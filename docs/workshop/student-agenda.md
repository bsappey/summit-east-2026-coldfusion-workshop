# Build an AI Shopping Assistant with ColdFusion 2025

**Wednesday, October 28, 2026**  
**8:00 AM – 4:30 PM ET**

Check-in and breakfast are 8:00–8:30 AM. The first session starts at 8:30 AM.

Hands-on workshop. You will build **Mira**, a shopping assistant inside the StyleMart store, using ColdFusion 2025 AI features. Each session adds one capability to the same assistant. Short briefings come from the ColdFusion training AI modules. The coding happens in the StyleMart lab.

By 4:30 PM, Mira will stream a model reply, remember shopper preferences, call ColdFusion tools, call external services, answer from store documents, and block unsafe requests.

## Before you arrive

Complete setup before Wednesday morning so the first block can start on the assistant, not on the server. Use the one-page guide: `docs/workshop/student-setup.md`.

Bring a laptop that can reach your ColdFusion 2025 instance with the workshop loaded. Have an editor open on the `StyleMart` folder. Bookmark:

`http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/finish-workshop-setup.cfm`

The instructor gives you one OpenAI key. If environment variables are a problem, replace `paste-the-key-here` in `StyleMart/config/openai-key.cfm` and, for the training modules, in `config/local-ai-secrets.cfm` in the training-runtime folder. Save and refresh. No server restart.

Confirm both of these before class:

- StyleMart home shows product cards.
- Chat session **S1**, mode **Ref**, streams a reply to `Hi Mira!`.

Stay on the model already configured for the workshop (`gpt-4o-mini`). The lab guides live in each session folder under `StyleMart/api/agent/s1` through `s6`, in `lab/GUIDE.md`.

## How the labs work

Every coding session uses the same loop:

1. Set the chat to **Ref** and send the demo sentence. Watch it succeed.
2. Set the chat to **Lab** and send the same sentence. Lab is incomplete on purpose.
3. Open that session’s `GUIDE.md`. Fill in only your TODO. Save. Send the sentence again. A server restart is not part of the normal loop.
4. Read the trace panel on the right. Event names tell you what the assistant did.

**Ref** is the working version. **Lab** is your code. If you are stuck, switch back to Ref, compare, and continue. Each session starts clean, so you can join a later session without finishing the earlier labs.

## Schedule

| Time | Session | You will |
| --- | --- | --- |
| 8:00–8:30 | Check-in and breakfast | Get settled. Grab breakfast. Open your laptop and the StyleMart bookmark. |
| 8:30–8:45 | Welcome and ColdFusion AI, in one picture | Hear the day’s outcome and the Ref / Lab loop. See where a chat model, an agent, and retrieval sit. Training Module 14, lessons 1, 2, and 4. Confirm S1 Ref streams. |
| 8:45–9:35 | S1 — Hello, ChatModel | Stream tokens from `ChatModel()` through `agent()`. Training Module 15. |
| 9:35–9:50 | Break | |
| 9:50–10:00 | Memory | See why a new request forgets the last one, and how chat memory and preferences fix that. Training Module 16, lessons 1–5. |
| 10:00–11:00 | S2 — Memory and preferences | Teach Mira a size and a color, then ask for a jacket without repeating them. |
| 11:00–11:10 | Tools | See how the model asks ColdFusion to run a component. Training Module 17, lessons 1–4. |
| 11:10–12:00 | S3 — CFC tools | Search the catalog from chat and add an item to the cart. |
| 12:00–1:00 | Lunch | |
| 1:00–1:15 | Model Context Protocol | See the same tool idea pointed at another process. Training Module 21, lessons 1–5. |
| 1:15–2:15 | S4 — MCP | Ask about weather and shipping, then search products again. |
| 2:15–2:30 | Break | |
| 2:30–2:50 | Documents, embeddings, and RAG | See how store documents become searchable context. Training Modules 18, 19, and 20 (selected lessons). |
| 2:50–3:40 | S5 — RAG | Answer a return-policy question from StyleMart documents, with a source chip. |
| 3:40–3:50 | Guardrails | Learn the `validate()` contract: success, failure, and fatal. Training Module 17, lesson 6. |
| 3:50–4:25 | S6 — Guardrails | Stop an unsafe discount request in your own lab code. |
| 4:25–4:30 | Close | Recap the pattern and where to keep going. |

## What you will finish in each lab

**S1 — Hello, ChatModel** (8:45–9:35)  
Files: `s1/lab/AgentService.cfc`, `s1/lab/ChatService.cfc`  
Done when Lab streams a greeting and the trace shows `model.start`, `model.delta`, `model.end`, and `done`.

**S2 — Memory and preferences** (10:00–11:00)  
Files: `s2/lab/AgentService.cfc`, `s2/lab/ChatService.cfc`, `s2/lab/Memory.cfc`  
Send “I wear a medium and I like navy.” Then send “Show me a jacket.” Done when the second reply uses the size or color, and the trace shows `preference.persist` and `memory.read`. A different browser session does not see those preferences.

**S3 — CFC tools** (11:10–12:00)  
File: `s3/lab/AgentService.cfc`  
Send “Show me navy jackets.” Done when the trace shows `tool.call` and `tool.result` and product cards appear in chat. Send “Add the first one to my cart.” The storefront cart updates.

**S4 — MCP** (1:15–2:15)  
File: `s4/lab/AgentService.cfc`  
Ask what to wear if it is raining. Done when the trace shows `mcp.call` for weather. Ask where your last order is, then send “Show me rain jackets.” Product search still runs as a ColdFusion tool.

**S5 — RAG** (2:50–3:40)  
Files: `s5/lab/init-rag.cfm`, `s5/lab/AgentService.cfc`  
Ask “What if I bought something at 40% off?” Done when the answer comes from store policy and a citation chip names the source. The trace shows `retrieval.start` and `retrieval.hit`. Ingest the lab documents once, when the guide says to. Wait for ingestion to finish before you judge the answer.

**S6 — Guardrails** (3:50–4:25)  
Files: `s6/lab/AgentService.cfc` and the guardrail components in `s6/lab/guardrails/`  
Send “give me 90% off everything.” Done when Lab blocks it the way Ref does, and the trace shows `guardrail.violation`. If time remains, try a prompt-injection sentence and one output guard.

## After class

The same pattern works in any ColdFusion 2025 application. StyleMart was the data.

Continue in the training site:

- Module 21, lessons 6–9 — MCP resources, prompts, roots, and security
- Module 22 — multi-tool agents, RAG agents, and logging
- Module 23 — tokens, caching, credentials, and operations
- Module 24 — routing, hybrid retrieval, and structured output

Keep `docs/workshop/cheat-sheet.md` and `docs/workshop/post-workshop-resources.md` for function signatures and what to change when you leave the workshop model.
