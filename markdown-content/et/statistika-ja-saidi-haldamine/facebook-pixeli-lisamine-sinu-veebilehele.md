---
title: Pixeli seadistamine Facebookis
lang: et
section: statistika-ja-saidi-haldamine
slug: facebook-pixeli-lisamine-sinu-veebilehele
original_url: https://www.voog.com/tugi/statistika-ja-saidi-haldamine/facebook-pixeli-lisamine-sinu-veebilehele
updated_at: 2025-08-07T21:25:01Z
word_count: 404
---
## **Pixeli seadistamine Facebookis**

1. Mine Facebookis oma [Events Manageri](https://www.facebook.com/events_manager2/)
2. Vajuta rohelisel **Connect Data Sources** nupul vasakul lehe ääres
3. Vali avanevast hüpikaknast **Võrk**
4. Pane kirja oma Pixeli nimi (näiteks “[veebilehe nimi] Pixel”)
5. Kirjuta URLi kasti oma veebilehe link. Sisesta kindlasti õige link: kui soovid enda lehte tutvustada aadressiga <https://example.com>, siis peaksid kasti lisama just selle aadressi, mitte <https://example.voog.com> või <https://www.example.com>. Kontrolli ka üle, kas su personaalsel domeenil on olemas [SSL-sertifikaat](/tugi/videojuhendid/ssl-sertifikaadi-lisamine).
6. Vajuta **Jätka**

## Pixeli Voogu ühendamine

1. Mine Facebookis oma [Events Manageri](https://www.facebook.com/events_manager2/)
2. Vali nimekirjast Pixel, mida soovid veebilehele lisada
3. Vajuta **Jätka Pixeli ülesseadmist**
4. Vajuta **Lisa kood manuaalselt**
5. Kopeeri Pixeli baaskood (jäta Events Manageri leht lahti). Kood näeb välja umbes selline:

```
<!-- Facebook Pixel Code -->  
<script>  
  !function(f,b,e,v,n,t,s)  
  {if(f.fbq)return;n=f.fbq=function(){n.callMethod?  
  n.callMethod.apply(n,arguments):n.queue.push(arguments)};  
  if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';  
  n.queue=[];t=b.createElement(e);t.async=!0;  
  t.src=v;s=b.getElementsByTagName(e)[0];  
  s.parentNode.insertBefore(t,s)}(window, document,'script',  
  'https://connect.facebook.net/en_US/fbevents.js');  
  fbq('init', '{your-pixel-id-goes-here}');  
  fbq('track', 'PageView');  
</script>  
<noscript>  
  <img height="1" width="1" style="display:none"  
    src="https://www.facebook.com/tr?id={your-pixel-id-goes-here}&ev=PageView&noscript=1"/>  
</noscript>  
<!-- End Facebook Pixel Code -->
```

6. Ava oma Voo veebileht, mine menüüsse **Seaded** > **Sait** ning kleebi kood **Päise koodi** alasse
7. Vajuta Facebooki Events Manageris nuppu **Jätka** niikaua kuni aken läheb eest ära

Pixel on nüüd lehel olemas ning võimaldab jälgida lehekülastusi. Lehekülastuste jälgimiseks on vajalik [Facebooki-poolne seadistus](https://developers.facebook.com/docs/facebook-pixel/implementation/#installing-the-pixel). Kui soovid ka seda, et Pixel jälgiks klientide tegemisi ka Voo ostukorvis, siis tuleks veebilehele juurde lisada skript, mis jälgib Voo ostukorvis tehtud oste. Selleks mine lehele [Tracking shopping cart events in Voog](/developers/scripting/ecommerce/tracking-shopping-cart-events) ning kopeeri vastav koodijupp oma lehel **Seaded** > **Sait** > **Päise koodi** alasse sinna juba lisatud Pixeli koodile lisaks.  
  
Kui lisad andmeid koguvaid kolmandate osapoolte rakendusi enda veebilehele, siis tuleks sellest teavitada ka veebilehe külastajaid. Vaata täpsemalt küpsiste kasutamise teavituse kohta [siit](/tugi/statistika-ja-saidi-haldamine/kupsiste-kasutamise-teavitus).
