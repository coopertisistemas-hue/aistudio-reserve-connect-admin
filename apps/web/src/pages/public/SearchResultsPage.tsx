import { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import SearchForm from '../../components/SearchForm'
import PropertyCard from '../../components/PropertyCard'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { getSessionId } from '../../lib/utils'

type Property = {
  id: string
  slug: string
  name: string
  city: string
  state: string
  rating?: number
  images?: string[]
  amenities?: string[]
  price_per_night: number
}

type SearchResponse = {
  success: boolean
  data: {
    properties: Property[]
    total: number
  }
}

function useQuery() {
  return new URLSearchParams(useLocation().search)
}

export default function SearchResultsPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const query = useQuery()
  const cityCode = import.meta.env.VITE_DEFAULT_CITY_CODE || 'URB'

  const today = new Date()
  const defaultCheckIn = new Date(today.getTime() + 24 * 60 * 60 * 1000)
  const defaultCheckOut = new Date(today.getTime() + 3 * 24 * 60 * 60 * 1000)

  const [checkIn, setCheckIn] = useState(query.get('check_in') || defaultCheckIn.toISOString().split('T')[0])
  const [checkOut, setCheckOut] = useState(query.get('check_out') || defaultCheckOut.toISOString().split('T')[0])
  const [adults, setAdults] = useState(Number(query.get('adults') || 2))
  const [children, setChildren] = useState(Number(query.get('children') || 0))
  const [sort, setSort] = useState(query.get('sort') || 'price_asc')
  const [maxPrice, setMaxPrice] = useState(Number(query.get('max_price') || 0))
  const [results, setResults] = useState<Property[]>([])
  const [loading, setLoading] = useState(false)

  const fetchResults = async () => {
    if (!checkIn || !checkOut) return
    setLoading(true)
    try {
      const payload = await postJson<SearchResponse>('search_availability', {
        city_code: cityCode,
        check_in: checkIn,
        check_out: checkOut,
        guests_adults: adults,
        guests_children: children,
        filters: {
          sort,
          max_price: maxPrice || undefined,
        },
      }, { sessionId: getSessionId() })
      setResults(payload.data.properties ?? [])
    } catch (error) {
      setResults([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchResults()
  }, [checkIn, checkOut, adults, children, sort, maxPrice])

  return (
    <main className="container" style={{ paddingBottom: '4rem' }}>
      <section className="section">
        <h1 className="headline">{t('search.title')}</h1>
        <div style={{ marginTop: '1.5rem' }}>
          <SearchForm
            checkIn={checkIn}
            checkOut={checkOut}
            adults={adults}
            children={children}
            onChange={(field, value) => {
              if (field === 'checkIn') setCheckIn(String(value))
              if (field === 'checkOut') setCheckOut(String(value))
              if (field === 'adults') setAdults(Number(value))
              if (field === 'children') setChildren(Number(value))
            }}
            onSubmit={() => {
              navigate(`/search?check_in=${checkIn}&check_out=${checkOut}&adults=${adults}&children=${children}&sort=${sort}&max_price=${maxPrice || ''}`)
              fetchResults()
            }}
            compact
          />
        </div>
      </section>

      <section className="section">
        <div className="grid grid-2" style={{ alignItems: 'center', marginBottom: '1rem' }}>
          <div className="card">
            <label className="muted">{t('search.sort')}</label>
            <select className="input" value={sort} onChange={(event) => setSort(event.target.value)}>
              <option value="price_asc">{t('search.sortPriceAsc')}</option>
              <option value="price_desc">{t('search.sortPriceDesc')}</option>
              <option value="rating">{t('search.sortRating')}</option>
            </select>
          </div>
          <div className="card">
            <label className="muted">{t('search.priceRange')}</label>
            <input
              type="number"
              className="input"
              placeholder={t('search.maxPricePlaceholder')}
              value={maxPrice || ''}
              onChange={(event) => setMaxPrice(Number(event.target.value))}
            />
          </div>
        </div>

        {loading && <LoadingState />}
        {!loading && results.length === 0 && <EmptyState message={t('search.noResults')} />}
        {!loading && results.length > 0 && (
          <div className="grid grid-3">
            {results.map((property) => (
              <PropertyCard
                key={property.id}
                slug={property.slug}
                detailsUrl={`/p/${property.slug}?check_in=${checkIn}&check_out=${checkOut}&adults=${adults}&children=${children}`}
                name={property.name}
                city={property.city}
                state={property.state}
                rating={property.rating}
                pricePerNight={property.price_per_night}
                image={property.images?.[0]}
                amenities={property.amenities}
              />
            ))}
          </div>
        )}
      </section>
    </main>
  )
}
