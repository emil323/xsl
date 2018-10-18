<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Denne verdien endres med PHP-->
    <xsl:param name="weatherFileValue"></xsl:param>


    <!-- Legger vær-fila i en variabel -->
    <xsl:param name="weatherFile" select="document($weatherFileValue)" />
    <xsl:variable name="weather" select="$weatherFile/weatherdata"/>

    <!-- Legger status-fila i en variabel -->
    <xsl:param name="statusFile" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')" />
    <xsl:variable name="status" select="$statusFile/searchresult/result-array" />

    <xsl:template match="/">

        <!-- En løkke som tester om stedsnavnet i fila fra Yr inngår i et resultat-element i Statens vegvesen fila -->
        <xsl:for-each select="$status/result">
            <xsl:if test="contains(heading, $weather/location/name)">
                <h2>Statens Vegvesen for: <em><xsl:value-of select="heading" /></em></h2>
                <h2>Yr: <xsl:value-of select="$weather/location/name"/></h2>
                <p><xsl:value-of select="$weatherFileValue"/></p>
            </xsl:if>
        </xsl:for-each>

        <br/>

    </xsl:template>
</xsl:stylesheet>