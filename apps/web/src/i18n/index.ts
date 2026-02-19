import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

// Public translations
import pt from './locales/pt.json'
import en from './locales/en.json'
import es from './locales/es.json'

// Admin translations
import adminCommonPt from './locales/admin/common_pt.json'
import adminCommonEn from './locales/admin/common_en.json'
import adminCommonEs from './locales/admin/common_es.json'

import adminSidebarPt from './locales/admin/sidebar_pt.json'
import adminSidebarEn from './locales/admin/sidebar_en.json'
import adminSidebarEs from './locales/admin/sidebar_es.json'

import adminMarketingPt from './locales/admin/marketing_pt.json'
import adminMarketingEn from './locales/admin/marketing_en.json'
import adminMarketingEs from './locales/admin/marketing_es.json'

import adminDashboardPt from './locales/admin/dashboard_pt.json'
import adminDashboardEn from './locales/admin/dashboard_en.json'
import adminDashboardEs from './locales/admin/dashboard_es.json'

const storedLanguage = localStorage.getItem('rc_lang')

i18n
  .use(initReactI18next)
  .init({
    resources: {
      pt: {
        translation: pt,
        admin_common: adminCommonPt,
        admin_sidebar: adminSidebarPt,
        admin_marketing: adminMarketingPt,
        admin_dashboard: adminDashboardPt
      },
      en: {
        translation: en,
        admin_common: adminCommonEn,
        admin_sidebar: adminSidebarEn,
        admin_marketing: adminMarketingEn,
        admin_dashboard: adminDashboardEn
      },
      es: {
        translation: es,
        admin_common: adminCommonEs,
        admin_sidebar: adminSidebarEs,
        admin_marketing: adminMarketingEs,
        admin_dashboard: adminDashboardEs
      }
    },
    lng: storedLanguage || 'pt',
    fallbackLng: 'pt',
    interpolation: { escapeValue: false },
    ns: ['translation', 'admin_common', 'admin_sidebar', 'admin_marketing', 'admin_dashboard'],
    defaultNS: 'translation'
  })

export function setLanguage(lang: string) {
  i18n.changeLanguage(lang)
  localStorage.setItem('rc_lang', lang)
}

export default i18n
