import { useEffect, useMemo, useState } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, getSessionId } from '../../lib/utils'
import LoadingState from '../../components/LoadingState'

type BookingIntentResponse = {
  success: boolean
  data: {
    intent_id: string
    status: string
    expires_at: string
    pricing: {
      nightly_rate: number
      nights: number
      total: number
      currency: string
    }
  }
}

type StripePaymentResponse = {
  success: boolean
  data: {
    client_secret: string
    payment_intent_id: string
    amount: number
    currency: string
  }
}

type PixPaymentResponse = {
  success: boolean
  data: {
    pix_id: string
    qr_code_base64: string
    copy_paste_key: string
    expires_at: string
    amount: number
    total_with_iof: number
  }
}

type PollResponse = {
  success: boolean
  data: {
    status: string
    payment_method: string
    next_action?: string
  }
}

export default function BookingFlowPage() {
  const { slug } = useParams()
  const [searchParams] = useSearchParams()
  const { t } = useTranslation()
  const navigate = useNavigate()
  const cityCode = import.meta.env.VITE_DEFAULT_CITY_CODE || 'URB'
  const unitId = searchParams.get('unit_id') || ''
  const checkIn = searchParams.get('check_in') || ''
  const checkOut = searchParams.get('check_out') || ''
  const adults = Number(searchParams.get('adults') || 2)
  const children = Number(searchParams.get('children') || 0)

  const [intentId, setIntentId] = useState<string | null>(null)
  const [pricing, setPricing] = useState<BookingIntentResponse['data']['pricing'] | null>(null)
  const [loading, setLoading] = useState(false)
  const [paymentMethod, setPaymentMethod] = useState<'stripe' | 'pix' | null>(null)
  const [paymentData, setPaymentData] = useState<StripePaymentResponse['data'] | PixPaymentResponse['data'] | null>(null)
  const [status, setStatus] = useState<string | null>(null)

  const intentKey = useMemo(
    () => `intent:${slug}:${unitId}:${checkIn}:${checkOut}`,
    [slug, unitId, checkIn, checkOut]
  )

  useEffect(() => {
    const cached = localStorage.getItem(intentKey)
    if (cached) {
      setIntentId(cached)
    }
  }, [intentKey])

  const createIntent = async () => {
    if (!slug || !unitId || !checkIn || !checkOut) return
    setLoading(true)
    try {
      const response = await postJson<BookingIntentResponse>('create_booking_intent', {
        session_id: getSessionId(),
        city_code: cityCode,
        property_slug: slug,
        unit_id: unitId,
        check_in: checkIn,
        check_out: checkOut,
        guests_adults: adults,
        guests_children: children,
      }, { idempotencyKey: intentKey, sessionId: getSessionId() })
      setIntentId(response.data.intent_id)
      setPricing(response.data.pricing)
      localStorage.setItem(intentKey, response.data.intent_id)
    } catch (error) {
      setStatus('error')
    } finally {
      setLoading(false)
    }
  }

  const startPayment = async (method: 'stripe' | 'pix') => {
    if (!intentId) return
    setLoading(true)
    setPaymentMethod(method)
    try {
      if (method === 'stripe') {
        const response = await postJson<StripePaymentResponse>('create_payment_intent_stripe', {
          intent_id: intentId,
        }, { idempotencyKey: `stripe:${intentId}` })
        setPaymentData(response.data)
      } else {
        const response = await postJson<PixPaymentResponse>('create_pix_charge', {
          intent_id: intentId,
        }, { idempotencyKey: `pix:${intentId}` })
        setPaymentData(response.data)
      }
      setStatus('processing')
    } catch (error) {
      setStatus('error')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (!intentId || !status || status === 'succeeded') return
    const interval = setInterval(async () => {
      try {
        const response = await postJson<PollResponse>('poll_payment_status', {
          intent_id: intentId,
        })
        setStatus(response.data.status)
      } catch (error) {
        setStatus('pending')
      }
    }, 5000)

    return () => clearInterval(interval)
  }, [intentId, status])

  useEffect(() => {
    if (!intentId) {
      createIntent()
    }
  }, [intentId])

  if (!slug) {
    return (
      <main className="container section">
        <LoadingState />
      </main>
    )
  }

  return (
    <main className="container" style={{ paddingBottom: '4rem' }}>
      <section className="section">
        <button className="button-secondary" onClick={() => navigate(-1)}>{t('common.back')}</button>
        <h1 className="headline" style={{ marginTop: '1rem' }}>{t('booking.title')}</h1>
        <div className="grid grid-2" style={{ marginTop: '2rem' }}>
          <div className="card">
            <h3>{t('booking.step1')}</h3>
            {loading && !intentId && <LoadingState />}
            {pricing && (
              <div style={{ display: 'grid', gap: '0.6rem', marginTop: '1rem' }}>
                <div><strong>{formatCurrency(pricing.nightly_rate)}</strong> / {t('property.perNight')}</div>
                <div className="muted">{pricing.nights} {t('common.nights')}</div>
                <div><strong>{formatCurrency(pricing.total)}</strong> {t('property.total')}</div>
                <div className="muted">Intent ID: {intentId}</div>
              </div>
            )}
          </div>
          <div className="card">
            <h3>{t('booking.step2')}</h3>
            <p className="muted">{t('booking.paymentMethod')}</p>
            <div style={{ display: 'flex', gap: '0.6rem', flexWrap: 'wrap' }}>
              <button className="button-primary" onClick={() => startPayment('stripe')}>
                {t('booking.stripe')}
              </button>
              <button className="button-secondary" onClick={() => startPayment('pix')}>
                {t('booking.pix')}
              </button>
            </div>
            {loading && <LoadingState />}
            {paymentMethod === 'pix' && paymentData && 'qr_code_base64' in paymentData && (
              <div style={{ marginTop: '1rem' }}>
                <img src={`data:image/png;base64,${paymentData.qr_code_base64}`} alt="PIX" style={{ maxWidth: '200px' }} />
                <p className="muted" style={{ marginTop: '0.5rem' }}>{paymentData.copy_paste_key}</p>
              </div>
            )}
            {paymentMethod === 'stripe' && paymentData && 'client_secret' in paymentData && (
              <div className="muted" style={{ marginTop: '1rem' }}>
                {t('booking.stripeNotice')}
              </div>
            )}
          </div>
        </div>
      </section>

      <section className="section">
        <div className="card">
          <h3>{t('booking.step3')}</h3>
          <p className="muted">{t('booking.status')}: {status || t('booking.awaiting')}</p>
          {status === 'succeeded' && (
            <div style={{ marginTop: '1rem' }}>
              <strong>{t('booking.confirmation')}</strong>
              <p className="muted">{t('booking.confirmationHint')}</p>
            </div>
          )}
          {status && status !== 'succeeded' && (
            <p className="muted">{t('booking.pending')}</p>
          )}
          {status === 'error' && (
            <p className="muted">{t('common.error')}</p>
          )}
        </div>
      </section>

      <section className="section">
        <Link to="/search" className="button-secondary">{t('common.search')}</Link>
      </section>
    </main>
  )
}
