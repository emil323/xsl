const collection = document.querySelector('.collection');
collection.addEventListener('click', test);

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

/*
// Fra https://www.w3schools.com/xml/ajax_xmlfile.asp
function loadDoc() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            myFunction(this);
        }
    };
    xhttp.open("GET", "cd_catalog.xml", true);
    xhttp.send();
}
function myFunction(xml) {
    var i;
    var xmlDoc = xml.responseXML;
    var table="<tr><th>Title</th><th>Artist</th></tr>";
    var x = xmlDoc.getElementsByTagName("CD");
    for (i = 0; i <x.length; i++) {
        table += "<tr><td>" +
            x[i].getElementsByTagName("TITLE")[0].childNodes[0].nodeValue +
            "</td><td>" +
            x[i].getElementsByTagName("ARTIST")[0].childNodes[0].nodeValue +
            "</td></tr>";
    }
    document.getElementById("demo").innerHTML = table;
}
*/




