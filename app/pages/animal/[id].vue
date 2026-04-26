<template>
  <div class="min-h-screen" :style="{ background: 'var(--color-bg, #f8fafc)' }">

    <!-- LOADING -->
    <div v-if="loading" class="flex flex-col items-center justify-center min-h-screen gap-4">
      <span class="inline-block w-14 h-14 border-4 border-t-transparent rounded-full animate-spin" :style="{ borderColor: 'var(--color-primary, #ec4899)', borderTopColor: 'transparent' }" />
      <p class="text-sm text-gray-400 font-medium">Carregando prontuário...</p>
    </div>

    <!-- NÃO ENCONTRADO -->
    <div v-else-if="!animal" class="flex flex-col items-center justify-center min-h-screen gap-4 px-4">
      <div class="w-20 h-20 rounded-3xl bg-gray-100 flex items-center justify-center text-4xl mb-2">🐾</div>
      <h1 class="text-xl font-bold text-gray-700">Animal não encontrado</h1>
      <p class="text-sm text-gray-400 text-center">Este perfil pode ter sido removido ou o link é inválido.</p>
    </div>

    <template v-else>
      <!-- ═══════ TOPO LIMPO ═══════ -->
      <div class="bg-white border-b border-gray-100">
        <!-- Faixa de cor fina no topo -->
        <div class="h-1 w-full" :style="{ background: 'var(--color-primary-bg, linear-gradient(90deg, #ec4899, #f43f5e))' }" />

        <div class="max-w-3xl mx-auto px-4 sm:px-8 pt-8 pb-8">
          <!-- Clínica nome -->
          <div class="flex items-center gap-2 mb-6">
            <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.456 3 12c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483 0 01-.923 1.785A5.969 5.969 0 006 21c1.282 0 2.47-.402 3.445-1.087.81.22 1.668.337 2.555.337z"/></svg>
            <span class="text-xs font-semibold text-gray-400 uppercase tracking-widest">{{ clinicaNome }}</span>
          </div>

          <!-- Animal: foto + info -->
          <div class="flex flex-wrap items-start gap-6">
            <!-- Foto / avatar -->
            <div class="relative shrink-0">
              <div
                class="w-24 h-24 sm:w-32 sm:h-32 rounded-3xl overflow-hidden border border-gray-100 shadow-md"
                :style="{ background: especieCorFundo(animal.especie) }"
              >
                <img
                  v-if="animal.foto_url"
                  :src="animal.foto_url"
                  :alt="animal.nome"
                  class="w-full h-full object-cover"
                />
                <div v-else class="w-full h-full flex items-center justify-center text-5xl sm:text-6xl">
                  {{ especieEmoji(animal.especie) }}
                </div>
              </div>
              <!-- Sexo badge -->
              <span
                v-if="animal.sexo"
                class="absolute -bottom-2 -right-2 text-xs font-black w-7 h-7 flex items-center justify-center rounded-full shadow border-2 border-white"
                :class="animal.sexo === 'macho' ? 'bg-blue-500 text-white' : 'bg-pink-500 text-white'"
              >
                {{ animal.sexo === 'macho' ? '♂' : '♀' }}
              </span>
            </div>

            <!-- Info -->
            <div class="flex-1 min-w-0 pt-1">
              <div class="flex flex-wrap items-center gap-1.5 mb-2">
                <span class="text-[11px] font-bold px-2.5 py-1 rounded-full bg-gray-100 text-gray-500">
                  {{ especieLabel(animal.especie) }}
                </span>
                <span v-if="animal.castrado" class="text-[11px] font-bold px-2.5 py-1 rounded-full bg-green-50 text-green-600 border border-green-100">✂️ Castrado</span>
              </div>
              <h1 class="text-3xl sm:text-4xl font-black text-gray-900 leading-tight tracking-tight">{{ animal.nome }}</h1>
              <p v-if="animal.raca" class="text-gray-400 text-sm mt-1 font-medium">{{ animal.raca }}</p>
              <p v-if="animal.tutor_nome" class="text-gray-400 text-sm mt-0.5">
                <span class="text-gray-300">Tutor:</span>
                <span class="text-gray-500 font-medium ml-1">{{ animal.tutor_nome }}</span>
              </p>
            </div>
          </div>

          <!-- Stats row -->
          <div class="grid grid-cols-3 sm:grid-cols-4 gap-3 mt-7">
            <div class="rounded-2xl bg-gray-50 border border-gray-100 px-4 py-3">
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Prontuários</p>
              <p class="text-2xl font-black text-gray-800">{{ prontuarios.length }}</p>
            </div>
            <div class="rounded-2xl bg-gray-50 border border-gray-100 px-4 py-3">
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Atendimentos</p>
              <p class="text-2xl font-black text-gray-800">{{ consultasCount }}</p>
            </div>
            <div class="rounded-2xl bg-gray-50 border border-gray-100 px-4 py-3">
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Peso</p>
              <p class="text-2xl font-black text-gray-800">{{ ultimoPeso ? `${ultimoPeso}kg` : '—' }}</p>
            </div>
            <div v-if="proximoAgendamento" class="hidden sm:block rounded-2xl bg-amber-50 border border-amber-100 px-4 py-3">
              <p class="text-[10px] font-bold text-amber-400 uppercase tracking-widest mb-1">Retorno</p>
              <p class="text-sm font-black text-amber-700 leading-tight">{{ formatDate(proximoAgendamento.data_hora) }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- DETALHES DO ANIMAL (info extra) -->
      <div class="max-w-3xl mx-auto px-4 sm:px-8 pt-6 mb-2">
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
          <div class="px-6 py-4 grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div v-if="animal.cor" class="flex flex-col gap-0.5">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Cor / Pelagem</span>
              <span class="text-sm font-semibold text-gray-700">{{ animal.cor }}</span>
            </div>
            <div v-if="animal.data_nascimento" class="flex flex-col gap-0.5">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Nascimento</span>
              <span class="text-sm font-semibold text-gray-700">{{ formatDate(animal.data_nascimento) }}</span>
              <span class="text-xs text-gray-400">{{ calcularIdade(animal.data_nascimento) }}</span>
            </div>
            <div v-if="animal.peso" class="flex flex-col gap-0.5">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Peso cadastrado</span>
              <span class="text-sm font-semibold text-gray-700">{{ animal.peso }} kg</span>
            </div>
            <div v-if="animal.tutor_nome" class="flex flex-col gap-0.5">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tutor</span>
              <span class="text-sm font-semibold text-gray-700">{{ animal.tutor_nome }}</span>
            </div>
          </div>

          <!-- Observações -->
          <template v-if="animal.observacoes">
            <div class="h-px bg-gray-50 mx-6" />
            <div class="px-6 py-4">
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">Observações / Histórico</p>
              <p class="text-sm text-gray-600 leading-relaxed whitespace-pre-wrap">{{ animal.observacoes }}</p>
            </div>
          </template>

          <!-- Próximo agendamento alert -->
          <template v-if="proximoAgendamento">
            <div class="h-px bg-gray-50 mx-6" />
            <div class="px-6 py-4">
              <div class="flex items-center gap-3 bg-amber-50 border border-amber-100 rounded-xl px-4 py-3">
                <div class="w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center shrink-0">
                  <svg class="w-4 h-4 text-amber-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/></svg>
                </div>
                <div>
                  <p class="text-[10px] font-bold text-amber-500 uppercase tracking-widest">Próxima consulta agendada</p>
                  <p class="text-sm font-bold text-amber-800">
                    {{ formatDataHora(proximoAgendamento.data_hora) }}
                    <span v-if="proximoAgendamento.servicos_nomes" class="font-normal text-amber-600"> · {{ proximoAgendamento.servicos_nomes }}</span>
                  </p>
                </div>
              </div>
            </div>
          </template>
        </div>
      </div>

      <!-- CONTEÚDO PRINCIPAL -->
      <div class="max-w-3xl mx-auto px-4 sm:px-8 pt-4 pb-16 space-y-6">

        <!-- ── PRONTUÁRIOS (TIMELINE) ── -->
        <section>
          <div class="flex items-center gap-3 mb-4">
            <h2 class="text-lg font-black text-gray-800">Histórico de Consultas</h2>
            <span class="text-xs font-bold px-2.5 py-1 rounded-full" :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg,#ec4899,#f43f5e))', color: '#fff' }">
              {{ prontuarios.length }}
            </span>
          </div>

          <div v-if="prontuarios.length === 0" class="flex flex-col items-center gap-3 py-12 bg-white rounded-3xl border border-gray-100 shadow-sm">
            <span class="text-4xl">🩺</span>
            <p class="text-sm font-semibold text-gray-400">Nenhum prontuário registrado ainda</p>
          </div>

          <div v-else class="relative">
            <!-- Linha vertical da timeline -->
            <div class="absolute left-5 top-5 bottom-5 w-0.5 bg-gradient-to-b from-gray-200 via-gray-100 to-transparent" />

            <div class="space-y-4">
              <div
                v-for="(p, idx) in prontuarios"
                :key="p.id"
                class="relative flex gap-4"
              >
                <!-- Dot da timeline -->
                <div class="relative z-10 shrink-0">
                  <div
                    class="w-10 h-10 rounded-full flex items-center justify-center text-base shadow-sm border-2 border-white"
                    :class="tipoBgClass(p.tipo)"
                  >
                    {{ tipoEmoji(p.tipo) }}
                  </div>
                </div>

                <!-- Card -->
                <div class="flex-1 bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                  <!-- Header do card -->
                  <div class="px-5 pt-4 pb-3 flex flex-wrap items-center justify-between gap-2">
                    <div class="flex items-center gap-2 flex-wrap">
                      <span class="text-xs font-bold px-2.5 py-1 rounded-full" :class="tipoBadgeClass(p.tipo)">
                        {{ tipoEmoji(p.tipo) }} {{ tipoLabel(p.tipo) }}
                      </span>
                      <span class="text-xs font-semibold text-gray-500">{{ formatDate(p.data_consulta) }}</span>
                      <span class="text-xs text-gray-300">{{ formatRelativo(p.data_consulta) }}</span>
                    </div>
                    <div v-if="p.funcionario_nome" class="flex items-center gap-1.5">
                      <div class="w-6 h-6 rounded-full bg-violet-100 flex items-center justify-center">
                        <svg class="w-3.5 h-3.5 text-violet-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                      </div>
                      <span class="text-xs font-semibold text-gray-600">{{ p.funcionario_nome }}</span>
                    </div>
                  </div>

                  <!-- Sinais vitais (inline, compacto) -->
                  <div v-if="p.peso_aferido || p.temperatura" class="flex gap-3 px-5 pb-3">
                    <div v-if="p.peso_aferido" class="flex items-center gap-1.5 bg-blue-50 rounded-xl px-3 py-1.5">
                      <svg class="w-3.5 h-3.5 text-blue-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"/></svg>
                      <span class="text-xs font-bold text-blue-700">{{ p.peso_aferido }} kg</span>
                    </div>
                    <div v-if="p.temperatura" class="flex items-center gap-1.5 bg-orange-50 rounded-xl px-3 py-1.5">
                      <svg class="w-3.5 h-3.5 text-orange-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.362 5.214A8.252 8.252 0 0112 21 8.25 8.25 0 016.038 7.048 8.287 8.287 0 009 9.6a8.983 8.983 0 013.361-6.867 8.21 8.21 0 003 2.48z"/><path stroke-linecap="round" stroke-linejoin="round" d="M12 18a3.75 3.75 0 00.495-7.467 5.99 5.99 0 00-1.925 3.546 5.974 5.974 0 01-2.133-1A3.75 3.75 0 0012 18z"/></svg>
                      <span class="text-xs font-bold text-orange-700">{{ p.temperatura }}°C</span>
                    </div>
                  </div>

                  <!-- Conteúdo clínico -->
                  <div class="px-5 pb-5 flex flex-col gap-3">
                    <div v-if="p.anamnese" class="flex flex-col gap-1">
                      <p class="text-[10px] font-extrabold text-gray-400 uppercase tracking-widest">Queixa / Anamnese</p>
                      <p class="text-sm text-gray-700 leading-relaxed whitespace-pre-wrap">{{ p.anamnese }}</p>
                    </div>
                    <div v-if="p.diagnostico" class="flex flex-col gap-1">
                      <p class="text-[10px] font-extrabold text-violet-400 uppercase tracking-widest">Diagnóstico</p>
                      <p class="text-sm text-violet-800 font-medium leading-relaxed whitespace-pre-wrap bg-violet-50 rounded-xl px-3 py-2">{{ p.diagnostico }}</p>
                    </div>
                    <div v-if="p.prescricao" class="flex flex-col gap-1">
                      <p class="text-[10px] font-extrabold text-green-500 uppercase tracking-widest">Prescrição / Tratamento</p>
                      <p class="text-sm text-green-800 leading-relaxed whitespace-pre-wrap bg-green-50 rounded-xl px-3 py-2">{{ p.prescricao }}</p>
                    </div>
                    <div v-if="p.observacoes" class="flex flex-col gap-1">
                      <p class="text-[10px] font-extrabold text-gray-400 uppercase tracking-widest">Observações</p>
                      <p class="text-sm text-gray-600 leading-relaxed whitespace-pre-wrap">{{ p.observacoes }}</p>
                    </div>
                    <div v-if="p.proxima_consulta" class="flex items-center gap-2 bg-amber-50 border border-amber-100 rounded-xl px-3 py-2 mt-1">
                      <svg class="w-4 h-4 text-amber-500 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/></svg>
                      <span class="text-xs font-semibold text-amber-700">Retorno: {{ formatDate(p.proxima_consulta) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- ── HISTÓRICO DE AGENDAMENTOS ── -->
        <section v-if="agendamentos.length > 0">
          <div class="flex items-center gap-3 mb-4">
            <h2 class="text-lg font-black text-gray-800">Agendamentos</h2>
            <span class="bg-gray-100 text-gray-600 text-xs font-bold px-2.5 py-1 rounded-full">{{ agendamentos.length }}</span>
          </div>

          <div class="bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden">
            <div class="divide-y divide-gray-50">
              <div
                v-for="ag in agendamentos"
                :key="ag.id"
                class="flex items-center gap-4 px-5 py-4 hover:bg-gray-50/60 transition-colors"
              >
                <div
                  class="w-10 h-10 rounded-2xl flex items-center justify-center shrink-0 text-sm font-black"
                  :class="statusBgClass(ag.status)"
                >
                  {{ statusEmoji(ag.status) }}
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-gray-800">{{ formatDataHora(ag.data_hora) }}</p>
                  <p v-if="ag.servicos_nomes" class="text-xs text-gray-500 truncate">{{ ag.servicos_nomes }}</p>
                  <p v-if="ag.observacoes" class="text-xs text-gray-400 truncate mt-0.5">{{ ag.observacoes }}</p>
                </div>
                <span class="text-xs font-bold px-2.5 py-1 rounded-full shrink-0" :class="statusBadgeClass(ag.status)">
                  {{ statusLabel(ag.status) }}
                </span>
              </div>
            </div>
          </div>
        </section>

        <!-- Rodapé da clínica -->
        <div class="text-center pt-4">
          <p class="text-xs text-gray-400">Prontuário digital gerado por <strong>{{ clinicaNome }}</strong></p>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { createSupabaseClient } from '~/lib/supabase'
import { usePersonalizacao } from '~/composables/usePersonalizacao'

defineOptions({ name: 'AnimalPublicPage' })
definePageMeta({ layout: 'public' })

// ── Types ──────────────────────────────────────────────────────
interface AnimalData {
  id: number
  nome: string
  especie: string | null
  raca: string | null
  cor: string | null
  peso: number | null
  foto_url: string | null
  data_nascimento: string | null
  sexo: string | null
  castrado: boolean | null
  observacoes: string | null
  empresa_id: number
  tutor_nome: string | null
}

interface ProntuarioData {
  id: number
  data_consulta: string
  tipo: string
  peso_aferido: number | null
  temperatura: number | null
  anamnese: string | null
  diagnostico: string | null
  prescricao: string | null
  observacoes: string | null
  proxima_consulta: string | null
  funcionario_nome: string | null
}

interface AgendamentoData {
  id: number
  data_hora: string
  status: string
  observacoes: string | null
  servicos_nomes: string | null
}

// ── Setup ──────────────────────────────────────────────────────
const route = useRoute()
const supabase = createSupabaseClient()
const { config: tema, loadPersonalizacaoPublic } = usePersonalizacao()

const animal      = ref<AnimalData | null>(null)
const prontuarios = ref<ProntuarioData[]>([])
const agendamentos = ref<AgendamentoData[]>([])
const loading     = ref(true)

const clinicaNome = computed(() => tema.value.nome_empresa || 'Clínica Veterinária')
const animalId    = computed(() => Number(route.params.id))

// ── Computed ──────────────────────────────────────────────────
const consultasCount = computed(() => prontuarios.value.length)

const ultimoPeso = computed(() => {
  const comPeso = prontuarios.value.filter(p => p.peso_aferido)
  return comPeso.length ? comPeso[0].peso_aferido : (animal.value?.peso ?? null)
})

const proximoAgendamento = computed(() => {
  const hoje = new Date().toISOString()
  return agendamentos.value.find(ag =>
    ag.data_hora >= hoje && !['cancelado', 'faltou', 'concluido'].includes(ag.status)
  ) ?? null
})

// ── Helpers ───────────────────────────────────────────────────
const especieMap: Record<string, string> = {
  cachorro: '🐶', gato: '🐱', passaro: '🐦', reptil: '🦎',
  roedor: '🐹', coelho: '🐰', peixe: '🐟',
}
const especieLabelMap: Record<string, string> = {
  cachorro: 'Cachorro', gato: 'Gato', passaro: 'Pássaro', reptil: 'Réptil',
  roedor: 'Roedor', coelho: 'Coelho', peixe: 'Peixe',
}
function especieEmoji(e: string | null | undefined) { return especieMap[e ?? ''] ?? '🐾' }
function especieLabel(e: string | null | undefined) { return especieLabelMap[e ?? ''] ?? 'Animal' }
function especieCorFundo(e: string | null | undefined) {
  const m: Record<string, string> = {
    cachorro: 'linear-gradient(135deg,#fde68a,#f59e0b)',
    gato:     'linear-gradient(135deg,#e9d5ff,#a855f7)',
    passaro:  'linear-gradient(135deg,#bfdbfe,#3b82f6)',
    reptil:   'linear-gradient(135deg,#bbf7d0,#22c55e)',
    roedor:   'linear-gradient(135deg,#fed7aa,#f97316)',
    coelho:   'linear-gradient(135deg,#fce7f3,#ec4899)',
    peixe:    'linear-gradient(135deg,#cffafe,#06b6d4)',
  }
  return m[e ?? ''] ?? 'linear-gradient(135deg,#f3f4f6,#9ca3af)'
}

const tiposDisponiveis = [
  { value: 'consulta',   emoji: '🩺', label: 'Consulta',    badge: 'bg-blue-100 text-blue-700',    bg: 'bg-blue-100' },
  { value: 'retorno',    emoji: '🔄', label: 'Retorno',     badge: 'bg-violet-100 text-violet-700', bg: 'bg-violet-100' },
  { value: 'vacina',     emoji: '💉', label: 'Vacina',      badge: 'bg-green-100 text-green-700',   bg: 'bg-green-100' },
  { value: 'cirurgia',   emoji: '🔬', label: 'Cirurgia',    badge: 'bg-red-100 text-red-700',       bg: 'bg-red-100' },
  { value: 'exame',      emoji: '📋', label: 'Exame',       badge: 'bg-yellow-100 text-yellow-700', bg: 'bg-yellow-100' },
  { value: 'emergencia', emoji: '🚨', label: 'Emergência',  badge: 'bg-orange-100 text-orange-700', bg: 'bg-orange-100' },
  { value: 'outros',     emoji: '🐾', label: 'Outros',      badge: 'bg-gray-100 text-gray-600',     bg: 'bg-gray-100' },
]
const tipoInfo = (t: string) => tiposDisponiveis.find(x => x.value === t) ?? tiposDisponiveis[tiposDisponiveis.length - 1]
function tipoEmoji(t: string) { return tipoInfo(t).emoji }
function tipoLabel(t: string) { return tipoInfo(t).label }
function tipoBadgeClass(t: string) { return tipoInfo(t).badge }
function tipoBgClass(t: string) { return tipoInfo(t).bg }

const statusInfoMap: Record<string, { emoji: string; label: string; badge: string; bg: string }> = {
  agendado:   { emoji: '📅', label: 'Agendado',   badge: 'bg-blue-100 text-blue-700',    bg: 'bg-blue-50' },
  confirmado: { emoji: '✅', label: 'Confirmado', badge: 'bg-green-100 text-green-700',   bg: 'bg-green-50' },
  concluido:  { emoji: '🏁', label: 'Concluído',  badge: 'bg-gray-100 text-gray-600',     bg: 'bg-gray-50' },
  cancelado:  { emoji: '❌', label: 'Cancelado',  badge: 'bg-red-100 text-red-600',       bg: 'bg-red-50' },
  faltou:     { emoji: '⚠️', label: 'Faltou',     badge: 'bg-orange-100 text-orange-600', bg: 'bg-orange-50' },
  solicitado: { emoji: '📬', label: 'Solicitado', badge: 'bg-violet-100 text-violet-600', bg: 'bg-violet-50' },
}
function statusEmoji(s: string) { return statusInfoMap[s]?.emoji ?? '📅' }
function statusLabel(s: string) { return statusInfoMap[s]?.label ?? s }
function statusBadgeClass(s: string) { return statusInfoMap[s]?.badge ?? 'bg-gray-100 text-gray-600' }
function statusBgClass(s: string) { return statusInfoMap[s]?.bg ?? 'bg-gray-50' }

function formatDate(d: string | null) {
  if (!d) return '—'
  const [y, m, day] = d.slice(0, 10).split('-')
  return `${day}/${m}/${y}`
}

function formatDataHora(d: string | null) {
  if (!d) return '—'
  const dt = new Date(d)
  return dt.toLocaleString('pt-BR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })
}

function formatRelativo(d: string | null) {
  if (!d) return ''
  const diff = Math.floor((Date.now() - new Date(d).getTime()) / 86400000)
  if (diff === 0) return 'Hoje'
  if (diff === 1) return 'Ontem'
  if (diff < 30)  return `Há ${diff} dias`
  if (diff < 365) return `Há ${Math.floor(diff / 30)} mês(es)`
  return `Há ${Math.floor(diff / 365)} ano(s)`
}

function calcularIdade(dataNasc: string | null) {
  if (!dataNasc) return ''
  const nasc = new Date(dataNasc + 'T00:00:00')
  const hoje = new Date()
  const anos = hoje.getFullYear() - nasc.getFullYear()
  const meses = hoje.getMonth() - nasc.getMonth() + (hoje.getDate() >= nasc.getDate() ? 0 : -1)
  const totalMeses = anos * 12 + meses
  if (totalMeses < 12) return `${totalMeses} mês(es)`
  const a = Math.floor(totalMeses / 12)
  const m = totalMeses % 12
  return m > 0 ? `${a} ano(s) e ${m} mês(es)` : `${a} ano(s)`
}

// ── Data fetching ─────────────────────────────────────────────
async function fetchData() {
  loading.value = true

  // Busca animal + tutor
  const { data: animalData } = await supabase
    .from('animais')
    .select('*, clientes(nome)')
    .eq('id', animalId.value)
    .maybeSingle()

  if (!animalData) { loading.value = false; return }

  animal.value = {
    ...animalData,
    tutor_nome: (animalData as any).clientes?.nome ?? null,
  } as AnimalData

  // Carrega personalização da clínica
  await loadPersonalizacaoPublic(animal.value.empresa_id)

  // Prontuários (mais recentes primeiro)
  const { data: prontsData } = await supabase
    .from('prontuarios')
    .select('*, funcionarios(nome)')
    .eq('animal_id', animalId.value)
    .order('data_consulta', { ascending: false })
    .order('created_at', { ascending: false })

  prontuarios.value = (prontsData ?? []).map((p: any) => ({
    ...p,
    funcionario_nome: p.funcionarios?.nome ?? null,
  })) as ProntuarioData[]

  // Agendamentos do animal (mais recentes primeiro)
  const { data: agsData } = await supabase
    .from('agendamentos')
    .select('id, data_hora, status, observacoes, agendamento_servicos(servicos(nome))')
    .eq('animal_id', animalId.value)
    .order('data_hora', { ascending: false })

  agendamentos.value = (agsData ?? []).map((ag: any) => ({
    ...ag,
    servicos_nomes: (ag.agendamento_servicos ?? [])
      .map((s: any) => s.servicos?.nome)
      .filter(Boolean)
      .join(', ') || null,
  })) as AgendamentoData[]

  loading.value = false
}

onMounted(fetchData)
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity .2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
