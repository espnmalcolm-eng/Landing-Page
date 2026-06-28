# LeverageBLK Landing Page — Project Brief

## What this is
A single-page, pre-launch waitlist landing site for LeverageBLK (private professional network for Black and Brown professionals). Purpose: drive traffic, capture phone-number signups, build brand trust. Single HTML file (vanilla HTML/CSS/JS, no build step, no framework) — deploy by dragging onto Netlify. **Do not migrate this to React/Vite/TanStack** unless that's a separate, deliberate decision later.

## Brand
- Tagline: "Where Your Culture Is Your Credential."
- Positioning: "The algorithm filtered you out. We let you in."
- Palette: ink `#0A0A0A`, deep card `#121110`, elevated card `#1A1714`, gold `#C9A84C`, cream `#FAF9F6`, muted cream `rgba(250,249,246,.62)`, faint cream `rgba(250,249,246,.34)`, gold border `rgba(201,168,76,.28)`, gold soft `rgba(201,168,76,.18)`.
- Fonts: Clash Display (display, via Fontshare), Plus Jakarta Sans (body, via Google Fonts).
- Direction: **cultural career infrastructure** — premium editorial tech launch, not a fantasy private club / mansion-doorway vibe, not generic SaaS.

## Current page structure (top → bottom)
0. **Globe moment** — cinematic opener, first section (`#globe-moment`, 100vh desktop + mobile). **Static globe image + transparent WebGL particle overlay** (Three.js r128, CDN, no build step). The globe *surface* is no longer 3D — it's the static `assets/globe.png` (`assets/globe-mobile.png` under 768px) inside a `.globe-crop` box (`position:relative; overflow:hidden`; 620px tall desktop / 420px mobile; image `width:115%` desktop / `195%` mobile, bottom-anchored, with a contrast/saturate/brightness + gold drop-shadow filter). A **transparent WebGL canvas is mounted inside `.globe-crop`** (`alpha:true`, `setClearColor(0x000000, 0)`, sized to the crop, `pointer-events:none`) and draws **only**: 38 named-city **additive glow sprites** (shared radial-gradient CanvasTexture, `0xD4B86A`, `depthTest:false`; primary hubs scale `0.072` / secondary `0.040`) + a seeded (`mulberry32`) additive glow-**Points** cloud (420 desktop / 70 mobile, `size:0.032`) clustered near the metros + arcs: 3 **primary** layered draw-in arcs (NYC→London/Lagos/Atlanta, each 4 additive line layers at opacity ×1/0.65/0.38/0.14 and scale 1/1.006/1.016/1.034 to fake glow/thickness; `setDrawRange` animates them in on section-enter) and ~55 low-opacity **secondary** arcs wrapping the whole globe. **There is NO sphere, atmosphere, lighting, earth texture, lat/lng grid, or sun-flare anymore** — all removed when the surface became a static image. Camera matches the photo's Atlantic-facing, slightly-elevated viewpoint: FOV 30 (mobile 50), `position (0, 0.6, 4.0)` desktop / `(0, 0.6, 3.0)` mobile, `lookAt(0, GY, 0)`; the particle group is `scale 1.6` (mobile 1.15), `y -1.15` (mobile -0.78), fixed `rotation.y = π*0.22` (`BASE_RY`), `rotation.x = -0.28` (`BASE_RX`).
   - **Gyroscope tilt:** on `pointermove` over the section the overlay eases toward the cursor (`rotation.y ±0.18`, `rotation.x ±0.10`, lerp `0.06`/frame); recenters on `pointerleave`. Disabled on touch (`hover:none`) and `prefers-reduced-motion`; frozen during the dissolve.
   - **Dissolve transition → hero (`#hero`) — GSAP ScrollTrigger pinned scroll-scrub + co-located hero crossfade** (GSAP 3.12.2 + ScrollTrigger, CDN, loaded before the globe script). **Scroll architecture:** `#globe-moment` and `#hero` share one wrapper `<div id="globe-hero-wrapper">` (`position:relative`). In the GSAP path the hero is set `position:absolute; top:0; left:0; width:100%; z-index:0; opacity:0` (set once) so it sits **co-located behind the globe** (globe `#globe-moment` is `z-index:1`); the **wrapper is the pinned element** (`trigger:wrapper, pin:wrapper`), so the pin-spacer accounts for both sections together and the hero is already at viewport top the instant the pin releases — **zero gap, no scroll-distance to travel**. The full-bleed `.globe-crop` (`position:absolute; inset:0; object-fit:cover; object-position:center 60%`) fills the whole 100vh section so scaling up never reveals letterbox edges. Pin runs `start:'top top'` for `end:'+=120%'` desktop / `'+=80%'` mobile; `scrub: 1.2` / `0.8`. `onUpdate(self)` scales `.globe-crop` `1.0 → 2.2` desktop / `1.0 → 1.6` mobile (`scale = 1 + progress*SCALE_GAIN`, `SCALE_GAIN` 1.2/0.6) toward the NYC hub (`transform-origin: 52% 58%`, set once on the crop); over the **final ~22%** (`p > 0.78`) it dissolves the crop opacity `1 → 0` while crossfading `#hero` opacity `0 → 1` (inverse), so the fading globe reveals the hero directly — **never black** — and fires `scatterParticles()` once (`scatterFired` latch). `onLeave` calls `window.__heroNetField.boostBrightness(1.3, 1000)`. The hero **StarField (NetField) is always-on from page load** (never scroll-gated, exposed as `window.__heroNetField`) so it's already rendering during the crossfade. (The hero's ~86px bottom-padding overflow past the wrapper overlaps `#why`'s top padding harmlessly — `#why` paints over it and no content is hidden.)
     - **Fully reversible:** scrubbing back above the threshold (`p ≤ 0.78`) calls `restoreParticles()` (cancels in-flight tweens, restores sprite positions/opacities, bg-points buffer, arc opacities) and sets hero opacity back to 0. `scatterParticles()` flies city sprites outward (per-sprite 0–200ms delay; mobile scatters primary cities only), expands+fades the bg Points cloud (mobile just fades it), fades arcs, and sets `isTransitioning` (freezes gyro tilt). `onLeave` (unpin) calls `window.__heroNetField.boostBrightness(1.3, 1000)` — the field pulses 30% brighter then eases back over 1s.
     - **`prefers-reduced-motion`: NO pin** — a non-pinned ScrollTrigger just crossfades the crop out as the section scrolls past (hero follows in normal flow), boost still fires on leave. **If GSAP fails to load**, no pin is created and the section scrolls away normally (graceful degradation). Render-pause IntersectionObserver is held open while pinned/`isTransitioning`; the WebGL context is kept alive (no auto-dispose) so the scrub stays reversible — disposal only on `pagehide` / DOM removal.
   - **Overlay copy rides the scrub:** the `.globe-moment-copy` container (eyebrow + tagline) fades + drifts up (`translateY -40px`) + blurs out over the first 70% of progress via `driveCopy(p)` — driven on the container (no `.reveal` transition to fight the scrub), cleared at `p≈0` so the per-line load blur-in and reverse-scrub both restore cleanly.
   - **Fallback:** if Three/WebGL is unavailable, `assets/globe.png` (`.globe-fallback`) is shown — no error state. One centered line of copy ("Real connections" / "Where your culture is your credential.") at z-index 10, SVG LineField above the canvas, mobile-only gold scroll-hint chevron. No form, no credential cards, no nav CTA.

   *WebGL-detect gotcha:* don't probe `renderer.domElement.getContext('webgl')` after constructing the renderer — Three r128 creates a **webgl2** context, so that returns `null` even when WebGL works (false-triggers the fallback). Use `renderer.getContext()` instead.
