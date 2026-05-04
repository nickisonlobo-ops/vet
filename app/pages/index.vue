<template>
  <div class="min-h-full bg-transparent">

    <!-- ══════════════════════════════════════════════ LOADING INICIAL -->
    <div v-if="adminLoading" class="flex items-center justify-center py-40">
      <div class="flex flex-col items-center gap-4">
        <div class="relative w-14 h-14">
          <div class="absolute inset-0 rounded-full border-4 border-pink-100" />
          <div class="absolute inset-0 rounded-full border-4 border-pink-500 border-t-transparent animate-spin" />
        </div>
        <p class="text-sm font-semibold text-gray-400">Carregando painel...</p>
      </div>
    </div>

    <!-- ══════════════════════════════════════════════ VISÃO FUNCIONÁRIO -->
    <template v-else-if="!isAdminOrGerente">

      <!-- Hero do funcionário -->
      <div class="relative overflow-hidden" :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg,#ec4899,#f43f5e))' }">
        <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.18),transparent_55%)]" />
        <div class="absolute bottom-0 left-0 w-72 h-72 rounded-full bg-white/5 -translate-x-1/2 translate-y-1/3" />
        <PageLogo />

        <div class="relative px-5 sm:px-8 pt-5 pb-0">
          <!-- Saudação -->
          <div class="flex flex-wrap items-start justify-between gap-4 mb-5">
            <div>
              <p class="text-[11px] font-bold uppercase tracking-[0.25em] text-white/60 mb-1">VetFlow · Meu Painel</p>
              <h1 class="text-2xl sm:text-3xl font-black text-white leading-tight">
                {{ funcionarioLogado ? `Olá, ${primeiroNome(funcionarioLogado.nome)}! 👋` : 'Meu Painel' }}
              </h1>
              <p class="text-sm text-white/60 mt-1 capitalize">{{ dataHoje }}</p>
            </div>
            <div v-if="funcionarioLogado" class="flex flex-col items-end gap-2">
              <span class="inline-flex items-center gap-1.5 text-xs font-bold bg-white/15 border border-white/20 text-white px-3 py-1.5 rounded-xl backdrop-blur-sm">
                <svg class="w-3.5 h-3.5 opacity-70" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 14.15v4.25c0 1.094-.787 2.036-1.872 2.18-2.087.277-4.216.42-6.378.42s-4.291-.143-6.378-.42c-1.085-.144-1.872-1.086-1.872-2.18v-4.25m16.5 0a2.18 2.18 0 00.75-1.661V8.706c0-1.081-.768-2.015-1.837-2.175a48.114 48.114 0 00-3.413-.387m4.5 8.006c-.194.165-.42.295-.673.38A23.978 23.978 0 0112 15.75c-2.648 0-5.195-.429-7.577-1.22a2.016 2.016 0 01-.673-.38m0 0A2.18 2.18 0 013 12.489V8.706c0-1.081.768-2.015 1.837-2.175a48.111 48.111 0 013.413-.387m7.5 0V5.25A2.25 2.25 0 0013.5 3h-3a2.25 2.25 0 00-2.25 2.25v.894m7.5 0a48.667 48.667 0 00-7.5 0M12 12.75h.008v.008H12v-.008z"/></svg>
                {{ funcionarioLogado.cargo ?? 'Funcionário' }}
              </span>
            </div>
          </div>

          <!-- Mini-KPIs no hero -->
          <div v-if="funcionarioLogado && !loadingAtividades" class="grid grid-cols-4 gap-2 mb-0">
            <div v-for="kpi in funcKpis" :key="kpi.label" class="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl px-3 py-3 flex flex-col gap-0.5">
              <span class="text-[9px] font-black uppercase tracking-widest leading-none" :class="kpi.cor">{{ kpi.label }}</span>
              <span class="text-xl font-black text-white leading-none">{{ kpi.valor }}</span>
            </div>
          </div>

          <!-- Navegação semana -->
          <div class="mt-4 flex items-center justify-between">
            <div class="flex items-center gap-2">
              <svg class="w-4 h-4 text-white/70" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
              <span class="text-xs font-bold text-white/80 capitalize">{{ meuKanbanMesLabel }}</span>
            </div>
            <div class="flex items-center gap-1.5">
              <button type="button" class="px-2.5 py-1 rounded-lg bg-white/15 border border-white/20 text-white text-[10px] font-bold hover:bg-white/25 transition-colors" @click="meuKanbanIrParaHoje">Hoje</button>
              <button type="button" class="w-7 h-7 rounded-lg bg-white/10 border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-colors" @click="meuKanbanSemanaAnterior">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg>
              </button>
              <button type="button" class="w-7 h-7 rounded-lg bg-white/10 border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-colors" @click="meuKanbanSemanaProxima">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg>
              </button>
            </div>
          </div>

          <!-- Dias da semana (tab-strip) -->
          <div class="flex gap-1.5 mt-3 overflow-x-auto pb-4 scrollbar-none">
            <button
              v-for="dia in meuKanbanDias"
              :key="dia.iso"
              type="button"
              class="shrink-0 flex flex-col items-center gap-0.5 py-2.5 px-3 rounded-2xl transition-all duration-200 min-w-[52px]"
              :class="diaSelecionado === dia.iso
                ? 'bg-white shadow-lg shadow-black/10'
                : dia.ehHoje ? 'bg-white/25 border border-white/30' : 'bg-white/10 border border-white/10 hover:bg-white/20'"
              @click="diaSelecionado = dia.iso"
            >
              <span class="text-[9px] font-black uppercase tracking-wide" :class="diaSelecionado === dia.iso ? 'text-gray-400' : 'text-white/70'">{{ dia.diaSemana }}</span>
              <span class="text-lg font-black leading-none" :class="diaSelecionado === dia.iso ? 'text-gray-900' : dia.ehHoje ? 'text-white' : 'text-white/80'">{{ dia.diaNum }}</span>
              <span class="text-[9px] font-bold rounded-full px-1.5 py-0.5 leading-none min-w-[18px] text-center"
                :class="diaSelecionado === dia.iso
                  ? ((meuKanbanPorDia[dia.iso]?.length ?? 0) > 0 ? 'bg-pink-100 text-pink-600' : 'bg-gray-100 text-gray-400')
                  : ((meuKanbanPorDia[dia.iso]?.length ?? 0) > 0 ? 'bg-white/30 text-white' : 'bg-white/10 text-white/50')"
              >{{ meuKanbanPorDia[dia.iso]?.length ?? 0 }}</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Agendamentos do dia selecionado -->
      <div class="px-4 sm:px-6 pt-5 pb-3">
        <div v-if="meuKanbanLoading" class="flex justify-center py-10">
          <div class="w-8 h-8 rounded-full border-4 border-gray-100 border-t-pink-400 animate-spin" />
        </div>
        <template v-else>
          <div v-if="!funcionarioLogado" class="flex flex-col items-center justify-center py-20 gap-3">
            <div class="w-16 h-16 rounded-2xl bg-pink-50 border border-pink-100 flex items-center justify-center">
              <svg class="w-8 h-8 text-pink-300" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/></svg>
            </div>
            <p class="text-sm font-bold text-gray-600">Nenhum funcionário vinculado</p>
            <p class="text-xs text-gray-400 text-center max-w-xs">Peça ao administrador para cadastrar seu e-mail na ficha de funcionário.</p>
          </div>
          <template v-else>
            <div class="flex items-center gap-2 mb-4">
              <h2 class="text-sm font-black text-gray-700">
                {{ diaSelecionado === hojeIso ? 'Hoje' : new Date(diaSelecionado + 'T12:00:00').toLocaleDateString('pt-BR', { weekday: 'long', day: '2-digit', month: 'long' }) }}
              </h2>
              <span class="text-xs font-bold px-2 py-0.5 rounded-full text-white" :style="{ background: 'var(--color-primary-bg)' }">
                {{ agendamentosdia.length }} agendamento(s)
              </span>
            </div>
            <div v-if="agendamentosdia.length === 0" class="flex flex-col items-center justify-center py-12 gap-2 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
              <span class="text-3xl">🐾</span>
              <p class="text-sm font-semibold text-gray-400">Nenhum agendamento neste dia</p>
            </div>
            <div v-else class="flex flex-col gap-3">
              <div
                v-for="ag in agendamentosdia"
                :key="ag.id"
                class="group relative bg-white rounded-2xl border shadow-sm hover:shadow-lg transition-all duration-200 overflow-hidden cursor-pointer active:scale-[0.99]"
                :class="ag.status === 'confirmado' ? 'border-green-200' : ag.status === 'concluido' ? 'border-violet-200 opacity-80' : 'border-gray-100'"
                @click="abrirDetalheKanban(ag)"
              >
                <!-- Barra colorida + foto pet (col esquerda) -->
                <div class="flex">
                  <div class="relative shrink-0 w-[72px] flex flex-col items-center justify-center py-4 bg-slate-50 border-r border-gray-100">
                    <!-- foto ou emoji -->
                    <div class="w-11 h-11 rounded-xl overflow-hidden shadow-sm ring-2 ring-white">
                      <img v-if="ag.animal_foto_url" :src="ag.animal_foto_url" :alt="ag.animal_nome ?? ''" class="w-full h-full object-cover" />
                      <div v-else class="w-full h-full flex items-center justify-center text-2xl bg-gray-100">{{ especieEmoji(ag.animal_especie) }}</div>
                    </div>
                    <!-- Status strip na borda esquerda -->
                    <div class="absolute left-0 top-0 bottom-0 w-1" :class="agKanbanStatusCor(ag.status)" />
                  </div>

                  <div class="flex-1 min-w-0 px-4 py-3 flex flex-col justify-center">
                    <div class="flex items-start justify-between gap-2 mb-1">
                      <div class="min-w-0">
                        <p class="text-sm font-black text-gray-900 leading-tight truncate">{{ ag.cliente_nome ?? ag.nome_solicitante ?? '—' }}</p>
                        <p v-if="ag.animal_nome" class="text-xs font-semibold text-pink-500 truncate">{{ ag.animal_nome }}</p>
                      </div>
                      <div class="shrink-0 flex flex-col items-end gap-1">
                        <span class="text-base font-black leading-none" :style="{ color: 'var(--color-primary, #ec4899)' }">{{ agKanbanFormatHora(ag.data_hora) }}</span>
                      </div>
                    </div>
                    <div class="flex items-center justify-between gap-2">
                      <p v-if="ag.servicos_nomes" class="text-[11px] text-gray-400 truncate flex-1">{{ ag.servicos_nomes }}</p>
                      <span class="shrink-0 inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-bold" :class="agKanbanStatusBadge(ag.status)">{{ agKanbanStatusLabel(ag.status) }}</span>
                    </div>
                  </div>

                  <div class="flex items-center pr-3">
                    <svg class="w-4 h-4 text-gray-200 group-hover:text-gray-400 transition-colors" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </template>
      </div>

      <!-- Separador tarefas -->
      <div class="flex items-center gap-3 px-5 sm:px-6 my-5">
        <div class="flex-1 h-px bg-gray-100" />
        <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Minhas Tarefas</span>
        <div class="flex-1 h-px bg-gray-100" />
      </div>

      <!-- Frase motivacional -->
      <div v-if="funcionarioLogado" class="mx-4 sm:mx-6 mb-5 flex items-center gap-3 px-4 py-3 rounded-2xl bg-gradient-to-r from-pink-50 to-rose-50 border border-pink-100">
        <div class="shrink-0 w-8 h-8 rounded-xl flex items-center justify-center" :style="{ background: 'var(--color-primary-bg)' }">
          <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z"/></svg>
        </div>
        <p class="text-sm font-semibold text-gray-700 leading-snug">{{ fraseAtual }}</p>
      </div>

      <!-- Tabs -->
      <div class="px-4 sm:px-6">
        <div class="flex gap-2 mb-5 overflow-x-auto scrollbar-none">
          <button
            v-for="tab in tabs"
            :key="tab.value"
            type="button"
            class="shrink-0 inline-flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-bold transition-all duration-150"
            :style="tabAtiva === tab.value ? { background: 'var(--color-primary-bg)', color: '#fff' } : {}"
            :class="tabAtiva === tab.value ? 'shadow-md' : 'bg-white text-gray-600 border border-gray-200 hover:border-pink-300'"
            @click="tabAtiva = tab.value"
          >
            {{ tab.label }}
            <span class="inline-flex items-center justify-center min-w-[20px] h-5 px-1 rounded-full text-xs font-black"
              :class="tabAtiva === tab.value ? 'bg-white/25 text-white' : 'bg-gray-100 text-gray-500'">
              {{ atividadesPorTab(tab.value).length }}
            </span>
          </button>
        </div>

        <!-- Ativas -->
        <div v-if="ativasTab(tabAtiva).length > 0" class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4 mb-6">
          <div
            v-for="at in ativasTab(tabAtiva)"
            :key="at.id"
            class="group bg-white rounded-2xl border shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden"
            :class="at.status === 'em_andamento' ? 'border-blue-300 ring-2 ring-blue-100' : at.prioridade === 'urgente' ? 'border-red-200' : 'border-gray-100'"
          >
            <div v-if="at.status === 'em_andamento'" class="h-1 w-full bg-blue-100 overflow-hidden">
              <div class="h-full bg-gradient-to-r from-blue-400 via-blue-600 to-blue-400 animate-pulse" />
            </div>
            <div v-else class="h-1" :class="prioridadeAccent(at.prioridade)" />
            <div class="relative px-5 pt-4 pb-3 overflow-hidden" :style="{ background: 'var(--color-primary-bg)' }">
              <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.12),transparent_65%)]" />
              <div class="relative flex items-start justify-between gap-2">
                <h3 class="font-black text-white text-sm leading-snug">{{ at.titulo }}</h3>
                <span class="shrink-0 inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-full"
                  :class="at.status === 'em_andamento' ? 'bg-blue-500/20 text-blue-200' : 'bg-white/10 text-white/80'">
                  <span v-if="at.status === 'em_andamento'" class="w-1.5 h-1.5 rounded-full bg-blue-300 animate-ping" />
                  <span v-else :class="['w-1.5 h-1.5 rounded-full', statusDotClass(at.status)]" />
                  {{ statusLabel(at.status) }}
                </span>
              </div>
              <p v-if="at.descricao" class="relative mt-1.5 text-xs text-white/60 leading-relaxed line-clamp-2">{{ at.descricao }}</p>
            </div>
            <div class="px-5 py-4 flex flex-col gap-3">
              <div class="flex flex-wrap gap-2">
                <span :class="['inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-full', prioridadeBadgeClass(at.prioridade)]">{{ prioridadeLabel(at.prioridade) }}</span>
                <span :class="['inline-flex items-center gap-1 text-[11px] font-bold px-2 py-0.5 rounded-full', periodicidadeBadgeClass(at.periodicidade)]">{{ periodicidadeLabel(at.periodicidade) }}</span>
              </div>
              <div class="flex items-center justify-between border-t border-gray-50 pt-2 text-xs text-gray-400">
                <span class="flex items-center gap-1">
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5"/></svg>
                  {{ at.data_atividade ? formatarData(at.data_atividade) : 'Sem data' }}
                </span>
                <span v-if="at.hora_inicio" class="flex items-center gap-1">
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.75v5.25l3 1.5"/></svg>
                  {{ at.hora_inicio }}{{ at.hora_fim ? ` → ${at.hora_fim}` : '' }}
                </span>
              </div>
              <div class="flex gap-2 pt-1" v-if="at.status !== 'concluida' && at.status !== 'cancelada'">
                <button v-if="at.status === 'pendente'" type="button"
                  class="flex-1 text-xs font-bold py-2 rounded-xl bg-blue-50 text-blue-700 hover:bg-blue-100 border border-blue-100 transition-colors"
                  :disabled="atualizando === at.id" @click="alterarStatus(at, 'em_andamento')">
                  {{ atualizando === at.id ? '...' : '▶ Iniciar' }}
                </button>
                <button v-if="at.status === 'em_andamento'" type="button"
                  class="flex-1 text-xs font-bold py-2 rounded-xl bg-green-50 text-green-700 hover:bg-green-100 border border-green-100 transition-colors"
                  :disabled="atualizando === at.id" @click="alterarStatus(at, 'concluida')">
                  {{ atualizando === at.id ? '...' : '✓ Concluir' }}
                </button>
              </div>
              <div v-else-if="at.status === 'concluida'" class="flex items-center gap-1.5 text-xs font-bold text-green-600 pt-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                Concluída
              </div>
            </div>
          </div>
        </div>

        <!-- Tudo concluído -->
        <div v-if="ativasTab(tabAtiva).length === 0 && concluidasTab(tabAtiva).length > 0"
          class="relative overflow-hidden rounded-2xl p-5 shadow-md mb-6" :style="{ background: 'var(--color-primary-bg)' }">
          <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.18),transparent_60%)]" />
          <div class="relative flex items-center gap-4">
            <div class="shrink-0 w-14 h-14 rounded-2xl bg-white/20 border border-white/30 flex items-center justify-center text-3xl">🐾</div>
            <div>
              <p class="text-base font-black text-white">Parabéns, {{ funcionarioLogado ? primeiroNome(funcionarioLogado.nome) : 'campeão' }}!</p>
              <p class="text-sm text-white/80 mt-0.5">Todas as tarefas desta aba foram concluídas. 🎉</p>
            </div>
          </div>
        </div>

        <!-- Vazio -->
        <div v-if="atividadesPorTab(tabAtiva).length === 0" class="flex flex-col items-center justify-center py-16 gap-3">
          <svg class="w-14 h-14 text-gray-200" fill="none" stroke="currentColor" stroke-width="1.25" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
          <span class="text-sm font-semibold text-gray-400">Nenhuma atividade neste período</span>
        </div>

        <!-- Concluídas colapsáveis -->
        <div v-if="concluidasTab(tabAtiva).length > 0" class="mt-6 mb-8">
          <button type="button" class="w-full flex items-center gap-3 mb-3" @click="mostrarConcluidas = !mostrarConcluidas">
            <div class="flex-1 h-px bg-gray-100" />
            <span class="inline-flex items-center gap-1.5 text-xs font-bold text-gray-400 bg-gray-50 border border-gray-200 px-3 py-1 rounded-full hover:bg-gray-100 transition-colors">
              <svg class="w-3 h-3 transition-transform duration-200" :class="mostrarConcluidas ? 'rotate-180' : ''" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/></svg>
              Concluídas ({{ concluidasTab(tabAtiva).length }})
            </span>
            <div class="flex-1 h-px bg-gray-100" />
          </button>
          <Transition name="slide-down">
            <div v-if="mostrarConcluidas" class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-3 opacity-60">
              <div v-for="at in concluidasTab(tabAtiva)" :key="at.id" class="bg-white rounded-xl border border-gray-100 px-4 py-3 flex items-start gap-2.5">
                <svg class="w-4 h-4 text-green-400 shrink-0 mt-0.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <div>
                  <p class="text-sm font-semibold text-gray-400 line-through decoration-gray-300">{{ at.titulo }}</p>
                  <span :class="['inline-flex items-center text-[10px] font-bold px-1.5 py-0.5 rounded-full mt-1', prioridadeBadgeClass(at.prioridade)]">{{ prioridadeLabel(at.prioridade) }}</span>
                </div>
              </div>
            </div>
          </Transition>
        </div>
      </div>
    </template>

    <!-- ══════════════════════════════════════════════ VISÃO ADMIN -->
    <template v-else-if="isAdminOrGerente">

      <!-- Hero admin -->
      <section class="relative overflow-hidden" :style="{ background: 'var(--color-primary-bg)' }">
        <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.15),transparent_55%)]" />
        <div class="absolute -bottom-8 -left-8 w-48 h-48 rounded-full bg-white/5" />
        <div class="absolute top-0 right-0 w-72 h-72 rounded-full bg-white/[0.04] translate-x-1/3 -translate-y-1/3" />
        <PageLogo />
        <div class="relative px-5 sm:px-8 pt-5 pb-6">
          <div class="flex flex-wrap items-center justify-between gap-4">
            <div>
              <p class="text-[11px] font-bold uppercase tracking-[0.25em] text-white/60 mb-1">VetFlow · Painel Admin</p>
              <h1 class="text-2xl sm:text-3xl font-black text-white leading-tight">Visão Geral</h1>
              <p class="text-sm text-white/60 mt-1 capitalize">{{ dataHoje }}</p>
            </div>
            <button type="button"
              class="inline-flex items-center gap-2 text-sm font-semibold px-4 py-2.5 rounded-xl transition-all"
              :class="filtroAberto ? 'bg-white text-pink-600 shadow-lg' : 'bg-white/15 text-white hover:bg-white/25 border border-white/20'"
              @click="filtroAberto = !filtroAberto">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/></svg>
              Filtros
              <span v-if="filtroPeriodo !== 'mes_atual'" class="w-2 h-2 rounded-full bg-pink-400" />
            </button>
          </div>

          <!-- KPIs hero -->
          <div v-if="!resumoLoading" class="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-5">
            <div class="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl px-4 py-3.5">
              <p class="text-[10px] font-black uppercase tracking-widest text-white/60 mb-1">Faturamento</p>
              <p class="text-xl font-black text-white truncate">{{ formatCurrency(faturamentoMes) }}</p>
              <p class="text-[10px] text-white/50 mt-0.5">{{ periodoLabelAtual }}</p>
            </div>
            <div class="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl px-4 py-3.5">
              <p class="text-[10px] font-black uppercase tracking-widest text-white/60 mb-1">Agendamentos</p>
              <p class="text-xl font-black text-white">{{ agendamentosMes }}</p>
              <p class="text-[10px] text-white/50 mt-0.5">no período</p>
            </div>
            <div class="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl px-4 py-3.5">
              <p class="text-[10px] font-black uppercase tracking-widest text-white/60 mb-1">Ticket Médio</p>
              <p class="text-xl font-black text-white truncate">{{ formatCurrency(ticketMedio) }}</p>
              <p class="text-[10px] text-white/50 mt-0.5">por atendimento</p>
            </div>
            <div class="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl px-4 py-3.5">
              <p class="text-[10px] font-black uppercase tracking-widest text-white/60 mb-1">Clientes</p>
              <p class="text-xl font-black text-white">{{ totalClientes }}</p>
              <p class="text-[10px] text-white/50 mt-0.5">cadastrados</p>
            </div>
          </div>
          <div v-else class="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-5">
            <div v-for="n in 4" :key="n" class="bg-white/10 rounded-2xl h-20 animate-pulse" />
          </div>
        </div>
      </section>

      <!-- Filtro avançado -->
      <Transition name="slide-down">
        <div v-if="filtroAberto" class="mx-4 sm:mx-0 mt-4 bg-white rounded-3xl border border-gray-100 shadow-md overflow-hidden">
          <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100 bg-gray-50/60">
            <span class="text-sm font-black text-gray-700">Filtro de Período</span>
            <button type="button" class="text-xs font-bold text-pink-500 hover:text-pink-700" @click="resetarFiltros">Redefinir</button>
          </div>
          <div class="px-6 py-5 grid grid-cols-1 sm:grid-cols-2 gap-6">
            <div>
              <p class="text-[10px] font-black uppercase tracking-widest text-pink-500 mb-3">Período</p>
              <div class="grid grid-cols-2 gap-2">
                <button v-for="opt in periodoOpcoes" :key="opt.value" type="button"
                  class="flex items-center gap-2 px-3 py-2.5 rounded-xl border text-sm font-semibold transition-all text-left"
                  :class="filtroPeriodo === opt.value ? 'bg-pink-50 border-pink-300 text-pink-600' : 'border-gray-200 text-gray-600 hover:border-pink-200'"
                  @click="filtroPeriodo = opt.value; aplicarFiltros()">
                  <span class="w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center shrink-0" :class="filtroPeriodo === opt.value ? 'border-pink-500' : 'border-gray-300'">
                    <span v-if="filtroPeriodo === opt.value" class="w-1.5 h-1.5 rounded-full bg-pink-500" />
                  </span>
                  {{ opt.label }}
                </button>
              </div>
            </div>
            <div>
              <p class="text-[10px] font-black uppercase tracking-widest text-pink-500 mb-3">Mês / Ano Específico</p>
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-xs font-semibold text-gray-500 mb-1.5">Mês</label>
                  <select v-model="filtroMes" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-pink-300" @change="filtroPeriodo = 'personalizado'; aplicarFiltros()">
                    <option v-for="m in mesesOpcoes" :key="m.value" :value="m.value">{{ m.label }}</option>
                  </select>
                </div>
                <div>
                  <label class="block text-xs font-semibold text-gray-500 mb-1.5">Ano</label>
                  <select v-model="filtroAno" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-pink-300" @change="filtroPeriodo = 'personalizado'; aplicarFiltros()">
                    <option v-for="a in anosOpcoes" :key="a" :value="a">{{ a }}</option>
                  </select>
                </div>
              </div>
              <p class="mt-2 text-xs text-gray-400">Exibindo: <span class="font-bold text-gray-600">{{ periodoLabelAtual }}</span></p>
            </div>
          </div>
        </div>
      </Transition>

      <div class="px-4 sm:px-0 mt-6 space-y-10 pb-14">

        <!-- Alertas -->
        <div v-if="!resumoLoading && (contasVencidas > 0 || produtosBaixoEstoque > 0)" class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div v-if="contasVencidas > 0" class="flex items-center gap-3 bg-red-50 border border-red-200 rounded-2xl px-4 py-3">
            <div class="w-9 h-9 rounded-xl bg-red-100 flex items-center justify-center shrink-0">
              <svg class="w-4 h-4 text-red-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/></svg>
            </div>
            <div>
              <p class="text-sm font-black text-red-700">{{ contasVencidas }} conta(s) vencida(s)</p>
              <p class="text-xs text-red-500">Regularize para evitar encargos</p>
            </div>
            <NuxtLink to="/contas-pagar" class="ml-auto shrink-0 text-xs font-bold text-red-600 hover:text-red-800 underline">Ver</NuxtLink>
          </div>
          <div v-if="produtosBaixoEstoque > 0" class="flex items-center gap-3 bg-amber-50 border border-amber-200 rounded-2xl px-4 py-3">
            <div class="w-9 h-9 rounded-xl bg-amber-100 flex items-center justify-center shrink-0">
              <svg class="w-4 h-4 text-amber-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"/></svg>
            </div>
            <div>
              <p class="text-sm font-black text-amber-700">{{ produtosBaixoEstoque }} produto(s) com estoque baixo</p>
              <p class="text-xs text-amber-500">Reponha antes de acabar</p>
            </div>
            <NuxtLink to="/estoque" class="ml-auto shrink-0 text-xs font-bold text-amber-600 hover:text-amber-800 underline">Ver</NuxtLink>
          </div>
        </div>

        <!-- KPIs operacionais -->
        <div>
          <div class="flex items-center gap-3 mb-5">
            <div class="w-1 h-5 rounded-full" style="background: var(--color-primary)" />
            <span class="text-xs font-black uppercase tracking-widest text-gray-700">Operacional</span>
            <div class="flex-1 h-px bg-gray-200" />
            <span class="text-[10px] font-bold text-gray-400">{{ periodoLabelAtual }}</span>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
            <NuxtLink to="/contas-pagar" class="group relative overflow-hidden rounded-2xl bg-white border border-gray-100 p-4 shadow-sm hover:shadow-md hover:border-pink-200 transition-all">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-8 h-8 rounded-xl bg-pink-50 flex items-center justify-center">
                  <svg class="w-4 h-4 text-pink-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z"/></svg>
                </div>
                <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Contas</span>
              </div>
              <p class="text-xl font-black text-gray-900 truncate">{{ resumoLoading ? '...' : formatCurrency(valorContasPagar) }}</p>
              <p class="text-xs text-gray-500 mt-1">{{ totalContasPagar }} em aberto</p>
              <div class="absolute bottom-0 right-0 w-16 h-16 rounded-full bg-pink-50 translate-x-6 translate-y-6 group-hover:bg-pink-100 transition-colors" />
            </NuxtLink>

            <NuxtLink to="/contas-pagar" class="group relative overflow-hidden rounded-2xl border p-4 shadow-sm hover:shadow-md transition-all"
              :class="contasVencidas > 0 ? 'bg-red-50 border-red-200' : 'bg-white border-gray-100 hover:border-pink-200'">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-8 h-8 rounded-xl flex items-center justify-center" :class="contasVencidas > 0 ? 'bg-red-100' : 'bg-gray-50'">
                  <svg class="w-4 h-4" :class="contasVencidas > 0 ? 'text-red-500' : 'text-gray-400'" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/></svg>
                </div>
                <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Vencidas</span>
                <span v-if="contasVencidas > 0" class="w-2 h-2 rounded-full bg-red-500 animate-ping ml-auto" />
              </div>
              <p class="text-2xl font-black" :class="contasVencidas > 0 ? 'text-red-600' : 'text-gray-900'">{{ resumoLoading ? '...' : contasVencidas }}</p>
              <p class="text-xs mt-1" :class="contasVencidas > 0 ? 'text-red-400' : 'text-gray-500'">{{ contasVencidas > 0 ? 'atenção necessária' : 'tudo em dia ✅' }}</p>
            </NuxtLink>

            <NuxtLink to="/estoque" class="group relative overflow-hidden rounded-2xl bg-white border border-gray-100 p-4 shadow-sm hover:shadow-md hover:border-pink-200 transition-all">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-8 h-8 rounded-xl bg-violet-50 flex items-center justify-center">
                  <svg class="w-4 h-4 text-violet-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"/></svg>
                </div>
                <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Estoque</span>
              </div>
              <p class="text-2xl font-black text-gray-900">{{ resumoLoading ? '...' : produtosTotal }}</p>
              <p class="text-xs text-gray-500 mt-1">
                <span v-if="produtosBaixoEstoque > 0" class="text-amber-500 font-bold">{{ produtosBaixoEstoque }} estoque baixo</span>
                <span v-else>todos ok</span>
              </p>
              <div class="absolute bottom-0 right-0 w-16 h-16 rounded-full bg-violet-50 translate-x-6 translate-y-6 group-hover:bg-violet-100 transition-colors" />
            </NuxtLink>

            <NuxtLink to="/atividades" class="group relative overflow-hidden rounded-2xl bg-white border border-gray-100 p-4 shadow-sm hover:shadow-md hover:border-pink-200 transition-all">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center">
                  <svg class="w-4 h-4 text-blue-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
                </div>
                <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Tarefas</span>
              </div>
              <p class="text-2xl font-black text-gray-900">{{ resumoLoading ? '...' : tarefasHoje }}</p>
              <p class="text-xs text-gray-500 mt-1">{{ tarefasConcluidasHoje }} concluídas</p>
              <div class="absolute bottom-0 right-0 w-16 h-16 rounded-full bg-blue-50 translate-x-6 translate-y-6 group-hover:bg-blue-100 transition-colors" />
            </NuxtLink>
          </div>
        </div>

        <!-- Agendamentos de hoje (admin) -->
        <div>
          <div class="flex items-center gap-3 mb-5">
            <div class="w-1 h-5 rounded-full" style="background: var(--color-primary)" />
            <span class="text-xs font-black uppercase tracking-widest text-gray-700">Agendamentos de Hoje</span>
            <div class="flex-1 h-px bg-gray-200" />
            <NuxtLink to="/agendamentos" class="text-[11px] font-bold text-pink-500 hover:text-pink-700 transition-colors">Ver todos →</NuxtLink>
          </div>
          <div v-if="agendamentosHojeLoading" class="flex justify-center py-8">
            <div class="w-7 h-7 rounded-full border-4 border-gray-100 border-t-pink-400 animate-spin" />
          </div>
          <div v-else-if="agendamentosHoje.length === 0" class="flex flex-col items-center justify-center py-10 gap-2 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
            <span class="text-2xl">📅</span>
            <p class="text-sm font-semibold text-gray-400">Nenhum agendamento hoje</p>
          </div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            <div
              v-for="ag in agendamentosHoje.slice(0, 6)"
              :key="ag.id"
              class="group bg-white rounded-3xl shadow-md hover:shadow-2xl hover:-translate-y-1 transition-all duration-200 overflow-hidden cursor-pointer active:scale-[0.99] flex flex-col"
              @click="abrirDetalheKanban(ag)"
            >
              <!-- ── Topo gradiente ── -->
              <div class="relative flex items-center gap-4 px-5 pt-5 pb-5" style="background: var(--color-primary-bg)">
                <!-- Pata decorativa watermark -->
                <svg class="absolute top-3 right-4 w-12 h-12 opacity-10 text-white" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2a2.5 2.5 0 100 5 2.5 2.5 0 000-5zm-5 3a2 2 0 100 4 2 2 0 000-4zm10 0a2 2 0 100 4 2 2 0 000-4zM4.5 9a2 2 0 100 4 2 2 0 000-4zm15 0a2 2 0 100 4 2 2 0 000-4zM12 10c-3.3 0-6 2-6 5.5 0 2.5 1.5 3.5 3 3.5.8 0 1.5-.3 2.1-.8.3-.2.5-.2.8 0 .6.5 1.3.8 2.1.8 1.5 0 3-1 3-3.5 0-3.5-2.7-5.5-6-5.5z"/>
                </svg>

                <!-- Foto circular do pet -->
                <div class="shrink-0 w-16 h-16 rounded-full overflow-hidden ring-4 ring-white/40 shadow-lg">
                  <img
                    v-if="ag.animal_foto_url"
                    :src="ag.animal_foto_url"
                    :alt="ag.animal_nome ?? ''"
                    class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                  />
                  <div v-else class="w-full h-full flex items-center justify-center text-3xl bg-white/20">
                    {{ especieEmoji(ag.animal_especie) }}
                  </div>
                </div>

                <!-- Nome + cliente/profissional -->
                <div class="flex-1 min-w-0">
                  <p class="text-xl font-black text-white truncate leading-tight">{{ ag.animal_nome ?? '—' }}</p>
                  <div class="flex items-center gap-1.5 mt-1">
                    <svg class="w-3.5 h-3.5 text-white/60 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/></svg>
                    <span class="text-sm font-semibold text-white/80 truncate">{{ ag.cliente_nome ?? ag.nome_solicitante ?? '—' }}</span>
                  </div>
                  <div v-if="ag.funcionario_nome" class="flex items-center gap-1.5 mt-0.5">
                    <svg class="w-3 h-3 text-white/50 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M11.42 15.17L17.25 21A2.652 2.652 0 0021 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 11-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 004.486-6.336l-3.276 3.277a3.004 3.004 0 01-2.25-2.25l3.276-3.276a4.5 4.5 0 00-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437l1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008z"/></svg>
                    <span class="text-[11px] font-medium text-white/50 truncate">{{ ag.funcionario_nome }}</span>
                  </div>
                </div>

                <!-- Badge hora glassmorphism -->
                <div class="shrink-0 flex items-center gap-2 bg-white/20 backdrop-blur-sm border border-white/25 rounded-2xl px-3 py-2 shadow">
                  <svg class="w-4 h-4 text-white/80" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/></svg>
                  <span class="text-base font-black text-white">{{ agKanbanFormatHora(ag.data_hora) }}</span>
                </div>
              </div>

              <!-- ── Rodapé branco ── -->
              <div class="flex items-center justify-between gap-3 px-5 py-3.5 bg-white">
                <!-- Serviço com ícone -->
                <div class="flex items-center gap-2.5 min-w-0">
                  <div class="w-9 h-9 rounded-xl flex items-center justify-center shrink-0 bg-sky-50">
                    <svg class="w-5 h-5 text-sky-400" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                  </div>
                  <span class="text-sm font-bold text-gray-800 truncate">{{ ag.servicos_nomes ?? 'Serviço' }}</span>
                </div>

                <!-- Status badge com ícone -->
                <div class="shrink-0 flex items-center gap-1.5 rounded-full px-3 py-1.5 text-sm font-bold" :class="agKanbanStatusBadge(ag.status)">
                  <!-- ícone por status -->
                  <svg v-if="ag.status === 'concluido'" class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                  <svg v-else-if="ag.status === 'confirmado'" class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5"/></svg>
                  <svg v-else-if="ag.status === 'agendado'" class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5"/></svg>
                  <svg v-else-if="ag.status === 'solicitado'" class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0"/></svg>
                  <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z"/></svg>
                  {{ agKanbanStatusLabel(ag.status) }}
                </div>
              </div>
            </div>
            <NuxtLink v-if="agendamentosHoje.length > 6" to="/agendamentos"
              class="flex items-center justify-center bg-gray-50 rounded-2xl border border-dashed border-gray-200 text-sm font-bold text-gray-400 hover:text-pink-500 hover:border-pink-200 transition-all py-6">
              +{{ agendamentosHoje.length - 6 }} mais hoje
            </NuxtLink>
          </div>
        </div>

        <!-- Atalhos -->
        <div>
          <div class="flex items-center gap-3 mb-5">
            <div class="w-1 h-5 rounded-full" style="background: var(--color-primary)" />
            <span class="text-xs font-black uppercase tracking-widest text-gray-700">Acesso Rápido</span>
            <div class="flex-1 h-px bg-gray-200" />
          </div>
          <div class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-2 sm:gap-3">
            <NuxtLink
              v-for="atalho in atalhosVisiveis"
              :key="atalho.to"
              :to="atalho.to"
              class="group relative overflow-hidden flex flex-col items-center justify-center gap-2.5 py-5 px-2 rounded-2xl shadow-sm hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200"
              :style="{ background: 'var(--color-primary-bg, var(--color-primary, #ec4899))' }"
            >
              <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(255,255,255,0.15),transparent_65%)] pointer-events-none" />
              <AppNavIcon :name="atalho.icon" class="relative w-6 h-6 text-white transition-transform duration-200 group-hover:scale-110" />
              <span class="relative text-[11px] font-bold text-white/90 text-center leading-tight">{{ atalho.title }}</span>
            </NuxtLink>
          </div>
        </div>

      </div>
    </template>

  </div>

  <!-- Modal detalhe agendamento -->
  <Teleport to="body">
    <Transition name="fade">
      <div v-if="detalheKanban" class="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4">
        <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" @click="detalheKanban = null" />
        <div class="relative w-full max-w-sm bg-white rounded-3xl shadow-2xl overflow-hidden">
          <div class="h-1.5 w-full" :class="agKanbanStatusCor(detalheKanban.status)" />
          <div class="px-6 pt-5 pb-2 flex items-start justify-between gap-3">
            <div class="flex items-center gap-3">
              <!-- Avatar pet no modal -->
              <div class="w-14 h-14 rounded-2xl overflow-hidden shadow-md ring-2 ring-gray-100 shrink-0 bg-gray-50">
                <img v-if="detalheKanban.animal_foto_url" :src="detalheKanban.animal_foto_url" :alt="detalheKanban.animal_nome ?? ''" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center text-3xl">{{ especieEmoji(detalheKanban.animal_especie) }}</div>
              </div>
              <div>
                <p class="text-xs font-bold uppercase tracking-widest text-gray-400 mb-0.5">Agendamento</p>
                <p class="text-lg font-black text-gray-900 leading-tight">{{ detalheKanban.cliente_nome ?? detalheKanban.nome_solicitante ?? '—' }}</p>
              </div>
            </div>
            <button type="button" class="shrink-0 w-8 h-8 flex items-center justify-center rounded-xl bg-gray-100 text-gray-500 hover:bg-gray-200 transition-colors mt-0.5" @click="detalheKanban = null">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
          </div>
          <div class="px-6 pb-6 flex flex-col gap-3">
            <div class="flex items-center gap-3 bg-gray-50 rounded-2xl px-4 py-3">
              <svg class="w-4 h-4 shrink-0 text-gray-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
              <div>
                <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Data e hora</p>
                <p class="text-sm font-bold text-gray-800">
                  {{ new Date(detalheKanban.data_hora.slice(0,10) + 'T12:00:00').toLocaleDateString('pt-BR', { weekday: 'long', day: '2-digit', month: 'long' }) }}
                  · {{ agKanbanFormatHora(detalheKanban.data_hora) }}
                </p>
              </div>
            </div>
            <div v-if="detalheKanban.animal_nome" class="flex items-center gap-3 bg-pink-50 rounded-2xl px-4 py-3">
              <span class="text-base">🐾</span>
              <div>
                <p class="text-[10px] font-bold text-pink-400 uppercase tracking-widest">Pet</p>
                <p class="text-sm font-bold text-pink-700">{{ detalheKanban.animal_nome }}</p>
              </div>
            </div>
            <div v-if="detalheKanban.servicos_nomes" class="flex items-center gap-3 bg-gray-50 rounded-2xl px-4 py-3">
              <svg class="w-4 h-4 shrink-0 text-gray-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
              <div>
                <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Serviço(s)</p>
                <p class="text-sm font-semibold text-gray-800">{{ detalheKanban.servicos_nomes }}</p>
              </div>
            </div>
            <div v-if="detalheKanban.funcionario_nome" class="flex items-center gap-3 bg-indigo-50 rounded-2xl px-4 py-3">
              <svg class="w-4 h-4 shrink-0 text-indigo-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
              <div>
                <p class="text-[10px] font-bold text-indigo-400 uppercase tracking-widest">Profissional</p>
                <p class="text-sm font-bold text-indigo-700">{{ detalheKanban.funcionario_nome }}</p>
              </div>
            </div>
            <div v-if="detalheKanban.observacoes" class="flex items-start gap-3 bg-amber-50 rounded-2xl px-4 py-3">
              <svg class="w-4 h-4 shrink-0 text-amber-400 mt-0.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
              <div>
                <p class="text-[10px] font-bold text-amber-500 uppercase tracking-widest">Observações</p>
                <p class="text-sm text-amber-800">{{ detalheKanban.observacoes }}</p>
              </div>
            </div>
            <div class="flex items-center justify-between gap-2 flex-wrap">
              <span class="inline-flex items-center rounded-full px-3 py-1.5 text-xs font-semibold" :class="agKanbanStatusBadge(detalheKanban.status)">{{ agKanbanStatusLabel(detalheKanban.status) }}</span>
              <div class="flex items-center gap-2">
                <NuxtLink v-if="detalheKanban.animal_id" :to="`/prontuarios?animal_id=${detalheKanban.animal_id}&agendamento_id=${detalheKanban.id}`"
                  class="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-violet-500 text-white text-xs font-bold hover:bg-violet-600 transition-colors"
                  @click="detalheKanban = null">
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                  Prontuário
                </NuxtLink>
                <a v-if="detalheKanban.cliente_telefone"
                  :href="`https://wa.me/55${detalheKanban.cliente_telefone.replace(/\D/g, '')}`"
                  target="_blank" rel="noopener noreferrer"
                  class="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-green-500 text-white text-sm font-bold hover:bg-green-600 transition-colors">
                  <svg class="w-4 h-4" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                  WhatsApp
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useAdmin } from '~/composables/useAdmin'
import { useEmpresa } from '~/composables/useEmpresa'
import { createSupabaseClient } from '~/lib/supabase'
import AppNavIcon from '~/components/AppNavIcon.vue'

