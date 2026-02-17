export function getSessionId() {
  const key = 'rc_session_id'
  const existing = localStorage.getItem(key)
  if (existing) return existing
  const value = crypto.randomUUID?.() ?? `session_${Date.now()}`
  localStorage.setItem(key, value)
  return value
}

export function formatCurrency(value: number, currency = 'BRL') {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency,
    maximumFractionDigits: 0,
  }).format(value)
}

export function formatDate(value?: string) {
  if (!value) return ''
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: 'short',
  }).format(new Date(value))
}
