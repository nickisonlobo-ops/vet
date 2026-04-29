DROP POLICY IF EXISTS "comissoes_empresa_select" ON public.comissoes;
DROP POLICY IF EXISTS "comissoes_empresa_insert" ON public.comissoes;
DROP POLICY IF EXISTS "comissoes_empresa_update" ON public.comissoes;
DROP POLICY IF EXISTS "comissoes_empresa_delete" ON public.comissoes;
CREATE POLICY "comissoes_select" ON public.comissoes FOR SELECT USING (empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid() LIMIT 1));
CREATE POLICY "comissoes_insert" ON public.comissoes FOR INSERT WITH CHECK (empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid() LIMIT 1));
CREATE POLICY "comissoes_update" ON public.comissoes FOR UPDATE USING (empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid() LIMIT 1));
CREATE POLICY "comissoes_delete" ON public.comissoes FOR DELETE USING (empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid() LIMIT 1));
