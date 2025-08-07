---
title: Uudiskirjaga liitumise vormi lisamine nupuga
lang: et
section: sisu-haldamine
slug: voo-kodulehele-smaily-liitumisvormi-lisamine
original_url: https://www.voog.com/tugi/sisu-haldamine/voo-kodulehele-smaily-liitumisvormi-lisamine
updated_at: 2025-08-07T21:25:01Z
word_count: 586
---
## Uudiskirjaga liitumise vormi lisamine nupuga

Oma [Smaily](https://smaily.com/et/help/kuidas-teha/voog-kodulehele-smaily-liitumisvormi-lisamine/) kontol saad luua ja kujundada maandumislehtede tööriistaga uudiskirjaga liitumise vormi. Uuri lähemalt [maandumislehtede loomise juhenditest](https://smaily.com/et/category/juhendid/maandumislehed/).  
  
1. Liigu oma kodulehel lehele, millele soovid Smaily uudiskirjaga liitumise vormi lisada.

2. Lisa sobivasse asukohta **[Tekst](/tugi/sisualad/mis-on-sisuala#tekst)**[tüüpi sisuala.](/tugi/sisualad/mis-on-sisuala#tekst)

3. Kirjuta loodud tekstikasti uudiskirjaga liitumise nupu tekst näiteks “Liitu uudiskirjaga”.

4. Tee **Liitu uudiskirjaga** tekst aktiivseks ja vajuta üleval tekstitööriistal vasakult neljandat, teksti vormingu nuppu (¶) ja vali rippmenüüst **Nupp.**

**![Nupu loomine selekteerides tekstitööriistas teksti ja vajutades teksti vormingu nuppu.](https://media.voog.com/0000/0036/2183/photos/nupu_loomine_block.webp "Nupu loomine selekteerides tekstitööriistas teksti ja vajutades teksti vormingu nuppu.")**

6. Klõpsa lehel loodud nupule ja lisa lingikasti trellide (#) asemel Smailys loodud maandumislehe link.  

7. Salvesta tehtud muudatused. Alt paremalt **Eelvaade** nupu kaudu saad kontrollida, milline uudiskirjaga liitumise nupp välja näeb ja kas see suunab korrektselt.

## Maandumislehe vormi lisamine iframe’i abil

1. Navigeeri lehele, millele soovid uudiskirjaga liitumise vormi lisada.

2. Lisa lehele **[Tekst](/tugi/sisualad/mis-on-sisuala#tekst)**[tüüpi sisuala](/tugi/sisualad/mis-on-sisuala#tekst).

3. Vajuta tekstitööriistal **[HTML lähtekood](/tugi/sisu-haldamine/teksti-haldamine#video-ja-html-triistad)**ikoonile (</>).

![Tekstiredaktoris HTML-lähtekoodi tööriista nupule vajutamine](https://media.voog.com/0000/0036/2183/photos/htmllahtekood_tekstitooriist_block.webp "Tekstiredaktoris HTML-lähtekoodi tööriista nupule vajutamine")

4. Avanevasse aknasse lisa allolev sarnane kood:

```
<iframe src="MAANDUMISLEHE_URL" title="Liitu uudiskirjaga"></iframe>
```

*href=* jutumärkide vahele lisa Smailys loodud maandumislehe link (URL) ning seejärel klõpsa **Muuda** nupul.

  

Smailys loodud maandumisleht kuvatakse lehe sees. Saad vormi kuvamise laiust ja kõrgust muuta, kui klõpsad vormi peale ja sikutad vormi äärtes olevaid mummukesi.

Paremalt alt **Eelvaade** nupu kaudu saad kontrollida, milline uudiskirjaga liitumise nupp välja näeb ning kas see suunab korrektselt

## Uudiskirjaga liitumise vormi lisamine kood sisuala kaudu

Kui soovid kujundada uudiskirjaga liitumise vormi endale sobivamaks ja lisada väljasid või neid muuta, siis saab kasutada *opt-in* näidiskoodi vormi lisamiseks.  
  
**Koodi lisamiseks on kaks valikut:**

- Loo **[Kood](/tugi/sisualad/mis-on-sisuala#kood)**[tüüpi sisuala](/tugi/sisualad/mis-on-sisuala#kood) ja kopeeri/kleebi koodijupp avanevasse kasti.
- Loo uus **[Tekst](/tugi/sisualad/mis-on-sisuala#tekst)** [tüüpi sisuala](/tugi/sisualad/mis-on-sisuala#tekst) ja klõpsa tekstitööriistal [**HTML lähtekood**](/tugi/sisu-haldamine/teksti-haldamine#video-ja-html-triistad) ikooni (</>) ning kopeeri/kleebi koodijupp avanevasse kasti.

**Vaikimisi stiilidega vormi kood:**  

<form action="https://<domain>.sendsmaily.net/api/opt-in/" method="post" autocomplete="off">  
  <div style="display:none">  
    <input type="hidden" name="key" value="XDcsks...3sz" />  
    <input type="hidden" name="autoresponder" value="1" />  
    <input type="hidden" name="source" value="web" />  
    <input type="hidden" name="success\_url" value="http://www.domeen.ee/ok" />  
    <input type="hidden" name="failure\_url" value="http://www.domeen.ee/error" />  
    <input type="text" name="re-email" value="" />  
  </div>  
  <div class="form\_area">  
    <div class="form\_fields">  
      <div class="form\_field form\_field\_required ">  
        <label class="form\_field\_label" for="email">E-mail</label>  
        <input class="form\_field\_textfield form\_field\_size\_medium" name="email" type="email" value="" />  
      </div>  
      <div class="form\_field">  
        <label class="form\_field\_label" for="name">Nimi</label>  
        <input class="form\_field\_textfield form\_field\_size\_medium" name="name" type="text" value="" />  
      </div>  
    </div>  
    <div class="form\_submit">  
      <input class="form\_submit\_input" name="commit" type="submit" value="Liitu" />  
    </div>  
  </div>  
</form>

```
  

```

Koodis esinevaid parameetreid näed täpsemalt siit: [näidisvorm opt-in liitumise tarbeks.](https://smaily.com/et/help/juhendid/liidestused/naidisvorm-opt-in-liitumise-tarbeks/)
