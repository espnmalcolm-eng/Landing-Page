# LeverageBLK — Session Goals & Task Cards

## How to Use This File

**At the start of every session — Sonnet or Opus — say this:**
> "Read `CLAUDE.md` and `SESSIONS.md` before doing anything. You are working on [Sonnet Session X / Opus Session Y] — follow the task card for that session exactly. Do not touch anything outside the scope of that card."

The session number tells the agent exactly what to execute, what to leave alone, and what the commit message should be. No re-explaining context, no drift into other tasks.

**Sonnet should refer to this file** for every session. It is the source of truth for what's done, what's next, and how to do it. If something in this file conflicts with `CLAUDE.md`, this file wins — it is more current.

**Can Sonnet spawn Opus?** No. Claude Code cannot escalate models mid-session programmatically. The model is fixed when the session starts.

**The escalation protocol instead:**
Tell Sonnet at the start of every session:
> "If you encounter something architecturally complex that you are not confident about — WebGL, GSAP internals, Three.js, multi-system interactions, or anything where one wrong decision causes cascading failures — STOP. Do not guess. Tell me exactly what you hit and why it's beyond this session's scope. I will open a new Opus session for that specific problem."

Sonnet hits a wall → tells you clearly → you open Opus with the specific problem → Opus solves it → you return to Sonnet for everything else.

**Opus never runs a Sonnet task card.** Opus is only for things explicitly marked as an Opus Session in this file, or for problems Sonnet has flagged and cannot resolve.

---

## Strategic Partner Mode — For All Sessions

This applies to both Sonnet and Opus. Do not blindly build. Act as a senior product designer, creative director, and technical lead.

**Challenge when:**
- The direction feels too generic
- A visual choice weakens the brand
- The page starts looking like SaaS instead of a cinematic marketing site
- A section feels unnecessary
- Copy sounds too corporate
- The layout feels overpacked
- A feature adds complexity without improving conversion
- The user experience creates friction
- The implementation choice is not worth the effort
- Something may hurt trust, clarity, or credibility

**Ask clarifying questions before building when:**
- The decision affects brand direction
- There are multiple strong creative routes
- A major layout choice is ambiguous
- Assets are missing
- Copy tone could go sharper or safer
- The conversion flow could change
- The technical setup could create unnecessary complexity

Do not ask questions about small obvious implementation details. Make smart assumptions there. When you disagree with an instruction, say so clearly and explain why.

**Response pattern before every major build:**

1. **What I understand** — summarize the goal in plain language
2. **What I'd challenge** — point out anything that may weaken the product, brand, conversion, or build quality
3. **Key decisions needed** — ask only the most important questions, 3–5 max
4. **Recommended direction** — give your opinion, do not stay neutral if one option is clearly stronger
5. **Then build** — only after resolving major direction issues, proceed with implementation

Default stance: collaborative but opinionated. Helpful but not passive. Protect the brand. Protect the user experience. Protect the conversion goal. Do not blindly execute weak ideas.

---

## Decision Rules

**Use Opus when:**
- First build of something with multiple interacting systems (WebGL + scroll + canvas)
- Something architectural is broken and Sonnet has failed to fix it
- Building the `/inside` page constellation interaction
- Any task where "one critical piece wrong" means a painful debugging session

**Use Sonnet when:**
- Config, wiring, copy updates
- Adding a section or page that follows existing patterns
- Motion tuning after seeing it live (iterative)
- Any task with a clear spec that doesn't require reasoning about system interactions
- Anything you'll do more than once (tune → look → tune again)

**Never use either when:**
- You haven't seen what currently exists in the browser first
- The task card isn't written — write the card here (or in Claude chat) first, then fire
- Multiple open threads are unresolved — close one before opening another

---

## Status: What's Done

- ✅ Three.js WebGL globe (PBR + bloom + city lights + arcs)
- ✅ GSAP ScrollTrigger pinned zoom + Option B crossfade (hero behind globe)
- ✅ Globe full-bleed deadzone fix (object-fit:cover + transform-origin NYC hub)
- ✅ FLIP wordmark intro (Figma-exported outlined SVG, pixel-perfect)
- ✅ Hero StarField restored (NetField, 700 particles)
- ✅ Supabase waitlist table + RLS + insert wired + honeypot
- ✅ Twilio confirmation texts (Edge Function + database webhook)
- ✅ Four-field waitlist form (name, field, phone, email)
- ✅ Scroll transitions (directional reveals, reel entrance from right)
- ✅ Credential cards migrated to Why section (desktop only)
- ✅ Hero tagline added ("Where your culture is your credential.")
- ✅ Legacy chip copy
- ✅ culture-connects.html built
- ✅ Figma brand file (wordmark components in Clash Display, all 3 sizes)
- ✅ CLAUDE.md updated

