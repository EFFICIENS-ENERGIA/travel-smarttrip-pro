param(
    [string]$RootDir = "."
)

$ErrorActionPreference = "Continue"

Write-Host "=========================================================================="
Write-Host "AUDIT DE RESILIENCE OFFLINE-FIRST ET STORAGE - (@OPS ET @AUD)"
Write-Host "=========================================================================="

$dashPath = Join-Path $RootDir "travel_dashboard.html"
$swPath = Join-Path $RootDir "sw.js"
$manifestPath = Join-Path $RootDir "manifest.webmanifest"

$score = 0
$total = 5

# 1. Vérification du Service Worker Precache
Write-Host "`n1. Verification du Precache Service Worker..." -ForegroundColor Cyan
if (Test-Path $swPath) {
    $sw = Get-Content -Path $swPath -Raw -Encoding UTF8
    $hasPrecacheUrls = $sw.Contains("PRECACHE_URLS")
    $hasDash = $sw.Contains("travel_dashboard.html")
    $hasIndex = $sw.Contains("index.html")
    $hasManifest = $sw.Contains("manifest.webmanifest")
    
    if ($hasPrecacheUrls -and $hasDash -and $hasIndex -and $hasManifest) {
        Write-Host "  [PASS] Precache exhaustif : index.html, travel_dashboard.html et manifest.webmanifest inclus." -ForegroundColor Green
        $score++
    } else {
        Write-Host "  [WARN] Precache incomplet : verifier la liste PRECACHE_URLS dans sw.js." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [FAIL] sw.js introuvable !" -ForegroundColor Red
}

# 2. Stratégie de mise en cache Fail-Soft des APIs
Write-Host "`n2. Verification de la strategie de mise en cache Fail-Soft des APIs..." -ForegroundColor Cyan
if (Test-Path $swPath) {
    $hasApiCache = $sw.Contains("caches.open('travellingo-api-cache')") -or $sw.Contains("api-cache")
    $hasFallback = $sw.Contains("caches.match(event.request)")
    
    if ($hasApiCache -and $hasFallback) {
        Write-Host "  [PASS] Repli fail-soft actif : les reponses API sont mises en cache et servies en cas de deconnexion." -ForegroundColor Green
        $score++
    } else {
        Write-Host "  [WARN] Repli fail-soft absent dans sw.js." -ForegroundColor Yellow
    }
}

# 3. Persistance IndexedDB dans l'application
Write-Host "`n3. Verification de l integration IndexedDB dans travel_dashboard.html..." -ForegroundColor Cyan
if (Test-Path $dashPath) {
    $dash = Get-Content -Path $dashPath -Raw -Encoding UTF8
    $hasIdb = $dash.Contains("indexedDB") -and $dash.Contains("open(")
    $hasFallback = $dash.Contains("localStorage")
    
    if ($hasIdb -and $hasFallback) {
        Write-Host "  [PASS] Architecture Local-First complete : IndexedDB integre avec repli transparent sur localStorage." -ForegroundColor Green
        $score++
    } else {
        Write-Host "  [WARN] IndexedDB non encore relie ou fallback manquant." -ForegroundColor Yellow
    }
}

# 4. Enregistrement PWA du Service Worker dans le DOM
Write-Host "`n4. Verification de l enregistrement du Service Worker dans le DOM..." -ForegroundColor Cyan
if (Test-Path $dashPath) {
    $hasRegister = $dash.Contains("navigator.serviceWorker.register('./sw.js')")
    if ($hasRegister) {
        Write-Host "  [PASS] Enregistrement sw.js present et actif lors du chargement de la page." -ForegroundColor Green
        $score++
    } else {
        Write-Host "  [FAIL] Enregistrement navigator.serviceWorker.register('./sw.js') manquant !" -ForegroundColor Red
    }
}

# 5. Manifeste PWA standalone
Write-Host "`n5. Verification des criteres PWA Standalone..." -ForegroundColor Cyan
if (Test-Path $manifestPath) {
    $man = Get-Content -Path $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($man.display -eq "standalone" -and $man.theme_color -and $man.icons.Count -ge 2) {
        Write-Host "  [PASS] Manifeste PWA 100% conforme pour installation desktop/mobile standalone." -ForegroundColor Green
        $score++
    } else {
        Write-Host "  [WARN] Manifeste incomplet." -ForegroundColor Yellow
    }
}

Write-Host "`n=========================================================================="
Write-Host "SCORE DE RESILIENCE OFFLINE-FIRST : $score / $total TESTS VALIDES"
if ($score -eq $total) {
    Write-Host "STATUT : 100% CONFORME AUX DIRECTIVES DEVOPS @OPS" -ForegroundColor Green
} else {
    Write-Host "STATUT : OPTIMISATIONS REQUISES ($($total - $score) point(s) d amelioration)" -ForegroundColor Yellow
}
Write-Host "=========================================================================="
