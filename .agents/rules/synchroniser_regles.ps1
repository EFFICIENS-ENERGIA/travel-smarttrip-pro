# Script de synchronisation automatique 1-clic des règles de Seb
$ErrorActionPreference = "SilentlyContinue"

$baseDir = "c:\Users\EFFICIENS ENERGIA\Desktop\ANTIGRAVITY"
$projectsRegles = Join-Path $baseDir "projects\REGLES"
$antigravityRegles = Join-Path $baseDir "REGLES"
$antigravityAgentsRules = Join-Path $baseDir ".agents\rules"
$currentProjectRegles = Join-Path $baseDir "`$HOMEagy2-projectsmy-first-project\REGLES"
$currentProjectAgentsRules = Join-Path $baseDir "`$HOMEagy2-projectsmy-first-project\.agents\rules"
$currentProjectProjectsRegles = Join-Path $baseDir "`$HOMEagy2-projectsmy-first-project\projects\REGLES"
$saasEfficiensRegles = Join-Path $baseDir "SAAS EFFICIENS ENERGIA\REGLES"
$saasEfficiensAgentsRules = Join-Path $baseDir "SAAS EFFICIENS ENERGIA\.agents\rules"
$globalConfigRules = "C:\Users\EFFICIENS ENERGIA\.gemini\config\rules"
$globalConfigRegles = "C:\Users\EFFICIENS ENERGIA\.gemini\config\REGLES"

Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "SYNCHRONISATION DES REGLES DE SEB SUR TOUS LES PROJETS & SYSTEMES" -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan

$destinations = @(
    $antigravityRegles,
    $antigravityAgentsRules,
    $currentProjectRegles,
    $currentProjectAgentsRules,
    $currentProjectProjectsRegles,
    $saasEfficiensRegles,
    $saasEfficiensAgentsRules,
    $globalConfigRules,
    $globalConfigRegles
)

foreach ($dest in $destinations) {
    if (-not (Test-Path $dest)) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }
    Copy-Item -Path (Join-Path $projectsRegles "*") -Destination $dest -Recurse -Force
    Write-Host "  [OK] Synchronise vers : $dest" -ForegroundColor Green
}

Write-Host "`nSucces : Toutes les regles de Seb sont propagees et actives !" -ForegroundColor Yellow
Start-Sleep -Seconds 3
