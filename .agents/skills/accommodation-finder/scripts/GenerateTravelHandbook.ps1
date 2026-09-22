<#
.SYNOPSIS
    Génère une fiche mémo "Carnet de Voyage Hors-Ligne & Fiche d'Urgence" en Markdown et HTML imprimable.

.DESCRIPTION
    Crée un document autonome consultable sans connexion Internet sur smartphone ou à imprimer,
    contenant les coordonnées de l'hébergement, les numéros d'urgence officiels du pays hôte
    (police, secours, ambassade de France) et un lexique local de survie pour l'accueil.

.PARAMETER Destination
    Ville et pays du séjour (ex: "Rome, Italie", "Tokyo, Japon", "Madrid, Espagne").

.PARAMETER HotelName
    Nom du logement ou de l'hôtel réservé.

.PARAMETER Address
    Adresse complète du logement.

.PARAMETER CheckIn
    Date d'arrivée.

.PARAMETER CheckOut
    Date de départ.

.PARAMETER HostContact
    Numéro de téléphone ou contact WhatsApp de l'hôte.

.PARAMETER OutputPath
    Chemin du fichier généré (par défaut 'Carnet_Voyage_<Hotel>.html').

.EXAMPLE
    .\GenerateTravelHandbook.ps1 -Destination "Rome, Italie" -HotelName "Colosseo Flat" -Address "Via Cavour 45, Rome" -CheckIn "2026-05-10" -CheckOut "2026-05-15"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Destination,

    [Parameter(Mandatory=$true)]
    [string]$HotelName,

    [Parameter(Mandatory=$false)]
    [string]$Address = "Adresse à préciser",

    [Parameter(Mandatory=$false)]
    [string]$CheckIn = (Get-Date).AddDays(14).ToString("yyyy-MM-dd"),

    [Parameter(Mandatory=$false)]
    [string]$CheckOut = (Get-Date).AddDays(19).ToString("yyyy-MM-dd"),

    [Parameter(Mandatory=$false)]
    [string]$HostContact = "+33 6 00 00 00 00 / Messagerie App",

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ""
)

