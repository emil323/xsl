<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Definer statusmeldinger -->
    <xsl:param name="KJØRE_FORHOLD" select='"Vær- og føreforhold"' />

    <xsl:param name="test" select='"Vær- og føreforhold"' />
    <!-- Legger vegmeldinger-fila i en variabel -->
    <xsl:param name="vegmeldingerFil" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')" />
    <!-- Lager et variabel for result-array -->
    <xsl:variable name="vegmeldinger" select="$vegmeldingerFil/searchresult/result-array/result" />

    <xsl:template match="/">
        <!-- definer rot -->
        <fjelloveranger>
            <test><xsl:value-of select="$test"/></test>
        <!-- kjør forloop på alle fjelloverganger -->
        <xsl:for-each select="$vegmeldinger">
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
                        <!-- Hent ut værdata ved hjelp av koordinatene
                            Til det trenger vi breddegrad og lengdegrad -->
                        <xsl:variable name="muligStedsnavn" select="heading" />
                        <xsl:variable name="kartURL" select="concat('https://ws.geonorge.no/SKWS3Index/ssr/sok?navn=',$muligStedsnavn)"/>

                        <xsl:variable name="stedData" select="document($kartURL)/sokRes" />
                        <xsl:if test="$stedData/stedsnavn">

                            <xsl:variable name="fylke" select="$stedData/stedsnavn/fylkesnavn"/>
                            <xsl:variable name="kommune" select="$stedData/stedsnavn/kommunenavn"/>
                            <xsl:variable name="stedsnavn" select="$stedData/stedsnavn/stedsnavn"/>

                            <xsl:variable name="yrURL" select="concat('http://www.yr.no/sted/Norge/',$fylke, '/',$kommune,'/',$stedsnavn,'/varsel.xml')"/>
                            <xsl:variable name="værmelding" select="document($yrURL)"/>

                            <værmelding>
                                <xsl:copy-of select="$værmelding"/>
                            </værmelding>

                        </xsl:if>
                    </xsl:if>



                </xsl:for-each>

            </fjellovergang>
        </xsl:for-each>
        </fjelloveranger>
    </xsl:template>

</xsl:stylesheet>