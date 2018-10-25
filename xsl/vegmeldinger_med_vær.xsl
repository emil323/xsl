<xsl:stylesheet version="1.0" xml:lang="no" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Definer statusmeldinger -->
    <xsl:param name="KJØRE_FORHOLD" select='"Vær- og føreforhold"'/>


    <!-- Legger vegmeldinger-fila i en variabel -->
    <xsl:param name="vegmeldingerFil" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')"/>
    <!-- Lager et variabel for result-array -->
    <xsl:variable name="vegmeldinger" select="$vegmeldingerFil/searchresult/result-array/result"/>
    <!-- Variabel for utvalg av fjelloverganger-->
    <xsl:variable name="utvalg" select="document('../xml/utvalg.xml')/utvalg"/>

    <xsl:template match="/">
        <!-- definer rot -->
        <fjelloveranger>
            <!-- kjør forloop på alle fjelloverganger -->
            <xsl:for-each select="$vegmeldinger">
                <xsl:variable name="identifikasjon" select="heading"/>
                <xsl:variable name="veimelding" select="messages"/>

                <!-- Hent ut vei fra utvalg, herfra definerer vi variabelet vei, som gir oss fylke, kommune osv.. for å sjekke opp værdata -->
                <xsl:variable name="vei" select="$utvalg/fjellovergang[@identifikasjon=$identifikasjon]"/>

                <!-- Sjekk om vei er definert, dvs at fjellovergangen er en del av vårt ønsket utvalg -->
                <xsl:if test="$vei">
                    <fjellovergang>
                        <!-- Kjør for-each på meldinger, eller "messages" -->
                        <xsl:for-each select="$veimelding/message">
                            <!-- Hent ut kjøreforhold -->
                            <xsl:if test="messageType = $KJØRE_FORHOLD">
                                <!-- Opprett et attriutt for navn på veiforbindelse -->
                                <xsl:attribute name="navn">
                                    <xsl:value-of select="concat(roadType, ' ',roadNumber, ' ',heading)"/>
                                </xsl:attribute>
                                <!-- Hent ut kjøreforhold -->
                                <kjøreforhold>
                                    <xsl:value-of select="ingress"/>
                                </kjøreforhold>
                                <beskrivelse>
                                    <xsl:value-of select="freetext"/>
                                </beskrivelse>
                                <meldingsType>
                                    <xsl:value-of select="messageType"/>
                                </meldingsType>
                                <hastverk>
                                    <xsl:value-of select="urgency"/>
                                </hastverk>
                                <veinummer>
                                    <xsl:value-of select="roadNumber"/>
                                </veinummer>
                                <gyldigFra>
                                    <xsl:value-of select="validFrom"/>
                                </gyldigFra>
                                <gyldigTil>
                                    <xsl:value-of select="validTo"/>
                                </gyldigTil>
                            </xsl:if>
                        </xsl:for-each>

                        <!-- Hent ut værmelding fra YR
                             Definer fylke, kommune og stednavn -->
                        <xsl:variable name="fylke" select="$vei/@fylke"/>
                        <xsl:variable name="kommune" select="$vei/@kommune"/>
                        <xsl:variable name="stedsnavn" select="$vei/@stedsnavn"/>

                        <xsl:variable name="yrURL"
                                      select="concat('http://www.yr.no/sted/Norge/',$fylke, '/',$kommune,'/',$stedsnavn,'/varsel_time_for_time.xml')"/>
                        <xsl:variable name="værmelding" select="document($yrURL)/weatherdata"/>

                        <!-- Bygg opp et værvarsel time for time -->
                        <værvarsel>
                            <!-- Lenke til det originale værvarsel, pga retningslinjer til YR -->
                            <xsl:copy-of select="$værmelding/credit/link"/>
                            <!-- Lag liste med timevarsel -->
                            <timevarsel>
                                <xsl:for-each select="$værmelding/forecast/tabular/time">
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
                            </timevarsel>
                        </værvarsel>
                    </fjellovergang>
                </xsl:if>


            </xsl:for-each>
        </fjelloveranger>
    </xsl:template>

</xsl:stylesheet>