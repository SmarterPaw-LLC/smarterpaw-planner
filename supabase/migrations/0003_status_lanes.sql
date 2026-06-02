-- SmarterPaw Channel Planner — make Kanban lanes (statuses) editable
-- Run once in Supabase: SQL Editor → New query → paste → Run.

-- allow a third list kind: 'status' (the board lanes)
alter table public.lists drop constraint if exists lists_kind_check;
alter table public.lists add constraint lists_kind_check check (kind in ('channel','person','status'));

-- seed the current 5 lanes (safe to edit/reorder later from the Manage panel)
insert into public.lists (kind, name, position) values
  ('status', 'Backlog',     1),
  ('status', 'In Progress', 2),
  ('status', 'Review',      3),
  ('status', 'Scheduled',   4),
  ('status', 'Live',        5)
on conflict (kind, name) do nothing;
