-- Packman Entregas — tabela de pedidos
create extension if not exists pgcrypto;

create table if not exists public.delivery_requests (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  from_cep text,
  to_cep text,
  from_street text not null,
  from_number text not null,
  from_district text not null,
  from_complement text,
  to_street text not null,
  to_number text not null,
  to_district text not null,
  to_complement text,
  vehicle text not null default 'moto' check (vehicle in ('moto','carro','utilitario')),
  notes text,
  distance_km numeric(10,3),
  duration_min integer,
  estimated_price numeric(10,2),
  status text not null default 'pending' check (status in ('pending','accepted','in_progress','delivered','cancelled'))
);

alter table public.delivery_requests enable row level security;

-- Permite ao site público criar pedidos sem login.
drop policy if exists "public can insert delivery requests" on public.delivery_requests;
create policy "public can insert delivery requests"
on public.delivery_requests for insert
to anon, authenticated
with check (true);

-- Não libera leitura pública dos pedidos.
drop policy if exists "public can read delivery requests" on public.delivery_requests;

create index if not exists delivery_requests_created_at_idx on public.delivery_requests(created_at desc);
create index if not exists delivery_requests_status_idx on public.delivery_requests(status);