1. **Hero** (`#hero`) — StarField (NetField, count 700, gold/cream) + LineField background, animated headline, explanatory sub, and the four-field waitlist form (name, field, phone, email + SMS consent + submit) shown **directly** — no expand-CTA gate (removed to avoid duplicating the fixed nav "Request your invite", which scrolls here). Form submit/validation/Supabase logic unchanged. Chip reads "Legacy waitlist · Now open".
2. **01 — Why we exist** — StarField, manifesto on ATS/AI screeners and ghost jobs as "the villain," pullquote, two pillar cards.
3. **Advocate video reels** — horizontal scroll-snap row of vertical 9:16 cards, data-driven `ADVOCATES` array (`name`, `role`, `src`). Empty `src` = non-clickable "coming soon" placeholder. Populated `src` opens a fullscreen lightbox `<video>` player. Tracks `advocate_video_play`.
4. **02 — How leverage works** — three mechanic cards: Co-Sign (public, 5/lifetime), The Tap (private signal), The Room (90-day warm-intro access).
5. **What-you're-getting-in strip** — single CTA "See what you're getting in →" linking to `inside.html` (was the feature-request "Shape the Room" strip; the feature-request CTA moved to the bottom of `/inside`). Tracks `inside_page`.
6. **Final waitlist** — second phone form (secondary capture), scarcity framing ("the room is filling up").
7. **Footer** — brand, founders (Malcolm & David Butler), beta status.