const supabase = createSupabaseClient()
const { isAdmin, isAdminOrGerente, adminLoading } = useAdmin()
const { empresaId, userPerfil, loadEmpresa } = useEmpresa()

// ── ADMIN: KPIs ───────────────────────────────────────────────────────────────
const resumoLoading      = ref(true)
const totalClientes      = ref(0)
const clientesAtivos     = ref(0)
const agendamentosMes    = ref(0)
const faturamentoMes     = ref(0)
const totalContasPagar   = ref(0)
const valorContasPagar   = ref(0)
const contasVencidas     = ref(0)
const tarefasHoje           = ref(0)
const tarefasConcluidasHoje = ref(0)
const tarefasPendentes      = ref(0)
const produtosTotal         = ref(0)
const produtosBaixoEstoque  = ref(0)
const ticketMedio           = ref(0)

// ── ADMIN: Agendamentos de hoje ───────────────────────────────────────────────
const agendamentosHoje        = ref<AgKanban[]>([])
const agendamentosHojeLoading = ref(false)

async function fetchAgendamentosHoje() {
  if (!empresaId.value) return
  agendamentosHojeLoading.value = true
  const todayIso = new Date().toISOString().slice(0, 10)
  const { data } = await supabase
    .from('agendamentos')
    .select('id, data_hora, status, observacoes, nome_solicitante, telefone_solicitante, funcionario_id, animal_id, clientes(nome, telefone), animais(nome, foto_url, especie)')
    .eq('empresa_id', empresaId.value)
    .gte('data_hora', todayIso + 'T00:00:00')
    .lte('data_hora', todayIso + 'T23:59:59')
    .not('status', 'in', '(cancelado)')
    .order('data_hora', { ascending: true })
  const rows = data ?? []
  const ids = rows.map((r: any) => r.id)
  let servicosMap: Record<number, string[]> = {}
  if (ids.length) {
    const { data: agSvcs } = await supabase.from('agendamento_servicos').select('agendamento_id, servicos(nome)').in('agendamento_id', ids)
    ;(agSvcs ?? []).forEach((row: any) => {
      if (!servicosMap[row.agendamento_id]) servicosMap[row.agendamento_id] = []
      if (row.servicos?.nome) servicosMap[row.agendamento_id].push(row.servicos.nome)
    })
  }
  // Resolve funcionario names
  const funcIds = [...new Set(rows.map((r: any) => r.funcionario_id).filter(Boolean))] as string[]
  let funcNomeMap: Record<string, string> = {}
  if (funcIds.length) {
    const { data: funcs } = await supabase.from('funcionarios').select('user_id, nome').eq('empresa_id', empresaId.value)
    ;(funcs ?? []).forEach((f: any) => { funcNomeMap[f.user_id] = f.nome })
  }
  agendamentosHoje.value = rows.map((r: any) => ({
    id: r.id, data_hora: r.data_hora, status: r.status,
    observacoes: r.observacoes ?? null,
    cliente_nome: r.clientes?.nome ?? null,
    nome_solicitante: r.nome_solicitante ?? null,
    cliente_telefone: r.clientes?.telefone ?? r.telefone_solicitante ?? null,
    servicos_nomes: servicosMap[r.id]?.join(', ') ?? null,
    funcionario_nome: funcNomeMap[r.funcionario_id] ?? null,
    animal_nome: r.animais?.nome ?? null,
    animal_foto_url: r.animais?.foto_url ?? null,
    animal_especie: r.animais?.especie ?? null,
    animal_id: r.animal_id ?? null,
  }))
  agendamentosHojeLoading.value = false
}

