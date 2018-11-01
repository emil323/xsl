<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="fylke"/>
    <xsl:param name="kommune"/>
    <xsl:param name="stedsnavn"/>

    <xsl:param name="yrURL" select="concat('http://www.yr.no/sted/Norge/',$fylke,'/',$kommune,'/',$stedsnavn,'/varsel.xml')"/>
    <xsl:variable name="værdata" select="document($yrURL)"/>

    <xsl:template match="/">
        <yr-URL>
            <xsl:value-of select="$yrURL"/>
        </yr-URL>
        <xsl:copy-of select="$værdata"/>
    </xsl:template>

</xsl:stylesheet>