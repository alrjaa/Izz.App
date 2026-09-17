create extension if not exists "pgcrypto";

create type user_role as enum ('admin', 'owner', 'follower', 'sponsor');
create type animal_type as enum ('camel_mazayin', 'camel_hejin');
create type mazayin_color as enum ('مجاهيم', 'وضُح', 'شقَح', 'حمُر', 'صُفُر', 'شعُل');
create type age_class as enum ('مفرودة', 'حقّة', 'لقيّة', 'جذعة', 'ثنيّة', 'حيلة', 'قاdoc');
create type competition_type as enum ('mazayin', 'hejin');
create type competition_status as enum ('upcoming', 'live', 'completed');
create type media_type as enum ('image', 'video');
create type sponsor_tier as enum ('platinum', 'gold', 'silver', 'partner');

create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  full_name varchar(200) not null,
  phone_number varchar(20) not null unique,
  email varchar(200),
  role user_role not null default 'follower',
  avatar_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.owner_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users(id) on delete cascade,
  cattery_or_stable_name varchar(255) not null,
  logo_url text,
  bio text,
  verified_status boolean not null default false,
  social_links jsonb not null default '{}'::jsonb
);

create table if not exists public.competitions (
  id uuid primary key default gen_random_uuid(),
  title varchar(255) not null,
  type competition_type not null,
  location varchar(255) not null,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  start_date timestamptz not null,
  end_date timestamptz not null,
  status competition_status not null default 'upcoming',
  banner_url text
);

create table if not exists public.animals (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.owner_profiles(id) on delete cascade,
  type animal_type not null,
  name varchar(255) not null,
  microchip_number varchar(100) not null unique,
  category_color mazayin_color,
  age_class age_class not null,
  father_name varchar(255),
  mother_name varchar(255),
  birth_year integer,
  avatar_url text
);

create table if not exists public.rounds_or_categories (
  id uuid primary key default gen_random_uuid(),
  competition_id uuid not null references public.competitions(id) on delete cascade,
  title varchar(255) not null,
  distance integer,
  scheduled_time timestamptz not null
);

create table if not exists public.prizes (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references public.rounds_or_categories(id) on delete cascade,
  rank integer not null,
  prize_description text not null
);

create table if not exists public.animal_achievements (
  id uuid primary key default gen_random_uuid(),
  animal_id uuid not null references public.animals(id) on delete cascade,
  competition_id uuid not null references public.competitions(id) on delete cascade,
  rank integer not null,
  timing varchar(50),
  points_or_score numeric(10, 2),
  achievement_date date not null
);

create table if not exists public.media (
  id uuid primary key default gen_random_uuid(),
  uploader_id uuid not null references public.users(id) on delete cascade,
  competition_id uuid references public.competitions(id) on delete set null,
  animal_id uuid references public.animals(id) on delete set null,
  media_type media_type not null,
  media_url text not null,
  thumbnail_url text,
  views_count integer not null default 0,
  likes_count integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.sponsors (
  id uuid primary key default gen_random_uuid(),
  competition_id uuid not null references public.competitions(id) on delete cascade,
  name varchar(255) not null,
  tier sponsor_tier not null,
  logo_url text,
  website_url text
);

alter table public.users enable row level security;
alter table public.owner_profiles enable row level security;
alter table public.animals enable row level security;
alter table public.animal_achievements enable row level security;
alter table public.competitions enable row level security;
alter table public.rounds_or_categories enable row level security;
alter table public.prizes enable row level security;
alter table public.media enable row level security;
alter table public.sponsors enable row level security;

create policy "public can read competitions" on public.competitions
  for select using (true);

create policy "public can read rounds" on public.rounds_or_categories
  for select using (true);

create policy "public can read prizes" on public.prizes
  for select using (true);

create policy "public can read sponsors" on public.sponsors
  for select using (true);

create policy "authenticated can read media" on public.media
  for select using (auth.uid() is not null);

create policy "authenticated can upload media" on public.media
  for insert with check (
    auth.uid() is not null
    and exists (
      select 1 from public.users u
      where u.id = uploader_id and u.auth_user_id = auth.uid()
    )
  );

create policy "owner can manage own profile" on public.owner_profiles
  for all using (
    exists (
      select 1 from public.users u
      where u.id = owner_profiles.user_id and u.auth_user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.users u
      where u.id = owner_profiles.user_id and u.auth_user_id = auth.uid()
    )
  );

create policy "owner can manage own animals" on public.animals
  for all using (
    exists (
      select 1
      from public.owner_profiles op
      join public.users u on u.id = op.user_id
      where op.id = animals.owner_id and u.auth_user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.owner_profiles op
      join public.users u on u.id = op.user_id
      where op.id = animals.owner_id and u.auth_user_id = auth.uid()
    )
  );

create policy "admin full access users" on public.users
  for all using (
    exists (
      select 1 from public.users u
      where u.auth_user_id = auth.uid() and u.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.users u
      where u.auth_user_id = auth.uid() and u.role = 'admin'
    )
  );

create policy "admin manage achievements" on public.animal_achievements
  for all using (
    exists (
      select 1 from public.users u
      where u.auth_user_id = auth.uid() and u.role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from public.users u
      where u.auth_user_id = auth.uid() and u.role = 'admin'
    )
  );
