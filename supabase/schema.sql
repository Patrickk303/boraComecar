-- XequeMate: execute this migration in the Supabase SQL Editor.
create extension if not exists pgcrypto;

create type public.tournament_system as enum ('swiss', 'round_robin');
create type public.tournament_status as enum ('draft', 'active', 'finished');
create type public.match_result as enum ('white_win', 'black_win', 'draw', 'white_walkover', 'black_walkover');

create table public.tournaments (
  id uuid primary key default gen_random_uuid(), referee_id uuid not null references auth.users(id) on delete cascade,
  name text not null, city text, event_date date not null, rounds smallint not null check (rounds > 0),
  system tournament_system not null default 'swiss', time_control text, code text not null unique default upper('XAD' || substr(replace(gen_random_uuid()::text, '-', ''), 1, 3)),
  status tournament_status not null default 'draft', walkover_points numeric(3,1) not null default 1,
  created_at timestamptz not null default now()
);
create table public.players (id uuid primary key default gen_random_uuid(), tournament_id uuid not null references public.tournaments(id) on delete cascade, name text not null, fide_rating integer, club text, category text, created_at timestamptz default now());
create table public.rounds (id uuid primary key default gen_random_uuid(), tournament_id uuid not null references public.tournaments(id) on delete cascade, number smallint not null, unique(tournament_id, number));
create table public.matches (id uuid primary key default gen_random_uuid(), round_id uuid not null references public.rounds(id) on delete cascade, board smallint not null, white_player_id uuid not null references public.players(id), black_player_id uuid not null references public.players(id), result match_result, unique(round_id, board));

alter table public.tournaments enable row level security; alter table public.players enable row level security; alter table public.rounds enable row level security; alter table public.matches enable row level security;
create policy "Public can read tournaments" on public.tournaments for select using (true);
create policy "Referees manage their tournaments" on public.tournaments for all using (auth.uid() = referee_id) with check (auth.uid() = referee_id);
create policy "Public can read players" on public.players for select using (true);
create policy "Referees manage players" on public.players for all using (exists(select 1 from public.tournaments t where t.id=tournament_id and t.referee_id=auth.uid()));
create policy "Public can read rounds" on public.rounds for select using (true);
create policy "Referees manage rounds" on public.rounds for all using (exists(select 1 from public.tournaments t where t.id=tournament_id and t.referee_id=auth.uid()));
create policy "Public can read matches" on public.matches for select using (true);
create policy "Referees manage matches" on public.matches for all using (exists(select 1 from public.rounds r join public.tournaments t on t.id=r.tournament_id where r.id=round_id and t.referee_id=auth.uid()));
alter publication supabase_realtime add table public.tournaments, public.players, public.rounds, public.matches;
