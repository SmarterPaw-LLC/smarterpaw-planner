-- SmarterPaw Channel Planner — initial schema
-- Run this in the Supabase dashboard: SQL Editor → New query → paste → Run.

create extension if not exists "pgcrypto";

create table if not exists public.deliverables (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  brand       text not null,
  channel     text not null,
  owner       text not null default '',
  due         date,
  status      text not null default 'Backlog',
  notes       text not null default '',
  position    double precision not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- keep updated_at fresh on every change
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_touch_updated_at on public.deliverables;
create trigger trg_touch_updated_at
  before update on public.deliverables
  for each row execute function public.touch_updated_at();

-- ── Row Level Security ────────────────────────────────────────────────
-- OPEN MODE (current choice): anyone with the anon key can read & write.
alter table public.deliverables enable row level security;

drop policy if exists "open_select" on public.deliverables;
drop policy if exists "open_insert" on public.deliverables;
drop policy if exists "open_update" on public.deliverables;
drop policy if exists "open_delete" on public.deliverables;

create policy "open_select" on public.deliverables for select using (true);
create policy "open_insert" on public.deliverables for insert with check (true);
create policy "open_update" on public.deliverables for update using (true) with check (true);
create policy "open_delete" on public.deliverables for delete using (true);

-- realtime so every open board updates live
alter publication supabase_realtime add table public.deliverables;

-- ── Seed data (safe to delete later from the board UI) ────────────────
insert into public.deliverables (title, brand, channel, owner, status, notes) values
  ('July sale teaser reels (3x)', 'Meowi', 'Organic Social', 'Brennan', 'Backlog',     'Hook on Super Zoomies. Vertical 9:16.'),
  ('Prime Day price drop email',  'Meowi', 'Email',          'Jason',   'In Progress', 'Klaviyo flow + one-off blast.'),
  ('Doggi summer collection',     'Doggi', 'Meta Campaigns', '',        'Review',      'ABO test, 3 creatives.'),
  ('Kitty refill landing page',   'Kitty', 'Web / Landing',  'Jason',   'Scheduled',   'Promo banner + bundle upsell.'),
  ('Doggi weekly grid posts',     'Doggi', 'Organic Social', 'Brennan', 'Live',        '');


-- ══════════════════════════════════════════════════════════════════════
-- OPTIONAL — TEAM LOGIN MODE
-- To lock the board down later (only logged-in users can edit), run this
-- block instead of the open policies above, then enable Email auth in
-- Supabase → Authentication. Leave it commented for now.
--
--   drop policy if exists "open_insert" on public.deliverables;
--   drop policy if exists "open_update" on public.deliverables;
--   drop policy if exists "open_delete" on public.deliverables;
--   create policy "auth_insert" on public.deliverables for insert to authenticated with check (true);
--   create policy "auth_update" on public.deliverables for update to authenticated using (true) with check (true);
--   create policy "auth_delete" on public.deliverables for delete to authenticated using (true);
--   -- (keep open_select if you still want public read, or restrict it to authenticated too)
-- ══════════════════════════════════════════════════════════════════════
