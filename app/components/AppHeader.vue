<template>
  <header class="border-b flex items-center justify-between px-6 shrink-0 shadow-lg sticky top-0 z-30" :class="headerHeight" :style="{ background: 'var(--color-sidebar, #ffffff)', borderColor: 'var(--color-primary-border, rgba(236,72,153,0.3))' }">
    <!-- Logo -->
    <div class="flex items-center gap-2.5">
      <div
        v-if="!config.logo_url"
        class="w-8 h-8 rounded-xl flex items-center justify-center shadow-md"
        style="background: rgba(255,255,255,0.15)"
      >
        <svg class="w-[18px] h-[18px]" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true" :style="{ color: 'var(--color-primary-text, #ffffff)' }">
          <path d="M12 2C10.34 2 9 3.34 9 5s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3zM5.5 6C4.12 6 3 7.12 3 8.5S4.12 11 5.5 11 8 9.88 8 8.5 6.88 6 5.5 6zm13 0C17.12 6 16 7.12 16 8.5S17.12 11 18.5 11 21 9.88 21 8.5 19.88 6 18.5 6zM12 10c-3.5 0-7 3-7 6.5 0 2.5 3 4.5 7 4.5s7-2 7-4.5c0-3.5-3.5-6.5-7-6.5z"/>
        </svg>
      </div>
      <img v-else :src="config.logo_url" alt="Logo" class="object-contain rounded-xl" :style="{ width: headerLogoPx + 'px', height: headerLogoPx + 'px' }" />
      <span class="text-lg font-black tracking-tight" :style="{ color: 'var(--color-primary-text, #ffffff)' }">{{ config.nome_empresa || 'VetFlow' }}</span>
    </div>

    <!-- Ações -->
    <div class="flex items-center gap-3">
      <span class="text-sm hidden sm:block" :style="{ color: 'var(--color-primary-text, #ffffff)' }">Olá, {{ displayName }}</span>
      <div
        class="w-9 h-9 rounded-full flex items-center justify-center font-black text-sm select-none shadow"
        :style="{ background: 'var(--color-primary, #ec4899)', color: 'var(--color-primary-text, #ffffff)' }"
      >
        {{ initials }}
      </div>
      <button
        type="button"
        class="flex items-center gap-1.5 text-sm transition-colors px-3 py-1.5 rounded-lg hover:bg-black/5"
        :style="{ color: 'var(--color-primary-text, #ffffff)' }"
        @click="handleLogout"
      >
        <span>Sair</span>
        <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9"/></svg>
      </button>
    </div>
    <!-- Banner trial -->
    <div
      v-if="diasRestantesTrial !== null && diasRestantesTrial >= 0"
      class="border-b px-4 py-2 flex items-center justify-between gap-4"
      :style="diasRestantesTrial <= 2
        ? 'background: linear-gradient(90deg,#fef3c7,#fde68a); border-color:#fcd34d; color:#92400e'
        : 'background: linear-gradient(90deg,#f0fdfa,#ccfbf1); border-color:#99f6e4; color:#0f766e'"
    >
      <div class="flex items-center gap-3 min-w-0">
        <!-- Barra de progresso -->
        <div class="hidden sm:flex items-center gap-1.5 shrink-0">
          <span class="text-xs font-bold">Teste grátis:</span>
          <div class="w-28 h-2 rounded-full overflow-hidden" style="background: rgba(0,0,0,0.1)">
            <div
              class="h-full rounded-full transition-all"
              :style="{
                width: `${Math.max(4, ((7 - diasRestantesTrial) / 7) * 100)}%`,
                background: diasRestantesTrial <= 2 ? '#d97706' : '#0d9488'
              }"
            ></div>
          </div>
        </div>
        <span class="text-xs font-semibold truncate">
          <template v-if="diasRestantesTrial === 0">⚠️ Último dia! Assine agora para não perder o acesso.</template>
          <template v-else-if="diasRestantesTrial <= 2">⏳ {{ diasRestantesTrial }} dia{{ diasRestantesTrial > 1 ? 's' : '' }} restante{{ diasRestantesTrial > 1 ? 's' : '' }} no teste. Assine para continuar.</template>
          <template v-else>🎉 Você está no período de teste gratuito — {{ diasRestantesTrial }} dias restantes.</template>
        </span>
      </div>
      <a
        href="/landing#precos"
        class="shrink-0 text-xs px-3 py-1 rounded-lg font-bold transition-all hover:scale-105 whitespace-nowrap"
        :style="diasRestantesTrial <= 2 ? 'background:#92400e;color:#fff' : 'background:#0d9488;color:#fff'"
      >
        Ver planos
      </a>
    </div>

  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '~/composables/useAuth'
import { usePersonalizacao } from '~/composables/usePersonalizacao'
import { createSupabaseClient } from '~/lib/supabase'

defineOptions({ name: 'AppHeader' })

const router = useRouter()
const { logout } = useAuth()
const supabase = createSupabaseClient()
const { config } = usePersonalizacao()

function logoSizeToPx(s: string): number {
  const num = parseInt(s)
  if (!isNaN(num)) return num
  switch (s) {
    case 'sm':  return 28
    case 'lg':  return 44
    case 'xl':  return 56
    case '2xl': return 72
    default:    return 32
  }
}

const headerLogoPx = computed(() => logoSizeToPx(config.value.logo_size))

const headerHeight = computed(() => {
  if (!config.value.logo_url) return 'h-16'
  const px = headerLogoPx.value
  if (px <= 28) return 'h-14'
  if (px <= 32) return 'h-16'
  if (px <= 44) return 'h-[4.5rem]'
  if (px <= 56) return 'h-20'
  if (px <= 72) return 'h-24'
  return 'h-28'
})

const userName = ref('')
const diasRestantesTrial = ref<number | null>(null)

onMounted(async () => {
  const { data: { user } } = await supabase.auth.getUser()
  userName.value = user?.user_metadata?.full_name ?? user?.email ?? ''

  // Só admins/gerentes veem o banner
  const perfil = user?.user_metadata?.perfil as string | undefined
  if (perfil === 'funcionario') return

  let empresaId = user?.user_metadata?.empresa_id as number | null | undefined ?? null
  if (!empresaId) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('empresa_id')
      .eq('id', user!.id)
      .maybeSingle()
    empresaId = profile?.empresa_id ?? null
  }

  if (!empresaId) return

  const { data: rows } = await supabase.rpc('get_empresa_plano', { p_empresa_id: empresaId })
  const info = rows?.[0]
  if (!info || info.plano !== 'trial' || !info.trial_end) return

  const diffMs = new Date(info.trial_end).getTime() - Date.now()
  const diffDias = Math.ceil(diffMs / (1000 * 60 * 60 * 24))
  // Mostra banner durante todo o trial (enquanto não expirou)
  if (diffDias >= 0) {
    diasRestantesTrial.value = diffDias
  }
})

const displayName = computed(() => {
  if (!userName.value) return ''
  return userName.value.split('@')[0]
})

const initials = computed(() => {
  const name = userName.value
  if (!name) return 'U'
  const parts = name.split(' ').filter(Boolean)
  if (parts.length >= 2) return ((parts[0]?.[0] ?? '') + (parts[1]?.[0] ?? '')).toUpperCase()
  return (name[0] ?? 'U').toUpperCase()
})

async function handleLogout() {
  await logout()
  await router.push('/login')
}
</script>

