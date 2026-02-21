import { Routes, Route, Navigate } from 'react-router-dom'
import ErrorBoundary from './components/ErrorBoundary'
import PublicLayout from './layouts/PublicLayout'
import AdminLayout from './layouts/AdminLayout'
import LandingPage from './pages/public/LandingPage'
import SearchResultsPage from './pages/public/SearchResultsPage'
import PropertyDetailPage from './pages/public/PropertyDetailPage'
import BookingFlowPage from './pages/public/BookingFlowPage'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/admin/DashboardPage'
import PropertiesPage from './pages/admin/PropertiesPage'
import ReservationsPage from './pages/admin/ReservationsPage'
import OpsPage from './pages/admin/OpsPage'
import PaymentsPage from './pages/admin/PaymentsPage'
import FinancialPage from './pages/admin/FinancialPage'
import PayoutsPage from './pages/admin/PayoutsPage'
import PayoutDetailPage from './pages/admin/PayoutDetailPage'
import UnitsPage from './pages/admin/UnitsPage'
import AvailabilityPage from './pages/admin/AvailabilityPage'
import RatePlansPage from './pages/admin/RatePlansPage'
import BookingHoldsPage from './pages/admin/BookingHoldsPage'
import SiteSettingsPage from './pages/admin/marketing/SiteSettingsPage'
import SocialLinksPage from './pages/admin/marketing/SocialLinksPage'
import AdminPlaceholderPage from './pages/admin/AdminPlaceholderPage'

function App() {
  return (
    <ErrorBoundary>
      <Routes>
        <Route element={<PublicLayout />}>
          <Route index element={<LandingPage />} />
          <Route path="search" element={<SearchResultsPage />} />
          <Route path="p/:slug" element={<PropertyDetailPage />} />
          <Route path="book/:slug" element={<BookingFlowPage />} />
        </Route>

        <Route path="login" element={<LoginPage />} />

        <Route path="admin" element={<AdminLayout />}>
          <Route index element={<DashboardPage />} />
          <Route path="leads" element={<AdminPlaceholderPage />} />
          <Route path="sites" element={<AdminPlaceholderPage />} />
          <Route path="ads" element={<AdminPlaceholderPage />} />
          <Route path="creatives" element={<AdminPlaceholderPage />} />
          <Route path="inventory" element={<PropertiesPage />} />
          <Route path="slots" element={<AdminPlaceholderPage />} />
          <Route path="units" element={<UnitsPage />} />
          <Route path="availability" element={<AvailabilityPage />} />
          <Route path="rate-plans" element={<RatePlansPage />} />
          <Route path="booking-holds" element={<BookingHoldsPage />} />
          <Route path="insights" element={<OpsPage />} />
          <Route path="marketing-view" element={<AdminPlaceholderPage />} />
          <Route path="reports" element={<AdminPlaceholderPage />} />
          <Route path="clients" element={<AdminPlaceholderPage />} />
          <Route path="contracts" element={<AdminPlaceholderPage />} />
          <Route path="plans" element={<AdminPlaceholderPage />} />
          <Route path="subscriptions" element={<AdminPlaceholderPage />} />
          <Route path="billing" element={<FinancialPage />} />
          <Route path="users" element={<AdminPlaceholderPage />} />
          <Route path="permissions" element={<AdminPlaceholderPage />} />
          <Route path="integrations" element={<AdminPlaceholderPage />} />
          <Route path="audit" element={<AdminPlaceholderPage />} />
          <Route path="help" element={<AdminPlaceholderPage />} />
          <Route path="settings" element={<AdminPlaceholderPage />} />
          <Route path="properties" element={<PropertiesPage />} />
          <Route path="reservations" element={<ReservationsPage />} />
          <Route path="payments" element={<PaymentsPage />} />
          <Route path="financial" element={<FinancialPage />} />
          <Route path="payouts" element={<PayoutsPage />} />
          <Route path="payouts/:id" element={<PayoutDetailPage />} />
          <Route path="ops" element={<OpsPage />} />
          <Route path="marketing/site-settings" element={<SiteSettingsPage />} />
          <Route path="marketing/social-links" element={<SocialLinksPage />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </ErrorBoundary>
  )
}

export default App
