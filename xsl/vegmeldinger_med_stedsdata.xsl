<xsl:stylesheet version="1.0" xml:lang="no" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Definer statusmeldinger -->
    <xsl:param name="KJØRE_FORHOLD" select='"Vær- og føreforhold"'/>


    <!-- Legger vegmeldinger-fila i en variabel -->
    <xsl:param name="vegmeldingerFil" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')"/>
    <!-- Lager et variabel for result-array -->
    <xsl:variable name="vegmeldinger" select="$vegmeldingerFil/searchresult/result-array/result"/>

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
                            <!-- Opprett fjellovergang objekt -->
                            <fjellovergang>
                                <!-- Opprett et attriutt for navn på veiforbindelse -->
                                <xsl:attribute name="navn">
                                    <xsl:value-of select="concat(roadType, ' ',roadNumber, ' ',heading)"/>
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
                                </stedsdata>
                                <yr-URL>
                                    <xsl:value-of select="concat('http://www.yr.no/sted/Norge/',$fylke,'/',$kommune,'/',$stedsnavn,'/varsel.xml')"/>
                                </yr-URL>
                            </fjellovergang>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>


            </xsl:for-each>
        </fjelloveranger>
    </xsl:template>

</xsl:stylesheet>