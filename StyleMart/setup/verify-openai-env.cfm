<cfsetting showdebugoutput="false">
<cfscript>
    function maskKey(key) {
        if (!len(trim(arguments.key))) return "(not set)";
        var k = trim(arguments.key);
        if (len(k) <= 8) return "(set, len " & len(k) & ")";
        return left(k, 7) & "…" & right(k, 4) & " (len " & len(k) & ")";
    }
</cfscript>
<cfset javaSys = createObject("java", "java.lang.System")>
<cfset openAi = "">
<cfset training = "">
<cftry>
    <cfset openAi = javaSys.getenv("OPENAI_API_KEY")>
    <cfif isNull(openAi)><cfset openAi = ""></cfif>
    <cfcatch><cfset openAi = ""></cfcatch>
</cftry>
<cftry>
    <cfset training = javaSys.getenv("CF_TRAINING_OPENAI_API_KEY")>
    <cfif isNull(training)><cfset training = ""></cfif>
    <cfcatch><cfset training = ""></cfcatch>
</cftry>
<cfif !len(trim(openAi))>
    <cftry>
        <cfset openAi = server.system.environment["OPENAI_API_KEY"]>
        <cfcatch><cfset openAi = ""></cfcatch>
    </cftry>
</cfif>
<cfif !len(trim(training))>
    <cftry>
        <cfset training = server.system.environment["CF_TRAINING_OPENAI_API_KEY"]>
        <cfcatch><cfset training = ""></cfcatch>
    </cftry>
</cfif>
<cfset fileKey = "">
<cfset keyFile = getDirectoryFromPath(getCurrentTemplatePath()) & "../config/openai-key.cfm">
<cfif fileExists(keyFile)>
    <cftry>
        <cfset request.workshopOpenAiKey = "">
        <cfinclude template="../config/openai-key.cfm">
        <cfset fileKey = trim(toString(request.workshopOpenAiKey))>
        <cfif fileKey eq "paste-the-key-here"><cfset fileKey = ""></cfif>
        <cfcatch><cfset fileKey = ""></cfcatch>
    </cftry>
</cfif>
<cfset agentAppKey = "">
<cftry>
    <cfif structKeyExists(application, "OPENAI_API_KEY")>
        <cfset agentAppKey = application.OPENAI_API_KEY>
    </cfif>
    <cfcatch><cfset agentAppKey = ""></cfcatch>
</cftry>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Verify OpenAI environment</title>
    <style>
        body { font-family: system-ui, sans-serif; max-width: 44rem; margin: 2rem auto; line-height: 1.5; }
        table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
        th, td { border: 1px solid #ccc; padding: 0.5rem 0.75rem; text-align: left; }
        .ok { color: #0a6; font-weight: 600; }
        .bad { color: #c00; font-weight: 600; }
        code { background: #f4f4f4; padding: 0.1em 0.35em; border-radius: 4px; }
        .callout { background: #fff8e6; border: 1px solid #e6c200; padding: 0.75rem 1rem; border-radius: 6px; }
    </style>
</head>
<body>
<h1>OpenAI key</h1>
<p>The day-of key belongs in <code>StyleMart/config/openai-key.cfm</code>. Environment variables are optional. Values are masked.</p>

<div class="callout">
    <strong>Day of class:</strong> open <code>StyleMart/config/openai-key.cfm</code>, replace <code>paste-the-key-here</code>, save, and refresh. Use the copy the server is running (port 8500 is under <code>wwwroot\CFSummit2026Workshop</code>).
    <strong>If the file row is SET, you are done.</strong> The environment rows can stay NOT SET.
    <br><br>
    <strong>If you used Windows System variables instead</strong> and those rows show NOT SET:
    <ol>
        <li>Confirm <code>OPENAI_API_KEY</code> is not blank (StyleMart needs this name — not only <code>CF_TRAINING_OPENAI_API_KEY</code>).</li>
        <li><strong>Restart</strong> <em>ColdFusion 2025 Application Server</em> as Administrator (Stop, wait 10s, Start). A browser refresh is not enough.</li>
        <li>If still NOT SET, run the setup script as Administrator (execution policy may require <code>Bypass</code>):<br>
            <code>powershell -ExecutionPolicy Bypass -File install-openai-env-for-cf-service.ps1 -ApiKey "your-key"</code><br>
            then restart the CF Application Server service.</li>
    </ol>
</div>

<table>
    <thead>
        <tr><th>Variable</th><th>Status</th><th>Masked value</th><th>Used by</th></tr>
    </thead>
    <tbody>
        <tr>
            <td><code>StyleMart/config/openai-key.cfm</code></td>
            <td class="<cfif len(trim(fileKey))>ok<cfelse>bad</cfif>"><cfif len(trim(fileKey))>SET<cfelse>NOT SET</cfif></td>
            <td><cfoutput>#encodeForHtml(maskKey(fileKey))#</cfoutput></td>
            <td>StyleMart chat and <code>samples/aihotfix/</code>. This is the day-of paste.</td>
        </tr>
        <tr>
            <td><code>OPENAI_API_KEY</code></td>
            <td class="<cfif len(trim(openAi))>ok<cfelse>bad</cfif>"><cfif len(trim(openAi))>SET<cfelse>NOT SET</cfif></td>
            <td><cfoutput>#encodeForHtml(maskKey(openAi))#</cfoutput></td>
            <td>StyleMart chat S1–S6, RAG, guards</td>
        </tr>
        <tr>
            <td><code>CF_TRAINING_OPENAI_API_KEY</code></td>
            <td class="<cfif len(trim(training))>ok<cfelse>bad</cfif>"><cfif len(trim(training))>SET<cfelse>NOT SET</cfif></td>
            <td><cfoutput>#encodeForHtml(maskKey(training))#</cfoutput></td>
            <td><code>samples/aihotfix/</code></td>
        </tr>
    </tbody>
</table>

<h2>Agent application scope (optional — often shows empty here)</h2>
<p>This page runs in the <strong>storefront</strong> app. Mira stores the key in a <strong>separate</strong> app under <code>api/agent/</code>, so <code>application.OPENAI_API_KEY</code> is usually <strong>empty on this screen even when everything is fine</strong>.</p>
<p><strong>What matters:</strong> the file row is <span class="ok">SET</span>, or both environment rows are <span class="ok">SET</span>. Then prove chat works:</p>
<ol>
    <li>Open <a href="../index.cfm">StyleMart</a> → chat → <strong>S1</strong> + <strong>Ref</strong> → send <code>Hi Mira!</code></li>
    <li>Or open <a href="../api/agent/index.cfm">api/agent/index.cfm</a> — should show agent <code>application.OPENAI_API_KEY</code> <strong>SET</strong>.</li>
</ol>
<p>Status on this page only:
<cfif len(trim(agentAppKey))><span class="ok">SET</span> in storefront <code>application</code> scope — <cfoutput>#encodeForHtml(maskKey(agentAppKey))#</cfoutput> (unusual; ignore if chat already works).
<cfelse><span class="ok">empty here — OK</span> if the file row is SET and S1 Ref chat streams.</cfif>
</p>

<p><a href="finish-workshop-setup.cfm">← Finish setup checklist</a></p>
</body>
</html>