---

## Currently Running

- ⏳ **Opus Session A** — Globe dissolve fix on fresh open + motion pass from Jitter MP4

---

## Open Items (priority order)

1. GitHub remote + push → Netlify auto-deploy (blocks everything going live)
2. Firebase config keys
3. Twilio Auth Token rotation (security — token was exposed in chat)
4. Wordmark SVG re-export (Clash Display width fix)
5. culture-connects.html — slo burn. as beverage vendor
6. culture-connects.html — speaker names when confirmed
7. Advocate video hosting + src values
8. Privacy policy page
9. `/inside` page (Opus Session B)
10. A2P 10DLC registration (Twilio — do before first blast)

---

## OPUS SESSION CARDS

### Opus Session A — CURRENTLY RUNNING
Globe dissolve fix on fresh load + motion pass from Jitter MP4.
Do not duplicate.

---

### Opus Session B — /inside page
**When to fire:** After Netlify is live and Sessions 1–4 are closed.

**Goal:** Build `inside.html` — the vision page for LeverageBLK members.

> **Task: build `inside.html` — "What you're getting in"**
>
> Full copy and section spec is in CLAUDE.md under "Step 5: /inside page." Read that entire section before writing any code. This card adds the interaction spec.
>
> **File:** `files/inside.html` — standalone, same single-file approach as `index.html` and `culture-connects.html`. Do not modify either existing file.
>
> **Design system:** identical to main page — same CDN links, same CSS custom properties, same `.reveal` IntersectionObserver blur-in system, same `.eyebrow`/`.btn`/`.rule`/`.chip` classes.
>
> **Nav:** LeverageBLK brand mark links to `index.html`. Right CTA: "Join the waitlist →" links to `index.html#waitlist`.
>
> **Section sequence:** Problem framing (03) → Circles constellation (04) → Playbooks triptych (05) → Legacy close with feature-request reveal. Numbering continues from main page's 01/02.
>
> **Circle constellation (most complex piece — read carefully):**
> An SVG-based constellation with 6 nodes: one central "your room" node + 5 category nodes (Tech, Finance, Law & Policy, Founders, Creative & Media). Each category node connects to the center via a thin gold line (`stroke: #C9A84C`, `stroke-opacity: 0.35`, `stroke-width: 1.5`). Lines use `stroke-dasharray` / `stroke-dashoffset` pathLength technique — draw in sequentially via IntersectionObserver when the section enters the viewport, staggered 150ms per line, 1.4s duration, EASE.
>
> Node styling: dark glass cards matching the credential card system (`background: rgba(250,249,246,.04)`, `border: 1px solid rgba(201,168,76,.28)`, `border-radius: 14px`, `backdrop-filter: blur(8px)`). Central node slightly larger and brighter (`border-color: #C9A84C`, `background: rgba(201,168,76,.08)`). Each node enters with blur-in reveal, staggered 100ms. No mouse parallax — scroll-triggered only.
>
> Position nodes in a loose radial layout — not a perfect circle, varied distances from center to feel organic. Central node at approximately 50% / 55% of the section. Category nodes at varying distances (180px–260px from center) and angles.
>
> **Playbooks triptych:** Three cards side by side (desktop) / stacked (mobile). Each card: title, list of three fundamentals. Blur-in staggered left to right, 200ms between cards. On hover: `transform: translateY(-6px)`, `border-color: var(--gold)`.
>
> **Reputation tiers:** Three cards in ascending visual stack — each card slightly larger and more elevated than the previous: Connector (base, `opacity: 0.7`), Networker (mid, `opacity: 0.85`, `transform: translateY(-8px) scale(1.02)`), Authority (top, full opacity, `transform: translateY(-16px) scale(1.04)`, gold border). On scroll-into-view, they animate in sequence from bottom to top, 300ms stagger. Small label below Authority: "(more to come)" in faint cream.
>
> **Feature-request reveal:** "Got an idea for what should be in here? Tell us →" with `href="mailto:leverageblk@gmail.com?subject=Feature%20Request"` — part of the Legacy close section, visible only after IntersectionObserver fires on that section. Not a popup. Tracks `cta_click` with target `"feature_board"`.
>
> **LineField:** New coordinate set distinct from main page and culture-connects:
> `[8,0,32,100], [42,0,68,100], [78,0,88,100], [0,35,100,70], [100,15,0,85], [25,0,75,100]`
>
> **StarField:** `count: 480` on the problem-framing section, `count: 380` on the Legacy close section.
>
> **Mobile:** constellation collapses to a vertical list of category cards (no SVG lines on mobile — too small to read). Triptych stacks single column. Tier stack stays but reduces transform offsets by 50%.
>
> **Commit:** `"add inside.html — vision page, circle constellation, playbooks triptych, tier stack"`

