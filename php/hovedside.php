<?php
/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 17.10.2018
 * Time: 20:38
 */

setlocale(LC_ALL, 'no_NO');

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
include("html/header.html");
?>
    <div class="fjelloverganger">
        <ul class="vei-liste">
            <?php

            $teller = 0;
            foreach ($statusFjelloverganger->fjellovergang as $fjellovergang) {

                $vei_id = "vei-" . $teller;

                $fylke = $fjellovergang->stedsdata->fylke;
                $kommune = $fjellovergang->stedsdata->kommune;
                $stedsnavn = $fjellovergang->stedsdata->stedsnavn;

                ?>
                <li id="<?php echo $vei_id ?>" class="vei"
                    onclick="lastVærdata(<?php echo "'$vei_id','$fylke','$kommune','$stedsnavn'" ?>)">
                    <ul class="fjellovergang">

                        <li class="vei-listeelement" id="veinavn"><h2><?php echo $fjellovergang['navn']; ?></h2></li>
                        <div class="fjellovergang-innhold">
                            <li class="vei-listeelement">
                                <small>Sist
                                    oppdatert: <?php echo strftime("%a %d. %b %Y, kl. %H:%M", strtotime($fjellovergang->gyldigFra)); ?></small>
                            </li>
                            <li class="vei-listeelement"><strong>Kjøreforhold</strong>:
                                <br><?php echo $fjellovergang->veiforhold ?></li>
                            <li class="vei-listeelement">
                                <strong>Hastverk</strong>: <?php echo $fjellovergang->hastverk ?>
                            </li>
                        </div>
                    </ul>
                </li>

                <?php
                $teller++;
            }
            ?>
        </ul>
    </div>
<?php  ?><?php
// Inkluder footer
include("html/footer.html");