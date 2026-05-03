import { createSupabaseClient } from '~/lib/supabase'

// Rotas bloqueadas para funcionario (somente admin/gerente)
const MANAGER_ROUTES = ['/contas-pagar', '/produtos', '/funcionarios']
// Rotas públicas (sem login)
const PUBLIC_ROUTES = ['/catalogo', '/loja', '/agendar', '/landing', '/animal']
// Rota de bloqueio (não redirecionar em loop)
const BLOCKED_ROUTE = '/assinatura-expirada'

export default defineNuxtRouteMiddleware(async (to) => {
  const supabase = createSupabaseClient()
  const { data: { session } } = await supabase.auth.getSession()

  // Permite acesso sem login para catálogo e páginas de detalhe de veículo
  if (PUBLIC_ROUTES.some(r => to.path === r || to.path.startsWith(r + '/'))) {
    return
  }

  // Permite acesso à própria página de bloqueio (e login)
  if (to.path === BLOCKED_ROUTE) return

  if (to.path === '/login') {
    if (session) {
      const { data: profile } = await supabase
        .from('profiles')
        .select('perfil')
        .eq('id', session.user.id)
        .maybeSingle()
      const perfil = profile?.perfil ?? session.user.user_metadata?.perfil ?? null
      if (perfil === 'funcionario') return navigateTo('/atividades')
      return navigateTo('/')
    }
    return
  }

  if (!session) {
    return navigateTo('/login')
  }

  // ── Verificação de trial/plano ──────────────────────────────────
  // Só admin/gerente são bloqueados (funcionário não gerencia assinatura)
  const metaPerfil = (session.user.user_metadata?.perfil as string | undefined) ?? null
  const isAdmin = !metaPerfil || metaPerfil === 'admin' || metaPerfil === 'gerente'

  if (isAdmin) {
    const metaEmpresaId = session.user.user_metadata?.empresa_id as number | null | undefined

    // Busca empresa_id do profile se não estiver no metadata
    let empresaId: number | null = metaEmpresaId ?? null
    if (!empresaId) {
      const { data: profile } = await supabase
        .from('profiles')
        .select('empresa_id')
        .eq('id', session.user.id)
        .maybeSingle()
      empresaId = profile?.empresa_id ?? null
    }

    if (empresaId) {
      const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
      const info = rows?.[0]
      if (info) {
        const plano = info.plano as string
        const trialEnd = info.trial_end ? new Date(info.trial_end) : null
        const expirado = plano === 'trial' && trialEnd && trialEnd < new Date()

        if (plano === 'bloqueado' || expirado) {
          return navigateTo(BLOCKED_ROUTE)
        }
      }
    }
  }
  // ────────────────────────────────────────────────────────────────

  // Lê perfil para rotas restritas a gerente/admin
  const needsCheck = MANAGER_ROUTES.includes(to.path)
  if (needsCheck) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('perfil')
      .eq('id', session.user.id)
      .maybeSingle()

    const perfil: string | null =
      profile?.perfil ??
      (session.user.user_metadata?.perfil as string | undefined) ??
      null

    if (perfil === 'funcionario') {
      return navigateTo('/atividades')
    }
  }
})
