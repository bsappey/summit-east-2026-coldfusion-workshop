<cfscript>
// Provider settings shared by the samples. Default: OpenAI, key from CF_TRAINING_OPENAI_API_KEY.
// Set CF_TRAINING_AI_PROVIDER=ollama to run against a local Ollama (llama3 + nomic-embed-text).
env = server.system.environment;
aiProvider = env.CF_TRAINING_AI_PROVIDER ?: "openai";
if (aiProvider == "ollama") {
    chatModel = ChatModel({ provider: "ollama", modelName: "llama3", baseUrl: "http://localhost:11434", temperature: 0.1 });
    embeddingCfg = { provider: "ollama", modelName: "nomic-embed-text", baseUrl: "http://localhost:11434" };
} else {
    apiKey = "";
    keyFile = getDirectoryFromPath(getCurrentTemplatePath()) & "../../StyleMart/config/openai-key.cfm";
    if (fileExists(keyFile)) {
        request.workshopOpenAiKey = "";
        include "#keyFile#";
        apiKey = trim(toString(request.workshopOpenAiKey ?: ""));
        if (apiKey == "paste-the-key-here") apiKey = "";
    }
    if (!len(apiKey)) apiKey = env.CF_TRAINING_OPENAI_API_KEY ?: "";
    if (!len(apiKey)) apiKey = env.OPENAI_API_KEY ?: "";
    if (!len(apiKey)) throw(type = "AiHotfixSamples.Config", message = "Replace paste-the-key-here in StyleMart/config/openai-key.cfm and refresh. Or set CF_TRAINING_OPENAI_API_KEY and restart ColdFusion.");
    chatModel = ChatModel({ provider: "openai", modelName: "gpt-4o-mini", apiKey: apiKey, temperature: 0.1, maxTokens: 300 });
    embeddingCfg = { provider: "openai", modelName: "text-embedding-3-small", apiKey: apiKey };
}
docsDir = getDirectoryFromPath(getCurrentTemplatePath()) & "docs/";
</cfscript>
