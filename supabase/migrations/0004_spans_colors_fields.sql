-- SmarterPaw Channel Planner v1.4 — end dates, saved colors, custom fields
-- Run once in Supabase: SQL Editor → New query → paste → Run.

-- end date (deliverables can span days on the calendar) + custom field values
alter table public.deliverables add column if not exists end_date date;
alter table public.deliverables add column if not exists fields jsonb not null default '{}'::jsonb;

-- saved colors + two new list kinds: 'brand' (color only) and 'field' (custom fields)
alter table public.lists add column if not exists color text;
alter table public.lists drop constraint if exists lists_kind_check;
alter table public.lists add constraint lists_kind_check check (kind in ('channel','person','status','brand','field'));

-- seed brand colors so they're editable like everything else
insert into public.lists (kind, name, color, position) values
  ('brand', 'Meowi', '#6d5dfc', 1),
  ('brand', 'Doggi', '#f5a524', 2),
  ('brand', 'Kitty', '#ec4899', 3)
on conflict (kind, name) do nothing;
