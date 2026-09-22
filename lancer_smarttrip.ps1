param(
    [int]$Port = 8080
)

$ErrorActionPreference = "Continue"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "   SmartTrip Pro - Version Aboutie et Testable (@OPS)" -ForegroundColor Yellow
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Demarrage du serveur local..." -ForegroundColor Gray

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

$indexPath = Join-Path $root "index.html"
if (-not (Test-Path $indexPath)) {
    Write-Host "[ERREUR] index.html introuvable dans : $root" -ForegroundColor Red
    Read-Host "Appuyez sur Entree pour quitter"
    exit 1
}

$url = "http://localhost:$Port/index.html"

# Verifier si un serveur ecoute deja
$isBusy = $false
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $ar = $tcp.BeginConnect("127.0.0.1", $Port, $null, $null)
    $ok = $ar.AsyncWaitHandle.WaitOne(300)
    if ($ok -and $tcp.Connected) {
        $isBusy = $true
        $tcp.EndConnect($ar)
    }
    $tcp.Close()
} catch {}

if (-not $isBusy) {
    Write-Host "Lancement du serveur HTTP natif sur le port $Port..." -ForegroundColor Green
    
    $jobScript = {
        param($p, $wroot)
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://localhost:$p/")
        $listener.Start()
        
        $mimeMap = @{
            ".html" = "text/html; charset=utf-8"
            ".js" = "application/javascript; charset=utf-8"
            ".json" = "application/json; charset=utf-8"
            ".webmanifest" = "application/manifest+json; charset=utf-8"
            ".svg" = "image/svg+xml"
            ".png" = "image/png"
            ".css" = "text/css; charset=utf-8"
        }
        
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            $urlPath = $request.Url.LocalPath.TrimStart('/')
            if (-not $urlPath) { $urlPath = "index.html" }
            $filePath = Join-Path $wroot $urlPath
            
            if (Test-Path $filePath -PathType Leaf) {
                $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
                $mime = if ($mimeMap.ContainsKey($ext)) { $mimeMap[$ext] } else { "application/octet-stream" }
                $bytes = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentType = $mime
                $response.ContentLength64 = $bytes.Length
                $response.StatusCode = 200
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            } else {
                $response.StatusCode = 404
                $err = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
                $response.OutputStream.Write($err, 0, $err.Length)
            }
            $response.OutputStream.Close()
        }
    }
    
    Start-Job -ScriptBlock $jobScript -ArgumentList $Port, $root -Name "SmartTripProServer_$Port" | Out-Null
    Start-Sleep -Milliseconds 800
} else {
    Write-Host "Un serveur ecoute deja sur le port $Port." -ForegroundColor Green
}

Write-Host "Ouverture automatique de votre navigateur par defaut..." -ForegroundColor Cyan
Start-Process $url

Write-Host "`n======================================================================" -ForegroundColor Green
Write-Host "  APPLICATION EN LIGNE ET DISPONIBLE POUR LE TEST !" -ForegroundColor Green
Write-Host "  URL locale : $url" -ForegroundColor White
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "  - 10 comparateurs operationnels (Google Hotels, Booking, Airbnb, etc.)" -ForegroundColor Gray
Write-Host "  - Fiches hebergements detaillees (#hotelDetailModal)" -ForegroundColor Gray
Write-Host "  - Filtrage budget strict (0 depassement) et rayon kilometrique" -ForegroundColor Gray
Write-Host "  - Persistance Offline-First (IndexedDB / localStorage) et PWA" -ForegroundColor Gray
Write-Host "`n(Laissez cette fenetre ouverte pendant vos tests)`n" -ForegroundColor DarkGray
Read-Host "Appuyez sur Entree pour arreter le serveur"

# Nettoyage des jobs
Get-Job -Name "SmartTripProServer_$Port" -ErrorAction SilentlyContinue | Stop-Job | Remove-Job
