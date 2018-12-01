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
    <div id="søkFelt"><input autofocus type="text" id="søk" placeholder="Søk etter fjellovergang..."
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

                    $obs = false;

                    ?>
                    <li id="<?php echo $vei_id ?>" class="vei">
                        <ul class="fjellovergang">
                            <li class="vei-listeelement" id="veinavn"><h2
                                        onclick="lastVærdata(<?php echo "'$vei_id','$fylke','$kommune','$stedsnavn'" ?>)"><?php echo $fjellovergang['navn']; ?></h2>
                            </li>
                            <div class="fjellovergang-innhold">
                                <li class="vei-listeelement" id="sistOppdatert">
                                    <small><strong>Gydlig
                                            fra:</strong> <?php echo strftime("%a %d. %b %Y, kl. %H:%M", strtotime($fjellovergang->gyldigFra)); ?>
                                    </small>
                                </li>
                                <li class="vei-listeelement"><strong>Kjøreforhold: </strong> <?php
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
                                    <strong>Beskrivelse: </strong><?php echo $fjellovergang->veiforhold; ?></li>

                                <li class="vei-listeelement"><strong>Varsler:</strong></li>
                                <li>
                                    <ul>
                                        <?php

                                        if (strpos(strtolower($fjellovergang->veiforhold), 'glatt') !== false) {
                                            $obs = true;
                                            echo "<li class='varselElement'><img src='./img/glatt.png' height='50px' alt='Glatt vei'/></li>";
                                        }

                                        if (strpos(strtolower($fjellovergang->veiforhold), 'ras') !== false) {
                                            $obs = true;
                                            echo "<li class='varselElement'><img src='./img/ras.png' height='50px' alt='Rasfare'/></li>";
                                        }

                                        if (strpos(strtolower($fjellovergang->veiforhold), 'vegarbeid') !== false) {
                                            $obs = true;
                                            echo "<li class='varselElement'><img src='./img/vegarbeid.png' height='50px' alt='Vegarbeid'/></li>";
                                        }

                                        if ((strpos(strtolower($fjellovergang->veiforhold), 'vegarbeid') !== false) || ($farenivå == "X")) {
                                            $obs = true;
                                            echo "<li class='varselElement'><img src='./img/varsel.png' height='50px' alt='Varselskilt. Dårlige kjøreforhold'/></li>";
                                        }

                                        if ($obs != true) {
                                            echo "<li class='varselElement'>Ingen varseler</li>";
                                        }
                                        ?>
                                    </ul>
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