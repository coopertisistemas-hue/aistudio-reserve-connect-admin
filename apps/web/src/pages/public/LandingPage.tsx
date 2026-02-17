import { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import SearchForm from '../../components/SearchForm'
import PropertyCard from '../../components/PropertyCard'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { getSessionId } from '../../lib/utils'

type SearchResponse = {
  success: boolean
  data: {
    properties: Array<{
      id: string
      slug: string
      name: string
      city: string
      state: string
      rating?: number
      images?: string[]
      amenities?: string[]
      price_per_night: number
    }>
  }
}

export default function LandingPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const today = new Date()
  const checkInDefault = new Date(today.getTime() + 24 * 60 * 60 * 1000)
  const checkOutDefault = new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000)

  const [checkIn, setCheckIn] = useState(checkInDefault.toISOString().split('T')[0])
  const [checkOut, setCheckOut] = useState(checkOutDefault.toISOString().split('T')[0])
  const [adults, setAdults] = useState(2)
  const [children, setChildren] = useState(0)
  const [featured, setFeatured] = useState<SearchResponse['data']['properties']>([])
  const [loading, setLoading] = useState(false)
  const cityCode = import.meta.env.VITE_DEFAULT_CITY_CODE || 'URB'

  const heroBackground = useMemo(
    () => ({
      background: 'linear-gradient(135deg, rgba(63,90,77,0.9), rgba(176,102,43,0.85))',
      borderRadius: '28px',
      color: '#fff',
      padding: '3rem 2.5rem',
      boxShadow: 'var(--shadow-soft)',
    }),
    []
  )

  useEffect(() => {
    let active = true
    const loadFeatured = async () => {
      setLoading(true)
      try {
        const response = await postJson<SearchResponse>('search_availability', {
          city_code: cityCode,
          check_in: checkIn,
          check_out: checkOut,
          guests_adults: adults,
          guests_children: children,
          page: 1,
          limit: 3,
        }, { sessionId: getSessionId() })
        if (active) {
          setFeatured(response.data.properties ?? [])
        }
      } catch (error) {
        if (active) {
          setFeatured([])
        }
      } finally {
        if (active) {
          setLoading(false)
        }
      }
    }
    loadFeatured()
    return () => {
      active = false
    }
  }, [checkIn, checkOut, adults, children, cityCode])

  return (
    <main className="container" style={{ paddingBottom: '4rem' }}>
      <section className="section" style={heroBackground}>
        <div style={{ maxWidth: '520px' }}>
          <h1 className="headline" style={{ color: '#fff' }}>{t('landing.heroTitle')}</h1>
          <p style={{ marginTop: '1rem', color: 'rgba(255,255,255,0.8)' }}>{t('landing.heroSubtitle')}</p>
          <button
            className="button-primary"
            style={{ marginTop: '1.6rem', background: '#fff', color: 'var(--ink-900)' }}
            onClick={() => navigate('/search')}
          >
            {t('landing.heroCta')}
          </button>
        </div>
        <div style={{ marginTop: '2rem' }}>
          <SearchForm
            checkIn={checkIn}
            checkOut={checkOut}
            adults={adults}
            children={children}
            onChange={(field, value) => {
              if (field === 'checkIn') setCheckIn(String(value))
              if (field === 'checkOut') setCheckOut(String(value))
              if (field === 'adults') setAdults(Number(value))
              if (field === 'children') setChildren(Number(value))
            }}
            onSubmit={() => navigate(`/search?check_in=${checkIn}&check_out=${checkOut}&adults=${adults}&children=${children}`)}
          />
        </div>
      </section>

      <section className="section">
        <div className="grid grid-2">
          <div>
            <h2 className="headline">{t('landing.trustTitle')}</h2>
          </div>
          <div className="grid" style={{ gap: '1rem' }}>
            {(t('landing.trustPoints', { returnObjects: true }) as string[]).map((point) => (
              <div key={point} className="card">{point}</div>
            ))}
          </div>
        </div>
      </section>

      <section className="section">
        <h2 className="headline" style={{ marginBottom: '1.5rem' }}>{t('landing.featuredTitle')}</h2>
        {loading && <LoadingState />}
        {!loading && featured.length === 0 && <EmptyState />}
        {!loading && featured.length > 0 && (
          <div className="grid grid-3">
            {featured.map((property) => (
              <PropertyCard
                key={property.id}
                slug={property.slug}
                detailsUrl={`/p/${property.slug}?check_in=${checkIn}&check_out=${checkOut}&adults=${adults}&children=${children}`}
                name={property.name}
                city={property.city}
                state={property.state}
                rating={property.rating}
                pricePerNight={property.price_per_night}
                image={property.images?.[0]}
                amenities={property.amenities}
              />
            ))}
          </div>
        )}
      </section>
    </main>
  )
}
