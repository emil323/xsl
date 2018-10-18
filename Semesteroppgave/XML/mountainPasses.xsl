<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Legger status-fila i en variabel -->
    <xsl:param name="statusFile" select="document('https://www.vegvesen.no/trafikk/xml/savedsearch.xml?id=604')" />
    <xsl:variable name="status" select="$statusFile/searchresult/result-array" />

    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="./stylesheet.css" />
            </head>
            <body>
                <h1>Fjelloverganger</h1>

                <ul id="road-list">


                <!-- Skriver ut alle fjelloverganger i en liste, sortert på veinummer -->
                <xsl:for-each select="$status/result">
                    <xsl:sort select="heading" data-type="text" />

                    <li class="road-heading-list-elements"><xsl:value-of select="heading" /></li>
                    <a href="fullStatusWithWeather.php?item={heading}">Test</a>

                </xsl:for-each>
                </ul>
                <script src="./app.js"></script>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>