# Sprint F0 - Repo Hygiene & Baseline

**Date:** February 17, 2026  
**Status:** ✅ COMPLETE

---

## 1. Current State Assessment

### Repository Structure (apps/web/)
```
src/
├── components/          # UI components (Header, Footer, LoadingState, etc.)
├── i18n/               # PT/EN/ES translations
├── layouts/            # PublicLayout, AdminLayout
├── lib/                # apiClient, auth, utils
├── pages/              # Public + Admin pages
├── App.tsx            # Router configuration
├── index.css          # Design system (premium CSS)
└── main.tsx           # Entry point
```

### Existing Design System ✅
- **Typography:** Manrope (body) + Playfair Display (headings)
- **Colors:** CSS custom properties (ink, sand, pearl, accent, sage)
- **Shadows:** Premium soft shadows (--shadow-soft, --shadow-card)
- **Components:** Buttons, cards, chips, inputs already styled
- **Grid:** Responsive grid system (grid-2, grid-3)

### i18n ✅
- PT/EN/ES translations complete
- Language switcher implemented
- localStorage persistence

### Security ✅
- No .env files committed
- .gitignore includes .env
- JWT auth implemented
- No bypass tokens

---

## 2. Reuse Strategy

### ADS Connect Template Analysis
**Note:** ADS Connect LP zip was referenced but not provided in execution context.

**Strategy:** Enhance existing Reserve Connect design system to achieve ADS-level premium quality:

1. **Keep Existing Foundation**
   - Typography scale (Manrope + Playfair)
   - Color palette (warm, premium aesthetic)
   - CSS custom properties structure
   - Component patterns

2. **Enhancements Needed (Sprint F1)**
   - Add missing UI primitives (Skeleton, Toast, Modal)
   - Improve accessibility (focus states, ARIA)
   - Add animation/transition polish
   - Create design token documentation
   - Ensure mobile-first responsiveness

3. **Public Site (Sprint F2)**
   - Landing Page: Hero enhancement, featured properties grid
   - Search Results: Card improvements, filter UI polish
   - Property Detail: Gallery layout, amenity presentation
   - Booking Flow: Step indicator, payment UI refinement

4. **Admin Panel (Sprints F3-F4)**
   - ADS-style dashboard: KPI cards, data tables
   - Sidebar navigation (premium styling)
   - Consistent header/actions pattern
   - Darker admin theme variant (optional)

---

## 3. Files to Modify/Create

### Sprint F1 (Design System)
- `src/index.css` - Add missing tokens, animations
- `src/components/ui/` - Create reusable UI primitives:
  - `Skeleton.tsx` - Loading skeletons
  - `Toast.tsx` - Notification toasts
  - `Modal.tsx` - Modal/dialog base
  - `Badge.tsx` - Status badges (enhanced)
  - `Button.tsx` - Button variants (if needed)

### Sprint F2 (Public Site)
- `src/pages/public/LandingPage.tsx` - Hero redesign, featured section
- `src/pages/public/SearchResultsPage.tsx` - Card grid, filters
- `src/pages/public/PropertyDetailPage.tsx` - Gallery, layout
- `src/pages/public/BookingFlowPage.tsx` - Step indicator, polish

### Sprint F3 (Admin Auth & Layout)
- `src/layouts/AdminLayout.tsx` - Sidebar, topbar styling
- `src/pages/LoginPage.tsx` - Premium login form

### Sprint F4 (Admin Modules)
- `src/pages/admin/DashboardPage.tsx` - KPI cards, charts
- `src/pages/admin/PropertiesPage.tsx` - Data table
- `src/pages/admin/ReservationsPage.tsx` - Table + actions
- `src/pages/admin/OpsPage.tsx` - Terminal-style logs

### Sprint F5 (QA & Deploy)
- `vercel.json` - SPA routing
- `docs/FRONTEND_QA.md` - QA checklist
- `docs/DEPLOY_FRONTEND.md` - Deployment guide

---

## 4. Branch Strategy

**Working Branch:** `opencode/witty-engine` (current)

**Commit Pattern:**
```
sprint(F0|F1|F2|F3|F4|F5): <component> - <description>

Examples:
sprint(f1): design-system - add skeleton and toast components
sprint(f2): landing-page - hero redesign with featured properties
sprint(f3): admin-layout - sidebar navigation styling
```

---

## 5. QA Checklist - Sprint F0

| Check | Status |
|-------|--------|
| No .env files in repo | ✅ PASS |
| .gitignore has .env | ✅ PASS |
| Build passes | ✅ PASS |
| i18n files complete | ✅ PASS |
| Design system documented | ✅ PASS |
| Strategy documented | ✅ PASS |

---

## 6. Risks & Mitigation

| Risk | Mitigation |
|------|-----------|
| No ADS zip available | Will enhance existing design to premium level |
| Time constraints | Prioritize core functionality over polish |
| Edge Functions availability | Assume backend is complete and functional |

---

## 7. Next Steps

**Sprint F1:** Design System Alignment
- Create UI primitives (Skeleton, Toast, Modal)
- Enhance CSS with animations
- Improve accessibility
- Document design tokens

**Ready to proceed:** ✅
