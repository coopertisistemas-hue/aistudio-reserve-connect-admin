import { useEffect, useState, useCallback, useRef } from 'react'
import { postJson } from '../lib/apiClient'

// Cache duration: 5 minutes
const CACHE_DURATION = 5 * 60 * 1000

interface SiteSettings {
  site_name: string
  primary_cta_label: string
  primary_cta_link: string
  contact_email: string
  contact_phone: string
  whatsapp: string
  meta_title: string
  meta_description: string
}

interface SocialLink {
  platform: string
  url: string
  active: boolean
}

interface HeroContent {
  title: string
  subtitle: string
  cta_label: string
  cta_link: string
  background_image_url: string
}

interface CacheEntry<T> {
  data: T
  timestamp: number
}

// Global cache for site settings
const settingsCache: { current: CacheEntry<SiteSettings> | null } = { current: null }
const socialLinksCache: { current: CacheEntry<SocialLink[]> | null } = { current: null }
const heroCache: { current: CacheEntry<HeroContent> | null } = { current: null }

export function useSiteSettings() {
  const [settings, setSettings] = useState<SiteSettings | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const fetchedRef = useRef(false)

  const fetchSettings = useCallback(async (forceRefresh = false) => {
    // Check cache first
    if (!forceRefresh && settingsCache.current) {
      const age = Date.now() - settingsCache.current.timestamp
      if (age < CACHE_DURATION) {
        setSettings(settingsCache.current.data)
        setLoading(false)
        return
      }
    }

    setLoading(true)
    setError(null)

    try {
      const response = await postJson<{ success: boolean; data: SiteSettings }>(
        'get_public_site_settings',
        { tenant_id: '00000000-0000-0000-0000-000000000000' }
      )

      if (response.success) {
        settingsCache.current = {
          data: response.data,
          timestamp: Date.now()
        }
        setSettings(response.data)
      }
    } catch (err: any) {
      setError(err.message)
      // Use fallback
      setSettings({
        site_name: 'Reserve Connect',
        primary_cta_label: '',
        primary_cta_link: '/search',
        contact_email: '',
        contact_phone: '',
        whatsapp: '',
        meta_title: '',
        meta_description: ''
      })
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    if (!fetchedRef.current) {
      fetchedRef.current = true
      fetchSettings()
    }
  }, [fetchSettings])

  const refresh = useCallback(() => {
    settingsCache.current = null
    return fetchSettings(true)
  }, [fetchSettings])

  return { settings, loading, error, refresh }
}

export function useSocialLinks() {
  const [links, setLinks] = useState<SocialLink[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const fetchedRef = useRef(false)

  const fetchLinks = useCallback(async (forceRefresh = false) => {
    // Check cache first
    if (!forceRefresh && socialLinksCache.current) {
      const age = Date.now() - socialLinksCache.current.timestamp
      if (age < CACHE_DURATION) {
        setLinks(socialLinksCache.current.data)
        setLoading(false)
        return
      }
    }

    setLoading(true)
    setError(null)

    try {
      const response = await postJson<{ success: boolean; data: SocialLink[] }>(
        'get_public_social_links',
        { tenant_id: '00000000-0000-0000-0000-000000000000' }
      )

      if (response.success) {
        socialLinksCache.current = {
          data: response.data,
          timestamp: Date.now()
        }
        setLinks(response.data)
      }
    } catch (err: any) {
      setError(err.message)
      setLinks([])
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    if (!fetchedRef.current) {
      fetchedRef.current = true
      fetchLinks()
    }
  }, [fetchLinks])

  const refresh = useCallback(() => {
    socialLinksCache.current = null
    return fetchLinks(true)
  }, [fetchLinks])

  return { links, loading, error, refresh }
}

export function useHeroContent(lang: string = 'pt') {
  const [hero, setHero] = useState<HeroContent | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const fetchedRef = useRef(false)
  const prevLangRef = useRef(lang)

  const fetchHero = useCallback(async (forceRefresh = false) => {
    // Check cache first (per language)
    if (!forceRefresh && heroCache.current && prevLangRef.current === lang) {
      const age = Date.now() - heroCache.current.timestamp
      if (age < CACHE_DURATION) {
        setHero(heroCache.current.data)
        setLoading(false)
        return
      }
    }

    setLoading(true)
    setError(null)

    try {
      const response = await postJson<{ success: boolean; data: HeroContent }>(
        'get_public_home_hero',
        { 
          tenant_id: '00000000-0000-0000-0000-000000000000',
          lang 
        }
      )

      if (response.success) {
        heroCache.current = {
          data: response.data,
          timestamp: Date.now()
        }
        setHero(response.data)
        prevLangRef.current = lang
      }
    } catch (err: any) {
      setError(err.message)
      // Fallback
      setHero({
        title: lang === 'en' ? 'Find your stay' : lang === 'es' ? 'Encuentra tu alojamiento' : 'Encontre sua hospedagem em Urubici',
        subtitle: '',
        cta_label: lang === 'en' ? 'Search Now' : lang === 'es' ? 'Buscar Ahora' : 'Buscar Agora',
        cta_link: '/search',
        background_image_url: ''
      })
    } finally {
      setLoading(false)
    }
  }, [lang])

  useEffect(() => {
    if (!fetchedRef.current || prevLangRef.current !== lang) {
      fetchedRef.current = true
      fetchHero()
    }
  }, [fetchHero, lang])

  const refresh = useCallback(() => {
    heroCache.current = null
    return fetchHero(true)
  }, [fetchHero])

  return { hero, loading, error, refresh }
}
