-- Página pública do animal: permite leitura anon de animais e prontuários
-- (acesso via link direto compartilhado com o tutor)

-- ── animais: leitura pública ──────────────────────────────────
DROP POLICY IF EXISTS "animais_anon_select" ON public.animais;
CREATE POLICY "animais_anon_select" ON public.animais
  FOR SELECT TO anon
  USING (true);

-- ── prontuários: leitura pública ─────────────────────────────
DROP POLICY IF EXISTS "prontuarios_anon_select" ON public.prontuarios;
CREATE POLICY "prontuarios_anon_select" ON public.prontuarios
  FOR SELECT TO anon
  USING (true);

-- ── funcionarios: já possuem anon select (20260424_funcionarios_public_read)
-- ── agendamentos: já possuem anon select (20260424_agendamento_publico_rls)
-- ── clientes: já possuem anon select (20260424_agendamento_publico_rls)