// ── Filtros ───────────────────────────────────────────────────────────────────
const filtroAberto = ref(false)
const filtroPeriodo = ref<'mes_atual' | 'semana_atual' | 'trimestre' | 'ano_atual' | 'personalizado'>('mes_atual')
const filtroMes = ref(new Date().getMonth() + 1)
const filtroAno = ref(new Date().getFullYear())
const filtroOp = reactive({ agendamentos: true, contas: true, estoque: true, tarefas: true })

const periodoOpcoes = [
  { value: 'mes_atual',    label: 'Mês Atual' },
  { value: 'semana_atual', label: 'Semana Atual' },
  { value: 'trimestre',    label: 'Trimestre' },
  { value: 'ano_atual',    label: 'Ano Atual' },
]

const mesesOpcoes = [
  { value: 1, label: 'Janeiro' }, { value: 2, label: 'Fevereiro' }, { value: 3, label: 'Março' },
  { value: 4, label: 'Abril' },   { value: 5, label: 'Maio' },      { value: 6, label: 'Junho' },
  { value: 7, label: 'Julho' },   { value: 8, label: 'Agosto' },    { value: 9, label: 'Setembro' },
  { value: 10, label: 'Outubro' },{ value: 11, label: 'Novembro' }, { value: 12, label: 'Dezembro' },
]

