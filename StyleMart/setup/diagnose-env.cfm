<cfsetting showdebugoutput="false">
<cfscript>
    sys = createObject("java", "java.lang.System");
    javaEnv = sys.getenv();
    cfEnv = {};
    try { cfEnv = server.system.environment; } catch (any e) { cfEnv = {}; }

    matches = [];
    for (var k in javaEnv) {
        if (findNoCase("OPENAI", k) || findNoCase("CF_TRAINING", k) || findNoCase("CF_ADMIN", k)) {
            arrayAppend(matches, k);
        }
    }
    arraySort(matches, "text");
</cfscript>
<pre>
Java getenv keys (OPENAI / CF_TRAINING / CF_ADMIN):
<cfloop array="#matches#" index="mk">
  #encodeForHtml(mk)# = len #len(trim(javaEnv[mk]))#
</cfloop>
<cfif arrayLen(matches) EQ 0>
  (none)
</cfif>

server.system.environment same keys:
<cfset cfMatches = []>
<cfloop collection="#cfEnv#" item="ck">
  <cfif findNoCase("OPENAI", ck) OR findNoCase("CF_TRAINING", ck)>
    <cfset arrayAppend(cfMatches, ck)>
  </cfif>
</cfloop>
<cfif arrayLen(cfMatches) EQ 0>(none)<cfelse>
<cfloop array="#cfMatches#" index="cm">
  #encodeForHtml(cm)# = len #len(trim(cfEnv[cm]))#
</cfloop>
</cfif>
</pre>
