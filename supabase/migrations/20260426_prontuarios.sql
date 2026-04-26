-- ──────────────────────────────────────────────────────────────
-- Tabela: prontuarios (fichas clínicas veterinárias)
-- ──────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS prontuarios (
  id               BIGSERIAL PRIMARY KEY,
  empresa_id       BIGINT      NOT NULL REFERENCES empresas(id)    ON DELETE CASCADE,
  animal_id        BIGINT      NOT NULL REFERENCES animais(id)     ON DELETE CASCADE,
  cliente_id       BIGINT               REFERENCES clientes(id)    ON DELETE SET NULL,
  funcionario_id   BIGINT               REFERENCES funcionarios(id) ON DELETE SET NULL,
  agendamento_id   BIGINT               REFERENCES agendamentos(id) ON DELETE SET NULL,

  data_consulta    DATE        NOT NULL DEFAULT CURRENT_DATE,
  tipo             TEXT        NOT NULL DEFAULT 'consulta'
                               CHECK (tipo IN (
                                 'consulta', 'retorno', 'vacina', 'cirurgia',
                                 'exame', 'emergencia', 'outros'
                               )),

  -- Sinais vitais
  peso_aferido     NUMERIC(6,2),
  temperatura      NUMERIC(4,1),

  -- Conteúdo clínico
  anamnese         TEXT,   -- queixa principal / histórico
  diagnostico      TEXT,
  prescricao       TEXT,   -- medicamentos / tratamento
  observacoes      TEXT,

  proxima_consulta DATE,

  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- ── Índices ────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS prontuarios_empresa_id_idx    ON prontuarios (empresa_id);
CREATE INDEX IF NOT EXISTS prontuarios_animal_id_idx     ON prontuarios (animal_id);
CREATE INDEX IF NOT EXISTS prontuarios_data_consulta_idx ON prontuarios (data_consulta DESC);

-- ── RLS ────────────────────────────────────────────────────────
ALTER TABLE prontuarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prontuarios_select" ON prontuarios
  FOR SELECT USING (
    empresa_id IN (SELECT empresa_id FROM profiles WHERE id = auth.uid())
  );

CREATE POLICY "prontuarios_insert" ON prontuarios
  FOR INSERT WITH CHECK (
    empresa_id IN (SELECT empresa_id FROM profiles WHERE id = auth.uid())
  );

CREATE POLICY "prontuarios_update" ON prontuarios
  FOR UPDATE USING (
    empresa_id IN (SELECT empresa_id FROM profiles WHERE id = auth.uid())
  );

CREATE POLICY "prontuarios_delete" ON prontuarios
  FOR DELETE USING (
    empresa_id IN (SELECT empresa_id FROM profiles WHERE id = auth.uid())
  );