## Already wired
- Firebase Analytics scaffold (placeholder `firebaseConfig`, `window.trackEvent()` console-logs until real keys added). Events: `page_view`, `waitlist_signup` (source: `hero`/`finale`), `inside_page`, `cta_click` (target: `waitlist`/`feature_board`), `advocate_video_play`.
- Supabase insert is **wired** in `index.html` — both forms call `supabase.from('waitlist').insert({ phone, source })` with real project URL + publishable (anon) key; `23505` (dup phone) treated as success. Gated on the table + RLS existing in the live project (see Security punch list).

---

## Next task: cinematic upgrade layer

Goal: bring VALMAX-spec motion techniques into this file as vanilla CSS/JS — reinterpreted for LeverageBLK's brand, not photography. Same file, same deploy story.

### Global constants
- `EASE = cubic-bezier(0.22, 1, 0.36, 1)` — use everywhere for entrance/scroll animations.
- `INTRO_DELAY ≈ 1.5–2s` (shorter than VALMAX's 2.9s is fine — this is a waitlist page, don't make people wait). Hero content waits for intro to mostly clear before its own entrance starts.

### 1. Intro sequence (fullscreen, ~2–2.5s, skip on `prefers-reduced-motion`)
- Fixed inset-0, z-100, ink backdrop (`#0A0A0A`), pointer-events none.
- Centered "Leverage**BLK**" wordmark (BLK in gold), fades/scales in, then the whole block animates to the top-left nav position and shrinks — landing exactly where the nav brand mark sits.
- Optional: 2–3 concentric thin gold-line circles pulsing outward behind the wordmark (opacity 0→0.4→0, scale 0.15→1→1.4), like VALMAX's ray/circle rings but gold instead of white.
- Unmount after animation completes (`display:none` or remove from DOM).

### 2. StarField → "Network field" canvas background
Port VALMAX's StarField algorithm directly but render gold/cream dots instead of white:
- Canvas absolutely positioned, resized via ResizeObserver + devicePixelRatio.
- Particles: random position, radius mostly 0.25–0.8px, opacity 0.2–0.9, each with a twinkle (sine wave) speed/offset.
- Per-frame: clear, draw each particle with alpha modulated by twinkle. Larger particles (r>1.1) get a soft radial glow.
- Use on hero, "Why we exist," and final waitlist sections at varying density (e.g. hero=700, why=500, finale=450). Lower density on mobile for performance.

### 3. LineField → gold connection lines
SVG overlay (viewBox 0 0 100 100, preserveAspectRatio none), thin gold lines (`stroke: var(--gold)`, `stroke-opacity: 0.10–0.15`, `stroke-width: 0.08`) connecting across the section diagonally — reads as "network." Animate `pathLength 0→1` + opacity 0→1 on scroll-into-view (IntersectionObserver), staggered per line, 1.2–1.4s, EASE. 4–6 lines per section, different coordinate sets per section so they don't feel copy-pasted. Skip the star/label markers from VALMAX — too literal for this brand.

### 4. Hero parallax
On `mousemove`, set CSS vars `--mx` / `--my` (normalized -0.5 to 0.5) on the hero section. Floating cards (see below) get `transform: translate3d(calc(var(--mx) * Npx), calc(var(--my) * Npx), 0)` with `transition: transform 0.4s ${EASE}`, each card a different `N` (depth) for parallax layering. Disable entirely on `prefers-reduced-motion` and on touch devices.

### 5. Floating credential cards (replaces VALMAX's photo collage)
5–7 small absolutely-positioned cards around the hero, each a dark glass card (`background: rgba(250,249,246,.04)`, `border: 1px solid var(--gold-line)`, `backdrop-filter: blur(8px)`, `border-radius: 14px`, subtle shadow). Each entrance: opacity 0→1, scale 0.92→1, blur(12px)→0, staggered. Sharp-ish corners, premium not playful. Content ideas (short label + micro-detail, like a notification/status card):
- "Co-Sign received" / a name placeholder
- "Warm intro available"
- "Private beta · Invite-only"
- "5 lifetime co-signs"
- "The Room · 90 days"
- "Reputation signal · +1"
- "Culture credential verified"

