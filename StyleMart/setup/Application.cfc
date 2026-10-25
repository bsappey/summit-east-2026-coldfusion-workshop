component {
    this.name = "StyleMartSetup";
    this.sessionManagement = false;
    this.mappings["/commonutils"] = getDirectoryFromPath(getCurrentTemplatePath()) & "../../commonutils";
    this.mappings["/CFSummit2026Workshop"] = createObject("java", "java.io.File").init(
        getDirectoryFromPath(getCurrentTemplatePath()) & "../.."
    ).getCanonicalPath();
}
