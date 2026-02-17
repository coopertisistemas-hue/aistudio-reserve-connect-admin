import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/auth'
import LoadingState from '../components/LoadingState'

export default function LoginPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault()
    setLoading(true)
    setError(null)
    const { error: signInError } = await supabase.auth.signInWithPassword({ email, password })
    if (signInError) {
      setError(signInError.message)
      setLoading(false)
      return
    }
    navigate('/admin')
  }

  return (
    <main className="container" style={{ padding: '4rem 0' }}>
      <div className="card" style={{ maxWidth: '420px', margin: '0 auto' }}>
        <h1 className="headline">{t('admin.loginTitle')}</h1>
        <form onSubmit={handleSubmit} style={{ display: 'grid', gap: '1rem', marginTop: '1.5rem' }}>
          <div>
            <label className="muted">{t('admin.email')}</label>
            <input className="input" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
          </div>
          <div>
            <label className="muted">{t('admin.password')}</label>
            <input className="input" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />
          </div>
          <button className="button-primary" type="submit">{t('admin.signIn')}</button>
        </form>
        {loading && <LoadingState />}
        {error && <p className="muted">{error}</p>}
      </div>
    </main>
  )
}
