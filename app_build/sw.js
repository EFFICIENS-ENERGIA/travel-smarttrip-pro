/**
 * sw.js — Service Worker Offline-First avec Versionnement Dynamique v2
 * Réalisé par @OPS (Architecte DevOps, Data & Résilience)
 * Révisé suite à l'audit @AUD : Invalidation automatique des anciens caches (PASSED)
 */

const CACHE_NAME = 'pwa-taskmanager-v2';
const STATIC_ASSETS = [
  './',
  './index.html',
  './styles.css',
  './db.js',
  './app.js',
  './manifest.json',
  './icon.svg'
];

// Phase 1 : Installation et mise en cache des actifs essentiels
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[SW] Mise en cache des ressources statiques (v2)');
      return cache.addAll(STATIC_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

// Phase 2 : Activation et purge systématique des anciens caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            console.log('[SW] Purge de l''ancien cache expiré :', cache);
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Phase 3 : Stratégie Cache-First avec repli réseau résilient
self.addEventListener('fetch', (event) => {
  // Ignorer les requêtes non-GET et les schémas non supportés
  if (event.request.method !== 'GET' || !event.request.url.startsWith('http')) {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }

      return fetch(event.request).then((networkResponse) => {
        if (!networkResponse || networkResponse.status !== 200 || networkResponse.type !== 'basic') {
          return networkResponse;
        }

        const responseToCache = networkResponse.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseToCache);
        });

        return networkResponse;
      }).catch(() => {
        // En cas de perte réseau totale pour une navigation HTML, renvoyer la coquille principale
        if (event.request.mode === 'navigate') {
          return caches.match('./index.html');
        }
      });
    })
  );
});