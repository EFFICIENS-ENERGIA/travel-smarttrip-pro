<#
.SYNOPSIS
    Génère des messages diplomatiques de négociation multilingues pour obtenir des réductions ou avantages auprès des hôtes.

.DESCRIPTION
    Fournit des messages types éprouvés et traduits en plusieurs langues (Anglais, Espagnol, Italien, Allemand, Japonais, Français)
    pour négocier sans friction : rabais séjour longue durée (-10% à -15%), check-in anticipé sans frais, ou garantie Wi-Fi fibre.

.PARAMETER Scenario
    Type de demande : 'Discount' (rabais tarifaire), 'EarlyCheckIn' (arrivée anticipée), 'LateCheckOut' (départ tardif), 'WiFiCheck' (débit Wi-Fi).

.PARAMETER Language
    Langue souhaitée : 'EN' (Anglais), 'ES' (Espagnol), 'IT' (Italien), 'DE' (Allemand), 'JA' (Japonais), 'FR' (Français).

.PARAMETER GuestName
    Prénom du voyageur.

.PARAMETER Nights
    Nombre de nuits du séjour.

.PARAMETER DiscountPercent
    Pourcentage de rabais suggéré (par défaut 10 à 15%).

.EXAMPLE
    .\NegotiateStay.ps1 -Scenario "Discount" -Language "IT" -GuestName "Alex" -Nights 6 -DiscountPercent 12
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Discount", "EarlyCheckIn", "LateCheckOut", "WiFiCheck")]
    [string]$Scenario = "Discount",

    [Parameter(Mandatory=$false)]
    [ValidateSet("EN", "ES", "IT", "DE", "JA", "FR")]
    [string]$Language = "EN",

    [Parameter(Mandatory=$false)]
    [string]$GuestName = "Alexandre",

    [Parameter(Mandatory=$false)]
    [int]$Nights = 5,

    [Parameter(Mandatory=$false)]
    [int]$DiscountPercent = 12
)

