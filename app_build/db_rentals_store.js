/**
 * 📦 Module de Persistance Locale IndexedDB & Fallback localStorage
 * Rôle : Stockage offline-first des recherches de logements avec TTL (Time-To-Live)
 * Auteur : @OPS (DevOps, Data & Résilience)
 */

const DB_NAME = 'TravelDashboardRentalsDB';
const DB_VERSION = 1;
const STORE_NAME = 'rentals_cache';
const DEFAULT_TTL_MS = 3 * 60 * 60 * 1000; // 3 heures

class RentalsStorageManager {
  constructor() {
    this.db = null;
    this.isIndexedDBSupported = typeof indexedDB !== 'undefined';
  }

  async init() {
    if (!this.isIndexedDBSupported) {
      console.warn('[OPS Cache] IndexedDB non supporté. Utilisation du fallback localStorage.');
      return false;
    }

    return new Promise((resolve) => {
      const request = indexedDB.open(DB_NAME, DB_VERSION);

      request.onupgradeneeded = (event) => {
        const db = event.target.result;
        if (!db.objectStoreNames.contains(STORE_NAME)) {
          const store = db.createObjectStore(STORE_NAME, { keyPath: 'searchKey' });
          store.createIndex('timestamp', 'timestamp', { unique: false });
          store.createIndex('expiresAt', 'expiresAt', { unique: false });
        }
      };

      request.onsuccess = (event) => {
        this.db = event.target.result;
        console.log('[OPS Cache] Base IndexedDB initialisée avec succès.');
        this.purgeExpired();
        resolve(true);
      };

      request.onerror = (event) => {
        console.error('[OPS Cache] Erreur ouverture IndexedDB :', event.target.error);
        resolve(false);
      };
    });
  }

  /**
   * Sauvegarder les résultats d'une recherche avec TTL
   */
  async saveSearch(searchKey, data, ttlMs = DEFAULT_TTL_MS) {
    const record = {
      searchKey,
      timestamp: Date.now(),
      expiresAt: Date.now() + ttlMs,
      data
    };

    if (this.db) {
      return new Promise((resolve) => {
        const tx = this.db.transaction([STORE_NAME], 'readwrite');
        const store = tx.objectStore(STORE_NAME);
        const req = store.put(record);
        req.onsuccess = () => resolve(true);
        req.onerror = () => resolve(false);
      });
    } else {
      // Fallback localStorage
      try {
        localStorage.setItem(`rental_${searchKey}`, JSON.stringify(record));
        return true;
      } catch (e) {
        console.warn('[OPS Cache] localStorage saturé ou inaccessible');
        return false;
      }
    }
  }

  /**
   * Récupérer une recherche du cache si non expirée
   */
  async getSearch(searchKey) {
    if (this.db) {
      return new Promise((resolve) => {
        const tx = this.db.transaction([STORE_NAME], 'readonly');
        const store = tx.objectStore(STORE_NAME);
        const req = store.get(searchKey);

        req.onsuccess = () => {
          const res = req.result;
          if (res && res.expiresAt > Date.now()) {
            resolve(res.data);
          } else {
            resolve(null);
          }
        };
        req.onerror = () => resolve(null);
      });
    } else {
      // Fallback localStorage
      try {
        const raw = localStorage.getItem(`rental_${searchKey}`);
        if (!raw) return null;
        const res = JSON.parse(raw);
        if (res.expiresAt > Date.now()) {
          return res.data;
        }
        localStorage.removeItem(`rental_${searchKey}`);
        return null;
      } catch (e) {
        return null;
      }
    }
  }

  /**
   * Purge automatique des entrées expirées
   */
  async purgeExpired() {
    if (!this.db) return;
    try {
      const tx = this.db.transaction([STORE_NAME], 'readwrite');
      const store = tx.objectStore(STORE_NAME);
      const req = store.openCursor();
      const now = Date.now();

      req.onsuccess = (event) => {
        const cursor = event.target.result;
        if (cursor) {
          if (cursor.value.expiresAt < now) {
            cursor.delete();
          }
          cursor.continue();
        }
      };
    } catch (err) {
      console.warn('[OPS Cache] Purge différée :', err);
    }
  }
}

// Export global pour utilisation dans l'application
if (typeof window !== 'undefined') {
  window.RentalsStorageManager = RentalsStorageManager;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = RentalsStorageManager;
}
