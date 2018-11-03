<?php
/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 17.10.2018
 * Time: 20:38
 */


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

    <div class="collection">
        <ul class="vei-liste">
            <?php
            foreach ($statusFjelloverganger->fjellovergang as $fjellovergang) {
                ?>
                <li>
                    <ul>
                        <li class="vei-listeelement" id="veinavn"><?php echo $fjellovergang['navn']; ?></li>
                        <li class="vei-listeelement"><?php echo $fjellovergang->veiforhold ?></li>
                        <li class="vei-listeelement"><?php echo $fjellovergang->hastverk ?></li>
                        <li class="vei-listeelement"><?php echo $fjellovergang->gyldigFra ?></li>
                        <li class="vei-listeelement" id="yrLink"><?php echo $fjellovergang->yrURL ?></li>
                        <li class="vei-listeelement" id="fylke"><?php echo $fjellovergang->stedsdata->fylke ?></li>
                        <li class="vei-listeelement" id="kommune"><?php echo $fjellovergang->stedsdata->kommune ?></li>
                        <li class="vei-listeelement" id="stedsnavn"><?php echo $fjellovergang->stedsdata->stedsnavn ?></li>
                        <div id="example" />
                    </ul>
                </li>

                <?php
            }
            ?>
        </ul>
    </div>
<?php
// Inkluder footer
include("footer.html");