-- SmarterPaw Channel Planner v2.59 — workspaces (Chunk 1 of 4)
-- Introduces a `workspace` column on deliverables, lists, and views so a second workspace
-- (Product Innovation) can live alongside the Channel Planner without their cards, fields,
-- lanes, or saved views crossing streams. Existing rows backfill to 'planner'.
--
-- Run once in Supabase: SQL Editor → New query → paste → Run. Safe to re-run.

-- deliverables: workspace scope
alter table public.deliverables add column if not exists workspace text not null default 'planner';
create index if not exists deliverables_workspace_idx on public.deliverables(workspace);

-- lists: scope custom fields, status lanes, channels, people, brands per workspace
alter table public.lists add column if not exists workspace text not null default 'planner';
create index if not exists lists_workspace_idx on public.lists(workspace);

-- views: saved views are workspace-local
alter table public.views add column if not exists workspace text not null default 'planner';
create index if not exists views_workspace_idx on public.views(workspace);
