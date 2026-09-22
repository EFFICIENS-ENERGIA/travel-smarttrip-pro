<#
.SYNOPSIS
    Moteur de recherche et d'agrégation d'hébergements multi-plateformes (Top 10 mondial).

.DESCRIPTION
    Génère des requêtes et liens profonds pour le Top 10 des plateformes mondiales.
    Enrichit automatiquement chaque recherche avec les cours de devises (Frankfurter API)
    et la météo prévisionnelle (Open-Meteo API) via des micro-APIs 100% libres sans clé.

.PARAMETER Location
    Ville, adresse ou lieu d'intérêt.

.PARAMETER CheckIn
    Date d'arrivée au format YYYY-MM-DD.

.PARAMETER CheckOut
    Date de départ au format YYYY-MM-DD.

.PARAMETER Guests
    Nombre de voyageurs adultes (par défaut : 2).

.PARAMETER Rooms
    Nombre de chambres (par défaut : 1).

.PARAMETER LodgingType
    Type de logement : 'Both', 'Hotel', 'Apartment'.

.PARAMETER MaxBudget
    Budget maximum par nuit en euros (optionnel).

.PARAMETER AsJson
    Si activé, retourne les résultats au format JSON structuré.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Location,

    [Parameter(Mandatory = $false)]
    [string]$CheckIn,

    [Parameter(Mandatory = $false)]
    [string]$CheckOut,

    [Parameter(Mandatory = $false)]
    [int]$Guests = 2,

    [Parameter(Mandatory = $false)]
    [int]$Rooms = 1,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Both", "Hotel", "Apartment")]
    [string]$LodgingType = "Both",

    [Parameter(Mandatory = $false)]
    [int]$MinBudget = 0,

    [Parameter(Mandatory = $false)]
    [int]$MaxBudget = 0,

    [Parameter(Mandatory = $false)]
    [string]$Landmark = "",

    [Parameter(Mandatory = $false)]
    [double]$MaxDistanceKm = 0,

    [Parameter(Mandatory = $false)]
    [switch]$AsJson
)

