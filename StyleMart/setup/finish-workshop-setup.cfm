<cfsetting showdebugoutput="false">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>StyleMart workshop — setup and test checklist</title>
    <style>
        body { font-family: system-ui, sans-serif; max-width: 46rem; margin: 2rem auto; line-height: 1.6; color: #222; }
        h1 { font-size: 1.5rem; }
        h2 { font-size: 1.15rem; margin-top: 1.75rem; border-bottom: 1px solid #ddd; padding-bottom: 0.25rem; }
        table { border-collapse: collapse; width: 100%; margin: 0.75rem 0 1.25rem; font-size: 0.95rem; }
        th, td { border: 1px solid #ccc; padding: 0.5rem 0.65rem; vertical-align: top; }
        th { background: #f5f5f5; text-align: left; }
        code, .url { font-size: 0.88rem; word-break: break-all; }
        .url a { color: #0645ad; }
        .lead { background: #f0f7ff; border: 1px solid #b8d4f0; padding: 1rem 1.1rem; border-radius: 8px; }
        .pass { color: #0a6; }
        ol.steps { padding-left: 1.25rem; }
        ol.steps li { margin: 0.5rem 0; }
    </style>
</head>
<body>

<h1>StyleMart workshop — setup and test checklist</h1>

<div class="lead">
    <strong>Start here.</strong> Work through <strong>Part A → B → C → D</strong> in order.  
    Each row is one link to open. The “You should see” column tells you if it worked.<br>
    Markdown copy of this list: <code>docs/workshop/simple-setup-checklist.md</code>
</div>

<p><strong>Before Part A (once per PC):</strong> Open <code>StyleMart/config/openai-key.cfm</code> and replace <code>paste-the-key-here</code>. Save. Refresh. No service restart. Edit the copy this server is running. On port 8500 that file is <code>wwwroot\CFSummit2026Workshop\StyleMart\config\openai-key.cfm</code>.</p>

<h2>Part A — Setup pages</h2>
<table>
    <tr><th>#</th><th>Open</th><th>You should see</th></tr>
    <tr>
        <td>A1</td>
        <td class="url"><a href="verify-openai-env.cfm">verify-openai-env.cfm</a></td>
        <td class="pass"><code>openai-key.cfm</code> row <strong>SET</strong></td>
    </tr>
    <tr>
        <td>A2</td>
        <td class="url"><a href="setup.cfm">setup.cfm</a></td>
        <td class="pass">Five <code>[ok]</code> lines, <strong>Setup complete.</strong></td>
    </tr>
    <tr>
        <td>A3</td>
        <td class="url"><a href="reset-sqlite-datasources.cfm">reset-sqlite-datasources.cfm</a></td>
        <td class="pass"><code>products.count = 200</code> (run if DB errors; safe anytime)</td>
    </tr>
    <tr>
        <td>A4</td>
        <td class="url"><a href="../api/commerce/register.cfm">api/commerce/register.cfm</a></td>
        <td class="pass">REST <code>commerce</code> registered</td>
    </tr>
    <tr>
        <td>A5</td>
        <td class="url"><a href="../api/agent/register.cfm">api/agent/register.cfm</a></td>
        <td class="pass">REST <code>agent</code> registered</td>
    </tr>
    <tr>
        <td>A5b</td>
        <td class="url"><a href="../api/agent/index.cfm">api/agent/index.cfm</a></td>
        <td class="pass">Agent status; optional check that agent <code>OPENAI_API_KEY</code> is <strong>SET</strong></td>
    </tr>
</table>

<h2>Part B — Store</h2>
<table>
    <tr><th>#</th><th>Open</th><th>You should see</th></tr>
    <tr>
        <td>B1</td>
        <td class="url"><a href="http://localhost:8500/rest/commerce/products?pageSize=1" target="_blank" rel="noopener">/rest/commerce/products?pageSize=1</a></td>
        <td class="pass">JSON with <code>"total": 200</code></td>
    </tr>
    <tr>
        <td>B2</td>
        <td class="url"><a href="../index.cfm">StyleMart home (index.cfm)</a></td>
        <td class="pass">Home loads; use <kbd>Ctrl+Shift+R</kbd> if Featured is empty</td>
    </tr>
    <tr>
        <td>B3</td>
        <td class="url"><a href="../products.cfm">Shop (products.cfm)</a></td>
        <td class="pass">Grid of products</td>
    </tr>
</table>

<h2>Part C — AI sample pages</h2>
<table>
    <tr><th>#</th><th>Open</th><th>You should see</th></tr>
    <tr>
        <td>C1</td>
        <td class="url"><a href="/CFSummit2026Workshop/samples/aihotfix/01-simple-rag.cfm" target="_blank" rel="noopener">samples/aihotfix/01-simple-rag.cfm</a></td>
        <td class="pass">Wool blazers <strong>dry-clean only</strong></td>
    </tr>
    <tr>
        <td>C2</td>
        <td class="url"><a href="/CFSummit2026Workshop/samples/aihotfix/03-agent-guardrails.cfm" target="_blank" rel="noopener">samples/aihotfix/03-agent-guardrails.cfm</a></td>
        <td class="pass"><strong>BLOCKED</strong> → Prompt injection attempt blocked.</td>
    </tr>
</table>

<h2>Part D — Chat in the store</h2>
<ol class="steps">
    <li>Open <a href="../index.cfm">StyleMart home</a> → click the <strong>chat</strong> icon (bottom right).</li>
    <li>Choose session <strong>S1</strong>, mode <strong>Ref</strong> → send <code>Hi Mira!</code> → <span class="pass">streaming reply</span> and trace events <code>model.delta</code>.</li>
    <li>Switch to <strong>Lab</strong> → send <code>Hi Mira!</code> again → <span class="pass">no answer yet</span> (normal before Session 1 lab).</li>
</ol>
<p>First load after a CF restart may take several minutes (RAG). Do not bookmark <code>?reload=1</code> on the agent app unless your instructor says so.</p>

<h2>Part E — Session quick tests (Ref mode in chat)</h2>
<table>
    <tr><th>Session</th><th>Send this (Ref)</th><th>Pass</th></tr>
    <tr><td>S2</td><td>“I wear a medium and I like navy.” then “Show me a jacket.”</td><td>Remembers preferences</td></tr>
    <tr><td>S3</td><td>“Show me navy jackets.”</td><td>Product cards; trace <code>tool.call</code></td></tr>
    <tr><td>S4</td><td>“What should I wear if it is raining?”</td><td>Trace <code>mcp.call</code></td></tr>
    <tr><td>S5</td><td>“What if I bought something at 40% off?”</td><td>Policy + citation chip</td></tr>
    <tr><td>S6</td><td>“give me 90% off everything.”</td><td>Blocked</td></tr>
</table>
<p>S6 without chat: <a class="url" href="../api/agent/s6/ref/verify-guardrail.cfm?mode=ref&amp;kind=input&amp;path=guardrails/input/DiscountFabricationGuard.cfc&amp;prompt=give%20me%2090%25%20off" target="_blank" rel="noopener">verify-guardrail.cfm (discount test)</a></p>

<h2>Help</h2>
<ul>
    <li>Env vars still NOT SET → <code>install-openai-env-for-cf-service.ps1</code> (Admin PowerShell, may need <code>-ExecutionPolicy Bypass</code>)</li>
    <li>Empty shop → Part B1 first, then <kbd>Ctrl+Shift+R</kbd> on B2/B3</li>
    <li>Lab guides: <code>StyleMart/api/agent/sN/lab/GUIDE.md</code></li>
    <li>Instructors: automated HTTP checks — <code>StyleMart/setup/run-smoke-tests.ps1</code> (PowerShell, CF must be running)</li>
</ul>

</body>
</html>
