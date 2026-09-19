create extension if not exists pgcrypto;

create type public.app_role as enum ('follower', 'owner', 'sponsor', 'organizer', 'admin');
create type public.publish_status as enum ('draft', 'pending', 'approved', 'archived');
create type public.content_kind as enum ('post', 'video');
create type public.link_kind as enum ('owner', 'camel', 'championship', 'competition', 'sponsor');
create type public.report_target_kind as enum ('user', 'owner', 'camel', 'content', 'comment', 'result');

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  role public.app_role not null default 'follower',
  display_name text not null,
  email text unique,
  locale text not null default 'ar',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.owners (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete set null,
  name_ar text not null,
  name_en text,
  region text,
  bio text,
  is_verified boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.sponsors (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete set null,
  name_ar text not null,
  name_en text,
  website_url text,
  logo_url text,
  about text,
  created_at timestamptz not null default now()
);

create table if not exists public.camels (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.owners(id) on delete cascade,
  name_ar text not null,
  name_en text,
  gender text,
  age_label text,
  color text,
  registration_code text unique,
  summary text,
  created_at timestamptz not null default now()
);

create index if not exists camels_owner_idx on public.camels(owner_id);
create index if not exists camels_name_ar_idx on public.camels(name_ar);

create table if not exists public.camel_media (
  id uuid primary key default gen_random_uuid(),
  camel_id uuid not null references public.camels(id) on delete cascade,
  media_type text not null,
  file_path text not null,
  mime_type text,
  file_size_bytes bigint,
  created_at timestamptz not null default now()
);

create table if not exists public.achievements (
  id uuid primary key default gen_random_uuid(),
  camel_id uuid references public.camels(id) on delete cascade,
  owner_id uuid references public.owners(id) on delete cascade,
  title text not null,
  description text,
  happened_on date
);

create table if not exists public.championships (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  name_en text,
  location text,
  season text,
  starts_on date,
  ends_on date,
  status public.publish_status not null default 'draft',
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.competitions (
  id uuid primary key default gen_random_uuid(),
  championship_id uuid not null references public.championships(id) on delete cascade,
  name_ar text not null,
  name_en text,
  status public.publish_status not null default 'draft',
  created_at timestamptz not null default now()
);

create index if not exists competitions_championship_idx on public.competitions(championship_id);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  competition_id uuid not null references public.competitions(id) on delete cascade,
  name_ar text not null,
  name_en text,
  code text,
  created_at timestamptz not null default now()
);

create table if not exists public.rounds (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories(id) on delete cascade,
  name_ar text not null,
  name_en text,
  round_order int not null default 1,
  status public.publish_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table if not exists public.participants (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references public.rounds(id) on delete cascade,
  camel_id uuid not null references public.camels(id) on delete cascade,
  owner_id uuid not null references public.owners(id) on delete cascade,
  lane_no int,
  bib_no text,
  created_at timestamptz not null default now(),
  unique(round_id, camel_id)
);

create table if not exists public.awards (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references public.rounds(id) on delete cascade,
  place_no int not null,
  title text not null,
  amount numeric(12,2),
  sponsor_id uuid references public.sponsors(id) on delete set null,
  created_at timestamptz not null default now(),
  unique(round_id, place_no)
);

create table if not exists public.results (
  id uuid primary key default gen_random_uuid(),
  participant_id uuid not null references public.participants(id) on delete cascade,
  position int not null,
  score numeric(8,2),
  notes text,
  status public.publish_status not null default 'pending',
  is_official boolean not null default false,
  approved_by uuid references public.profiles(id) on delete set null,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(participant_id)
);

create index if not exists results_status_idx on public.results(status, is_official);
create index if not exists results_position_idx on public.results(position);

create table if not exists public.winner_cards (
  id uuid primary key default gen_random_uuid(),
  result_id uuid not null unique references public.results(id) on delete cascade,
  verification_code text not null unique,
  badge_title text not null,
  printable_snapshot_path text,
  created_at timestamptz not null default now()
);

create table if not exists public.sponsorships (
  id uuid primary key default gen_random_uuid(),
  sponsor_id uuid not null references public.sponsors(id) on delete cascade,
  championship_id uuid references public.championships(id) on delete cascade,
  competition_id uuid references public.competitions(id) on delete cascade,
  package_name text,
  amount numeric(12,2),
  created_at timestamptz not null default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  author_profile_id uuid not null references public.profiles(id) on delete cascade,
  kind public.content_kind not null default 'post',
  title text,
  body text not null,
  media_url text,
  linked_kind public.link_kind not null,
  linked_id uuid not null,
  status public.publish_status not null default 'approved',
  created_at timestamptz not null default now()
);

create index if not exists posts_link_idx on public.posts(linked_kind, linked_id, created_at desc);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  author_profile_id uuid not null references public.profiles(id) on delete cascade,
  parent_comment_id uuid references public.comments(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.likes (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(post_id, profile_id)
);

create table if not exists public.saves (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(post_id, profile_id)
);

create table if not exists public.follows (
  id uuid primary key default gen_random_uuid(),
  follower_profile_id uuid not null references public.profiles(id) on delete cascade,
  target_kind public.link_kind not null,
  target_id uuid not null,
  created_at timestamptz not null default now(),
  unique(follower_profile_id, target_kind, target_id)
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  route text,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_profile_id uuid not null references public.profiles(id) on delete cascade,
  target_kind public.report_target_kind not null,
  target_id uuid not null,
  reason text not null,
  status public.publish_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table if not exists public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  request_type text not null,
  status public.publish_status not null default 'pending',
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.permissions (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  description text not null
);

create table if not exists public.role_permissions (
  role public.app_role not null,
  permission_id uuid not null references public.permissions(id) on delete cascade,
  primary key (role, permission_id)
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_profile_id uuid references public.profiles(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid not null,
  details text,
  created_at timestamptz not null default now()
);