---

### Opus Session C — Emergency only
Only if something architectural breaks post-deploy that Sonnet cannot fix (WebGL context, ScrollTrigger conflicts, Three.js performance on low-end mobile). Do not pre-plan this session.

---

## SONNET SESSION CARDS

### Sonnet Session 1 — Ship it
**Goal:** Get the page live on Netlify with auto-deploy from GitHub. Do this first — everything else depends on having a live URL.

> **Task: GitHub remote + Netlify deploy**
>
> 1. Confirm the repo is at `files/.git` on `main` branch with all recent commits
> 2. Run: `git remote add origin [GITHUB_REPO_URL]`
> 3. Run: `git push -u origin main`
>    - If GitHub repo already has commits (non-empty): use `git push --force-with-lease` after confirming local is correct
>    - Do NOT force push if you're unsure — flag it first
> 4. Confirm push succeeded and all files are on GitHub
> 5. Do NOT set up Netlify via CLI — Malcolm will connect via Netlify dashboard (github.com → netlify.com → "Import from Git" → select repo → publish directory: `files/` → no build command → deploy)
>
> After Malcolm confirms Netlify is live:
> 6. Note the live URL in CLAUDE.md under a new "## Deployment" section
>
> **Commit:** nothing new — just the push

**Malcolm's manual step:** netlify.com → "Add new site" → "Import from Git" → select `leverageblk-landing` → publish directory: `files` → build command: (empty) → deploy. Takes 2 minutes.

---

### Sonnet Session 2 — Config + security
**Goal:** Close all open config before real traffic hits.

> **Task: Firebase config + Twilio token rotation + wordmark re-export**
>
> Do these in order:
>
> **1. Firebase config**
> Malcolm will provide the `firebaseConfig` object from Firebase Console → Project Settings → Your apps → Web app. Paste it into the `firebaseConfig` placeholder in BOTH `files/index.html` AND `files/culture-connects.html`. Replace the entire placeholder object — do not leave any `"YOUR_..."` values. Confirm `logEvent(analytics, 'page_view')` fires without errors in console after update.
>
> **2. Twilio Auth Token rotation**
> The old token was exposed. Malcolm will provide the new Auth Token from Twilio Console → Account → API keys & tokens → rotate auth token. Update the Supabase Edge Function secret via MCP:
> - Secret name: `TWILIO_AUTH_TOKEN`
> - New value: [Malcolm provides]
> - Do not touch `TWILIO_ACCOUNT_SID` or `TWILIO_FROM_NUMBER`
> - Confirm Edge Function still triggers correctly after update (test by inserting a row directly into the waitlist table via Supabase dashboard)
>
> **3. Wordmark SVG re-export**
> Via Figma MCP, access file `q170kbWhRmMeB1JeijV45i`. Find the `Wordmark/Nav` component on the Wordmark page. Export it as SVG with text converted to outlined paths (no font dependency). Overwrite `files/assets/wordmark-outlined.svg`. Confirm the new file renders correctly in the browser — the wordmark should appear narrower and in Clash Display proportions vs the current Plus Jakarta Sans version.
>
> **Commit:** `"firebase config + twilio token rotation + wordmark re-export"`

---

### Sonnet Session 3 — culture-connects.html polish
**Goal:** Finish the event page before July 12.

