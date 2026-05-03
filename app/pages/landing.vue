<template>
  <div class="min-h-screen font-sans antialiased overflow-x-hidden" style="background: #f0fdfa; color: #134e4a">

    <!-- NAV -->
    <nav class="nav-bar" :class="{ 'nav-bar--scrolled': scrolled }">
      <div class="nav-inner">

        <!-- Logo -->
        <NuxtLink to="/" class="nav-logo">
          <div class="nav-logo__icon">
            <svg width="16" height="16" fill="none" stroke="white" stroke-width="2" viewBox="0 0 24 24">
              <circle cx="7" cy="4" r="2" fill="white" stroke="none"/>
              <circle cx="17" cy="4" r="2" fill="white" stroke="none"/>
              <circle cx="4" cy="10" r="2" fill="white" stroke="none"/>
              <circle cx="20" cy="10" r="2" fill="white" stroke="none"/>
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 22c-4 0-7-3-7-7 0-2 1-4 2.5-5.5 1.5-1.5 3-2 4.5-2s3 .5 4.5 2C18 11 19 13 19 15c0 4-3 7-7 7z"/>
            </svg>
          </div>
          <span class="nav-logo__text">VetFlow</span>
        </NuxtLink>

        <!-- Desktop links -->
        <div class="nav-links">
          <a v-for="link in navLinks" :key="link.href" :href="link.href" class="nav-link">{{ link.label }}</a>
        </div>

        <!-- Desktop actions -->
        <div class="nav-actions">
          
          <a href="/login?tab=register" class="nav-btn-primary">Experimentar grátis</a>
        </div>

        <!-- Hamburger (mobile) -->
        <button class="nav-hamburger" @click="mobileOpen = !mobileOpen" aria-label="Menu">
          <span class="nav-hamburger__line" :class="{ 'nav-hamburger__line--top-open': mobileOpen }"></span>
          <span class="nav-hamburger__line" :class="{ 'nav-hamburger__line--mid-open': mobileOpen }"></span>
          <span class="nav-hamburger__line" :class="{ 'nav-hamburger__line--bot-open': mobileOpen }"></span>
        </button>

      </div>

      <!-- Mobile drawer -->
      <div v-if="mobileOpen" class="nav-mobile">
        <a v-for="link in navLinks" :key="link.href" :href="link.href" class="nav-mobile__link" @click="mobileOpen = false">{{ link.label }}</a>
        <div class="nav-mobile__actions">
          <a href="/login" class="nav-btn-ghost" @click="mobileOpen = false">Entrar</a>
          <a href="/login?tab=register" class="nav-btn-primary" @click="mobileOpen = false">Experimentar grátis</a>
        </div>
      </div>
    </nav>

    <!-- HERO -->
    <section class="relative min-h-screen flex items-center justify-center overflow-hidden pt-32 pb-16">
      <div class="absolute inset-0 pointer-events-none overflow-hidden">
        <div class="absolute -top-32 -left-32 w-[600px] h-[600px] rounded-full opacity-30 blur-[100px]" style="background: radial-gradient(circle, #99f6e4, transparent 70%)"></div>
        <div class="absolute -bottom-40 -right-40 w-[700px] h-[700px] rounded-full opacity-25 blur-[120px]" style="background: radial-gradient(circle, #a5f3fc, transparent 70%)"></div>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] rounded-full opacity-20 blur-[80px]" style="background: radial-gradient(circle, #ccfbf1, transparent 70%)"></div>
        <div class="absolute top-20 right-16 w-3.5 h-3.5 rounded-full bg-teal-300/40" style="animation: float 4s ease-in-out infinite"></div>
        <div class="absolute top-40 right-40 w-2 h-2 rounded-full bg-cyan-300/45" style="animation: float 5s ease-in-out infinite; animation-delay:.7s"></div>
        <div class="absolute top-60 left-20 w-2.5 h-2.5 rounded-full bg-teal-300/40" style="animation: float 4.5s ease-in-out infinite; animation-delay:1.3s"></div>
        <div class="absolute bottom-32 left-32 w-2 h-2 rounded-full bg-teal-400/35" style="animation: float 3.5s ease-in-out infinite; animation-delay:.4s"></div>
        <div class="absolute bottom-48 right-24 w-2.5 h-2.5 rounded-full bg-cyan-400/30" style="animation: float 4.2s ease-in-out infinite; animation-delay:1s"></div>
        <div class="absolute top-1/3 left-1/4 w-1.5 h-1.5 rounded-full bg-teal-300/30" style="animation: float 6s ease-in-out infinite; animation-delay:.2s"></div>
      </div>

      <div class="relative z-10 max-w-5xl mx-auto px-6 sm:px-10 text-center">
        <!-- Badge -->
        <div class="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-teal-100 border border-teal-200 mb-10 shadow-sm">
          <span class="text-xs font-black text-white bg-teal-500 rounded-full px-2 py-0.5">NOVO</span>
          <span class="text-xs font-bold text-teal-600 tracking-wider uppercase">VetFlow — sistema veterinário completo</span>
        </div>

        <!-- Headline -->
        <h1 class="font-black tracking-tight mb-6" style="line-height: 1.04;">
          <span class="block" style="font-size: clamp(2.4rem, 6vw, 4.8rem); background: linear-gradient(135deg, #0f766e, #0e7490); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Prontuário perdido.</span>
          <span class="block" style="font-size: clamp(2.4rem, 6vw, 4.8rem); background: linear-gradient(135deg, #0f766e, #0e7490); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Vacina vencendo sem aviso.</span>
          <span class="block mt-2" style="font-size: clamp(2.2rem, 5.5vw, 4.4rem); background: linear-gradient(135deg, #2dd4bf, #0891b2, #0284c7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Sua clínica precisa de um</span>
          <span class="block" style="font-size: clamp(2.2rem, 5.5vw, 4.4rem); background: linear-gradient(135deg, #2dd4bf, #0891b2, #0284c7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">sistema que não te abandona.</span>
        </h1>

        <!-- Subheadline -->
        <p class="text-lg sm:text-xl max-w-2xl mx-auto mb-10 leading-relaxed" style="color: rgba(15,70,60,0.6)">
          Agenda inteligente, prontuário digital, controle financeiro e gestão de equipe — feito para <strong class="text-teal-500 font-semibold">veterinários</strong> que querem atender mais e administrar menos.
        </p>

        <!-- CTAs -->
        <div class="flex flex-col sm:flex-row items-center justify-center gap-4 mb-14">
          <a href="/login?tab=register"
            class="inline-flex items-center gap-2 text-base font-black px-10 py-4 rounded-full text-white transition-all duration-200 hover:scale-105"
            style="background: linear-gradient(135deg, #2dd4bf, #0891b2); box-shadow: 0 8px 28px rgba(13,148,136,0.4);">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
            Criar conta grátis
          </a>
          <a href="#precos"
            class="inline-flex items-center gap-2 text-base font-semibold px-8 py-4 rounded-full border-2 border-teal-200 text-teal-500 bg-white hover:bg-teal-50 hover:border-teal-300 transition-all duration-200 shadow-sm">
            Ver planos e preços
          </a>
        </div>

        <!-- Social proof -->
        <div class="flex flex-wrap items-center justify-center gap-5 text-sm" style="color: rgba(15,70,60,0.5)">
          <div class="flex items-center gap-2">
            <div class="flex -space-x-2">
              <div v-for="(c, i) in avatarColors" :key="i"
                class="w-8 h-8 rounded-full border-2 border-white flex items-center justify-center text-xs font-black text-white"
                :style="{ background: c }">{{ avatarInitials[i] }}</div>
            </div>
            <span class="font-semibold">+200 clínicas ativas</span>
          </div>
          <span class="text-teal-200 hidden sm:inline">|</span>
          <div class="flex items-center gap-1.5">
            <svg v-for="s in 5" :key="s" class="w-4 h-4 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
            <span class="font-semibold" style="color: rgba(15,70,60,0.7)">4.9 de satisfação</span>
          </div>
          <span class="text-teal-200 hidden sm:inline">|</span>
          <div class="flex items-center gap-1.5">
            <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <span>7 dias grátis, sem cartão</span>
          </div>
        </div>
      </div>
    </section>

    <!-- DORES -->
    <section class="py-16 sm:py-20 relative" style="background: linear-gradient(180deg, #f0fdfa 0%, #ecfeff 100%)">
      <div class="max-w-5xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-12">
          <p class="section-label">Reconhece isso?</p>
          <h2 class="text-3xl sm:text-4xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">O dia a dia sem um sistema organizado</h2>
          <p class="text-teal-900/50 max-w-md mx-auto">Essas dores custam tempo, dinheiro e pacientes. Você não precisa mais viver assim.</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <div v-for="dor in dores" :key="dor.titulo"
            class="flex items-start gap-4 p-5 rounded-2xl bg-white border border-teal-100 shadow-sm">
            <div class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 bg-teal-50 border border-teal-100">
              <svg class="w-5 h-5 text-teal-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" v-html="dor.svg"></svg>
            </div>
            <div>
              <p class="text-sm font-bold text-gray-800 mb-1">{{ dor.titulo }}</p>
              <p class="text-xs text-gray-500 leading-relaxed">{{ dor.desc }}</p>
            </div>
          </div>
        </div>
        <div class="mt-10 text-center">
          <a href="/login?tab=register"
            class="inline-flex items-center gap-2 text-sm font-black px-8 py-3.5 rounded-full text-white transition-all duration-200 hover:scale-105"
            style="background: linear-gradient(135deg, #2dd4bf, #0891b2); box-shadow: 0 6px 20px rgba(13,148,136,0.35)">
            Quero resolver isso agora
          </a>
        </div>
      </div>
    </section>

    <!-- PARA QUEM -->
    <section class="py-16 sm:py-24 relative" style="background: linear-gradient(180deg, #f0fdfa 0%, #f0fdfa 100%)">
      <div class="max-w-5xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-12">
          <p class="section-label">Para quem é</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Feito para o seu negócio veterinário</h2>
          <p class="text-teal-900/50 max-w-md mx-auto mt-2">De clínicas a petshops, se você cuida de animais, essa plataforma é para você.</p>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
          <div v-for="tipo in tiposNegocio" :key="tipo.label"
            class="group flex flex-col items-center text-center gap-3 px-4 py-8 rounded-2xl border border-teal-100 bg-white hover:border-teal-300 hover:shadow-xl hover:shadow-teal-100/60 hover:-translate-y-1 transition-all duration-300 cursor-default">
            <div class="w-14 h-14 rounded-2xl flex items-center justify-center shadow-md group-hover:scale-110 group-hover:shadow-lg group-hover:shadow-teal-200/60 transition-all duration-300" :style="{ background: tipo.bg }">
              <svg class="w-6 h-6" :style="{ color: tipo.color }" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24" v-html="tipo.svg"></svg>
            </div>
            <span class="text-sm font-bold leading-tight" style="color: #0f766e">{{ tipo.label }}</span>
          </div>
        </div>
      </div>
    </section>

    <!-- FUNCIONALIDADES -->
    <section id="funcionalidades" class="py-16 sm:py-24 relative" style="background: linear-gradient(180deg, #f0fdfa 0%, #ccfbf1 100%)">
      <div class="max-w-6xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-12">
          <p class="section-label">Funcionalidades</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Tudo para o seu dia a dia</h2>
          <p class="text-teal-900/50 max-w-lg mx-auto">Da agenda ao caixa, do estoque à equipe. Uma plataforma que entende o ritmo da sua clínica.</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          <div v-for="feat in features" :key="feat.title"
            class="group relative p-6 rounded-3xl bg-white border border-teal-100 hover:border-teal-200 hover:shadow-xl hover:shadow-teal-100/50 transition-all duration-300 overflow-hidden">
            <div class="absolute inset-x-0 top-0 h-[2px] rounded-t-3xl opacity-0 group-hover:opacity-100 transition-opacity duration-300" style="background: linear-gradient(90deg, #2dd4bf, #22d3ee, #c084fc)"></div>
            <div class="w-12 h-12 rounded-2xl flex items-center justify-center mb-4 shadow-md group-hover:scale-110 group-hover:shadow-teal-200/80 transition-all duration-300" :style="{ background: feat.bg }">
              <svg class="w-5 h-5" :style="{ color: feat.color }" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24" v-html="feat.svg"></svg>
            </div>
            <h3 class="text-base font-bold mb-2" style="color: #0e7490">{{ feat.title }}</h3>
            <p class="text-sm text-teal-900/55 leading-relaxed">{{ feat.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- STATS -->
    <section class="py-14 sm:py-20" style="background: linear-gradient(135deg, #ecfeff, #ccfbf1)">
      <div class="max-w-4xl mx-auto px-5 sm:px-10">
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div v-for="stat in stats" :key="stat.label" class="text-center bg-white/80 backdrop-blur-sm rounded-2xl py-8 px-4 border border-teal-100 shadow-sm hover:shadow-md hover:shadow-teal-100/80 transition-all duration-200 group">
            <div class="text-4xl sm:text-5xl font-black mb-2 group-hover:scale-105 transition-transform duration-200" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text">{{ stat.value }}</div>
            <div class="text-xs font-semibold text-teal-900/50 uppercase tracking-wider leading-snug">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- DEVICE SHOWCASE -->
    <section class="py-20 sm:py-28 relative overflow-hidden" style="background: linear-gradient(180deg, #ccfbf1 0%, #ecfeff 100%)">
      <div class="absolute -top-24 -right-24 w-[500px] h-[500px] rounded-full opacity-20 blur-[100px] pointer-events-none" style="background: radial-gradient(circle, #5eead4, transparent)"></div>
      <div class="absolute -bottom-24 -left-24 w-[400px] h-[400px] rounded-full opacity-20 blur-[100px] pointer-events-none" style="background: radial-gradient(circle, #22d3ee, transparent)"></div>

      <div class="relative max-w-7xl mx-auto px-6 sm:px-10">
        <div class="text-center mb-16">
          <p class="section-label">Acesso em qualquer lugar</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Desktop ou celular, tudo em um só lugar</h2>
          <p class="text-teal-900/50 max-w-lg mx-auto">Gerencie sua clínica de onde estiver. Tudo sincronizado em tempo real.</p>
        </div>

        <!-- Desktop + Phone side by side -->
        <div class="flex flex-col lg:flex-row items-center justify-center gap-10 lg:gap-8">

          <!-- ── DESKTOP MOCKUP — Visão Geral ── -->
          <div class="relative flex-shrink-0 w-full max-w-2xl lg:max-w-none" style="flex:1;">
            <div class="relative" style="border-radius:16px 16px 0 0; border:6px solid #1e293b; border-bottom:0; background:#0f172a; box-shadow: 0 32px 64px rgba(0,0,0,0.22);">
              <!-- Browser bar -->
              <div style="height:32px; background:#1e293b; border-radius:10px 10px 0 0; display:flex; align-items:center; padding:0 12px; gap:6px;">
                <div style="width:10px;height:10px;border-radius:999px;background:#ef4444;opacity:.8;"></div>
                <div style="width:10px;height:10px;border-radius:999px;background:#f59e0b;opacity:.8;"></div>
                <div style="width:10px;height:10px;border-radius:999px;background:#22c55e;opacity:.8;"></div>
                <div style="flex:1;margin-left:10px;height:18px;border-radius:999px;background:rgba(255,255,255,0.08);display:flex;align-items:center;padding:0 10px;">
                  <span style="font-size:9px;color:rgba(255,255,255,0.4);font-family:monospace;">app.clinicavet.com.br</span>
                </div>
              </div>
              <!-- Screen content -->
              <div style="background:#f1f5f9; display:flex; height:380px; overflow:hidden; border-radius:0 0 2px 2px;">
                <!-- Sidebar esquerda — igual ao sistema real -->
                <div style="width:52px; background:#0f172a; display:flex; flex-direction:column; align-items:center; padding:12px 0; gap:4px; flex-shrink:0;">
                  <!-- Logo -->
                  <div style="width:32px;height:32px;border-radius:10px;background:linear-gradient(135deg,#0d9488,#0891b2);display:flex;align-items:center;justify-content:center;margin-bottom:12px;">
                    <svg style="width:16px;height:16px;color:white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="7" cy="4" r="2" fill="white" stroke="none"/><circle cx="17" cy="4" r="2" fill="white" stroke="none"/><circle cx="4" cy="10" r="2" fill="white" stroke="none"/><circle cx="20" cy="10" r="2" fill="white" stroke="none"/><path stroke-linecap="round" stroke-linejoin="round" d="M12 22c-4 0-7-3-7-7 0-2 1-4 2.5-5.5 1.5-1.5 3-2 4.5-2s3 .5 4.5 2C18 11 19 13 19 15c0 4-3 7-7 7z"/></svg>
                  </div>
                  <!-- Nav icons -->
                  <div style="width:36px;height:36px;border-radius:10px;background:rgba(13,148,136,0.2);display:flex;align-items:center;justify-content:center;">
                    <svg style="width:16px;height:16px;color:#2dd4bf" fill="currentColor" viewBox="0 0 24 24"><path d="M11.47 3.841a.75.75 0 011.06 0l8.69 8.69a.75.75 0 101.06-1.061l-8.689-8.69a2.25 2.25 0 00-3.182 0l-8.69 8.69a.75.75 0 101.061 1.06l8.69-8.689z"/><path d="m12 5.432 8.159 8.159c.03.03.06.058.091.086v6.198c0 1.035-.84 1.875-1.875 1.875H15a.75.75 0 01-.75-.75v-4.5a.75.75 0 00-.75-.75h-3a.75.75 0 00-.75.75V21a.75.75 0 01-.75.75H5.625a1.875 1.875 0 01-1.875-1.875v-6.198a2.29 2.29 0 00.091-.086L12 5.43z"/></svg>
                  </div>
                  <div style="width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;opacity:0.4;">
                    <svg style="width:16px;height:16px;color:#94a3b8" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75"/></svg>
                  </div>
                  <div style="width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;opacity:0.4;">
                    <svg style="width:16px;height:16px;color:#94a3b8" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/></svg>
                  </div>
                  <div style="width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;opacity:0.4;">
                    <svg style="width:16px;height:16px;color:#94a3b8" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25z"/></svg>
                  </div>
                  <div style="width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;opacity:0.4;">
                    <svg style="width:16px;height:16px;color:#94a3b8" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75"/></svg>
                  </div>
                </div>
                <!-- Main content -->
                <div style="flex:1; overflow:hidden; display:flex; flex-direction:column;">
                  <!-- Page header — igual ao real -->
                  <div style="position:relative; overflow:hidden; background:linear-gradient(135deg,#0d9488,#0891b2); padding:14px 16px 14px; flex-shrink:0;">
                    <div style="position:absolute;inset:0;background:radial-gradient(ellipse at top right,rgba(255,255,255,0.12),transparent 60%);"></div>
                    <div style="position:relative; display:flex; align-items:center; justify-content:space-between; gap:10px;">
                      <div style="display:flex; align-items:center; gap:10px;">
                        <div style="width:36px;height:36px;border-radius:10px;background:rgba(255,255,255,0.15);border:1px solid rgba(255,255,255,0.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                          <svg style="width:18px;height:18px;color:white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
                        </div>
                        <div>
                          <p style="font-size:8px;font-weight:700;color:rgba(255,255,255,0.7);text-transform:uppercase;letter-spacing:0.1em;margin:0;">Clínica</p>
                          <p style="font-size:16px;font-weight:900;color:white;margin:0;line-height:1.1;">Prontuários</p>
                          <p style="font-size:8px;color:rgba(255,255,255,0.6);margin:3px 0 0;">24 registros exibidos</p>
                        </div>
                      </div>
                      <div style="display:flex;gap:6px;">
                        <div style="display:flex;align-items:center;gap:5px;background:rgba(255,255,255,0.1);border:1px solid rgba(255,255,255,0.15);border-radius:8px;padding:6px 10px;">
                          <svg style="width:11px;height:11px;color:white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/></svg>
                          <span style="font-size:9px;font-weight:700;color:white;">Filtros</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:5px;background:white;border-radius:8px;padding:6px 10px;">
                          <svg style="width:11px;height:11px;color:#0d9488" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
                          <span style="font-size:9px;font-weight:800;color:#0d9488;">Novo Prontuário</span>
                        </div>
                      </div>
                    </div>
                    <!-- Stats row -->
                    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:6px;margin-top:10px;position:relative;">
                      <div style="background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.1);border-radius:8px;padding:6px 8px;">
                        <p style="font-size:7px;font-weight:700;color:rgba(255,255,255,0.65);text-transform:uppercase;letter-spacing:0.08em;margin:0;">Total</p>
                        <p style="font-size:16px;font-weight:900;color:white;margin:2px 0 0;line-height:1;">24</p>
                        <p style="font-size:7px;color:rgba(255,255,255,0.45);margin:2px 0 0;">registros</p>
                      </div>
                      <div style="background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.1);border-radius:8px;padding:6px 8px;">
                        <p style="font-size:7px;font-weight:700;color:rgba(255,255,255,0.65);text-transform:uppercase;letter-spacing:0.08em;margin:0;">Consultas</p>
                        <p style="font-size:16px;font-weight:900;color:white;margin:2px 0 0;line-height:1;">18</p>
                        <p style="font-size:7px;color:rgba(255,255,255,0.45);margin:2px 0 0;">consultas</p>
                      </div>
                      <div style="background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.08);border-radius:8px;padding:6px 8px;">
                        <p style="font-size:7px;font-weight:700;color:rgba(255,255,255,0.65);text-transform:uppercase;letter-spacing:0.08em;margin:0;">Vacinas</p>
                        <p style="font-size:16px;font-weight:900;color:white;margin:2px 0 0;line-height:1;">4</p>
                        <p style="font-size:7px;color:rgba(255,255,255,0.45);margin:2px 0 0;">registros</p>
                      </div>
                      <div style="background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.08);border-radius:8px;padding:6px 8px;">
                        <p style="font-size:7px;font-weight:700;color:rgba(255,255,255,0.65);text-transform:uppercase;letter-spacing:0.08em;margin:0;">Últ. 30 dias</p>
                        <p style="font-size:16px;font-weight:900;color:white;margin:2px 0 0;line-height:1;">11</p>
                        <p style="font-size:7px;color:rgba(255,255,255,0.45);margin:2px 0 0;">registros</p>
                      </div>
                    </div>
                  </div>
                  <!-- Prontuário list -->
                  <div style="flex:1; overflow:hidden; background:#f1f5f9; padding:10px 12px; display:flex; flex-direction:column; gap:6px;">
                    <!-- Search bar -->
                    <div style="display:flex;align-items:center;gap:6px;background:white;border:1px solid #e2e8f0;border-radius:8px;padding:6px 10px;margin-bottom:2px;">
                      <svg style="width:11px;height:11px;color:#94a3b8;flex-shrink:0;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"/></svg>
                      <span style="font-size:9px;color:#94a3b8;">Buscar por animal, tutor ou veterinário…</span>
                    </div>
                    <!-- Row 1 -->
                    <div style="background:white;border-radius:10px;border:1px solid #e2e8f0;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                      <div style="height:3px;background:linear-gradient(90deg,#0d9488,#0891b2);"></div>
                      <div style="display:flex;align-items:center;gap:8px;padding:8px 10px;">
                        <div style="width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#0d9488,#0891b2);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:10px;font-weight:900;color:white;">R</div>
                        <div style="flex:1;min-width:0;">
                          <div style="display:flex;align-items:center;gap:5px;">
                            <p style="font-size:10px;font-weight:800;color:#0f172a;margin:0;">Rex</p>
                            <span style="font-size:7px;font-weight:700;background:#f0fdfa;color:#0d9488;border:1px solid #99f6e4;border-radius:4px;padding:1px 5px;">Consulta</span>
                          </div>
                          <p style="font-size:8px;color:#64748b;margin:2px 0 0;">Golden Retriever · Tutor: Carlos Mendes</p>
                        </div>
                        <div style="text-align:right;flex-shrink:0;">
                          <p style="font-size:8px;font-weight:700;color:#0f766e;margin:0;">Dra. Ana Lima</p>
                          <p style="font-size:7px;color:#94a3b8;margin:2px 0 0;">26/04/2026</p>
                        </div>
                      </div>
                    </div>
                    <!-- Row 2 -->
                    <div style="background:white;border-radius:10px;border:1px solid #e2e8f0;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                      <div style="height:3px;background:linear-gradient(90deg,#059669,#0d9488);"></div>
                      <div style="display:flex;align-items:center;gap:8px;padding:8px 10px;">
                        <div style="width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#059669,#0d9488);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:10px;font-weight:900;color:white;">M</div>
                        <div style="flex:1;min-width:0;">
                          <div style="display:flex;align-items:center;gap:5px;">
                            <p style="font-size:10px;font-weight:800;color:#0f172a;margin:0;">Mia</p>
                            <span style="font-size:7px;font-weight:700;background:#f0fdf4;color:#059669;border:1px solid #86efac;border-radius:4px;padding:1px 5px;">Vacina</span>
                          </div>
                          <p style="font-size:8px;color:#64748b;margin:2px 0 0;">Siamesa · Tutor: Fernanda Costa</p>
                        </div>
                        <div style="text-align:right;flex-shrink:0;">
                          <p style="font-size:8px;font-weight:700;color:#0f766e;margin:0;">Dr. Bruno Vet</p>
                          <p style="font-size:7px;color:#94a3b8;margin:2px 0 0;">25/04/2026</p>
                        </div>
                      </div>
                    </div>
                    <!-- Row 3 -->
                    <div style="background:white;border-radius:10px;border:1px solid #e2e8f0;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                      <div style="height:3px;background:linear-gradient(90deg,#0891b2,#0e7490);"></div>
                      <div style="display:flex;align-items:center;gap:8px;padding:8px 10px;">
                        <div style="width:28px;height:28px;border-radius:8px;background:linear-gradient(135deg,#0891b2,#0e7490);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:10px;font-weight:900;color:white;">B</div>
                        <div style="flex:1;min-width:0;">
                          <div style="display:flex;align-items:center;gap:5px;">
                            <p style="font-size:10px;font-weight:800;color:#0f172a;margin:0;">Bob</p>
                            <span style="font-size:7px;font-weight:700;background:#ecfeff;color:#0891b2;border:1px solid #a5f3fc;border-radius:4px;padding:1px 5px;">Retorno</span>
                          </div>
                          <p style="font-size:8px;color:#64748b;margin:2px 0 0;">Bulldog · Tutor: Paulo Ramos</p>
                        </div>
                        <div style="text-align:right;flex-shrink:0;">
                          <p style="font-size:8px;font-weight:700;color:#0f766e;margin:0;">Dra. Ana Lima</p>
                          <p style="font-size:7px;color:#94a3b8;margin:2px 0 0;">24/04/2026</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!-- Monitor stand -->
            <div style="display:flex;flex-direction:column;align-items:center;">
              <div style="width:100%;height:8px;background:#1e293b;border-radius:0 0 4px 4px;border:6px solid #1e293b;border-top:0;"></div>
              <div style="width:60px;height:20px;background:#1e293b;border-radius:0 0 6px 6px;"></div>
              <div style="width:100px;height:6px;background:#334155;border-radius:999px;margin-top:2px;"></div>
            </div>
            <!-- Label -->
            <div class="text-center mt-4">
              <span class="inline-flex items-center gap-2 text-xs font-bold text-teal-700 bg-teal-50 border border-teal-200 rounded-full px-4 py-1.5">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><path d="M8 21h8M12 17v4"/></svg>
                Desktop — Prontuários
              </span>
            </div>
            <!-- Glow -->
            <div class="absolute -z-10" style="top:10%;left:10%;right:10%;bottom:0;filter:blur(60px);opacity:0.35;background:radial-gradient(circle, #0d9488, #0891b2);"></div>
          </div>

          <!-- ── PHONE MOCKUP — Prontuário ── -->
          <div class="relative flex-shrink-0">
            <!-- Phone frame -->
            <div class="relative" style="width:240px; height:500px; border-radius:44px; border:7px solid #1a0a1e; background:#f3f4f6; box-shadow: 0 32px 64px rgba(0,0,0,0.28), 0 0 0 1px rgba(255,255,255,0.08) inset;">
              <!-- Screen -->
              <div class="absolute flex flex-col" style="inset:0; border-radius:38px; overflow:hidden; background:#f3f4f6;">
                <!-- Header prontuário -->
                <div class="relative flex-shrink-0" style="background:linear-gradient(135deg,#0d9488,#0891b2); padding:10px 10px 10px;">
                  <div style="display:flex; justify-content:center; margin-bottom:8px;">
                    <div style="width:64px; height:16px; border-radius:999px; background:#1a0a1e;"></div>
                  </div>
                  <div class="absolute" style="inset:0; border-radius:inherit; background:radial-gradient(ellipse at top right, rgba(255,255,255,0.18), transparent 65%);"></div>
                  <!-- Título -->
                  <div class="relative" style="display:flex;align-items:center;gap:7px;margin-bottom:8px;">
                    <div style="width:28px;height:28px;border-radius:8px;background:rgba(255,255,255,0.15);border:1px solid rgba(255,255,255,0.2);display:flex;align-items:center;justify-content:center;">
                      <svg style="width:14px;height:14px;color:white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25z"/></svg>
                    </div>
                    <div>
                      <p style="font-size:7px;font-weight:700;color:rgba(255,255,255,0.7);text-transform:uppercase;letter-spacing:0.1em;margin:0;">Clínica</p>
                      <p style="font-size:13px;font-weight:900;color:white;margin:0;line-height:1.1;">Prontuários</p>
                    </div>
                    <div style="margin-left:auto;background:white;border-radius:7px;padding:4px 7px;display:flex;align-items:center;gap:4px;">
                      <svg style="width:9px;height:9px;color:#0d9488" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
                      <span style="font-size:8px;font-weight:800;color:#0d9488;">Novo</span>
                    </div>
                  </div>
                  <!-- Mini stats -->
                  <div class="relative" style="display:grid;grid-template-columns:repeat(4,1fr);gap:4px;">
                    <div style="background:rgba(255,255,255,0.13);border:1px solid rgba(255,255,255,0.1);border-radius:7px;padding:4px 3px;text-align:center;">
                      <p style="font-size:6px;font-weight:700;color:rgba(255,255,255,0.7);letter-spacing:0.05em;margin:0;text-transform:uppercase;">Total</p>
                      <p style="font-size:12px;font-weight:900;color:white;margin:1px 0 0;line-height:1;">24</p>
                    </div>
                    <div style="background:rgba(255,255,255,0.13);border:1px solid rgba(255,255,255,0.1);border-radius:7px;padding:4px 3px;text-align:center;">
                      <p style="font-size:6px;font-weight:700;color:rgba(255,255,255,0.7);letter-spacing:0.05em;margin:0;text-transform:uppercase;">Consultas</p>
                      <p style="font-size:12px;font-weight:900;color:white;margin:1px 0 0;line-height:1;">18</p>
                    </div>
                    <div style="background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.08);border-radius:7px;padding:4px 3px;text-align:center;">
                      <p style="font-size:6px;font-weight:700;color:rgba(255,255,255,0.7);letter-spacing:0.05em;margin:0;text-transform:uppercase;">Vacinas</p>
                      <p style="font-size:12px;font-weight:900;color:white;margin:1px 0 0;line-height:1;">4</p>
                    </div>
                    <div style="background:rgba(255,255,255,0.07);border:1px solid rgba(255,255,255,0.08);border-radius:7px;padding:4px 3px;text-align:center;">
                      <p style="font-size:6px;font-weight:700;color:rgba(255,255,255,0.7);letter-spacing:0.05em;margin:0;text-transform:uppercase;">30 dias</p>
                      <p style="font-size:12px;font-weight:900;color:white;margin:1px 0 0;line-height:1;">11</p>
                    </div>
                  </div>
                </div>

                <!-- Body — lista de prontuários -->
                <div style="flex:1; overflow:hidden; padding:8px 7px; display:flex; flex-direction:column; gap:5px; background:#f1f5f9;">
                  <!-- search -->
                  <div style="display:flex;align-items:center;gap:5px;background:white;border:1px solid #e2e8f0;border-radius:8px;padding:5px 8px;">
                    <svg style="width:9px;height:9px;color:#94a3b8;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"/></svg>
                    <span style="font-size:7.5px;color:#94a3b8;">Buscar prontuário…</span>
                  </div>
                  <!-- Card 1 -->
                  <div style="background:white;border-radius:10px;border:1px solid #e2e8f0;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                    <div style="height:3px;background:linear-gradient(90deg,#0d9488,#0891b2);"></div>
                    <div style="padding:7px 8px;">
                      <div style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">
                        <div style="width:22px;height:22px;border-radius:6px;background:linear-gradient(135deg,#0d9488,#0891b2);display:flex;align-items:center;justify-content:center;font-size:8px;font-weight:900;color:white;flex-shrink:0;">R</div>
                        <div style="flex:1;min-width:0;">
                          <div style="display:flex;align-items:center;gap:4px;">
                            <p style="font-size:9px;font-weight:800;color:#0f172a;margin:0;">Rex</p>
                            <span style="font-size:6px;font-weight:700;background:#f0fdfa;color:#0d9488;border:1px solid #99f6e4;border-radius:4px;padding:1px 4px;">Consulta</span>
                          </div>
                          <p style="font-size:7px;color:#64748b;margin:1px 0 0;">Golden · Tutor: Carlos Mendes</p>
                        </div>
                        <p style="font-size:7px;color:#94a3b8;flex-shrink:0;margin:0;">26/04</p>
                      </div>
                      <div style="background:#f8fafc;border-radius:6px;padding:5px 7px;border-left:2px solid #0d9488;">
                        <p style="font-size:7px;color:#475569;margin:0;line-height:1.4;">Animal apresentou dispneia leve. Prescrito broncodilatador por 7 dias. Retorno em 15 dias.</p>
                      </div>
                      <div style="display:flex;align-items:center;gap:4px;margin-top:4px;">
                        <svg style="width:8px;height:8px;color:#0d9488;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0"/></svg>
                        <p style="font-size:7px;font-weight:700;color:#0d9488;margin:0;">Dra. Ana Lima</p>
                      </div>
                    </div>
                  </div>
                  <!-- Card 2 -->
                  <div style="background:white;border-radius:10px;border:1px solid #e2e8f0;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.04);">
                    <div style="height:3px;background:linear-gradient(90deg,#059669,#0d9488);"></div>
                    <div style="padding:7px 8px;">
                      <div style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">
                        <div style="width:22px;height:22px;border-radius:6px;background:linear-gradient(135deg,#059669,#0d9488);display:flex;align-items:center;justify-content:center;font-size:8px;font-weight:900;color:white;flex-shrink:0;">M</div>
                        <div style="flex:1;min-width:0;">
                          <div style="display:flex;align-items:center;gap:4px;">
                            <p style="font-size:9px;font-weight:800;color:#0f172a;margin:0;">Mia</p>
                            <span style="font-size:6px;font-weight:700;background:#f0fdf4;color:#059669;border:1px solid #86efac;border-radius:4px;padding:1px 4px;">Vacina</span>
                          </div>
                          <p style="font-size:7px;color:#64748b;margin:1px 0 0;">Siamesa · Tutor: Fernanda Costa</p>
                        </div>
                        <p style="font-size:7px;color:#94a3b8;flex-shrink:0;margin:0;">25/04</p>
                      </div>
                      <div style="background:#f8fafc;border-radius:6px;padding:5px 7px;border-left:2px solid #059669;">
                        <p style="font-size:7px;color:#475569;margin:0;line-height:1.4;">V4 e antirrábica aplicadas. Peso: 4,2kg. Próxima dose em 12 meses.</p>
                      </div>
                      <div style="display:flex;align-items:center;gap:4px;margin-top:4px;">
                        <svg style="width:8px;height:8px;color:#059669;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0"/></svg>
                        <p style="font-size:7px;font-weight:700;color:#059669;margin:0;">Dr. Bruno Vet</p>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Bottom nav -->
                <div style="flex-shrink:0; border-top:1px solid #e2e8f0; background:white; padding:5px 0; display:flex; align-items:center; justify-content:space-around;">
                  <div style="display:flex;flex-direction:column;align-items:center;gap:2px;opacity:0.35;">
                    <svg style="width:13px;height:13px;color:#6b7280;" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955a1.126 1.126 0 011.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"/></svg>
                    <span style="font-size:6px;font-weight:600;color:#9ca3af;">Início</span>
                  </div>
                  <div style="display:flex;flex-direction:column;align-items:center;gap:2px;opacity:0.35;">
                    <svg style="width:13px;height:13px;color:#6b7280;" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/></svg>
                    <span style="font-size:6px;font-weight:600;color:#9ca3af;">Agenda</span>
                  </div>
                  <div style="display:flex;flex-direction:column;align-items:center;gap:2px;">
                    <svg style="width:13px;height:13px;color:#0d9488;" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375"/></svg>
                    <span style="font-size:6px;font-weight:700;color:#0d9488;">Prontuário</span>
                  </div>
                  <div style="display:flex;flex-direction:column;align-items:center;gap:2px;opacity:0.35;">
                    <svg style="width:13px;height:13px;color:#6b7280;" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75"/></svg>
                    <span style="font-size:6px;font-weight:600;color:#9ca3af;">Caixa</span>
                  </div>
                </div>
              </div>
              <!-- Side buttons -->
              <div class="absolute" style="right:-5px; top:88px; width:4px; height:52px; border-radius:999px; background:#1a0a1e;"></div>
              <div class="absolute" style="left:-5px; top:76px; width:4px; height:34px; border-radius:999px; background:#1a0a1e;"></div>
              <div class="absolute" style="left:-5px; top:120px; width:4px; height:34px; border-radius:999px; background:#1a0a1e;"></div>
            </div>
            <!-- Label -->
            <div class="text-center mt-5">
              <span class="inline-flex items-center gap-2 text-xs font-bold text-teal-700 bg-teal-50 border border-teal-200 rounded-full px-4 py-1.5">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 8.25h3m-3 3h3m-3 3h3m-3-12.75h3"/></svg>
                Celular — Prontuário Digital
              </span>
            </div>
            <!-- Glow -->
            <div class="absolute -z-10" style="inset:-24px; border-radius:999px; filter:blur(50px); opacity:0.45; background:radial-gradient(circle, #5eead4, #22d3ee);"></div>
          </div>

        </div>
      </div>
    </section>

    <!-- COMO FUNCIONA -->
    <section id="como-funciona" class="py-16 sm:py-24" style="background: #f0fdfa">
      <div class="max-w-4xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-14">
          <p class="section-label">Simples assim</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Começa em 3 passos</h2>
          <p class="text-teal-900/50 max-w-md mx-auto">Sem complicação. Em 5 minutos sua conta está criada e funcionando.</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-8 relative">
          <div class="hidden sm:block absolute top-10 left-[18%] right-[18%] h-px" style="background: linear-gradient(to right, #5eead4, #22d3ee, #5eead4)"></div>
          <div v-for="(step, i) in steps" :key="step.title" class="flex flex-col items-center text-center gap-4">
            <div class="relative w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl z-10 border-2 border-white" :style="{ background: step.bg }">
              <svg class="w-8 h-8" :style="{ color: step.color }" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24" v-html="step.svg"></svg>
              <span class="absolute -top-2 -right-2 w-7 h-7 rounded-full text-xs font-black flex items-center justify-center text-white shadow-md" style="background: linear-gradient(135deg, #2dd4bf, #0891b2)">{{ i + 1 }}</span>
            </div>
            <h3 class="text-base font-black" style="color: #0e7490">{{ step.title }}</h3>
            <p class="text-sm text-teal-900/55 leading-relaxed">{{ step.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- DEPOIMENTOS -->
    <section id="depoimentos" class="py-16 sm:py-24 relative overflow-hidden" style="background: linear-gradient(135deg, #ecfeff 0%, #ccfbf1 50%, #f0fdfa 100%)">
      <div class="absolute top-8 left-8 opacity-10 pointer-events-none select-none"><svg width="64" height="64" fill="none" stroke="#2dd4bf" stroke-width="1.2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z"/></svg></div>
      <div class="absolute bottom-8 right-8 opacity-10 pointer-events-none select-none"><svg width="64" height="64" fill="none" stroke="#22d3ee" stroke-width="1.2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"/></svg></div>
      <div class="relative max-w-6xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-12">
          <p class="section-label">Depoimentos</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Eles já transformaram suas clínicas</h2>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          <div v-for="review in reviews" :key="review.name"
            class="relative p-6 rounded-3xl bg-white border border-teal-100 shadow-sm hover:shadow-lg hover:shadow-teal-100 hover:border-teal-200 transition-all duration-300 flex flex-col gap-4 overflow-hidden">
            <span class="absolute top-3 right-5 leading-none text-teal-100 pointer-events-none select-none" style="font-size: 5rem; font-family: Georgia, serif; line-height: 1">“</span>
            <div class="flex gap-1">
              <svg v-for="s in 5" :key="s" class="w-4 h-4 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
            </div>
            <p class="text-sm text-teal-900/65 leading-relaxed flex-1 italic">"{{ review.text }}"</p>
            <div class="flex items-center gap-3 pt-3 border-t border-teal-50">
              <div class="w-10 h-10 rounded-full flex items-center justify-center text-sm font-black text-white shadow-md shrink-0" :style="{ background: review.avatarBg }">{{ review.name[0] }}</div>
              <div>
                <p class="text-sm font-black" style="color: #0e7490">{{ review.name }}</p>
                <p class="text-xs text-teal-900/40">{{ review.role }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- PLANOS -->
    <section id="precos" class="py-16 sm:py-24" style="background: #f0fdfa">
      <div class="max-w-5xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-12">
          <p class="section-label">Planos</p>
          <h2 class="text-4xl sm:text-5xl font-black mb-3" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Investimento que cabe no seu orçamento</h2>
          <p class="text-teal-900/50 max-w-sm mx-auto">Todas as funcionalidades em todos os planos. Cancele quando quiser.</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 items-start">
          <div v-for="plan in plans" :key="plan.name"
            class="relative rounded-3xl p-7 flex flex-col gap-5 transition-all duration-300"
            :class="plan.featured ? 'border-2 border-teal-300 shadow-2xl shadow-teal-200/60 sm:scale-[1.04]' : 'border border-teal-100 bg-white hover:shadow-lg hover:shadow-teal-100 hover:border-teal-200'"
            :style="plan.featured ? 'background: linear-gradient(135deg, #ecfeff, #ccfbf1)' : ''">
            <div v-if="plan.featured"
              class="absolute -top-3.5 left-1/2 -translate-x-1/2 px-5 py-1.5 rounded-full text-[11px] font-black text-white shadow-lg whitespace-nowrap"
              style="background: linear-gradient(135deg, #2dd4bf, #0891b2)">
              MAIS POPULAR
            </div>
            <div>
              <h3 class="text-xl font-black mb-1" style="color: #0e7490">{{ plan.name }}</h3>
              <p class="text-xs text-teal-900/40">{{ plan.desc }}</p>
            </div>
            <div class="flex items-end gap-1">
              <span class="text-5xl font-black" style="color: #0f766e">{{ plan.price }}</span>
              <span v-if="plan.period" class="text-sm text-teal-900/40 mb-1.5">{{ plan.period }}</span>
            </div>
            <ul class="flex flex-col gap-3 flex-1">
              <li v-for="item in plan.items" :key="item" class="flex items-start gap-2.5 text-sm text-teal-900/65">
                <svg class="mt-0.5 shrink-0 w-4 h-4 text-teal-400" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/></svg>
                {{ item }}
              </li>
            </ul>
            <a :href="plan.url"
              :target="plan.url.startsWith('http') ? '_blank' : undefined"
              :rel="plan.url.startsWith('http') ? 'noopener noreferrer' : undefined"
              class="mt-2 w-full py-3.5 rounded-full text-sm font-black text-center transition-all duration-200 hover:scale-[1.02] block"
              :class="plan.featured ? 'text-white shadow-lg hover:shadow-teal-300/60' : 'border-2 border-teal-200 text-teal-500 hover:border-teal-400 hover:bg-teal-50'"
              :style="plan.featured ? 'background: linear-gradient(135deg, #2dd4bf, #0891b2)' : ''">
              {{ plan.cta }}
            </a>
          </div>
        </div>
        <p class="text-center text-xs text-teal-900/35 mt-8">✅ 7 dias grátis em todos os planos · Sem cartão de crédito · Sem fidelidade · Cancele quando quiser</p>
      </div>
    </section>

    <!-- FAQ -->
    <section class="py-16 sm:py-24" style="background: linear-gradient(180deg, #ecfeff, #f0fdfa)">
      <div class="max-w-2xl mx-auto px-5 sm:px-10">
        <div class="text-center mb-10">
          <p class="section-label">Dúvidas</p>
          <h2 class="text-4xl sm:text-5xl font-black" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Perguntas frequentes</h2>
        </div>
        <div class="flex flex-col gap-3">
          <div v-for="(faq, i) in faqs" :key="i"
            class="rounded-2xl border border-teal-100 bg-white overflow-hidden shadow-sm transition-shadow hover:shadow-md">
            <button class="w-full flex items-center justify-between gap-4 px-6 py-4 text-left" @click="toggleFaq(i)">
              <span class="text-sm font-bold" style="color: #0e7490">{{ faq.q }}</span>
              <svg class="w-4 h-4 text-teal-400 shrink-0 transition-transform duration-200" :class="faqOpen === i ? 'rotate-180' : ''" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/>
              </svg>
            </button>
            <div v-if="faqOpen === i" class="px-6 pb-5">
              <p class="text-sm text-teal-900/55 leading-relaxed">{{ faq.a }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA FINAL -->
    <section class="py-20 sm:py-28 relative overflow-hidden" style="background: linear-gradient(135deg, #f0fdfa 0%, #ccfbf1 50%, #ecfeff 100%)">
      <div class="absolute inset-0 pointer-events-none overflow-hidden">
        <div class="absolute -top-20 -left-20 w-80 h-80 rounded-full opacity-30 blur-[80px]" style="background: radial-gradient(circle, #5eead4, transparent)"></div>
        <div class="absolute -bottom-20 -right-20 w-80 h-80 rounded-full opacity-30 blur-[80px]" style="background: radial-gradient(circle, #22d3ee, transparent)"></div>
      </div>
      <div class="relative max-w-2xl mx-auto px-5 sm:px-10 text-center">
        <div class="w-16 h-16 rounded-3xl mx-auto mb-6 flex items-center justify-center shadow-xl shadow-teal-200 border-2 border-teal-100" style="background: linear-gradient(135deg, #ccfbf1, #ecfeff)">
          <svg class="w-7 h-7 text-teal-400" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"/></svg>
        </div>
        <h2 class="text-3xl sm:text-5xl font-black mb-5 leading-tight" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">
          Seus pacientes merecem o melhor. <br class="hidden sm:block">Sua clínica também.
        </h2>
        <p class="text-teal-900/55 text-lg mb-10 max-w-md mx-auto leading-relaxed">
          Experimente 7 dias grátis. Sem cartão, sem burocracia. Se não mudar sua rotina, cancele com um clique.
        </p>
        <a href="/login?tab=register"
          class="inline-flex items-center gap-3 text-lg font-black px-12 py-5 rounded-full text-white shadow-2xl shadow-teal-300/50 transition-all duration-200 hover:scale-105 hover:shadow-teal-400/60"
          style="background: linear-gradient(135deg, #2dd4bf, #0891b2)">
          Começar agora
        </a>
        <p class="text-xs text-teal-900/35 mt-5">Sem cartão de crédito. Pronto em 5 minutos. Suporte via WhatsApp.</p>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="border-t border-teal-100 py-8 bg-white">
      <div class="max-w-6xl mx-auto px-5 sm:px-10 flex flex-col sm:flex-row items-center justify-between gap-4">
        <div class="flex items-center gap-2">
          <div class="w-7 h-7 rounded-lg flex items-center justify-center" style="background: linear-gradient(135deg, #2dd4bf, #0891b2)">
            <svg class="w-3.5 h-3.5 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z"/>
            </svg>
          </div>
          <span class="text-sm font-black" style="background: linear-gradient(135deg, #0d9488, #0891b2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text">Clínica Vet</span>
        </div>
        <p class="text-xs text-teal-900/35 text-center">2026 Clínica Vet. Feito com cuidado para profissionais veterinários.</p>
        <a href="/login" class="text-xs font-semibold text-teal-400 hover:text-teal-600 transition-colors">Acessar plataforma</a>
      </div>
    </footer>

  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

definePageMeta({ layout: false })

useHead({
  script: [
    {
      innerHTML: `!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');fbq('init','1197167722370276');fbq('track','PageView');`,
      type: 'text/javascript',
    },
  ],
  noscript: [
    {
      innerHTML: '<img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=1197167722370276&ev=PageView&noscript=1" />',
    },
  ],
})

const scrolled = ref(false)
const mobileOpen = ref(false)
function onScroll() { scrolled.value = window.scrollY > 30 }
onMounted(() => window.addEventListener('scroll', onScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', onScroll))

const faqOpen = ref<number | null>(null)
function toggleFaq(i: number) { faqOpen.value = faqOpen.value === i ? null : i }

const navLinks = [
  { href: '#funcionalidades', label: 'Funcionalidades' },
  { href: '#como-funciona',   label: 'Como funciona' },
  { href: '#depoimentos',     label: 'Depoimentos' },
  { href: '#precos',          label: 'Planos' },
]

const avatarColors   = ['linear-gradient(135deg,#2dd4bf,#0891b2)', 'linear-gradient(135deg,#22d3ee,#0e7490)', 'linear-gradient(135deg,#38bdf8,#0284c7)', 'linear-gradient(135deg,#2dd4bf,#22d3ee)']
const avatarInitials = ['C', 'F', 'B', 'J']

const dores = [
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25"/>', titulo: 'Dois pacientes no mesmo horário', desc: 'Conflito de agenda e constrangimento na recepção. O tutor vai embora frustrado e não volta.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/>', titulo: 'Vacina vencida sem aviso', desc: 'O tutor liga perguntando sobre a dose e você não sabe responder. Credibilidade perdida em segundos.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108"/>', titulo: 'Prontuário de papel sumiu', desc: 'Na hora da cirurgia, o histórico do animal não está em lugar nenhum. Pânico e retrabalho.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75"/>', titulo: 'Caixa no papel, números errados', desc: 'No fim do mês você não sabe se teve lucro ou prejuízo. Impossivel planejar ou crescer.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12"/>', titulo: 'Medicamento acabou na hora errada', desc: 'Paciente em crise e a vacina acabou há 3 dias. O estoque era controlado “de memória”.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72"/>', titulo: 'Equipe sem saber o que fazer', desc: 'Cada funcionário faz do jeito que quer. Sem tarefa definida, sem responsabilidade, sem padrão.' },
]

const mockAppts = [
  { init: 'R', name: 'Rex (Golden)',   service: 'Consulta Clínica', time: '14h00', color: 'linear-gradient(135deg,#2dd4bf,#0891b2)', accent: 'linear-gradient(90deg,#2dd4bf,#0891b2)', timeBg: '#ccfbf1', timeColor: '#0f766e' },
  { init: 'M', name: 'Mia (Siamesa)',  service: 'Vacinação',       time: '14h45', color: 'linear-gradient(135deg,#22d3ee,#0e7490)', accent: 'linear-gradient(90deg,#22d3ee,#0e7490)', timeBg: '#ecfeff', timeColor: '#0e7490' },
  { init: 'B', name: 'Bob (Bulldog)',  service: 'Banho & Tosa',    time: '15h30', color: 'linear-gradient(135deg,#38bdf8,#0284c7)', accent: 'linear-gradient(90deg,#38bdf8,#0284c7)', timeBg: '#f0fdfa', timeColor: '#be123c' },
]

const mobileFeatures = [
  { title: 'Agenda em tempo real',  desc: 'Visualize e gerencie todas as consultas na palma da mão, sem precisar ligar.',              bg: 'linear-gradient(135deg,#ccfbf1,#ecfeff)', color: '#0d9488', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"/>' },
  { title: 'Caixa no celular',      desc: 'Acompanhe entradas, saídas e saldo do dia diretamente no app sem abrir o computador.',     bg: 'linear-gradient(135deg,#ecfeff,#ede9fe)',   color: '#a855f7', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 00-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 01-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 003 15h-.75"/>' },
  { title: 'Pacientes sempre à mão', desc: 'Histórico completo de cada animal: consultas, vacinas, exames e observações registradas.',   bg: 'linear-gradient(135deg,#ccfbf1,#fee2e2)',   color: '#0284c7', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>' },
]

const tiposNegocio = [
  { label: 'Clínica Veterinária',   color: '#0d9488', bg: 'linear-gradient(135deg,#ccfbf1,#ecfeff)', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"/>' },
  { label: 'Pet Shop',              color: '#a855f7', bg: 'linear-gradient(135deg,#ede9fe,#ecfeff)', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007z"/>' },
  { label: 'Hospital Veterinário',  color: '#0891b2', bg: 'linear-gradient(135deg,#ecfeff,#ccfbf1)', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/>' },
  { label: 'Banho & Tosa',         color: '#f97316', bg: 'linear-gradient(135deg,#fff7ed,#ccfbf1)', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M9.53 16.122a3 3 0 00-5.78 1.128 2.25 2.25 0 01-2.4 2.245 4.5 4.5 0 008.4-2.245c0-.399-.078-.78-.22-1.128zm0 0a15.998 15.998 0 003.388-1.62m-5.043-.025a15.994 15.994 0 011.622-3.395m3.42 3.42a15.995 15.995 0 004.764-4.648l3.876-5.814a1.151 1.151 0 00-1.597-1.597L14.146 6.32a15.996 15.996 0 00-4.649 4.763m3.42 3.42a6.776 6.776 0 00-3.42-3.42"/>' },
  { label: 'Veterinário Autônomo',  color: '#10b981', bg: 'linear-gradient(135deg,#f0fdf4,#ecfeff)', svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>' },
]

const stats = [
  { value: '200+',  label: 'Clínicas ativas' },
  { value: '98%',   label: 'Satisfação' },
  { value: '6h',    label: 'Economizadas por semana' },
  { value: '5 min', label: 'Para configurar' },
]

const steps = [
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"/>',  color: '#0d9488', title: 'Crie sua conta',         bg: 'linear-gradient(135deg,#ccfbf1,#ecfeff)', desc: 'Cadastre sua clínica em menos de 5 minutos. Sem burocracia e sem cartão de crédito.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M10.343 3.94c.09-.542.56-.94 1.11-.94h1.093c.55 0 1.02.398 1.11.94l.149.894c.07.424.384.764.78.93.398.164.855.142 1.205-.108l.737-.527a1.125 1.125 0 011.45.12l.773.774c.39.389.44 1.002.12 1.45l-.527.737c-.25.35-.272.806-.107 1.204.165.397.505.71.93.78l.893.15c.543.09.94.56.94 1.109v1.094c0 .55-.397 1.02-.94 1.11l-.893.149c-.425.07-.765.383-.93.78-.165.398-.143.854.107 1.204l.527.738c.32.447.269 1.06-.12 1.45l-.774.773a1.125 1.125 0 01-1.449.12l-.738-.527c-.35-.25-.806-.272-1.203-.107-.397.165-.71.505-.781.929l-.149.894c-.09.542-.56.94-1.11.94h-1.094c-.55 0-1.019-.398-1.11-.94l-.148-.894c-.071-.424-.384-.764-.781-.93-.398-.164-.854-.142-1.204.108l-.738.527c-.447.32-1.06.269-1.45-.12l-.773-.774a1.125 1.125 0 01-.12-1.45l.527-.737c.25-.35.273-.806.108-1.204-.165-.397-.505-.71-.93-.78l-.894-.15c-.542-.09-.94-.56-.94-1.109v-1.094c0-.55.398-1.02.94-1.11l.894-.149c.424-.07.765-.383.93-.78.165-.398.143-.854-.108-1.204l-.526-.738a1.125 1.125 0 01.12-1.45l.773-.773a1.125 1.125 0 011.45-.12l.737.527c.35.25.807.272 1.204.107.397-.165.71-.505.78-.929l.15-.894z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>',  color: '#a855f7', title: 'Configure sua clínica', bg: 'linear-gradient(135deg,#ede9fe,#ecfeff)', desc: 'Adicione serviços, equipe e personalize as cores com o visual do seu negócio.' },
  { svg: '<path stroke-linecap="round" stroke-linejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z"/>',  color: '#f59e0b', title: 'Comece a usar',         bg: 'linear-gradient(135deg,#ccfbf1,#fff7ed)', desc: 'Agenda, pacientes e finanças organizados. Acesse do celular ou computador a qualquer hora.' },
]

const reviews = [
  { name: 'Dra. Camila Rocha',   role: 'Médica Veterinária CRMV-SP · Clínica própria',       avatarBg: 'linear-gradient(135deg,#2dd4bf,#0891b2)', text: 'Perdi um paciente por vacina vencida sem aviso. Depois do sistema, nunca mais. O histórico do animal fica todo lá, acessivo em 3 segundos.' },
  { name: 'Fernanda Lima',       role: 'Gestora de Pet Shop · 6 funcionários',                avatarBg: 'linear-gradient(135deg,#22d3ee,#0e7490)', text: 'Antes eu usava 3 planilhas diferentes. Hoje é um sistema só: agenda, estoque de remdios e caixa. A equipe adorou e o caos acabou.' },
  { name: 'Dr. Bruno Santos',    role: 'Veterinário Autonômo · Atendimento domiciliar',       avatarBg: 'linear-gradient(135deg,#38bdf8,#0284c7)', text: 'Trabalho sozinho e precisava de algo simples. Configuro o celular antes de entrar na casa do cliente e o prontuário fica salvo.' },
  { name: 'Juliana Melo',        role: 'Proprietária · Clínica e Petshop · Curitiba',         avatarBg: 'linear-gradient(135deg,#2dd4bf,#22d3ee)', text: 'Minha recepcionista tem 50 anos e nunca tinha usado sistema. Aprendeu em 1 dia. A interface é realmente simples.' },
  { name: 'Patricia Alves',      role: 'Veterinária · Banho & Tosa · Porto Alegre',             avatarBg: 'linear-gradient(135deg,#34d399,#0ea5e9)', text: 'O financeiro me salvou. Eu não sabia quanto ganhava por mês de verdade. Agora sei o lucro de cada serviço.' },
  { name: 'Renata Costa',        role: 'Clínica Movel Veterinária · Brasília',                  avatarBg: 'linear-gradient(135deg,#fbbf24,#0284c7)', text: 'Testei VetSmart e PetHub antes. Esse é o único que funciona no celular de verdade. Rápido, bonito e não trava.' },
]

const plans = [
  {
    name: '🐾 Básico', price: 'R$97', period: '/mês', featured: false,
    desc: 'Para quem está começando',
    cta: 'Testar 7 dias grátis',
    url: '/login?tab=register',
    items: [
      'Até 100 tutores/clientes',
      'Até 150 animais cadastrados',
      'Até 3 funcionários',
      'Até 200 agendamentos/mês',
      'Todas as funcionalidades',
      'Suporte por e-mail',
    ],
  },
  {
    name: '🏥 Clínica', price: 'R$197', period: '/mês', featured: true,
    desc: 'Para clínicas em crescimento',
    cta: 'Testar 7 dias grátis',
    url: '/login?tab=register',
    items: [
      'Até 200 tutores/clientes',
      'Até 300 animais cadastrados',
      'Até 10 funcionários',
      'Até 1.000 agendamentos/mês',
      'Todas as funcionalidades',
      'Suporte e-mail + chat + migração',
    ],
  },
  {
    name: '🏆 Rede', price: 'R$347', period: '/mês', featured: false,
    desc: 'Para redes e franquias veterinárias',
    cta: 'Falar com a gente',
    url: 'https://wa.me/5511940527609?text=Quero+assinar+o+plano+Rede+do+VetFlow',
    items: [
      'Tutores e animais ilimitados',
      'Funcionários ilimitados',
      'Agendamentos ilimitados',
      'Todas as funcionalidades',
      'Suporte prioritário via WhatsApp',
      'Onboarding + migração personalizada',
    ],
  },
]

const faqs = [
  { q: 'Minha recepcionista não tem experiência com sistema. Vai funcionar?', a: 'Sim! A interface foi desenhada para ser intuitiva. A maioria das recepcionistas após a configuração aprende a usar o sistema em menos de 1 hora, sem treinamento.' },
  { q: 'O prontuário digital é aceito pelo CFMV?',                           a: 'O sistema armazena todos os dados clínicos exigidos pelo CFMV. Recomendamos consultar a norma do seu estado, mas o prontuário digital é amplamente aceito quando contém as informações obrigatórias.' },
  { q: 'Consigo migrar os dados que já tenho em planilha?',                  a: 'Sim. Nossa equipe de suporte ajuda na migração dos dados principais (clientes, animais e prontuários) sem custo adicional no plano Clínica e Rede.' },
  { q: 'Funciona para mais de uma espécie animal?',                          a: 'Sim! Cães, gatos, pássaros, répteis e exóticos. Cadastre com raça, peso, espécie e observações específicas de cada animal.' },
  { q: 'Preciso instalar alguma coisa?',                                      a: 'Não! 100% online, funciona em qualquer celular ou computador com internet, sem instalação.' },
  { q: 'Posso cancelar quando quiser?',                                       a: 'Sim, sem fidelidade e sem multa. Cancele quando quiser pelo painel ou pelo WhatsApp de suporte. Seus dados ficam disponíveis por 30 dias após o cancelamento.' },
]
</script>

<style scoped>
html { scroll-behavior: smooth; }

/* ── NAV ──────────────────────────────────────────────── */
.nav-bar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 50;
  transition: background .4s, box-shadow .4s, border-color .4s;
}
.nav-bar--scrolled {
  background: rgba(255,255,255,0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 1px 0 #ccfbf1;
  border-bottom: 1px solid #ccfbf1;
}
.nav-inner {
  max-width: 1152px;
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  gap: 0;
}
.nav-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
  flex-shrink: 0;
}
.nav-logo__icon {
  width: 32px; height: 32px; flex-shrink: 0;
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, #2dd4bf, #22d3ee);
  box-shadow: 0 2px 8px rgba(244,114,182,.35);
}
.nav-logo__text {
  font-size: 14px;
  font-weight: 900;
  letter-spacing: -0.02em;
  white-space: nowrap;
  background: linear-gradient(135deg, #0d9488, #0891b2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.nav-links {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 32px;
}
@media (max-width: 767px) { .nav-links { display: none; } }
.nav-link {
  font-size: 14px; font-weight: 500;
  color: rgba(15,70,60,.6);
  text-decoration: none;
  white-space: nowrap;
  transition: color .2s;
}
.nav-link:hover { color: #0d9488; }
.nav-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
  margin-left: auto;
}
@media (max-width: 767px) { .nav-actions { display: none; } }
.nav-btn-ghost {
  display: inline-flex; align-items: center;
  font-size: 14px; font-weight: 600;
  color: #0d9488;
  text-decoration: none;
  padding: 8px 16px;
  border-radius: 9999px;
  white-space: nowrap;
  transition: background .2s;
}
.nav-btn-ghost:hover { background: rgba(252,231,243,.8); }
.nav-btn-primary {
  display: inline-flex; align-items: center;
  font-size: 14px; font-weight: 700;
  color: white;
  text-decoration: none;
  padding: 10px 20px;
  border-radius: 9999px;
  white-space: nowrap;
  background: linear-gradient(135deg, #2dd4bf, #0891b2);
  box-shadow: 0 4px 14px rgba(13,148,136,.35);
  transition: transform .2s, box-shadow .2s;
}
.nav-btn-primary:hover { transform: scale(1.04); box-shadow: 0 6px 20px rgba(13,148,136,.45); }
.nav-hamburger {
  display: none;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
  width: 36px; height: 36px;
  margin-left: auto;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  border-radius: 8px;
  transition: background .2s;
}
.nav-hamburger:hover { background: rgba(252,231,243,.8); }
@media (max-width: 767px) { .nav-hamburger { display: flex; } }
.nav-hamburger__line {
  display: block;
  width: 22px; height: 2px;
  background: #0d9488;
  border-radius: 9999px;
  transition: transform .25s, opacity .25s;
  transform-origin: center;
}
.nav-hamburger__line--top-open { transform: translateY(7px) rotate(45deg); }
.nav-hamburger__line--mid-open { opacity: 0; }
.nav-hamburger__line--bot-open { transform: translateY(-7px) rotate(-45deg); }
.nav-mobile {
  background: rgba(255,255,255,0.97);
  backdrop-filter: blur(20px);
  border-top: 1px solid #ccfbf1;
  padding: 16px 24px 24px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.nav-mobile__link {
  font-size: 15px; font-weight: 600;
  color: rgba(15,70,60,.7);
  text-decoration: none;
  padding: 12px 8px;
  border-radius: 12px;
  transition: background .2s, color .2s;
}
.nav-mobile__link:hover { background: #f0fdfa; color: #0d9488; }
.nav-mobile__actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 12px;
  padding-top: 16px;
  border-top: 1px solid #ccfbf1;
}
.nav-mobile__actions .nav-btn-ghost,
.nav-mobile__actions .nav-btn-primary {
  width: 100%;
  justify-content: center;
  padding: 14px 20px;
  font-size: 15px;
}
/* ────────────────────────────────────────────────────── */

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50%       { transform: translateY(-14px); }
}

.section-label {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.65rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.2em;
  color: #2dd4bf;
  margin-bottom: 0.75rem;
}
.section-label::before {
  content: '';
  display: inline-block;
  width: 18px;
  height: 2px;
  border-radius: 9999px;
  background: linear-gradient(90deg, #2dd4bf, #22d3ee);
}
</style>
