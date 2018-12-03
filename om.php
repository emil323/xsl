<?php
include("html/header.html");
?>
    <article id="om">
        <h2>Om Fjelloverganger</h2>
        <br>
        <h3>Om applikasjonen</h3>
        <p>Fjelloverganger er en web-applikasjon som viser de mest traffikerte fjelloverganger i Sør-Norge, med væropplysinger og kjøreforhold.
        Dette gjør vi ved å kombinere vær og vei data fra statensvegvesen, yr og kartverkets sine åpne data, og samler dette på siden vår
        slik at det skal være enklere å velge riktig rute over fjellet.</p>

        <br>
        <h3>Om bruk av åpne data</h3>
        <p>Takket være det gode tilbudet åpne data i Norge som er tilgjenlig, gjennom blant annet portalen data.norge.no har vi funnet de datasett
            som vi ville ta i bruk i vår web-applikasjon. Vi valgte akkurat disse datasettene fordi vi så potensiale for at de
            kunne kombineres på en informativ og god måte. Begge datasett hadde likhetstrekk. Vi har også brukt kartverktets stedsnavn
            api som en hjelper å finne riktig lokalisjon fra statensvegvesen vegmelding, slik at vi finner riktig værmelding til den aktuelle fjellovergangen.</p>

        <br>
        <h4>Statens Vegvesen</h4>
        <p>Statens vegvesen leverer kjøreforhold</p>
        <p>Vi bruker XML filen vegmeldinger fra statensvegvesen. Som innholder generell info om den aktuelle fjellovergangen, om den er stengt
            og i såfall tidsrommet den er stengt, redusert traffikk, eventuell kolonnekjøring.</p>

        <br>
        <h4>Yr.no</h4>
        <p>Yr.no leverer værdata</p>
        <p>Yr har en litt anderledes struktur på datasettene sine, her trenger man fylke, kommune og sted for å finne riktig datasett.
        Xml filen inneholder generell værmelding i tekstformat pluss nøkkeltall som vindretning og temperatur</p>
    </article>


<?php
include("html/footer.html");
?>