> **Task: culture-connects.html — vendor + QA**
>
> **1. Add slo burn. as beverage vendor**
> In the vendor tables section (Section 02 — Inside the Room, or wherever vendors are listed), add slo burn. as the third vendor alongside the two other Black-owned brand placeholders. Label: "slo burn." Role label: "Beverage vendor." Do not add them to the partner/co-host line or the hero. They appear on the flyer image which is already displayed on the page — this addition is for the vendor section specifically.
>
> **2. Speaker cards**
> If Malcolm provides speaker names: update the 3 speaker card placeholders with real name, title, and brand. If no names yet: leave placeholder copy as-is ("Speakers announced soon — follow @LeverageBLK for updates").
>
> **3. Year audit**
> Search the entire file for "2025" — replace every instance with "2026". Check: countdown target date, any date strings, footer, meta tags.
>
> **4. Countdown timer verification**
> Confirm the countdown target is `new Date('2026-07-12T12:00:00-05:00')` (CDT). Open in browser and verify the timer shows approximately 13 days from June 29, 2026. If it shows a negative number or wrong value, the timezone offset is wrong — fix it.
>
> **5. Supabase RSVP verification**
> Submit a test RSVP with a real phone number. Check Supabase dashboard → waitlist table → confirm row appears with `source: 'event_atx'`. If no row appears, check console for errors and fix.
>
> **6. Mobile QA**
> Resize browser to 375px width. Check: no horizontal overflow, bingo card 3×3 grid readable, countdown fits on one line (hide seconds if needed), form fields stack properly, flyer image doesn't overflow.
>
> **Commit:** `"culture-connects polish — slo burn vendor, year fix, QA"`

---

### Sonnet Session 4 — Motion tuning
**Goal:** Review Opus motion pass output, tune anything that feels off. Do NOT fire this until Opus Session A is committed and you've seen the live page.

> **Task: motion tuning pass**
>
> Open the live page. Scroll through every section. Note anything that feels wrong — too fast, too slow, wrong direction, wrong easing character.
>
> For each issue, describe it precisely and fix it:
> - "Credential card stagger is too slow" → reduce delay interval from Xms to Yms
> - "Hero headline enters too abruptly" → increase blur from 14px to 20px, duration from 1.1s to 1.3s
> - "Reel cards come from wrong direction" → change translateX(40px) to translateX(-40px)
>
> Do NOT make broad changes. One specific fix per issue, no more. The goal is precision tuning, not a rewrite.
>
> Apply same fixes to `culture-connects.html` if it uses the same reveal system.
>
> **Commit:** `"motion tuning — [list what changed]"`

---

### Sonnet Session 4B — Retrigger hero entrance on dissolve reveal
**Goal:** Make the Jitter motion actually visible. Currently hero animations settle while the hero is hidden behind the globe — users never see them. This session fixes that.

**Why this matters:** Opus flagged this in Session A. The credential card drift-in (Jitter motion) fires on a timer during page load, but the hero is hidden behind the globe the whole time. By the time the globe dissolves, all animations have already settled — users see a static hero. The fix is retriggering entrance animations at the moment the dissolve begins.

> **Task: retrigger hero entrance on dissolve reveal**
>
> **1. Disable timer-based hero entrance on load**
> Find the existing hero entrance animation triggers (likely `setTimeout` or `INTRO_DELAY`-based). Disable them — hero elements should NOT animate on page load.
>
> **2. Reset hero elements to pre-animation state on load**
> All hero animated elements start invisible:
> ```css
> .hero-animate {
>   opacity: 0;
>   transform: translateY(20px);
>   filter: blur(14px);
>   transition: opacity 0.8s cubic-bezier(0.22,1,0.36,1),
>               transform 0.8s cubic-bezier(0.22,1,0.36,1),
>               filter 0.8s cubic-bezier(0.22,1,0.36,1);
> }
> .hero-animate.in {
>   opacity: 1;
>   transform: none;
>   filter: none;
> }
> ```
>
> Mark these elements with `.hero-animate`: headline lines, tagline, sub-paragraph, CTA button, credential cards.
>
> **3. Fire entrance on dissolve**
> In the GSAP ScrollTrigger `onUpdate`, when `progress > 0.7` (dissolve window begins) and `!heroEntranceFired`:
> ```js
> function triggerHeroEntrance() {
>   if (heroEntranceFired) return;
>   heroEntranceFired = true;
>   document.querySelectorAll('.hero-animate').forEach((el, i) => {
>     setTimeout(() => el.classList.add('in'), i * 90);
>   });
> }
> ```
>
> **4. Credential cards get their Jitter drift-in as part of this sequence**
> Left-side cards: `translateX(-44px)→0` + `rotate(-1.2deg)→0`, spring easing `cubic-bezier(0.34,1.56,0.64,1)`
> Right-side cards: `translateX(44px)→0` + `rotate(1.2deg)→0`, same spring easing
> These override the generic `.hero-animate` transform for cards specifically.
>
> **5. Fallback — direct URL visit bypassing globe**
> If user lands directly on `#hero` without scrolling through the globe, the GSAP trigger never fires. Add a fallback: `IntersectionObserver` on `#hero` that calls `triggerHeroEntrance()` if it hasn't fired within 2s of the hero being visible.
>
> **6. prefers-reduced-motion**
> Skip all of this — hero elements jump straight to `.in` state on page load. No animation, instant visibility.
>
> **7. GSAP missing fallback**
> If GSAP fails to load, hero elements add `.in` immediately — never hidden.
>
> **Commit:** `"retrigger hero entrance on dissolve reveal — Jitter motion now visible"`
>
> Do not touch the globe transition math, GSAP ScrollTrigger pin/scrub values, Supabase, Firebase, or any other section.

