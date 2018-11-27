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
    <div id="søkFelt"><input type="text" id="søk" placeholder="Søk etter fjellovergang..."
                             onkeyup="søk(this.value)"></div>
    <article>


        <div class="fjelloverganger">
            <ul class="vei-liste">
                <?php

                $teller = 0;
                foreach ($statusFjelloverganger->fjellovergang as $fjellovergang) {

                    $vei_id = "vei-" . $teller;

                    $fylke = $fjellovergang->stedsdata->fylke;
                    $kommune = $fjellovergang->stedsdata->kommune;
                    $stedsnavn = $fjellovergang->stedsdata->stedsnavn;

                    $farenivå = $fjellovergang->hastverk;

                    ?>
                    <li id="<?php echo $vei_id ?>" class="vei">
                        <ul class="fjellovergang">
                            <li class="vei-listeelement" id="veinavn"><h2
                                        onclick="lastVærdata(<?php echo "'$vei_id','$fylke','$kommune','$stedsnavn'" ?>)"><?php echo $fjellovergang['navn']; ?></h2>
                            </li>
                            <div class="fjellovergang-innhold">
                                <li class="vei-listeelement" id="sistOppdatert">
                                    <small>Sist
                                        oppdatert: <?php echo strftime("%a %d. %b %Y, kl. %H:%M", strtotime($fjellovergang->gyldigFra)); ?></small>
                                </li>

                                    <li class="vei-listeelement"><strong>Kjøreforhold</strong>: <?php
                                    switch ($farenivå) {
                                        case "N":
                                            echo "Normalt, trygt for ferdsel";
                                            break;
                                        case "U":
                                            echo "Mindre gode, vis varsomhet";
                                            break;
                                        case "X":
                                            echo "Dårlig, anbefales ikke for normal ferdsel";
                                            break;
                                        default:
                                            echo "";
                                            break;
                                    }

                                    ?>
                                </li>
                                <li class="vei-listeelement">
                                    <strong>Beskrivelse</strong>: <?php echo $fjellovergang->veiforhold; ?>
                                </li>
                                <li class="vei-listeelement">
                                    <?php

                                    if (strpos(strtolower($fjellovergang->veiforhold), 'stengt') !== false) {
                                        echo "<img src='./img/stop.png' height='50px' alt='Veien er stengt'/>";
                                    }

                                    if (strpos(strtolower($fjellovergang->veiforhold), 'glatt') !== false) {
                                        echo "<img src='./img/glattvei.png' height='50px' alt='Glatt vei'/>";
                                    }

                                    if (strpos(strtolower($fjellovergang->veiforhold), 'skred') !== false) {
                                        echo "<img src='./img/skred.png' height='50px' alt='Skredfare'/>";
                                    }

                                    if($farenivå == "X") {
                                        echo "<img src='./img/varsel.png' height='50px' alt='Varselskilt. Dårlige kjøreforhold'/>";
                                    }
                                    ?>
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
    </article>
<?php ?><?php
// Inkluder footer
include("html/footer.html");