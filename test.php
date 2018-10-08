<?php
/**
 * Created by IntelliJ IDEA.
 * User: Emil
 * Date: 08.10.2018
 * Time: 13:47
 */

$elm = new DOMDocument();
$xslt = new XSLTProcessor();
$elm->load("graph_with_obstacles.xsl");
$xslt->importStylesheet($elm);
echo $resultat = $xslt->transformToXML($elm);