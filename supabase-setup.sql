-- ============================================================
-- Syrma SGS Training Assessment — Supabase table setup
-- Run this once in: Supabase Dashboard → SQL Editor → New query
-- Project: zsmklcrmjtpwfvmsstpc
-- ============================================================

create table if not exists public.test_submissions (
  id            text primary key,
  name          text not null,
  code          text not null,
  dept          text not null,
  trainer       text not null,
  test_date     date not null,
  test          text not null,          -- 'ESD' | 'L1' | 'L0'
  test_name     text not null,          -- display name of the test
  correct       int  not null,
  total         int  not null,
  score         int  not null,          -- percentage, 0-100
  result        text not null,          -- 'PASS' | 'FAIL'
  submitted_at  timestamptz not null default now()
);

-- Helpful indexes for the admin dashboard's filters/sorts
create index if not exists idx_test_submissions_test        on public.test_submissions (test);
create index if not exists idx_test_submissions_dept         on public.test_submissions (dept);
create index if not exists idx_test_submissions_result       on public.test_submissions (result);
create index if not exists idx_test_submissions_submitted_at on public.test_submissions (submitted_at desc);

-- Row Level Security: required by Supabase before the anon (public) key
-- can read/write. Since this is an internal, no-login tool, we allow the
-- anon key to insert, select, and delete rows in this one table only.
alter table public.test_submissions enable row level security;

drop policy if exists "public can insert" on public.test_submissions;
create policy "public can insert" on public.test_submissions
  for insert to anon
  with check (true);

drop policy if exists "public can select" on public.test_submissions;
create policy "public can select" on public.test_submissions
  for select to anon
  using (true);

-- Only needed for the "Reset all submission data" button in the admin
-- dashboard. Skip this policy if you don't want that button to work.
drop policy if exists "public can delete" on public.test_submissions;
create policy "public can delete" on public.test_submissions
  for delete to anon
  using (true);
