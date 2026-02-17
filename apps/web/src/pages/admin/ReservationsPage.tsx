import { useEffect, useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, formatDate } from '../../lib/utils'

type Reservation = {
  id: string
  confirmation_code: string
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed'
  check_in: string
  check_out: string
  guest_name: string
  guest_email?: string
  total_amount: number
  property_name?: string
  created_at?: string
}

type ListResponse = {
  success: boolean
  data: Reservation[]
}

function CancelModal({ 
  isOpen, 
  onClose, 
  onConfirm, 
  loading 
}: { 
  isOpen: boolean
  onClose: () => void
  onConfirm: (reason: string) => void
  loading: boolean
}) {
  const { t } = useTranslation()
  const [reason, setReason] = useState('')

  if (!isOpen) return null

  return (
    <div 
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: 'rgba(0,0,0,0.5)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 1000
      }}
      onClick={onClose}
    >
      <div 
        className="card"
        style={{ 
          maxWidth: '480px', 
          width: '90%',
          maxHeight: '90vh',
          overflow: 'auto'
        }}
        onClick={(e) => e.stopPropagation()}
      >
        <h3 style={{ marginBottom: '1rem' }}>{t('admin.cancelConfirmTitle')}</h3>
        <p className="muted" style={{ marginBottom: '1.5rem' }}>
          {t('admin.cancelConfirmMessage')}
        </p>
        <div style={{ marginBottom: '1.5rem' }}>
          <label className="muted">{t('admin.cancelReason')}</label>
          <input
            type="text"
            className="input"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            placeholder="Enter cancellation reason..."
          />
        </div>
        <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end' }}>
          <button className="button-secondary" onClick={onClose} disabled={loading}>
            {t('admin.close')}
          </button>
          <button 
            className="button-primary" 
            onClick={() => onConfirm(reason)}
            disabled={loading || !reason.trim()}
            style={{ background: '#c83232' }}
          >
            {loading ? '...' : t('admin.confirm')}
          </button>
        </div>
      </div>
    </div>
  )
}

export default function ReservationsPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Reservation[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [statusFilter, setStatusFilter] = useState<string>('all')
  const [selectedReservation, setSelectedReservation] = useState<Reservation | null>(null)
  const [cancelLoading, setCancelLoading] = useState(false)

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<ListResponse>('admin_list_reservations', {}, { auth: true })
        if (active) setData(response.data)
      } catch (err: any) {
        if (active) {
          setData([])
          setError(err.message || 'Failed to load reservations')
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

  const filteredReservations = useMemo(() => {
    return data.filter((reservation) => {
      const matchesSearch = 
        searchTerm === '' || 
        reservation.confirmation_code.toLowerCase().includes(searchTerm.toLowerCase()) ||
        reservation.guest_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (reservation.guest_email && reservation.guest_email.toLowerCase().includes(searchTerm.toLowerCase()))
      
      const matchesStatus = 
        statusFilter === 'all' || reservation.status === statusFilter
      
      return matchesSearch && matchesStatus
    })
  }, [data, searchTerm, statusFilter])

  const cancelReservation = async (id: string, reason: string) => {
    setCancelLoading(true)
    try {
      await postJson('cancel_reservation', {
        reservation_id: id,
        cancellation_reason: reason || 'admin_request',
        actor_type: 'admin'
      }, { auth: true, idempotencyKey: `admin-cancel:${id}:${Date.now()}` })
      
      setData((prev) => prev.map((item) => 
        item.id === id ? { ...item, status: 'cancelled' } : item
      ))
      setSelectedReservation(null)
    } catch (err: any) {
      setError(err.message || 'Failed to cancel reservation')
    } finally {
      setCancelLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'confirmed': return { bg: 'rgba(63,90,77,0.1)', text: '#3f5a4d' }
      case 'pending': return { bg: 'rgba(176,102,43,0.1)', text: '#b0662b' }
      case 'cancelled': return { bg: 'rgba(200,50,50,0.1)', text: '#c83232' }
      case 'completed': return { bg: 'rgba(100,100,200,0.1)', text: '#6464c8' }
      default: return { bg: 'var(--sand-200)', text: 'var(--ink-700)' }
    }
  }

  return (
    <section>
      <h1 className="headline">{t('admin.reservations')}</h1>
      
      {/* Filters */}
      <div className="grid grid-2" style={{ marginTop: '1.5rem', marginBottom: '1.5rem' }}>
        <div className="card">
          <label className="muted">{t('admin.search')}</label>
          <input
            type="text"
            className="input"
            placeholder="Search by code, guest name, or email..."
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
            <option value="confirmed">{t('admin.confirmed')}</option>
            <option value="pending">{t('admin.pending')}</option>
            <option value="cancelled">{t('admin.cancelled')}</option>
          </select>
        </div>
      </div>

      {loading && <LoadingState />}
      
      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}
      
      {!loading && filteredReservations.length === 0 && (
        <EmptyState message={t('admin.emptyReservations')} />
      )}
      
      {filteredReservations.length > 0 && (
        <div className="grid" style={{ marginTop: '1.5rem' }}>
          {filteredReservations.map((reservation) => {
            const statusColors = getStatusColor(reservation.status)
            return (
              <div 
                key={reservation.id} 
                className="card" 
                style={{ display: 'grid', gap: '0.8rem' }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <strong style={{ fontSize: '1.1rem' }}>{reservation.confirmation_code}</strong>
                    <span 
                      className="chip" 
                      style={{ 
                        marginLeft: '0.75rem',
                        background: statusColors.bg,
                        color: statusColors.text,
                        fontWeight: 600
                      }}
                    >
                      {t(`admin.${reservation.status}`)}
                    </span>
                  </div>
                  <strong style={{ color: '#3f5a4d' }}>{formatCurrency(reservation.total_amount)}</strong>
                </div>
                
                <div>
                  <div style={{ fontWeight: 500 }}>{reservation.guest_name}</div>
                  {reservation.guest_email && (
                    <div className="muted" style={{ fontSize: '0.875rem' }}>{reservation.guest_email}</div>
                  )}
                </div>
                
                <div className="muted" style={{ display: 'flex', gap: '1rem', fontSize: '0.875rem' }}>
                  <span>{formatDate(reservation.check_in)} → {formatDate(reservation.check_out)}</span>
                  {reservation.property_name && (
                    <span>• {reservation.property_name}</span>
                  )}
                </div>
                
                {(reservation.status === 'pending' || reservation.status === 'confirmed') && (
                  <button 
                    className="button-secondary" 
                    onClick={() => setSelectedReservation(reservation)}
                    style={{ alignSelf: 'flex-start', marginTop: '0.5rem' }}
                  >
                    {t('admin.cancelReservation')}
                  </button>
                )}
              </div>
            )
          })}
        </div>
      )}
      
      {!loading && filteredReservations.length > 0 && (
        <div style={{ marginTop: '1rem', textAlign: 'center' }}>
          <span className="muted">
            Showing {filteredReservations.length} of {data.length} reservations
          </span>
        </div>
      )}

      {/* Cancel Modal */}
      <CancelModal
        isOpen={!!selectedReservation}
        onClose={() => setSelectedReservation(null)}
        onConfirm={(reason) => {
          if (selectedReservation) {
            cancelReservation(selectedReservation.id, reason)
          }
        }}
        loading={cancelLoading}
      />
    </section>
  )
}
