<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Definer statusmeldinger -->
    <xsl:param name="KJØRE_FORHOLD" select='"Vær- og føreforhold"'/>

    <xsl:param name="test" select='"Vær- og føreforhold"'/>
    <!-- Legger vegmeldinger-fila i en variabel -->
    <xsl:param name="vegmeldingerFil" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')"/>
    <!-- Lager et variabel for result-array -->
    <xsl:variable name="vegmeldinger" select="$vegmeldingerFil/searchresult/result-array/result"/>

    <xsl:template match="/">
        <!-- definer rot -->
        <fjelloveranger>
            <!-- kjør forloop på alle fjelloverganger -->
            <xsl:for-each select="$vegmeldinger">
                <!-- Sjekk om kjøreforld finnes i veimelding, viss ikke så er det ikke interessant for oss -->
                <xsl:if test="messages/message/messageType = $KJØRE_FORHOLD">
                <!-- Definer fjellovergang -->
                <fjellovergang>
                    <!-- Legg til navn attributt for taggen <fjellovergang> -->
                    <xsl:attribute name="navn">
                        <xsl:value-of select="heading"/>
                    </xsl:attribute>
                    <!-- Kjør for-each på meldinger, eller "messages" -->
                    <xsl:for-each select="messages/message">
                        <!-- Hent ut kjøreforhold -->
                        <xsl:if test="messageType = $KJØRE_FORHOLD">
                            <!-- Hent ut kjøreforhold -->
                            <kjøreforhold>
                                <xsl:value-of select="ingress"/>
                            </kjøreforhold>

                            <!-- Hent ut stedsnavn fra stednavn registeret til Kartverket" -->
                            <xsl:variable name="muligStedsnavn" select="substring-before(concat(heading,' '), ' ')"/>

                            <xsl:variable name="kartURL"
                                          select="concat('https://ws.geonorge.no/SKWS3Index/ssr/sok?navn=',$muligStedsnavn)"/>
                            <xsl:variable name="stedData" select="document($kartURL)/sokRes"/>

                            <!-- Viktig: Vi tar en if test for å se om vi har fått noe igjen fra kartverket -->
                            <xsl:if test="$stedData/stedsnavn">

                                <!-- Konstruer URL til YR API'et, for å hente ut værvarsel -->

                                <xsl:variable name="fylke" select="$stedData/stedsnavn/fylkesnavn"/>
                                <xsl:variable name="kommune" select="$stedData/stedsnavn/kommunenavn"/>
                                <xsl:variable name="stedsnavn" select="$stedData/stedsnavn/stedsnavn"/>

                                <xsl:variable name="yrURL"
                                              select="concat('http://www.yr.no/sted/Norge/',$fylke, '/',$kommune,'/',$muligStedsnavn,'/varsel_time_for_time.xml')"/>
                                <xsl:variable name="værmelding" select="document($yrURL)/weatherdata/forecast/tabular"/>
                                <yrURL><xsl:value-of select="$yrURL"/></yrURL>
                                <!-- Bygg opp et værvarsel time for time -->
                                <værvarsel>
                                    <xsl:for-each select="$værmelding/time">
                                        <!-- Bygg opp time varsel-->
                                        <time>
                                            <!-- Legg til attributter for fra og til tidspunk -->
                                            <xsl:attribute name="fra">
                                                <xsl:value-of select="@from"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="til">
                                                <xsl:value-of select="@to"/>
                                            </xsl:attribute>

                                            <!-- Legg til antall estimert mm nedbør-->
                                            <nedbør>
                                                <xsl:attribute name="mm">
                                                    <xsl:value-of select="precipitation/@value"/>
                                                </xsl:attribute>
                                            </nedbør>
                                            <!-- Legg til temperatur -->
                                            <temperatur>
                                                <xsl:attribute name="celcius">
                                                    <xsl:value-of select="temperature/@value"/>
                                                </xsl:attribute>
                                            </temperatur>
                                            <!-- Legg til vindhastighet -->
                                            <vind>
                                                <xsl:attribute name="mps">
                                                    <xsl:value-of select="windSpeed/@mps"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="styrke">
                                                    <xsl:value-of select="windSpeed/@name"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="retning">
                                                    <xsl:value-of select="windDirection/@name"/>
                                                </xsl:attribute>
                                            </vind>
                                            <!-- Legg til URL for symbol -->
                                            <xsl:variable name="symbolURL"
                                                          select="concat('https://api.met.no/weatherapi/weathericon/1.1/?symbol=',symbol/@number,'&amp;content_type=image/png')"/>
                                            <symbol>
                                                <xsl:value-of select="$symbolURL"/>
                                            </symbol>
                                        </time>

                                    </xsl:for-each>

                                </værvarsel>

                            </xsl:if>
                        </xsl:if>


                    </xsl:for-each>

                </fjellovergang>
                </xsl:if>
            </xsl:for-each>
        </fjelloveranger>
    </xsl:template>

</xsl:stylesheet>