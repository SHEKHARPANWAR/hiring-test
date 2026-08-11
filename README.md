# Syrma SGS · Training Assessment Portal

A self-contained, single-file training assessment site — Level 0 (Induction), Level 1,
and ESD Awareness tests — with an admin dashboard, charts, Excel export, and
Supabase-backed score storage.

## Files in this repo

| File                  | Purpose                                                        |
|------------------------|-----------------------------------------------------------------|
| `index.html`           | The entire website (HTML + CSS + JS, no build step required)    |
| `supabase-setup.sql`   | One-time SQL to create the results table in your Supabase project |

## 1. Set up Supabase (one-time)

1. Open your project → **SQL Editor** → **New query**.
2. Paste in the contents of `supabase-setup.sql` and click **Run**.
   This creates a `test_submissions` table and the Row Level Security
   policies that let the site's public key insert/read/delete rows.
3. The site is already pointed at:
   - Project URL: `https://zsmklcrmjtpwfvmsstpc.supabase.co`
   - Anon key: `sb_publishable_upF29T-8A0VKA3vpS_11Jg_xIPPsNV_`

   If you ever rotate the anon key or move to a different Supabase project,
   update the two constants near the top of the `<script>` section in
   `index.html`:
   ```js
   const SUPABASE_URL = 'https://your-project.supabase.co';
   const SUPABASE_ANON_KEY = 'your-anon-key';
   ```

## 2. Deploy to GitHub Pages

1. Create a new GitHub repository (public or private, both work with Pages
   on a paid plan; public repos get Pages free).
2. Add `index.html` and `supabase-setup.sql` to the repo root and push:
   ```bash
   git init
   git add index.html supabase-setup.sql README.md
   git commit -m "Initial commit: training assessment portal"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<your-repo>.git
   git push -u origin main
   ```
3. In the GitHub repo, go to **Settings → Pages**.
4. Under **Build and deployment → Source**, choose **Deploy from a branch**.
5. Branch: `main`, folder: `/ (root)` → **Save**.
6. GitHub gives you a live URL shortly after
   (`https://<your-username>.github.io/<your-repo>/`). Open it — the app
   works immediately, no server or build step needed.

## 3. Using the site

- **Employees**: enter their details once (Name, Employee Code, Department,
  Date, Trainer), then pick any of the 3 tests. Each submission is scored
  instantly (70% to pass) and saved to Supabase.
- **Admin**: click **Admin** in the top bar. Passcode is `syrma@admin`
  (change it by editing `ADMIN_PASSCODE` in `index.html` — search for that
  constant). The dashboard shows live stats, charts, a searchable/filterable/
  sortable results table, and an **Export to Excel** button.
- **Import legacy data**: if you have older results saved from a previous
  version of this app (stored in Claude's artifact storage rather than
  Supabase), the admin dashboard has an **Import legacy data** button that
  copies them across once, safely (re-clicking won't duplicate rows).

## Notes & limitations

- This is a static, backend-less site — the Supabase anon key is visible in
  the page source, and the admin passcode is a simple client-side gate, not
  real authentication. That's fine for an internal tool on a private network
  or unlisted URL, but don't treat it as public-facing without adding proper
  auth (e.g. Supabase Auth) and tighter Row Level Security policies.
- Chart.js and SheetJS (used for charts and Excel export) load from
  `cdnjs.cloudflare.com` at runtime, so the page needs internet access to
  render those two features — everything else works fully offline once
  loaded.
