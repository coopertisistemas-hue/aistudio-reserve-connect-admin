import { useEffect, useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Property = {
  id: string
  slug: string
  name: string
  city: string
  state: string
  status: 'active' | 'inactive' | 'draft'
  type?: string
  rating?: number
}

type Response = {
  success: boolean
  data: Property[]
}

export default function PropertiesPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Property[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState<string>('all')

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<Response>('admin_list_properties', {}, { auth: true })
        if (active) setData(response.data)
      } catch (err: any) {
        if (active) {
          setData([])
          setError(err.message || 'Failed to load properties')
        }
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [])

  const filteredProperties = useMemo(() => {
    return data.filter((property) => {
      const matchesSearch = 
        searchTerm === '' || 
        property.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        property.slug.toLowerCase().includes(searchTerm.toLowerCase()) ||
        property.city.toLowerCase().includes(searchTerm.toLowerCase())
      
      const matchesStatus = 
        statusFilter === 'all' || property.status === statusFilter
      
      return matchesSearch && matchesStatus
    })
  }, [data, searchTerm, statusFilter])

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return { bg: 'rgba(63,90,77,0.1)', text: '#3f5a4d' }
      case 'inactive': return { bg: 'rgba(150,150,150,0.1)', text: '#666' }
      case 'draft': return { bg: 'rgba(176,102,43,0.1)', text: '#b0662b' }
      default: return { bg: 'var(--sand-200)', text: 'var(--ink-700)' }
    }
  }

  return (
    <section>
      <h1 className="headline">{t('admin.properties')}</h1>
      
      {/* Filters */}
      <div className="grid grid-2" style={{ marginTop: '1.5rem', marginBottom: '1.5rem' }}>
        <div className="card">
          <label className="muted">{t('admin.search')}</label>
          <input
            type="text"
            className="input"
            placeholder="Search by name, slug, or city..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="card">
          <label className="muted">{t('admin.filter')}</label>
          <select 
            className="input" 
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
          >
            <option value="all">{t('admin.all')}</option>
            <option value="active">{t('admin.active')}</option>
            <option value="inactive">{t('admin.inactive')}</option>
            <option value="draft">{t('admin.draft')}</option>
          </select>
        </div>
      </div>

      {loading && <LoadingState />}
      
      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}
      
      {!loading && filteredProperties.length === 0 && (
        <EmptyState message={t('admin.emptyProperties')} />
      )}
      
      {filteredProperties.length > 0 && (
        <div className="grid" style={{ marginTop: '1.5rem' }}>
          {filteredProperties.map((property) => {
            const statusColors = getStatusColor(property.status)
            return (
              <div 
                key={property.id} 
                className="card" 
                style={{ 
                  display: 'flex', 
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  cursor: 'pointer',
                  transition: 'transform 0.2s, box-shadow 0.2s'
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.transform = 'translateY(-2px)'
                  e.currentTarget.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)'
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.transform = 'translateY(0)'
                  e.currentTarget.style.boxShadow = 'none'
                }}
              >
                <div>
                  <strong style={{ fontSize: '1.1rem' }}>{property.name}</strong>
                  <div className="muted" style={{ marginTop: '0.25rem' }}>
                    {property.city}, {property.state} • {property.slug}
                  </div>
                  {property.type && (
                    <div style={{ marginTop: '0.5rem', fontSize: '0.875rem', color: 'var(--ink-600)' }}>
                      {property.type}
                    </div>
                  )}
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '0.5rem' }}>
                  <span 
                    className="chip" 
                    style={{ 
                      background: statusColors.bg,
                      color: statusColors.text,
                      fontWeight: 600
                    }}
                  >
                    {t(`admin.${property.status}`)}
                  </span>
                  {property.rating && (
                    <span style={{ fontSize: '0.875rem', color: '#b0662b' }}>
                      ★ {property.rating.toFixed(1)}
                    </span>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      )}
      
      {!loading && filteredProperties.length > 0 && (
        <div style={{ marginTop: '1rem', textAlign: 'center' }}>
          <span className="muted">
            Showing {filteredProperties.length} of {data.length} properties
          </span>
        </div>
      )}
    </section>
  )
}
