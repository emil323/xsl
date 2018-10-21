<?php
/**
 * Created by IntelliJ IDEA.
 * User: Emil
 * Date: 08.10.2018
 * Time: 13:47
 */
$xslt = new XSLTProcessor();
$doc = new DOMDocument();

$doc->load("xsl/vegmeldinge_med_vær.xsl");
$xslt->importStylesheet($doc);
echo $xslt->transformToXML($doc);