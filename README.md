# Dos Tomios

**For my English speaking friends**: a fun project comparing word usage by real [Tomio Okamura](https://twitter.com/tomio_cz) (Czech xenophobe of Japanese descent) and [a fake account](https://twitter.com/Tomio_Okamura) operated in his name by an unknown prankster. 

As this project is relevant mostly to Czech Republic the description will continue in Czech language.

<hr>

**Pro mé česky hovořící přátele**: malý projekt na technickou analýzu timeliny skutečného Tomio Okamury (@tomio_cz) a jeho fejkového alter ega (@Tomio_Okamura).

<p align="center">
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/tomio_cz.jpg?raw=true" alt="skutečný Tomio"/>
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/tomio_okamura.jpg?raw=true" alt="fejkový Tomio"/>
</p>


### Cílem snažení je:
* ukázat, jak se tweety na těchto dvou účtech jazykově liší 
* navrhnout jednoduché klasifikační pravidlo, které tweety rozdělilo na pravého a falešného Tomia

### Výsledkem snažení je:
* erkový kód na stažení timeliny obou Tomiů (celkem je to necelých 5000 tweetů), rozbití do slov (78 tisíc slov, to je obsah tak čtyř, na VŠE možná pěti diplomek)
* porovnání relativní četnosti (účty mají nestejný počet tweetů, takže absolutní hodnoty jsou neporovnatelné) hlavních slovních druhů oběma účty
* jednoduchý rozhodovací strom, který dokáže s jistotou přes 90% určit, zda ten či který tweet pochází od skutečného, či fejkového Tomia

<p align="center">
  <img src="https://github.com/jlacko/dos-tomios/blob/master/img/decision-tree.png?raw=true" alt="rozhodovací strom"/>
</p>
