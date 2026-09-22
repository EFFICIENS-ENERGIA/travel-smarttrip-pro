/**
 * FailHonestState.js — Composant Standard d'État Vide & Repli Honnête (Règles 14 & 20)
 * Conforme WCAG AA / ARIA — Zéro hallucination, diagnostic explicite & méta-recherche directe.
 */
class FailHonestState {
  /**
   * Génère le balisage HTML accessible de l'état vide
   * @param {Object} options
   * @param {string} options.title Titre explicite
   * @param {string} options.description Raison exacte des critères non satisfaits
   * @param {string} [options.actionText] Libellé du bouton de réinitialisation
   * @param {Function|string} [options.onAction] Handler ou action JS
   * @param {string} [options.metaSearchUrl] URL de recherche externe 1-clic (ex: Google / Booking)
   * @param {string} [options.metaSearchText] Libellé du méta-comparateur
   * @returns {string} HTML string
   */
  static render({
    title = "Aucun établissement ne correspond exactement à vos critères",
    description = "Afin de respecter scrupuleusement votre budget et votre rayon, aucun résultat fictif n'est inventé.",
    actionText = "Élargir les filtres",
    onAction = "resetFilters()",
    metaSearchUrl = "",
    metaSearchText = "Lancer la recherche directe 1-clic sur les plateformes réelles"
  } = {}) {
    const metaButtonHtml = metaSearchUrl
      ? `<a href="${metaSearchUrl}" target="_blank" rel="noopener noreferrer" class="fail-honest-meta-btn" role="button">
          🔍 ${metaSearchText}
         </a>`
      : "";

    return `
      <div class="fail-honest-card" role="status" aria-live="polite">
        <div class="fail-honest-icon" aria-hidden="true">🛡️</div>
        <h3 class="fail-honest-title">${title}</h3>
        <p class="fail-honest-desc">${description}</p>
        <div class="fail-honest-actions">
          ${actionText ? `<button type="button" class="fail-honest-reset-btn" onclick="${onAction}">${actionText}</button>` : ""}
          ${metaButtonHtml}
        </div>
      </div>
    `;
  }
}

if (typeof module !== "undefined" && module.exports) {
  module.exports = FailHonestState;
} else if (typeof window !== "undefined") {
  window.FailHonestState = FailHonestState;
}
