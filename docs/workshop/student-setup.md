# StyleMart workshop — student setup (one page)

## Start here (easiest)

Open this page in your browser and follow **Part A → D** in order:

**http://localhost:8500/CFSummit2026Workshop/StyleMart/setup/finish-workshop-setup.cfm**

Same steps with full URLs: `docs/workshop/simple-setup-checklist.md`

---

Use this on **native Windows ColdFusion 2025 Update 13** with the course under:

`C:\ColdFusion2025\cfusion\wwwroot\CFSummit2026Workshop`

Your instructor may have already applied the AI hotfix and path filter. If something fails, use the **Help** section on the finish page or ask before you change server files.

---

## CommandBox instead of the installed server

The port **8500** service is the classroom install. CommandBox is a second server, used when you clone this repo and do not copy it into `wwwroot`. The ColdFusion Training Runtime CommandBox server also uses port **8080**. Stop that server before starting this one (`box server stop "ColdFusion Training Runtime"`). The port 8500 service can stay up.

From this repo (the folder that contains `server.json`):

```text
box server start
```

Then use these URLs. There is no `/CFSummit2026Workshop` prefix, because the clone is the web root:

```text
http://127.0.0.1:8080/StyleMart/setup/setup.cfm
http://127.0.0.1:8080/StyleMart/setup/finish-workshop-setup.cfm
http://127.0.0.1:8080/StyleMart/
http://127.0.0.1:8080/rest/commerce/products?pageSize=1
http://127.0.0.1:8080/rest/logistics/shipments/by-order/ord_ecd33f2507af7011a043aa9a7c9c0f3c
```

The repo already includes the CommandBox export:

| File | Keep it |
| --- | --- |
| `server.json` | `restMappings` is `/rest/*` and `libDirs` is `kit`. Without `restMappings`, `/rest/...` shows the CommandBox **Oops! Not Found** page. |
| `.cfconfig.json` | Administrator password. It must match `admin.password` in the `db.properties` files. |
| `kit/sqlite-jdbc-3.45.3.0.jar` | SQLite driver for this CommandBox server. |

After a git pull that changes `server.json` or `Application.cfc` mappings, restart once: `box server restart "ColdFusion Summit 2026 Workshop"`.

If logistics registration says it cannot find `CFSummit2026Workshop.externalservices.prologics.ShipmentService`, restart so the mapping in `externalservices/prologics/Application.cfc` loads. If the shipment URL mentions `C:Users` or `SQLITE_CANTOPEN`, open `http://127.0.0.1:8080/StyleMart/setup/reset-sqlite-datasources.cfm`.

Full steps and the troubleshooting table: `docs/workshop/instructor-syllabus.md` (section **CommandBox (port 8080) and the training runtime**).

---

## 1. OpenAI key — paste it in a file

If Windows environment variables are awkward, skip them. Paste the key the instructor gives you into one file and refresh. No ColdFusion restart.

**StyleMart and the hotfix samples** (one paste covers both):

1. Open `StyleMart/config/openai-key.cfm`
2. Replace `paste-the-key-here` with the key. Save.
3. Refresh the chat page.

Edit the copy the server is running. Port 8500 uses `C:\ColdFusion2025\cfusion\wwwroot\CFSummit2026Workshop\StyleMart\config\openai-key.cfm`. CommandBox on port 8080 uses this clone’s `StyleMart\config\openai-key.cfm`. The file in git keeps the placeholder. Do not paste the key into `Application.cfc`.

**Training runtime** (the module pages on port 8080) is a second file, same key:

1. Open `config/local-ai-secrets.cfm` in the training-runtime folder
2. Replace `paste-the-key-here` on `application.apiKey`. Save.
3. Refresh the sample page.

Check the workshop file at `StyleMart/setup/verify-openai-env.cfm`. The `openai-key.cfm` row should say **SET**. The environment rows can stay **NOT SET**.

### Environment variables, only if you prefer them

Set **both** variables to the **same** key. Use **System variables** (Machine scope), not User-only, when ColdFusion runs as a Windows **service**. Then restart the service.

| Variable | Used by |
| --- | --- |
| `OPENAI_API_KEY` | StyleMart assistant (chat, RAG, tools) |
| `CF_TRAINING_OPENAI_API_KEY` | Sample pages under `samples/aihotfix/` |

**Do not** paste the key into `Application.cfc` or `Application.cfm`. Leave `paste-the-key-here` in anything you push.

### Windows GUI

1. **Win + R** → `sysdm.cpl` → **Advanced** → **Environment Variables**
2. Under **System variables** → **New** → `OPENAI_API_KEY` = your key
3. **New** again → `CF_TRAINING_OPENAI_API_KEY` = same key
4. **OK** all dialogs, then **restart ColdFusion** (or ask instructor to restart the service)

### PowerShell (admin)

```powershell
[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "<your key>", "Machine")
[Environment]::SetEnvironmentVariable("CF_TRAINING_OPENAI_API_KEY", "<your key>", "Machine")
```

