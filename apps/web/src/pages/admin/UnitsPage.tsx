import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Unit = {
  id: string
  property_id: string
  property_name: string | null
  property_city: string | null
  name: string
  slug: string
  unit_type: string | null
  max_occupancy: number
  base_capacity: number
  size_sqm: number | null
  is_active: boolean
  updated_at: string
}

type Property = {
  id: string
  name: string
}

export default function UnitsPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [units, setUnits] = useState<Unit[]>([])
  const [properties, setProperties] = useState<Property[]>([])
  const [propertyId, setPropertyId] = useState('')

  const [saving, setSaving] = useState(false)
  const [form, setForm] = useState({
    id: '',
    property_id: '',
    name: '',
    slug: '',
    unit_type: '',
    max_occupancy: 2,
    base_capacity: 2,
    size_sqm: '',
    is_active: true,
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [unitsRes, propertiesRes] = await Promise.all([
        postJson<{ success: boolean; data: Unit[] }>('admin_list_units', {
          property_id: propertyId || undefined,
        }, { auth: true }),
        postJson<{ success: boolean; data: Property[] }>('admin_list_properties', {}, { auth: true }),
      ])
      setUnits(unitsRes.data || [])
      setProperties(propertiesRes.data || [])
    } catch (err: any) {
      setUnits([])
      setError(err.message || t('admin.s1.units.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [propertyId])

  const editUnit = (unit: Unit) => {
    setForm({
      id: unit.id,
      property_id: unit.property_id,
      name: unit.name,
      slug: unit.slug,
      unit_type: unit.unit_type || '',
      max_occupancy: unit.max_occupancy,
      base_capacity: unit.base_capacity,
      size_sqm: unit.size_sqm ? String(unit.size_sqm) : '',
      is_active: unit.is_active,
    })
  }

  const resetForm = () => {
    setForm({
      id: '',
      property_id: '',
      name: '',
      slug: '',
      unit_type: '',
      max_occupancy: 2,
      base_capacity: 2,
      size_sqm: '',
      is_active: true,
    })
  }

  const saveUnit = async () => {
    if (!form.property_id || !form.name) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_unit', {
        id: form.id || undefined,
        property_id: form.property_id,
        name: form.name,
        slug: form.slug || undefined,
        unit_type: form.unit_type || undefined,
        max_occupancy: form.max_occupancy,
        base_capacity: form.base_capacity,
        size_sqm: form.size_sqm ? Number(form.size_sqm) : undefined,
        is_active: form.is_active,
      }, { auth: true })
      resetForm()
      await load()
    } catch (err: any) {
      setError(err.message || t('admin.s1.units.errors.save'))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s1.units.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <label className="muted">{t('admin.s1.common.filterByProperty')}</label>
        <select className="input" value={propertyId} onChange={(e) => setPropertyId(e.target.value)}>
          <option value="">{t('admin.all')}</option>
          {properties.map((property) => (
            <option key={property.id} value={property.id}>{property.name}</option>
          ))}
        </select>
      </div>

      <div className="card" style={{ marginBottom: '1.25rem' }}>
        <h3 style={{ marginTop: 0 }}>{form.id ? t('admin.s1.units.editTitle') : t('admin.s1.units.newTitle')}</h3>
        <div className="grid grid-3" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">{t('admin.properties')}</label>
            <select className="input" value={form.property_id} onChange={(e) => setForm((prev) => ({ ...prev, property_id: e.target.value }))}>
              <option value="">{t('admin.s1.common.select')}</option>
              {properties.map((property) => (
                <option key={property.id} value={property.id}>{property.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="muted">{t('admin.s1.common.name')}</label>
            <input className="input" value={form.name} onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))} />
          </div>
          <div>
            <label className="muted">Slug</label>
            <input className="input" value={form.slug} onChange={(e) => setForm((prev) => ({ ...prev, slug: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.units.type')}</label>
            <input className="input" value={form.unit_type} onChange={(e) => setForm((prev) => ({ ...prev, unit_type: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.units.maxOccupancy')}</label>
            <input className="input" type="number" min={1} value={form.max_occupancy} onChange={(e) => setForm((prev) => ({ ...prev, max_occupancy: Number(e.target.value) }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.units.baseCapacity')}</label>
            <input className="input" type="number" min={1} value={form.base_capacity} onChange={(e) => setForm((prev) => ({ ...prev, base_capacity: Number(e.target.value) }))} />
          </div>
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '1rem' }}>
          <button className="button-secondary" onClick={resetForm}>{t('admin.s1.common.clear')}</button>
          <button className="button-primary" onClick={saveUnit} disabled={saving || !form.property_id || !form.name}>
            {saving ? t('admin.saving') : form.id ? t('admin.s1.common.update') : t('admin.s1.common.create')}
          </button>
        </div>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}
      {!loading && units.length === 0 && <EmptyState message={t('admin.s1.units.empty')} />}

      {!loading && units.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {units.map((unit) => (
            <button key={unit.id} className="card" onClick={() => editUnit(unit)} style={{ textAlign: 'left', cursor: 'pointer' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{unit.name}</strong>
                <span className="chip">{unit.is_active ? t('admin.active') : t('admin.inactive')}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{unit.property_name} {unit.property_city ? `• ${unit.property_city}` : ''}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                <span className="chip">{unit.slug}</span>
                {unit.unit_type && <span className="chip">{unit.unit_type}</span>}
                <span className="chip">{t('admin.s1.units.maxShort')}: {unit.max_occupancy}</span>
              </div>
            </button>
          ))}
        </div>
      )}
    </section>
  )
}
