<cfsetting showdebugoutput="false">
<cfoutput>
<pre>
<cftry>
<cfscript>
    base = createObject("java", "java.io.File").init(
        getDirectoryFromPath(getCurrentTemplatePath()) & "../../"
    ).getCanonicalPath();
    base = replace(base, "\", "/", "all") & "/";

    stylemartProps = base & "StyleMart/config/db.properties";
    prologicsProps = base & "externalservices/prologics/config/db.properties";

    function fixDbPath(required string propsPath, required string key, required string correctPath) {
        var content = fileRead(arguments.propsPath);
        var pattern = arguments.key & "=.*";
        var replacement = arguments.key & "=" & arguments.correctPath;
        var updated = reReplace(content, pattern, replacement);
        if (updated != content) {
            fileWrite(arguments.propsPath, updated);
            writeOutput("[ok] updated " & arguments.key & " in " & arguments.propsPath & chr(10));
        }
    }

    stylemartDbPath = base & "StyleMart/db/sqlite/stylemart.db";
    prologicsDbPath = base & "externalservices/prologics/db/sqlite/prologics.db";
    fixDbPath(stylemartProps, "stylemart.file", stylemartDbPath);
    fixDbPath(prologicsProps, "prologics.file", prologicsDbPath);

    props = getPropertyFile(stylemartProps);
    adminPassword = props["admin.password"];
    try {
        adminPassword = server.system.environment["CF_ADMIN_PASSWORD"];
    } catch (any e) {}

    createObject("component", "CFIDE.adminapi.administrator").login(adminPassword);
    ds = createObject("component", "CFIDE.adminapi.datasource");
    util = new commonutils.db.DatasourceUtil();

    if (structKeyExists(ds.getDatasources(), "stylemart")) {
        ds.deleteDatasource("stylemart");
        writeOutput("[ok] removed datasource 'stylemart'" & chr(10));
    }
    util.register("stylemart", stylemartProps);
    writeOutput("[ok] registered 'stylemart'" & chr(10));

    if (structKeyExists(ds.getDatasources(), "prologics")) {
        ds.deleteDatasource("prologics");
        writeOutput("[ok] removed datasource 'prologics'" & chr(10));
    }
    util.register("prologics", prologicsProps);
    writeOutput("[ok] registered 'prologics'" & chr(10));

    q = queryExecute("SELECT COUNT(*) AS n FROM products", {}, { datasource: "stylemart" });
    writeOutput("[ok] stylemart products.count = " & q.n[1] & chr(10));
    writeOutput("Done." & chr(10));
</cfscript>
<cfcatch type="any">
[fail] #cfcatch.message#
#cfcatch.detail#
<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
</pre>
</cfoutput>
