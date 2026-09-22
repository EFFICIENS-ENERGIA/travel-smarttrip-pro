param(
    [string]$InputPath = "scratch/raw_rentals.json",
    [string]$OutputPath = "production_artifacts/rentals_extracted.json",
    [int]$TimeoutSec = 5
)

if (-not (Test-Path $InputPath)) {
    Write-Error "Erreur : le fichier source $InputPath est introuvable."
    exit 1
}

$rawJson = Get-Content -Path $InputPath -Raw -Encoding UTF8
$data = $rawJson | ConvertFrom-Json

$listings = $data.listings
Write-Host "Validation HTTP de $($listings.Count) annonces via PowerShell..."

for ($i = 0; $i -lt $listings.Count; $i++) {
    $item = $listings[$i]
    $rawUrl = $item.url
    if ($rawUrl -and $rawUrl.StartsWith("http")) {
        try {
            $req = [System.Net.HttpWebRequest]::Create($rawUrl)
            $req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            $req.Timeout = $TimeoutSec * 1000
            $req.AllowAutoRedirect = $true
            $resp = $req.GetResponse()
            $code = [int]$resp.StatusCode
            $resp.Close()
            $item.is_url_verified = ($code -ge 200 -and $code -le 399)
            $item.http_status = $code
            Write-Host "  [$($i+1)/$($listings.Count)] HTTP $code -> $($rawUrl.Substring(0, [Math]::Min(70, $rawUrl.Length)))"
        } catch [System.Net.WebException] {
            $resp = $_.Exception.Response
            if ($resp) {
                $code = [int]$resp.StatusCode
                $item.is_url_verified = $false
                $item.http_status = $code
                Write-Host "  [$($i+1)/$($listings.Count)] HTTP $code -> $($rawUrl.Substring(0, [Math]::Min(70, $rawUrl.Length)))"
            } else {
                $item.is_url_verified = $false
                $item.http_status = $null
                Write-Host "  [$($i+1)/$($listings.Count)] TIMEOUT/ERR -> $($rawUrl.Substring(0, [Math]::Min(70, $rawUrl.Length)))"
            }
        } catch {
            $item.is_url_verified = $false
            $item.http_status = $null
            Write-Host "  [$($i+1)/$($listings.Count)] ERR -> $($rawUrl.Substring(0, [Math]::Min(70, $rawUrl.Length)))"
        }
    } else {
        $item.is_url_verified = $false
        $item.http_status = 400
        Write-Host "  [$($i+1)/$($listings.Count)] INVALID_URL -> $rawUrl"
    }
}

$outDir = Split-Path -Path (Resolve-Path -Path "." | Join-Path -ChildPath $OutputPath) -Parent
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$data | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "[OK] Fichier certifié écrit avec succès : $OutputPath"
