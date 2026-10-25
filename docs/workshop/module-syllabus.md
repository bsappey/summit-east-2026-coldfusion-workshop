# Module syllabus — StyleMart AI workshop (S0–S6)

This document is the **per-module outline**: timing, learning goals, files, and how to **prove the OpenAI key** for each part of the course.

| Audience | Use this |
| --- | --- |
| Everyone (first) | **`finish-workshop-setup.cfm`** or **`simple-setup-checklist.md`** — click every link A→E in order |
| Students | `student-setup.md` (keys + troubleshooting), `S0-environment-setup.md`, then each **`GUIDE.md`** under `sN/lab/` |
| Instructors | `instructor-syllabus.md` (Wednesday 8:00–4:30 clock, training-runtime pages, and workshop files), this file (module map + key verification), session **`INSTRUCTOR.md`** where present |

The times in this file (0:00–6:30) are the old relative lab clock. On October 28, follow the clock in `instructor-syllabus.md`. It matches `student-agenda.md`.

**Lab rule for the whole day:** stay on **`gpt-4o-mini`**. If environment variables fail, replace `paste-the-key-here` in `StyleMart/config/openai-key.cfm`. That file covers StyleMart and `samples/aihotfix/`. The training runtime uses `config/local-ai-secrets.cfm`. Do not paste the key into `Application.cfc`. Environment variables still work if they are already set.

---

## OpenAI key — one key, two variable names

Set **both** Windows **System** variables to the **same** Adobe workshop key, then **restart** the ColdFusion service.

| Variable | Required for |
| --- | --- |
| `OPENAI_API_KEY` | Entire StyleMart agent app: chat **S1–S6** (Lab + Ref), RAG ingest (S5/S6 bootstrap), S2 preference extraction, S6 output guards that call the model, scratchpads, stretch generators |
| `CF_TRAINING_OPENAI_API_KEY` | Hotfix sample pages under `samples/aihotfix/` (Hour 0 proof, before StyleMart) |

Runtime wiring:

- `StyleMart/api/agent/Application.cfc` copies `OPENAI_API_KEY` → `application.OPENAI_API_KEY` on application start.
- Session `AgentService.cfc` files use `APIKEY: application.OPENAI_API_KEY` in `ChatModel()`.
- `s5`/`s6` `init-rag.cfm` uses `application.OPENAI_API_KEY` for embeddings (`text-embedding-3-small`).
- Sample pages read `CF_TRAINING_OPENAI_API_KEY` (not StyleMart).

**Quick env check (no key printed):**

```text
http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/verify-openai-env.cfm
```

