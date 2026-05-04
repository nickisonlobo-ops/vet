# Code Citations

## License: unknown
https://github.com/DonPasticho/SmartHome--Vue--Tw-/blob/27817a16401b1c9b2ed1bd3fa2360fea7ffc0d64/my-project/src/App.vue

```
Aqui está o prompt completo para replicar no outro projeto:

---

## Prompt para replicar o sistema de trial

Quero implementar um sistema de trial de 7 dias exatamente igual ao do meu outro projeto. Este projeto usa **Nuxt 3 + Supabase**, com tabela `public.empresas`, middleware global em `app/middleware/auth.global.ts` e header em `app/components/AppHeader.vue`. Implemente as 4 partes abaixo:

---

### PARTE 1 — Migration SQL

Crie o arquivo `supabase/migrations/YYYYMMDD_trial_plano.sql` com este conteúdo exato (substitua a data):

```sql
ALTER TABLE public.empresas
  ADD COLUMN IF NOT EXISTS plano       text NOT NULL DEFAULT 'trial'
    CHECK (plano IN ('trial','basico','clinica','rede','bloqueado')),
  ADD COLUMN IF NOT EXISTS trial_start timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS trial_end   timestamptz NOT NULL DEFAULT (now() + interval '7 days');

UPDATE public.empresas
SET plano = 'clinica',
    trial_start = created_at,
    trial_end   = created_at + interval '7 days'
WHERE plano = 'trial';

CREATE OR REPLACE FUNCTION public.get_empresa_plano(p_empresa_id bigint)
RETURNS TABLE(plano text, trial_end timestamptz)
LANGUAGE sql SECURITY DEFINER SET search_path = public
AS $$
  SELECT plano, trial_end FROM public.empresas WHERE id = p_empresa_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_empresa_plano TO authenticated;
```

---

### PARTE 2 — Middleware `auth.global.ts`

Dentro do middleware existente, após confirmar que o usuário tem sessão e **antes** das verificações de perfil, adicione este bloco. A constante `BLOCKED_ROUTE = '/assinatura-expirada'` deve ser adicionada no topo e incluída na lista de rotas permitidas sem redirect:

```ts
// No topo do arquivo:
const BLOCKED_ROUTE = '/assinatura-expirada'

// Na lista de rotas que passam sem verificação, adicione:
if (to.path === BLOCKED_ROUTE) return

// Bloco de verificação (após confirmar sessão, antes das rotas de perfil):
const metaPerfil = (session.user.user_metadata?.perfil as string | undefined) ?? null
const isAdmin = !metaPerfil || metaPerfil === 'admin' || metaPerfil === 'gerente'

