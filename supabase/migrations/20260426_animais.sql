-- ──────────────────────────────────────────────────────────────
-- Tabela: animais (pacientes da clínica veterinária)
-- ──────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS animais (
  id            BIGSERIAL PRIMARY KEY,
  empresa_id    BIGINT     NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  cliente_id    BIGINT     REFERENCES clientes(id) ON DELETE SET NULL,
  nome          TEXT       NOT NULL,
  especie       TEXT,                           -- cachorro, gato, passaro, reptil, roedor, coelho, peixe, outro
  raca          TEXT,
  cor           TEXT,
  peso          NUMERIC(6, 2),
  data_nascimento DATE,
  sexo          TEXT CHECK (sexo IN ('macho', 'femea')),
  castrado      BOOLEAN    DEFAULT FALSE,
  observacoes   TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── Índices ────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS animais_empresa_id_idx  ON animais (empresa_id);
CREATE INDEX IF NOT EXISTS animais_cliente_id_idx  ON animais (cliente_id);

-- ── RLS ────────────────────────────────────────────────────────
ALTER TABLE animais ENABLE ROW LEVEL SECURITY;

CREATE POLICY "animais_empresa_select" ON animais
  FOR SELECT USING (
    empresa_id IN (
      SELECT empresa_id FROM profiles WHERE id = auth.uid()
    )
  );

CREATE POLICY "animais_empresa_insert" ON animais
  FOR INSERT WITH CHECK (
    empresa_id IN (
      SELECT empresa_id FROM profiles WHERE id = auth.uid()
    )
  );

CREATE POLICY "animais_empresa_update" ON animais
  FOR UPDATE USING (
    empresa_id IN (
      SELECT empresa_id FROM profiles WHERE id = auth.uid()
    )
  );

CREATE POLICY "animais_empresa_delete" ON animais
  FOR DELETE USING (
    empresa_id IN (
      SELECT empresa_id FROM profiles WHERE id = auth.uid()
    )
  );

-- ──────────────────────────────────────────────────────────────
-- Coluna: agendamentos.animal_id
-- ──────────────────────────────────────────────────────────────

ALTER TABLE agendamentos
  ADD COLUMN IF NOT EXISTS animal_id BIGINT REFERENCES animais(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS agendamentos_animal_id_idx ON agendamentos (animal_id);
