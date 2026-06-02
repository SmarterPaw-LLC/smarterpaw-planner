-- SmarterPaw Channel Planner — channels & people lists
-- Run once in Supabase: SQL Editor → New query → paste → Run.

create table if not exists public.lists (
  id          uuid primary key default gen_random_uuid(),
  kind        text not null check (kind in ('channel','person')),
  name        text not null,
  position    double precision not null default 0,
  created_at  timestamptz not null default now(),
  unique (kind, name)
);

alter table public.lists enable row level security;

drop policy if exists "lists_select" on public.lists;
drop policy if exists "lists_insert" on public.lists;
drop policy if exists "lists_update" on public.lists;
drop policy if exists "lists_delete" on public.lists;

create policy "lists_select" on public.lists for select using (true);
create policy "lists_insert" on public.lists for insert with check (true);
create policy "lists_update" on public.lists for update using (true) with check (true);
create policy "lists_delete" on public.lists for delete using (true);

alter publication supabase_realtime add table public.lists;

-- seed current channels + people (safe to edit later from the Manage panel)
insert into public.lists (kind, name, position) values
  ('channel', 'Organic Social', 1),
  ('channel', 'Email',          2),
  ('channel', 'Meta Campaigns', 3),
  ('channel', 'Web / Landing',  4),
  ('person',  'Jason',          1),
  ('person',  'Brennan',        2)
on conflict (kind, name) do nothing;
