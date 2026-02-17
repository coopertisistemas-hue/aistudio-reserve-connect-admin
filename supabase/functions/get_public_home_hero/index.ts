import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders, createErrorResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

// Cache duration in seconds (5 minutes)
const CACHE_MAX_AGE = 300

// Fallback hero content in Portuguese
const FALLBACK_HERO = {
  title: 'Encontre sua hospedagem em Urubici',
  subtitle: 'Reserve com segurança e praticidade. As melhores pousadas e casas de temporada em um só lugar.',
  cta_label: 'Buscar Agora',
  cta_link: '/search',
  background_image_url: ''
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get tenant_id and language from request
    const body = await req.json().catch(() => ({}))
    const tenantId = body.tenant_id || '00000000-0000-0000-0000-000000000000'
    const lang = body.lang || 'pt'
    
    // Get hero configuration from site settings
    const { data: siteSettings, error } = await supabaseAdmin
      .from('site_settings')
      .select('site_name')
      .eq('tenant_id', tenantId)
      .single()
    
    // Build hero content
    let heroContent = { ...FALLBACK_HERO }
    
    // If site settings exist, customize the hero
    if (siteSettings && !error) {
      const siteName = siteSettings.site_name || 'Reserve Connect'
      
      // Dynamic title based on site name
      if (siteName.toLowerCase().includes('urubici')) {
        heroContent.title = `Encontre sua hospedagem em Urubici`
        heroContent.subtitle = `As melhores pousadas e casas de temporada em Urubici, SC. Reserve com segurança.`
      } else {
        heroContent.title = `Bem-vindo ao ${siteName}`
        heroContent.subtitle = `Encontre as melhores hospedagens. Reserve com segurança e praticidade.`
      }
    }
    
    // Language-specific fallbacks
    if (lang === 'en') {
      heroContent = {
        ...heroContent,
        title: 'Find your stay in Urubici',
        subtitle: 'Book with security and convenience. The best guesthouses and vacation rentals in one place.',
        cta_label: 'Search Now'
      }
    } else if (lang === 'es') {
      heroContent = {
        ...heroContent,
        title: 'Encuentra tu alojamiento en Urubici',
        subtitle: 'Reserva con seguridad y practicidad. Las mejores posadas y casas de temporada en un solo lugar.',
        cta_label: 'Buscar Ahora'
      }
    }

    // Return with cache headers
    return new Response(
      JSON.stringify({
        success: true,
        data: heroContent
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Cache-Control': `public, max-age=${CACHE_MAX_AGE}`,
          'CDN-Cache-Control': `public, max-age=${CACHE_MAX_AGE}`
        }
      }
    )
  } catch (error) {
    console.error('get_public_home_hero error:', error.message)
    // Return fallback even on error
    return new Response(
      JSON.stringify({
        success: true,
        data: FALLBACK_HERO
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Cache-Control': `public, max-age=${CACHE_MAX_AGE}`
        }
      }
    )
  }
})
