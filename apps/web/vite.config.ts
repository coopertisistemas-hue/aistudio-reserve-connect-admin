import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    chunkSizeWarningLimit: 650,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('react-dom') || id.includes('react-router-dom') || id.includes('react/')) {
            return 'react-core'
          }
          if (id.includes('i18next') || id.includes('react-i18next')) {
            return 'i18n'
          }
          if (id.includes('@supabase/supabase-js')) {
            return 'supabase'
          }
          return undefined
        },
      },
    },
  },
})
