component {
    this.name = "logistics_mcp";
    this.datasource = "prologics";
    this.sessionManagement = false;

    this.mappings["/commonutils"] = getDirectoryFromPath(getCurrentTemplatePath()) & "../../../commonutils";

    // prologics-mcp-server.cfm loads
    // CFSummit2026Workshop.externalservices.prologics.mcp.ShipmentTool.
    // Same mapping as the logistics Application.cfc so that name resolves
    // when this repo is the web root.
    this.mappings["/CFSummit2026Workshop"] = createObject("java", "java.io.File").init(
        getDirectoryFromPath(getCurrentTemplatePath()) & "../../.."
    ).getCanonicalPath();

    public boolean function onApplicationStart() {
        try {
            var configDir = getDirectoryFromPath(getCurrentTemplatePath()) & "../config/";
            setSQLiteDBPath(configDir & "db.properties");
            new commonutils.db.DatasourceUtil().register("prologics", configDir & "db.properties");
        } catch (any e) {}
        return true;
    }

    private void function setSQLiteDBPath(required string propsPath) {
        var content = fileRead(arguments.propsPath);
        if (find("prologics.file=", content)) {
            var correctPath = replace(getDirectoryFromPath(getCurrentTemplatePath()) & "../db/sqlite/prologics.db", "\", "/", "all");
            var updated = reReplace(content, "prologics\.file=.*", "prologics.file=" & correctPath);
            if (updated != content) fileWrite(arguments.propsPath, updated);
        }
    }
}
