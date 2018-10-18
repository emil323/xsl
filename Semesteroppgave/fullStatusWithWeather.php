<?php

/**
 * Created by PhpStorm.
 * User: Kristoffer
 * Date: 18.10.2018
 * Time: 12:59
 */

// Henter item fra URL
if(isset($_GET['item'])) {
    $road = $_GET['item'];
}

echo strtolower($road);

// En array over all tilgjenglig værdata. Dette er trolig en hatløsning
$weatherFiles = array(
    array("Ev 6", "https://www.yr.no/sted/Norge/Oppland/Dovre/Dovrefjell/varsel.xml"),
    array("Ev 16", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/L%C3%A6rdal/Filefjell/varsel.xml"),
    array("Ev 39", "https://www.yr.no/sted/Norge/M%C3%B8re_og_Romsdal/%C3%98rskog/%C3%98rskogfjellet/varsel.xml"),
    array("Ev 39", "https://www.yr.no/sted/Norge/M%C3%B8re_og_Romsdal/Gjemnes/Batnfjords%C3%B8ra/varsel.xml"),
    array("Ev 134", "https://www.yr.no/sted/Norge/Telemark/Vinje/Haukelifjell/varsel.xml"),
    array("Rv 3", "https://www.yr.no/sted/Norge/Hedmark/Tynset/Kvikne/varsel.xml"),
    array("Rv 7", "https://www.yr.no/sted/Norge/Telemark/Vinje/Hardangervidda/varsel.xml"),
    array("Rv 9", "https://www.yr.no/sted/Norge/Aust-Agder/Bykle/Hovden/varsel.xml"),
    array("Rv 13", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/Flora/Vikafjellet~159327/varsel.xml"),
    array("Rv 15", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/Stryn/Strynefjellet/varsel.xml"),
    array("Rv 52", "https://www.yr.no/sted/Norge/Buskerud/Hemsedal/Hemsedal/varsel.xml"),
    array("Fv 13", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/Balestrand/Gaularfjellet/varsel.xml"),
    array("Fv 27", "https://www.yr.no/sted/Norge/Oppland/Ringebu/Venabygdsfjellet/varsel.xml"),
    array("Fv 37", "https://www.yr.no/sted/Norge/Telemark/Vinje/Raulandsgrend/varsel.xml"),
    array("Fv 40", "https://www.yr.no/sted/Norge/Buskerud/Fl%C3%A5/Dagalifjell/varsel.xml"),
    array("Fv 45 Hunnedalsvegen", "https://www.yr.no/sted/Norge/Vest-Agder/Sirdal/Hunnedalsvegen/varsel.xml"),
    array("Fv 45 Rotemo", "https://www.yr.no/sted/Norge/Aust-Agder/Valle/Rotemo/varsel.xml"),
    array("Fv 50", "https://www.yr.no/sted/Norge/Buskerud/Hol/Hol/varsel.xml"),
    array("Fv 51", "https://www.yr.no/sted/Norge/Oppland/%C3%98ystre_Slidre/Valdresflye/varsel.xml"),
    array("Fv 53", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/%C3%85rdal/Tyinoset/varsel.xml"),
    array("Fv 55", ",https://www.yr.no/sted/Norge/Sogn_og_Fjordane/Luster/Sognefjellet/varsel.xml"),
    array("Fv 60 Utvikfjellet ", "https://www.yr.no/sted/Norge/Sogn_og_Fjordane/Gloppen/Utvikfjellet~2285247/varsel.xml"),
    array("Fv 60 Strandafjellet ","https://www.yr.no/sted/Norge/M%C3%B8re_og_Romsdal/Tingvoll/Strandafjellet/varsel.xml"),
    array("Fv 63", "https://www.yr.no/sted/Norge/M%C3%B8re_og_Romsdal/Stranda/Geiranger/varsel.xml"),
    array("Fv 63", "https://www.yr.no/sted/Norge/M%C3%B8re_og_Romsdal/Rauma/Trollstigen_halvbru/varsel.xml"),
    array("Fv 92/381", "https://www.yr.no/sted/Norge/Hordaland/Masfjorden/Matre/varsel.xml"),
    array("Fv 124/755 ", "https://www.yr.no/sted/Norge/Buskerud/Nore_og_Uvdal/Imingfjell/varsel.xml"),
    array("Fv 252", "https://www.yr.no/sted/Norge/Oppland/Vang/Tyin/varsel.xml"),
    array("Fv 287", "https://www.yr.no/sted/Norge/Buskerud/Kr%C3%B8dsherad/Norefjell/varsel.xml"),
    array("Fv 337/987", "https://www.yr.no/sted/Norge/Vest-Agder/Sirdal/Suleskard_bru/varsel.xml"),
    array("Fv 385", "https://www.yr.no/sted/Norge/Oppland/Ringebu/Friisvegen/varsel.xml"),
    array("Fv 402", "https://www.yr.no/sted/Norge/Telemark/Fyresdal/%C3%98vre_Birtedalen/varsel.xml"),
    array("Fv 500/986", "https://www.yr.no/sted/Norge/Vest-Agder/Sirdal/Sirdalsheiane/varsel.xml"),
    array("Fv 520", "https://www.yr.no/sted/Norge/Rogaland/Sauda/Hellandsbygda/varsel.xml"),
    array("Fv 520", "https://www.yr.no/sted/Norge/Rogaland/Sauda/Breiborg/varsel.xml"),
    array("Fv 651", "https://www.yr.no/sted/Norge/Telemark/Hjartdal/Tuddal~68992/varsel.xml"),
    array("Fv 705", "https://www.yr.no/sted/Norge/Tr%C3%B8ndelag/Tydal/Stugudalen/varsel.xml"),
    array("Fv 204", "https://www.yr.no/sted/Norge/Oppland/Gausdal/Verskeid~142812/varsel.xml")
);

// Laster inn xsl-dokuimentet
$xslDoc = new DOMDocument();
$xslDoc->load("XML/fullStatusWithWeather.xsl");

// XSLT
$xsltProcessor = new XSLTProcessor();
$xsltProcessor->registerPHPFunctions();
$xsltProcessor->importStylesheet($xslDoc);

// Går igjennom lista over lenker fra Yr, og matcher veinavnet i header mot element 0 i arrayen
foreach($weatherFiles as $file) {
    if(strpos(mb_strtolower($road), strtolower($file[0])) !== false) {
        echo mb_strtolower($road);
        echo strtolower($file[0]);

        // Lenke til Yr sine værdata
        $selectedRoad = $file[1];

        // Legger inn filnavnet i et paramter som ligger i XSL dokumnetet. Dette parameteret bestemmer hvilket Yr-dokument som hentes
        $xsltProcessor->setParameter("", "weatherFileValue", $selectedRoad);

        // Skriver ut det transformerte dokumentet
        echo $result = $xsltProcessor->transformToXml($xslDoc);
    }
}




