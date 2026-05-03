-- Atualiza categorias de serviços para o nicho veterinário

-- 1. Remove constraint antiga
ALTER TABLE public.servicos
  DROP CONSTRAINT IF EXISTS servicos_categoria_check;

-- 2. Converte registros com categorias antigas para 'outro' ANTES de adicionar a nova constraint
UPDATE public.servicos
SET categoria = 'outro'
WHERE categoria NOT IN ('consulta','vacina','cirurgia','exame','estetica','internacao','outro');

-- 3. Adiciona nova constraint com categorias veterinárias
ALTER TABLE public.servicos
  ADD CONSTRAINT servicos_categoria_check
  CHECK (categoria = ANY (ARRAY[
    'consulta'::text,
    'vacina'::text,
    'cirurgia'::text,
    'exame'::text,
    'estetica'::text,
    'internacao'::text,
    'outro'::text
  ]));
