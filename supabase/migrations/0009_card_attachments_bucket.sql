-- Card attachments — Supabase Storage bucket for PDFs, spreadsheets, and other non-image files
-- attached to Planner cards. Images continue to live inline in the deliverables row's `fields` blob
-- (data URLs, ~30-80KB each); files go here instead to keep rows small.

insert into storage.buckets (id, name, public, file_size_limit)
values ('card-attachments', 'card-attachments', true, 26214400)  -- 25 MB per file
on conflict (id) do update set public = excluded.public, file_size_limit = excluded.file_size_limit;

-- Anon has full CRUD on this bucket's objects, matching the rest of the planner's model
-- (the deliverables table itself is anon-accessible; auth is scoped to the app, not the DB).

drop policy if exists "card-attachments anon read" on storage.objects;
create policy "card-attachments anon read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'card-attachments');

drop policy if exists "card-attachments anon insert" on storage.objects;
create policy "card-attachments anon insert"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'card-attachments');

drop policy if exists "card-attachments anon update" on storage.objects;
create policy "card-attachments anon update"
  on storage.objects for update
  to anon, authenticated
  using (bucket_id = 'card-attachments');

drop policy if exists "card-attachments anon delete" on storage.objects;
create policy "card-attachments anon delete"
  on storage.objects for delete
  to anon, authenticated
  using (bucket_id = 'card-attachments');
