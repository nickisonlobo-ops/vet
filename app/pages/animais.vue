<template>
  <div class="min-h-full bg-transparent p-3 sm:p-8">

    <!-- TOAST: link copiado -->
    <Transition name="toast">
      <div
        v-if="copiedId !== null"
        class="fixed top-5 left-1/2 -translate-x-1/2 z-[200] flex items-center gap-2 bg-gray-900 text-white text-sm font-semibold px-5 py-3 rounded-2xl shadow-2xl pointer-events-none"
      >
        <svg class="w-4 h-4 text-green-400 shrink-0" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13.19 8.688a4.5 4.5 0 011.242 7.244l-4.5 4.5a4.5 4.5 0 01-6.364-6.364l1.757-1.757m13.35-.622l1.757-1.757a4.5 4.5 0 00-6.364-6.364l-4.5 4.5a4.5 4.5 0 001.242 7.244"/></svg>
        Link do prontuário copiado!
      </div>
    </Transition>

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
              <AppNavIcon name="paw" class="w-5 sm:w-7 h-5 sm:h-7 text-white" />
            </div>
            <div>
              <div class="flex items-center gap-2 mb-1">
                <span class="text-xs font-semibold text-white/80 uppercase tracking-widest">Pacientes</span>
              </div>
              <h1 class="text-xl sm:text-3xl font-bold text-white tracking-tight leading-none">Animais</h1>
              <p class="text-sm text-white/80 mt-1.5">
                {{ loading ? 'Carregando...' : `${animaisFiltrados.length} de ${animais.length} animal(is) exibido(s)` }}
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

            <!-- Vista toggle -->
            <div class="hidden sm:flex items-center gap-0.5 bg-white/10 rounded-xl p-1 border border-white/15">
              <button
                type="button"
                class="w-8 h-8 flex items-center justify-center rounded-lg transition-all"
                :class="vistaCards ? 'bg-white text-[#ff46a2] shadow-sm' : 'text-white/70 hover:text-white'"
                title="Vista em cards"
                @click="vistaCards = true"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
              </button>
              <button
                type="button"
                class="w-8 h-8 flex items-center justify-center rounded-lg transition-all"
                :class="!vistaCards ? 'bg-white text-[#ff46a2] shadow-sm' : 'text-white/70 hover:text-white'"
                title="Vista em lista"
                @click="vistaCards = false"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"/></svg>
              </button>
            </div>

            <button
              v-if="isAdminOrGerente"
              type="button"
              class="inline-flex items-center gap-2 text-sm font-bold px-3 sm:px-5 py-2.5 rounded-xl bg-white text-[#ff46a2] hover:bg-pink-50 shadow-lg shadow-pink-200/40 transition-all duration-200 hover:scale-[1.02]"
              @click="abrirAdicionar"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
              <span class="hidden sm:inline">Adicionar Animal</span>
            </button>
          </div>
        </div>

        <div class="h-px bg-white/10 my-4 sm:my-6" />

        <!-- Stats -->
        <div v-if="!loading" class="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <div class="flex flex-col gap-1 bg-white/10 backdrop-blur-sm rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/15 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Total</span>
            <span class="text-xl font-black text-white leading-tight">{{ animais.length }}</span>
            <span class="text-xs text-white/50">paciente(s)</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/10 rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/15 transition-colors">
            <div class="flex items-center gap-1.5">
              <span class="text-xs">🐶</span>
              <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Cachorros</span>
            </div>
            <span class="text-xl font-black text-white leading-tight">{{ countEspecie('cachorro') }}</span>
            <span class="text-xs text-white/50">cães</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/[0.07] rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/12 transition-colors">
            <div class="flex items-center gap-1.5">
              <span class="text-xs">🐱</span>
              <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Gatos</span>
            </div>
            <span class="text-xl font-black text-white leading-tight">{{ countEspecie('gato') }}</span>
            <span class="text-xs text-white/50">felinos</span>
          </div>
          <div class="flex flex-col gap-1 bg-white/[0.07] rounded-2xl px-5 py-4 border border-white/10 hover:bg-white/12 transition-colors">
            <span class="text-xs font-semibold text-white/70 uppercase tracking-widest">Outros</span>
            <span class="text-xl font-black text-white leading-tight">{{ countOutros }}</span>
            <span class="text-xs text-white/50">animais</span>
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
          <button v-if="filtrosAtivos > 0" type="button" class="text-xs font-semibold text-[#ff46a2] hover:text-pink-600 hover:underline" @click="limparFiltros">
            Limpar todos
          </button>
        </div>
        <div class="p-7 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          <div class="sm:col-span-2 flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Busca</label>
            <div class="relative">
              <svg class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path stroke-linecap="round" d="m21 21-4.35-4.35"/></svg>
              <input v-model="filtros.busca" type="text" placeholder="Nome do animal ou tutor..." class="w-full rounded-xl border border-gray-200 pl-10 pr-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-[var(--color-primary,#6b7280)] transition-shadow" />
            </div>
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Espécie</label>
            <select v-model="filtros.especie" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
              <option value="">Todas</option>
              <option v-for="e in especiesDisponiveis" :key="e.value" :value="e.value">{{ e.label }}</option>
            </select>
          </div>
          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Tutor</label>
            <select v-model="filtros.tutorId" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
              <option value="">Todos</option>
              <option v-for="t in tutoresUnicos" :key="t.id" :value="t.id">{{ t.nome }}</option>
            </select>
          </div>
        </div>
      </div>
    </Transition>

    <!-- LOADING -->
    <div v-if="loading" class="flex flex-col items-center justify-center gap-4 py-32">
      <span class="inline-block w-12 h-12 border-4 border-violet-600 border-t-transparent rounded-full animate-spin" />
      <span class="text-sm text-gray-400 font-medium">Carregando animais...</span>
    </div>

    <!-- ERRO -->
    <div v-else-if="error" class="flex items-center gap-3 text-sm text-red-700 bg-red-50 border border-red-200 rounded-2xl px-6 py-4">
      <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path stroke-linecap="round" d="M12 8v4m0 4h.01"/></svg>
      {{ error }}
    </div>

    <!-- CARDS -->
    <div v-else-if="vistaCards">
      <div v-if="animaisFiltrados.length === 0" class="flex flex-col items-center justify-center gap-3 py-24 bg-white rounded-3xl border border-gray-100 shadow-md">
        <span class="text-5xl">🐾</span>
        <span class="text-base font-semibold text-gray-400">Nenhum animal encontrado</span>
        <span v-if="filtrosAtivos > 0" class="text-sm text-gray-400">Tente ajustar os filtros</span>
        <button v-else-if="isAdminOrGerente" type="button" class="mt-2 text-sm font-semibold text-[#ff46a2] hover:underline" @click="abrirAdicionar">
          Adicionar primeiro animal
        </button>
      </div>
      <div v-else class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
        <div
          v-for="animal in animaisFiltrados"
          :key="animal.id"
          class="bg-white rounded-3xl overflow-hidden shadow-sm border border-gray-100 hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200 group flex flex-col"
        >
          <!-- Foto -->
          <div class="relative w-full aspect-square overflow-hidden" :style="{ background: especieCorFundo(animal.especie) }">
            <img
              v-if="animal.foto_url"
              :src="animal.foto_url"
              :alt="animal.nome"
              class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <span class="text-6xl">{{ especieEmoji(animal.especie) }}</span>
            </div>
            <!-- Castrado badge -->
            <span v-if="animal.castrado" class="absolute top-2 left-2 text-[10px] font-bold bg-green-500 text-white px-2 py-0.5 rounded-full shadow">
              ✂️ Castrado
            </span>
            <!-- Sexo badge -->
            <span
              v-if="animal.sexo"
              class="absolute top-2 right-2 text-[10px] font-bold px-2 py-0.5 rounded-full shadow"
              :class="animal.sexo === 'macho' ? 'bg-blue-500 text-white' : 'bg-pink-500 text-white'"
            >
              {{ animal.sexo === 'macho' ? '♂ Macho' : '♀ Fêmea' }}
            </span>
            <!-- Overlay: botão de editar -->
            <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors duration-200" />
          </div>
          <!-- Info -->
          <div class="px-4 py-3 flex flex-col gap-1 flex-1">
            <div class="flex items-start justify-between gap-2">
              <p class="font-bold text-gray-800 text-sm truncate leading-tight">{{ animal.nome }}</p>
              <span class="shrink-0 text-[11px] font-bold px-2 py-0.5 rounded-full" :class="especieBadgeClass(animal.especie)">
                {{ especieLabel(animal.especie) }}
              </span>
            </div>
            <p v-if="animal.raca" class="text-xs text-gray-400 truncate">{{ animal.raca }}</p>
            <p v-if="animal.tutor_nome" class="text-xs text-gray-500 truncate mt-0.5">
              <span class="opacity-60">👤</span> {{ animal.tutor_nome }}
            </p>
            <div v-if="animal.peso" class="mt-1">
              <span class="text-[11px] font-semibold text-violet-600 bg-violet-50 px-2 py-0.5 rounded-lg">{{ animal.peso }} kg</span>
            </div>
          </div>
          <!-- Actions -->
          <div class="flex items-center gap-0 px-3 pb-3 pt-0 border-t border-gray-50 mt-auto">
            <button
              type="button"
              class="flex-1 flex items-center justify-center gap-1 py-2 rounded-xl text-xs font-semibold text-[#ff46a2] hover:bg-pink-50 transition-colors"
              @click="editAnimal(animal)"
            >
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z"/></svg>
              Editar
            </button>
            <div class="w-px h-5 bg-gray-100 shrink-0" />
            <button
              type="button"
              class="flex-1 flex items-center justify-center gap-1 py-2 rounded-xl text-xs font-semibold text-sky-500 hover:bg-sky-50 transition-colors"
              title="Compartilhar prontuário"
              @click="abrirProntuario(animal)"
            >
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M7.217 10.907a2.25 2.25 0 100 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186l9.566-5.314m-9.566 7.5l9.566 5.314m0 0a2.25 2.25 0 103.935 2.186 2.25 2.25 0 00-3.935-2.186zm0-12.814a2.25 2.25 0 103.933-2.185 2.25 2.25 0 00-3.933 2.185z"/></svg>
              Prontuário
            </button>
            <template v-if="isAdminOrGerente">
              <div class="w-px h-5 bg-gray-100 shrink-0" />
              <button
                type="button"
                class="flex-1 flex items-center justify-center gap-1 py-2 rounded-xl text-xs font-semibold text-red-400 hover:bg-red-50 transition-colors"
                @click="confirmarExclusao(animal)"
              >
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M9 7h6m-7 0a1 1 0 01-1-1V5a1 1 0 011-1h8a1 1 0 011 1v1a1 1 0 01-1 1H9z"/></svg>
                Excluir
              </button>
            </template>
          </div>
        </div>
      </div>
    </div>

    <!-- TABELA -->
    <div v-else class="bg-white rounded-3xl shadow-md border border-gray-100 overflow-hidden">
      <div class="flex items-center justify-between px-7 py-4 border-b border-gray-100 bg-gray-50/50">
        <span class="text-sm font-semibold text-gray-600">
          <span class="text-[#ff46a2] font-black">{{ animaisFiltrados.length }}</span>
          resultado(s)
          <span v-if="filtrosAtivos > 0" class="text-gray-400 font-normal"> · filtros aplicados</span>
        </span>
        <span class="text-xs text-gray-400">Ordenado por nome</span>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full text-sm whitespace-nowrap">
          <thead>
            <tr class="bg-gray-50 border-b border-gray-100">
              <th class="text-left px-7 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">#</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Animal</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Espécie / Raça</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Tutor</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Peso</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Nascimento</th>
              <th class="text-left px-5 py-4 text-xs font-extrabold text-gray-400 uppercase tracking-widest">Sexo</th>
              <th class="px-7 py-4 text-right text-xs font-extrabold text-gray-400 uppercase tracking-widest sm:sticky sm:right-0 bg-gray-50">Ações</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
            <tr v-if="animaisFiltrados.length === 0">
              <td colspan="8" class="text-center py-20">
                <div class="flex flex-col items-center gap-3">
                  <span class="text-5xl">🐾</span>
                  <span class="text-base font-semibold text-gray-400">Nenhum animal encontrado</span>
                  <span v-if="filtrosAtivos > 0" class="text-sm text-gray-400">Tente ajustar os filtros</span>
                </div>
              </td>
            </tr>
            <tr
              v-for="animal in animaisFiltrados"
              :key="animal.id"
              class="hover:bg-pink-50/40 transition-colors duration-150 group"
            >
              <td class="px-7 py-4">
                <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-violet-100 text-[#ff46a2] font-black text-xs">
                  {{ animal.id }}
                </span>
              </td>
              <td class="px-5 py-4">
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-full flex items-center justify-center text-xl shrink-0 shadow-sm"
                    :style="{ background: especieCorFundo(animal.especie) }">
                    {{ especieEmoji(animal.especie) }}
                  </div>
                  <div>
                    <span class="font-semibold text-gray-800 block">{{ animal.nome }}</span>
                    <span v-if="animal.cor" class="text-xs text-gray-400">{{ animal.cor }}</span>
                  </div>
                </div>
              </td>
              <td class="px-5 py-4">
                <div>
                  <span class="inline-flex items-center gap-1.5 text-xs font-bold px-2.5 py-1 rounded-full" :class="especieBadgeClass(animal.especie)">
                    {{ especieLabel(animal.especie) }}
                  </span>
                  <span v-if="animal.raca" class="block text-xs text-gray-400 mt-1">{{ animal.raca }}</span>
                </div>
              </td>
              <td class="px-5 py-4">
                <span v-if="animal.tutor_nome" class="font-medium text-gray-700">{{ animal.tutor_nome }}</span>
                <span v-else class="text-gray-300">—</span>
              </td>
              <td class="px-5 py-4 text-gray-600 font-medium">
                {{ animal.peso ? `${animal.peso} kg` : '—' }}
              </td>
              <td class="px-5 py-4 text-gray-500">
                {{ animal.data_nascimento ? formatDate(animal.data_nascimento) : '—' }}
              </td>
              <td class="px-5 py-4">
                <span v-if="animal.sexo" class="inline-flex items-center gap-1 text-xs font-bold px-2.5 py-1 rounded-full"
                  :class="animal.sexo === 'macho' ? 'bg-blue-100 text-blue-700' : 'bg-pink-100 text-pink-700'">
                  {{ animal.sexo === 'macho' ? '♂ Macho' : '♀ Fêmea' }}
                </span>
                <span v-else class="text-gray-300">—</span>
              </td>
              <td class="px-7 py-4 text-right sm:sticky sm:right-0 group-hover:bg-pink-50/40 transition-colors">
                <div class="flex items-center justify-end gap-1">
                  <button
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-sky-500 hover:bg-sky-50 transition-colors"
                    title="Compartilhar prontuário público"
                    @click="abrirProntuario(animal)"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M7.217 10.907a2.25 2.25 0 100 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186l9.566-5.314m-9.566 7.5l9.566 5.314m0 0a2.25 2.25 0 103.935 2.186 2.25 2.25 0 00-3.935-2.186zm0-12.814a2.25 2.25 0 103.933-2.185 2.25 2.25 0 00-3.933 2.185z"/></svg>
                  </button>
                  <button
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-[#ff46a2] hover:bg-pink-100 transition-colors"
                    title="Editar"
                    @click="editAnimal(animal)"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z"/></svg>
                  </button>
                  <button
                    v-if="isAdminOrGerente"
                    type="button"
                    class="w-8 h-8 flex items-center justify-center rounded-full bg-white shadow-sm text-red-400 hover:bg-red-50 transition-colors"
                    title="Excluir"
                    @click="confirmarExclusao(animal)"
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

    <!-- MODAL ADICIONAR / EDITAR -->
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
                  🐾
                </div>
                <h2 class="text-lg font-bold text-white">{{ adicionando ? 'Adicionar Animal' : 'Editar Animal' }}</h2>
              </div>
              <button type="button" class="w-8 h-8 flex items-center justify-center rounded-xl text-white/60 hover:text-white hover:bg-white/10 transition-colors" @click="fecharModal">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
              </button>
            </div>

            <form class="flex flex-col gap-5 px-8 py-7 overflow-y-auto max-h-[70vh]" @submit.prevent="adicionando ? salvarAdicao() : salvarEdicao()">
              <!-- Foto do animal -->
              <div class="flex flex-col items-center gap-2">
                <div
                  class="relative w-28 h-28 rounded-2xl overflow-hidden cursor-pointer border-2 border-dashed border-gray-200 hover:border-[#ff46a2] transition-colors group/foto"
                  @click="fotoInputRef?.click()"
                >
                  <img v-if="fotoPreview" :src="fotoPreview" :alt="form.nome" class="w-full h-full object-cover" />
                  <img v-else-if="form.foto_url" :src="form.foto_url" :alt="form.nome" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full flex flex-col items-center justify-center gap-1.5 bg-gray-50">
                    <svg class="w-8 h-8 text-gray-300" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6.827 6.175A2.31 2.31 0 015.186 7.23c-.38.054-.757.112-1.134.175C2.999 7.58 2.25 8.507 2.25 9.574V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9.574c0-1.067-.75-1.994-1.802-2.169a47.865 47.865 0 00-1.134-.175 2.31 2.31 0 01-1.64-1.055l-.822-1.316a2.192 2.192 0 00-1.736-1.039 48.774 48.774 0 00-5.232 0 2.192 2.192 0 00-1.736 1.039l-.821 1.316z" />
                      <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 12.75a4.5 4.5 0 11-9 0 4.5 4.5 0 019 0zM18.75 10.5h.008v.008h-.008V10.5z" />
                    </svg>
                    <span class="text-xs text-gray-400 font-medium text-center leading-tight">Clique para<br/>adicionar foto</span>
                  </div>
                  <div class="absolute inset-0 bg-black/30 opacity-0 group-hover/foto:opacity-100 transition-opacity flex items-center justify-center pointer-events-none">
                    <span class="text-white text-xs font-bold">Alterar</span>
                  </div>
                </div>
                <input ref="fotoInputRef" type="file" accept="image/jpeg,image/png,image/webp" class="hidden" @change="onFotoChange" />
                <button
                  v-if="fotoPreview || form.foto_url"
                  type="button"
                  class="text-xs text-red-400 hover:text-red-600 transition-colors hover:underline"
                  @click="removerFoto"
                >
                  Remover foto
                </button>
              </div>

              <!-- Nome + Espécie -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <AppInput v-model="form.nome" label="Nome do Animal *" placeholder="Ex: Rex" :error="formErrors.nome" required />
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Espécie *</label>
                  <select v-model="form.especie" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option value="">Selecione</option>
                    <option v-for="e in especiesDisponiveis" :key="e.value" :value="e.value">{{ e.label }}</option>
                  </select>
                  <p v-if="formErrors.especie" class="text-xs text-red-500">{{ formErrors.especie }}</p>
                </div>
              </div>

              <!-- Raça + Cor -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <AppInput v-model="form.raca" label="Raça" placeholder="Ex: Golden Retriever" />
                <AppInput v-model="form.cor" label="Cor / Pelagem" placeholder="Ex: Dourado, Preto e branco" />
              </div>

              <!-- Peso + Data nascimento -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <AppInput v-model="form.peso" label="Peso (kg)" type="number" placeholder="Ex: 8.5" />
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Data de Nascimento</label>
                  <input
                    v-model="form.data_nascimento"
                    type="date"
                    class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500"
                  />
                </div>
              </div>

              <!-- Sexo + Tutor -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Sexo</label>
                  <select v-model="form.sexo" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option value="">Não informado</option>
                    <option value="macho">♂ Macho</option>
                    <option value="femea">♀ Fêmea</option>
                  </select>
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-sm font-semibold text-gray-700">Tutor (Dono) *</label>
                  <select v-model="form.cliente_id" class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-violet-500">
                    <option :value="null">Selecione o tutor</option>
                    <option v-for="t in tutores" :key="t.id" :value="t.id">{{ t.nome }}</option>
                  </select>
                  <p v-if="formErrors.cliente_id" class="text-xs text-red-500">{{ formErrors.cliente_id }}</p>
                </div>
              </div>

              <!-- Castrado -->
              <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-3 border border-gray-100">
                <button
                  type="button"
                  class="relative w-11 h-6 rounded-full transition-colors duration-200"
                  :class="form.castrado ? 'bg-green-500' : 'bg-gray-300'"
                  @click="form.castrado = !form.castrado"
                >
                  <span class="absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform duration-200" :class="form.castrado ? 'translate-x-5' : 'translate-x-0'" />
                </button>
                <div>
                  <p class="text-sm font-semibold text-gray-700">Castrado(a)</p>
                  <p class="text-xs text-gray-400">{{ form.castrado ? 'Animal castrado' : 'Não castrado' }}</p>
                </div>
              </div>

              <!-- Observações -->
              <div class="flex flex-col gap-1.5">
                <label class="text-sm font-semibold text-gray-700">Observações / Histórico</label>
                <textarea
                  v-model="form.observacoes"
                  rows="3"
                  placeholder="Alergias, condições especiais, histórico de saúde..."
                  class="w-full rounded-xl border border-gray-200 px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-[var(--color-primary,#6b7280)] resize-none"
                />
              </div>

              <p v-if="modalError" class="text-sm text-red-600 bg-red-50 border border-red-200 rounded-xl px-4 py-3">{{ modalError }}</p>

              <div class="flex gap-3 pt-1">
                <button type="button" class="flex-1 py-3 rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 transition-colors text-sm font-semibold" @click="fecharModal">
                  Cancelar
                </button>
                <AppButton variant="primary" size="md" type="submit" :loading="saving" class="flex-1">
                  {{ adicionando ? 'Adicionar' : 'Salvar alterações' }}
                </AppButton>
              </div>
            </form>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- MODAL PRONTUÁRIO -->
    <Teleport to="body">
      <Transition name="fade">
        <div
          v-if="prontuarioAnimal"
          class="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-black/40 backdrop-blur-md px-4 pb-4 sm:pb-0"
          @click.self="prontuarioAnimal = null"
        >
          <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col overflow-hidden">

            <!-- Header -->
            <div class="relative px-6 pt-6 pb-4 border-b border-gray-100 shrink-0">
              <div class="h-1 absolute top-0 left-0 right-0 rounded-t-3xl" :style="{ background: 'var(--color-primary-bg, linear-gradient(90deg,#0d9488,#0891b2))' }" />
              <div class="flex items-start gap-4 mt-1">
                <!-- Avatar -->
                <div class="w-12 h-12 rounded-2xl overflow-hidden border border-gray-100 shrink-0 flex items-center justify-center text-2xl bg-gray-50">
                  <img v-if="prontuarioAnimal.foto_url" :src="prontuarioAnimal.foto_url" :alt="prontuarioAnimal.nome" class="w-full h-full object-cover" />
                  <span v-else>{{ pronEspecieEmoji(prontuarioAnimal.especie) }}</span>
                </div>
                <div class="flex-1 min-w-0">
                  <h3 class="text-lg font-black text-gray-900 leading-tight">{{ prontuarioAnimal.nome }}</h3>
                  <p class="text-xs text-gray-400 mt-0.5">
                    {{ pronEspecieLabel(prontuarioAnimal.especie) }}
                    <span v-if="prontuarioAnimal.raca"> · {{ prontuarioAnimal.raca }}</span>
                    <span v-if="prontuarioAnimal.tutor_nome"> · Tutor: {{ prontuarioAnimal.tutor_nome }}</span>
                  </p>
                </div>
                <!-- Actions -->
                <div class="flex items-center gap-2 shrink-0">
                  <button
                    type="button"
                    @click="enviarProntuarioWhatsApp"
                    class="text-xs font-semibold text-green-600 hover:text-green-700 flex items-center gap-1 px-3 py-1.5 rounded-xl border border-green-200 hover:bg-green-50 transition-colors"
                    :title="tutorTelefone() ? `Enviar para ${tutorTelefone()}` : 'Número não cadastrado — abre WhatsApp'"
                  >
                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z"/><path d="M12 0C5.373 0 0 5.373 0 12c0 2.123.554 4.11 1.524 5.832L.054 23.486a.5.5 0 00.613.613l5.654-1.47A11.946 11.946 0 0012 24c6.627 0 12-5.373 12-12S18.627 0 12 0zm0 22c-1.944 0-3.77-.497-5.354-1.37l-.383-.215-3.978 1.033 1.056-3.858-.236-.397A9.96 9.96 0 012 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10z"/></svg>
                    Enviar prontuário
                  </button>
                  <a
                    :href="`/animal/${prontuarioAnimal.id}`"
                    target="_blank"
                    class="text-xs font-semibold text-sky-500 hover:text-sky-600 flex items-center gap-1 px-3 py-1.5 rounded-xl border border-sky-100 hover:bg-sky-50 transition-colors"
                  >
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"/></svg>
                    Ver completo
                  </a>
                  <button type="button" @click="prontuarioAnimal = null" class="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 transition-colors text-gray-400">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                  </button>
                </div>
              </div>
              <!-- Stats -->
              <div class="flex gap-3 mt-4">
                <div class="flex-1 bg-gray-50 rounded-xl px-3 py-2 text-center">
                  <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Atendimentos</p>
                  <p class="text-xl font-black text-gray-800">{{ prontuariosLoading ? '…' : prontuariosList.length }}</p>
                </div>
                <div v-if="prontuarioAnimal.peso" class="flex-1 bg-gray-50 rounded-xl px-3 py-2 text-center">
                  <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Peso</p>
                  <p class="text-xl font-black text-gray-800">{{ prontuarioAnimal.peso }} kg</p>
                </div>
                <div v-if="tutorTelefone()" class="flex-1 bg-green-50 rounded-xl px-3 py-2 text-center">
                  <p class="text-[10px] font-bold text-green-400 uppercase tracking-widest">Tutor WhatsApp</p>
                  <p class="text-xs font-semibold text-green-700 mt-0.5">{{ tutorTelefone() }}</p>
                </div>
                <div v-else class="flex-1 bg-teal-50 rounded-xl px-3 py-2 text-center">
                  <p class="text-[10px] font-bold text-teal-400 uppercase tracking-widest">Link copiado</p>
                  <p class="text-xs font-semibold text-teal-600 mt-0.5">✓ área de transferência</p>
                </div>
              </div>
            </div>

            <!-- Body -->
            <div class="overflow-y-auto flex-1 px-6 py-4">

              <!-- ── Botão + Formulário Novo Atendimento ── -->
              <div class="mb-4">
                <button
                  type="button"
                  class="w-full flex items-center justify-center gap-2 py-2.5 rounded-2xl border-2 border-dashed text-sm font-semibold transition-colors"
                  :class="novoAtendimentoAberto ? 'border-teal-300 text-teal-600 bg-teal-50' : 'border-gray-200 text-gray-400 hover:border-teal-200 hover:text-teal-500 hover:bg-teal-50/50'"
                  @click="novoAtendimentoAberto = !novoAtendimentoAberto; if(novoAtendimentoAberto) carregarFuncionariosVet()"
                >
                  <svg class="w-4 h-4 transition-transform" :class="novoAtendimentoAberto ? 'rotate-45' : ''" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15"/></svg>
                  {{ novoAtendimentoAberto ? 'Cancelar novo atendimento' : 'Registrar novo atendimento' }}
                </button>

                <Transition name="slide-fade">
                  <form v-if="novoAtendimentoAberto" class="mt-3 bg-gray-50 rounded-2xl border border-gray-100 p-4 space-y-3" @submit.prevent="salvarNovoAtendimento">
                    <!-- Tipo + Data -->
                    <div class="grid grid-cols-2 gap-3">
                      <div class="flex flex-col gap-1">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Tipo</label>
                        <select v-model="novoAtend.tipo" class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400">
                          <option value="consulta">🩺 Consulta</option>
                          <option value="retorno">🔄 Retorno</option>
                          <option value="vacina">💉 Vacina</option>
                          <option value="cirurgia">🔬 Cirurgia</option>
                          <option value="exame">📋 Exame</option>
                          <option value="emergencia">🚨 Emergência</option>
                          <option value="outros">🐾 Outros</option>
                        </select>
                      </div>
                      <div class="flex flex-col gap-1">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Data</label>
                        <input v-model="novoAtend.data_consulta" type="date" class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400" />
                      </div>
                    </div>

                    <!-- Profissional -->
                    <div class="flex flex-col gap-1">
                      <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Profissional (Veterinário)</label>
                      <select v-model="novoAtend.funcionario_id" class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400">
                        <option :value="null">Não informado</option>
                        <option v-for="f in funcionariosVet" :key="f.id" :value="f.id">{{ f.nome }}{{ f.cargo ? ` — ${f.cargo}` : '' }}</option>
                      </select>
                    </div>

                    <!-- Peso + Temperatura -->
                    <div class="grid grid-cols-2 gap-3">
                      <div class="flex flex-col gap-1">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Peso (kg)</label>
                        <input v-model="novoAtend.peso_aferido" type="number" step="0.1" placeholder="Ex: 8.5" class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400" />
                      </div>
                      <div class="flex flex-col gap-1">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Temperatura (°C)</label>
                        <input v-model="novoAtend.temperatura" type="number" step="0.1" placeholder="Ex: 38.5" class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400" />
                      </div>
                    </div>

                    <!-- Anamnese -->
                    <div class="flex flex-col gap-1">
                      <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Queixa / Anamnese</label>
                      <textarea v-model="novoAtend.anamnese" rows="2" placeholder="Sintomas, motivo da consulta..." class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400 resize-none" />
                    </div>

                    <!-- Diagnóstico -->
                    <div class="flex flex-col gap-1">
                      <label class="text-xs font-bold text-violet-400 uppercase tracking-widest">Diagnóstico</label>
                      <textarea v-model="novoAtend.diagnostico" rows="2" placeholder="Diagnóstico clínico..." class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-violet-50/50 focus:outline-none focus:ring-2 focus:ring-violet-400 resize-none" />
                    </div>

                    <!-- Prescrição -->
                    <div class="flex flex-col gap-1">
                      <label class="text-xs font-bold text-green-600 uppercase tracking-widest">Prescrição / Tratamento</label>
                      <textarea v-model="novoAtend.prescricao" rows="2" placeholder="Medicamentos, dosagem, duração..." class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-green-50/50 focus:outline-none focus:ring-2 focus:ring-green-400 resize-none" />
                    </div>

                    <!-- Observações -->
                    <div class="flex flex-col gap-1">
                      <label class="text-xs font-bold text-gray-500 uppercase tracking-widest">Observações</label>
                      <textarea v-model="novoAtend.observacoes" rows="1" placeholder="Outras informações..." class="w-full rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-teal-400 resize-none" />
                    </div>

                    <!-- Próxima consulta -->
                    <div class="rounded-xl border border-amber-200 bg-amber-50/50 p-3 space-y-2">
                      <p class="text-xs font-bold text-amber-600 uppercase tracking-widest">Próxima consulta (retorno)</p>
                      <div class="grid grid-cols-2 gap-2">
                        <div class="flex flex-col gap-1">
                          <label class="text-xs text-amber-700 font-medium">Data</label>
                          <input v-model="novoAtend.proxima_consulta" type="date" class="w-full rounded-xl border border-amber-200 bg-white px-3 py-1.5 text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-amber-400" />
                        </div>
                        <div class="flex flex-col gap-1">
                          <label class="text-xs text-amber-700 font-medium">Horário</label>
                          <input v-model="novoAtend.proxima_consulta_hora" type="time" class="w-full rounded-xl border border-amber-200 bg-white px-3 py-1.5 text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-amber-400" />
                        </div>
                      </div>
                    </div>

                    <p v-if="novoAtendimentoError" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded-xl px-3 py-2">{{ novoAtendimentoError }}</p>

                    <button
                      type="submit"
                      :disabled="novoAtendimentoSaving"
                      class="w-full py-2.5 rounded-xl text-white text-sm font-bold transition-opacity disabled:opacity-60 flex items-center justify-center gap-2"
                      :style="{ background: 'var(--color-primary-bg, linear-gradient(135deg,#0d9488,#0891b2))' }"
                    >
                      <span v-if="novoAtendimentoSaving" class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      {{ novoAtendimentoSaving ? 'Salvando...' : 'Salvar atendimento' }}
                    </button>
                  </form>
                </Transition>
              </div>

              <!-- Loading -->
              <div v-if="prontuariosLoading" class="flex items-center justify-center py-12">
                <span class="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" :style="{ borderColor: 'var(--color-primary, #0d9488)', borderTopColor: 'transparent' }" />
              </div>
              <!-- Empty -->
              <div v-else-if="prontuariosList.length === 0" class="flex flex-col items-center gap-2 py-12">
                <span class="text-3xl">🩺</span>
                <p class="text-sm text-gray-400 font-semibold">Nenhum prontuário registrado</p>
              </div>
              <!-- Lista -->
              <div v-else class="space-y-3">
                <div v-for="p in prontuariosList" :key="p.id" class="bg-gray-50 rounded-2xl border border-gray-100 p-4">
                  <!-- Topo -->
                  <div class="flex items-center justify-between gap-2 flex-wrap mb-3">
                    <div class="flex items-center gap-2">
                      <span class="text-xs font-bold px-2.5 py-1 rounded-full" :class="pronTipoBadge(p.tipo)">
                        {{ pronTipoEmoji(p.tipo) }} {{ pronTipoLabel(p.tipo) }}
                      </span>
                      <span class="text-xs text-gray-500 font-semibold">{{ pronFormatDate(p.data_consulta) }}</span>
                    </div>
                    <div v-if="p.funcionario_nome" class="text-xs text-gray-400 flex items-center gap-1">
                      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0"/></svg>
                      {{ p.funcionario_nome }}
                    </div>
                  </div>
                  <!-- Campos -->
                  <div class="space-y-2 text-sm">
                    <div v-if="p.anamnese" class="flex flex-col gap-0.5">
                      <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Queixa / Anamnese</span>
                      <p class="text-gray-700 leading-relaxed">{{ p.anamnese }}</p>
                    </div>
                    <div v-if="p.diagnostico" class="bg-violet-50 rounded-xl px-3 py-2">
                      <span class="text-[10px] font-bold text-violet-400 uppercase tracking-widest block mb-0.5">Diagnóstico</span>
                      <p class="text-gray-700 leading-relaxed">{{ p.diagnostico }}</p>
                    </div>
                    <div v-if="p.prescricao" class="bg-green-50 rounded-xl px-3 py-2">
                      <span class="text-[10px] font-bold text-green-600 uppercase tracking-widest block mb-0.5">Prescrição / Tratamento</span>
                      <p class="text-gray-700 leading-relaxed">{{ p.prescricao }}</p>
                    </div>
                    <div v-if="p.observacoes">
                      <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Observações</span>
                      <p class="text-gray-600 text-xs mt-0.5 leading-relaxed">{{ p.observacoes }}</p>
                    </div>
                    <div v-if="p.proxima_consulta" class="flex items-center gap-1.5 text-xs text-teal-600 bg-teal-50 rounded-xl px-3 py-1.5">
                      <svg class="w-3.5 h-3.5 shrink-0" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/></svg>
                      Retorno: {{ pronFormatDate(p.proxima_consulta) }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- MODAL EXCLUIR -->
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
              <h2 class="text-xl font-bold text-gray-800">Excluir animal?</h2>
              <p class="text-sm text-gray-500 mt-2 leading-relaxed">
                Tem certeza que deseja excluir <br /><strong class="text-gray-800">{{ excluindo.nome }}</strong>?<br />
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
import { createSupabaseClient } from '~/lib/supabase'
import { useAdmin } from '~/composables/useAdmin'
import { useEmpresa } from '~/composables/useEmpresa'
import AppInput from '~/components/AppInput.vue'
import AppButton from '~/components/AppButton.vue'
import AppNavIcon from '~/components/AppNavIcon.vue'

interface Animal {
  id: number
  nome: string
  especie: string | null
  raca: string | null
  cor: string | null
  peso: number | null
  data_nascimento: string | null
  sexo: string | null
  castrado: boolean | null
  foto_url: string | null
  observacoes: string | null
  cliente_id: number | null
  tutor_nome?: string | null
  empresa_id: number | null
  created_at: string | null
}

interface Tutor {
  id: number
  nome: string
  telefone: string | null
}

const supabase = createSupabaseClient()
const { empresaId, loadEmpresa } = useEmpresa()
const { isAdminOrGerente } = useAdmin()

const animais = ref<Animal[]>([])
const tutores = ref<Tutor[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

const editando = ref<Animal | null>(null)
const adicionando = ref(false)
const saving = ref(false)
const modalError = ref<string | null>(null)

const excluindo = ref<Animal | null>(null)
const deleting = ref(false)
const deleteError = ref<string | null>(null)

const vistaCards = ref(true)
const fotoInputRef = ref<HTMLInputElement | null>(null)
const fotoFile = ref<File | null>(null)
const fotoPreview = ref<string | null>(null)

const form = reactive({
  nome: '',
  especie: '',
  raca: '',
  cor: '',
  peso: '' as string | number,
  data_nascimento: '',
  sexo: '',
  castrado: false,
  observacoes: '',
  foto_url: '',
  cliente_id: null as number | null,
})

const formErrors = reactive({ nome: '', especie: '', cliente_id: '' })

const filtroAberto = ref(false)
const filtros = reactive({ busca: '', especie: '', tutorId: '' as string | number })

const especiesDisponiveis = [
  { value: 'cachorro', label: '🐶 Cachorro' },
  { value: 'gato', label: '🐱 Gato' },
  { value: 'passaro', label: '🐦 Pássaro' },
  { value: 'reptil', label: '🦎 Réptil' },
  { value: 'roedor', label: '🐹 Roedor' },
  { value: 'coelho', label: '🐰 Coelho' },
  { value: 'peixe', label: '🐟 Peixe' },
  { value: 'outro', label: '🐾 Outro' },
]

// ── Computed ──────────────────────────────────────────────────
const countEspecie = (esp: string) => animais.value.filter(a => a.especie === esp).length
const countOutros = computed(() =>
  animais.value.filter(a => !['cachorro', 'gato'].includes(a.especie ?? '')).length
)

const tutoresUnicos = computed<Tutor[]>(() => {
  const map = new Map<number, string>()
  animais.value.forEach(a => {
    if (a.cliente_id && a.tutor_nome) map.set(a.cliente_id, a.tutor_nome)
  })
  return Array.from(map.entries()).map(([id, nome]) => ({ id, nome, telefone: null }))
})

const filtrosAtivos = computed(() => {
  let c = 0
  if (filtros.busca) c++
  if (filtros.especie) c++
  if (filtros.tutorId) c++
  return c
})

const animaisFiltrados = computed(() => {
  return animais.value.filter(a => {
    if (filtros.especie && a.especie !== filtros.especie) return false
    if (filtros.tutorId && a.cliente_id !== Number(filtros.tutorId)) return false
    if (filtros.busca.trim()) {
      const q = filtros.busca.toLowerCase()
      return (
        a.nome.toLowerCase().includes(q) ||
        (a.raca ?? '').toLowerCase().includes(q) ||
        (a.tutor_nome ?? '').toLowerCase().includes(q)
      )
    }
    return true
  })
})

function limparFiltros() {
  filtros.busca = ''
  filtros.especie = ''
  filtros.tutorId = ''
}

// ── Helpers de UI ──────────────────────────────────────────────
function especieEmoji(especie: string | null) {
  const map: Record<string, string> = {
    cachorro: '🐶', gato: '🐱', passaro: '🐦', reptil: '🦎',
    roedor: '🐹', coelho: '🐰', peixe: '🐟', outro: '🐾',
  }
  return map[especie ?? ''] ?? '🐾'
}

function especieLabel(especie: string | null) {
  return especiesDisponiveis.find(e => e.value === especie)?.label.split(' ')[1] ?? especie ?? '—'
}

function especieCorFundo(especie: string | null) {
  const map: Record<string, string> = {
    cachorro: '#fef9c3', gato: '#fce7f3', passaro: '#dbeafe', reptil: '#dcfce7',
    roedor: '#fef3c7', coelho: '#fae8ff', peixe: '#cffafe', outro: '#f3f4f6',
  }
  return map[especie ?? ''] ?? '#f3f4f6'
}

function especieBadgeClass(especie: string | null) {
  const map: Record<string, string> = {
    cachorro: 'bg-amber-100 text-amber-700',
    gato: 'bg-pink-100 text-pink-700',
    passaro: 'bg-blue-100 text-blue-700',
    reptil: 'bg-green-100 text-green-700',
    roedor: 'bg-yellow-100 text-yellow-700',
    coelho: 'bg-purple-100 text-purple-700',
    peixe: 'bg-cyan-100 text-cyan-700',
    outro: 'bg-gray-100 text-gray-600',
  }
  return map[especie ?? ''] ?? 'bg-gray-100 text-gray-600'
}

function formatDate(d: string) {
  return new Date(d + 'T00:00:00').toLocaleDateString('pt-BR')
}

// ── Foto helpers ───────────────────────────────────────────────
function onFotoChange(e: Event) {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  fotoFile.value = file
  fotoPreview.value = URL.createObjectURL(file)
}

function removerFoto() {
  form.foto_url = ''
  fotoFile.value = null
  fotoPreview.value = null
  if (fotoInputRef.value) fotoInputRef.value.value = ''
}

async function uploadFoto(animalId: number): Promise<string | null> {
  if (!fotoFile.value) return form.foto_url || null
  const file = fotoFile.value
  const ext = file.name.split('.').pop() ?? 'jpg'
  const path = `${empresaId.value}/${animalId}.${ext}`
  const { error } = await supabase.storage.from('animais-fotos').upload(path, file, { upsert: true })
  if (error) throw error
  const { data } = supabase.storage.from('animais-fotos').getPublicUrl(path)
  return data.publicUrl
}

// ── Data ───────────────────────────────────────────────────────
async function carregarDados() {
  loading.value = true
  error.value = null
  try {
    await loadEmpresa()
    if (!empresaId.value) { error.value = 'Empresa não encontrada.'; return }

    const [animaisRes, tutoresRes] = await Promise.all([
      supabase
        .from('animais')
        .select('*, clientes(nome)')
        .eq('empresa_id', empresaId.value)
        .order('nome'),
      supabase
        .from('clientes')
        .select('id, nome, telefone')
        .eq('empresa_id', empresaId.value)
        .eq('ativo', true)
        .order('nome'),
    ])

    if (animaisRes.error) throw animaisRes.error
    if (tutoresRes.error) throw tutoresRes.error

    animais.value = (animaisRes.data ?? []).map((a: any) => ({
      ...a,
      tutor_nome: a.clientes?.nome ?? null,
    }))
    tutores.value = tutoresRes.data ?? []
  } catch (e: any) {
    error.value = e.message ?? 'Erro ao carregar dados.'
  } finally {
    loading.value = false
  }
}

// ── CRUD ───────────────────────────────────────────────────────
function resetForm() {
  form.nome = ''
  form.especie = ''
  form.raca = ''
  form.cor = ''
  form.peso = ''
  form.data_nascimento = ''
  form.sexo = ''
  form.castrado = false
  form.observacoes = ''
  form.foto_url = ''
  form.cliente_id = null
  fotoFile.value = null
  fotoPreview.value = null
  if (fotoInputRef.value) fotoInputRef.value.value = ''
  formErrors.nome = ''
  formErrors.especie = ''
  formErrors.cliente_id = ''
  modalError.value = null
}

function abrirAdicionar() {
  resetForm()
  adicionando.value = true
}

function editAnimal(animal: Animal) {
  resetForm()
  editando.value = animal
  form.nome = animal.nome
  form.especie = animal.especie ?? ''
  form.raca = animal.raca ?? ''
  form.cor = animal.cor ?? ''
  form.peso = animal.peso ?? ''
  form.data_nascimento = animal.data_nascimento ?? ''
  form.sexo = animal.sexo ?? ''
  form.castrado = animal.castrado ?? false
  form.observacoes = animal.observacoes ?? ''
  form.foto_url = animal.foto_url ?? ''
  form.cliente_id = animal.cliente_id
  fotoFile.value = null
  fotoPreview.value = null
}

function fecharModal() {
  editando.value = null
  adicionando.value = false
  resetForm()
}

function validarForm() {
  let ok = true
  formErrors.nome = ''
  formErrors.especie = ''
  formErrors.cliente_id = ''
  if (!form.nome.trim()) { formErrors.nome = 'Nome obrigatório.'; ok = false }
  if (!form.especie) { formErrors.especie = 'Selecione a espécie.'; ok = false }
  if (!form.cliente_id) { formErrors.cliente_id = 'Selecione o tutor.'; ok = false }
  return ok
}

async function salvarAdicao() {
  if (!validarForm()) return
  saving.value = true
  modalError.value = null
  try {
    const { data, error: err } = await supabase.from('animais').insert(buildPayload()).select('id').single()
    if (err) throw err
    if (fotoFile.value && data?.id) {
      const url = await uploadFoto(data.id)
      if (url) await supabase.from('animais').update({ foto_url: url }).eq('id', data.id)
    }
    fecharModal()
    await carregarDados()
  } catch (e: any) {
    modalError.value = e.message ?? 'Erro ao adicionar animal.'
  } finally {
    saving.value = false
  }
}

async function salvarEdicao() {
  if (!editando.value || !validarForm()) return
  saving.value = true
  modalError.value = null
  try {
    const foto_url = await uploadFoto(editando.value.id)
    const payload = { ...buildPayload(), foto_url }
    const { error: err } = await supabase.from('animais').update(payload).eq('id', editando.value.id)
    if (err) throw err
    fecharModal()
    await carregarDados()
  } catch (e: any) {
    modalError.value = e.message ?? 'Erro ao salvar animal.'
  } finally {
    saving.value = false
  }
}

function buildPayload() {
  return {
    nome: form.nome.trim(),
    especie: form.especie || null,
    raca: form.raca.trim() || null,
    cor: form.cor.trim() || null,
    peso: form.peso !== '' ? Number(form.peso) : null,
    data_nascimento: form.data_nascimento || null,
    sexo: form.sexo || null,
    castrado: form.castrado,
    observacoes: form.observacoes.trim() || null,
    foto_url: form.foto_url || null,
    cliente_id: form.cliente_id,
    empresa_id: empresaId.value,
  }
}

function confirmarExclusao(animal: Animal) {
  excluindo.value = animal
  deleteError.value = null
}

const copiedId = ref<number | null>(null)
function compartilharAnimal(animal: Animal) {
  const url = `${window.location.origin}/animal/${animal.id}`
  navigator.clipboard.writeText(url).then(() => {
    copiedId.value = animal.id
    setTimeout(() => { copiedId.value = null }, 2500)
  })
}

// ── Modal Prontuário ──────────────────────────────────────────

interface ProntuarioItem {
  id: number
  tipo: string
  data_consulta: string
  anamnese: string | null
  diagnostico: string | null
  prescricao: string | null
  observacoes: string | null
  proxima_consulta: string | null
  funcionario_nome: string | null
}

const prontuarioAnimal = ref<Animal | null>(null)
const prontuariosList  = ref<ProntuarioItem[]>([])
const prontuariosLoading = ref(false)

const pronTiposInfo: Record<string, { emoji: string; label: string; badge: string }> = {
  consulta:   { emoji: '🩺', label: 'Consulta',   badge: 'bg-blue-100 text-blue-700'    },
  retorno:    { emoji: '🔄', label: 'Retorno',    badge: 'bg-violet-100 text-violet-700' },
  vacina:     { emoji: '💉', label: 'Vacina',     badge: 'bg-green-100 text-green-700'  },
  cirurgia:   { emoji: '🔬', label: 'Cirurgia',   badge: 'bg-red-100 text-red-700'      },
  exame:      { emoji: '📋', label: 'Exame',      badge: 'bg-yellow-100 text-yellow-700'},
  emergencia: { emoji: '🚨', label: 'Emergência', badge: 'bg-orange-100 text-orange-700'},
  outros:     { emoji: '🐾', label: 'Outros',     badge: 'bg-gray-100 text-gray-600'    },
}
function pronTipoEmoji(t: string) { return pronTiposInfo[t]?.emoji ?? '🐾' }
function pronTipoLabel(t: string) { return pronTiposInfo[t]?.label ?? t }
function pronTipoBadge(t: string) { return pronTiposInfo[t]?.badge ?? 'bg-gray-100 text-gray-600' }
function pronFormatDate(d: string | null) {
  if (!d) return '—'
  const [y, m, day] = d.slice(0, 10).split('-')
  return `${day}/${m}/${y}`
}

const especieEmojiMapLocal: Record<string, string> = {
  cachorro: '🐶', gato: '🐱', passaro: '🐦', reptil: '🦎',
  roedor: '🐹', coelho: '🐰', peixe: '🐟',
}
const especieLabelMapLocal: Record<string, string> = {
  cachorro: 'Cachorro', gato: 'Gato', passaro: 'Pássaro', reptil: 'Réptil',
  roedor: 'Roedor', coelho: 'Coelho', peixe: 'Peixe',
}
function pronEspecieEmoji(e: string | null | undefined) { return especieEmojiMapLocal[e ?? ''] ?? '🐾' }
function pronEspecieLabel(e: string | null | undefined) { return especieLabelMapLocal[e ?? ''] ?? 'Animal' }

async function abrirProntuario(animal: Animal) {
  // mantém cópia do link
  compartilharAnimal(animal)
  // abre modal e busca prontuários
  prontuarioAnimal.value = animal
  prontuariosLoading.value = true
  prontuariosList.value = []
  novoAtendimentoAberto.value = false
  novoAtendimentoError.value = null
  novoAtendimentoSaving.value = false
  resetNovoAtendimento()
  const { data } = await supabase
    .from('prontuarios')
    .select('id, tipo, data_consulta, anamnese, diagnostico, prescricao, observacoes, proxima_consulta, funcionarios(nome)')
    .eq('animal_id', animal.id)
    .order('data_consulta', { ascending: false })
    .order('created_at', { ascending: false })
  prontuariosList.value = (data ?? []).map((p: any) => ({
    ...p,
    funcionario_nome: p.funcionarios?.nome ?? null,
  })) as ProntuarioItem[]
  prontuariosLoading.value = false
}

// ── Novo Atendimento no modal ─────────────────────────────────

interface FuncionarioVet { id: number; nome: string; cargo: string | null }
const funcionariosVet = ref<FuncionarioVet[]>([])
const novoAtendimentoAberto = ref(false)
const novoAtendimentoSaving = ref(false)
const novoAtendimentoError  = ref<string | null>(null)

const novoAtend = reactive({
  tipo:              'consulta',
  data_consulta:     new Date().toISOString().slice(0, 10),
  funcionario_id:    null as number | null,
  peso_aferido:      '' as string | number,
  temperatura:       '' as string | number,
  anamnese:          '',
  diagnostico:       '',
  prescricao:        '',
  observacoes:       '',
  proxima_consulta:  '',
  proxima_consulta_hora: '09:00',
})

function resetNovoAtendimento() {
  novoAtend.tipo = 'consulta'
  novoAtend.data_consulta = new Date().toISOString().slice(0, 10)
  novoAtend.funcionario_id = null
  novoAtend.peso_aferido = ''
  novoAtend.temperatura = ''
  novoAtend.anamnese = ''
  novoAtend.diagnostico = ''
  novoAtend.prescricao = ''
  novoAtend.observacoes = ''
  novoAtend.proxima_consulta = ''
  novoAtend.proxima_consulta_hora = '09:00'
}

async function carregarFuncionariosVet() {
  if (funcionariosVet.value.length) return
  const { data } = await supabase
    .from('funcionarios')
    .select('id, nome, cargo')
    .eq('empresa_id', empresaId.value!)
    .order('nome')
  funcionariosVet.value = (data ?? []).filter((f: any) =>
    f.cargo?.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').includes('veterin')
  ) as FuncionarioVet[]
}

async function salvarNovoAtendimento() {
  if (!prontuarioAnimal.value) return
  novoAtendimentoSaving.value = true
  novoAtendimentoError.value  = null
  try {
    const payload: Record<string, any> = {
      empresa_id:      prontuarioAnimal.value.empresa_id,
      animal_id:       prontuarioAnimal.value.id,
      cliente_id:      prontuarioAnimal.value.cliente_id ?? null,
      tipo:            novoAtend.tipo,
      data_consulta:   novoAtend.data_consulta,
      funcionario_id:  novoAtend.funcionario_id || null,
      peso_aferido:    novoAtend.peso_aferido !== '' ? Number(novoAtend.peso_aferido) : null,
      temperatura:     novoAtend.temperatura  !== '' ? Number(novoAtend.temperatura)  : null,
      anamnese:        novoAtend.anamnese.trim()    || null,
      diagnostico:     novoAtend.diagnostico.trim() || null,
      prescricao:      novoAtend.prescricao.trim()  || null,
      observacoes:     novoAtend.observacoes.trim() || null,
      proxima_consulta: novoAtend.proxima_consulta  || null,
    }
    const { error: err } = await supabase.from('prontuarios').insert(payload)
    if (err) throw err
    // Agendamento de retorno automático
    if (novoAtend.proxima_consulta) {
      const hora = novoAtend.proxima_consulta_hora || '09:00'
      const dataHora = `${novoAtend.proxima_consulta}T${hora}:00-03:00`
      let profileId: string | null = null
      const vet = funcionariosVet.value.find(f => f.id === novoAtend.funcionario_id)
      if (vet) {
        const vetFull = await supabase.from('funcionarios').select('email').eq('id', vet.id).maybeSingle()
        if (vetFull.data?.email) {
          const prof = await supabase.from('profiles').select('id').eq('email', vetFull.data.email).maybeSingle()
          profileId = prof.data?.id ?? null
        }
      }
      await supabase.from('agendamentos').insert({
        empresa_id:    prontuarioAnimal.value.empresa_id,
        animal_id:     prontuarioAnimal.value.id,
        cliente_id:    prontuarioAnimal.value.cliente_id ?? null,
        funcionario_id: profileId,
        data_hora:     dataHora,
        status:        'agendado',
        observacoes:   novoAtend.diagnostico.trim() ? `Retorno — ${novoAtend.diagnostico.slice(0, 120)}` : 'Retorno agendado pelo prontuário',
      })
    }
    // Recarrega lista
    novoAtendimentoAberto.value = false
    resetNovoAtendimento()
    prontuariosLoading.value = true
    const { data: refreshed } = await supabase
      .from('prontuarios')
      .select('id, tipo, data_consulta, anamnese, diagnostico, prescricao, observacoes, proxima_consulta, funcionarios(nome)')
      .eq('animal_id', prontuarioAnimal.value.id)
      .order('data_consulta', { ascending: false })
      .order('created_at', { ascending: false })
    prontuariosList.value = (refreshed ?? []).map((p: any) => ({
      ...p,
      funcionario_nome: p.funcionarios?.nome ?? null,
    })) as ProntuarioItem[]
    prontuariosLoading.value = false
  } catch (e: any) {
    novoAtendimentoError.value = e.message ?? 'Erro ao salvar atendimento.'
  } finally {
    novoAtendimentoSaving.value = false
  }
}

// ── Enviar prontuário WhatsApp ────────────────────────────────
function tutorTelefone(): string | null {
  if (!prontuarioAnimal.value?.cliente_id) return null
  const tutor = tutores.value.find(t => t.id === prontuarioAnimal.value!.cliente_id)
  return tutor?.telefone ?? null
}

function enviarProntuarioWhatsApp() {
  const tel = tutorTelefone()
  const animal = prontuarioAnimal.value
  if (!animal) return
  const url = `${window.location.origin}/animal/${animal.id}`
  const msg = `Olá! Segue o prontuário digital de *${animal.nome}* 🐾\n${url}`
  const numero = tel ? tel.replace(/\D/g, '') : ''
  const waUrl = numero
    ? `https://wa.me/55${numero}?text=${encodeURIComponent(msg)}`
    : `https://wa.me/?text=${encodeURIComponent(msg)}`
  window.open(waUrl, '_blank')
}

async function executarExclusao() {
  if (!excluindo.value) return
  deleting.value = true
  deleteError.value = null
  try {
    const { error: err } = await supabase.from('animais').delete().eq('id', excluindo.value.id)
    if (err) throw err
    excluindo.value = null
    await carregarDados()
  } catch (e: any) {
    deleteError.value = e.message ?? 'Erro ao excluir.'
  } finally {
    deleting.value = false
  }
}

onMounted(carregarDados)
</script>

<style scoped>
.slide-fade-enter-active, .slide-fade-leave-active { transition: all 0.2s ease; }
.slide-fade-enter-from, .slide-fade-leave-to { opacity: 0; transform: translateY(-8px); }
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.toast-enter-active, .toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translate(-50%, -12px); }
</style>