---

### Sonnet Session 5 — Advocate videos
**Goal:** Wire real video files once hosting is decided.

> **Task: wire advocate videos**
>
> **1. Hosting decision** (Malcolm decides before firing this session):
> - Option A: Supabase Storage (already have account, public bucket, free tier)
> - Option B: Cloudflare R2 (cheap, fast CDN)
> - Option C: Direct file in `assets/` (only if all videos together are under 50MB)
>
> **2. Compress videos before uploading**
> Each video: target under 5MB, 720p H.264, vertical 9:16. Use `ffmpeg` if available:
> `ffmpeg -i input.mp4 -vcodec h264 -acodec aac -vf scale=720:-2 -crf 28 output.mp4`
>
> **3. Upload to chosen host, get public URLs**
>
> **4. Update ADVOCATES array in `index.html`**
> ```js
> const ADVOCATES = [
>   { name: "Real Name", role: "Role / Company", src: "https://..." },
>   // ... etc
> ];
> ```
> Remove placeholder entries. Each entry with a real `src` will open the lightbox player on click.
>
> **5. Test lightbox on each video** — click card, confirm video plays, Esc closes, `advocate_video_play` event fires in console.
>
> **Commit:** `"wire advocate videos — [number] advocates"`

---

### Sonnet Session 6 — Privacy policy
**Goal:** Build `privacy.html` and link from both waitlist forms.

> **Task: build privacy.html**
>
> Create `files/privacy.html` — a simple, readable privacy policy page. Same nav and footer as other pages. No animations, no StarField, no canvas — just clean readable text on ink background.
>
> **Content to cover:**
> 1. What we collect: name, phone number, email address, field of work, event RSVP status
> 2. Why we collect it: waitlist notifications, event updates, product launch communications
> 3. Third-party processors: Supabase (database storage), Firebase (analytics), Twilio (SMS delivery)
> 4. How to request removal: email leverageblk@gmail.com with subject "Data Removal Request"
> 5. No data sold to third parties
> 6. SMS: you can reply STOP to any text to opt out
> 7. Last updated: June 2026
>
> **Link from:**
> - Both waitlist forms in `index.html` — add "Privacy Policy" link next to the SMS consent copy
> - The RSVP form in `culture-connects.html` — same placement
>
> **Note:** This is a draft. Final wording should be reviewed by whoever is handling LeverageBLK Corp's legal structure before the app launches publicly. For the landing page pre-launch phase, this draft is sufficient.
>
> **Commit:** `"add privacy.html + link from waitlist forms"`

---

## MOTION TASK CARD
**For Sonnet Session 4 specifically — but also reference during any motion work**

### Motion System Overview (current state after Opus Session A)

The page uses three motion layers:

**Layer 1 — Entrance animations (CSS + IntersectionObserver)**
- `.reveal` class: `opacity 0→1`, `translateY 26px→0`, `filter blur(14px)→blur(0)`, duration 0.8s, EASE
- `.reveal-left`: same + `translateX(-24px)→0`
- `.reveal-right`: same + `translateX(24px)→0`
- Triggered by IntersectionObserver at threshold 0.15
- Stagger: applied manually via `transition-delay` on child elements

**Layer 2 — Scroll-driven (GSAP ScrollTrigger)**
- Globe-moment: pinned section, `scrub: 1.2`, scale `1.0→2.2` desktop / `1.0→1.6` mobile, dissolve over final 30% of progress
- Scroll transitions: globe parallax (`translateY` + `translateX` driven by scrollY), directional section reveals

