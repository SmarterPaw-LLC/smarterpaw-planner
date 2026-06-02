# SmarterPaw Channel Planner

A lightweight Kanban planner for marketing-channel deliverables across **Meowi**, **Doggi**, and **Kitty** — organic social, email, Meta campaigns, and web/landing pages.

- **Frontend:** single static `index.html` (no build step), hosted on GitHub Pages
- **Backend:** Supabase (Postgres) with live realtime sync across everyone who has the board open
- **Fallback:** if no Supabase keys are set, it runs in local-only mode (saves to your browser)

## Board

Columns: **Backlog → In Progress → Review → Scheduled → Live**. Drag cards between columns to change status. Each card carries brand, channel, owner, due date, and notes. Filter by brand/channel, search, and export to Excel (`.xlsx`), CSV, or a JSON backup.

## Setup

### 1. Supabase
1. Create a project at [supabase.com](https://supabase.com).
2. Open **SQL Editor → New query**, paste the contents of [`supabase/migrations/0001_init.sql`](supabase/migrations/0001_init.sql), and **Run**. This creates the `deliverables` table, RLS policies, realtime, and seed rows.
3. Go to **Project Settings → API** and copy the **Project URL** and the **anon / public** key.

### 2. Connect the app
Paste those two values into [`config.js`](config.js):
```js
window.PLANNER_CONFIG = {
  url:     "https://YOURPROJECT.supabase.co",
  anonKey: "eyJhbGci....",
};
```
The anon key is a **public** key — safe to commit. Access is controlled by the database RLS policies.

### 3. Host on GitHub Pages
In the repo: **Settings → Pages → Build and deployment → Source: Deploy from a branch → `main` / root**. Your board goes live at `https://<user>.github.io/<repo>/`.

## Security model

Currently in **open mode**: anyone with the URL can read and edit. Because this repo is public, that means the board is effectively open to anyone who finds it. Fine for low-stakes internal planning — keep JSON backups. To lock it down to a logged-in team, run the **Team login** block at the bottom of the migration and enable Email auth in Supabase.

## Local development

Just open `index.html` in a browser. With keys in `config.js` it talks to Supabase; without them it runs local-only.
