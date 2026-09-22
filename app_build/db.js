/**
 * db.js — Adaptateur de Persistance Local-First / IndexedDB avec Fallback localStorage
 * Conçu par @DEV (Développeur Senior Fullstack) pour PWA Task Manager
 */

(function(window) {
  'use strict';

  const DB_NAME = 'TaskManagerDB';
  const DB_VERSION = 1;
  const STORE_NAME = 'tasks';
  const LS_KEY = 'taskmanager_tasks_fallback';

  class StorageAdapter {
    constructor() {
      this.db = null;
      this.isIndexedDBAvailable = 'indexedDB' in window;
    }

    /**
     * Initialise la base de données IndexedDB ou prépare le fallback localStorage
     */
    async init() {
      if (!this.isIndexedDBAvailable) {
        console.warn('⚠️ IndexedDB non supporté. Bascule automatique sur localStorage.');
        return;
      }

      return new Promise((resolve, reject) => {
        const request = indexedDB.open(DB_NAME, DB_VERSION);

        request.onupgradeneeded = (event) => {
          const db = event.target.result;
          if (!db.objectStoreNames.contains(STORE_NAME)) {
            const store = db.createObjectStore(STORE_NAME, { keyPath: 'id' });
            store.createIndex('status', 'status', { unique: false });
            store.createIndex('priority', 'priority', { unique: false });
            store.createIndex('createdAt', 'createdAt', { unique: false });
          }
        };

        request.onsuccess = (event) => {
          this.db = event.target.result;
          resolve(this.db);
        };

        request.onerror = (event) => {
          console.error('Erreur IndexedDB open:', event.target.error);
          this.isIndexedDBAvailable = false;
          resolve(); // Fallback transparent
        };
      });
    }

    /**
     * Récupère l'ensemble des tâches stockées
     */
    async getAllTasks() {
      if (this.db) {
        return new Promise((resolve, reject) => {
          try {
            const transaction = this.db.transaction([STORE_NAME], 'readonly');
            const store = transaction.objectStore(STORE_NAME);
            const request = store.getAll();

            request.onsuccess = () => resolve(request.result || []);
            request.onerror = () => resolve(this._getLocalStorageTasks());
          } catch (e) {
            resolve(this._getLocalStorageTasks());
          }
        });
      }
      return this._getLocalStorageTasks();
    }

    /**
     * Ajoute ou met à jour une tâche
     */
    async saveTask(task) {
      if (!task || !task.id) throw new Error('Format de tâche invalide (id requis)');

      if (this.db) {
        return new Promise((resolve, reject) => {
          try {
            const transaction = this.db.transaction([STORE_NAME], 'readwrite');
            const store = transaction.objectStore(STORE_NAME);
            const request = store.put(task);

            request.onsuccess = () => resolve(task);
            request.onerror = (e) => {
              this._saveLocalStorageTask(task);
              resolve(task);
            };
          } catch (e) {
            this._saveLocalStorageTask(task);
            resolve(task);
          }
        });
      }

      this._saveLocalStorageTask(task);
      return task;
    }

    /**
     * Supprime une tâche par son identifiant
     */
    async deleteTask(taskId) {
      if (this.db) {
        return new Promise((resolve) => {
          try {
            const transaction = this.db.transaction([STORE_NAME], 'readwrite');
            const store = transaction.objectStore(STORE_NAME);
            const request = store.delete(taskId);

            request.onsuccess = () => resolve(true);
            request.onerror = () => {
              this._deleteLocalStorageTask(taskId);
              resolve(true);
            };
          } catch (e) {
            this._deleteLocalStorageTask(taskId);
            resolve(true);
          }
        });
      }

      this._deleteLocalStorageTask(taskId);
      return true;
    }

    /* === MÉTODES DE SECOURS (FALLBACK LOCALSTORAGE) === */
    _getLocalStorageTasks() {
      try {
        const raw = localStorage.getItem(LS_KEY);
        return raw ? JSON.parse(raw) : [];
      } catch (e) {
        console.error('Erreur lecture localStorage:', e);
        return [];
      }
    }

    _saveLocalStorageTask(task) {
      try {
        const tasks = this._getLocalStorageTasks();
        const index = tasks.findIndex(t => t.id === task.id);
        if (index >= 0) {
          tasks[index] = task;
        } else {
          tasks.push(task);
        }
        localStorage.setItem(LS_KEY, JSON.stringify(tasks));
      } catch (e) {
        console.error('Erreur écriture localStorage:', e);
      }
    }

    _deleteLocalStorageTask(taskId) {
      try {
        let tasks = this._getLocalStorageTasks();
        tasks = tasks.filter(t => t.id !== taskId);
        localStorage.setItem(LS_KEY, JSON.stringify(tasks));
      } catch (e) {
        console.error('Erreur suppression localStorage:', e);
      }
    }
  }

  window.TaskDB = new StorageAdapter();
})(window);