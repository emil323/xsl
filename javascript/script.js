var værModus = {
    xml : null,
    veiID:-1,
    visAlt:false
}

vedInnlasting();

function vedInnlasting() {
    skjulInfo()
}

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

function skrivVærmelding(vei_id,xml) {
    if (xml.readyState == 4 && xml.status == 200) {

        console.log(xml.responseXML)
        var xmlDoc = xml.responseXML

        if(værModus.veiID != vei_id) {
            værModus.veiID = vei_id
            værModus.visAlt = false
            værModus.xml = xml
        }


        var vei_element = document.getElementById(vei_id)
        var timevarsel = xmlDoc.getElementsByTagName("time")
        let forrigeDag = "";


        skjulInfo()


        document.querySelectorAll('.fjellovergang-innhold').forEach(function (road) {
            if(road.parentElement.parentElement === vei_element) {
                road.style.display = 'block';
            } else {
                road.style.display = 'none';
            }
        });


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
                    "<th class='tabellKategori'>Tid</th>" +
                    "<th class='tabellKategori' colspan='2'>Varsel</th>" +
                    "<th class='tabellKategori'>Temp.</th>" +
                    "<th class='tabellKategori'>Nedbør</th>" +
                    "<th class='tabellKategori'>Vind</th>" +
                    "</tr>";
            }

            html+=
                "<tr>" +
                "<td class='tabellData'>kl " + fra.toLocaleString('no-NO', tidspunkt) + "-" + til.toLocaleString('no-NO', tidspunkt) + "</td>" +
                "<td class='varselElement' class='tabellData'><img src='" + symbolURL +"'/></td>" +
                "<td class='tabellData'>" + varsel +"</td>" +
                "<td class='tabellData'>" + temperatur + "°</td>" +
                "<td class='tabellData'>" + mm_nedbør +" mm</td>" +
                "<td class='tabellData'>" + vind_styrke + ", " + vind_mps + "m/s fra " + vind_retning +"</td>" +
                "</tr>";



            if(værModus.visAlt == false && i == 4) {
                console.log("ikke vis alt")
                html+= "<tr><td><button class='visLangtidsVarselKnapp' onclick='visLangtidsvarsel()'>Vis langtidsvarsel</button></td></tr>";
                break;
            }
            forrigeDag = fra.getDay();
        }

        html+= "<tr><td><button class='skjulKnapp' onclick='skjulInfo()'>Skjul</button></td></tr>";

        html += "</table>";
        vei_element.insertAdjacentHTML('beforeend', html)
    } else {
        console.log("Kunne ikke laste værdata");
        var html = "<p>Feil</p>";
        var vei_element = document.getElementById(vei_id)
        vei_element.insertAdjacentHTML('beforeend', html);
    }

}

function visLangtidsvarsel() {
    skjulInfo()
    værModus.visAlt = true
    skrivVærmelding(værModus.veiID, værModus.xml);
}

function skjulInfo() {


    var elements = document.getElementsByClassName("værTabell");
    while(elements.length > 0){
        elements[0].parentNode.removeChild(elements[0]);
    }
    document.querySelectorAll('.fjellovergang-innhold').forEach(function (road) {
            road.style.display = 'none';
    });
}

function søk(filter) {
    skjulInfo()
    værModus = {
        xml : null,
        veiID:-1,
        visAlt:false
    }
    //var tekst = e.target.value.toUpperCase()
    document.querySelectorAll('.vei').forEach(function (task) {
        var vei = task.firstChild.parentNode.innerText;
        if(vei.toUpperCase().indexOf(filter.toUpperCase()) != -1) {
            task.style.display = "block";
        } else {
            task.style.display = 'none';
        }
    })

}



