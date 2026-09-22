<#
.SYNOPSIS
    Générateur de calendrier .ics pour réservations et alertes d'annulation gratuite (RFC 5545).

.DESCRIPTION
    Crée un fichier standard .ics compatible Google Calendar, Outlook et Apple Calendar
    contenant l'événement du séjour ainsi qu'une alarme rappel pour la date limite d'annulation gratuite.

.PARAMETER HotelName
    Nom de l'hébergement (ex: 'ibis Madrid Norte Las Tablas').

.PARAMETER CheckIn
    Date d'arrivée au format YYYY-MM-DD.

.PARAMETER CheckOut
    Date de départ au format YYYY-MM-DD.

.PARAMETER CancellationDeadline
    Date et heure limite pour annuler sans frais (format YYYY-MM-DD ou YYYY-MM-DDTHH:mm:ss).

.PARAMETER Address
    Adresse physique de l'hébergement.

.PARAMETER Price
    Prix total ou prix par nuit indicatif.

.PARAMETER OutputFile
    Chemin du fichier .ics à générer (optionnel, par défaut dans le dossier courant).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HotelName,

    [Parameter(Mandatory = $true)]
    [string]$CheckIn,

    [Parameter(Mandatory = $true)]
    [string]$CheckOut,

    [Parameter(Mandatory = $false)]
    [string]$CancellationDeadline,

    [Parameter(Mandatory = $false)]
    [string]$Address = "Adresse à confirmer sur votre réservation",

    [Parameter(Mandatory = $false)]
    [string]$Price = "",

    [Parameter(Mandatory = $false)]
    [string]$OutputFile
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Formatage des dates
$InDate = [DateTime]::ParseExact($CheckIn, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
$OutDate = [DateTime]::ParseExact($CheckOut, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)

$DtStamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$UidStay = [Guid]::NewGuid().ToString()
$UidAlert = [Guid]::NewGuid().ToString()

$InFormatted = $InDate.ToString("yyyyMMdd")
$OutFormatted = $OutDate.ToString("yyyyMMdd")

if (-not $OutputFile) {
    $SafeName = ($HotelName -replace '[^a-zA-Z0-9]', '_').ToLower()
    $OutputFile = "rappel_${SafeName}.ics"
}

# Construction du contenu ICS
$IcsLines = [System.Collections.Generic.List[string]]::new()
$IcsLines.Add("BEGIN:VCALENDAR")
$IcsLines.Add("VERSION:2.0")
$IcsLines.Add("PRODID:-//Antigravity Travel Assistant//FR")
$IcsLines.Add("CALSCALE:GREGORIAN")
$IcsLines.Add("METHOD:PUBLISH")

# Événement 1 : Le Séjour
$IcsLines.Add("BEGIN:VEVENT")
$IcsLines.Add("UID:${UidStay}@antigravity.travel")
$IcsLines.Add("DTSTAMP:$DtStamp")
$IcsLines.Add("DTSTART;VALUE=DATE:$InFormatted")
$IcsLines.Add("DTEND;VALUE=DATE:$OutFormatted")
$IcsLines.Add("SUMMARY:Voyage : $HotelName")
$IcsLines.Add("LOCATION:$Address")
$IcsLines.Add("DESCRIPTION:Séjour à $HotelName du $CheckIn au $CheckOut.\nTarif : $Price\nAdresse : $Address")
$IcsLines.Add("STATUS:CONFIRMED")
$IcsLines.Add("BEGIN:VALARM")
$IcsLines.Add("TRIGGER:-P1D")
$IcsLines.Add("ACTION:DISPLAY")
$IcsLines.Add("DESCRIPTION:Rappel départ demain : séjour à $HotelName")
$IcsLines.Add("END:VALARM")
$IcsLines.Add("END:VEVENT")

# Événement 2 : Alerte d'annulation gratuite (si fournie)
if ($CancellationDeadline) {
    $CancelDate = [DateTime]::Parse($CancellationDeadline)
    $CancelStart = $CancelDate.AddHours(-1).ToString("yyyyMMddTHHmmss")
    $CancelEnd = $CancelDate.ToString("yyyyMMddTHHmmss")

    $IcsLines.Add("BEGIN:VEVENT")
    $IcsLines.Add("UID:${UidAlert}@antigravity.travel")
    $IcsLines.Add("DTSTAMP:$DtStamp")
    $IcsLines.Add("DTSTART:$CancelStart")
    $IcsLines.Add("DTEND:$CancelEnd")
    $IcsLines.Add("SUMMARY:⚠️ DERNIÈRE LIMITE Annulation Gratuite : $HotelName")
    $IcsLines.Add("LOCATION:$Address")
    $IcsLines.Add("DESCRIPTION:Dernier délai pour annuler la réservation sans frais pour $HotelName !\nHeure limite : $CancellationDeadline")
    $IcsLines.Add("STATUS:CONFIRMED")
    $IcsLines.Add("BEGIN:VALARM")
    $IcsLines.Add("TRIGGER:-PT24H")
    $IcsLines.Add("ACTION:DISPLAY")
    $IcsLines.Add("DESCRIPTION:ALERTE : Annulation gratuite $HotelName expire dans 24 heures !")
    $IcsLines.Add("END:VALARM")
    $IcsLines.Add("BEGIN:VALARM")
    $IcsLines.Add("TRIGGER:-PT2H")
    $IcsLines.Add("ACTION:DISPLAY")
    $IcsLines.Add("DESCRIPTION:URGENT : Annulation gratuite $HotelName expire dans 2 heures !")
    $IcsLines.Add("END:VALARM")
    $IcsLines.Add("END:VEVENT")
}

$IcsLines.Add("END:VCALENDAR")

# Sauvegarde
$Content = [string]::Join("`r`n", $IcsLines)
[System.IO.File]::WriteAllText($OutputFile, $Content, [System.Text.Encoding]::UTF8)

Write-Output "Fichier calendrier ICS généré avec succès : $OutputFile"
Write-Output "Contient le séjour du $CheckIn au $CheckOut $(if ($CancellationDeadline) {"et le rappel d'annulation pour le $CancellationDeadline"} else {''})."
