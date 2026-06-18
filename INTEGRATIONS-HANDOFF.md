# LeverageBLK — Integrations Handoff

**For:** a fresh Claude Code (Sonnet) session picking up the integration/wiring work.
**Project:** `/Users/malcolm.purefoy/Downloads/Leverage Landing Page/files/`
**Stack:** two static single-file pages (`index.html`, `inside.html`) + `privacy.html`. Vanilla HTML/CSS/JS, no build step. Deploy by dragging onto Netlify. **Do not migrate to a framework.** Read `CLAUDE.md` (same folder) first — it's the source of truth for brand, copy, and the "don't do" list.

---

## 1. Current state (what's already done — don't redo)

- **Pages:** `index.html` (main landing — renamed from `leverage-blk-landing.html`), `inside.html` (the `/inside` vision page, Step 5), `privacy.html`. All cross-linked; verified resolving in the local preview.
- **Supabase client is already wired in `index.html`.** Real project URL + publishable (anon) key are in place (`createClient(...)` near the top `<script type="module">`), and both waitlist forms call `supabase.from('waitlist').insert({ phone, source })` inside `bind()` → `submit()`. `23505` (unique_violation) is already treated as success.
  - Project ref: `mkxtkjitjgzjkflhahto`. Key in the file is the **publishable/anon** key (safe to be public). **Never** put a `service_role` key in any HTML.
- **Honeypot anti-bot** is live on both `index.html` forms (`.hp-field`, silently rejects on fill). No action needed.
- **Firebase Analytics is a scaffold only.** Both pages import the SDK and define `window.trackEvent`, but `firebaseConfig` is still placeholder (`apiKey: "YOUR_API_KEY"`). Until real keys are pasted, `trackEvent()` just `console.log`s `[track] …` — nothing breaks. Same scaffold in both files.
- **`supabase-setup.sql`** contains the table + RLS DDL, ready to run. Its "wiring note" (§4) still references the old filename `leverage-blk-landing.html` and an old TODO — that wiring is **already done in `index.html`**; ignore §4, it's stale.

---

## 2. Tasks, in order

### Task A — Supabase: create table + apply RLS (touches the LIVE project)
The client code is wired, but the **`waitlist` table and its RLS policy must exist in the live project** or inserts will fail (or, worse, succeed without RLS and let anyone read/wipe the table).

1. Run the DDL in `supabase-setup.sql` against project `mkxtkjitjgzjkflhahto` (Supabase SQL Editor, or the Supabase MCP `apply_migration` / `execute_sql` if connected).
   - Creates `waitlist (id, phone, source, created_at)`, a unique index on `phone`, and a `created_at` index.
   - Enables RLS and creates **`anon_insert_waitlist`** (INSERT-only for `anon`). No SELECT/UPDATE/DELETE policy → anon can write but not read/modify. This is the security requirement from `CLAUDE.md` → "Security" punch list.
2. **Verify** (queries are in `supabase-setup.sql` §3):
   - `SELECT relrowsecurity FROM pg_class WHERE relname='waitlist';` → `TRUE`
   - `SELECT policyname, cmd, roles FROM pg_policies WHERE tablename='waitlist';` → one row: `anon_insert_waitlist | INSERT | {anon}`
   - Simulate the browser: `SET ROLE anon; INSERT … ; SELECT *` should insert but return 0 rows on read.
3. **End-to-end check:** serve locally (`python3 -m http.server` from `files/`, or the `landing` preview config in `.claude/launch.json`), submit a phone on the hero form, confirm a row lands in the table (read it back as service_role / dashboard, since anon can't SELECT).

> ⚠️ This is the one task that mutates a live project. Confirm you're pointed at the right project ref before running. RLS-before-traffic is the whole point — do Task A before any real signups are driven.

### Task B — Firebase Analytics keys (needs the owner's credentials)
1. Firebase console → create/select the LeverageBLK project → Project settings → Your apps → Web app → copy the `firebaseConfig` object.
2. Paste it over the placeholder `firebaseConfig` in **both** `index.html` and `inside.html` (two separate copies — keep them identical).
3. Once real keys are in, `trackEvent()` sends to Firebase instead of console. Verify events fire in Firebase DebugView. Event reference in §3 below.
4. **Hygiene (low urgency):** once a production domain exists, restrict the Firebase API key to it (Firebase console → API key settings). Per `CLAUDE.md`.

### Task C — SMS pipeline (needs an account; scaffold/document only until then)
Storing a phone in Supabase doesn't text anyone. Per `CLAUDE.md`:
1. Stand up an SMS provider account on the **LeverageBLK email**, not a personal one (Twilio recommended; Telnyx cheaper at volume).
2. **A2P 10DLC registration** happens here — start early, it can take days, and unregistered US traffic gets silently filtered.
3. Build the send trigger: something reads new `waitlist` rows and calls the provider. Options: Supabase Edge Function on insert, a scheduled script, or a Zapier/Make bridge. **If an Edge Function is added, its secrets (provider auth token, `service_role` if needed) live server-side only — never in the client HTML.**

---

## 3. Analytics event reference (current `data-track` / `trackEvent` calls)

Keep this consistent if you add/rename anything.

| Page | Event | Params | Trigger |
|------|-------|--------|---------|
| index | `page_view` | `{page_title:'landing'}` | load |
| index | `nav_invite` | `{href}` | nav "Request your invite" |
| index | `waitlist_signup` | `{source:'hero'\|'finale'}` | successful form submit |
| index | `inside_page` | `{href}` | "See what you're getting in →" strip CTA |
| index | `advocate_video_play` | `{name}` | opening an advocate reel |
| inside | `page_view` | `{page_title:'inside'}` | load |
| inside | `nav_invite` | `{href}` | nav "Request your invite" |
| inside | `cta_click` | `{href, target:'waitlist'}` | "Get on the founding waitlist →" |
| inside | `cta_click` | `{href, target:'feature_board'}` | "Tell us →" feature-request (bottom reveal) |

Note: the old `feature_board` event from the main page's "Shape the Room" strip moved to `inside.html` as `cta_click` / `target:'feature_board'` (per Step 5). The generic tracker on `inside.html` reads `data-track` as the event name and merges `data-target` into params.

---

## 4. Gotchas / constraints

- **EASE in inline styles:** JS sets transitions with the literal string `'cubic-bezier(0.22,1,0.36,1)'`, never `var(--ease)` — CSS vars don't resolve in inline `style` set from JS. Follow that pattern if you touch the cinematic layer.
- **`service_role` key: server-side only, ever.** Only the publishable/anon key belongs in the HTML.
- **Don't break:** the SMS consent copy under both forms, the ATS/ghost-jobs narrative, the advocate reel system, the honeypot fields, or the analytics scaffold. See `CLAUDE.md` "Hard don't-do list" and the "four horsemen" visual constraints.
- **Stale references:** `.claude/launch.json` and `.claude/settings.local.json` still mention `leverage-blk-landing.html` (now `index.html`) — harmless permission/allowlist entries; clean up only if you're tidying.
- **No build step.** Test by opening the file or serving the folder. Deploy = drag the folder onto netlify.com (`index.html` is the root).

---

## 5. Definition of done
- [ ] `waitlist` table + `anon_insert_waitlist` RLS live and verified; end-to-end signup writes a row.
- [ ] Real `firebaseConfig` in both pages; events visible in Firebase DebugView.
- [ ] SMS provider chosen, 10DLC registration started, send-trigger approach decided (build can follow).
- [ ] No `service_role` key anywhere client-side; honeypot + consent copy intact.
