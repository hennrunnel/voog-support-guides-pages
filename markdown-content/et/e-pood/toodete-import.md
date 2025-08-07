---
title: Nõuanded edukaks toodete importimiseks
lang: et
section: e-pood
slug: toodete-import
original_url: https://www.voog.com/tugi/e-pood/toodete-import
updated_at: 2025-08-07T21:25:01Z
word_count: 982
---
## Nõuanded edukaks toodete importimiseks

**Üldine**  

- Korraga saab importida ühe keele piires - nime tõlked tuleb importida eraldi.
- Kui valid toodete uuendamise, siis variatsioonidega toote puhul eemaldatakse uuendatava toote variatsioonid, mille ridu impordifailis ei ole.

  
**Impordifail**  

- Impordi fail võib sisaldada **maksimaalselt** **10000** rida.
- Impordifaili **suurus** võib olla maksimaalselt **10 MB**.
- Toetatud **failiformaadid**: **XLSX, ODS, CSV**.
- Uue, **ilma variatsioonideta toote** edukaks impordiks on **minimaalselt vaja kahte veergu** - **toote nimi** ja **hind.**
- **Variatsiooniga toote** importfailis **peab olema põhitoote rida ning talle järgnevad variatsioonide read st minimaalselt 5 veergu** - **ID**, **Ülem ID**, **Variatsiooni valikud**, **Nimi**, **Hind**.

