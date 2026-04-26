-- Adiciona campo de foto nos animais
ALTER TABLE animais ADD COLUMN IF NOT EXISTS foto_url TEXT;

-- ── Bucket de fotos para animais ──────────────────────────────
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'animais-fotos',
  'animais-fotos',
  true,
  5242880, -- 5 MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Permite que usuários autenticados façam upload
CREATE POLICY "animais_fotos_insert"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'animais-fotos');

-- Permite leitura pública das fotos
CREATE POLICY "animais_fotos_select"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'animais-fotos');

-- Permite que usuários autenticados atualizem fotos
CREATE POLICY "animais_fotos_update"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'animais-fotos');

-- Permite que usuários autenticados deletem fotos
CREATE POLICY "animais_fotos_delete"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'animais-fotos');
