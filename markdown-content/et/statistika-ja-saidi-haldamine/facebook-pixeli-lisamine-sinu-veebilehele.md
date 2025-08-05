# Lisa Facebook Pixel oma saidile | Voog mitmekeelne koduleht ja e-pood

**Section:** Statistika ja saidi haldamine  
**Language:** et  
**Original URL:** https://www.voog.com/support/statistika-ja-saidi-haldamine/facebook-pixeli-lisamine-sinu-veebilehele.html  
**Extracted:** 2025-08-05 07:49:08 UTC

---

Pixeli seadistamine Facebookis
Mine Facebookis oma Events Manageri
Vajuta rohelisel Connect Data Sources nupul vasakul lehe ääres
Vali avanevast hüpikaknast Võrk
Pane kirja oma Pixeli nimi (näiteks “[veebilehe nimi] Pixel”)
Kirjuta URLi kasti oma veebilehe link. Sisesta kindlasti õige link: kui soovid enda lehte tutvustada aadressiga https://example.com, siis peaksid kasti lisama just selle aadressi, mitte https://example.voog.com või https://www.example.com. Kontrolli ka üle, kas su personaalsel domeenil on olemas SSL-sertifikaat.
Vajuta Jätka
Pixeli Voogu ühendamine
Mine Facebookis oma Events Manageri
Vali nimekirjast Pixel, mida soovid veebilehele lisada
Vajuta Jätka Pixeli ülesseadmist
Vajuta Lisa kood manuaalselt
Kopeeri Pixeli baaskood (jäta Events Manageri leht lahti). Kood näeb välja umbes selline:<!-- Facebook Pixel Code --><script>  !function(f,b,e,v,n,t,s)  {if(f.fbq)return;n=f.fbq=function(){n.callMethod?  n.callMethod.apply(n,arguments):n.queue.push(arguments)};  if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';  n.queue=[];t=b.createElement(e);t.async=!0;  t.src=v;s=b.getElementsByTagName(e)[0];  s.parentNode.insertBefore(t,s)}(window, document,'script',  'https://connect.facebook.net/en_US/fbevents.js');  fbq('init', '{your-pixel-id-goes-here}');  fbq('track', 'PageView');</script><noscript>  <img height="1" width="1" style="display:none"    src="https://www.facebook.com/tr?id={your-pixel-id-goes-here}&ev=PageView&noscript=1"/></noscript><!-- End Facebook Pixel Code -->
Ava oma Voo veebileht, mine menüüsse Seaded > Sait ning kleebi kood Päise koodi alasseVajuta Facebooki Events Manageris nuppu Jätka niikaua kuni aken läheb eest äraPixel on nüüd lehel olemas ning võimaldab jälgida lehekülastusi. Lehekülastuste jälgimiseks on vajalik Facebooki-poolne seadistus. Kui soovid ka seda, et Pixel jälgiks klientide tegemisi ka Voo ostukorvis, siis tuleks veebilehele juurde lisada skript, mis jälgib Voo ostukorvis tehtud oste. Selleks mine lehele Tracking shopping cart events in Voog ning kopeeri vastav koodijupp oma lehel Seaded > Sait > Päise koodi alasse sinna juba lisatud Pixeli koodile lisaks.Kui lisad andmeid koguvaid kolmandate osapoolte rakendusi enda veebilehele, siis tuleks sellest teavitada ka veebilehe külastajaid. Vaata täpsemalt küpsiste kasutamise teavituse kohta siit.

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
