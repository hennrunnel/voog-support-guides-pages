---
title: Kuidas ma saan Google Analyticsi koodi lisada oma kodulehele?
lang: et
section: statistika-ja-saidi-haldamine
slug: google-analyticsi-lisamine-sinu-veebilehele
original_url: https://www.voog.com/tugi/statistika-ja-saidi-haldamine/google-analyticsi-lisamine-sinu-veebilehele
updated_at: 2025-08-07T21:25:01Z
word_count: 304
---
## Kuidas ma saan Google Analyticsi koodi lisada oma kodulehele?

Logi oma Google’i kontoga sisse [Google Analyticsi keskkonda](https://marketingplatform.google.com/about/analytics/). Klõpsa nupul **Get started today** ja avanevas vaates **Start measuring**. Esmalt saad üles seada enda konto, ja kui esmane seadistus tehtud, suunatakse sind vaatesse **Start collecting data**, kus vali platvormiks **Web**. Järgmises vaates saad sisestada enda veebilehe andmed.  
  
 Veebilehe aadressi sisestades kasuta just seda domeeni, millega soovid saiti tutvustada, ning kasuta **https://** eesliidet.   
  
Kui soovid enda kodulehekülge tutvustada "**minufirma.com**" aadressiga, siis peaksid Google Analytics'sse lisama selle just kirjapildiga "**https://minufirma.com**" aadressi, mitte näiteks "minufirma.voog.com" või "https://www.minufirma.com" aadressi.

Kui konto registreeritud, luuakse sulle kood (Global Site Tag), mis näeb välja umbes selline:  
  
`→Google tag (gtag.js) -->  
 <script async src="https://www.googletagmanager.com/gtag/js?id=G-12345BCDGH"></script>  
 <script>  
   window.dataLayer = window.dataLayer || [];  
   function gtag(){dataLayer.push(arguments);}  
   gtag('js', new Date());  
  
   gtag('config', 'G-12345BCDGH');  
 </script>`  
Kopeeri kood ning mine oma Voo kodulehele. Ava **Seaded > Sait** ning kleebi kopeeritud kood **Välise statisika koodi** väljale ning kliki **Salvesta** ikoonil tööriistamenüü alumises servas.

![Esiletõstetud Google Analyticsi kood saidi seadete välise statistika koodi alas.](https://media.voog.com/0000/0036/2183/photos/Google_Analytics_est_block.webp "Esiletõstetud Google Analyticsi kood saidi seadete välise statistika koodi alas.")

Kui oled Google Analytics'i koodi oma kodulehele lisanud, siis võib minna kuni paar päeva enne kui Google sinu konto aktiveerib ning tulemusi nägema hakkad.

Täpsemalt saad juurde lugeda ka Google'i [ametlikult lehelt](https://developers.google.com/analytics).  
  
E-poe sündmuste jälgimise (*event* *tracking*) kohta saad põhjalikumalt lugeda [siit juhendist](/developers/scripting/ecommerce/tracking-shopping-cart-events).  
  
**NB! Kui lisad andmeid koguvaid kolmandate osapoolte rakendusi enda veebilehele, siis tuleks sellest teavitada ka veebilehe külastajaid. Vaata** [**siit**](/tugi/statistika-ja-saidi-haldamine/kupsiste-kasutamise-teavitus) **täpsemalt küpsiste kasutamise teavituse kohta.**
