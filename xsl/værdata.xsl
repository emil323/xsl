<xsl:stylesheet version="1.0" xml:lang="no" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="fylke"/>
    <xsl:param name="kommune"/>
    <xsl:param name="stedsnavn"/>

    <xsl:param name="yrURL"
               select="concat('http://www.yr.no/sted/Norge/',$fylke,'/',$kommune,'/',$stedsnavn,'/varsel.xml')"/>
    <xsl:variable name="værmelding" select="document($yrURL)/weatherdata"/>

    <xsl:template match="/">
        <værvarsel>
            <yr-URL>
                <xsl:value-of select="$yrURL"/>
            </yr-URL>

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

                        <xsl:variable name="symbolURL"
                                      select="concat('https://api.met.no/weatherapi/weathericon/1.1/?symbol=',symbol/@number,'&amp;content_type=image/png')"/>

                        <!-- Legg til varsel -->
                        <varsel>
                            <xsl:attribute name="vær">
                                <xsl:value-of select="symbol/@name"/>
                            </xsl:attribute>
                            <xsl:attribute name="symbol">
                                <xsl:value-of select="$symbolURL"/>
                            </xsl:attribute>
                        </varsel>
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
                    </time>

                </xsl:for-each>
            </timevarsel>
        </værvarsel>
    </xsl:template>

</xsl:stylesheet>