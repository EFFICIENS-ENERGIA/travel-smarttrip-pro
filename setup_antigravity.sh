#!/usr/bin/env bash
# ==============================================================================
# Script d'installation automatique pour la configuration d'équipe multi-agents
# et son Lead Tech Trainer sur Google Antigravity
# ==============================================================================
set -e

echo "🚀 Initialisation de la structure Antigravity..."

# Création des répertoires requis
mkdir -p .agents/rules
mkdir -p .agents/workflows
mkdir -p .agents/skills/dev-core-engine
mkdir -p .agents/skills/aud-qa-security
mkdir -p .agents/skills/uix-design-system
mkdir -p .agents/skills/ops-devops-resilience
mkdir -p .agents/docs

echo "✅ Arborescence créée avec succès."
echo "💡 Ouvrez Google Antigravity et utilisez '/traincycle' pour démarrer l'entraînement de l'équipe !"