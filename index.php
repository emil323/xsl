<?php
/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 17.10.2018
 * Time: 20:38
 */


// Laster inn doc og XSLT prosessor
$xslDoc = new DOMDocument();
$xslDoc->load("xsl/vegmeldinger_med_vær.xsl");

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
            <li><?php echo $fjellovergang->kjøreforhold ?></li>
            <li><?php echo $fjellovergang->beskrivelse ?></li>
            <li><?php echo $fjellovergang->meldingsType ?></li>
            <li><?php echo $fjellovergang->hastverk ?></li>
            <li><?php echo $fjellovergang->veinummer ?></li>
            <li><?php echo $fjellovergang->gyldigFra ?></li>
            <li><?php echo $fjellovergang->gyldigTil ?></li>
            <li>

                <ul>
                    <?php
                    foreach ($statusFjelloverganger->fjellovergang->værvarsel->timevarsel->time as $time) {
                        ?>
                        <li>Fra <?php echo $time['fra']; ?> til <?php echo $time['til']; ?></li>
                        <li>Nedbør: <?php echo $time->nedbør; ?></li>
                        <li>Temperatur: <?php echo $time->temperatur; ?></li>
                        <li>
                            <ul>
                                <li>Mps: <?php echo $time->vind['mps']; ?></li>
                                <li>Styrke: <?php echo $time->vind['styrke']; ?></li>
                                <li>Retning: <?php echo $time->vind['retning']; ?></li>
                                <li>Symbol: <img src="<?php echo $time->symbol; ?>"></li>
                            </ul>
                        </li>
                        <?php
                    }
                    ?>
                </ul>
            </li>
        </ul>
    </div> <?php
}
?>

<?php
// Inkluder footer
include("footer.html");