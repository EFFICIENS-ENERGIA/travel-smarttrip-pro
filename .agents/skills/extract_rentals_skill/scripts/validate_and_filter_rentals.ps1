param(
    [string]$InputPath = "scratch/raw_rentals.json",
    [string]$OutputPath = "production_artifacts/rentals_extracted.json",
    [double]$UserMaxBudget = 150.0,
    [int]$TimeoutSec = 5
)

$ErrorActionPreference = "Continue"

function Test-ListingUrl {
    param([string]$Url, [int]$TimeoutSec = 5)
    
    if (-not $Url -or -not ($Url.StartsWith("http://") -or $Url.StartsWith("https://"))) {
        return @{ IsValid = $false; StatusCode = 400 }
    }
    
    try {
        $req = [System.Net.HttpWebRequest]::Create($Url)
        $req.Method = "GET"
        $req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        $req.Timeout = $TimeoutSec * 1000
        $req.AllowAutoRedirect = $true
        $req.MaximumAutomaticRedirections = 5
        
        $resp = $req.GetResponse()
        $code = [int]$resp.StatusCode
        $resp.Close()
        
        $isValid = ($code -ge 200 -and $code -lt 400)
        return @{ IsValid = $isValid; StatusCode = $code }
    } catch [System.Net.WebException] {
        $resp = $_.Exception.Response
        if ($resp) {
            $code = [int]$resp.StatusCode
            $resp.Close()
            # 403 et 429 correspondent aux challenges anti-bot WAF sur bot sans session, mais sont des URLs valides
            if ($code -eq 403 -or $code -eq 429) {
                return @{ IsValid = $true; StatusCode = $code }
            }
            return @{ IsValid = $false; StatusCode = $code }
        } else {
            return @{ IsValid = $false; StatusCode = $null }
        }
    } catch {
        return @{ IsValid = $false; StatusCode = $null }
    }
}

Write-Host "Demarrage du filtrage de budget ($UserMaxBudget EUR) et validation HTTP..." -ForegroundColor Cyan

if (-not (Test-Path $InputPath)) {
    Write-Error "Fichier introuvable : $InputPath"
    exit 1
}

$rawJson = Get-Content -Path $InputPath -Raw -Encoding UTF8
$data = $rawJson | ConvertFrom-Json

$data | Add-Member -MemberType NoteProperty -Name "user_max_budget_eur" -Value $UserMaxBudget -Force

$validListings = [System.Collections.ArrayList]::new()
$overBudgetSuggestions = [System.Collections.ArrayList]::new()

$items = if ($data.listings) { $data.listings } else { @() }

foreach ($item in $items) {
    $url = $item.url
    $price = $item.price_per_night_eur
    
    $check = Test-ListingUrl -Url $url -TimeoutSec $TimeoutSec
    $item | Add-Member -MemberType NoteProperty -Name "is_url_verified" -Value $check.IsValid -Force
    $item | Add-Member -MemberType NoteProperty -Name "http_status" -Value $check.StatusCode -Force
    
    # Rejet immediat des liens casses
    if (-not $check.IsValid) {
        Write-Host "  [REJETE - LIEN CASSE] $($item.title) (Code: $($check.StatusCode))" -ForegroundColor Red
        continue
    }
    
    # Filtrage deterministe du budget
    if ($null -ne $price) {
        $p = [double]$price
        if ($p -le $UserMaxBudget) {
            $item | Add-Member -MemberType NoteProperty -Name "is_over_budget_suggestion" -Value $false -Force
            [void]$validListings.Add($item)
            Write-Host "  [ACCEPTE] $($item.title) -> $p EUR <= $UserMaxBudget EUR" -ForegroundColor Green
        } elseif ($p -le ($UserMaxBudget * 1.05)) {
            $item | Add-Member -MemberType NoteProperty -Name "is_over_budget_suggestion" -Value $true -Force
            [void]$overBudgetSuggestions.Add($item)
            Write-Host "  [SUGGESTION +5%] $($item.title) -> $p EUR (Max: $([Math]::Round($UserMaxBudget * 1.05, 2)) EUR)" -ForegroundColor Yellow
        } else {
            Write-Host "  [EXCLU - HORS BUDGET] $($item.title) -> $p EUR > $([Math]::Round($UserMaxBudget * 1.05, 2)) EUR" -ForegroundColor DarkGray
        }
    }
}

$data.listings = @($validListings)
$data | Add-Member -MemberType NoteProperty -Name "over_budget_suggestions" -Value @($overBudgetSuggestions) -Force
$data | Add-Member -MemberType NoteProperty -Name "total_valid_listings" -Value $validListings.Count -Force

$status = "NO_MATCH_UNDER_BUDGET"
if ($validListings.Count -gt 0) {
    $status = "SUCCESS"
} elseif ($overBudgetSuggestions.Count -gt 0) {
    $status = "PARTIAL_MATCH"
}
$data | Add-Member -MemberType NoteProperty -Name "search_status" -Value $status -Force

# Sauvegarde
$outDir = Split-Path $OutputPath -Parent
if ($outDir -and -not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$data | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "`nResultat : $($validListings.Count) logements valides, $($overBudgetSuggestions.Count) suggestions hors budget. Statut: $status" -ForegroundColor Green
Write-Host "Artefact genere : $OutputPath" -ForegroundColor Green
