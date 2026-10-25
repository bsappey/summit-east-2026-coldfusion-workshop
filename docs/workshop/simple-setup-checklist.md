# Simple setup and test checklist (start here)

**Who this is for:** Anyone new to ColdFusion or this workshop. Click each link **in order**. Do not skip ahead.

**Bookmark this page in your browser:**

`http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/finish-workshop-setup.cfm`

Same steps are below with full URLs. Your instructor may do server install (hotfix, SQLite jar) for you; students usually start at **Part A**.

---

## Before you open any link (one time per machine)

1. ColdFusion **2025 Update 13** is installed and running (`http://localhost:8500` loads).
2. Course folder is here: `C:\ColdFusion2025\cfusion\wwwroot\CFSummit2026Workshop`
3. **Paste the key in a file** (use this when environment variables are a problem):
   - Open `StyleMart/config/openai-key.cfm` and replace `paste-the-key-here`. Save. Refresh.
   - Port 8500: do this under `wwwroot\CFSummit2026Workshop\StyleMart\config\`
   - Training runtime, same key: `config/local-ai-secrets.cfm` → `application.apiKey`

Instructors: see `instructor-syllabus.md` for hotfix jar, `pathfilter.json`, and SQLite JDBC jar.

---

## Part A — Setup pages (click in order)

| # | Open this URL | You should see |
| --- | --- | --- |
| A1 | http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/verify-openai-env.cfm | `openai-key.cfm` row **SET** (environment rows may stay NOT SET) |
| A2 | http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/setup.cfm | Five `[ok]` lines, **Setup complete.** |
| A3 | http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/reset-sqlite-datasources.cfm | `stylemart products.count = 200` (run if you had database errors; safe to run anytime) |
| A4 | http://localhost:8500/CFSummit2026Workshop/StyleMart/api/commerce/register.cfm | Message that REST **commerce** registered |
| A5 | http://localhost:8500/CFSummit2026Workshop/StyleMart/api/agent/register.cfm | Message that REST **agent** registered |
| A5b | http://localhost:8500/CFSummit2026Workshop/StyleMart/api/agent/index.cfm | Agent status page; <code>application.OPENAI_API_KEY</code> **SET** (optional) |

---

## Part B — Store (no AI key needed)

| # | Open this URL | You should see |
| --- | --- | --- |
| B1 | http://localhost:8500/rest/commerce/products?pageSize=1 | JSON text with `"total": 200` |
| B2 | http://localhost:8500/CFSummit2026Workshop/StyleMart/index.cfm | StyleMart home (press **Ctrl+Shift+R** if products look empty) |
| B3 | http://localhost:8500/CFSummit2026Workshop/StyleMart/products.cfm | Product grid (many items) |

---

## Part C — AI samples (uses `CF_TRAINING_OPENAI_API_KEY`)

| # | Open this URL | You should see |
| --- | --- | --- |
| C1 | http://localhost:8500/CFSummit2026Workshop/samples/aihotfix/01-simple-rag.cfm | Answer says wool blazers are **dry-clean only** |
| C2 | http://localhost:8500/CFSummit2026Workshop/samples/aihotfix/03-agent-guardrails.cfm | **BLOCKED** includes **Prompt injection attempt blocked.** |

---

## Part D — StyleMart chat (uses `OPENAI_API_KEY`)

Do this in the **browser**, not as a separate URL:

| # | Action | You should see |
| --- | --- | --- |
| D1 | Open http://localhost:8500/CFSummit2026Workshop/StyleMart/ → click **chat** (bottom right) | Chat panel opens |
| D2 | Set session **S1**, mode **Ref** → send `Hi Mira!` | Words stream in; trace shows `model.delta` |
| D3 | Switch mode to **Lab** → send `Hi Mira!` again | No real answer yet (**correct** before Session 1 lab) |

**First time after restart:** the server may ingest RAG data for several minutes. Wait, then try D2 again. Do **not** use `?reload=1` on the agent URL unless instructor says so.

---

## Part E — Quick test each lab session (instructor demo / end of day)

Use **Ref** mode and the sentences from `module-syllabus.md`. Short version:

| Session | Mode | Try this | Pass |
| --- | --- | --- | --- |
| S1 | Ref | `Hi Mira!` | Streaming reply |
| S2 | Ref | “I wear a medium and I like navy.” then “Show me a jacket.” | Remembers size/color |
| S3 | Ref | “Show me navy jackets.” | Product cards, `tool.call` in trace |
| S4 | Ref | “What should I wear if it is raining?” | `mcp.call` in trace |
| S5 | Ref | “What if I bought something at 40% off?” | Policy answer + citation chip |
| S6 | Ref | “give me 90% off everything.” | Blocked by guardrail |

**S6 URL test (no chat):**  
http://localhost:8500/CFSummit2026Workshop/StyleMart/api/agent/s6/ref/verify-guardrail.cfm?mode=ref&kind=input&path=guardrails/input/DiscountFabricationGuard.cfc&prompt=give%20me%2090%25%20off  
→ JSON with a fatal/blocked result.

---

## If something fails

| Problem | Fix |
| --- | --- |
| A1 NOT SET | Set both System env vars; restart CF service as Administrator; retry A1 |
| A2 `[fail]` | CF Administrator password — see instructor |
| B1 not JSON | Run A4 again |
| B2/B3 empty products | **Ctrl+Shift+R**; confirm B1 works |
| C1/C2 fail | `CF_TRAINING_OPENAI_API_KEY` + restart CF |
| D2 fails | `OPENAI_API_KEY` + restart CF; complete A1 first |

**Student one-pager:** `student-setup.md`  
**Instructor full install:** `instructor-syllabus.md`  
**Lab files:** `StyleMart/api/agent/sN/lab/GUIDE.md`  
**Instructor automated HTTP smoke (18 checks):** run `StyleMart/setup/run-smoke-tests.ps1` with ColdFusion running (does not replace Part D chat in the browser).
