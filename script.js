//const collection = document.querySelector('.collection');
//collection.addEventListener('click', test);
/*
function test(e) {
       if (e.target.id === 'veinavn') {
        console.log(e.target.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling.innerHTML);
        let yrLink = e.target.nextElementSibling.nextElementSibling.nextElementSibling.nextElementSibling.innerHTML;
        displayResult(yrLink);
    }


}

// Fra https://www.w3schools.com/xml/xsl_client.asp
function loadXMLDoc(filename) {
    if (window.ActiveXObject) {
        xhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
    else {
        xhttp = new XMLHttpRequest();
    }
    xhttp.open("GET", filename, false);
    try {
        xhttp.responseType = "msxml-document"
    } catch (err) {
    } // Helping IE11
    xhttp.send("");
    return xhttp.responseXML;
}

function displayResult(yrLink) {
    console.log(yrLink);

    //xml = loadXMLDoc("xml/cdcatalog.xml");
    //xsl = loadXMLDoc("xsl/cdcatalog_client.xsl");
    xml = loadXMLDoc("xml/varsel.xml");
    xsl = loadXMLDoc("xsl/værdata2.xsl");
// code for IE
    if (window.ActiveXObject || xhttp.responseType == "msxml-document") {
        ex = xml.transformNode(xsl);
        document.getElementById("example").innerHTML = ex;
    }
// code for Chrome, Firefox, Opera, etc.
    else if (document.implementation && document.implementation.createDocument) {
        xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);

        const fylke = document.getElementById('fylke').innerHTML;
        const kommune = document.getElementById('kommune').innerHTML;
        const stedsnavn = document.getElementById('stedsnavn').innerHTML;

        console.log(fylke, kommune, stedsnavn);

        xsltProcessor.setParameter(null, "fylke", fylke);
        xsltProcessor.setParameter(null, "kommune", kommune);
        xsltProcessor.setParameter(null, "stedsnavn", stedsnavn);

        resultDocument = xsltProcessor.transformToFragment(xml, document);
        document.getElementById("example").appendChild(resultDocument);
    }
}

*/
// Fra https://www.w3schools.com/xml/ajax_xmlfile.asp
function lastVærdata(vei_id,fylke,kommune,stedsnavn) {
    console.log(vei_id, fylke, kommune, stedsnavn)

    var xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            skrivVærmelding(vei_id,this)
        }
    };

    var url = encodeURI("værdata.php?fylke=" + fylke + "&kommune=" + kommune + "&stedsnavn=" + stedsnavn)
    console.log(url)
    xhttp.open("GET", url, true);
    xhttp.send();
}


function skrivVærmelding(vei_id,xml) {
    if (xml.readyState == 4 && xml.status == 200) {

        console.log(xml.responseXML)
        var xmlDoc = xml.responseXML

        var vei_element = document.getElementById(vei_id)

        var timevarsel = xmlDoc.getElementsByTagName("time")
        for(i = 0; i< timevarsel.length; i++) {

            //Værdata variabler
            var fra = new Date(timevarsel[i].getAttribute("fra"))
            var til = new Date(timevarsel[i].getAttribute("til"))
            var mm_nedbør = timevarsel[i].getElementsByTagName("nedbør")[0].getAttribute("mm")
            var temperatur = timevarsel[i].getElementsByTagName("temperatur")[0].getAttribute("celcius")
            var vind_mps = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("mps")
            var vind_styrke = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("styrke")
            var vind_retning = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("retning")
            var symbolURL = timevarsel[i].getElementsByTagName("symbol")[0].firstChild.nodeValue
            var datoFormatering = {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric'}

            //HTML
            var html = "<ul>" +
                "<li>Fra: " + fra.toLocaleString("no-NO", datoFormatering) +"</li>" +
                "<li>Til: " + til.toLocaleString("no-NO", datoFormatering) +"</li>" +
                "<ul>" +
                "<li>Nedbør: " + mm_nedbør +"mm</li>" +
                "<li>Temperatur: " + temperatur +" celcius</li>" +
                "<li>Vind: " + vind_mps +" meter i sekundet</li>" +
                "<li>Vindstyrke: " + vind_styrke +"</li>" +
                "<li>Vind retning: " + vind_retning +"</li>" +
                "<li><img src='" + symbolURL +"'/></li>" +
                "</ul>" +
                "</ul>"

            vei_element.insertAdjacentHTML('beforeend', html)


            console.log(symbolURL)
        }
    }
}