Position them around the hero text (corners, edges) at varying sizes — don't center-stack, don't overlap the headline.

### 6. Scroll-reveal upgrade
Current `.reveal` class does opacity+translateY. Add `filter: blur(12-16px) → blur(0)` to the transition for the VALMAX "blur-in" feel — apply to section headings, pullquote, and cards.

---

## Hard "don't do" list (carried over from brand brief)
- No mansion/doorway/private-club imagery or copy.
- No fake testimonials, fake metrics, stock photography.
- No phone mockups / dashboard UI unless explicitly requested.
- Don't replace phone capture with email; don't remove SMS consent copy.
- Don't remove the ATS/ghost-jobs narrative, advocate reel system, analytics scaffold, or Supabase TODOs.
- Keep gold as the only accent color — no new brand colors introduced.

## Negative references — "the four horsemen" (hard constraints)

Four visual patterns identified as generic AI-slop tells. None of these may appear anywhere in steps 2–4:

1. **No purple/indigo gradient blobs or glows.** Any soft radial/linear gradient drifting toward purple-blue is the canonical "default AI background" — banned outright. Glows, halos, and atmosphere stay gold-on-ink only, per the palette.
2. **No oversized, heavily tracked-out uppercase "headline as texture."** Giant letter-spacing on big type as a stand-in for "premium" reads as templated. Display type should carry weight through scale, weight, and the existing italic/strikethrough contrast — not extreme tracking.
3. **No generic floating status pills** (e.g. a dot + "Live"-style badge) that exist purely as decorative chrome with no real meaning. Every floating credential card must map to an actual LeverageBLK concept (Co-Sign, The Tap, The Room, etc.) — never a stock "notification" prop.
4. **No arbitrary decorative bracket/meter shapes** borrowed from system-notification UI (storage meters, odd curved brackets, etc.) used purely for visual texture. If a shape appears, it should read as part of the network/line-field system, not as floating UI debris.

## Steps 2–4: Goal mode — ✅ COMPLETE

Steps 2–4 (intro sequence; hero parallax + credential cards; remaining section backgrounds + blur-in reveal upgrade) shipped as one continuous build. All definition-of-done items verified: intro plays once via FLIP measured on live `getBoundingClientRect()`, NetField (700 particles, gold/cream, sine twinkle) + 5-path LineField on hero, rAF-lerp pointer parallax (LERP=0.075, 6 depth values, reduced-motion + touch disabled), 6 credential cards all mapped to real mechanics, distinct StarField/LineField densities + coordinates for Why (500) and Finale (450), blur-in reveal (14px) with reduced-motion override. Zero four-horsemen violations, all existing functionality intact.

**Remaining:** open it, scroll it, feel it — confirm intro timing on repeat loads, check for jank with 3 canvases running, test `prefers-reduced-motion` and mobile width. If it feels right, commit + deploy to Netlify for David/Raheem to react to.

## Punch list — pre-launch

Items below are independent of the visual layer and should be cleared before (or alongside) going live.

### Security — do before wiring real Supabase
- ✅ **Supabase RLS policy on the waitlist table** — DONE. `waitlist` table + `anon_insert_waitlist` (INSERT-only for `anon`) applied to the live project (`mkxtkjitjgzjkflhahto`) and verified: `relrowsecurity=TRUE`, single policy `anon_insert_waitlist | INSERT | {anon}`, no anon SELECT/UPDATE/DELETE. Insert wiring in `index.html` is live, so signups can now be driven safely.
- **Never expose the `service_role` key** in client-side JS — only the `anon` key belongs in the HTML. Relevant if/when any server-side function is added later.
- ✅ **Honeypot field** — DONE. Hidden `.hp-field` on both `index.html` forms; populated → `submit()` silently returns before hitting Supabase.
- **Firebase API key domain restriction** (Firebase console → API key settings): restrict to the production domain once one exists. Low urgency at current traffic, good hygiene before launch.

### Privacy / compliance
- ✅ **Privacy Policy page** — DONE (draft). `privacy.html` exists and is linked from the SMS-consent copy under both forms. Covers collection (phone, analytics), purpose, third-party processors, and removal. ⏳ Still needs a final pass from whoever's handling the LeverageBLK Corp legal structure — not legal advice from Claude.
- **A2P 10DLC registration**: not a landing-page item, but plan ahead — before sending real SMS blasts via Twilio/etc., register the business sender (10DLC or toll-free) or US carriers will silently filter the messages. Registration can take days, so start before the first real "you're invited" text needs to go out.
- **EU cookie/analytics consent**: Firebase Analytics technically counts as non-essential tracking under EU rules. Deprioritized given US-focused pre-launch traffic — revisit if EU visitor share becomes meaningful.

