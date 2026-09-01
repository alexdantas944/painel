-- Execute depois de criar public.delivery_requests
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE public.delivery_requests; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
ALTER TABLE public.delivery_requests ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "motoboy read orders" ON public.delivery_requests;
CREATE POLICY "motoboy read orders" ON public.delivery_requests FOR SELECT TO anon,authenticated USING (true);
DROP POLICY IF EXISTS "motoboy update orders" ON public.delivery_requests;
CREATE POLICY "motoboy update orders" ON public.delivery_requests FOR UPDATE TO anon,authenticated USING (true) WITH CHECK (true);
GRANT SELECT,UPDATE ON public.delivery_requests TO anon,authenticated;
-- Sem login: estas políticas permitem que a chave anon leia/atualize pedidos. Para produção privada, use Supabase Auth + RLS por usuário.
