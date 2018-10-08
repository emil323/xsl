<?php
/**
 * Created by IntelliJ IDEA.
 * User: Emil
 * Date: 08.10.2018
 * Time: 13:47
 */
$xslt = new XSLTProcessor();
$doc = new DOMDocument();
$doc->load("xsl/graph_with_obstacles.xsl");
$xslt->importStylesheet($doc);
echo $resultat = $xslt->transformToXML($doc);