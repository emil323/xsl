<xsl:stylesheet version="1.0" xml:lang="no" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Definer statusmeldinger -->
    <xsl:param name="KJØRE_FORHOLD" select='"Vær- og føreforhold"'/>


    <!-- Legger vegmeldinger-fila i en variabel -->

    <!-- VIKTIG: Vi har lastet opp en lokal kopi av vegvesen API'et, dersom APIet skulle svikte.
     -->
    <!-- Henter en oppdatert XML-fil fra Vegvesen.no -->
    <xsl:param name="vegmeldingerFil" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')"/>

    <!-- Bruker en lokal kopi av XML-filen. Denne er ikke oppdatert, men kan brukes om den fra Statens Vegvesen ikke kan lastes inn
        KOMMENTER UT DENNE DERSOM NETTISDEN IKKE LASTER
    -->
    <!-- <xsl:param name="vegmeldingerFil" select="document('../xml/veidataLokalKopi.xml')"/> -->

    <!-- Henter xml fil ignorerte veier-->
    <xsl:param name="ignorertFil" select="document('../xml/ignorerte.xml')"/>

    <!-- Lager et variabel for result-array til vegvesen XMLen-->
    <xsl:variable name="vegmeldinger" select="$vegmeldingerFil/searchresult/result-array/result"/>

    <!-- Hent ut XML fil  -->
    <xsl:variable name="ignorerte-veier" select="$ignorertFil/ignorerte-veier"/>

    <xsl:template match="/">
        <!-- definer rot -->
        <fjelloveranger>
            <!-- kjør forloop på alle fjelloverganger -->
            <xsl:for-each select="$vegmeldinger">
                <xsl:variable name="veimelding" select="messages"/>

                <!-- Kjør for-each på meldinger, eller "messages" -->
                <xsl:for-each select="$veimelding/message">
                    <!-- Hent ut kjøreforhold -->
                    <xsl:if test="messageType = $KJØRE_FORHOLD">

                        <!-- Hent ut stedsnavn, dette trenger vi for å bruke YR APIet -->
                        <xsl:variable name="muligStedsnavn" select="substring-before(concat(heading,' '),' ')"/>

                        <xsl:variable name="kartverketURL"
                                      select="concat('https://ws.geonorge.no/SKWS3Index/ssr/sok?navn=', $muligStedsnavn)"/>
                        <xsl:variable name="stedsdata" select="document($kartverketURL)/sokRes"/>

                        <!-- Finner vi stednavn data? -->
                        <xsl:if test="$stedsdata/stedsnavn">
                            <xsl:variable name="navn" select="concat(roadType, ' ',roadNumber, ' ',heading)"/>

                            <!-- sjekk om veien IKKE finnes i ignorte veier -->
                            <xsl:if test="boolean($ignorerte-veier/vei = $navn) = 0">

                            <!-- Opprett fjellovergang objekt -->
                            <fjellovergang>
                                <!-- Opprett et attriutt for navn på veiforbindelse -->
                                <xsl:attribute name="navn">
                                    <xsl:value-of select="$navn"/>
                                </xsl:attribute>
                                <!-- Hent ut kjøreforhold -->
                                <veiforhold>
                                    <xsl:value-of select="ingress"/>
                                </veiforhold>
                                <hastverk>
                                    <xsl:value-of select="urgency"/>
                                </hastverk>
                                <gyldigFra>
                                    <xsl:value-of select="validFrom"/>
                                </gyldigFra>
                                <!-- Opprett stedsdata objekt , og fyll ut fylke, kommune og stedsnavn
                                     Dette gjøres fordi YR-API'et krever det.-->
                                <xsl:variable name="sted" select="$stedsdata/stedsnavn[1]"/>

                                <xsl:variable name="fylke" select="$sted/fylkesnavn"/>
                                <xsl:variable name="kommune" select="$sted/kommunenavn"/>
                                <xsl:variable name="stedsnavn" select="$sted/stedsnavn"/>

                                <stedsdata>
                                    <fylke>
                                        <xsl:value-of select="$fylke"/>
                                    </fylke>
                                    <kommune>
                                        <xsl:value-of select="$kommune"/>
                                    </kommune>
                                    <stedsnavn>
                                        <xsl:value-of select="$stedsnavn"/>
                                    </stedsnavn>
                                    <koordinater>
                                        <xsl:attribute name="breddegrad">
                                            <xsl:value-of select="coordinates/startPoint/xCoord"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="lengdegrad">
                                            <xsl:value-of select="coordinates/startPoint/yCoord"/>
                                        </xsl:attribute>
                                    </koordinater>
                                </stedsdata>
                                <yrURL>
                                    <xsl:value-of
                                            select="concat('http://www.yr.no/sted/Norge/',$fylke,'/',$kommune,'/',$stedsnavn,'/varsel.xml')"/>
                                </yrURL>
                            </fjellovergang>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>

            </xsl:for-each>
        </fjelloveranger>
    </xsl:template>

</xsl:stylesheet>