**Layer 3 — Continuous (CSS animations + rAF)**
- Globe breathing: `scale(1.0→1.04)` over 12s, looping alternate
- NetField: continuous particle twinkle via sine wave per particle
- Intro sequence: FLIP animation, concentric gold rings

### Motion Design Principles (from Jitter MP4 reference + brand direction)

1. **EASE everywhere**: `cubic-bezier(0.22, 1, 0.36, 1)` — fast start, long tail, never bouncy
2. **Blur-in is the signature**: every entrance uses `filter: blur(14px)→blur(0)` — this is the page's motion DNA
3. **Stagger creates hierarchy**: elements in the same section stagger 80–120ms apart — earlier = more important
4. **Gold moves last**: gold accent elements (eyebrows, gold text, gold borders) should appear slightly after their parent element to draw the eye
5. **No simultaneous entrances**: nothing enters at the same frame as something else in the same visual zone
6. **Subtle is premium**: if an animation is noticeable as an animation rather than a feeling, it's too much

### Per-Section Motion Spec

**Globe moment:**
- Copy ("REAL CONNECTIONS" eyebrow + "Where your culture is your credential." headline): blur-in on page load after intro delay, no scroll trigger — it's the first thing visible
- Chevron ↓: pulse animation, `opacity 0.4→1→0.4` over 2s, looping

**Hero:**
- Chip: blur-in, delay 0ms after intro completes
- H1 line 1 ("The algorithm"): blur-in, delay 80ms
- H1 line 2 ("filtered you out. We"): blur-in, delay 160ms. "filtered" strikethrough: `scaleX(0→1)` on `::after`, `transform-origin: left`, fires 200ms after line 2 enters
- H1 line 3 ("let you in."): blur-in, delay 240ms. "in." gold italic: enters with its line, no extra delay needed
- Tagline: blur-in, delay 340ms
- Sub-paragraph: blur-in, delay 440ms
- CTA button: blur-in + subtle `scale(0.96→1)`, delay 540ms

**Credential cards (Why section):**
- Enter on scroll-into-view, staggered 100ms per card
- Left-side cards: `.reveal-left` + `rotate(-1.5deg→0deg)` — settle into position
- Right-side cards: `.reveal-right` + `rotate(1.5deg→0deg)`
- Center cards (if any): `.reveal` straight up
- Hover: `translateY(-6px)`, `border-color: var(--gold)`, duration 0.3s

**How it works cards (mechanic cards):**
- Stagger 120ms left to right
- Each card: blur-in + `translateY(32px→0)`
- Hover: same as credential cards

**Advocate reel:**
- Row enters from right: each card `translateX(40px→0)` + opacity, stagger 80ms
- Cards already in view on load: enter immediately without waiting

**Shape the Room strip:**
- `.reveal-left` — drifts in from left as a unit

**Finale section:**
- Heading: `.reveal` straight up
- Sub: `.reveal`, 120ms delay
- Form: `.reveal`, 200ms delay

### Tuning Reference

When something feels wrong:

| Symptom | Likely cause | Fix |
|---|---|---|
| Entrance feels abrupt | blur too low or duration too short | Increase blur to 20px, duration to 1.2s |
| Entrance feels slow/laggy | duration too long | Reduce to 0.7s |
| Stagger feels mechanical | intervals too uniform | Vary delays: 0, 80, 180, 260ms instead of 0, 80, 160, 240ms |
| Cards feel like they're falling | translateY too large | Reduce from 32px to 20px |
| Rotation feels gimmicky | rotate too large | Reduce from 1.5deg to 0.8deg |
| Everything enters at once | IntersectionObserver threshold too low | Increase from 0.15 to 0.25 |
| Things enter before visible | IntersectionObserver threshold too high | Decrease from 0.25 to 0.1 |

### Adding Motion to New Pages

When building `inside.html` or any future page:
1. Copy the `.reveal`, `.reveal-left`, `.reveal-right` CSS and IntersectionObserver JS from `index.html`
2. Apply the same EASE constant
3. Use the stagger delays from the Per-Section spec above as a starting point
4. Do NOT add GSAP ScrollTrigger to new pages unless there's a specific scroll-scrub interaction — it's overkill for standard reveals
5. Test `prefers-reduced-motion` — all animations should be zero or opacity-only under this preference
