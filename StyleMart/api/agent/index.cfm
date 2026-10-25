<cfsetting showdebugoutput="false">
<cfscript>
    function maskKey(key) {
        if (!len(trim(arguments.key))) return "(not set)";
        var k = trim(arguments.key);
        if (len(k) <= 8) return "(set, len " & len(k) & ")";
        return left(k, 7) & "…" & right(k, 4);
    }
    keyOk = false;
    keyMask = "(not set)";
    if (structKeyExists(application, "OPENAI_API_KEY") && len(trim(application.OPENAI_API_KEY))) {
        keyOk = true;
        keyMask = maskKey(application.OPENAI_API_KEY);
    }
</cfscript>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>StyleMart agent application</title>
    <style>
        body { font-family: system-ui, sans-serif; max-width: 40rem; margin: 2rem auto; line-height: 1.55; }
        .ok { color: #0a6; font-weight: 600; }
        .bad { color: #c00; font-weight: 600; }
        code { background: #f4f4f4; padding: 0.1em 0.35em; border-radius: 4px; }
    </style>
</head>
<body>
<h1>StyleMart agent application</h1>
<p>This folder is the <strong>Mira</strong> backend. The storefront talks to it over REST at <code>/rest/agent/...</code>, not by browsing here.</p>

<p><code>application.OPENAI_API_KEY</code>:
<cfif keyOk><span class="ok">SET</span> — <cfoutput>#encodeForHtml(keyMask)#</cfoutput>
<cfelse><span class="bad">NOT SET</span> — set System env <code>OPENAI_API_KEY</code>, restart ColdFusion, then reload this page.</cfif>
</p>

<h2>What to use instead</h2>
<ul>
    <li><a href="register.cfm">register.cfm</a> — register REST (run once per install)</li>
    <li><a href="../../setup/finish-workshop-setup.cfm">finish-workshop-setup.cfm</a> — full checklist</li>
    <li><a href="../../index.cfm">StyleMart storefront</a> — open chat, <strong>S1 Ref</strong>, send <code>Hi Mira!</code></li>
</ul>

<p><small>Do not use <code>?reload=1</code> unless your instructor asks — it re-runs RAG ingest and costs API usage.</small></p>
</body>
</html>
