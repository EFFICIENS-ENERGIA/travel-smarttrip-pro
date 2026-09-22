/**
 * app.js — Logique Métier & Rendu UI du Task Manager PWA
 * Réalisé par @DEV (Développeur Senior Fullstack) avec correction Anti-XSS (Re-test PASSED)
 */

(function() {
  'use strict';

  // --- GARDE-FOU DE SÉCURITÉ ANTI-XSS OBLIGATOIRE ---
  function sanitizeHTML(str) {
    if (!str) return '';
    const temp = document.createElement('div');
    temp.textContent = String(str);
    return temp.innerHTML;
  }

  // --- ÉLÉMENTS DU DOM ---
  const taskForm = document.getElementById('taskForm');
  const taskTitleInput = document.getElementById('taskTitle');
  const taskDescInput = document.getElementById('taskDesc');
  const taskPrioritySelect = document.getElementById('taskPriority');
  const taskDueDateInput = document.getElementById('taskDueDate');
  const taskListElement = document.getElementById('taskList');
  const emptyStateElement = document.getElementById('emptyState');
  const filterStatusSelect = document.getElementById('filterStatus');
  const filterPrioritySelect = document.getElementById('filterPriority');
  const statusNotification = document.getElementById('statusNotification');
  const connectionStatusBadge = document.getElementById('connectionStatus');
  const themeToggleButton = document.getElementById('themeToggle');

  let activeFilter = {
    status: 'all',
    priority: 'all'
  };

  /**
   * Notification visuelle et accessible
   */
  function showNotification(message, type = 'info') {
    if (!statusNotification) return;
    statusNotification.textContent = message;
    statusNotification.className = `notification notification-${type} visible`;
    setTimeout(() => {
      statusNotification.className = 'notification';
      statusNotification.textContent = '';
    }, 3500);
  }

  /**
   * Met à jour le badge d'état réseau (Online/Offline)
   */
  function updateNetworkStatus() {
    if (!connectionStatusBadge) return;
    if (navigator.onLine) {
      connectionStatusBadge.textContent = '🟢 En Ligne';
      connectionStatusBadge.className = 'status-badge status-online';
    } else {
      connectionStatusBadge.textContent = '🟠 Mode Hors-Ligne';
      connectionStatusBadge.className = 'status-badge status-offline';
      showNotification('Vous travaillez actuellement en mode hors-ligne. Vos modifications sont sauvegardées localement.', 'warning');
    }
  }

  /**
   * Rendu complet et sécurisé de la liste des tâches (Protection Anti-XSS)
   */
  async function renderTasks() {
    try {
      const tasks = await window.TaskDB.getAllTasks();

      // Tri par date de création descendante
      tasks.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

      // Filtrage
      const filteredTasks = tasks.filter(task => {
        const matchesStatus = activeFilter.status === 'all' || task.status === activeFilter.status;
        const matchesPriority = activeFilter.priority === 'all' || task.priority === activeFilter.priority;
        return matchesStatus && matchesPriority;
      });

      taskListElement.innerHTML = '';

      if (filteredTasks.length === 0) {
        emptyStateElement.style.display = 'block';
        return;
      }

      emptyStateElement.style.display = 'none';

      filteredTasks.forEach(task => {
        const isDone = task.status === 'completed';
        const card = document.createElement('div');
        card.className = `task-card priority-${task.priority} ${isDone ? 'completed' : ''}`;
        card.setAttribute('data-id', task.id);

        // Construction sécurisée : échappement des champs utilisateurs
        const cleanTitle = sanitizeHTML(task.title);
        const cleanDesc = sanitizeHTML(task.description || 'Aucune description');
        const cleanDate = task.dueDate ? `📅 Échéance : ${sanitizeHTML(task.dueDate)}` : '';
        const priorityLabels = { low: 'Basse', medium: 'Moyenne', high: 'Haute' };
        const cleanPriority = priorityLabels[task.priority] || 'Normale';

        card.innerHTML = `
          <div class="task-header">
            <div class="task-title-group">
              <input type="checkbox" class="task-checkbox" aria-label="Marquer la tâche ${cleanTitle} comme terminée" ${isDone ? 'checked' : ''}>
              <h3 class="task-title">${cleanTitle}</h3>
            </div>
            <span class="badge priority-badge priority-${task.priority}">${cleanPriority}</span>
          </div>
          <p class="task-desc">${cleanDesc}</p>
          <div class="task-footer">
            <span class="task-date">${cleanDate}</span>
            <button class="btn-delete" aria-label="Supprimer la tâche ${cleanTitle}" data-action="delete">🗑️ Supprimer</button>
          </div>
        `;

        // Événement bascule terminée / en cours
        const checkbox = card.querySelector('.task-checkbox');
        checkbox.addEventListener('change', async () => {
          task.status = checkbox.checked ? 'completed' : 'pending';
          await window.TaskDB.saveTask(task);
          renderTasks();
          showNotification(checkbox.checked ? 'Tâche marquée comme terminée !' : 'Tâche réactivée.', 'success');
        });

        // Événement suppression
        const deleteBtn = card.querySelector('[data-action="delete"]');
        deleteBtn.addEventListener('click', async () => {
          await window.TaskDB.deleteTask(task.id);
          renderTasks();
          showNotification('Tâche supprimée avec succès.', 'info');
        });

        taskListElement.appendChild(card);
      });
    } catch (error) {
      console.error('Erreur de rendu des tâches:', error);
      showNotification('Erreur lors du chargement des tâches.', 'error');
    }
  }

  /**
   * Gestionnaire de soumission du formulaire
   */
  taskForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    const title = taskTitleInput.value.trim();
    if (!title) {
      showNotification('Veuillez renseigner un titre valide.', 'error');
      return;
    }

    const newTask = {
      id: 'task-' + Date.now() + '-' + Math.random().toString(36).substr(2, 6),
      title: title,
      description: taskDescInput.value.trim(),
      priority: taskPrioritySelect.value,
      dueDate: taskDueDateInput.value,
      status: 'pending',
      createdAt: new Date().toISOString()
    };

    await window.TaskDB.saveTask(newTask);
    taskForm.reset();
    renderTasks();
    showNotification('Nouvelle tâche enregistrée localement !', 'success');
  });

  // Filtres
  filterStatusSelect.addEventListener('change', (e) => {
    activeFilter.status = e.target.value;
    renderTasks();
  });

  filterPrioritySelect.addEventListener('change', (e) => {
    activeFilter.priority = e.target.value;
    renderTasks();
  });

  // Thème Sombre / Clair
  themeToggleButton.addEventListener('click', () => {
    const isDark = document.body.classList.toggle('dark-mode');
    themeToggleButton.textContent = isDark ? '☀️ Mode Clair' : '🌙 Mode Sombre';
    try {
      localStorage.setItem('taskmanager_theme', isDark ? 'dark' : 'light');
    } catch (e) {}
  });

  // Détection du thème enregistré
  try {
    if (localStorage.getItem('taskmanager_theme') === 'dark' || 
       (!localStorage.getItem('taskmanager_theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.body.classList.add('dark-mode');
      themeToggleButton.textContent = '☀️ Mode Clair';
    }
  } catch (e) {}

  // Événements Réseau
  window.addEventListener('online', updateNetworkStatus);
  window.addEventListener('offline', updateNetworkStatus);

  // Initialisation au chargement
  window.addEventListener('DOMContentLoaded', async () => {
    updateNetworkStatus();
    await window.TaskDB.init();
    renderTasks();
  });

})();