<#
.SYNOPSIS
    Vérifie si les dates de séjour tombent sur des jours fériés nationaux ou locaux via l'API ouverte Nager.Date (sans clé).

.DESCRIPTION
    Interroge l'API publique gratuite Nager.Date pour détecter les jours fériés officiels
    dans le pays de destination et évaluer l'impact sur les prix et disponibilités.

.PARAMETER Destination
    Nom de la ville ou du pays (ex: 'Rome', 'Tokyo', 'Madrid', 'France', 'IT').

.PARAMETER StartDate
    Date d'arrivée (format YYYY-MM-DD).

.PARAMETER EndDate
    Date de départ (format YYYY-MM-DD).

.EXAMPLE
    .\CheckPublicHolidays.ps1 -Destination "Rome" -StartDate "2026-04-24" -EndDate "2026-04-28"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Destination,

    [Parameter(Mandatory=$false)]
    [string]$StartDate = (Get-Date).AddDays(14).ToString("yyyy-MM-dd"),

    [Parameter(Mandatory=$false)]
    [string]$EndDate = (Get-Date).AddDays(19).ToString("yyyy-MM-dd")
)

# Table de correspondance Ville / Région -> Code Pays ISO
$CityCountryMap = @{
    "rome" = "IT"; "milan" = "IT"; "florence" = "IT"; "venise" = "IT"; "italie" = "IT"; "italy" = "IT"
    "madrid" = "ES"; "barcelone" = "ES"; "seville" = "ES"; "espagne" = "ES"; "spain" = "ES"
    "tokyo" = "JP"; "kyoto" = "JP"; "osaka" = "JP"; "japon" = "JP"; "japan" = "JP"
    "londres" = "GB"; "london" = "GB"; "edimbourg" = "GB"; "royaume-uni" = "GB"; "uk" = "GB"
    "paris" = "FR"; "lyon" = "FR"; "marseille" = "FR"; "nice" = "FR"; "france" = "FR"
    "berlin" = "DE"; "munich" = "DE"; "allemagne" = "DE"; "germany" = "DE"
    "new york" = "US"; "los angeles" = "US"; "miami" = "US"; "usa" = "US"; "etats-unis" = "US"
    "montreal" = "CA"; "toronto" = "CA"; "canada" = "CA"
    "lisbonne" = "PT"; "porto" = "PT"; "portugal" = "PT"
    "bangkok" = "TH"; "phuket" = "TH"; "thailande" = "TH"; "thailand" = "TH"
    "athenes" = "GR"; "grece" = "GR"; "greece" = "GR"
    "amsterdam" = "NL"; "pays-bas" = "NL"; "netherlands" = "NL"
}

$destKey = $Destination.Trim().ToLower()
$countryCode = "FR"
if ($CityCountryMap.ContainsKey($destKey)) {
    $countryCode = $CityCountryMap[$destKey]
} elseif ($destKey.Length -eq 2) {
    $countryCode = $destKey.ToUpper()
}

$start = [DateTime]::Parse($StartDate)
$end = [DateTime]::Parse($EndDate)
$year = $start.Year
$nbNights = [int]($end - $start).TotalDays

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "SCAN DES JOURS FERIES ET PICS DE PRIX (Nager.Date API)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ("Destination : {0} (Code pays : {1})" -f $Destination, $countryCode) -ForegroundColor Gray
Write-Host ("Période     : du {0} au {1} ({2} nuits)" -f $start.ToString('dd/MM/yyyy'), $end.ToString('dd/MM/yyyy'), $nbNights) -ForegroundColor Gray

$apiUrl = "https://date.nager.at/api/v3/PublicHolidays/$year/$countryCode"

try {
    $holidays = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 6 -ErrorAction Stop
} catch {
    Write-Host "Impossible de joindre l'API Nager.Date. Mode secours activé." -ForegroundColor Yellow
    $holidays = @()
}

$matchingHolidays = @()
foreach ($h in $holidays) {
    $hDate = [DateTime]::Parse($h.date)
    if ($hDate -ge $start.AddDays(-1) -and $hDate -le $end.AddDays(1)) {
        $matchingHolidays += $h
    }
}

if ($matchingHolidays.Count -gt 0) {
    Write-Host ""
    Write-Host "ALERTE : JOUR(S) FERIE(S) DETECTE(S) PENDANT LE SEJOUR !" -ForegroundColor Red
    Write-Host "--------------------------------------------------------" -ForegroundColor DarkRed
    foreach ($item in $matchingHolidays) {
        $d = [DateTime]::Parse($item.date).ToString("dd/MM/yyyy")
        Write-Host ("  - {0} : {1} ({2})" -f $d, $item.localName, $item.name) -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "IMPACTS ET RECOMMANDATIONS :" -ForegroundColor Cyan
    Write-Host "  - Tarifs : Forte hausse probable sur Booking/Airbnb due a la demande locale." -ForegroundColor White
    Write-Host "  - Commerces : Fermeture fréquente des banques, musées ou transports réduits." -ForegroundColor White
    Write-Host "  - Stratégie : Réservez avec annulation gratuite IMMEDIATEMENT avant saturation." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "AUCUN JOUR FERIE NATIONAL DETECTE sur cette période." -ForegroundColor Green
    Write-Host "  Les prix et disponibilités devraient correspondre aux tarifs normaux de saison." -ForegroundColor Gray
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

return [PSCustomObject]@{
    Destination = $Destination
    CountryCode = $countryCode
    StartDate = $StartDate
    EndDate = $EndDate
    HasHoliday = ($matchingHolidays.Count -gt 0)
    Holidays = $matchingHolidays
}
