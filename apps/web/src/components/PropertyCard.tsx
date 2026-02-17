import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { formatCurrency } from '../lib/utils'

type Props = {
  slug: string
  detailsUrl?: string
  name: string
  city: string
  state: string
  rating?: number | null
  pricePerNight: number
  image?: string
  amenities?: string[]
}

export default function PropertyCard({ slug, detailsUrl, name, city, state, rating, pricePerNight, image, amenities }: Props) {
  const { t } = useTranslation()
  const url = detailsUrl || `/p/${slug}`

  return (
    <div className="card" style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
      <div
        style={{
          height: '180px',
          borderRadius: '16px',
          background: image
            ? `url(${image}) center/cover no-repeat`
            : 'linear-gradient(135deg, #d7a273 0%, #f2e7db 100%)',
        }}
      />
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.6rem' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <strong>{name}</strong>
          {rating ? <span className="chip">★ {rating.toFixed(1)}</span> : null}
        </div>
        <span className="muted">{city}, {state}</span>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.4rem' }}>
          {(amenities || []).slice(0, 3).map((amenity) => (
            <span key={amenity} className="chip">{amenity}</span>
          ))}
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <strong>{formatCurrency(pricePerNight)}</strong>
            <span className="muted"> / {t('property.perNight')}</span>
          </div>
          <Link to={url} className="button-secondary">
            {t('common.viewDetails')}
          </Link>
        </div>
      </div>
    </div>
  )
}
