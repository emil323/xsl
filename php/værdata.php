<?php
/**
 * Created by IntelliJ IDEA.
 * User: Emil
 * Date: 01.11.2018
 * Time: 18:13
 */

header('Content-Type: text/xml');

$xslt = new XSLTProcessor();
$doc = new DOMDocument();

$doc->load("../xsl/værdata.xsl");
$xslt->importStylesheet($doc);

$fylke = urlencode($_GET['fylke']);
$kommune = urlencode($_GET['kommune']);
$stedsnavn = urlencode($_GET['stedsnavn']);

//Sett parametere
$yr_url = "http://www.yr.no/sted/Norge/" . $fylke . "/" .  $kommune . "/" .  $stedsnavn . "/varsel.xml";

$xslt->setParameter('','yrURL',$yr_url);

echo $xslt->transformToXML($doc);