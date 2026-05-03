<template>
  <div class="min-h-full bg-transparent p-3 sm:p-8">

    <!-- CABEÇALHO -->
    <div class="relative rounded-3xl overflow-hidden mb-8 shadow-xl">
      <div class="absolute inset-0" :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg, #ec4899, #f43f5e))' }" />
      <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.1),transparent_60%)]" />
      <div class="absolute -top-16 -right-16 w-72 h-72 rounded-full bg-white/[0.03] pointer-events-none" />
      <div class="absolute -bottom-20 left-1/4 w-96 h-96 rounded-full bg-white/[0.02] pointer-events-none" />
      <PageLogo />

      <div class="relative px-4 sm:px-8 pt-5 sm:pt-7 pb-5 sm:pb-7">
        <div class="flex flex-wrap items-start justify-between gap-3 sm:gap-6">
          <div class="flex items-center gap-3 sm:gap-5">
            <div class="flex items-center justify-center w-10 sm:w-14 h-10 sm:h-14 rounded-2xl bg-white/[0.12] backdrop-blur-sm border border-white/20 shadow-lg">
              <AppNavIcon name="stethoscope" class="w-5 sm:w-7 h-5 sm:h-7 text-white" />
            </div>
            <div>
              <div class="flex items-center gap-2 mb-1">
                <span class="text-xs font-semibold text-white/80 uppercase tracking-widest">Clínica</span>
              </div>
              <h1 class="text-xl sm:text-3xl font-bold text-white tracking-tight leading-none">Prontuários</h1>
              <p class="text-sm text-white/80 mt-1.5">
                {{ loading ? 'Carregando...' : `${prontuariosFiltrados.length} de ${prontuarios.length} registro(s) exibido(s)` }}
              </p>
            </div>
          </div>

          <div class="flex items-center gap-2 shrink-0">
            <button
              type="button"
              class="inline-flex items-center gap-2 text-sm font-semibold px-3 sm:px-5 py-2.5 rounded-xl transition-all duration-200"
              :class="filtroAberto
                ? 'bg-white text-[#ff46a2] shadow-lg scale-[1.02]'
                : 'bg-white/10 text-white hover:bg-white/20 border border-white/15 backdrop-blur-sm'"
              @click="filtroAberto = !filtroAberto"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/></svg>
              <span class="hidden sm:inline">Filtros</span>
              <span v-if="filtrosAtivos > 0" class="inline-flex items-center justify-center min-w-[20px] h-5 px-1 rounded-full bg-white text-pink-400 text-xs font-black">{{ filtrosAtivos }}</span>
            </button>
            <button
              type="button"
              class="inline-flex items-center gap-2 text-sm font-bold px-3 sm:px-5 py-2.5 rounded-xl bg-white text-[#ff46a2] hover:bg-pink-50 shadow-lg shadow-pink-200/40 transition-all duration-200 hover:scale-[1.02]"
              @click="abrirAdicionar"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
              <span class="hidden sm:inline">Novo Prontuário</span>
            </button>
          </div>
        </div>

        <div class="h-px bg-white/10 my-4 sm:my-6" />

        <!-- Stats -->
        <div v-if="!loading" class="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <div class="flex flex-col gap-1 bg-white/10 backdrop-blur-sm rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/15 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Total</span>
            <span class="text-xl font-black text-white leading-tight">{{ prontuarios.length }}</span>
            <span class="text-xs text-white/50">registros</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/10 rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/15 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Consultas</span>
            <span class="text-xl font-black text-white leading-tight">{{ countTipo('consulta') + countTipo('retorno') }}</span>
            <span class="text-xs text-white/50">consultas</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/[0.07] rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/12 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Vacinas</span>
            <span class="text-xl font-black text-white leading-tight">{{ countTipo('vacina') }}</span>
            <span class="text-xs text-white/50">registros</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/[0.07] rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/12 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Últimos 30 dias</span>
            <span class="text-xl font-black text-white leading-tight">{{ countUltimos30Dias }}</span>
            <span class="text-xs text-white/50">registros</span>
          </div>
        </div>
      </div>
    </div>

    <!-- FILTROS -->
    <Transition name="slide-fade">
      <div v-show="filtroAberto" class="bg-white rounded-3xl border border-gray-100 shadow-md mb-6 overflow-hidden">
        <div class="flex items-center justify-between px-7 py-4 border-b border-gray-100 bg-gray-50/70">
          <div class="flex items-center gap-2.5">
            <svg class="w-4 h-4 text-[#ff46a2]" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/></svg>
            <span class="text-sm font-bold text-gray-700">Filtros</span>
          </div>
          <button v-if="filtrosAtivos > 0" type="button" class="text-xs font-semibold text-[#ff46a2] hover:underline" @click="limparFiltros">
            Limpar todos
          </button>
        </div>
        <div class="p-7 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          <div class="sm:col-span-2 flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Busca</label>
            <div class="relative">
              <svg class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path stroke-linecap="round" d="m21 21-4.35-4.35"/></svg>
              <input v-model="filtros.busca" type="text" placeholder="Animal, tutor ou diagnóstico..." class="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-[var(--color-primary,#6b7280)]" />
            </div>
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Tipo</label>
            <select v-model="filtros.tipo" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
              <option value="">Todos</option>
              <option v-for="t in tiposDisponiveis" :key="t.value" :value="t.value">{{ t.label }}</option>
            </select>
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Profissional</label>
            <select v-model="filtros.funcionarioId" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
              <option value="">Todos</option>
              <option v-for="f in funcionarios" :key="f.id" :value="f.id">{{ f.nome }}</option>
            </select>
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Data de</label>
            <input v-model="filtros.dataInicio" type="date" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500" />
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Data até</label>
            <input v-model="filtros.dataFim" type="date" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500" />
          </div>
        </div>
      </div>
    </Transition>

    <!-- NOTIFICAÇÃO AGENDAMENTO CRIADO -->
    <Transition name="slide-fade">
      <div
        v-if="agendamentoNotification"
        class="flex items-center gap-3 bg-green-50 border border-green-200 rounded-2xl px-6 py-4 mb-4 shadow-sm"
      >
        <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center shrink-0">
          <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/></svg>
        </div>
        <p class="text-sm font-semibold text-green-800 flex-1">{{ agendamentoNotification }}</p>
        <button type="button" class="w-6 h-6 flex items-center justify-center text-green-500 hover:text-green-700 transition-colors" @click="agendamentoNotification = null">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
      </div>
    </Transition>

    <!-- LOADING -->
    <div v-if="loading" class="flex flex-col items-center justify-center gap-4 py-32">
      <span class="inline-block w-12 h-12 border-4 border-violet-600 border-t-transparent rounded-full animate-spin" />
      <span class="text-sm text-gray-400 font-medium">Carregando prontuários...</span>
    </div>

    <!-- ERRO -->
    <div v-else-if="error" class="flex items-center gap-3 text-sm text-red-700 bg-red-50 border border-red-200 rounded-2xl px-6 py-4">
      <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path stroke-linecap="round" d="M12 8v4m0 4h.01"/></svg>
      {{ error }}
    </div>

    <!-- TABELA -->
    <div v-else class="bg-white rounded-3xl shadow-md border border-gray-100 overflow-hidden">
      <div class="flex items-center justify-between px-7 py-4 border-b border-gray-100 bg-gray-50/50">
        <span class="text-sm font-semibold text-gray-600">
          <span class="text-[#ff46a2] font-black">{{ prontuariosFiltrados.length }}</span>
          resultado(s)
          <span v-if="filtrosAtivos > 0" class="text-gray-400 font-normal"> · filtros aplicados</span>
        </span>
        <span class="text-xs text-gray-400">Ordenado por data (mais recente)</span>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full text-sm whitespace-nowrap">
          <thead>
            <tr class="bg-gray-50 border-b border-gray-100">
              <th class="text-left px-7 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Data</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Animal</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Tipo</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Tutor</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Profissional</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Diagnóstico</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Próx. Consulta</th>
              <th class="px-7 py-4 text-right text-xs font-extrabold text-gray-400 uppercase tracking-widest sm:sticky sm:right-0 bg-gray-50">Ações</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
            <tr v-if="prontuariosFiltrados.length === 0">
              <td colspan="8" class="text-center py-20">
                <div class="flex flex-col items-center gap-3">
                  <span class="text-5xl">🩺</span>
                  <span class="text-base font-semibold text-gray-400">Nenhum prontuário encontrado</span>
                  <span v-if="filtrosAtivos > 0" class="text-sm text-gray-400">Tente ajustar os filtros</span>
                  <button v-else type="button" class="mt-2 text-sm font-semibold text-[#ff46a2] hover:underline" @click="abrirAdicionar">
                    Criar primeiro prontuário
                  </button>
                </div>
              </td>
            </tr>
            <tr
              v-for="p in prontuariosFiltrados"
              :key="p.id"
              class="hover:bg-pink-50/40 transition-colors duration-150 group cursor-pointer"
              @click="visualizar(p)"
            >
              <td class="px-7 py-4">
                <div class="flex flex-col">
                  <span class="font-semibold text-gray-800">{{ formatDate(p.data_consulta) }}</span>
                  <span class="text-xs text-gray-400">{{ formatDateRelative(p.data_consulta) }}</span>
                </div>
              </td>
              <td class="px-5 py-4">
                <div class="flex items-center gap-2.5">
                  <div class="w-8 h-8 rounded-full flex items-center justify-center text-base shrink-0 shadow-sm"
                    :style="{ background: especieCorFundo(p.animal_especie) }">
                    {{ especieEmoji(p.animal_especie) }}
                  </div>
                  <div>
                    <span class="font-semibold text-gray-800 block">{{ p.animal_nome }}</span>
                    <span v-if="p.animal_especie" class="text-xs text-gray-400 capitalize">{{ p.animal_especie }}</span>
                  </div>
                </div>
              </td>
              <td class="px-5 py-4">
                <span class="inline-flex items-center gap-1 text-xs font-bold px-2.5 py-1 rounded-full" :class="tipoBadgeClass(p.tipo)">
                  {{ tipoEmoji(p.tipo) }} {{ tipoLabel(p.tipo) }}
                </span>
              </td>
              <td class="px-5 py-4 text-gray-600">{{ p.tutor_nome ?? '—' }}</td>
              <td class="px-5 py-4 text-gray-600">{{ p.funcionario_nome ?? '—' }}</td>
              <td class="px-5 py-4 max-w-[180px]">
                <span v-if="p.diagnostico" class="text-gray-700 truncate block max-w-[180px]" :title="p.diagnostico">
                  {{ p.diagnostico }}
                </span>
                <span v-else class="text-gray-300">—</span>
              </td>
              <td class="px-5 py-4">
                <span v-if="p.proxima_consulta"
                  class="inline-flex items-center gap-1 text-xs font-semibold px-2 py-1 rounded-lg"
                  :class="isProximaConsultaProxima(p.proxima_consulta) ? 'bg-amber-50 text-amber-700' : 'bg-gray-100 text-gray-500'"
                >
                  <svg class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/></svg>
                  {{ formatDate(p.proxima_consulta) }}
                </span>
                <span v-else class="text-gray-300">—</span>
              </td>
              <td class="px-7 py-4 text-right sm:sticky sm:right-0 group-hover:bg-pink-50/40 transition-colors" @click.stop>
                <div class="flex items-center justify-end gap-1">
                  <button
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-violet-500 hover:bg-violet-100 transition-colors"
                    title="Ver prontuário"
                    @click="visualizar(p)"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                  </button>
                  <button
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-[#ff46a2] hover:bg-pink-100 transition-colors"
                    title="Editar"
                    @click="editProntuario(p)"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z"/></svg>
                  </button>
                  <button
                    v-if="isAdminOrGerente"
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-red-400 hover:bg-red-50 transition-colors"
                    title="Excluir"
                    @click="confirmarExclusao(p)"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M9 7h6m-7 0a1 1 0 01-1-1V5a1 1 0 011-1h8a1 1 0 011 1v1a1 1 0 01-1 1H9z"/></svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ── MODAL VISUALIZAR ─────────────────────────────────────── -->
    <Teleport to="body">
      <Transition name="fade">
        <div
          v-if="visualizando"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-md px-4"
          @click.self="visualizando = null"
        >
          <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl overflow-hidden">
            <!-- Header -->
            <div class="flex items-center justify-between px-8 py-5 border-b border-white/10" :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg, #111827, #1f2937))' }">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-xl bg-white/10 border border-white/15 flex items-center justify-center text-white text-lg">
                  🩺
                </div>
                <div>
                  <h2 class="text-lg font-bold text-white leading-none">Prontuário #{{ visualizando.id }}</h2>
                  <p class="text-xs text-white/60 mt-0.5">{{ formatDate(visualizando.data_consulta) }}</p>
                </div>
              </div>
              <div class="flex items-center gap-2">
                <button
                  type="button"
                  class="inline-flex items-center gap-1.5 text-xs font-semibold px-3 py-1.5 rounded-lg bg-white/10 text-white hover:bg-white/20 transition-colors"
                  @click="editProntuario(visualizando); visualizando = null"
                >
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z"/></svg>
                  Editar
                </button>
                <button type="button" class="w-8 h-8 flex items-center justify-center rounded-xl text-white/60 hover:text-white hover:bg-white/10 transition-colors" @click="visualizando = null">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
              </div>
            </div>

            <div class="overflow-y-auto max-h-[75vh] px-8 py-7 flex flex-col gap-6">
              <!-- Animal + Tipo -->
              <div class="flex flex-wrap items-center gap-4">
                <div class="flex items-center gap-3 bg-gray-50 rounded-2xl px-4 py-3 flex-1 min-w-[200px]">
                  <span class="text-3xl">{{ especieEmoji(visualizando.animal_especie) }}</span>
                  <div>
                    <p class="font-bold text-gray-800">{{ visualizando.animal_nome }}</p>
                    <p class="text-xs text-gray-400 capitalize">{{ visualizando.animal_especie ?? 'Animal' }}</p>
                  </div>
                </div>
                <span class="inline-flex items-center gap-1.5 text-sm font-bold px-4 py-2.5 rounded-2xl" :class="tipoBadgeClass(visualizando.tipo)">
                  {{ tipoEmoji(visualizando.tipo) }} {{ tipoLabel(visualizando.tipo) }}
                </span>
              </div>

              <!-- Info grid -->
              <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
                <div v-if="visualizando.tutor_nome" class="bg-gray-50 rounded-xl px-4 py-3">
                  <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-1">Tutor</p>
                  <p class="text-sm font-semibold text-gray-800">{{ visualizando.tutor_nome }}</p>
                </div>
                <div v-if="visualizando.funcionario_nome" class="bg-gray-50 rounded-xl px-4 py-3">
                  <p class="text-xs font-semibold text-gray-400 uppercase tracking-widest mb-1">Profissional</p>
                  <p class="text-sm font-semibold text-gray-800">{{ visualizando.funcionario_nome }}</p>
                </div>
                <div v-if="visualizando.peso_aferido" class="bg-blue-50 rounded-xl px-4 py-3">
                  <p class="text-xs font-semibold text-blue-400 uppercase tracking-widest mb-1">Peso</p>
                  <p class="text-sm font-bold text-blue-800">{{ visualizando.peso_aferido }} kg</p>
                </div>
                <div v-if="visualizando.temperatura" class="bg-orange-50 rounded-xl px-4 py-3">
                  <p class="text-xs font-semibold text-orange-400 uppercase tracking-widest mb-1">Temperatura</p>
                  <p class="text-sm font-bold text-orange-800">{{ visualizando.temperatura }} °C</p>
                </div>
              </div>

              <!-- Conteúdo clínico -->
              <div v-if="visualizando.anamnese" class="flex flex-col gap-1.5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest">Anamnese / Queixa principal</p>
                <div class="bg-gray-50 rounded-2xl p-4 text-sm text-gray-700 leading-relaxed whitespace-pre-wrap">{{ visualizando.anamnese }}</div>
              </div>
              <div v-if="visualizando.diagnostico" class="flex flex-col gap-1.5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest">Diagnóstico</p>
                <div class="bg-violet-50 border border-violet-100 rounded-2xl p-4 text-sm text-violet-900 leading-relaxed font-medium whitespace-pre-wrap">{{ visualizando.diagnostico }}</div>
              </div>
              <div v-if="visualizando.prescricao" class="flex flex-col gap-1.5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest">Prescrição / Tratamento</p>
                <div class="bg-green-50 border border-green-100 rounded-2xl p-4 text-sm text-green-900 leading-relaxed whitespace-pre-wrap">{{ visualizando.prescricao }}</div>
              </div>
              <div v-if="visualizando.observacoes" class="flex flex-col gap-1.5">
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest">Observações</p>
                <div class="bg-gray-50 rounded-2xl p-4 text-sm text-gray-600 leading-relaxed whitespace-pre-wrap">{{ visualizando.observacoes }}</div>
              </div>
              <div v-if="visualizando.proxima_consulta" class="flex items-center gap-3 bg-amber-50 border border-amber-100 rounded-2xl px-5 py-4">
                <svg class="w-5 h-5 text-amber-500 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
                <div>
                  <p class="text-xs font-semibold text-amber-600 uppercase tracking-widest">Próxima consulta</p>
                  <p class="text-sm font-bold text-amber-800">{{ formatDate(visualizando.proxima_consulta) }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ── MODAL ADICIONAR / EDITAR ─────────────────────────────── -->
    <Teleport to="body">
      <Transition name="fade">
        <div
          v-if="editando !== null || adicionando"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-md px-4"
          @click.self="fecharModal"
        >
          <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl overflow-hidden">
            <div class="flex items-center justify-between px-8 py-6 border-b border-white/10" :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg, #111827, #1f2937))' }">
              <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-xl bg-white/10 border border-white/15 flex items-center justify-center text-white text-lg">
                  🩺
                </div>
                <h2 class="text-lg font-bold text-white">{{ adicionando ? 'Novo Prontuário' : 'Editar Prontuário' }}</h2>
              </div>
              <button type="button" class="w-8 h-8 flex items-center justify-center rounded-xl text-white/60 hover:text-white hover:bg-white/10 transition-colors" @click="fecharModal">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
              </button>
            </div>

            <form class="flex flex-col gap-5 px-8 py-7 overflow-y-auto max-h-[75vh]" @submit.prevent="adicionando ? salvarAdicao() : salvarEdicao()">

              <!-- Animal + Tipo -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Animal / Paciente <span class="text-red-500">*</span></label>
                  <select v-model="form.animal_id" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option :value="null">Selecione o animal</option>
                    <option v-for="a in animais" :key="a.id" :value="a.id">
                      {{ especieEmoji(a.especie) }} {{ a.nome }} {{ a.tutor_nome ? `(${a.tutor_nome})` : '' }}
                    </option>
                  </select>
                  <p v-if="formErrors.animal_id" class="text-xs text-red-500">{{ formErrors.animal_id }}</p>
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Tipo de atendimento <span class="text-red-500">*</span></label>
                  <select v-model="form.tipo" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option v-for="t in tiposDisponiveis" :key="t.value" :value="t.value">{{ t.label }}</option>
                  </select>
                </div>
              </div>

              <!-- Data + Profissional -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Data da consulta <span class="text-red-500">*</span></label>
                  <input
                    v-model="form.data_consulta"
                    type="date"
                    class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500"
                  />
                  <p v-if="formErrors.data_consulta" class="text-xs text-red-500">{{ formErrors.data_consulta }}</p>
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Profissional (Veterinário)</label>
                  <select v-model="form.funcionario_id" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option :value="null">Não informado</option>
                    <option v-for="f in funcionarios" :key="f.id" :value="f.id">{{ f.nome }}{{ f.cargo ? ` — ${f.cargo}` : '' }}</option>
                  </select>
                  <p v-if="funcionarios.length === 0" class="text-xs text-amber-500">Nenhum funcionário com cargo de Veterinário encontrado.</p>
                </div>
              </div>

              <!-- Sinais vitais -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <AppInput v-model="form.peso_aferido" label="Peso aferido (kg)" type="number" placeholder="Ex: 8.5" />
                <AppInput v-model="form.temperatura" label="Temperatura (°C)" type="number" placeholder="Ex: 38.5" />
              </div>

              <!-- Anamnese -->
              <div class="flex flex-col gap-1.5">
                <label class="text-sm font-semibold text-gray-700">Anamnese / Queixa principal</label>
                <textarea
                  v-model="form.anamnese"
                  rows="3"
                  placeholder="Descreva os sintomas, histórico e motivo da consulta..."
                  class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500 resize-none"
                />
              </div>

              <!-- Diagnóstico -->
              <div class="flex flex-col gap-1.5">
                <label class="text-sm font-semibold text-gray-700">Diagnóstico</label>
                <textarea
                  v-model="form.diagnostico"
                  rows="2"
                  placeholder="Diagnóstico clínico..."
                  class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-violet-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500 resize-none"
                />
              </div>

              <!-- Prescrição -->
              <div class="flex flex-col gap-1.5">
                <label class="text-sm font-semibold text-gray-700">Prescrição / Tratamento</label>
                <textarea
                  v-model="form.prescricao"
                  rows="3"
                  placeholder="Medicamentos prescritos, dosagem, duração do tratamento..."
                  class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-green-50/50 focus:outline-none focus:ring-2 focus:ring-green-400 resize-none"
                />
              </div>

              <!-- Observações -->
              <div class="flex flex-col gap-1.5">
                <label class="text-sm font-semibold text-gray-700">Observações adicionais</label>
                <textarea
                  v-model="form.observacoes"
                  rows="2"
                  placeholder="Outras informações relevantes..."
                  class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500 resize-none"
                />
              </div>

              <!-- Próxima consulta + agendamento automático -->
              <div class="rounded-2xl border border-amber-200 bg-amber-50/50 p-4 flex flex-col gap-3">
                <div class="flex items-center gap-2">
                  <svg class="w-4 h-4 text-amber-500 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
                  <label class="text-sm font-semibold text-amber-800">Próxima consulta (retorno)</label>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-amber-700">Data</label>
                    <input
                      v-model="form.proxima_consulta"
                      type="date"
                      class="w-full rounded-xl border border-amber-200 bg-white/80 px-3 py-2 text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-amber-400"
                    />
                  </div>
                  <div class="flex flex-col gap-1">
                    <label class="text-xs font-medium text-amber-700">Horário</label>
                    <input
                      v-model="form.proxima_consulta_hora"
                      type="time"
                      class="w-full rounded-xl border border-amber-200 bg-white/80 px-3 py-2 text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-amber-400"
                    />
                  </div>
                </div>
                <Transition name="slide-fade">
                  <div v-if="form.proxima_consulta" class="flex items-start gap-2 text-xs text-amber-700 bg-amber-100 rounded-xl px-3 py-2.5">
                    <svg class="w-3.5 h-3.5 shrink-0 mt-0.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z"/></svg>
                    <span>Um agendamento de <strong>retorno</strong> será criado automaticamente para <strong>{{ formatDate(form.proxima_consulta) }}</strong> às <strong>{{ form.proxima_consulta_hora || '09:00' }}h</strong>.</span>
                  </div>
                </Transition>
              </div>

              <p v-if="modalError" class="text-sm text-red-600 bg-red-50 border border-red-200 rounded-xl px-4 py-3">{{ modalError }}</p>

              <div class="flex gap-3 pt-1">
                <button type="button" class="flex-1 py-3 rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 transition-colors text-sm font-semibold" @click="fecharModal">
                  Cancelar
                </button>
                <AppButton variant="primary" size="md" type="submit" :loading="saving" class="flex-1">
                  {{ adicionando ? 'Salvar Prontuário' : 'Salvar alterações' }}
                </AppButton>
              </div>
            </form>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ── MODAL EXCLUIR ──────────────────────────────────────────── -->
    <Teleport to="body">
      <Transition name="fade">
        <div
          v-if="excluindo"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-md px-4"
          @click.self="excluindo = null"
        >
          <div class="bg-white rounded-3xl shadow-2xl w-full max-w-sm overflow-hidden">
            <div class="px-8 pt-8 pb-6 text-center">
              <div class="w-16 h-16 rounded-2xl bg-red-50 border border-red-100 flex items-center justify-center mx-auto mb-5">
                <svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M9 7h6m-7 0a1 1 0 01-1-1V5a1 1 0 011-1h8a1 1 0 011 1v1a1 1 0 01-1 1H9z"/></svg>
              </div>
              <h2 class="text-xl font-bold text-gray-800">Excluir prontuário?</h2>
              <p class="text-sm text-gray-500 mt-2 leading-relaxed">
                Prontuário de <strong class="text-gray-800">{{ excluindo.animal_nome }}</strong> do dia
                <strong class="text-gray-800">{{ formatDate(excluindo.data_consulta) }}</strong> será removido.<br />
                <span class="text-red-500 text-xs font-semibold">Essa ação não pode ser desfeita.</span>
              </p>
            </div>
            <p v-if="deleteError" class="text-sm text-red-600 bg-red-50 border-t border-b border-red-200 px-8 py-3 text-center">{{ deleteError }}</p>
            <div class="flex gap-3 px-8 pb-8 pt-4">
              <button type="button" class="flex-1 py-3 rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 transition-colors text-sm font-semibold" @click="excluindo = null">
                Cancelar
              </button>
              <button
                type="button"
                class="flex-1 py-3 rounded-xl bg-red-500 hover:bg-red-600 text-white font-bold text-sm transition-colors shadow-sm shadow-red-200 disabled:opacity-60"
                :disabled="deleting"
                @click="executarExclusao"
              >
                <span v-if="deleting" class="inline-block w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-1" />
                {{ deleting ? 'Excluindo...' : 'Excluir' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { createSupabaseClient } from '~/lib/supabase'
import { useAdmin } from '~/composables/useAdmin'
import { useEmpresa } from '~/composables/useEmpresa'
import AppInput from '~/components/AppInput.vue'
import AppButton from '~/components/AppButton.vue'
import AppNavIcon from '~/components/AppNavIcon.vue'

// ── Interfaces ────────────────────────────────────────────────

interface Prontuario {
  id: number
  animal_id: number
  animal_nome?: string | null
  animal_especie?: string | null
  cliente_id: number | null
  tutor_nome?: string | null
  funcionario_id: number | null
  funcionario_nome?: string | null
  data_consulta: string
  tipo: string
  peso_aferido: number | null
  temperatura: number | null
  anamnese: string | null
  diagnostico: string | null
  prescricao: string | null
  observacoes: string | null
  proxima_consulta: string | null
  empresa_id: number
  created_at: string | null
}

interface AnimalOption {
  id: number
  nome: string
  especie: string | null
  tutor_nome: string | null
  cliente_id: number | null
}

interface FuncionarioOption {
  id: number
  nome: string
  cargo: string | null
  email: string | null
}

// ── Setup ──────────────────────────────────────────────────────

const supabase = createSupabaseClient()
const { empresaId, loadEmpresa } = useEmpresa()
const { isAdminOrGerente } = useAdmin()

const prontuarios  = ref<Prontuario[]>([])
const animais      = ref<AnimalOption[]>([])
const funcionarios = ref<FuncionarioOption[]>([])
const loading = ref(true)
const error   = ref<string | null>(null)

const editando   = ref<Prontuario | null>(null)
const adicionando = ref(false)
const visualizando = ref<Prontuario | null>(null)
const saving     = ref(false)
const modalError = ref<string | null>(null)

const excluindo  = ref<Prontuario | null>(null)
const deleting   = ref(false)
const deleteError = ref<string | null>(null)

const agendamentoNotification = ref<string | null>(null)

const form = reactive({
  animal_id:        null as number | null,
  funcionario_id:   null as number | null,
  data_consulta:    new Date().toISOString().slice(0, 10),
  tipo:             'consulta',
  peso_aferido:     '' as string | number,
  temperatura:      '' as string | number,
  anamnese:         '',
  diagnostico:      '',
  prescricao:       '',
  observacoes:      '',
  proxima_consulta: '',
  proxima_consulta_hora: '09:00',
})

const formErrors = reactive({ animal_id: '', data_consulta: '' })

const filtroAberto = ref(false)
const filtros = reactive({
  busca:        '',
  tipo:         '',
  funcionarioId: '' as string | number,
  dataInicio:   '',
  dataFim:      '',
})

const tiposDisponiveis = [
  { value: 'consulta',   label: '🩺 Consulta'   },
  { value: 'retorno',    label: '🔄 Retorno'    },
  { value: 'vacina',     label: '💉 Vacina'     },
  { value: 'cirurgia',   label: '🔬 Cirurgia'   },
  { value: 'exame',      label: '📋 Exame'      },
  { value: 'emergencia', label: '🚨 Emergência' },
  { value: 'outros',     label: '🐾 Outros'     },
]

// ── Helpers ───────────────────────────────────────────────────

function especieEmoji(e: string | null | undefined) {
  const m: Record<string, string> = {
    cachorro: '🐶', gato: '🐱', passaro: '🐦',
    reptil: '🦎', roedor: '🐹', coelho: '🐰', peixe: '🐟',
  }
  return m[e ?? ''] ?? '🐾'
}

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

function tipoLabel(t: string) {
  return tiposDisponiveis.find(x => x.value === t)?.label.split(' ').slice(1).join(' ') ?? t
}

function tipoEmoji(t: string) {
  return tiposDisponiveis.find(x => x.value === t)?.label.split(' ')[0] ?? '🐾'
}

function tipoBadgeClass(t: string) {
  const m: Record<string, string> = {
    consulta:   'bg-blue-100 text-blue-700',
    retorno:    'bg-violet-100 text-violet-700',
    vacina:     'bg-green-100 text-green-700',
    cirurgia:   'bg-red-100 text-red-700',
    exame:      'bg-yellow-100 text-yellow-700',
    emergencia: 'bg-orange-100 text-orange-700',
    outros:     'bg-gray-100 text-gray-600',
  }
  return m[t] ?? 'bg-gray-100 text-gray-600'
}

function formatDate(d: string | null) {
  if (!d) return '—'
  const [y, m, day] = d.slice(0, 10).split('-')
  return `${day}/${m}/${y}`
}

function formatDateRelative(d: string | null) {
  if (!d) return ''
  const diff = Math.floor((Date.now() - new Date(d).getTime()) / 86400000)
  if (diff === 0) return 'Hoje'
  if (diff === 1) return 'Ontem'
  if (diff < 7)  return `Há ${diff} dias`
  return ''
}

function isProximaConsultaProxima(d: string | null) {
  if (!d) return false
  const diff = Math.floor((new Date(d).getTime() - Date.now()) / 86400000)
  return diff >= 0 && diff <= 7
}

// ── Computed ──────────────────────────────────────────────────

const countTipo = (t: string) => prontuarios.value.filter(p => p.tipo === t).length
const countUltimos30Dias = computed(() => {
  const limite = Date.now() - 30 * 86400000
  return prontuarios.value.filter(p => new Date(p.data_consulta).getTime() >= limite).length
})

const filtrosAtivos = computed(() => {
  let c = 0
  if (filtros.busca) c++
  if (filtros.tipo) c++
  if (filtros.funcionarioId) c++
  if (filtros.dataInicio) c++
  if (filtros.dataFim) c++
  return c
})

const prontuariosFiltrados = computed(() => {
  let list = [...prontuarios.value]
  const b = filtros.busca.toLowerCase()
  if (b) {
    list = list.filter(p =>
      (p.animal_nome ?? '').toLowerCase().includes(b) ||
      (p.tutor_nome ?? '').toLowerCase().includes(b) ||
      (p.diagnostico ?? '').toLowerCase().includes(b)
    )
  }
  if (filtros.tipo) list = list.filter(p => p.tipo === filtros.tipo)
  if (filtros.funcionarioId) list = list.filter(p => p.funcionario_id === Number(filtros.funcionarioId))
  if (filtros.dataInicio) list = list.filter(p => p.data_consulta >= filtros.dataInicio)
  if (filtros.dataFim)    list = list.filter(p => p.data_consulta <= filtros.dataFim)
  return list
})

function limparFiltros() {
  filtros.busca = ''
  filtros.tipo  = ''
  filtros.funcionarioId = ''
  filtros.dataInicio = ''
  filtros.dataFim    = ''
}

// ── Data fetching ─────────────────────────────────────────────

async function fetchProntuarios() {
  loading.value = true
  error.value   = null
  const { data, error: err } = await supabase
    .from('prontuarios')
    .select('*, animais(nome, especie), clientes(nome), funcionarios(nome)')
    .eq('empresa_id', empresaId.value!)
    .order('data_consulta', { ascending: false })
    .order('created_at', { ascending: false })

  if (err) { error.value = err.message; loading.value = false; return }

  prontuarios.value = (data ?? []).map((r: any) => ({
    ...r,
    animal_nome:     r.animais?.nome  ?? null,
    animal_especie:  r.animais?.especie ?? null,
    tutor_nome:      r.clientes?.nome ?? null,
    funcionario_nome: r.funcionarios?.nome ?? null,
  })) as Prontuario[]
  loading.value = false
}

async function fetchAnimais() {
  const { data } = await supabase
    .from('animais')
    .select('id, nome, especie, cliente_id, clientes(nome)')
    .eq('empresa_id', empresaId.value!)
    .order('nome')
  animais.value = (data ?? []).map((a: any) => ({
    id:         a.id,
    nome:       a.nome,
    especie:    a.especie,
    cliente_id: a.cliente_id ?? null,
    tutor_nome: a.clientes?.nome ?? null,
  })) as AnimalOption[]
}

async function fetchFuncionarios() {
  const { data } = await supabase
    .from('funcionarios')
    .select('id, nome, cargo, email')
    .eq('empresa_id', empresaId.value!)
    .order('nome')
  funcionarios.value = (data ?? []).filter((f: any) =>
    f.cargo?.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').includes('veterin')
  ) as FuncionarioOption[]
}

const route = useRoute()

onMounted(async () => {
  await loadEmpresa()
  await Promise.all([fetchProntuarios(), fetchAnimais(), fetchFuncionarios()])

  // Abrir modal de novo prontuário pré-preenchido via query params (vindo do kanban)
  const qAnimalId = route.query.animal_id
  if (qAnimalId) {
    resetForm()
    form.animal_id = Number(qAnimalId)
    adicionando.value = true
    editando.value = null
  }
})

// ── CRUD ──────────────────────────────────────────────────────

function resetForm() {
  form.animal_id        = null
  form.funcionario_id   = null
  form.data_consulta    = new Date().toISOString().slice(0, 10)
  form.tipo             = 'consulta'
  form.peso_aferido     = ''
  form.temperatura      = ''
  form.anamnese         = ''
  form.diagnostico      = ''
  form.prescricao       = ''
  form.observacoes      = ''
  form.proxima_consulta = ''
  form.proxima_consulta_hora = '09:00'
  formErrors.animal_id    = ''
  formErrors.data_consulta = ''
}

function abrirAdicionar() {
  resetForm()
  adicionando.value = true
  editando.value    = null
  modalError.value  = null
}

function fecharModal() {
  editando.value    = null
  adicionando.value = false
}

function visualizar(p: Prontuario) {
  visualizando.value = p
}

function editProntuario(p: Prontuario) {
  editando.value    = p
  adicionando.value = false
  modalError.value  = null
  formErrors.animal_id     = ''
  formErrors.data_consulta = ''
  form.animal_id        = p.animal_id
  form.funcionario_id   = p.funcionario_id
  form.data_consulta    = p.data_consulta.slice(0, 10)
  form.tipo             = p.tipo
  form.peso_aferido     = p.peso_aferido ?? ''
  form.temperatura      = p.temperatura  ?? ''
  form.anamnese         = p.anamnese      ?? ''
  form.diagnostico      = p.diagnostico   ?? ''
  form.prescricao       = p.prescricao    ?? ''
  form.observacoes      = p.observacoes   ?? ''
  form.proxima_consulta = p.proxima_consulta?.slice(0, 10) ?? ''
  form.proxima_consulta_hora = '09:00'
}

function validateForm(): boolean {
  formErrors.animal_id     = ''
  formErrors.data_consulta = ''
  let ok = true
  if (!form.animal_id)    { formErrors.animal_id     = 'Selecione o animal.'; ok = false }
  if (!form.data_consulta) { formErrors.data_consulta = 'Informe a data.';    ok = false }
  return ok
}

function buildPayload() {
  // Find cliente_id from selected animal
  const animal = animais.value.find(a => a.id === form.animal_id)
  const clienteId = (animal as any)?.cliente_id ?? null
  return {
    empresa_id:       empresaId.value!,
    animal_id:        form.animal_id,
    cliente_id:       clienteId,
    funcionario_id:   form.funcionario_id || null,
    data_consulta:    form.data_consulta,
    tipo:             form.tipo,
    peso_aferido:     form.peso_aferido !== '' ? Number(form.peso_aferido) : null,
    temperatura:      form.temperatura  !== '' ? Number(form.temperatura)  : null,
    anamnese:         form.anamnese.trim()      || null,
    diagnostico:      form.diagnostico.trim()   || null,
    prescricao:       form.prescricao.trim()    || null,
    observacoes:      form.observacoes.trim()   || null,
    proxima_consulta: form.proxima_consulta     || null,
  }
}

async function criarAgendamentoRetorno() {
  if (!form.proxima_consulta) return
  const animal     = animais.value.find(a => a.id === form.animal_id)
  const funcionario = funcionarios.value.find(f => f.id === form.funcionario_id)
  const hora       = form.proxima_consulta_hora || '09:00'
  const dataHora   = `${form.proxima_consulta}T${hora}:00-03:00`
  const obs        = form.diagnostico.trim()
    ? `Retorno — ${form.diagnostico.slice(0, 120)}`
    : 'Retorno agendado pelo prontuário'

  const { error: err } = await supabase.from('agendamentos').insert({
    empresa_id:    empresaId.value!,
    animal_id:     form.animal_id,
    cliente_id:    animal?.cliente_id ?? null,
    funcionario_id: funcionario?.email
      ? (await supabase.from('profiles').select('id').eq('email', funcionario.email).maybeSingle()).data?.id ?? null
      : null,
    data_hora:     dataHora,
    status:        'agendado',
    observacoes:   obs,
  })

  if (err) {
    // Prontuário já foi salvo — avisa mas não bloqueia
    modalError.value = `Prontuário salvo! Porém não foi possível criar o agendamento de retorno: ${err.message}`
    return
  }

  agendamentoNotification.value = `Agendamento de retorno criado para ${formatDate(form.proxima_consulta)} às ${hora}h.`
  setTimeout(() => { agendamentoNotification.value = null }, 7000)
}

async function salvarAdicao() {
  if (!validateForm()) return
  saving.value     = true
  modalError.value = null
  const { error: err } = await supabase
    .from('prontuarios')
    .insert(buildPayload())
  if (err) { modalError.value = err.message; saving.value = false; return }
  if (form.proxima_consulta) await criarAgendamentoRetorno()
  saving.value      = false
  adicionando.value = false
  await fetchProntuarios()
}

async function salvarEdicao() {
  if (!editando.value || !validateForm()) return
  saving.value     = true
  modalError.value = null
  const { error: err } = await supabase
    .from('prontuarios')
    .update(buildPayload())
    .eq('id', editando.value.id)
  if (err) { modalError.value = err.message; saving.value = false; return }
  // Cria agendamento apenas se a data de retorno foi adicionada ou alterada
  const dataAnterior = editando.value.proxima_consulta?.slice(0, 10) ?? ''
  if (form.proxima_consulta && form.proxima_consulta !== dataAnterior) {
    await criarAgendamentoRetorno()
  }
  saving.value   = false
  editando.value = null
  await fetchProntuarios()
}

function confirmarExclusao(p: Prontuario) {
  excluindo.value  = p
  deleteError.value = null
}

async function executarExclusao() {
  if (!excluindo.value) return
  deleting.value = true
  const { error: err } = await supabase
    .from('prontuarios')
    .delete()
    .eq('id', excluindo.value.id)
  if (err) { deleteError.value = err.message; deleting.value = false; return }
  deleting.value  = false
  excluindo.value = null
  await fetchProntuarios()
}
</script>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active { transition: all .25s ease; }
.slide-fade-enter-from,
.slide-fade-leave-to    { opacity: 0; transform: translateY(-8px); }

.fade-enter-active,
.fade-leave-active { transition: opacity .2s ease; }
.fade-enter-from,
.fade-leave-to     { opacity: 0; }
</style>