const anosOpcoes = computed(() => {
  const y = new Date().getFullYear(); return [y - 2, y - 1, y, y + 1]
})

const periodoLabelAtual = computed(() => {
  if (filtroPeriodo.value === 'mes_atual') return new Date().toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' })
  if (filtroPeriodo.value === 'semana_atual') return 'Esta semana'
  if (filtroPeriodo.value === 'trimestre') {
    const q = Math.floor(new Date().getMonth() / 3) + 1
    return `${q}º Trimestre ${new Date().getFullYear()}`
  }
  if (filtroPeriodo.value === 'ano_atual') return `Ano ${new Date().getFullYear()}`
  const mes = mesesOpcoes.find(m => m.value === filtroMes.value)?.label ?? ''
  return `${mes} ${filtroAno.value}`
})

function getPeriodoRange(): { inicio: string; fim: string } {
  const now = new Date(); const y = now.getFullYear(), m = now.getMonth()
  if (filtroPeriodo.value === 'mes_atual')
    return { inicio: new Date(y, m, 1).toISOString().slice(0, 10), fim: new Date(y, m + 1, 0).toISOString().slice(0, 10) }
  if (filtroPeriodo.value === 'semana_atual') {
    const d = new Date(now); const day = d.getDay()
    const mon = new Date(d); mon.setDate(d.getDate() + (day === 0 ? -6 : 1 - day))
    const sun = new Date(mon); sun.setDate(mon.getDate() + 6)
    return { inicio: mon.toISOString().slice(0, 10), fim: sun.toISOString().slice(0, 10) }
  }
  if (filtroPeriodo.value === 'trimestre') {
    const q = Math.floor(m / 3)
    return { inicio: new Date(y, q * 3, 1).toISOString().slice(0, 10), fim: new Date(y, q * 3 + 3, 0).toISOString().slice(0, 10) }
  }
  if (filtroPeriodo.value === 'ano_atual') return { inicio: `${y}-01-01`, fim: `${y}-12-31` }
  const pm = filtroMes.value - 1, py = filtroAno.value
  return { inicio: new Date(py, pm, 1).toISOString().slice(0, 10), fim: new Date(py, pm + 1, 0).toISOString().slice(0, 10) }
}

