component {
    this.name = "agent";
    this.datasource = "stylemart";
    this.sessionManagement = true;
    this.sessionTimeout = createTimespan(0, 2, 0, 0);

    // CFC dot-path resolution.
    //
    // S1 ChatService.cfc passes "api.agent.s1.ref.Streamer" to agent({STREAMINGHANDLER:...}).
    // CF resolves dot-paths against the web root by default. When CF's web root is
    // not the StyleMart project root (e.g. attendees running CF with its default
    // wwwroot), api.agent.s1.ref.Streamer would not be found.
    //
    // Mapping "/api" to the directory two levels up from this Application.cfc
    // (which IS the StyleMart api/ directory) lets dot-paths beginning with "api."
    // always resolve correctly regardless of where CF's web root is.
    this.mappings = {
        "/api": getDirectoryFromPath( getCurrentTemplatePath() ) & ".."
    };

    // CommandBox blocks outbound calls to the local MCP servers unless they are listed.
    // The installed ColdFusion server already allows its own port.
    this.security.outboundNetwork = {
        allowList: [
            "http://localhost:8080",
            "http://127.0.0.1:8080",
            "http://localhost:8500",
            "http://127.0.0.1:8500"
        ]
    };

    public boolean function onApplicationStart() {
        // Clear per-session agent caches (each workshop session has its own
        // bucket so a session-id collision in one session doesn't leak into
        // another). Plural form: application.s{N}Agents = { sessionId: bundle }.
        structDelete(application, "s1Agents");
        structDelete(application, "s2Agents");
        structDelete(application, "s3Agents");
        structDelete(application, "s4Agents");
        structDelete(application, "s5Agents");
        structDelete(application, "s6Agents");
        structDelete(application, "s4McpClients");
        structDelete(application, "s5McpClients");
        structDelete(application, "s6McpClients");
        structDelete(application, "s6WeatherMcpClient");
        // Stale legacy keys from earlier (global-agent) versions:
        structDelete(application, "s3Agent");
        structDelete(application, "s4Agent");
        structDelete(application, "s5Agent");
        structDelete(application, "agents");

        application.OPENAI_API_KEY = readWorkshopOpenAiKey();
        if (!len(application.OPENAI_API_KEY)) {
            writeLog(text="OpenAI key is not set. Replace paste-the-key-here in StyleMart/config/openai-key.cfm or set OPENAI_API_KEY.", type="warning", file="agent");
        }

        server.stylemart.streams = {};
        server.stylemart.guardrailTrace = new api.agent.s6.GuardrailTrace();
        application.services = {
            search:  new api.commerce.SearchService(),
            product: new api.commerce.ProductService(),
            cart:    new api.commerce.CartService(),
            cartMe:  new api.commerce.CartMeService(),
            order:   new api.commerce.OrderService(),
            user:    new api.commerce.UserService()
        };
        server.stylemart.services = application.services;

        restInitApplication(getDirectoryFromPath(getCurrentTemplatePath()), "agent");

        // RAG bootstrap — ref and lab each get their own vector stores so
        // attendees editing lab-side ingestion don't corrupt the ref demo.
        // Both runs are non-fatal: a missing JAR or vector-store provider
        // shouldn't take down the whole REST app.
        server.stylemart.ragReadyRef = false;
        server.stylemart.ragReadyLab = false;
        try { include "s5/ref/init-rag.cfm"; }
        catch (any e) { writeLog(text="[S5-RAG] ref bootstrap failed (non-fatal): #e.message#", file="rag"); }
        try { include "s5/lab/init-rag.cfm"; }
        catch (any e) { writeLog(text="[S5-RAG] lab bootstrap failed (non-fatal): #e.message#", file="rag"); }
        try { include "s6/ref/init-rag.cfm"; }
        catch (any e) { writeLog(text="[S6-RAG] ref bootstrap failed (non-fatal): #e.message#", file="rag"); }
        try { include "s6/lab/init-rag.cfm"; }
        catch (any e) { writeLog(text="[S6-RAG] lab bootstrap failed (non-fatal): #e.message#", file="rag"); }

        return true;
    }
    public boolean function onRequestStart(required string targetPage) {
        var freshKey = readWorkshopOpenAiKey();
        if (len(freshKey) && (!structKeyExists(application, "OPENAI_API_KEY") || application.OPENAI_API_KEY != freshKey)) {
            application.OPENAI_API_KEY = freshKey;
            structDelete(application, "s1Agents");
            structDelete(application, "s2Agents");
            structDelete(application, "s3Agents");
            structDelete(application, "s4Agents");
            structDelete(application, "s5Agents");
            structDelete(application, "s6Agents");
        }
        if (structKeyExists(url, "reload")) {
            onApplicationStart();
            try { restDeleteApplication(getDirectoryFromPath(getCurrentTemplatePath())); } catch (any e) {}
            try { restInitApplication(getDirectoryFromPath(getCurrentTemplatePath()), "agent"); } catch (any e) {}
        }
        return true;
    }

    // Day-of file wins when it contains a real key. Otherwise the OPENAI_API_KEY environment variable.
    private string function readWorkshopOpenAiKey() {
        var key = "";
        try {
            var raw = server.system.environment["OPENAI_API_KEY"];
            if (!isNull(raw)) key = trim(toString(raw));
        } catch (any ignoreEnv) {
            key = "";
        }
        var keyFile = getDirectoryFromPath(getCurrentTemplatePath()) & "../../config/openai-key.cfm";
        if (fileExists(keyFile)) {
            request.workshopOpenAiKey = "";
            include "../../config/openai-key.cfm";
            var fileKey = trim(toString(request.workshopOpenAiKey ?: ""));
            if (len(fileKey) && fileKey != "paste-the-key-here") key = fileKey;
        }
        return key;
    }
}
