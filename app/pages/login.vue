<template>
  <div class="min-h-screen relative overflow-hidden font-sans antialiased" style="background: #f0fdfb; color: #0f2d28">

    <!-- Blobs de fundo -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden">
      <div class="absolute -top-32 -left-32 w-[600px] h-[600px] rounded-full opacity-20 blur-[100px]" style="background: radial-gradient(circle, #99f6e4, transparent 70%)"></div>
      <div class="absolute -bottom-40 -right-40 w-[700px] h-[700px] rounded-full opacity-15 blur-[120px]" style="background: radial-gradient(circle, #a7f3d0, transparent 70%)"></div>
      <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] rounded-full opacity-10 blur-[80px]" style="background: radial-gradient(circle, #ccfbf1, transparent 70%)"></div>
      <!-- Partículas flutuantes -->
      <div class="particle" style="top:8%;right:12%;width:14px;height:14px;background:#5eead4;animation-duration:4s"></div>
      <div class="particle" style="top:18%;right:30%;width:9px;height:9px;background:#34d399;animation-duration:5s;animation-delay:.7s"></div>
      <div class="particle" style="top:55%;left:8%;width:11px;height:11px;background:#6ee7b7;animation-duration:4.5s;animation-delay:1.3s"></div>
      <div class="particle" style="bottom:20%;left:22%;width:8px;height:8px;background:#2dd4bf;animation-duration:3.5s;animation-delay:.4s"></div>
      <div class="particle" style="bottom:35%;right:18%;width:10px;height:10px;background:#67e8f9;animation-duration:4.2s;animation-delay:1s"></div>
      <div class="particle" style="top:40%;left:40%;width:6px;height:6px;background:#a7f3d0;animation-duration:6s;animation-delay:.2s"></div>
    </div>

    <!-- ═══════════════ INTRO HERO ═══════════════ -->
    <Transition name="intro">
      <div v-if="showIntro" class="relative z-10 flex flex-col items-center justify-center min-h-screen px-6 py-16 text-center">

        <!-- Badge -->
        <div class="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-teal-50 border border-teal-200 mb-8 shadow-sm intro-badge">
          <svg class="w-3.5 h-3.5 text-teal-500 shrink-0" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C10.34 2 9 3.34 9 5s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3zM5.5 6C4.12 6 3 7.12 3 8.5S4.12 11 5.5 11 8 9.88 8 8.5 6.88 6 5.5 6zm13 0C17.12 6 16 7.12 16 8.5S17.12 11 18.5 11 21 9.88 21 8.5 19.88 6 18.5 6zM12 10c-3.5 0-7 3-7 6.5 0 2.5 3 4.5 7 4.5s7-2 7-4.5c0-3.5-3.5-6.5-7-6.5z"/>
          </svg>
          <span class="text-xs font-bold text-teal-600 tracking-wider uppercase">Gestão completa para clínicas veterinárias</span>
        </div>

        <!-- Ícone central -->
        <div class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-xl mb-8 intro-icon" style="background: linear-gradient(135deg, #0d9488, #0891b2)">
          <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="1.6" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"/>
          </svg>
        </div>

        <!-- Headline -->
        <h1 class="font-black tracking-tight mb-5 intro-headline" style="line-height:1.08">
          <span class="block" style="font-size:clamp(2rem,5.5vw,3.8rem);background:linear-gradient(135deg,#0f766e,#0369a1);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text">
            Menos papelada.
          </span>
          <span class="block mt-1" style="font-size:clamp(2rem,5.5vw,3.8rem);background:linear-gradient(135deg,#0d9488,#0891b2,#059669);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text">
            Mais tempo para cuidar.
          </span>
        </h1>

        <!-- Subheadline -->
        <p class="text-base sm:text-lg max-w-xl mx-auto mb-8 leading-relaxed intro-sub" style="color:rgba(15,60,50,0.6)">
          Crie sua conta grátis e transforme a gestão da sua clínica — da agenda aos prontuários, tudo em um só lugar.
        </p>

        <!-- Benefícios em pills -->
        <div class="flex flex-wrap items-center justify-center gap-3 mb-10 intro-pills">
          <div v-for="b in benefits" :key="b.text" class="flex items-center gap-2 px-4 py-2 rounded-full bg-white border border-teal-100 shadow-sm text-sm font-semibold" style="color:#0f766e">
            <span class="text-base">{{ b.emoji }}</span>
            <span>{{ b.text }}</span>
          </div>
        </div>

        <!-- CTAs -->
        <div class="flex flex-col sm:flex-row items-center justify-center gap-4 mb-12 intro-ctas">
          <button
            class="inline-flex items-center gap-2 text-base font-black px-10 py-4 rounded-full text-white transition-all duration-200 hover:scale-105 active:scale-100 shadow-xl"
            style="background:linear-gradient(135deg,#0d9488,#0891b2);box-shadow:0 8px 28px rgba(13,148,136,0.4)"
            @click="goTo('register')"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
            Criar minha conta grátis
          </button>
          <button
            class="inline-flex items-center gap-2 text-base font-semibold px-8 py-4 rounded-full border-2 border-teal-200 bg-white hover:bg-teal-50 hover:border-teal-300 transition-all duration-200 shadow-sm"
            style="color:#0d9488"
            @click="goTo('login')"
          >
            Já tenho uma conta
            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"/></svg>
          </button>
        </div>

        <!-- Social proof -->
        <div class="flex flex-wrap items-center justify-center gap-5 text-sm intro-proof" style="color:rgba(15,60,50,0.45)">
          <div class="flex items-center gap-2">
            <div class="flex -space-x-2">
              <div v-for="(c, i) in avatarColors" :key="i" class="w-8 h-8 rounded-full border-2 border-white flex items-center justify-center text-xs font-black text-white" :style="{ background: c }">{{ avatarInitials[i] }}</div>
            </div>
            <span class="font-semibold">+200 clínicas ativas</span>
          </div>
          <span class="text-teal-200 hidden sm:inline">|</span>
          <div class="flex items-center gap-1">
            <svg v-for="s in 5" :key="s" class="w-4 h-4 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
            <span class="font-semibold ml-1" style="color:rgba(15,60,50,0.65)">4.9 de satisfação</span>
          </div>
          <span class="text-teal-200 hidden sm:inline">|</span>
          <div class="flex items-center gap-1.5">
            <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <span>Sem cartão de crédito</span>
          </div>
        </div>

      </div>
    </Transition>

    <!-- ═══════════════ FORMULÁRIO ═══════════════ -->
    <Transition name="form">
      <div v-if="!showIntro" class="relative z-10 flex flex-col items-center justify-center min-h-screen px-4 py-12">

        <!-- Botão voltar -->
        <button
          class="absolute top-5 left-5 flex items-center gap-2 text-sm font-semibold transition-colors"
          style="color:#0d9488"
          @click="showIntro = true"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18"/></svg>
          Voltar
        </button>

        <LoginForm :initial-tab="initialTab" class="relative z-10" />

      </div>
    </Transition>

  </div>
</template>

<script setup lang="ts">
import LoginForm from '~/components/LoginForm.vue'

definePageMeta({ layout: false })

const route = useRoute()
const showIntro = ref(true)
const initialTab = ref<'login' | 'register'>('register')

function goTo(tab: 'login' | 'register') {
  initialTab.value = tab
  showIntro.value = false
}

// Se vier da landing com ?tab=register ou ?tab=login, pula o intro
onMounted(() => {
  const tab = route.query.tab as string | undefined
  if (tab === 'register' || tab === 'login') {
    goTo(tab)
  }
})

const benefits = [
  { emoji: '📅', text: 'Agendamento online' },
  { emoji: '📋', text: 'Prontuários digitais' },
  { emoji: '🐾', text: 'Cadastro de pacientes' },
  { emoji: '💊', text: 'Controle de estoque' },
  { emoji: '💰', text: 'Gestão financeira' },
]

const avatarColors = ['#0d9488', '#0891b2', '#059669', '#0284c7']
const avatarInitials = ['A', 'M', 'J', 'K']
</script>

<style scoped>
.particle {
  position: absolute;
  border-radius: 50%;
  opacity: 0.45;
  animation: float linear infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) scale(1); }
  50%       { transform: translateY(-14px) scale(1.1); }
}

.intro-badge   { animation: fadeUp .55s ease both; }
.intro-icon    { animation: fadeUp .6s .08s ease both; }
.intro-headline{ animation: fadeUp .65s .15s ease both; }
.intro-sub     { animation: fadeUp .65s .22s ease both; }
.intro-pills   { animation: fadeUp .65s .30s ease both; }
.intro-ctas    { animation: fadeUp .65s .38s ease both; }
.intro-proof   { animation: fadeUp .65s .46s ease both; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(22px); }
  to   { opacity: 1; transform: translateY(0); }
}

.intro-leave-active { transition: all .45s cubic-bezier(.4,0,.2,1); }
.intro-leave-to     { opacity: 0; transform: translateY(-30px); }
.intro-enter-active { transition: all .45s cubic-bezier(.4,0,.2,1); }
.intro-enter-from   { opacity: 0; transform: translateY(-30px); }

.form-enter-active { transition: all .5s cubic-bezier(.4,0,.2,1) .1s; }
.form-enter-from   { opacity: 0; transform: translateY(30px); }
.form-leave-active { transition: all .35s cubic-bezier(.4,0,.2,1); }
.form-leave-to     { opacity: 0; transform: translateY(30px); }
</style>