$Templates = @{
    "Discount" = @{
        "FR" = @"
Bonjour,

Votre logement a l'air vraiment magnifique et correspond parfaitement à ce que nous recherchons pour notre séjour de $Nights nuits.

Nous sommes des voyageurs calmes, respectueux et non-fumeurs (avec d'excellents avis vérifiés). 
Comme notre séjour est de plusieurs nuits, seriez-vous ouvert à nous accorder une petite remise de bienvenu de l'ordre de $DiscountPercent % sur le loyer global ? Si oui, nous sommes prêts à finaliser la réservation immédiatement.

Merci d'avance pour votre considération et belle journée !
Cordialement,
$GuestName
"@
        "EN" = @"
Hello,

Your place looks fantastic and would be ideal for our upcoming $Nights-night stay.

We are quiet, clean, and non-smoking guests with excellent review history. Since we are booking for a solid $Nights nights, would you consider a modest discount of around $DiscountPercent% on the total stay? If that works for you, we would be delighted to book right away.

Thank you very much for your time and consideration!
Warm regards,
$GuestName
"@
        "IT" = @"
Buongiorno,

Il vostro alloggio è davvero splendido e perfetto per il nostro soggiorno di $Nights notti.

Siamo ospiti tranquilli, puliti e non fumatori (con ottime recensioni verificate). Poiché ci fermiamo per $Nights notti, sarebbe possibile concordare un piccolo sconto di cortesia di circa il $DiscountPercent% sul totale? Se fosse fattibile, saremmo felicissimi di confermare subito la prenotazione.

Grazie mille per la disponibilità e buona giornata!
Cordiali saluti,
$GuestName
"@
        "ES" = @"
Hola,

Su alojamiento se ve fantástico y sería perfecto para nuestra estancia de $Nights noches.

Somos viajeros tranquilos, limpios y no fumadores (con excelentes valoraciones). Dado que nos quedamos $Nights noches consecutivas, ¿sería posible considerar un pequeño descuento de cortesía del $DiscountPercent% sobre el total? Si es posible, estaríamos encantados de reservar de inmediato.

¡Muchas gracias por su atención y que tenga un excelente día!
Saludos cordiales,
$GuestName
"@
        "DE" = @"
Guten Tag,

Ihre Unterkunft sieht wunderbar aus und wäre ideal für unseren Aufenthalt von $Nights Nächten.

Wir sind sehr ruhige, ordentliche und Nichtraucher-Gäste mit erstklassigen Bewertungen. Da wir für $Nights Nächte buchen, möchten wir höflich fragen, ob ein kleiner Rabatt von ca. $DiscountPercent% möglich wäre? Gerne würden wir die Buchung direkt verbindlich abschließen.

Vielen Dank im Voraus für Ihre Rückmeldung!
Beste Grüße,
$GuestName
"@
        "JA" = @"
こんにちは。

お部屋の写真や説明を拝見し、大変素敵で今回の $Nights 泊の滞在にぜひ利用させていただきたくご連絡いたしました。

当方は非喫煙者で、静かで丁寧な利用を心がけております。今回はまとまった泊数の滞在となりますため、もし可能でしたら約 $DiscountPercent ％ほどの特別割引をご検討いただくことは可能でしょうか？もしご快諾いただけるようでしたら、すぐに予約を確定させていただきます。

ご検討のほど、よろしくお願いいたします。
$GuestName
"@
    }

    "EarlyCheckIn" = @{
        "FR" = @"
Bonjour,

Notre vol / train arrive un peu plus tôt le jour de notre arrivée. 
Serait-il envisageable de faire un check-in un peu plus tôt (ou à défaut de simplement déposer nos bagages en sécurité le temps que le ménage se termine) ?

Un grand merci pour votre flexibilité !
Bien cordialement,
$GuestName
"@
        "EN" = @"
Hello,

Our flight / train arrives a bit earlier in the day. 
Would it be possible to arrange an early check-in (or at least drop off our luggage safely while cleaning is completed)?

Thank you so much for your flexibility!
Best regards,
$GuestName
"@
        "IT" = @"
Buongiorno,

Il nostro treno / volo arriverà un po' prima del previsto. 
Sarebbe possibile effettuare il check-in anticipato (o almeno lasciare i bagagli al sicuro mentre vengono completate le pulizie)?

Grazie mille per la gentilezza e disponibilità!
Cordiali saluti,
$GuestName
"@
        "ES" = @"
Hola,

Nuestro vuelo / tren llega un poco más temprano ese día. 
¿Sería posible hacer el check-in temprano (o al menos dejar nuestras maletas guardadas mientras termina la limpieza)?

¡Muchísimas gracias por su amabilidad!
Saludos cordiales,
$GuestName
"@
        "JA" = @"
こんにちは。

到着日の移動便が予定より少し早めに到着する見込みとなっております。
もし可能でしたら、アーリーチェックイン（または清掃完了までの間、お荷物だけを先に預けること）は可能でしょうか？

ご柔軟にご対応いただけますと幸いです。よろしくお願いいたします。
$GuestName
"@
    }

    "WiFiCheck" = @{
        "FR" = @"
Bonjour,

Votre logement nous intéresse beaucoup. Devant travailler en distanciel pendant quelques heures, pourriez-vous m'assurer de la stabilité de la connexion Wi-Fi (vitesse moyenne en téléchargement ou connexion fibre) ?

Merci beaucoup pour votre retour !
Bien à vous,
$GuestName
"@
        "EN" = @"
Hello,

We are very interested in your place. As I will need to do some remote work and video calls during our stay, could you kindly confirm the reliability and speed of the Wi-Fi connection?

Thank you very much for your help!
Best regards,
$GuestName
"@
        "IT" = @"
Buongiorno,

Il vostro alloggio ci interessa molto. Dovendo svolgere alcune ore di smart working e videochiamate, potreste confermarmi la velocità e stabilità della connessione Wi-Fi?

Grazie mille per l'assistenza!
Cordiali saluti,
$GuestName
"@
        "ES" = @"
Hola,

Nos interesa mucho su alojamiento. Como necesitaré trabajar a distancia y realizar videollamadas durante la estancia, ¿podría confirmarme la velocidad y estabilidad de la conexión Wi-Fi?

¡Muchas gracias por su ayuda!
Saludos cordiales,
$GuestName
"@
        "JA" = @"
こんにちは。

滞在中にリモートワーク（ビデオ通話等）を予定しております。
差し支えなければ、お部屋のWi-Fi接続の安定性やおおよその回線速度（光回線等）について教えていただけますでしょうか？

お忙しいところ恐れ入りますが、よろしくお願いいたします。
$GuestName
"@
    }
}

$selectedText = $Templates[$Scenario][$Language]
if (-not $selectedText) {
    $selectedText = $Templates[$Scenario]["EN"]
}

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "💬 GÉNÉRATEUR DE NÉGOCIATION DIPLOMATIQUE ($Scenario - $Language)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host $selectedText -ForegroundColor Green
Write-Host "--------------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "💡 CONSEIL PRO : Mentionnez toujours que vous êtes non-fumeur, calme et prêt à réserver sous 1h pour maximiser l'acceptation de l'hôte.`n" -ForegroundColor Yellow

return [PSCustomObject]@{
    Scenario = $Scenario
    Language = $Language
    Message = $selectedText
}
