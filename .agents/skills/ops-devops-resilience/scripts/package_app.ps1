param(
    [string]$RootDir = "."
)

$ErrorActionPreference = "Continue"

Write-Host "=========================================================================="
Write-Host "PACKAGE ET INTEGRITY CHECK - SMARTTRIP PRO (@OPS)"
Write-Host "=========================================================================="

$dashPath = Join-Path $RootDir "travel_dashboard.html"
$indexPath = Join-Path $RootDir "index.html"
$swPath = Join-Path $RootDir "sw.js"
$manifestPath = Join-Path $RootDir "manifest.webmanifest"
$icon192 = Join-Path $RootDir "icon-192.svg"
$icon512 = Join-Path $RootDir "icon-512.svg"

$errors = 0

# 1. Vérification des fichiers vitaux
Write-Host "`n1. Verification des fichiers obligatoires..." -ForegroundColor Cyan
$requiredFiles = @($dashPath, $indexPath, $swPath, $manifestPath, $icon192, $icon512)
foreach ($f in $requiredFiles) {
    if (Test-Path $f) {
        $size = (Get-Item $f).Length
        Write-Host "  [OK] $(Split-Path $f -Leaf) present ($size octets)" -ForegroundColor Green
    } else {
        Write-Host "  [ERR] Fichier MANQUANT : $(Split-Path $f -Leaf)" -ForegroundColor Red
        $errors++
    }
}

# 2. Vérification de la parité binaire (Règles 04 & 11)
Write-Host "`n2. Verification de la parite binaire miroir (travel_dashboard.html <-> index.html)..." -ForegroundColor Cyan
if ((Test-Path $dashPath) -and (Test-Path $indexPath)) {
    $h1 = (Get-FileHash -Path $dashPath -Algorithm SHA256).Hash
    $h2 = (Get-FileHash -Path $indexPath -Algorithm SHA256).Hash
    $s1 = (Get-Item $dashPath).Length
    $s2 = (Get-Item $indexPath).Length
    
    if ($h1 -eq $h2 -and $s1 -eq $s2) {
        Write-Host "  [PASS] Parite binaire certifiee : SHA-256=$h1 ($s1 octets)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Divergence detectee entre travel_dashboard.html et index.html !" -ForegroundColor Red
        $errors++
    }
}

# 3. Validation du Manifeste Web
Write-Host "`n3. Validation du Manifeste Web..." -ForegroundColor Cyan
if (Test-Path $manifestPath) {
    try {
        $manifestJson = Get-Content -Path $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($manifestJson.start_url -and $manifestJson.display -eq "standalone" -and $manifestJson.icons.Count -ge 2) {
            Write-Host "  [PASS] Manifeste valide : display=$($manifestJson.display), icons=$($manifestJson.icons.Count)" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] Manifeste incomplet : verifier start_url ou icones." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [FAIL] Syntaxe JSON invalide dans manifest.webmanifest !" -ForegroundColor Red
        $errors++
    }
}

# 4. Validation du Service Worker
Write-Host "`n4. Validation du Service Worker (sw.js)..." -ForegroundColor Cyan
if (Test-Path $swPath) {
    $swContent = Get-Content -Path $swPath -Raw -Encoding UTF8
    $hasPrecache = $swContent.Contains("caches.open") -and $swContent.Contains("addAll")
    $hasFetch = $swContent.Contains("addEventListener('fetch'")
    $hasClaim = $swContent.Contains("clients.claim")
    
    if ($hasPrecache -and $hasFetch -and $hasClaim) {
        Write-Host "  [PASS] Service Worker structurellement complet (install, activate, fetch geres)" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Service Worker incomplet : verifier gestion du cycle de vie." -ForegroundColor Yellow
    }
}

Write-Host "`n=========================================================================="
if ($errors -eq 0) {
    Write-Host "RESULTAT DU PACKAGING : 100% SUCCES (APPLICATION PRETE AU DEPLOIEMENT)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "RESULTAT DU PACKAGING : $errors ERREURS DETECTEES" -ForegroundColor Red
    exit 1
}
