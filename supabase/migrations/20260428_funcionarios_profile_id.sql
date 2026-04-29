ALTER TABLE public.funcionarios
  ADD COLUMN IF NOT EXISTS profile_id uuid REFERENCES auth.users(id) ON DELETE SET NULL;
UPDATE public.funcionarios f SET profile_id = p.id FROM public.profiles p WHERE lower(p.email) = lower(f.email) AND f.profile_id IS NULL AND f.email IS NOT NULL;
CREATE INDEX IF NOT EXISTS funcionarios_profile_id_idx ON public.funcionarios (profile_id) WHERE profile_id IS NOT NULL;