function resetarFiltros() {
  filtroPeriodo.value = 'mes_atual'
  filtroMes.value = new Date().getMonth() + 1
  filtroAno.value = new Date().getFullYear()
  aplicarFiltros()
}

async function aplicarFiltros() {
  resumoLoading.value = true
  const { inicio, fim } = getPeriodoRange()
  const todayIso = new Date().toISOString().slice(0, 10)
  const [clientesResp, agendamentosResp, contasResp, tarefasResp, produtosResp] = await Promise.all([
    supabase.from('clientes').select('ativo').eq('empresa_id', empresaId.value!),
    supabase.from('agendamentos').select('valor_total, data_hora, status').eq('empresa_id', empresaId.value!).gte('data_hora', inicio).lte('data_hora', fim + 'T23:59:59'),
    supabase.from('contas_pagar').select('valor, data_vencimento, status').eq('empresa_id', empresaId.value!).gte('data_vencimento', inicio).lte('data_vencimento', fim),
    supabase.from('atividades_funcionarios').select('status, data_atividade').eq('empresa_id', empresaId.value!).gte('data_atividade', inicio).lte('data_atividade', fim),
    supabase.from('produtos_casa_racao').select('estoque, ativo').eq('empresa_id', empresaId.value!),
  ])
  const clientes = clientesResp.data ?? []
  totalClientes.value = clientes.length
  clientesAtivos.value = clientes.filter((c: any) => c.ativo !== false).length
  const agendamentos = agendamentosResp.data ?? []
  const confirmados = agendamentos.filter((a: any) => a.status !== 'cancelado')
  agendamentosMes.value = agendamentos.length
  faturamentoMes.value = confirmados.reduce((sum: number, a: any) => sum + Number(a.valor_total ?? 0), 0)
  ticketMedio.value = confirmados.length > 0 ? faturamentoMes.value / confirmados.length : 0
  const contas = (contasResp.data ?? []).filter((c: any) => c.status !== 'pago' && c.status !== 'cancelado')
  totalContasPagar.value = contas.length
  valorContasPagar.value = contas.reduce((sum: number, c: any) => sum + Number(c.valor ?? 0), 0)
  contasVencidas.value = contas.filter((c: any) => c.data_vencimento && c.data_vencimento < todayIso).length
  const tf = tarefasResp.data ?? []
  tarefasHoje.value = tf.length
  tarefasConcluidasHoje.value = tf.filter((t: any) => t.status === 'concluida').length
  tarefasPendentes.value = tf.filter((t: any) => t.status === 'pendente').length
  const prods = (produtosResp.data ?? []).filter((p: any) => p.ativo !== false)
  produtosTotal.value = prods.length
  produtosBaixoEstoque.value = prods.filter((p: any) => p.estoque <= 5).length
  resumoLoading.value = false
}

