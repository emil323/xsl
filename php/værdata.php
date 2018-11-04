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

$doc->load("xsl/værdata.xsl");
$xslt->importStylesheet($doc);

//Sett parametere
$xslt->setParameter('','fylke',$_GET['fylke']);
$xslt->setParameter('','kommune',$_GET['kommune']);
$xslt->setParameter('','stedsnavn',$_GET['stedsnavn']);

echo $xslt->transformToXML($doc);