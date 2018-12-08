# Dos Tomios

**For my English speaking friends**: a fun project comparing word usage by real [Tomio Okamura](https://twitter.com/tomio_cz) (Czech xenophobe of Japanese descent) and [a fake account](https://twitter.com/Tomio_Okamura) operated in his name by an unknown prankster. 

As this project is relevant mainly to the Czech Republic the description will continue in the Czech language.

<hr>

**Pro mé česky hovořící přátele**: malý projekt, který si klade za cíl technickou analýzu twitterové timeliny skutečného Tomio Okamury ([@tomio_cz](https://twitter.com/tomio_cz)) a jeho fejkového alter ega ([@Tomio_Okamura](https://twitter.com/tomio_okamura)).  

Dle vypozorovaných odlišností navrhuje klasifikační algoritmus, který dokáže s vysokou mírou jistoty z textu rozpoznat, zda jeho autor má na profilovce v rohu vlaječku nebo, hm..., něco jiného.

<p align="center">
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/tomio_cz.jpg?raw=true" alt="opravdický Tomio"/>
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/tomio_okamura.jpg?raw=true" alt="fejkový Tomio"/>
</p>


### Technicky:
* pracuju ve světě `tidyverse`, takže `dplyr` a `ggplot` místo base R
* pro stažení dat používám [`rtweet`](https://rtweet.info/)
* pro rozbití textu na slova [`udpipe`](https://bnosac.github.io/udpipe/docs/doc1.html)
* pro klasifikaci [`rpart`](https://cran.r-project.org/web/packages/rpart/rpart.pdf) - zejména proto, že se dobře ukazuje; sofistikovanější techniky typu ensemble metod či neuronek by byly možná přesnější, ale za cenu horší srozumitelnosti výstupu.

<p align="center">
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/NOUN.png?raw=true" alt="podstatná jména"/>
</p>

### Výsledkem snažení je:
* erkový kód na stažení timeliny obou Tomiů (celkem je to necelých 5000 tweetů), rozbití do slov (78 tisíc slov, to je obsah tak čtyř, na VŠE možná pěti diplomek)
* porovnání relativní četnosti (účty mají nestejný počet tweetů, takže absolutní hodnoty jsou neporovnatelné) hlavních slovních druhů oběma účty
* jednoduchý rozhodovací strom, který dokáže s jistotou přes 90% určit, zda ten či který tweet pochází od skutečného, či fejkového Tomia

<p align="center">
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/decision-tree.png?raw=true" alt="rozhodovací strom"/>
</p>

### Obsahem repozitáře je:
Erkový kód, rozdělený pro přehlednost do pěti kroků v samostatných souborech:
- stažení dat z twitteru; vyžaduje vlastní přístupové heslo (v duchu hesla piju za svý) - tento krok lze přeskočit
- tokenizaci textu z tweetů do slov
- frekvenční analýzu po slovních druzích a přípravu obrázků do adresáře /img
- zpracování podkladu pro klasifikaci, včetně lehkého feature engineeringu dle poznatků z předchozí odrážky
- vlastní klasifikace - zde pomocí stromu, ale jiné metody mohou dát jiné (i přesnější) výsledky

V adresáři /data jsou podkladová data aktuální k začátku prosince 2018. Takže repo bude fungovat i bez hesla k twitteru, jenom nebude tak žhavě aktuální.

