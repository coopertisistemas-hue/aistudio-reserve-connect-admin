import { useTranslation } from 'react-i18next'

type Props = {
  checkIn: string
  checkOut: string
  adults: number
  children: number
  onChange: (field: string, value: string | number) => void
  onSubmit: () => void
  compact?: boolean
}

export default function SearchForm({ checkIn, checkOut, adults, children, onChange, onSubmit, compact }: Props) {
  const { t } = useTranslation()

  return (
    <div className="card" style={{ padding: compact ? '1rem' : '1.6rem' }}>
      <div className="grid grid-2" style={{ alignItems: 'end' }}>
        <div>
          <label className="muted">{t('common.dates')}</label>
          <div style={{ display: 'flex', gap: '0.6rem', marginTop: '0.5rem' }}>
            <input
              type="date"
              className="input"
              value={checkIn}
              onChange={(event) => onChange('checkIn', event.target.value)}
            />
            <input
              type="date"
              className="input"
              value={checkOut}
              onChange={(event) => onChange('checkOut', event.target.value)}
            />
          </div>
        </div>
        <div>
          <label className="muted">{t('common.guests')}</label>
          <div style={{ display: 'flex', gap: '0.6rem', marginTop: '0.5rem' }}>
            <input
              type="number"
              min={1}
              className="input"
              value={adults}
              onChange={(event) => onChange('adults', Number(event.target.value))}
              placeholder={t('common.adults')}
            />
            <input
              type="number"
              min={0}
              className="input"
              value={children}
              onChange={(event) => onChange('children', Number(event.target.value))}
              placeholder={t('common.children')}
            />
          </div>
        </div>
      </div>
      <div style={{ marginTop: '1.4rem', textAlign: 'right' }}>
        <button className="button-primary" onClick={onSubmit}>
          {t('common.search')}
        </button>
      </div>
    </div>
  )
}
