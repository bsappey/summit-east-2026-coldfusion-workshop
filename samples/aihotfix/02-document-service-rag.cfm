<cfsetting requesttimeout="300"><cfinclude template="config.cfm"><cfscript>
ds = documentService();
docs = ds.load(docsDir);
segments = ds.split(docs, { chunkSize: 300, chunkOverlap: 50, splitterType: "recursive" });
store = VectorStore({ provider: "INMEMORY", embeddingModel: embeddingCfg });
ds.ingest(segments, store);

ragAgent = agent({
    chatModel: chatModel,
    retrievalAugmentor: {
        queryRouter: { type: "default", contentRetrievers: [ { vectorStore: store, maxResults: 3, minScore: 0.3 } ] },
        contentInjector: { promptTemplate: "Answer using only this context:" & chr(10) & "{{contents}}" & chr(10) & "Question: {{userMessage}}" }
    }
});
writeDump(var = { documents: arrayLen(docs), segments: arrayLen(segments), answer: ragAgent.chat("Are sale items returnable?") },
          label = "documentService() + agent({ retrievalAugmentor })");
</cfscript>
