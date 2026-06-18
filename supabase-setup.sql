-- ============================================================
--  LeverageBLK — Supabase waitlist setup
--  Run this in the Supabase SQL Editor (leverageblk project).
--  Safe to re-run: uses IF NOT EXISTS / OR REPLACE throughout.
-- ============================================================


-- ── 1. WAITLIST TABLE ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS waitlist (
  id          bigint       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  phone       text         NOT NULL,
  source      text         NOT NULL DEFAULT 'unknown',   -- 'hero' | 'finale'
  created_at  timestamptz  NOT NULL DEFAULT now()
);

-- Prevent exact duplicate phone submissions (optional but recommended)
CREATE UNIQUE INDEX IF NOT EXISTS waitlist_phone_unique ON waitlist (phone);

-- Index for admin queries by time (e.g. "how many signups today")
CREATE INDEX IF NOT EXISTS waitlist_created_at_idx ON waitlist (created_at DESC);


-- ── 2. ROW-LEVEL SECURITY ────────────────────────────────────
--
--  Goal: the anon key (public, in client-side HTML) can INSERT
--  new rows — and nothing else. SELECT / UPDATE / DELETE are
--  denied to every role that isn't service_role.
--
--  service_role bypasses RLS by default; use it only server-side
--  (Edge Functions, admin scripts) — never in the browser.

ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;

-- Drop & recreate policies so this script is idempotent
DROP POLICY IF EXISTS "anon_insert_waitlist"  ON waitlist;
DROP POLICY IF EXISTS "anon_select_waitlist"  ON waitlist;

-- Allow anon INSERT only
CREATE POLICY "anon_insert_waitlist"
  ON waitlist
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Explicitly deny anon SELECT (belt + suspenders — RLS denies by default,
-- but an explicit DENY policy makes the intent obvious to future maintainers)
-- Note: Postgres RLS has no DENY keyword; omitting a permissive SELECT policy
-- is the correct way to block it. The comment below is the documentation.
--
-- No SELECT policy for anon → anon cannot read any rows. ✓
-- No UPDATE policy for anon → anon cannot update any rows. ✓
-- No DELETE policy for anon → anon cannot delete any rows. ✓


-- ── 3. VERIFY (run in SQL Editor to confirm setup) ───────────
--
-- Check RLS is on:
--   SELECT relname, relrowsecurity FROM pg_class WHERE relname = 'waitlist';
--   → relrowsecurity should be TRUE
--
-- Check policies:
--   SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'waitlist';
--   → should show one row: anon_insert_waitlist | INSERT | {anon}
--
-- Test anon insert (simulates the browser):
--   SET ROLE anon;
--   INSERT INTO waitlist (phone, source) VALUES ('+12125550100', 'hero');
--   SELECT * FROM waitlist;   -- should return 0 rows (anon can't read)
--   RESET ROLE;
--
-- Test service_role (admin):
--   SELECT * FROM waitlist;   -- service_role bypasses RLS, sees all rows ✓


-- ── 4. WIRING NOTE ───────────────────────────────────────────
--
--  In leverage-blk-landing.html, replace the TODO comment with:
--
--    import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
--    const supabase = createClient(
--      'https://YOUR_PROJECT_REF.supabase.co',
--      'YOUR_ANON_KEY'         // ← public key only, never service_role
--    );
--
--    // then inside the submit() function:
--    const { error } = await supabase
--      .from('waitlist')
--      .insert({ phone: input.value, source });
--    if (error && error.code !== '23505') {  // 23505 = unique_violation (already signed up)
--      console.error('Supabase insert error:', error);
--      return;
--    }
--
--  The unique index on `phone` (step 1 above) means a duplicate
--  submission returns a 23505 error rather than inserting a duplicate row.
--  Treat that as a success in the UI ("you're already on the list").