if (isAdmin) {
  let empresaId: number | null = (session.user.user_metadata?.empresa_id as number | null) ?? null
  if (!empresaId) {
    const { data: profile } = await supabase
      .from('profiles').select('empresa_id').eq('id', session.user.id).maybeSingle()
    empresaId = profile?.empresa_id ?? null
  }
  if (empresaId) {
    const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
    const info = rows?.[0]
    if (info) {
      const plano = info.plano as string
      const trialEnd = info.trial_end ? new Date(info.trial_end) : null
      const expirado = plano === 'trial' && trialEnd && trialEnd < new Date()
      if (plano === 'bloqueado' || expirado) return navigateTo(BLOCKED_ROUTE)
    }
  }
}
```

---

### PARTE 3 — Página `app/pages/assinatura-expirada.vue`

Crie o arquivo com este conteúdo (ajuste o número do WhatsApp, nome do produto e preços dos planos):

```vue
<template>
  <div class="min-h-screen flex flex-col items-center justify-center px-5 font-sans antialiased" style="background: linear-gradient(180deg, #f0fdfa 0%, #ecfeff 100%)">
    <div class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl mb-8" style="background: linear-gradient(135deg, #0d9488, #0891b2)">
      <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2
```


## License: unknown
https://github.com/Ortus-Solutions/ContentBox/blob/807784b57e4540232abb9803ac1acef4ae10cb9d/modules/contentbox/modules/contentbox-admin/views/_components/ui/Icon.cfm

```
Aqui está o prompt completo para replicar no outro projeto:

---

## Prompt para replicar o sistema de trial

Quero implementar um sistema de trial de 7 dias exatamente igual ao do meu outro projeto. Este projeto usa **Nuxt 3 + Supabase**, com tabela `public.empresas`, middleware global em `app/middleware/auth.global.ts` e header em `app/components/AppHeader.vue`. Implemente as 4 partes abaixo:

---

### PARTE 1 — Migration SQL

Crie o arquivo `supabase/migrations/YYYYMMDD_trial_plano.sql` com este conteúdo exato (substitua a data):

```sql
ALTER TABLE public.empresas
  ADD COLUMN IF NOT EXISTS plano       text NOT NULL DEFAULT 'trial'
    CHECK (plano IN ('trial','basico','clinica','rede','bloqueado')),
  ADD COLUMN IF NOT EXISTS trial_start timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS trial_end   timestamptz NOT NULL DEFAULT (now() + interval '7 days');

UPDATE public.empresas
SET plano = 'clinica',
    trial_start = created_at,
    trial_end   = created_at + interval '7 days'
WHERE plano = 'trial';

CREATE OR REPLACE FUNCTION public.get_empresa_plano(p_empresa_id bigint)
RETURNS TABLE(plano text, trial_end timestamptz)
LANGUAGE sql SECURITY DEFINER SET search_path = public
AS $$
  SELECT plano, trial_end FROM public.empresas WHERE id = p_empresa_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_empresa_plano TO authenticated;
```

---

### PARTE 2 — Middleware `auth.global.ts`

Dentro do middleware existente, após confirmar que o usuário tem sessão e **antes** das verificações de perfil, adicione este bloco. A constante `BLOCKED_ROUTE = '/assinatura-expirada'` deve ser adicionada no topo e incluída na lista de rotas permitidas sem redirect:

```ts
// No topo do arquivo:
const BLOCKED_ROUTE = '/assinatura-expirada'

// Na lista de rotas que passam sem verificação, adicione:
if (to.path === BLOCKED_ROUTE) return

// Bloco de verificação (após confirmar sessão, antes das rotas de perfil):
const metaPerfil = (session.user.user_metadata?.perfil as string | undefined) ?? null
const isAdmin = !metaPerfil || metaPerfil === 'admin' || metaPerfil === 'gerente'

if (isAdmin) {
  let empresaId: number | null = (session.user.user_metadata?.empresa_id as number | null) ?? null
  if (!empresaId) {
    const { data: profile } = await supabase
      .from('profiles').select('empresa_id').eq('id', session.user.id).maybeSingle()
    empresaId = profile?.empresa_id ?? null
  }
  if (empresaId) {
    const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
    const info = rows?.[0]
    if (info) {
      const plano = info.plano as string
      const trialEnd = info.trial_end ? new Date(info.trial_end) : null
      const expirado = plano === 'trial' && trialEnd && trialEnd < new Date()
      if (plano === 'bloqueado' || expirado) return navigateTo(BLOCKED_ROUTE)
    }
  }
}
```

---

### PARTE 3 — Página `app/pages/assinatura-expirada.vue`

Crie o arquivo com este conteúdo (ajuste o número do WhatsApp, nome do produto e preços dos planos):

```vue
<template>
  <div class="min-h-screen flex flex-col items-center justify-center px-5 font-sans antialiased" style="background: linear-gradient(180deg, #f0fdfa 0%, #ecfeff 100%)">
    <div class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl mb-8" style="background: linear-gradient(135deg, #0d9488, #0891b2)">
      <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"/>
      </svg>
    </div>
    <h1 class="text-3xl sm:text-4xl font-black text-center mb-3" style="color: #0f766e">
      {{ plano === 'bloqueado' ? 'Acesso sus
```


## License: unknown
https://github.com/Ortus-Solutions/ContentBox/blob/807784b57e4540232abb9803ac1acef4ae10cb9d/modules/contentbox/modules/contentbox-admin/views/_components/ui/Icon.cfm

```
Aqui está o prompt completo para replicar no outro projeto:

---

## Prompt para replicar o sistema de trial

Quero implementar um sistema de trial de 7 dias exatamente igual ao do meu outro projeto. Este projeto usa **Nuxt 3 + Supabase**, com tabela `public.empresas`, middleware global em `app/middleware/auth.global.ts` e header em `app/components/AppHeader.vue`. Implemente as 4 partes abaixo:

---

### PARTE 1 — Migration SQL

Crie o arquivo `supabase/migrations/YYYYMMDD_trial_plano.sql` com este conteúdo exato (substitua a data):

```sql
ALTER TABLE public.empresas
  ADD COLUMN IF NOT EXISTS plano       text NOT NULL DEFAULT 'trial'
    CHECK (plano IN ('trial','basico','clinica','rede','bloqueado')),
  ADD COLUMN IF NOT EXISTS trial_start timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS trial_end   timestamptz NOT NULL DEFAULT (now() + interval '7 days');

UPDATE public.empresas
SET plano = 'clinica',
    trial_start = created_at,
    trial_end   = created_at + interval '7 days'
WHERE plano = 'trial';

CREATE OR REPLACE FUNCTION public.get_empresa_plano(p_empresa_id bigint)
RETURNS TABLE(plano text, trial_end timestamptz)
LANGUAGE sql SECURITY DEFINER SET search_path = public
AS $$
  SELECT plano, trial_end FROM public.empresas WHERE id = p_empresa_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_empresa_plano TO authenticated;
```

---

### PARTE 2 — Middleware `auth.global.ts`

Dentro do middleware existente, após confirmar que o usuário tem sessão e **antes** das verificações de perfil, adicione este bloco. A constante `BLOCKED_ROUTE = '/assinatura-expirada'` deve ser adicionada no topo e incluída na lista de rotas permitidas sem redirect:

```ts
// No topo do arquivo:
const BLOCKED_ROUTE = '/assinatura-expirada'

// Na lista de rotas que passam sem verificação, adicione:
if (to.path === BLOCKED_ROUTE) return

// Bloco de verificação (após confirmar sessão, antes das rotas de perfil):
const metaPerfil = (session.user.user_metadata?.perfil as string | undefined) ?? null
const isAdmin = !metaPerfil || metaPerfil === 'admin' || metaPerfil === 'gerente'

if (isAdmin) {
  let empresaId: number | null = (session.user.user_metadata?.empresa_id as number | null) ?? null
  if (!empresaId) {
    const { data: profile } = await supabase
      .from('profiles').select('empresa_id').eq('id', session.user.id).maybeSingle()
    empresaId = profile?.empresa_id ?? null
  }
  if (empresaId) {
    const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
    const info = rows?.[0]
    if (info) {
      const plano = info.plano as string
      const trialEnd = info.trial_end ? new Date(info.trial_end) : null
      const expirado = plano === 'trial' && trialEnd && trialEnd < new Date()
      if (plano === 'bloqueado' || expirado) return navigateTo(BLOCKED_ROUTE)
    }
  }
}
```

---

### PARTE 3 — Página `app/pages/assinatura-expirada.vue`

Crie o arquivo com este conteúdo (ajuste o número do WhatsApp, nome do produto e preços dos planos):

```vue
<template>
  <div class="min-h-screen flex flex-col items-center justify-center px-5 font-sans antialiased" style="background: linear-gradient(180deg, #f0fdfa 0%, #ecfeff 100%)">
    <div class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl mb-8" style="background: linear-gradient(135deg, #0d9488, #0891b2)">
      <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"/>
      </svg>
    </div>
    <h1 class="text-3xl sm:text-4xl font-black text-center mb-3" style="color: #0f766e">
      {{ plano === 'bloqueado' ? 'Acesso sus
```


## License: unknown
https://github.com/DonPasticho/SmartHome--Vue--Tw-/blob/27817a16401b1c9b2ed1bd3fa2360fea7ffc0d64/my-project/src/App.vue

```
Aqui está o prompt completo para replicar no outro projeto:

---

## Prompt para replicar o sistema de trial

Quero implementar um sistema de trial de 7 dias exatamente igual ao do meu outro projeto. Este projeto usa **Nuxt 3 + Supabase**, com tabela `public.empresas`, middleware global em `app/middleware/auth.global.ts` e header em `app/components/AppHeader.vue`. Implemente as 4 partes abaixo:

---

### PARTE 1 — Migration SQL

Crie o arquivo `supabase/migrations/YYYYMMDD_trial_plano.sql` com este conteúdo exato (substitua a data):

```sql
ALTER TABLE public.empresas
  ADD COLUMN IF NOT EXISTS plano       text NOT NULL DEFAULT 'trial'
    CHECK (plano IN ('trial','basico','clinica','rede','bloqueado')),
  ADD COLUMN IF NOT EXISTS trial_start timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS trial_end   timestamptz NOT NULL DEFAULT (now() + interval '7 days');

UPDATE public.empresas
SET plano = 'clinica',
    trial_start = created_at,
    trial_end   = created_at + interval '7 days'
WHERE plano = 'trial';

CREATE OR REPLACE FUNCTION public.get_empresa_plano(p_empresa_id bigint)
RETURNS TABLE(plano text, trial_end timestamptz)
LANGUAGE sql SECURITY DEFINER SET search_path = public
AS $$
  SELECT plano, trial_end FROM public.empresas WHERE id = p_empresa_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_empresa_plano TO authenticated;
```

---

### PARTE 2 — Middleware `auth.global.ts`

Dentro do middleware existente, após confirmar que o usuário tem sessão e **antes** das verificações de perfil, adicione este bloco. A constante `BLOCKED_ROUTE = '/assinatura-expirada'` deve ser adicionada no topo e incluída na lista de rotas permitidas sem redirect:

```ts
// No topo do arquivo:
const BLOCKED_ROUTE = '/assinatura-expirada'

// Na lista de rotas que passam sem verificação, adicione:
if (to.path === BLOCKED_ROUTE) return

// Bloco de verificação (após confirmar sessão, antes das rotas de perfil):
const metaPerfil = (session.user.user_metadata?.perfil as string | undefined) ?? null
const isAdmin = !metaPerfil || metaPerfil === 'admin' || metaPerfil === 'gerente'

if (isAdmin) {
  let empresaId: number | null = (session.user.user_metadata?.empresa_id as number | null) ?? null
  if (!empresaId) {
    const { data: profile } = await supabase
      .from('profiles').select('empresa_id').eq('id', session.user.id).maybeSingle()
    empresaId = profile?.empresa_id ?? null
  }
  if (empresaId) {
    const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
    const info = rows?.[0]
    if (info) {
      const plano = info.plano as string
      const trialEnd = info.trial_end ? new Date(info.trial_end) : null
      const expirado = plano === 'trial' && trialEnd && trialEnd < new Date()
      if (plano === 'bloqueado' || expirado) return navigateTo(BLOCKED_ROUTE)
    }
  }
}
```

---

### PARTE 3 — Página `app/pages/assinatura-expirada.vue`

Crie o arquivo com este conteúdo (ajuste o número do WhatsApp, nome do produto e preços dos planos):

```vue
<template>
  <div class="min-h-screen flex flex-col items-center justify-center px-5 font-sans antialiased" style="background: linear-gradient(180deg, #f0fdfa 0%, #ecfeff 100%)">
    <div class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl mb-8" style="background: linear-gradient(135deg, #0d9488, #0891b2)">
      <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"/>
      </svg>
    </div>
    <h1 class="text-3xl sm:text-4xl font-black text-center mb-3" style="color: #0f766e">
      {{ plano === 'bloqueado' ? 'Acesso sus
```

