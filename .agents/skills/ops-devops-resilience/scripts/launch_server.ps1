param(
    [int]$Port = 8085,
    [string]$WebRoot = ".",
    [switch]$HealthCheckOnly
)

$ErrorActionPreference = "Continue"

Write-Host "=========================================================================="
Write-Host "SERVEUR LOCAL ET HEALTHCHECK PWA - SMARTTRIP PRO (@OPS)"
Write-Host "=========================================================================="

$resolvedRoot = (Resolve-Path $WebRoot).Path
$testUrl = "http://localhost:$Port/index.html"
$swUrl = "http://localhost:$Port/sw.js"

Write-Host "Racine du serveur : $resolvedRoot"
Write-Host "Port configure    : $Port"

# Vérification si un serveur tourne déjà sur ce port
$listener = $null
$isPortBusy = $false
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $ar = $tcp.BeginConnect("127.0.0.1", $Port, $null, $null)
    $success = $ar.AsyncWaitHandle.WaitOne(300)
    if ($success -and $tcp.Connected) {
        $isPortBusy = $true
        $tcp.EndConnect($ar)
    }
    $tcp.Close()
} catch {}

if ($isPortBusy) {
    Write-Host "  [INFO] Un serveur ecoute deja sur le port $Port. Execution du Healthcheck..." -ForegroundColor Yellow
} else {
    Write-Host "  [INFO] Demarrage du serveur statique natif PowerShell sur le port $Port..." -ForegroundColor Cyan
    
    # Création du serveur HTTP d'arrière-plan
    $jobScript = {
        param($p, $root)
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
            $filePath = Join-Path $root $urlPath
            
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
    
    Start-Job -ScriptBlock $jobScript -ArgumentList $Port, $resolvedRoot -Name "SmartTripServer_$Port" | Out-Null
    Start-Sleep -Milliseconds 800
}

# Healthcheck HTTP
Write-Host "`nTest de disponibilite HTTP (Healthcheck) :" -ForegroundColor Cyan
$sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $req = [System.Net.HttpWebRequest]::Create($testUrl)
    $req.Timeout = 4000
    $resp = $req.GetResponse()
    $sw.Stop()
    $code = [int]$resp.StatusCode
    $resp.Close()
    
    if ($code -eq 200) {
        Write-Host "  [PASS] Index principal accessible : $testUrl -> HTTP 200 ($($sw.ElapsedMilliseconds) ms)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Reponse anormale : HTTP $code" -ForegroundColor Red
    }
} catch {
    Write-Host "  [FAIL] Serveur inaccessible a $testUrl ($($_.Exception.Message))" -ForegroundColor Red
}

try {
    $sw2 = [System.Diagnostics.Stopwatch]::StartNew()
    $req2 = [System.Net.HttpWebRequest]::Create($swUrl)
    $req2.Timeout = 4000
    $resp2 = $req2.GetResponse()
    $sw2.Stop()
    $code2 = [int]$resp2.StatusCode
    $resp2.Close()
    
    if ($code2 -eq 200) {
        Write-Host "  [PASS] Service Worker accessible  : $swUrl -> HTTP 200 ($($sw2.ElapsedMilliseconds) ms)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Service Worker inaccessible : HTTP $code2" -ForegroundColor Red
    }
} catch {
    Write-Host "  [FAIL] sw.js inaccessible a $swUrl ($($_.Exception.Message))" -ForegroundColor Red
}

Write-Host "`nServeur pret pour les tests d integration et l audit Offline-First." -ForegroundColor Green