# Base de connaissances d'urgence et lexique par pays / langue
$CountryData = @{
    "italie" = @{
        EmergencyPolice = "112 / 113"; EmergencyMedical = "118"; EmergencyFire = "115"
        FrenchConsulate = "+39 06 68 60 11 (Rome) / Ambassade Palazzo Farnese"
        Lang = "Italien"
        Phrases = @(
            @{ Fr = "Bonjour, j'ai une réservation au nom de..."; Local = "Buongiorno, ho una prenotazione a nome di..." }
            @{ Fr = "Quel est le code du Wi-Fi ?"; Local = "Qual è la password del Wi-Fi per favore?" }
            @{ Fr = "Puis-je laisser mes valises quelques heures ?"; Local = "Posso lasciare le valigie per qualche ora?" }
            @{ Fr = "À quelle heure est le check-out ?"; Local = "A che ora è il check-out?" }
            @{ Fr = "Où jeter les poubelles (tri sélectif) ?"; Local = "Dove si buttano i rifiuti / la raccolta differenziata?" }
            @{ Fr = "La climatisation / le chauffage ne fonctionne pas"; Local = "L'aria condizionata / il riscaldamento non funziona." }
        )
    }
    "espagne" = @{
        EmergencyPolice = "112 / 091"; EmergencyMedical = "112 / 061"; EmergencyFire = "080"
        FrenchConsulate = "+34 91 700 78 00 (Madrid) / +34 93 270 30 00 (Barcelone)"
        Lang = "Espagnol"
        Phrases = @(
            @{ Fr = "Bonjour, j'ai une réservation au nom de..."; Local = "Hola, tengo una reserva a nombre de..." }
            @{ Fr = "Quel est le code du Wi-Fi ?"; Local = "¿Cuál es la contraseña del Wi-Fi por favor?" }
            @{ Fr = "Puis-je laisser mes bagages quelques heures ?"; Local = "¿Puedo dejar mis maletas un par de horas?" }
            @{ Fr = "À quelle heure est le départ ?"; Local = "¿A qué hora es el check-out?" }
            @{ Fr = "Où sont les poubelles ?"; Local = "¿Dónde se tira la basura?" }
            @{ Fr = "Le climatiseur ne s'allume pas"; Local = "El aire acondicionado no enciende." }
        )
    }
    "japon" = @{
        EmergencyPolice = "110"; EmergencyMedical = "119"; EmergencyFire = "119"
        FrenchConsulate = "+81 (0)3 5798 6000 (Tokyo, Minami-Azabu)"
        Lang = "Japonais"
        Phrases = @(
            @{ Fr = "Bonjour, j'ai une réservation au nom de..."; Local = "Konnichiwa, [Nom] no namae de yoyaku ga arimasu." }
            @{ Fr = "Quel est le mot de passe Wi-Fi ?"; Local = "Wi-Fi no pasuwādo wa nan desu ka?" }
            @{ Fr = "Puis-je laisser mes bagages ?"; Local = "Nimotsu o azukatte itadakemasu ka?" }
            @{ Fr = "À quelle heure dois-je libérer la chambre ?"; Local = "Chekkuauto wa nanji desu ka?" }
            @{ Fr = "Où sont les poubelles ?"; Local = "Gomibako wa doko desu ka?" }
            @{ Fr = "Merci beaucoup pour votre accueil"; Local = "Arigatō gozaimasu." }
        )
    }
    "usa" = @{
        EmergencyPolice = "911"; EmergencyMedical = "911"; EmergencyFire = "911"
        FrenchConsulate = "+1 (202) 944-6000 (Washington) / +1 (212) 606-3688 (New York)"
        Lang = "Anglais"
        Phrases = @(
            @{ Fr = "Bonjour, j'ai une réservation au nom de..."; Local = "Hello, I have a reservation under the name..." }
            @{ Fr = "What is the Wi-Fi password please?"; Local = "What is the Wi-Fi password please?" }
            @{ Fr = "Can I store my luggage before check-in / after check-out?"; Local = "Can I store my luggage before check-in / after check-out?" }
            @{ Fr = "What time is check-out?"; Local = "What time is check-out?" }
            @{ Fr = "Where should I leave the key?"; Local = "Where should I leave the key?" }
        )
    }
    "defaut" = @{
        EmergencyPolice = "112 (Standard International / UE) ou 911"; EmergencyMedical = "112"; EmergencyFire = "112"
        FrenchConsulate = "Urgences consulaires France : +33 1 53 59 11 00"
        Lang = "Anglais (International)"
        Phrases = @(
            @{ Fr = "Bonjour, j'ai une réservation au nom de..."; Local = "Hello, I have a booking under the name..." }
            @{ Fr = "Quel est le mot de passe Wi-Fi ?"; Local = "Could you give me the Wi-Fi password please?" }
            @{ Fr = "Puis-je laisser mes bagages ?"; Local = "Is it possible to leave my luggage here?" }
            @{ Fr = "À quelle heure est le check-out ?"; Local = "What time is check-out?" }
        )
    }
}

# Détection du profil pays
$destLower = $Destination.ToLower()
$profile = $CountryData["defaut"]
foreach ($k in $CountryData.Keys) {
    if ($destLower.Contains($k)) {
        $profile = $CountryData[$k]
        break
    }
}

# Nom de fichier cible
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $cleanHotel = ($HotelName -replace '[^a-zA-Z0-9]', '_').ToLower()
    $OutputPath = "Carnet_Voyage_$cleanHotel.html"
}

# Génération HTML responsive & imprimable
$phrasesRows = ""
foreach ($p in $profile.Phrases) {
    $phrasesRows += @"
    <tr style="border-bottom: 1px solid #e5e7eb;">
      <td style="padding: 8px 12px; font-weight: 600; color: #374151;">$($p.Fr)</td>
      <td style="padding: 8px 12px; font-weight: 700; color: #1e40af; background-color: #f8fafc;">$($p.Local)</td>
    </tr>
"@
}