// ── FUNCIONÁRIO ───────────────────────────────────────────────────────────────
interface AtividadeFuncionario {
  id: number; titulo: string; descricao: string | null; status: string | null
  prioridade: string | null; periodicidade: string | null; data_atividade: string | null
  hora_inicio: string | null; hora_fim: string | null; observacao: string | null
}
interface FuncionarioLite { id: number; nome: string; cargo: string | null }

const funcionarioLogado  = ref<FuncionarioLite | null>(null)
const minhasAtividades   = ref<AtividadeFuncionario[]>([])
const loadingAtividades  = ref(true)
const atualizando        = ref<number | null>(null)
const tabAtiva           = ref<'hoje' | 'semana' | 'quinzena' | 'mes'>('hoje')
const mostrarConcluidas  = ref(false)

const funcKpis = computed(() => [
  { label: 'Pendentes', valor: countAtivStatus('pendente'), cor: 'text-pink-200' },
  { label: 'Andamento', valor: countAtivStatus('em_andamento'), cor: 'text-blue-200' },
  { label: 'Concluídas', valor: countAtivStatus('concluida'), cor: 'text-green-200' },
  { label: 'Urgentes', valor: minhasAtividades.value.filter(a => a.prioridade === 'urgente').length, cor: 'text-red-200' },
])

const tabs = [
  { label: 'Hoje', value: 'hoje' }, { label: 'Semana', value: 'semana' },
  { label: 'Quinzena', value: 'quinzena' }, { label: 'Mês', value: 'mes' },
] as const

