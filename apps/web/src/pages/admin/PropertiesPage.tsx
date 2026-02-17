import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Property = {
  id: string
  slug: string
  name: string
  city: string
  status: string
}

type Response = {
  success: boolean
  data: Property[]
}

export default function PropertiesPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Property[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      try {
        const response = await postJson<Response>('admin_list_properties', {}, { auth: true })
        if (active) setData(response.data)
      } catch (error) {
        if (active) setData([])
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [])

  return (
    <section>
      <h1 className="headline">{t('admin.properties')}</h1>
      {loading && <LoadingState />}
      {!loading && data.length === 0 && <EmptyState message={t('admin.emptyProperties')} />}
      {data.length > 0 && (
        <div className="grid" style={{ marginTop: '1.5rem' }}>
          {data.map((property) => (
            <div key={property.id} className="card" style={{ display: 'flex', justifyContent: 'space-between' }}>
              <div>
                <strong>{property.name}</strong>
                <div className="muted">{property.city}</div>
              </div>
              <span className="chip">{property.status}</span>
            </div>
          ))}
        </div>
      )}
    </section>
  )
}
