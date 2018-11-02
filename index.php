<?php
/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 17.10.2018
 * Time: 20:38
 */

function lagYrLink($fylke, $kommune, $sted) {
    $link = "https://www.yr.no/sted/Norge/".$fylke."/".$kommune."/".$sted."/varsel.xml";
    return $link;

}

// Laster inn doc og XSLT prosessor
$xslDoc = new DOMDocument();
$xslDoc->load("xsl/vegmeldinger_med_stedsdata.xsl");

$xsltProcessor = new XSLTProcessor();
$xsltProcessor->registerPHPFunctions();
$xsltProcessor->importStylesheet($xslDoc);

// Skriver ut det transformerte dokumentet
$transformertXSL = $xsltProcessor->transformToXml($xslDoc);

// Lager et SimpleXMLElement ut av det transformerte XML dokumentet
$statusFjelloverganger = new SimpleXMLElement($transformertXSL);

//Inkluder header
include("header.html");
?>


<?php
foreach ($statusFjelloverganger->fjellovergang as $fjellovergang) {
    ?>
    <div class="vei-element">
        <ul>
            <li><?php echo $fjellovergang['navn']; ?></li>
            <li><?php echo $fjellovergang->veiforhold ?></li>
            <li><?php echo $fjellovergang->hastverk ?></li>
            <li><?php echo $fjellovergang->gyldigFra ?></li>
            <?php
            $fylke = $fjellovergang->stedsdata->fylke;
            $kommune= $fjellovergang->stedsdata->kommune;
            $sted = $fjellovergang->stedsdata->stedsnavn; ?>
            <li><?php echo lagYrLink($fylke, $kommune, $sted); ?></li>
        </ul>
    </div> <?php
}
?>

<?php
// Inkluder footer
include("footer.html");