-- SmarterPaw Channel Planner v2.65 — workspace-aware uniqueness on lists
-- The original lists table has UNIQUE(kind, name). That blocks Innovation from having its own
-- `(brand, Meowi)` / `(person, Jason)` / `(channel, PetSmart)` rows because Planner already uses them.
-- Rewrite the constraint to include workspace so each workspace keeps its own namespace.
--
-- Run once in Supabase: SQL Editor → New query → paste → Run. Safe to re-run.

alter table public.lists drop constraint if exists lists_kind_name_key;
alter table public.lists add constraint lists_kind_name_workspace_key unique (kind, name, workspace);
