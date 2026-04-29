ALTER TABLE public.agendamento_servicos
  ADD COLUMN IF NOT EXISTS funcionario_id bigint REFERENCES public.funcionarios(id) ON DELETE SET NULL;
