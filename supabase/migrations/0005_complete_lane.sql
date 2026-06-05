-- SmarterPaw Channel Planner v1.10 — mark a lane as the "complete" lane
-- Run once in Supabase: SQL Editor → New query → paste → Run.

alter table public.lists add column if not exists is_complete boolean not null default false;
