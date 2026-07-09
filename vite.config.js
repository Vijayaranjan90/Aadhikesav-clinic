import { defineConfig } from 'vite'
import { resolve } from 'path'

export default defineConfig({
  root: 'pages',
  publicDir: resolve(__dirname, 'pages'),
  server: {
    port: 5173,
    host: true,
  },
  optimizeDeps: {
    include: [],
  },
  build: {
    assetsInlineLimit: 0,
  },
})
