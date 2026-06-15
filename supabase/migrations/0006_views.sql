-- SmarterPaw Channel Planner v1.43 — app-wide saved views
-- Run once in Supabase: SQL Editor → New query → paste → Run.
-- (Personal "Just me" views work without this; this enables the shared, app-wide ones.)

create table if not exists public.views (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  params      text not null default '',
  created_at  timestamptz not null default now()
);

alter table public.views enable row level security;

drop policy if exists "views_select" on public.views;
drop policy if exists "views_insert" on public.views;
drop policy if exists "views_update" on public.views;
drop policy if exists "views_delete" on public.views;

create policy "views_select" on public.views for select using (true);
create policy "views_insert" on public.views for insert with check (true);
create policy "views_update" on public.views for update using (true) with check (true);
create policy "views_delete" on public.views for delete using (true);

alter publication supabase_realtime add table public.views;
