import { useEffect, useState } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { postJson } from '../../lib/apiClient'
import { formatCurrency } from '../../lib/utils'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'

type PropertyDetail = {
  id: string
  slug: string
  name: string
  description?: string
  type: string
  images: string[]
  amenities: string[]
  rating?: number
  review_count?: number
  room_types: Array<Unit>
  availability?: {
    check_in: string
    check_out: string
    nights: number
    units: Array<Unit>
  }
}

type Unit = {
  id: string
  name: string
  description?: string
  max_occupancy: number
  images?: string[]
  nightly_price?: number | null
  total_price?: number | null
}

type DetailResponse = {
  success: boolean
  data: PropertyDetail
}

export default function PropertyDetailPage() {
  const { slug } = useParams()
  const [searchParams] = useSearchParams()
  const { t } = useTranslation()
  const [property, setProperty] = useState<PropertyDetail | null>(null)
  const [loading, setLoading] = useState(false)
  const checkIn = searchParams.get('check_in') || ''
  const checkOut = searchParams.get('check_out') || ''

  useEffect(() => {
    if (!slug) return
    let active = true
    const load = async () => {
      setLoading(true)
      try {
        const response = await postJson<DetailResponse>('get_property_detail', {
          slug,
          check_in: checkIn || undefined,
          check_out: checkOut || undefined,
        })
        if (active) setProperty(response.data)
      } catch (error) {
        if (active) setProperty(null)
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [slug, checkIn, checkOut])

  if (loading) {
    return (
      <main className="container section">
        <LoadingState />
      </main>
    )
  }

  if (!property) {
    return (
      <main className="container section">
        <EmptyState message={t('common.error')} />
      </main>
    )
  }

  const heroImage = property.images?.[0]

  return (
    <main className="container" style={{ paddingBottom: '4rem' }}>
      <section className="section">
        <Link to="/search" className="button-secondary">{t('common.back')}</Link>
        <div className="card" style={{ marginTop: '1.5rem', overflow: 'hidden' }}>
          <div style={{ height: '260px', background: heroImage ? `url(${heroImage}) center/cover` : 'var(--sand-200)' }} />
          <div style={{ padding: '1.5rem' }}>
            <h1 className="headline">{property.name}</h1>
            <p className="subhead">{property.description}</p>
            <div style={{ display: 'flex', gap: '0.6rem', marginTop: '1rem', flexWrap: 'wrap' }}>
              {(property.amenities || []).slice(0, 8).map((amenity) => (
                <span key={amenity} className="chip">{amenity}</span>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="section">
        <h2 className="headline">{t('property.rooms')}</h2>
        <div className="grid grid-2" style={{ marginTop: '1.5rem' }}>
          {(property.availability?.units || property.room_types || []).map((unit) => (
            <div key={unit.id} className="card" style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem' }}>
              <strong>{unit.name}</strong>
              <span className="muted">{unit.max_occupancy} {t('booking.guestsLabel')}</span>
              {unit.nightly_price && (
                <div>
                  <strong>{formatCurrency(unit.nightly_price)}</strong> {t('property.perNight')}
                </div>
              )}
              {unit.total_price && (
                <div className="muted">{t('property.total')}: {formatCurrency(unit.total_price)}</div>
              )}
              <Link
                to={`/book/${property.slug}?unit_id=${unit.id}&check_in=${checkIn}&check_out=${checkOut}`}
                className="button-primary"
                style={{ textAlign: 'center' }}
              >
                {t('property.selectRoom')}
              </Link>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}
