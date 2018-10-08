<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Definer at utdata skal være XML -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Definer parametere for XML filer -->
    <xsl:param name="graphFile" select="document('xml/graph.xml')"/>
    <xsl:param name="obstaclesFiles" select="document('xml/surface.obstacles.xml')"/>

    <!-- Definer variabel for graf-->
    <xsl:variable name="vertices" select="$graphFile/vertices/vertex"/>
    <xsl:variable name="obstacles" select="$obstaclesFiles/obstacles/obstacle"/>

    <!-- Definer rot template -->


    <xsl:template match="/">
        <vertices>
            <!-- Lag en løkke igjennom alle vertexer -->
            <xsl:for-each select="$vertices">

                <!-- Definer variabel vertexID -->
                <xsl:variable name="vertexID">
                    <xsl:value-of select="@id"/>
                </xsl:variable>

                <!-- Bruk variabel 'vertexID' -->
                <vertex id="{$vertexID}">
                    <!-- Kopier ut coordinates og edges -->
                    <xsl:copy-of select="coordinates"/>
                    <xsl:copy-of select="edges"/>
                    <!-- Lag en ny for-each for å loope igjennom obstacles -->
                    <xsl:for-each select="$obstacles">
                        <!-- Sjekk om  det er match på vertexID-->
                        <xsl:if test="triggers/vertex[@id=$vertexID]">
                            <!-- Kopier ut  alt i <obstacle> taggen -->
                            <xsl:copy-of select="."></xsl:copy-of>
                        </xsl:if>
                    </xsl:for-each>

                </vertex>
            </xsl:for-each>
        </vertices>
    </xsl:template>


</xsl:stylesheet>