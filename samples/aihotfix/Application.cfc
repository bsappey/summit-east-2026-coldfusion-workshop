component {
    this.name = "cfAiHotfixSamples";
    // Lets the guardrail CFCs be referenced as "aihotfix.guardrails.InputGuard"
    // no matter where this folder sits under the web root.
    this.mappings["/aihotfix"] = getDirectoryFromPath(getCurrentTemplatePath());
}