Restart ColdFusion after changing either variable (Stop the **Application Server** service, wait ~10 seconds, Start — as **Administrator**).

If `verify-openai-env.cfm` still shows **NOT SET** after that, run as Administrator from `StyleMart/setup/`:

```powershell
# If scripts are blocked, use -ExecutionPolicy Bypass for this one file:
powershell -ExecutionPolicy Bypass -File .\install-openai-env-for-cf-service.ps1 -ApiKey "your-adobe-key-here"
Restart-Service -Name "ColdFusion 2025 Application Server" -Force
```

Or paste the commands from `install-openai-env-for-cf-service.ps1` directly in the same Admin window (no `.ps1` file needed).

That script sets both variables at Machine scope **and** on the ColdFusion Windows service (some installs only pick up env vars from the service registry key).

---

## 2. Database — no SQL Server

The store uses **SQLite** files already in the repo. You only register them once.

| Step | URL | You should see |
| --- | --- | --- |
| API env check | `.../StyleMart/setup/verify-openai-env.cfm` | Both variables **SET** (masked) |
| Main setup | `.../StyleMart/setup/setup.cfm` | Five `[ok]` lines and **Setup complete.** |
| Finish + smoke tests | `.../StyleMart/setup/finish-workshop-setup.cfm` | Click each link; JSON check shows products |

If setup fails on administrator login, ask for the CF Admin password or use the instructor’s `CF_ADMIN_PASSWORD` system variable.

**SQLite driver:** the main `sqlite-jdbc-*.jar` must be in `C:\ColdFusion2025\cfusion\lib\` (instructor usually installs this). Error `org.sqlite.JDBC` → tell instructor.

**Path error:** `[SQLITE_CANTOPEN]` → open `.../StyleMart/setup/reset-sqlite-datasources.cfm` once.

---

## 3. Storefront must use `/rest/` (not `/api/`)

On a normal Windows install, the browser calls:

- `http://localhost:8500/rest/commerce/...`
- `http://localhost:8500/rest/agent/...`

Quick JSON check (open in browser):

`http://localhost:8500/rest/commerce/products?pageSize=1`

You should see JSON with `"total": 200`.

| Page | URL |
| --- | --- |
| Home | `.../StyleMart/` |
| Shop | `.../StyleMart/products.cfm` |

After any fix, hard-refresh: **Ctrl + Shift + R**.

If the home page shows a huge **Error** circle, the site is often still calling old `/api/` URLs or a cached script — hard-refresh and re-run the **finish** setup page links.

---

## 4. Verify AI (before labs)

| Check | URL / action | Pass |
| --- | --- | --- |
| Sample RAG | `.../samples/aihotfix/01-simple-rag.cfm` | Answer mentions wool blazers are **dry-clean only** |
| Sample guardrail | `.../samples/aihotfix/03-agent-guardrails.cfm` | `BLOCKED` contains **Prompt injection attempt blocked.** |
| Mira chat | Open StyleMart → chat → **S1** + **Ref** → send `Hi Mira!` | Tokens stream; trace shows `model.delta` |

First agent load after restart may take several minutes (RAG ingest). Do **not** bookmark `?reload=1` on the agent URL.

---

## 5. Lab rules (save API usage)

- Stay on **`gpt-4o-mini`** — do not change `modelName` in lab files.
- **Lab** = your TODOs; **Ref** = working answer key.
- Do not restart ColdFusion during a session unless the instructor says so.
- Do not reload the agent application unless instructed.

Session guides live under `StyleMart/api/agent/sN/lab/GUIDE.md`.

---

## 6. Quick troubleshooting

| Problem | Try this |
| --- | --- |
| Chat never streams | Both env vars set at **System** scope + CF service restarted |
| Sample 01 works, chat does not | You may be missing `OPENAI_API_KEY` (StyleMart uses that name) |
| Empty Shop / no products | Open finish setup page; confirm `/rest/commerce/products` JSON; **Ctrl+Shift+R** |
| `setup.cfm` `[fail]` | Wrong CF Administrator password — ask instructor |
| Stuck > 10 minutes on a TODO | Toggle **Ref**, confirm it works, then ask or copy matching `ref/` file over `lab/` |

Module outline + per-session verification: `docs/workshop/module-syllabus.md`  
More detail for instructors: `docs/workshop/instructor-syllabus.md`  
API patterns during labs: `docs/workshop/cheat-sheet.md`

---

## Copy-paste URL list

Replace `...` with `http://localhost:8500/CFSummit2026Workshop`.

```text
.../StyleMart/setup/verify-openai-env.cfm
.../StyleMart/setup/setup.cfm
.../StyleMart/setup/finish-workshop-setup.cfm
.../StyleMart/
.../StyleMart/products.cfm
http://localhost:8500/rest/commerce/products?pageSize=1
.../samples/aihotfix/01-simple-rag.cfm
.../samples/aihotfix/03-agent-guardrails.cfm
```