### SMS sending pipeline (new — closes the loop on "we'll text you")
- **SMS provider account** (Twilio recommended; Telnyx as a cheaper alternative at volume) — sign up using the LeverageBLK email, not a personal account. This is where A2P 10DLC registration (above) actually happens and where you get the phone number messages send *from*.
- **Send trigger**: Supabase storing a phone number doesn't message anyone by itself. Something needs to read new waitlist rows and call the SMS provider — options range from a Supabase Edge Function trigger, a simple scheduled script, to a no-code Zapier/Make bridge. Decide this once the provider account exists; not urgent before launch, but needed before the first real "you're invited" text goes out.

### Carried over from earlier sessions
- Firebase project config keys (paste into the placeholder `firebaseConfig`).
- ~~Canny/UserJot board URL~~ — superseded, see Step 5 below.
- Advocate video hosting decision + real `src` values in the `ADVOCATES` array.
- ✅ Supabase waitlist table schema + insert wiring — table + RLS applied to the live project and verified, insert wired in `index.html`. Fully live.

## Testing
Open the HTML files directly in a browser, or serve locally (`npx serve` / `python3 -m http.server`) for a localhost URL. No build step. Deploy by dragging the folder onto netlify.com — the main page is now **`index.html`** (renamed from `leverage-blk-landing.html`) so it serves at the site root; `inside.html` and `privacy.html` sit alongside it.

> **Integrations handoff:** the remaining wiring (Supabase table+RLS, Firebase keys, SMS pipeline) is captured in `INTEGRATIONS-HANDOFF.md` — a self-contained brief for a fresh session.

---

## Step 5: `/inside` page — "What you're getting in"

A second page (e.g. `inside.html`), public and linkable (no gate — usable for investor/partner shares as well as cold traffic). Same single-file-per-page approach, same gold-on-ink system, same `EASE`/blur-in/StarField/LineField techniques — but its own LineField coordinate set (third distinct "feel," after hero and Why/Finale) and its own pacing. This page's job is **vision, not proof** — second-person, present-tense-as-membership-experience. No member counts, no testimonials, no named schools, no pricing, anywhere on this page.

### Entry point (edit on main page)
Replace the current "Shape the Room" strip's CTA and copy. It now links to `inside.html` — something like "See what you're getting in →" — and is the *only* CTA in that strip. (The feature-request email moves to the bottom of `/inside` — see Section 05 below.)

### Section 01 — Open (problem framing, reframed as "why")
**Eyebrow:** Why we're building this

**Headline:**
"The unwritten rules of getting ahead were never written down. We're writing them down."

