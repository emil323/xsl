<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <værvarsel>

            <!-- Lenke til det originale værvarsel, pga retningslinjer til YR -->
            <xsl:copy-of select="weatherdata/credit/link"/>
            <!-- Lag liste med timevarsel -->

            <timevarsel>
                <xsl:for-each select="weatherdata/forecast/tabular/time">
                    <!-- Bygg opp time varsel-->
                    <time>
                        <!-- Legg til attributter for fra og til tidspunk -->

                            <xsl:value-of select="@from"/>


                            <xsl:value-of select="@to"/>


                        <!-- Legg til antall estimert mm nedbør-->
                        <nedbør>

                                <xsl:value-of select="precipitation/@value"/>

                        </nedbør>
                        <!-- Legg til temperatur -->
                        <temperatur>

                                <xsl:value-of select="temperature/@value"/>

                        </temperatur>
                        <!-- Legg til vindhastighet -->
                        <vind>

                                <xsl:value-of select="windSpeed/@mps"/>


                                <xsl:value-of select="windSpeed/@name"/>


                                <xsl:value-of select="windDirection/@name"/>

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
    </xsl:template>

</xsl:stylesheet>