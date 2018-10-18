<?php
/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 17.10.2018
 * Time: 20:38
 */

// Laster inn doc og XSLT prosessor
$xslDoc = new DOMDocument();
$xslDoc->load("XML/mountainPasses.xsl");

$xsltProcessor = new XSLTProcessor();
$xsltProcessor->registerPHPFunctions();
$xsltProcessor->importStylesheet($xslDoc);

// Skriver ut det transformerte dokumentet
echo $result = $xsltProcessor->transformToXml($xslDoc);