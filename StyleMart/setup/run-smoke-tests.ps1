# Workshop smoke tests — run from repo or copy to setup folder
$ErrorActionPreference = "Continue"
$base = "http://localhost:8500"
$ws = "$base/CFSummit2026Workshop"

function Invoke-SmokeTest {
    param(
        [string]$Name,
        [string]$Url,
        [int]$ExpectCode = 200,
        [string]$Pattern = "",
        [string]$Method = "GET",
        [string]$Body = ""
    )
    $tmp = [System.IO.Path]::GetTempFileName()
    $codeFile = "$tmp.code"
    $args = @("-s", "-o", $tmp, "-w", "%{http_code}", "-X", $Method)
    if ($Body) { $args += @("-H", "Content-Type: application/json", "-d", $Body) }
    $args += $Url
    & curl.exe @args 2>$null | Set-Content -Path $codeFile -NoNewline
    $code = 0
    if (Test-Path $codeFile) { $code = [int](Get-Content $codeFile -Raw) }
    $html = ""
    if (Test-Path $tmp) { $html = Get-Content $tmp -Raw -ErrorAction SilentlyContinue }
    Remove-Item $tmp, $codeFile -ErrorAction SilentlyContinue

    $ok = ($code -eq $ExpectCode)
    $detail = ""
    if ($ok -and $Pattern) {
        if ($html -notmatch $Pattern) {
            $ok = $false
            $detail = "pattern missing: $Pattern"
        }
    }
    if ($html -match "Error Occurred While Processing Request|Invalid CFML") {
        $ok = $false
        $detail = "CF error page"
    }
    [PSCustomObject]@{ Name = $Name; Code = $code; Ok = $ok; Detail = $detail }
}

$tests = @(
    @{ Name = "A1 verify-openai-env"; Url = "$ws/StyleMart/setup/verify-openai-env.cfm"; Pattern = "OPENAI_API_KEY" },
    @{ Name = "A2 setup.cfm"; Url = "$ws/StyleMart/setup/setup.cfm"; Pattern = "Setup complete" },
    @{ Name = "A3 reset-sqlite"; Url = "$ws/StyleMart/setup/reset-sqlite-datasources.cfm"; Pattern = "products.count" },
    @{ Name = "A4 commerce register"; Url = "$ws/StyleMart/api/commerce/register.cfm"; Pattern = "commerce" },
    @{ Name = "A5 agent register"; Url = "$ws/StyleMart/api/agent/register.cfm"; Pattern = "agent" },
    @{ Name = "A5b agent index"; Url = "$ws/StyleMart/api/agent/index.cfm"; Pattern = "agent" },
    @{ Name = "A5c agent folder"; Url = "$ws/StyleMart/api/agent/" },
    @{ Name = "B1 REST products"; Url = "$base/rest/commerce/products?pageSize=1"; Pattern = '"total"' },
    @{ Name = "B1b REST session"; Url = "$base/rest/commerce/auth/session"; Pattern = "authenticated" },
    @{ Name = "B2 storefront"; Url = "$ws/StyleMart/index.cfm"; Pattern = "StyleMart" },
    @{ Name = "B3 products"; Url = "$ws/StyleMart/products.cfm"; Pattern = "data-plp-grid" },
    @{ Name = "B4 api.js"; Url = "$ws/StyleMart/assets/js/api.js"; Pattern = "/rest/commerce" },
    @{ Name = "C1 sample 01"; Url = "$ws/samples/aihotfix/01-simple-rag.cfm" },
    @{ Name = "C2 sample 03"; Url = "$ws/samples/aihotfix/03-agent-guardrails.cfm" },
    @{ Name = "D1 finish page"; Url = "$ws/StyleMart/setup/finish-workshop-setup.cfm"; Pattern = "Part A" },
    @{ Name = "D2 checklist md"; Url = "$ws/docs/workshop/simple-setup-checklist.md"; Pattern = "Part A" },
    @{
        Name = "E1 agent session POST"
        Url = "$base/rest/agent/s1/ref/chat/sessions"
        Method = "POST"
        Body = "{}"
        Pattern = "sessionId"
    },
    @{ Name = "E2 verify-guardrail"; Url = "$ws/StyleMart/api/agent/s6/ref/verify-guardrail.cfm?mode=ref&kind=input&path=guardrails/input/DiscountFabricationGuard.cfc&prompt=give%20me%2090%25%20off" }
)

$results = foreach ($t in $tests) {
    $m = if ($t.Method) { $t.Method } else { "GET" }
    $b = if ($t.Body) { $t.Body } else { "" }
    $p = if ($t.Pattern) { $t.Pattern } else { "" }
    Invoke-SmokeTest -Name $t.Name -Url $t.Url -Pattern $p -Method $m -Body $b
}

$results | ForEach-Object {
    $s = if ($_.Ok) { "PASS" } else { "FAIL" }
    "$s | $($_.Name) | HTTP $($_.Code) $($_.Detail)"
}
$fail = @($results | Where-Object { -not $_.Ok }).Count
Write-Host ""
# Optional: S1 Ref chat SSE (requires valid OPENAI_API_KEY)
if ($env:SMOKE_CHAT -eq "1") {
    $sessJson = curl.exe -s -X POST -H "Content-Type: application/json" -d "{}" "$base/rest/agent/s1/ref/chat/sessions"
    if ($sessJson -match '"sessionId"\s*:\s*"([^"]+)"') {
        $sid = $Matches[1]
        $bodyPath = Join-Path $env:TEMP "stylemart-smoke-chat.json"
        [System.IO.File]::WriteAllText($bodyPath, '{"userText":"Hi Mira!","uiContext":{}}', (New-Object System.Text.UTF8Encoding $false))
        $chatOut = curl.exe -s -m 120 -X POST -H "Content-Type: application/json" --data-binary "@$bodyPath" "$base/rest/agent/s1/ref/chat/sessions/$sid/messages"
        Remove-Item $bodyPath -ErrorAction SilentlyContinue
        $chatOk = ($chatOut -match "model\.")
        $s = if ($chatOk) { "PASS" } else { "FAIL" }
        Write-Host "$s | E3 S1 chat SSE | $($chatOut.Length) bytes"
        if (-not $chatOk) { $fail++ }
    } else {
        Write-Host "FAIL | E3 S1 chat SSE | no sessionId"
        $fail++
    }
}

Write-Host ""
Write-Host "Total: $($results.Count) tests, $fail failed"
exit $fail
