---
title: Google Search Console tööriista ühendamine Vooga
lang: et
section: seo
slug: kuidas-ma-saan-oma-kodulehe-otsingumootorite-jaoks-nahtavaks-muuta
original_url: https://www.voog.com/tugi/seo/kuidas-ma-saan-oma-kodulehe-otsingumootorite-jaoks-nahtavaks-muuta
updated_at: 2025-08-07T21:25:01Z
word_count: 802
---
Kui oled just loonud uue veebilehe, ei tea sellest veel keegi, kaasa arvatud otsingumootorid. Kui tunned, et oled valmis oma lehte maailmale näitama, tuleks sellest otsingumootoritele teada anda. Lihtsaim viis seda teha on teatada oma saidist

- [otse Google'ile.](https://www.google.com/webmasters/tools/submit-url "Link: http://www.google.com/addurl/")
- või ühendada enda veebileht [Bing Webmaster's tööriistaga.](https://www.bing.com/toolbox/webmaster/ "Link: http://www.bing.com/docs/submit.aspx")
- samuti on võimalik kasutada keerulisemat ja võimsamat tööriista [Google Search Console](https://search.google.com/search-console/about "Link: http://www.google.com/webmasters/") (varasema nimega Google Webmasters Tools). See on tasuta teenus, mis annab sulle rohkem kontrolli selle üle, kuidas otsingumootorid sinu lehte näevad.

## Google Search Console tööriista ühendamine Vooga

Google Search Console'iga alustamiseks pead olema sisse logitud Google'i kontole. Vasakul menüüs näed võimalust domeeniomandi otsimiseks. Vali **Search property** ja **Add property.** Kui sinu aadess on lisatud, palub Google sul tõestada, et oled selle lehekülje omanik. Vali **URL prefix** tõestamismeetodina.  

![Veebilehekülje URL Google Search Console tööriista 'URL prefix' tõestamismeetodi lahtris.](https://media.voog.com/0000/0036/2183/photos/Google_search_console_1_block.webp "Veebilehekülje URL Google Search Console tööriista 'URL prefix' tõestamismeetodi lahtris.")

Sulle antakse kood, mis näeb välja umbes nii: **googlef52f1d814b8972e9.html**.

![Google Search Console'i verifitseerimiskood selle seadistamise aknas.](https://media.voog.com/0000/0036/2183/photos/Google_search_console_2_block.webp "Google Search Console'i verifitseerimiskood selle seadistamise aknas.")

Selle koodi pead nüüd oma Voo saidile lisama. Koodi lisamiseks klõpsa all tööriistaribal **Sisu** > **SEO**. **SEO** vaates olles liigu allapoole kuni leiad lahtri **Google Search Console'i verifitseerimiskood**. Sisesta kood lahtrisse ja vajuta **Salvesta**. Seejärel saad tõestamisprotsessi lõpetada, vajutades oma Google Search Console'i lehel **Verify**.

Jälgi, et sisestaksid Google Search Console'i lehel õige domeeni aadressi. Kui soovid oma lehte tutvustada aadressiga 'https://www.mycompany.com' siis sisesta just see aadress, mitte 'https://mycompany.com'.

Samuti on hea idee sisestada Google Search Console kasutajale oma [sitemap.xml](/tugi/seo/seo-optimeerimine-voos#sisukaart-ja-robotid) aadress. Voog genereerib sinu saidi sitemap.xml aadressi automaatselt. Selle leidmiseks lisa oma veebiaadressi lõppu „sitemap.xml“ (näiteks www.minufirma.ee/sitemap.xml). Selle aadressi võid postitada Google Search Console'is liikudes menüüs **Index** > **Sitemaps** sektsiooni. Kui soovid anda Google’ile käsu oma lehte re-indekseerida (kui oled näiteks mõningaid muudatusi teinud), siis lihtsalt sisesta oma sitemap uuesti.

Kui oled oma saidi otsingumootoritesse sisestanud, siis jääb sul ainult seda reklaamida.

## Bing Webmaster tööriista ühendamine Vooga

Kõigepealt loo endale **Bingi / Microsofti** konto või [logi juba olemasolevale kontole sisse.](https://www.bing.com/toolbox/webmaster/)

Seejärel saad enda personaalse domeeni lisada profiilile **Add a site** väljalt ja sisestatud aadressi salvestada **Add** nupuga. Vaata kõiki vajalikke samme [Bing Webmaster tööriista seadistamiseks](https://www.bing.com/webmaster/help/getting-started-checklist-66a806de).

Domeeni verifitseerimiseks CNAME kaudu kopeeri CNAME kood enda Bingi profiililt ning saada oma registripidajale. Kui sinu domeen on meie juurest ostetud, siis saad uue CNAME kirje domeeni DNS seadetesse ise lisada, avades **Seaded** > **Domeenid**. Domeeninime kõrval on hammasrattaikoon, kust saad avada domeeni seaded ja sealt edasi DNS seaded.

Uus CNAME kirje peaks sisaldama järgnevat informatsiooni:

|  |  |  |
| --- | --- | --- |
| ***Alamdomeen:*** | ***Tüüp:*** | ***Asukoht:*** |
| *(verifitseerimiskood)* | *CNAME* | *verify.bing.com.* |

  

Kui oled CNAME kirje lisanud ja salvestanud, võidki suunduda tagasi enda Bingi lehele ning domeeni **Verify** lingilt ära verifitseerida. Roheline teade annab märku, et domeen on edukalt ühendatud, punane aga seevastu tähendab, et midagi on valesti. Anna sellele mõni tund kuni päev toimima hakkamiseks.

Teine võimalus on kasutada *<meta> tag*’i, mille saad sisestada **Seaded** > **Sait** lehe **Päise kood** väljale.

## Uuendasin hiljuti oma veebilehte, kuid otsingumootor kuvab ikka veel vana infot. Mida teha?

Kui oled muutnud oma veebilehe struktuuri, kustutanud lehti või lisanud uusi lehti, siis on alati hea idee [paluda Google'il oma veebilehte uuesti indekseerida](https://support.google.com/webmasters/answer/6065812?hl=en). See on väga hea tööriist, sest see aitab veebilehe informatsiooni õigena ja ajakohasena hoida.  

## Kuidas enda sait või mõni kindel leht Google'i otsingutulemustest eemaldada?

Google võib sinu veebilehe nii ära indekseerida, et see ei ole sinu jaoks just kõige sobilikum — näiteks on otsingutulemustes kuvatud leht, mis tegelikult on ära kustutatud. Sa saad Google'ile märku anda, et nad selle tulemuse teiste seast eemaldaks.   
  
Kui su sait on ühendatud Google Search Console tööriistaga, siis kõigepealt tuleb kustutada oma sait või saidil olevad alamlehed ning seejärel logida oma Google Search Console kontole ning valida vasakust menüüst Google Index - Remove URLs. Kui eelnevalt saiti kustutatud ei ole, siis see rakendus peidab teie veebisaidi otsingumootoritest vaid ajutiselt, 90 päevaks. Täpsema informatsiooni leiad meie inglise keelsest blogipostitusest [How to remove your website or web page from Google](/blog/how-to-remove-your-website-or-web-page-from-google).  
  
Kui sa oled hiljuti oma saidil muudatusi teinud, siis sa saad paluda Google’il see uuesti indekseerida, kasutades [URL Inspection Tool](https://support.google.com/webmasters/answer/6065812?hl=en) tööriista.