# Configuration des dates
if (-not $CheckIn) {
    $CheckInDate = (Get-Date).AddDays(14)
    $CheckIn = $CheckInDate.ToString("yyyy-MM-dd")
} else {
    $CheckInDate = [DateTime]::ParseExact($CheckIn, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
}

if (-not $CheckOut) {
    $CheckOutDate = $CheckInDate.AddDays(3)
    $CheckOut = $CheckOutDate.ToString("yyyy-MM-dd")
} else {
    $CheckOutDate = [DateTime]::ParseExact($CheckOut, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
}

$Nights = ($CheckOutDate - $CheckInDate).Days
if ($Nights -le 0) {
    Write-Error "La date de depart (CheckOut) doit etre posterieure a la date d'arrivee (CheckIn)."
    return
}

# Encodage console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Encodage de la localisation et du point de repere
$TargetLocation = if ($Landmark) { "$Landmark, $Location" } else { $Location }
$EncodedLocation = [System.Uri]::EscapeDataString($TargetLocation)
$EncodedLocationPlus = $TargetLocation -replace '\s+', '+'

# 1. Google Hotels
$GoogleHotelsUrl = "https://www.google.com/travel/hotels?q=${EncodedLocationPlus}&dates=${CheckIn}%2C${CheckOut}&adults=${Guests}"
if ($MinBudget -gt 0) { $GoogleHotelsUrl += "&min_price=$MinBudget" }
if ($MaxBudget -gt 0) { $GoogleHotelsUrl += "&max_price=$MaxBudget" }

# 2. Booking.com
$BookingUrl = "https://www.booking.com/searchresults.html?ss=${EncodedLocationPlus}&checkin=${CheckIn}&checkout=${CheckOut}&group_adults=${Guests}&no_rooms=${Rooms}&group_children=0&sb=1&sb_lp=1&src=searchbox&src_elem=sb&lang=fr"
if ($MinBudget -gt 0 -and $MaxBudget -gt 0) {
    $BookingUrl += "&nflt=price%3DEUR-$MinBudget-$MaxBudget-1"
} elseif ($MaxBudget -gt 0) {
    $BookingUrl += "&nflt=price%3DEUR-min-$MaxBudget-1"
} elseif ($MinBudget -gt 0) {
    $BookingUrl += "&nflt=price%3DEUR-$MinBudget-max-1"
}

# 3. Airbnb
$AirbnbUrl = "https://www.airbnb.fr/s/${EncodedLocationPlus}/homes?checkin=${CheckIn}&checkout=${CheckOut}&adults=${Guests}"
if ($MinBudget -gt 0) { $AirbnbUrl += "&price_min=$MinBudget" }
if ($MaxBudget -gt 0) { $AirbnbUrl += "&price_max=$MaxBudget" }

# 4. HomeToGo
$HomeToGoUrl = "https://www.hometogo.fr/search?destination=${EncodedLocation}&checkIn=${CheckIn}&checkOut=${CheckOut}&adults=${Guests}"

# 5. Agoda
$AgodaUrl = "https://www.agoda.com/fr-fr/search?text=${EncodedLocationPlus}&checkIn=${CheckIn}&checkOut=${CheckOut}&rooms=${Rooms}&adults=${Guests}"
if ($MinBudget -gt 0) { $AgodaUrl += "&minprice=$MinBudget" }
if ($MaxBudget -gt 0) { $AgodaUrl += "&maxprice=$MaxBudget" }

# 6. Expedia
$ExpediaUrl = "https://www.expedia.fr/Hotel-Search?destination=${EncodedLocationPlus}&startDate=${CheckIn}&endDate=${CheckOut}&adults=${Guests}"
if ($MinBudget -gt 0) { $ExpediaUrl += "&f-price-min=$MinBudget" }
if ($MaxBudget -gt 0) { $ExpediaUrl += "&f-price-max=$MaxBudget" }

# 7. Abritel / Vrbo
$AbritelUrl = "https://www.abritel.fr/search?destination=${EncodedLocationPlus}&startDate=${CheckIn}&endDate=${CheckOut}&adults=${Guests}"
if ($MinBudget -gt 0) { $AbritelUrl += "&minPrice=$MinBudget" }
if ($MaxBudget -gt 0) { $AbritelUrl += "&maxPrice=$MaxBudget" }

# 8. Trip.com
$TripComUrl = "https://fr.trip.com/hotels/list?city=${EncodedLocationPlus}&checkin=${CheckIn}&checkout=${CheckOut}&adult=${Guests}"

# 9. Hostelworld
$HostelworldUrl = "https://www.hostelworld.com/fr/st/auberges-de-jeunesse/${EncodedLocationPlus}/"

# 10. Kayak
$KayakUrl = "https://www.kayak.fr/hotels/${EncodedLocationPlus}/${CheckIn}/${CheckOut}/${Guests}guests"

# Detection de zone geographique
$AsianKeywords = @("japon", "tokyo", "kyoto", "osaka", "thailande", "bangkok", "phuket", "bali", "indonesie", "vietnam", "chine", "coree", "seoul", "singapour", "malaisie", "philippines", "inde", "dubai", "emirats", "asie", "asia")
$AmericasKeywords = @("usa", "etats-unis", "united states", "new york", "miami", "los angeles", "san francisco", "floride", "canada", "quebec", "montreal", "mexique", "bresil", "colombie", "amerique")

$IsAsia = $false
foreach ($kw in $AsianKeywords) {
    if ($Location.ToLower() -match $kw) { $IsAsia = $true; break }
}

$IsAmericas = $false
foreach ($kw in $AmericasKeywords) {
    if ($Location.ToLower() -match $kw) { $IsAmericas = $true; break }
}

# --- ENRICHISSEMENT OPEN DATA (SANS CLE NI COMPTE) ---

# 1. Devises (Frankfurter API)
$CurrencyInfo = $null
$CurrencyMap = @{
    "USD" = @("usa", "etats-unis", "united states", "new york", "miami", "los angeles", "san francisco", "floride", "hawaii", "vegas", "californie")
    "GBP" = @("uk", "angleterre", "royaume-uni", "londres", "london", "ecosse", "edimbourg", "manchester", "liverpool")
    "JPY" = @("japon", "japan", "tokyo", "kyoto", "osaka", "hokkaido", "okinawa")
    "CHF" = @("suisse", "switzerland", "geneve", "zurich", "lausanne", "bale", "berne")
    "CAD" = @("canada", "montreal", "quebec", "toronto", "vancouver")
    "AUD" = @("australie", "australia", "sydney", "melbourne", "brisbane")
    "THB" = @("thailande", "thailand", "bangkok", "phuket", "chiang mai", "samui", "pattaya")
    "MAD" = @("maroc", "morocco", "marrakech", "casablanca", "agadir", "rabat", "fes")
    "PLN" = @("pologne", "poland", "varsovie", "warsaw", "cracovie", "krakow")
    "CZK" = @("republique tcheque", "tchequie", "prague", "praha")
    "HUF" = @("hongrie", "hungary", "budapest")
}

$TargetCurrency = $null
foreach ($curr in $CurrencyMap.Keys) {
    foreach ($keyword in $CurrencyMap[$curr]) {
        if ($Location.ToLower() -match $keyword) {
            $TargetCurrency = $curr
            break
        }
    }
    if ($TargetCurrency) { break }
}

if ($TargetCurrency) {
    try {
        $RatesResponse = Invoke-RestMethod -Uri "https://api.frankfurter.app/latest?from=EUR&to=$TargetCurrency" -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($RatesResponse -and $RatesResponse.rates -and $RatesResponse.rates.$TargetCurrency) {
            $Rate = [math]::Round([double]$RatesResponse.rates.$TargetCurrency, 2)
            $Reverse = [math]::Round((100 / $Rate), 2)
            $CurrencyInfo = [PSCustomObject]@{
                Currency    = $TargetCurrency
                RateToEur   = $Rate
                Summary     = "1 EUR = $Rate $TargetCurrency (100 $TargetCurrency ≈ $Reverse EUR)"
            }
        }
    } catch {}
}

# 2. Meteo (Open-Meteo API)
$WeatherInfo = $null
try {
    $CleanCity = ($Location -split ',')[0].Trim()
    $EscapedCity = [System.Uri]::EscapeDataString($CleanCity)
    $GeoUrl = "https://geocoding-api.open-meteo.com/v1/search?name=${EscapedCity}&count=1&language=fr&format=json"
    $GeoResponse = Invoke-RestMethod -Uri $GeoUrl -TimeoutSec 3 -ErrorAction SilentlyContinue


    if ($GeoResponse -and $GeoResponse.results -and $GeoResponse.results.Count -gt 0) {
        $Place = $GeoResponse.results[0]
        $Lat = $Place.latitude
        $Lon = $Place.longitude
        $CityName = $Place.name
        $CountryName = $Place.country

        $ForecastUrl = "https://api.open-meteo.com/v1/forecast?latitude=$Lat&longitude=$Lon&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"
        $WeatherResponse = Invoke-RestMethod -Uri $ForecastUrl -TimeoutSec 3 -ErrorAction SilentlyContinue

        if ($WeatherResponse -and $WeatherResponse.daily) {
            $MinTemp = [math]::Round([double]$WeatherResponse.daily.temperature_2m_min[0], 1)
            $MaxTemp = [math]::Round([double]$WeatherResponse.daily.temperature_2m_max[0], 1)
            $WCode = $WeatherResponse.daily.weathercode[0]

            $WeatherDesc = switch ($WCode) {
                0 { "Ensoleille / Ciel degage" }
                { $_ -in 1, 2, 3 } { "Eclaircies / Partiellement nuageux" }
                { $_ -in 45, 48 } { "Brouillard" }
                { $_ -in 51, 53, 55, 61, 63, 65, 80, 81, 82 } { "Averses / Pluie" }
                { $_ -in 71, 73, 75, 85, 86 } { "Neige" }
                { $_ -in 95, 96, 99 } { "Risque d'orage" }
                default { "Temps variable" }
            }

            $WeatherInfo = [PSCustomObject]@{
                City        = $CityName
                Country     = $CountryName
                MinTemp     = "$MinTemp C"
                MaxTemp     = "$MaxTemp C"
                Condition   = $WeatherDesc
                Summary     = "$CityName ($CountryName) : $MinTemp C a $MaxTemp C - $WeatherDesc"
            }
        }
    }
} catch {}

# Structure de donnees
$ResultObject = [PSCustomObject]@{
    Destination     = $Location
    CheckIn         = $CheckIn
    CheckOut        = $CheckOut
    Nights          = $Nights
    Guests          = $Guests
    Rooms           = $Rooms
    LodgingType     = $LodgingType
    IsAsia          = $IsAsia
    IsAmericas      = $IsAmericas
    BudgetRange     = if ($MinBudget -gt 0 -and $MaxBudget -gt 0) { "$MinBudget EUR a $MaxBudget EUR / nuit" } elseif ($MaxBudget -gt 0) { "Jusqu'a $MaxBudget EUR / nuit" } elseif ($MinBudget -gt 0) { "A partir de $MinBudget EUR / nuit" } else { "Tous budgets" }
    LiveEnrichment  = [PSCustomObject]@{
        Currency    = $CurrencyInfo
        Weather     = $WeatherInfo
    }
    Top10Platforms  = [PSCustomObject]@{
        "1_Booking"     = [PSCustomObject]@{ Rank = 1; Name = "Booking.com"; Speciality = "Leader mondial hotels et appartements"; Url = $BookingUrl }
        "2_Airbnb"      = [PSCustomObject]@{ Rank = 2; Name = "Airbnb"; Speciality = "Locations particuliers et logements uniques"; Url = $AirbnbUrl }
        "3_GoogleHotels"= [PSCustomObject]@{ Rank = 3; Name = "Google Hotels"; Speciality = "Meta-moteur comparateur tous sites"; Url = $GoogleHotelsUrl }
        "4_HomeToGo"    = [PSCustomObject]@{ Rank = 4; Name = "HomeToGo"; Speciality = "Meta-moteur locations (Airbnb, Vrbo, etc.)"; Url = $HomeToGoUrl }
        "5_Agoda"       = [PSCustomObject]@{ Rank = 5; Name = "Agoda"; Speciality = "N1 Asie-Pacifique et tarifs negocies"; Url = $AgodaUrl }
        "6_Expedia"     = [PSCustomObject]@{ Rank = 6; Name = "Expedia"; Speciality = "N1 Amerique du Nord et packages complets"; Url = $ExpediaUrl }
        "7_AbritelVrbo" = [PSCustomObject]@{ Rank = 7; Name = "Abritel / Vrbo"; Speciality = "Grandes maisons de vacances et villas"; Url = $AbritelUrl }
        "8_TripCom"     = [PSCustomObject]@{ Rank = 8; Name = "Trip.com"; Speciality = "Reservations Asie et international"; Url = $TripComUrl }
        "9_Hostelworld" = [PSCustomObject]@{ Rank = 9; Name = "Hostelworld"; Speciality = "Auberges de jeunesse et petits budgets"; Url = $HostelworldUrl }
        "10_Kayak"      = [PSCustomObject]@{ Rank = 10; Name = "Kayak"; Speciality = "Comparateur global multi-fournisseurs"; Url = $KayakUrl }
    }
}

if ($AsJson) {
    $ResultObject | ConvertTo-Json -Depth 4
    return
}

# Bloc meteo et devises
$EnrichmentMarkdown = ""
if ($WeatherInfo -or $CurrencyInfo) {
    $EnrichmentMarkdown += "`n### Informations Voyage en direct (Micro-APIs Libres)`n"
    if ($WeatherInfo) {
        $EnrichmentMarkdown += "- Meteo prevue : $($WeatherInfo.Summary)`n"
    }
    if ($CurrencyInfo) {
        $EnrichmentMarkdown += "- Taux de change en direct : $($CurrencyInfo.Summary)`n"
    }
}

# Rendu Markdown
$MarkdownOutput = @"
# Recherche multi-plateformes (Top 10 Mondial) : $Location
**Dates :** Du $CheckIn au $CheckOut ($Nights nuit$(if ($Nights -gt 1) {'s'} else {''}))  
**Voyageurs :** $Guests personne$(if ($Guests -gt 1) {'s'} else {''}) - $Rooms chambre$(if ($Rooms -gt 1) {'s'} else {''})  
**Budget cible :** $(if ($MinBudget -gt 0 -and $MaxBudget -gt 0) {"$MinBudget EUR a $MaxBudget EUR / nuit"} elseif ($MaxBudget -gt 0) {"Jusqu'a $MaxBudget EUR / nuit"} elseif ($MinBudget -gt 0) {"A partir de $MinBudget EUR / nuit"} else {"Illimite / Tous budgets"})
$(if ($IsAsia) {"`n> Recommandation Asie : Agoda et Trip.com sont prioritaires pour cette destination (tarifs souvent 15% a 30% inferieurs)."} else {''})
$(if ($IsAmericas) {"`n> Recommandation Amerique : Expedia et Abritel/VRBO sont prioritaires. Attention aux Resort Fees."} else {''})
$EnrichmentMarkdown
---

### Le Top 10 Mondial des Plateformes de Location

| Rang | Plateforme | Specialite et Super-pouvoir | Lien d'acces pre-configure |
| :---: | :--- | :--- | :--- |
| 1 | **Google Hotels** | Meta-moteur qui compare tous les prix du web en direct | [Ouvrir Google Hotels]($GoogleHotelsUrl) |
| 2 | **Booking.com** | Leader mondial hotels et appartements (trie par prix) | [Ouvrir Booking.com]($BookingUrl) |
| 3 | **Airbnb** | N1 locations chez des particuliers et logements uniques | [Ouvrir Airbnb]($AirbnbUrl) |
| 4 | **HomeToGo** | Meta-moteur locations (agrege Airbnb, Abritel, Vrbo) | [Ouvrir HomeToGo]($HomeToGoUrl) |
| 5 | **Agoda** | $(if ($IsAsia) {'**LEADER ASIE (Prioritaire)**'} else {'N1 Asie-Pacifique et tarifs negocies'}) | [Ouvrir Agoda]($AgodaUrl) |
| 6 | **Expedia** | $(if ($IsAmericas) {'**LEADER AMERIQUE (Prioritaire)**'} else {'N1 Amerique du Nord et forfaits'}) | [Ouvrir Expedia]($ExpediaUrl) |
| 7 | **Abritel / Vrbo** | Specialiste grandes maisons de vacances et villas | [Ouvrir Abritel]($AbritelUrl) |
| 8 | **Trip.com** | Geant asiatique et mondial tres agressif sur les prix | [Ouvrir Trip.com]($TripComUrl) |
| 9 | **Hostelworld** | Auberges de jeunesse, chambres partagees et petits budgets | [Ouvrir Hostelworld]($HostelworldUrl) |
| 10 | **Kayak** | Comparateur de prix multi-fournisseurs avec carte | [Ouvrir Kayak]($KayakUrl) |

---

### Recommandations de l'agent
1. **Pour les hotels et appart'hotels :** Consultez en priorite le lien **Google Hotels** pour identifier qui vend la chambre le moins cher.
2. **Pour les appartements independants :** Le lien **HomeToGo** regroupe toutes les annonces Airbnb et Abritel sans chercher separement.
3. **Bouclier d'annulation :** Cochez le filtre « Annulation gratuite » des l'ouverture des liens pour comparer les deux tarifs.
"@

Write-Output $MarkdownOutput
