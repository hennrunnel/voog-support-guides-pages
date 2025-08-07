---
title: Välise domeeni importimine Voo
keskkonda
lang: et
section: domeenid
slug: kasuta-juba-eelnevalt-eksisteerivat-domeeni
original_url: https://www.voog.com/tugi/domeenid/kasuta-juba-eelnevalt-eksisteerivat-domeeni
updated_at: 2025-08-07T21:25:01Z
word_count: 409
---
Pärast seda, kui oled liitunud
[**Voog
Standard / Plus / Premium**](/hinnad) paketiga, saad sa
suunata juba olemasoleva aadressi (näiteks minudomeen.ee) oma Voo saidile.

Teise registripidaja juurest ostetud
domeeni kasutamiseks Voo keskkonnas tuleb

- **[importida domeen](/tugi/domeenid/kasuta-juba-eelnevalt-eksisteerivat-domeeni#vlise-domeeni-importimine-vookeskkonda) oma Voo saidile**
- ja seejärel [suunata domeeni A-kirje Voo
  serverite IP-aadressile](/tugi/domeenid/kasuta-juba-eelnevalt-eksisteerivat-domeeni#dns-kirjete-muutmine) **[85.222.234.14](/tugi/domeenid/kasuta-juba-eelnevalt-eksisteerivat-domeeni#dns-kirjete-muutmine)**

## Välise domeeni importimine Voo keskkonda

Esimese sammuna pead Voo keskkonnas siduma domeeninime ja enda saidi. See on vajalik, et meie süsteem
teaks, millist lehte päringu minudomeen.ee vastusena näidata.

Selleks liigu saidile, millega tahad domeeni siduda ja mine **Seaded** > **Domeenid** menüüsse. Klõpsa nupul **Lisa uus** ja vali **Impordi**
ning sisesta oma domeeninimi.   
Domeen kirjuta ilma www-eesliiteta, st www.minudomeen.ee
asemel kirjuta lihtsalt minudomeen.ee. Domeeni kujul
www.minudomeen.ee tunneb süsteem ära juba automaatselt.

!['Lisa uus' nupu alt avanev rippmenüü, kus kursor 'Impordi' valikul.](https://media.voog.com/0000/0036/2183/photos/impordi_domeen_block.webp "'Lisa uus' nupu alt avanev rippmenüü, kus kursor 'Impordi' valikul.")

## DNS kirjete muutmine

Järgmisena pead muutma oma registripidaja
halduskeskkonnas domeeni DNS kirjeid.

1. Logi sisse oma registripidaja halduskeskkonda.
2. Leia
   haldusliidesest nimeserveri (DNS) seadistamise võimaluste alt
   aadressi suunamise osa, näiteks **IP suunamine** (*IP
   Forwarding*) või **Muuda oma A-kirjet** (*Modifying
   an A-Record*). Tavaliselt leiad selle **DNS
   haldamise** (*Advanced DNS Management* ) alajaotusest.
3. Muuda domeeni
   **A-kirje** IP-aadress Voo serveri IP-aadressiks: **85.222.234.14** .
   Lisa oma domeeni nimi A-kirjesse ilma www eesliiteta, kujul
   minudomeen.ee.
4. Lisa
   domeenile CNAME kirje www kolmanda astme domeeni jaoks. Kontrolli,
   et kirje nimi oleks www.minudomeen.ee,
   tüüp CNAME ja väärtus minudomeen.ee.

Sinu domeeni A-kirje ja CNAME peaksid nüüd sellised välja nägema:

|  |  |  |
| --- | --- | --- |
| **NAME** | **TYPE** | **VALUE** |
| minudomeen.ee | A | 85.222.234.14 |
| www.minudomeen.ee | CNAME | minudomeen.ee |

Pärast IP-aadressi muutmist võib
minna kuni 48 tundi, enne kui muudetud kirje üle kogu interneti
levib ning antud aadressil hakkab avanema sinu Voo lehekülg. See
sõltub domeeni TTL (*time to live*) seadetest.

## DNS seadete muutmine populaarsemate registripidajate veebikeskkondades

Juhendid DNS seadete muutmiseks populaarsemate registripidajate veebikeskkondades:

- [Domeeni
  suunamine Zone.ee keskkonnas](/tugi/domeenid/domeeni-suunamine-zone-ee-keskkonnas)
- [Domeeni
  suunamine Veebimajutus.ee keskkonnas](/tugi/domeenid/domeeni-suunamine-veebimajutus-ee-keskkonnas)
- [Domeeni suunamine Radicenter keskkonnas](/tugi/domeenid/domeeni-suunamine-radicenter-ee-keskkonnas)

  

Loe edasi [domeeni vaikekuju muutmise kohta](/tugi/domeenid/domeeni-seaded).
