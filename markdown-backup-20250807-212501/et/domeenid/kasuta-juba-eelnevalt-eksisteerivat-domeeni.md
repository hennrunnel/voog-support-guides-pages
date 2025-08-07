# Kasutad juba eelnevalt eksisteerivat domeeni | Voog mitmekeelne koduleht ja e-pood

**Section:** Domeenid  
**Language:** et  
**Original URL:** https://www.voog.com/support/domeenid/kasuta-juba-eelnevalt-eksisteerivat-domeeni.html  
**Extracted:** 2025-08-05 07:49:05 UTC

---

Pärast seda, kui oled liitunud
Voog
Standard / Plus / Premium paketiga, saad sa
suunata juba olemasoleva aadressi (näiteks minudomeen.ee) oma Voo saidile.
Teise registripidaja juurest ostetud
domeeni kasutamiseks Voo keskkonnas tuleb importida domeen oma Voo saidileja seejärel suunata domeeni A-kirje Voo
serverite IP-aadressile 85.222.234.14
Välise domeeni importimine Voo
keskkonda
Esimese sammuna pead Voo keskkonnas siduma domeeninime ja enda saidi. See on vajalik, et meie süsteem
teaks, millist lehte päringu minudomeen.ee vastusena näidata.
Selleks liigu saidile, millega tahad domeeni siduda ja mine Seaded > Domeenid menüüsse. Klõpsa nupul Lisa uus ja vali Impordi
ning sisesta oma domeeninimi. Domeen kirjuta ilma www-eesliiteta, st www.minudomeen.ee
asemel kirjuta lihtsalt minudomeen.ee. Domeeni kujul
www.minudomeen.ee tunneb süsteem ära juba automaatselt.
DNS kirjete muutmineJärgmisena pead muutma oma registripidaja
halduskeskkonnas domeeni DNS kirjeid.
Logi sisse oma registripidaja halduskeskkonda.
Leia
haldusliidesest nimeserveri (DNS) seadistamise võimaluste alt
aadressi suunamise osa, näiteks IP suunamine (IP
Forwarding) või Muuda oma A-kirjet (Modifying
an A-Record). Tavaliselt leiad selle DNS
haldamise (Advanced DNS Management ) alajaotusest.
Muuda domeeni
A-kirje IP-aadress Voo serveri IP-aadressiks: 85.222.234.14 .
Lisa oma domeeni nimi A-kirjesse ilma www eesliiteta, kujul
minudomeen.ee.
Lisa
domeenile CNAME kirje www kolmanda astme domeeni jaoks. Kontrolli,
et kirje nimi oleks www.minudomeen.ee,
tüüp CNAME ja väärtus minudomeen.ee.
Sinu domeeni A-kirje ja CNAME peaksid nüüd sellised välja nägema:
NAME  		TYPEVALUEminudomeen.ee
A85.222.234.14www.minudomeen.eeCNAMEminudomeen.ee
Pärast IP-aadressi muutmist võib
minna kuni 48 tundi, enne kui muudetud kirje üle kogu interneti
levib ning antud aadressil hakkab avanema sinu Voo lehekülg. See
sõltub domeeni TTL (time to live) seadetest.
DNS seadete muutmine populaarsemate
registripidajate veebikeskkondades
Juhendid DNS seadete muutmiseks populaarsemate registripidajate veebikeskkondades:
Domeeni
suunamine Zone.ee keskkonnas
Domeeni
suunamine Veebimajutus.ee keskkonnasDomeeni suunamine Radicenter keskkonnas
Loe edasi domeeni vaikekuju muutmise kohta.

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
