<cfsetting requesttimeout="300"><cfinclude template="config.cfm"><cfscript>
bot = simpleRAG(docsDir, chatModel, {
    vectorStore: VectorStore({ provider: "INMEMORY", embeddingModel: embeddingCfg }),
    chunkSize: 300, chunkOverlap: 50, splitterType: "recursive", maxResults: 3, minScore: 0.3
});
ingestResult = bot.ingest();
answer = bot.chat("Can the wool blazer be machine-washed?");
writeDump(var = { ingest: ingestResult, answer: answer }, label = "simpleRAG()");
</cfscript>