const hoje = new Date(); hoje.setHours(0, 0, 0, 0)
const hojeIso = hoje.toISOString().split('T')[0]
const dataHoje = hoje.toLocaleDateString('pt-BR', { weekday: 'long', day: '2-digit', month: 'long', year: 'numeric' })

function toISODate(d: Date) { return d.toISOString().slice(0, 10) }
function inicioSemana(): Date { const d = new Date(hoje); d.setDate(d.getDate() - d.getDay()); return d }
function fimSemana(): Date { const d = new Date(inicioSemana()); d.setDate(d.getDate() + 6); return d }
function inicioQuinzena(): Date { const d = new Date(hoje); d.setDate(hoje.getDate() <= 15 ? 1 : 16); return d }
function fimQuinzena(): Date {
  const d = new Date(hoje)
  if (hoje.getDate() <= 15) { d.setDate(15) } else { d.setMonth(d.getMonth() + 1, 0) }
  return d
}
function inicioMes(): Date { return new Date(hoje.getFullYear(), hoje.getMonth(), 1) }
function fimMes(): Date { return new Date(hoje.getFullYear(), hoje.getMonth() + 1, 0) }

function ativasTab(tab: string) { return atividadesPorTab(tab).filter(a => a.status !== 'concluida' && a.status !== 'cancelada') }
function concluidasTab(tab: string) { return atividadesPorTab(tab).filter(a => a.status === 'concluida') }

const frasesMotivacionais = [
  'Cada animal cuidado aqui sai mais saudável e feliz — graças a você!',
  'O bem-estar animal começa com profissionais dedicados como você.',
  'Um atendimento com carinho faz toda a diferença na vida do pet!',
  'Sua habilidade salva e transforma vidas — isso é incrível!',
  'Organização e dedicação são o segredo de uma clínica de excelência.',
  'Hoje é mais um dia para cuidar, curar e fazer a diferença!',
  'Cada detalhe importa quando o objetivo é a saúde do animal.',
  'Tutores satisfeitos são a melhor propaganda do seu trabalho.',
]
const fraseAtual = computed(() => frasesMotivacionais[new Date().getDate() % frasesMotivacionais.length])

function atividadesPorTab(tab: string): AtividadeFuncionario[] {
  const todaIso = toISODate(hoje)
  return minhasAtividades.value.filter(a => {
    const dataAtiv = a.data_atividade
    if (tab === 'hoje') {
      if (a.periodicidade === 'diaria') return !dataAtiv || dataAtiv === todaIso
      return dataAtiv === todaIso
    }
    if (tab === 'semana') {
      if (a.periodicidade !== 'diaria') return false
      if (!dataAtiv) return true
      return dataAtiv >= toISODate(inicioSemana()) && dataAtiv <= toISODate(fimSemana())
    }
    if (tab === 'quinzena') {
      if (a.periodicidade !== 'quinzenal') return false
      if (!dataAtiv) return true
      return dataAtiv >= toISODate(inicioQuinzena()) && dataAtiv <= toISODate(fimQuinzena())
    }
    if (tab === 'mes') {
      if (a.periodicidade !== 'mensal') return false
      if (!dataAtiv) return true
      return dataAtiv >= toISODate(inicioMes()) && dataAtiv <= toISODate(fimMes())
    }
    return false
  })
}

function countAtivStatus(s: string) { return minhasAtividades.value.filter(a => a.status === s).length }
function primeiroNome(nome: string) { return nome.split(' ')[0] }
function formatarData(iso: string): string { const [y, m, d] = iso.split('-'); return `${d}/${m}/${y}` }

function statusLabel(s: string | null) {
  return ({ pendente: 'Pendente', em_andamento: 'Em Andamento', concluida: 'Concluída', cancelada: 'Cancelada' } as Record<string,string>)[s ?? ''] ?? s ?? '—'
}
function statusDotClass(s: string | null) {
  return ({ pendente: 'bg-pink-500', em_andamento: 'bg-blue-500', concluida: 'bg-green-500', cancelada: 'bg-red-500' } as Record<string,string>)[s ?? ''] ?? 'bg-gray-400'
}
function prioridadeLabel(p: string | null) {
  return ({ baixa: 'Baixa', media: 'Média', alta: 'Alta', urgente: 'Urgente' } as Record<string,string>)[p ?? ''] ?? p ?? '—'
}
function prioridadeBadgeClass(p: string | null) {
  return ({ baixa: 'bg-gray-100 text-gray-600', media: 'bg-sky-100 text-sky-700', alta: 'bg-orange-100 text-orange-700', urgente: 'bg-red-100 text-red-700' } as Record<string,string>)[p ?? ''] ?? 'bg-gray-100 text-gray-500'
}
function prioridadeAccent(p: string | null) {
  return ({ baixa: 'bg-gray-300', media: 'bg-sky-400', alta: 'bg-orange-400', urgente: 'bg-red-500' } as Record<string,string>)[p ?? ''] ?? 'bg-gray-200'
}
function periodicidadeLabel(p: string | null) {
  return ({ diaria: 'Diária', quinzenal: 'Quinzenal', mensal: 'Mensal' } as Record<string,string>)[p ?? ''] ?? p ?? '—'
}
function periodicidadeBadgeClass(p: string | null) {
  return ({ diaria: 'bg-violet-100 text-violet-700', quinzenal: 'bg-teal-100 text-teal-700', mensal: 'bg-rose-100 text-rose-700' } as Record<string,string>)[p ?? ''] ?? 'bg-gray-100 text-gray-500'
}

async function alterarStatus(at: AtividadeFuncionario, novoStatus: string) {
  atualizando.value = at.id
  await supabase.from('atividades_funcionarios').update({ status: novoStatus }).eq('id', at.id)
  at.status = novoStatus
  atualizando.value = null
}

// ── Kanban funcionário ────────────────────────────────────────────────────────
interface AgKanban {
  id: number; data_hora: string; status: string
  cliente_nome: string | null; nome_solicitante: string | null; cliente_telefone: string | null
  servicos_nomes: string | null; funcionario_nome: string | null
  animal_id: number | null; animal_nome: string | null; animal_foto_url: string | null; animal_especie: string | null; observacoes: string | null
}

const meuKanban        = ref<AgKanban[]>([])
const meuKanbanLoading = ref(false)

function getMondayOfWeek(date: Date): Date {
  const d = new Date(date); const day = d.getDay()
  d.setDate(d.getDate() + (day === 0 ? -6 : 1 - day)); d.setHours(0,0,0,0); return d
}

const meuKanbanSemanaInicio = ref<Date>(getMondayOfWeek(new Date()))
const diaSelecionado = ref<string>(hojeIso)

const meuKanbanDias = computed(() =>
  Array.from({ length: 7 }, (_, i) => {
    const d = new Date(meuKanbanSemanaInicio.value); d.setDate(d.getDate() + i)
    const iso = d.toISOString().split('T')[0]
    return {
      iso,
      diaSemana: d.toLocaleDateString('pt-BR', { weekday: 'short' }).replace('.', '').toUpperCase(),
      diaNum: d.toLocaleDateString('pt-BR', { day: '2-digit' }),
      ehHoje: iso === hojeIso,
    }
  })
)

const meuKanbanMesLabel = computed(() => {
  const dias = meuKanbanDias.value
  const inicio = new Date(dias[0].iso + 'T12:00:00')
  const fim    = new Date(dias[6].iso + 'T12:00:00')
  if (inicio.getMonth() === fim.getMonth())
    return inicio.toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' })
  return `${inicio.toLocaleDateString('pt-BR', { month: 'short' }).replace('.', '')} – ${fim.toLocaleDateString('pt-BR', { month: 'short', year: 'numeric' }).replace('.', '')}`
})

const meuKanbanPorDia = computed(() => {
  const map: Record<string, AgKanban[]> = {}
  meuKanbanDias.value.forEach(d => { map[d.iso] = [] })
  meuKanban.value.forEach(ag => {
    const key = ag.data_hora.slice(0, 10)
    if (map[key]) map[key].push(ag)
  })
  Object.keys(map).forEach(k => map[k].sort((a, b) => a.data_hora.localeCompare(b.data_hora)))
  return map
})

const agendamentosdia = computed(() => meuKanbanPorDia.value[diaSelecionado.value] ?? [])

watch(meuKanbanSemanaInicio, () => {
  const dias = meuKanbanDias.value.map(d => d.iso)
  diaSelecionado.value = dias.includes(hojeIso) ? hojeIso : dias[0]
})

function meuKanbanSemanaAnterior() { const d = new Date(meuKanbanSemanaInicio.value); d.setDate(d.getDate() - 7); meuKanbanSemanaInicio.value = d }
function meuKanbanSemanaProxima() { const d = new Date(meuKanbanSemanaInicio.value); d.setDate(d.getDate() + 7); meuKanbanSemanaInicio.value = d }
function meuKanbanIrParaHoje() { meuKanbanSemanaInicio.value = getMondayOfWeek(new Date()); diaSelecionado.value = hojeIso }

