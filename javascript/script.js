


function lastVærdata(vei_id,fylke,kommune,stedsnavn) {
    console.log(vei_id, fylke, kommune, stedsnavn)

    var xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            skrivVærmelding(vei_id,this)
        }
    };

    var url = encodeURI("php/værdata.php?fylke=" + fylke + "&kommune=" + kommune + "&stedsnavn=" + stedsnavn)
    console.log(url)
    xhttp.open("GET", url, true);
    xhttp.send();
}

/*
for hver timevarsel
    hent fra-dato
    <table>
        så lenge til-dato er samme dag
            bygg tabell

 */

function skrivVærmelding(vei_id,xml) {
    if (xml.readyState == 4 && xml.status == 200) {

        console.log(xml.responseXML)
        var xmlDoc = xml.responseXML

        var vei_element = document.getElementById(vei_id)
        var timevarsel = xmlDoc.getElementsByTagName("time")
        let forrigeDag = "";

        var elements = document.getElementsByClassName("værTabell");
        while(elements.length > 0){
            elements[0].parentNode.removeChild(elements[0]);
        }

        var html = "<table class='værTabell'>";

        for(i = 0; i< timevarsel.length; i++) {
            //Værdata variabler
            var fra = new Date(timevarsel[i].getAttribute("fra"))
            var til = new Date(timevarsel[i].getAttribute("til"))
            var varsel = timevarsel[i].getElementsByTagName("varsel")[0].getAttribute("vær")
            var symbolURL = timevarsel[i].getElementsByTagName("varsel")[0].getAttribute("symbol")
            var mm_nedbør = timevarsel[i].getElementsByTagName("nedbør")[0].getAttribute("mm")
            var temperatur = timevarsel[i].getElementsByTagName("temperatur")[0].getAttribute("celcius")
            var vind_mps = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("mps")
            var vind_styrke = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("styrke")
            var vind_retning = timevarsel[i].getElementsByTagName("vind")[0].getAttribute("retning")

            var dag = {weekday: 'long', day: 'numeric', month: 'long', year: 'numeric'};
            var tidspunkt = {hour: 'numeric'}

            if(fra.getDay() !== forrigeDag) {
                html +=
                    "<tr>" +
                    "<th class='tabellOverskrift' colspan='5'>" + fra.toLocaleString('no-NO', dag) + "</th>" +
                    "</th>" +
                    "<tr>" +
                    "<th>Tid</th>" +
                    "<th>Varsel</th>" +
                    "<th>Temp.</th>" +
                    "<th>Nedbør</th>" +
                    "<th>Vind</th>" +
                    "</tr>";
            }

            html+=
                "<tr>" +
                "<td>kl " + fra.toLocaleString('no-NO', tidspunkt) + "-" + til.toLocaleString('no-NO', tidspunkt) + "</td>" +
                "<td class='varselElement'>" + varsel + "<img src='" + symbolURL +"'/></td>" +
                "<td>" + temperatur + "°</td>" +
                "<td>" + mm_nedbør +" mm</td>" +
                "<td>" + vind_styrke + ", " + vind_mps + "m/s fra " + vind_retning +"</td>" +
                "</tr>";

            forrigeDag = fra.getDay();

        }
        html += "</table>";
        vei_element.insertAdjacentHTML('beforeend', html)
    }
}



