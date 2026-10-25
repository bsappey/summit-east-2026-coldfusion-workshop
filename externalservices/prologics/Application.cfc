component {
    this.name = "prologics-logistics";
    this.datasource = "prologics";
    this.sessionManagement = false;

    this.mappings["/commonutils"] = getDirectoryFromPath(getCurrentTemplatePath()) & "../../commonutils";

    // ShipmentTool.cfc and the MCP server use dotted names that start with
    // CFSummit2026Workshop. That matches wwwroot/CFSummit2026Workshop.
    // CommandBox uses this repo as the web root, so that folder does not exist
    // and REST registration fails while compiling mcp/ShipmentTool.cfc.
    // This mapping is applied when the application starts.
    this.mappings["/CFSummit2026Workshop"] = createObject("java", "java.io.File").init(
        getDirectoryFromPath(getCurrentTemplatePath()) & "../.."
    ).getCanonicalPath();

    public boolean function onApplicationStart() {
        try {
            var configDir = getDirectoryFromPath(getCurrentTemplatePath()) & "config/";
            setSQLiteDBPath(configDir & "db.properties");
            new commonutils.db.DatasourceUtil().register("prologics", configDir & "db.properties");
        } catch (any e) {
            cflog(text="Error in onRequestStart: #e.message#", type="error", file="prologics-debug");
        }
        restInitApplication(expandPath("."), "logistics");
        return true;
    }

    private void function setSQLiteDBPath(required string propsPath) {
        var content = fileRead(arguments.propsPath);
        if (find("prologics.file=", content)) {
            var correctPath = replace(getDirectoryFromPath(getCurrentTemplatePath()) & "db/sqlite/prologics.db", "\", "/", "all");
            var updated = reReplace(content, "prologics\.file=.*", "prologics.file=" & correctPath);
            if (updated != content) fileWrite(arguments.propsPath, updated);
        }
    }

    public boolean function onRequestStart(required string targetPage) {
        if (structKeyExists(url, "reload")) {
            restInitApplication(expandPath("."), "logistics");
        }
        return true;
    }
}