function agKanbanFormatHora(iso: string) {
  return new Date(iso).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit', hour12: false, timeZone: 'America/Sao_Paulo' })
}
function agKanbanStatusCor(s: string) {
  return ({ solicitado: 'bg-amber-400', agendado: 'bg-blue-400', confirmado: 'bg-green-400', concluido: 'bg-violet-500', cancelado: 'bg-red-400', faltou: 'bg-orange-400' } as Record<string,string>)[s] ?? 'bg-gray-300'
}
function agKanbanStatusBadge(s: string) {
  return ({ solicitado: 'bg-amber-100 text-amber-700', agendado: 'bg-blue-100 text-blue-700', confirmado: 'bg-green-100 text-green-700', concluido: 'bg-green-100 text-green-700', cancelado: 'bg-red-100 text-red-600', faltou: 'bg-orange-100 text-orange-600' } as Record<string,string>)[s] ?? 'bg-gray-100 text-gray-600'
}
function agKanbanStatusLabel(s: string) {
  return ({ solicitado: 'Solicitado', agendado: 'Agendado', confirmado: 'Confirmado', concluido: 'Concluído', cancelado: 'Cancelado', faltou: 'Faltou' } as Record<string,string>)[s] ?? s
}

const _especieEmojiMap: Record<string, string> = { cachorro: '🐶', gato: '🐱', passaro: '🐦', reptil: '🦎', roedor: '🐹', coelho: '🐰', peixe: '🐟' }
function especieEmoji(e: string | null | undefined) { return _especieEmojiMap[e ?? ''] ?? '🐾' }
const _especieCorMap: Record<string, string> = {
  cachorro: 'linear-gradient(135deg,#fde68a,#f59e0b)', gato: 'linear-gradient(135deg,#e9d5ff,#a855f7)',
  passaro: 'linear-gradient(135deg,#bfdbfe,#3b82f6)', reptil: 'linear-gradient(135deg,#bbf7d0,#22c55e)',
  roedor: 'linear-gradient(135deg,#fed7aa,#f97316)', coelho: 'linear-gradient(135deg,#fce7f3,#ec4899)', peixe: 'linear-gradient(135deg,#cffafe,#06b6d4)',
}
function especieCor(e: string | null | undefined) { return _especieCorMap[e ?? ''] ?? 'linear-gradient(135deg,#f3f4f6,#9ca3af)' }

const detalheKanban = ref<AgKanban | null>(null)
function abrirDetalheKanban(ag: AgKanban) { detalheKanban.value = ag }

async function fetchMeuKanban(userId: string, funcId: number, eId: number) {
  meuKanbanLoading.value = true
  const { data: rowsByUuid } = await supabase
    .from('agendamentos')
    .select('id, data_hora, status, observacoes, nome_solicitante, telefone_solicitante, funcionario_id, animal_id, clientes(nome, telefone), animais(nome, foto_url, especie)')
    .eq('empresa_id', eId).eq('funcionario_id', userId).not('status', 'in', '(cancelado,faltou)').order('data_hora', { ascending: true })

  const { data: meusSvcs } = await supabase.from('servico_funcionarios').select('servico_id').eq('funcionario_id', funcId)
  const meusSvcIds = (meusSvcs ?? []).map((s: any) => Number(s.servico_id))
  let rowsByServico: any[] = []
  if (meusSvcIds.length) {
    const { data: agLinks } = await supabase.from('agendamento_servicos').select('agendamento_id').in('servico_id', meusSvcIds)
    const agIds = [...new Set((agLinks ?? []).map((l: any) => Number(l.agendamento_id)))]
    if (agIds.length) {
      const { data: rowsSvc } = await supabase
        .from('agendamentos')
        .select('id, data_hora, status, observacoes, nome_solicitante, telefone_solicitante, funcionario_id, animal_id, clientes(nome, telefone), animais(nome, foto_url, especie)')
        .eq('empresa_id', eId).in('id', agIds).not('status', 'in', '(cancelado,faltou)').order('data_hora', { ascending: true })
      rowsByServico = rowsSvc ?? []
    }
  }
  const seenIds = new Set<number>(); const allRows: any[] = []
  for (const r of [...(rowsByUuid ?? []), ...rowsByServico]) {
    if (!seenIds.has(Number(r.id))) { seenIds.add(Number(r.id)); allRows.push(r) }
  }
  allRows.sort((a, b) => a.data_hora.localeCompare(b.data_hora))
  const ids = allRows.map((r: any) => r.id)
  let servicosMap: Record<number, string[]> = {}
  if (ids.length) {
    const { data: agSvcs } = await supabase.from('agendamento_servicos').select('agendamento_id, servicos(nome)').in('agendamento_id', ids)
    ;(agSvcs ?? []).forEach((row: any) => {
      if (!servicosMap[row.agendamento_id]) servicosMap[row.agendamento_id] = []
      if (row.servicos?.nome) servicosMap[row.agendamento_id].push(row.servicos.nome)
    })
  }
  const funcUuids = [...new Set(allRows.map((r: any) => r.funcionario_id).filter(Boolean))] as string[]
  const funcNomeByUuid: Record<string, string> = {}
  if (funcUuids.length) {
    const { data: profs } = await supabase.from('profiles').select('id, email').in('id', funcUuids)
    const emailToUuid: Record<string, string> = {}
    ;(profs ?? []).forEach((p: any) => { if (p.email) emailToUuid[p.email.toLowerCase()] = p.id })
    const { data: funcs } = await supabase.from('funcionarios').select('nome, email').eq('empresa_id', eId)
    ;(funcs ?? []).forEach((f: any) => { if (f.email) { const uuid = emailToUuid[f.email.toLowerCase()]; if (uuid) funcNomeByUuid[uuid] = f.nome } })
  }
  meuKanban.value = allRows.map((r: any) => ({
    id: r.id, data_hora: r.data_hora, status: r.status,
    observacoes: r.observacoes ?? null,
    cliente_nome: r.clientes?.nome ?? null,
    nome_solicitante: r.nome_solicitante ?? null,
    cliente_telefone: r.clientes?.telefone ?? r.telefone_solicitante ?? null,
    servicos_nomes: servicosMap[r.id]?.join(', ') ?? null,
    funcionario_nome: funcNomeByUuid[r.funcionario_id] ?? null,
    animal_nome: r.animais?.nome ?? null,
    animal_foto_url: r.animais?.foto_url ?? null,
    animal_especie: r.animais?.especie ?? null,
    animal_id: r.animal_id ?? null,
  }))
  meuKanbanLoading.value = false
}

// ── onMounted ─────────────────────────────────────────────────────────────────
onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  const email = session?.user?.email
  await loadEmpresa()
  if (userPerfil.value === 'funcionario') {
    const { data: func } = await supabase
      .from('funcionarios').select('id, nome, cargo')
      .eq('empresa_id', empresaId.value!).ilike('email', email ?? '').maybeSingle()
    if (func) {
      funcionarioLogado.value = func as FuncionarioLite
      const { data: ativs } = await supabase
        .from('atividades_funcionarios')
        .select('id, titulo, descricao, status, prioridade, periodicidade, data_atividade, hora_inicio, hora_fim, observacao')
        .eq('funcionario_id', func.id).eq('empresa_id', empresaId.value!).order('data_atividade', { ascending: true })
      minhasAtividades.value = (ativs ?? []) as AtividadeFuncionario[]
      if (session?.user?.id) await fetchMeuKanban(session.user.id, func.id, empresaId.value!)
    }
    loadingAtividades.value = false
    resumoLoading.value = false
    return
  }
  loadingAtividades.value = false
  await Promise.all([aplicarFiltros(), fetchAgendamentosHoje()])
})

function formatCurrency(val: number): string {
  return val.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
}

const atalhos = [
  { to: '/agendamentos',  icon: 'calendar',       title: 'Agendamentos',  minPerfil: 'all' },
  { to: '/servicos',      icon: 'sparkles',       title: 'Serviços',      minPerfil: 'all' },
  { to: '/clientes',      icon: 'identification', title: 'Clientes',      minPerfil: 'all' },
  { to: '/estoque',       icon: 'package',        title: 'Estoque',       minPerfil: 'all' },
  { to: '/funcionarios',  icon: 'users',          title: 'Funcionários',  minPerfil: 'manager' },
  { to: '/atividades',    icon: 'clipboard',      title: 'Atividades',    minPerfil: 'all' },
  { to: '/financeiro',    icon: 'chart-bar',      title: 'Financeiro',    minPerfil: 'manager' },
  { to: '/contas-pagar',  icon: 'wallet',         title: 'Contas a Pagar', minPerfil: 'manager' },
  { to: '/configuracoes', icon: 'settings',       title: 'Configurações', minPerfil: 'manager' },
] as const

const atalhosVisiveis = computed(() =>
  atalhos.filter(item => item.minPerfil === 'all' || isAdminOrGerente.value)
)
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.18s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.slide-down-enter-active { transition: all 0.25s ease-out; }
.slide-down-leave-active { transition: all 0.2s ease-in; }
.slide-down-enter-from, .slide-down-leave-to { opacity: 0; transform: translateY(-8px); }
.scrollbar-none::-webkit-scrollbar { display: none; }
.scrollbar-none { scrollbar-width: none; }
</style>
