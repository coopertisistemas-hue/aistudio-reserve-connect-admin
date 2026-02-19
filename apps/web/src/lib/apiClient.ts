import { getAccessToken } from './auth'

const baseUrl = import.meta.env.VITE_FUNCTIONS_BASE_URL
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!baseUrl) {
  console.warn('VITE_FUNCTIONS_BASE_URL is not set')
}

if (!anonKey) {
  console.warn('VITE_SUPABASE_ANON_KEY is not set')
}

type ApiOptions = {
  auth?: boolean
  idempotencyKey?: string
  sessionId?: string
}

export async function postJson<T>(path: string, body: unknown, options: ApiOptions = {}): Promise<T> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 20000)

  try {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    }

    if (anonKey) {
      headers.apikey = anonKey
    }

    if (options.idempotencyKey) {
      headers['x-idempotency-key'] = options.idempotencyKey
    }

    if (options.sessionId) {
      headers['x-session-id'] = options.sessionId
    }

    if (options.auth) {
      const token = await getAccessToken()
      if (token) {
        headers.Authorization = `Bearer ${token}`
      }
    } else if (anonKey) {
      headers.Authorization = `Bearer ${anonKey}`
    }

    const response = await fetch(`${baseUrl}/${path}`, {
      method: 'POST',
      headers,
      body: JSON.stringify(body),
      signal: controller.signal,
    })

    const payload = await response.json().catch(() => null)
    if (!response.ok || payload?.success === false) {
      const message = payload?.error?.message || payload?.message || 'Request failed'
      throw new Error(message)
    }

    return payload as T
  } finally {
    clearTimeout(timeout)
  }
}
