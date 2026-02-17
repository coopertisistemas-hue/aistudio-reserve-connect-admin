import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Reservation = {
  id: string
  confirmation_code: string
  status: string
  check_in: string
  check_out: string
  guest_name: string
  total_amount: number
}

type Response = {
  success: boolean
  data: Reservation[]
}

export default function ReservationsPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Reservation[]>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      try {
        const response = await postJson<Response>('admin_list_reservations', {}, { auth: true })
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

  const cancelReservation = async (id: string) => {
    await postJson('cancel_reservation', {
      reservation_id: id,
      cancellation_reason: 'admin_request',
      actor_type: 'admin'
    }, { auth: true, idempotencyKey: `admin-cancel:${id}` })
    setData((prev) => prev.map((item) => (item.id === id ? { ...item, status: 'cancelled' } : item)))
  }

  return (
    <section>
      <h1 className="headline">{t('admin.reservations')}</h1>
      {loading && <LoadingState />}
      {!loading && data.length === 0 && <EmptyState message={t('admin.emptyReservations')} />}
      {data.length > 0 && (
        <div className="grid" style={{ marginTop: '1.5rem' }}>
          {data.map((reservation) => (
            <div key={reservation.id} className="card" style={{ display: 'grid', gap: '0.6rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <strong>{reservation.confirmation_code}</strong>
                <span className="chip">{reservation.status}</span>
              </div>
              <div className="muted">{reservation.guest_name}</div>
              <div className="muted">{reservation.check_in} → {reservation.check_out}</div>
              {reservation.status !== 'cancelled' && (
                <button className="button-secondary" onClick={() => cancelReservation(reservation.id)}>
                  {t('admin.cancelReservation')}
                </button>
              )}
            </div>
          ))}
        </div>
      )}
    </section>
  )
}