**T****oodete impordfaili põhjad**  
 Impordifaili põhjana võid kasutada nii oma veebilehelt alla laaditud toodete [ekspordifaili](/tugi/e-pood/tellimuste-haldamine#tellimuste-filtreerimine-ja-eksport), meie [näidispõhja](https://media.voog.com/0000/0036/2183/files/toodete-importfaili-naidis.xlsx) või koostada faili ise.

## Importimisel toetatud importfaili väljad

Toote importimisel on toetatud järgnevate andmete import, mis on tootega seotud:  
  

- **ID** – toote tunnus, kasutatakse toote uuendamisel ja variatsioonidega toodete impordil.
- **Ülem-ID** – tootevariatsiooni real temaga seotud põhitoote ID, kasutatakse variatsioonide importimisel.
- **Tootekood** – toote kood (SKU vms).
- **Nimi** – toote nimi vastavas keeles (tootevariatsiooni rea puhul ignoreeritakse).
- **Aadress** – toote URLi osa nt /et/tooted/minu-toode puhul minu-toode (impordil arvestatakse vaid põhitoote rea väärtust).
- **Variatsiooni valikud** – tootevariatsiooniga seotud variatsioonitüübid kujul Suurus: S, Värv: Must (dimensiooni eraldajaks on koma ning väärtuse eraldajaks koolon).
- **Kirjeldus** – toote kirjeldus vastavas keeles (tootevariatsiooni rea puhul ignoreeritakse).
- **Hind** – toote/variatsiooni netohind poe valuutas (põhitootel kohustuslik, variatsioonil valikuline).
- **Soodushind** – toote/variatsiooni neto soodushind poe valuutas (põhitootel valikuline, variatsioonil valikuline).
- **Laos** – saada olev kogus, kui on tühi, siis piiramatu lao kogus.
- **Olek** – toote/variatsiooni nähtavus (lubatud väärtused Avalik / Mustand (või inglise keeles Live / Draft)).
- **Kategooriad** – tootega seotud kategooriad vastavas keeles, eraldajaks koma (nt Lamu, Teine kat) (tühiväärtus eemaldab kategooriad, tootevariatsiooni rea puhul ignoreeritakse).
- **Meta kirjeldus** - kui oma tootelehe linki sotsiaalmeedias jagad, saad sellele lisada sobiva toote kirjelduse ehk OG kirjelduse (Open Graph Description).
- **Pikkus** – toote pikkus meetrites.
- **Laius** – toote laius meetrites.
- **Kõrgus** – toote kõrgus meetrites.
- **Kaal** – toote kaal kilogrammides.

  
 Kui laadid oma kodulehelt olemasolevate [toodete ekspordi faili alla](/tugi/e-pood/tellimuste-haldamine#filtreerimine-ja-eksport), siis saad

samamoodi üleval mainitud veergude nimetused kätte.

## Impordifaili struktuur

Impordi fail koosneb päisereast ja sellele järgnevatest imporditavate toodete ridadest.  
 Veergude tüübi automaatse tuvastamise hõlbustamiseks soovitame kasutada samu väljade nimetusi nagu eelpool kirjeldatud [toetatud impordiväljade sektsioonis.](/tugi/e-pood/toodete-import#importimisel-toetatud-importfaili-vljad)  
  

- **Ilma variatsioonideta too****t****e import -** iga toode on eraldi real. Minimaalsed veerud on   
  “Nimi” ja “Hind” loomisel ning “ID”, “Nimi” ja “Hind” uuendamise.  
  [Ilma variatsioonideta toote/toodete importfaili näidisfail.](https://media.voog.com/0000/0036/2183/files/toote-importfail-ilma-variatsioonideta-et.xlsx)
- **Variatsioonidega toote import -** iga toote kohta on 2-N rida.   
  Esimene, põhitoote rida ehk matrix sisaldab toote põhiandmeid (nt, nimi, aadress, kategooriad, vaike hind). Sellele järgnevad toote variatsiooni read, mille “Ülem-id” väärtusel peab vastama põhitoote “ID” veeru väärtusel.  
  [Variatsioonidega toote/toodete importfaili näidisfail.](https://media.voog.com/0000/0036/2183/files/toote-importfail-variatsiooniga-tootel-et.xlsx)

## Toodete impordi protsess

1. Liigu **Pood** > **Tooted** vaatesse, klõpsa lehe üleval nurgas kolmel punktikesel ning avanenud aknas vali **Impordi tooteid. Pane tähele, et toodete importimiseks on oluline, et kõik lisatav info oleks õige formaadi ja [struktuuriga](/tugi/e-pood/toodete-import#impordifaili-struktuur).**  
Lisaks on **toodete importimiseks oluline, et kõik lisatav info oleks õige formaadi ja [struktuuriga](/tugi/e-pood/toodete-import#impordifaili-struktuur).** Kui vähemalt üks toode (toode võib-olla siis üksiktoode, või põhitoode + variatsioon), ei valideeru või on vigane, siis tühistatakse kogu import. Samas teatud tingimustel rida ignoreeritakse. Näiteks, kui esimene rida on kohe variatsiooni rida ning tema põhitooterida puudub, siis variatsiooni rida ignoreeritakse ning imporditakse esimene põhitoode, kui see järgmistel ridadel leidub.  
**![Kursor nupul 'Impordi tooteid' toodete haldusmenüüs.](https://media.voog.com/0000/0036/2183/photos/Toodete_import_block.webp "Kursor nupul 'Impordi tooteid' toodete haldusmenüüs.")**2. Avanenud **Impordi tooteid** lehel saad üles laadida imporditava faili (eelistatult XLSX, ODS fail). Enne toodete importi ole hea ja tutvu:  

- [tõlgitavate väljade impordi infoga](https://www.voog.com/tugi/e-pood/toodete-import#toote-tlgete-import)
- [impordifaili näidisfailiga](https://media.voog.com/0000/0036/2183/files/toodete-importfaili-naidis.xlsx)

![Impordi tooteid vaade](https://media.voog.com/0000/0036/2183/photos/impordi_tooteid_vaade_ee_block.jpg "Impordi tooteid vaade")

3. Vali, millises keeles soovid tooteid importida.  
4. Määra veergude ja tootevälja vasted. Saad vajadusel automaatselt tuvastatud vasted korrigeerida. Peale importfaili ülesse laadimist kuvatakse sulle **Impordi tooteid** vaates kõiki failis leiduvaid veerge, nende esimese 4 rea sisu ning valikut, kas üldse ning millise väljana mingi veerg imporditakse. Pane tähele, et imporditakse ainult veerud, millele on väli määratud.  
5. Kui klõpsad **Alusta importi** nupul annab süsteem sulle märku, et toodete import pandi tööle. Impordi töö lõppedes saadetakse sulle e-postile teavitus, et toodete import on lõpetatud. Teavitus saadetakse, nii eduka kui ka ebaeduka impordi korral.  
  
Kui sulged impordi vaate, siis näed toote listivaates filtri nupu kõrval "X imports" menüüd, kus on näha lõpetatud ja töös/järjekorras olevad impottööd.  

## Toote tõlgete import

Kui sinu e-poes oleval tootel on tõlgitavad väljad, siis need on tarvis importida keeles, mis on **Impordi tooteid** vaates ehk dialoogis määratud.  
  
 Kui soovid importida toote tõlkeid (näiteks: Nimi, Aadress, Kirjeldus) massiliselt siis toimi järgnevalt.  
  

1. Laadi alla ehk ekspordi soovitud tooted.
2. Jäta allalaetud failis alles vähemalt ”ID, Ülem-ID, Nimi, Aadress, Kirjeldus” veerud.  
   Vaata ka näitena toodud [toote tõlke importfaili](https://media.voog.com/0000/0036/2183/files/toodete-import-tolked-ee.xlsx) ülesehitust.
3. Tõlgi need allaletud faili keelele vastavaks.
4. **Impordi tooteid** vaates vali teine keel, kuhu soovid tooted importida.
5. **Impordi tooteid** vaates vali “Kirjuta olemasolevad tooted üle, kui ID väli kattub”.

## **Oluline info peale toodete importi**

Toodete nimekirja vaates olles uuendatakse import tööd regulaarselt, kui mõni töö on parasjagu pooleli. Pane tähele, et kui toote importimine lõpeb ja oled tootenimekirja vaates, siis toodete nimekiri laaditakse uuesti.  
  
 Pane tähele, kui importimisel midagi ei lähe nii nagu tarvis (mõni rida ebaõnnestub), siis keeratakse kogu muudatus tagasi ja ühtegi toodet ei impordita.