$htmlContent = @"
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Carnet de Voyage Hors-Ligne - $HotelName</title>
  <style>
    body { font-family: system-ui, -apple-system, sans-serif; background-color: #f3f4f6; color: #1f2937; margin: 0; padding: 20px; }
    .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 16px; border: 2px solid #e5e7eb; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    h1 { color: #111827; margin-top: 0; font-size: 22px; border-bottom: 3px solid #3b82f6; padding-bottom: 8px; }
    h2 { color: #1e3a8a; font-size: 16px; margin-top: 20px; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; }
    .card { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 12px; padding: 12px; }
    .card-label { font-size: 11px; text-transform: uppercase; font-weight: 700; color: #6b7280; }
    .card-val { font-size: 14px; font-weight: 700; color: #111827; margin-top: 4px; word-break: break-word; }
    .alert-box { background-color: #fef2f2; border: 2px solid #fecaca; border-radius: 12px; padding: 12px; margin-top: 16px; }
    .btn-print { background: #2563eb; color: white; border: none; padding: 8px 16px; border-radius: 8px; font-weight: 700; cursor: pointer; float: right; }
    @media print { .btn-print { display: none; } body { background: white; padding: 0; } .container { border: none; box-shadow: none; } }
  </style>
</head>
<body>
  <div class="container">
    <button class="btn-print" onclick="window.print()">🖨️ Imprimer / PDF</button>
    <h1>📋 Carnet de Voyage Hors-Ligne &amp; Fiche d'Urgence</h1>

    <h2>🏨 Détails de l'Hébergement</h2>
    <div class="grid">
      <div class="card">
        <div class="card-label">Établissement</div>
        <div class="card-val">$HotelName</div>
      </div>
      <div class="card">
        <div class="card-label">Destination</div>
        <div class="card-val">$Destination</div>
      </div>
      <div class="card">
        <div class="card-label">Dates du Séjour</div>
        <div class="card-val">Du $CheckIn au $CheckOut</div>
      </div>
      <div class="card">
        <div class="card-label">Contact Hôte / Urgence Logement</div>
        <div class="card-val">$HostContact</div>
      </div>
      <div class="card" style="grid-column: 1 / -1;">
        <div class="card-label">Adresse Précise</div>
        <div class="card-val">$Address</div>
      </div>
    </div>

    <h2>🚨 Numéros d'Urgence Officiels ($Destination)</h2>
    <div class="alert-box">
      <div class="grid">
        <div>
          <div class="card-label" style="color: #991b1b;">Police / Secours</div>
          <div class="card-val" style="color: #b91c1c; font-size: 18px;">$($profile.EmergencyPolice)</div>
        </div>
        <div>
          <div class="card-label" style="color: #991b1b;">SAMU / Urgences Médicales</div>
          <div class="card-val" style="color: #b91c1c; font-size: 18px;">$($profile.EmergencyMedical)</div>
        </div>
        <div>
          <div class="card-label" style="color: #991b1b;">Pompiers</div>
          <div class="card-val" style="color: #b91c1c; font-size: 18px;">$($profile.EmergencyFire)</div>
        </div>
      </div>
      <div style="margin-top: 10px; font-size: 12px; color: #7f1d1d; font-weight: 600;">
        Consulat / Ambassade de France : $($profile.FrenchConsulate)
      </div>
    </div>

    <h2>🗣️ Lexique Local de Survie ($($profile.Lang))</h2>
    <table style="width: 100%; border-collapse: collapse; font-size: 13px;">
      <thead>
        <tr style="background: #f3f4f6; text-align: left;">
          <th style="padding: 8px 12px; color: #4b5563;">Français</th>
          <th style="padding: 8px 12px; color: #1e40af;">En $($profile.Lang)</th>
        </tr>
      </thead>
      <tbody>
        $phrasesRows
      </tbody>
    </table>

    <div style="margin-top: 20px; font-size: 11px; color: #9ca3af; text-align: center;">
      Généré par Antigravity TravelHub • Document autonome consultable sans connexion Internet
    </div>
  </div>
</body>
</html>
"@

Set-Content -Path $OutputPath -Value $htmlContent -Encoding UTF8
Write-Host "`n✅ Carnet de voyage hors-ligne généré avec succès !" -ForegroundColor Green
Write-Host "Fichier : $OutputPath" -ForegroundColor White
Write-Host "Vous pouvez l'ouvrir dans votre navigateur ou le transférer sur votre smartphone.`n" -ForegroundColor Gray

return (Resolve-Path $OutputPath).Path
