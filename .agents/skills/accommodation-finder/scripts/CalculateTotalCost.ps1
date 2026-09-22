<#
.SYNOPSIS
    Calculateur de Coût Réel Tout Compris (TCO - Total Cost of Stay).

.DESCRIPTION
    Calcule le montant réel global d'un hébergement sans frais cachés en intégrant :
    Prix de base + Frais de ménage + Taxes de séjour locales + Parking + Transports en commun + Resort fees.
    Permet de comparer loyalement un Airbnb et un Hôtel classique.

.PARAMETER AccommodationName
    Nom de l'hébergement (ex: 'Airbnb Centre' ou 'Hôtel Éclipse').

.PARAMETER BasePricePerNight
    Tarif de base affiché par nuit en euros.

.PARAMETER Nights
    Nombre de nuits du séjour.

.PARAMETER Guests
    Nombre total de voyageurs.

.PARAMETER CleaningFee
    Frais fixes de ménage (courant sur Airbnb/Abritel).

.PARAMETER CityTaxPerPersonPerNight
    Taxe de séjour municipale par personne et par nuit (ex: 2.50 € à Rome ou 3.00 € en Espagne).

.PARAMETER ParkingPerDay
    Frais journaliers de parking pour la voiture.

.PARAMETER TransitPerPersonPerDay
    Coût moyen journalier des transports en commun par voyageur (ex: 3.50 € de tickets métro).

.PARAMETER ExtraFeesPerNight
    Frais additionnels par nuit (ex: Resort / Amenity Fees aux USA).

.PARAMETER AsJson
    Si activé, retourne un objet JSON structuré.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$AccommodationName = "Hébergement",

    [Parameter(Mandatory = $true)]
    [double]$BasePricePerNight,

    [Parameter(Mandatory = $true)]
    [int]$Nights,

    [Parameter(Mandatory = $false)]
    [int]$Guests = 2,

    [Parameter(Mandatory = $false)]
    [double]$CleaningFee = 0,

    [Parameter(Mandatory = $false)]
    [double]$CityTaxPerPersonPerNight = 0,

    [Parameter(Mandatory = $false)]
    [double]$ParkingPerDay = 0,

    [Parameter(Mandatory = $false)]
    [double]$TransitPerPersonPerDay = 0,

    [Parameter(Mandatory = $false)]
    [double]$ExtraFeesPerNight = 0,

    [Parameter(Mandatory = $false)]
    [switch]$AsJson
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Calculs détaillés
$TotalBase = [math]::Round($BasePricePerNight * $Nights, 2)
$TotalCleaning = [math]::Round($CleaningFee, 2)
$TotalCityTax = [math]::Round($CityTaxPerPersonPerNight * $Guests * $Nights, 2)
$TotalParking = [math]::Round($ParkingPerDay * $Nights, 2)
$TotalTransit = [math]::Round($TransitPerPersonPerDay * $Guests * $Nights, 2)
$TotalExtraFees = [math]::Round($ExtraFeesPerNight * $Nights, 2)

$TotalCost = [math]::Round($TotalBase + $TotalCleaning + $TotalCityTax + $TotalParking + $TotalTransit + $TotalExtraFees, 2)
$CostPerPerson = if ($Guests -gt 0) { [math]::Round($TotalCost / $Guests, 2) } else { $TotalCost }
$CostPerPersonPerNight = if ($Guests -gt 0 -and $Nights -gt 0) { [math]::Round($TotalCost / ($Guests * $Nights), 2) } else { 0 }
$RealCostPerNight = if ($Nights -gt 0) { [math]::Round($TotalCost / $Nights, 2) } else { $TotalCost }

$ResultObject = [PSCustomObject]@{
    AccommodationName       = $AccommodationName
    Nights                  = $Nights
    Guests                  = $Guests
    Breakdown               = [PSCustomObject]@{
        BaseLodgingPrice    = "$TotalBase € ($BasePricePerNight €/nuit)"
        CleaningFee         = "$TotalCleaning €"
        CityTax             = "$TotalCityTax € ($CityTaxPerPersonPerNight €/pers/nuit)"
        Parking             = "$TotalParking € ($ParkingPerDay €/jour)"
        Transit             = "$TotalTransit € ($TransitPerPersonPerDay €/pers/jour)"
        ExtraFees           = "$TotalExtraFees € ($ExtraFeesPerNight €/nuit)"
    }
    TotalRealCost           = "$TotalCost €"
    RealCostPerNight        = "$RealCostPerNight € / nuit"
    CostPerPerson           = "$CostPerPerson € / personne"
    CostPerPersonPerNight   = "$CostPerPersonPerNight € / personne / nuit"
}

if ($AsJson) {
    $ResultObject | ConvertTo-Json -Depth 4
    return
}

$MarkdownOutput = @"
# 🧾 Calcul du Coût Réel Tout Compris (TCO) : $AccommodationName
**Séjour :** $Nights nuits pour $Guests voyageur$(if ($Guests -gt 1) {'s'} else {''})

---

### 📊 Décomposition des frais réels

| Poste de dépense | Calcul appliqué | Montant total |
| :--- | :--- | :--- |
| 🛏️ **Prix de base affiché** | $BasePricePerNight € × $Nights nuits | **$TotalBase €** |
| 🧹 **Frais de ménage fixes** | Frais uniques | **$TotalCleaning €** |
| 🏛️ **Taxes de séjour locales** | $CityTaxPerPersonPerNight € × $Guests pers. × $Nights nuits | **$TotalCityTax €** |
| 🚗 **Parking voiture** | $ParkingPerDay € × $Nights nuits | **$TotalParking €** |
| 🚇 **Transports en commun** | $TransitPerPersonPerDay € × $Guests pers. × $Nights jours | **$TotalTransit €** |
| ➕ **Frais supplémentaires (Resort fees)** | $ExtraFeesPerNight € × $Nights nuits | **$TotalExtraFees €** |
| 🏁 **COÛT RÉEL TOTAL** | **Somme de tous les frais réels** | **$TotalCost €** |

---

### 💡 Synthèse financière
* 💰 **Prix réel tout compris par nuit :** **$RealCostPerNight € / nuit** *(vs $BasePricePerNight € affiché)*
* 👤 **Budget réel par personne pour le séjour :** **$CostPerPerson €**
* 🌙 **Budget réel par personne et par nuit :** **$CostPerPersonPerNight €**
"@

Write-Output $MarkdownOutput