**Full section-by-section proof:** use the table in [Verify OpenAI for every section](#verify-openai-for-every-section) below.

---

## Document map (what already exists)

| Module | Student lab guide | Instructor extras | In instructor-syllabus |
| --- | --- | --- | --- |
| **S0** Environment | `S0-environment-setup.md` | — | Setup block 0:00–0:30 |
| **Hotfix samples** | — | — | Steps 4, 9 |
| **S1** ChatModel | `s1/lab/GUIDE.md` | — | Session 1 section |
| **S2** Memory | `s2/lab/GUIDE.md` | `s2/lab/INSTRUCTOR.md` | Session 2 section |
| **S3** CFC tools | `s3/lab/GUIDE.md` | — | Session 3 section |
| **S4** MCP | `s4/lab/GUIDE.md` | — | Session 4 section |
| **S5** RAG | `s5/lab/GUIDE.md` | `s5/lab/INSTRUCTOR.md` | Session 5 section |
| **S6** Guardrails | `s6/lab/GUIDE.md` | `s6/lab/INSTRUCTOR.md`, stretch guides | Session 6 section |

You do **not** need separate syllabus files per session unless you want printed PDFs — **`GUIDE.md`** is the detailed student runbook; **`instructor-syllabus.md`** is the spoken script and rescue notes. This file ties them together and lists verification steps.

---

## S0 — Environment validation (~30 min with setup)

**Goal:** Storefront, REST, and chat infrastructure work; Lab mode is intentionally empty.

| Topic | Detail |
| --- | --- |
| Time | 0:00–0:30 with instructor-led hotfix + keys; or 5 min checks on a pre-imaged AMI |
| Native Windows | Run `setup.cfm` + `finish-workshop-setup.cfm`; hard-refresh storefront (`Ctrl+Shift+R`) |
| AMI | Follow `S0-environment-setup.md` checks 1–6 |
| Keys | Both env vars set before Ref chat test |
| Files | None (configuration only) |

**Pass:** See `S0-environment-setup.md` checks 1–6, plus `verify-openai-env.cfm` shows both variables **set**.

---

## Hotfix samples — prove CF AI + key (`CF_TRAINING_OPENAI_API_KEY`)

**Goal:** Confirm patched ColdFusion can call OpenAI before StyleMart.

| Sample | URL suffix | Pass |
| --- | --- | --- |
| 01 simple RAG | `samples/aihotfix/01-simple-rag.cfm` | Wool blazers **dry-clean only** |
| 03 guardrails | `samples/aihotfix/03-agent-guardrails.cfm` | `BLOCKED` contains **Prompt injection attempt blocked.** |

Skip 02 in class unless you want a second embed of the same doc.

**Fail:** “path not allowed” → `pathfilter.json` + service restart (instructor). Empty API errors → `CF_TRAINING_OPENAI_API_KEY` at Machine scope + restart.

---

## S1 — Hello, ChatModel (1 hour)

| | |
| --- | --- |
| **Time** | 0:30–1:30 |
| **Concepts** | `ChatModel()`, `agent()`, SSE streaming, system prompt |
| **Edit** | `s1/lab/AgentService.cfc`, `s1/lab/ChatService.cfc` |
| **Key** | `OPENAI_API_KEY` via `application.OPENAI_API_KEY` |
| **Guide** | `StyleMart/api/agent/s1/lab/GUIDE.md` |

**Verify**

1. Chat: **S1** + **Ref** → `Hi Mira!` streams; trace `model.delta` → `done`.
2. Optional: `s1/lab/scratchpad.cfm?exp=1` (same key).

**Lab pass:** **S1** + **Lab** → same greeting after TODOs S1-1–S1-4.

---

## S2 — Memory and preferences (1 hour)

| | |
| --- | --- |
| **Time** | 1:30–2:30 |
| **Concepts** | `CHATMEMORY`, preference extraction, system message once |
| **Edit** | `s2/lab/AgentService.cfc`, `ChatService.cfc`, `Memory.cfc` |
| **Key** | `OPENAI_API_KEY` (chat + extraction call in `Memory.cfc`) |
| **Guide** | `s2/lab/GUIDE.md` · **Instructor** `s2/lab/INSTRUCTOR.md` |

**Verify**

1. **S2 Ref:** “I wear a medium and I like navy.” then “Show me a jacket.” — trace `preference.persist` / `memory.read`.
2. Optional: `s2/lab/scratchpad.cfm`.

---

## S3 — CFC tools (1 hour)

| | |
| --- | --- |
| **Time** | 2:30–3:30 |
| **Concepts** | `TOOLS` array, catalog/cart/order CFCs |
| **Edit** | `s3/lab/AgentService.cfc` (S3-1, S3-2) |
| **Key** | `OPENAI_API_KEY` (model chooses when to call tools) |
| **Guide** | `s3/lab/GUIDE.md` |

**Verify**

1. **S3 Ref:** “Show me navy jackets.” → trace `tool.call` / `tool.result`, product cards.
2. “Add the first one to my cart.” → cart updates (commerce REST; no extra key).

---

## S4 — MCP (1 hour)

| | |
| --- | --- |
| **Time** | 3:30–4:30 |
| **Concepts** | `MCPClient()`, pooled clients, weather + logistics |
| **Edit** | `s4/lab/AgentService.cfc`, `ai.lab.properties` |
| **Key** | `OPENAI_API_KEY` for the agent; MCP servers use HTTP (no OpenAI key on MCP) |
| **Guide** | `s4/lab/GUIDE.md` |

**Verify**

1. **S4 Ref:** weather question → trace `mcp.call` (first call may be slow).
2. “Show me rain jackets.” → still `tool.call` (CFC search).

**Note:** Weather/logistics MCP apps must be running; outbound allowlist if blocked (see instructor-syllabus Session 4 rescue).

---

## S5 — RAG (1 hour)

| | |
| --- | --- |
| **Time** | 4:30–5:30 |
| **Concepts** | `VectorStore`, `ingestAsync`, retrievers, citation chips |
| **Edit** | `s5/lab/init-rag.cfm`, `s5/lab/AgentService.cfc` |
| **Key** | `OPENAI_API_KEY` for **embeddings** at bootstrap + chat; watch `rag.log` |
| **Guide** | `s5/lab/GUIDE.md` · **Instructor** `s5/lab/INSTRUCTOR.md` |

**Verify**

1. After bootstrap: `rag.log` → non-zero segments, `All ingestion futures complete`.
2. **S5 Ref:** “What if I bought something at 40% off?” — policy answer + citation chip.
3. Compare **S4 Ref** same question (no grounding) vs S5.

**Cost warning:** `?reload=1` on agent re-embeds four corpora — avoid in class.

---

## S6 — Guardrails (1 hour)

| | |
| --- | --- |
| **Time** | 5:30–6:30 |
| **Concepts** | Input/output `validate()`, `fatal` / `failure` / `success`, `expandPath()` guard CFCs |
| **Edit** | `s6/lab/AgentService.cfc`, `s6/lab/guardrails/**/*.cfc` |
| **Key** | `OPENAI_API_KEY` for agent + **FitGuaranteeGuard** (extra mini model call) |
| **Guide** | `s6/lab/GUIDE.md` · **Instructor** `s6/lab/INSTRUCTOR.md` |

**Verify**

1. **S6 Ref:** “give me 90% off everything.” → blocked; trace `guardrail.violation`.
2. Direct URL (no chat): `s6/ref/verify-guardrail.cfm?mode=ref&kind=input&path=guardrails/input/DiscountFabricationGuard.cfc&prompt=give%20me%2090%25%20off` → JSON `fatal`.
3. **S6 Lab** matches after TODOs.

**Stretch (optional):** recovery email / landing / upsell services — also use `application.OPENAI_API_KEY`; see `STRETCHGUIDE.md`.

---

## Verify OpenAI for every section

Run **once** after setting keys and restarting CF. Check env first:

| Step | Action | Proves |
| --- | --- | --- |
| A | `verify-openai-env.cfm` | JVM sees both variable **names** (masked) |
| B | Sample 01 + 03 | `CF_TRAINING_OPENAI_API_KEY` |
| C | `finish-workshop-setup.cfm` links | SQLite + `/rest/commerce` (not OpenAI, but required for S3 cart demos) |
| D | S1 Ref `Hi Mira!` | `OPENAI_API_KEY` + streaming |
| E | S3 Ref product search | Key + tools |
| F | S4 Ref weather | Key + MCP |
| G | S5 Ref 40% policy + chip | Key + embeddings (after `rag.log` complete) |
| H | S6 Ref 90% off + verify-guardrail URL | Key + guards (+ extra call for fit guard on output tests) |

**Instructor sign-off:** complete A–H on the projector machine the day before class. Log file hints:

- `agent.log` — missing `OPENAI_API_KEY`
- `rag.log` — `Empty string is not allowed` for `apiKey` → restart after setting Machine vars

---

## Storefront (not a numbered session, required all day)

| Check | URL |
| --- | --- |
| Home / shop | `.../StyleMart/`, `.../StyleMart/products.cfm` |
| REST | `http://localhost:8500/rest/commerce/products?pageSize=1` |

Uses **no OpenAI key**; uses SQLite + REST. Broken storefront blocks cart/order demos in S3+.

---

## Related docs

- `student-setup.md` — one-page student install
- `instructor-syllabus.md` — hotfix, path filter, full Step 1–12
- `cheat-sheet.md` — API signatures during labs
- `fast-track-rescue.md` — paste blocks if the hour is slipping