**Body** (reworked per fact-check — no specific stats that can't be sourced; same emotional weight via directionally-true claims instead):
"Entry-level postings have fallen sharply since 2023 — some tech roles by two-thirds. AI screening filters most resumes before a human ever sees them. The jobs that remain increasingly go to whoever's in the room, not whoever applied. That's true whether you went to an HBCU, a PWI, or skipped the degree entirely."

Numbering: continue from main page's 01/02 sequence — this page's sections are **03 / 04 / 05** (reads as "the next chapter" since it's linked directly from Shape the Room).

### Section 03 — Pillar: Circles ("you belong in")
**Eyebrow:** 03 — Circles

**Headline:** "Find your people. By industry. By city. By background — or no background at all."

**Body:** "Inside, you'll find Circles for your industry, your city, the school you went to — or the one you didn't. HBCU, PWI, bootcamp, military, self-taught, no degree at all: the work is the credential. Circles aren't a directory. They're rooms — for tech, for finance, for law and policy, for founders, for creative and media, and for whatever you bring that doesn't fit a category yet."

**Visual — Circle constellation:** A central "your room" node (the woven-background line above — slightly larger/brighter than the others) with 5 category cards (Tech, Finance, Law & Policy, Founders, Creative & Media) radiating outward at varying distances/sizes, connected to the center by thin gold lines drawn in via the LineField pathLength technique on scroll-into-view. 6 nodes total (within the established 5-7 floating-element range). Layout reference: central node ~100x60, category nodes ~140-160px wide at varying y-offsets, lines from each category node converging on the center — see the constellation sketch from this session for relative positioning (adapt coordinates to the page's actual viewBox/section dimensions, not a literal copy).

### Section 04 — Pillar: Playbooks
**Eyebrow:** 04 — Playbooks

**Headline:** "The unwritten rules, finally written down."

**Body:** "Every Playbook starts from the same place — nine fundamentals, grouped into three moves:

**Show up right** — the first impression, reading the room, dressing for it. Showing up as yourself, deliberately.

**Build what lasts** — the follow-up that actually works, sponsorship over mentorship, the office politics nobody explains. The relationships that move you forward.

**Get what you're owed** — code-switching strategically (not erasing yourself — knowing which register works in which room, and never apologizing for either), the cold DM that gets a reply, negotiating without apology. Confidence that doesn't require permission.

From there, Playbooks go deep on your world. The Wealth Room. The Term Sheet Playbook. More, by field, as Circles take shape."

**Visual — triptych:** Three cards (Show up right / Build what lasts / Get what you're owed), each listing its three fundamentals, staggered blur-in left to right.

### Section 05 — Close: Legacy membership + feature-request reveal
**Eyebrow:** Get in early

**Headline:** "This is what Legacy members are part of."

**Body:** "Everything here — every Circle, every Playbook, every Co-Sign — is what we're building toward, starting with the people who join first. Legacy membership isn't a discount. It's a seat at the table while the table's still being built."

**Tie-back CTA:** links to the waitlist on the main page (`index.html#waitlist`) — no duplicate form on this page.

**Feature-request reveal (two-stage CTA, important):** A second element — "Got an idea for what should be in here? Tell us →" with `href="mailto:leverageblk@gmail.com?subject=Feature%20Request"` — is part of this closing section's content, NOT a separate popup/banner. It uses the same blur-in reveal as everything else, triggered by `IntersectionObserver` watching this final section. Do not show this CTA anywhere earlier on the page or via a persistent/sticky element — it should only become visible once someone has scrolled to the bottom, as part of the natural reveal of this section. Track as `cta_click` with target `"feature_board"` (reuses the existing event name from the old Shape the Room strip).

### Co-Sign/Tap/Room reputation tiers (referenced from main page's existing mechanic cards, expanded here)
As trust builds: **Connector → Networker → Authority.** Copy includes "(more to come)" — do not present this as a finished/closed system. No visual implies a 4th tier exists yet; the open-endedness is conveyed by the copy alone.

### Hard constraints specific to this page
- No stats beyond the reworked Section 01 body — and that body is written to avoid citable-but-unverifiable specifics (no "70%", no "3x", no "60%").
- No member counts, testimonials, named schools/universities, or pricing anywhere on this page.
- "The Code Switch Playbook" as a *named product* does not appear — the concept lives only inside the "Get what you're owed" fundamental, with its reframing intact ("not erasing yourself... never apologizing for either").
- All existing hard "don't do" list items and the four-horsemen constraints (above) apply equally to this page.

## Step 5: `/inside` page — ✅ COMPLETE

Shipped as `inside.html`, reusing the main page's system (intro FLIP, NetField, LineField, blur-in reveal, gold-on-ink palette) with its own third distinct LineField coordinate sets. All Step 5 items verified in the local preview:
- **Open** (eyebrow "Why we're building this") + the reworked Section 01 body verbatim (no citable stats).
- **03 — Circles**: copy verbatim + the **Circle constellation** — central glowing "Your room" node with 5 category Circles (Tech, Finance, Law & Policy, Founders, Creative & Media) radiating out, connected by gold lines drawn via the `pathLength`/LineField technique on scroll-into-view (6 nodes total). Collapses to a readable stacked list under 760px ("Your room" first, lines hidden).
- **04 — Playbooks**: "finally written down" headline + triptych (Show up right / Build what lasts / Get what you're owed), three fundamentals each, staggered blur-in. Code-switch reframing intact; no named "Code Switch Playbook" product.
- **05 — Close**: "Get in early" → Legacy headline → tie-back CTA to `index.html#waitlist` (no duplicate form) → `Connector → Networker → Authority · more to come` tier pill → **feature-request reveal** ("Tell us →", `mailto:leverageblk@gmail.com`) that only surfaces as the final section reveals. Tracks `cta_click` / `target:'feature_board'`.

**Entry point** (main page): the old "Shape the Room" strip is now the single CTA "See what you're getting in →" → `inside.html` (tracks `inside_page`). Zero four-horsemen violations; constraints above all upheld. No console errors; mobile + reduced-motion paths verified.
