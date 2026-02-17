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
import SiteSettingsPage from './pages/admin/marketing/SiteSettingsPage'
import SocialLinksPage from './pages/admin/marketing/SocialLinksPage'

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
          <Route path="properties" element={<PropertiesPage />} />
          <Route path="reservations" element={<ReservationsPage />} />
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
