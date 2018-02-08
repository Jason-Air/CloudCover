<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Bulut Kapalılık Haritası</title>

    <link rel="stylesheet" href="./css/site.css" />
    <link rel="stylesheet" href="./css/leaflet.css" />
    <script src="./js/leaflet.js"></script>
    <script src="js/dataModel.js"></script>


</head>
<body onload="yukle()">
    <form id="form1" runat="server">
        <div id="map"></div>


        <script type="text/javascript">
            var iconSize = 25;
            var iconFolder = "image";
            var map = L.map('map').setView([39.0, 35.5], 6);
            // add an OpenStreetMap tile layer
            L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.mgm.gov.tr">Meteoroloji Genel Müdürlüğü</a>'
            }).addTo(map);

            function yukle() {
                var coverInfoColumn, coverAmount;
                for (var i = 0; i < value.length; i++) {
                    if (value[i][dataModel.autoMan] == 'Otomatik') coverAmount = value[i][dataModel.cloudCoverSat];
                    else coverAmount = value[i][dataModel.cloudCoverObs];
                    coverAmount = Math.round(coverAmount / 12.5);
                    console.log(value[i][dataModel.istNo] + " " + value[i][dataModel.ad] + " " + value[i][dataModel.autoMan] + " " + coverAmount + " " + value[i][dataModel.cloudBottomEst]);
                    L.marker([value[i][dataModel.lat], value[i][dataModel.lon]], { icon: CoverIcon(coverAmount) }).addTo(map).bindPopup(PrintPopup(value[i], coverAmount));
                }
                document.getElementById("map").style.height = window.innerHeight+'px';
            }

            //var coverIcon = L.icon({ iconUrl: './image/N5.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });

            var n0 = L.icon({ iconUrl: './' + iconFolder + '/N0.png', iconSize: [iconSize, iconSize] });
            var n1 = L.icon({ iconUrl: './' + iconFolder + '/N1.png', iconSize: [iconSize, iconSize] });
            var n2 = L.icon({ iconUrl: './' + iconFolder + '/N2.png', iconSize: [iconSize, iconSize] });
            var n3 = L.icon({ iconUrl: './' + iconFolder + '/N3.png', iconSize: [iconSize, iconSize] });
            var n4 = L.icon({ iconUrl: './' + iconFolder + '/N4.png', iconSize: [iconSize, iconSize] });
            var n5 = L.icon({ iconUrl: './' + iconFolder + '/N5.png', iconSize: [iconSize, iconSize] });
            var n6 = L.icon({ iconUrl: './' + iconFolder + '/N6.png', iconSize: [iconSize, iconSize] });
            var n7 = L.icon({ iconUrl: './' + iconFolder + '/N7.png', iconSize: [iconSize, iconSize] });
            var n8 = L.icon({ iconUrl: './' + iconFolder + '/N8.png', iconSize: [iconSize, iconSize] });
            var n9 = L.icon({ iconUrl: './' + iconFolder + '/N9.png', iconSize: [iconSize, iconSize] });

            function CoverIcon(cover) {
                switch (cover) {
                    case 0: return n0;
                    case 1: return n1;
                    case 2: return n2;
                    case 3: return n3;
                    case 4: return n4;
                    case 5: return n5;
                    case 6: return n6;
                    case 7: return n7;
                    case 8: return n8;
                    default: return n9;
                }
            }

            function PrintPopup(val, coverAmout) {
                return `<div id='popup'>
                    <div id= 'istAd' > `+ val[dataModel.ad] + `</div >
                        <div id='istBilgi'>
                            <div class='arabaslik'>İstasyon Bilgileri</div>
                            <div>Enlem: `+ val[dataModel.lat] + ` | Boylam: ` + val[dataModel.lon] + ` | Yükseklik: ` + val[dataModel.alt] + ` | Çalışma Şekli: ` + val[dataModel.autoMan] + `</div>
                        </div>
                        <div class='arabaslik'>Ölçülen Değerler</div>
                        <div id='olcumler'>
                            Sıcaklık: `+ val[dataModel.temperature] + ` | İşba: ` + val[dataModel.dewPoint] + ` | Görüş Mesafesi: - | Rüzgar: - / - | Toplam Kapalılık: ` + coverAmout + ` / 8 | Bulut Taban: ` + val[dataModel.cloudBottomObs] + ` | Hadise: --
                        </div>
                        <div id='hesaplanan'>
                            <div class='arabaslik'>Hesaplanan Değerler</div>
                            <div>Bulut Kapalılığı (%): `+ val[dataModel.cloudCoverSat] + `</div>
                            <div>Hesaplanan: `+ val[dataModel.cloudBottomEst] + `m | Enterpole Edilen: ` + val[dataModel.cloudBottomInterpole] + `m </div>
                            <hr />
                            <div>Alçak Bulut Miktarı: `+ val[dataModel.cloudLowSat] + ` | Orta Bulut Miktarı: ` + val[dataModel.cloudMidSat] + ` | Yüksek Bulut Miktarı: ` + val[dataModel.cloudHiSat] + `</div>
                            <div>İstasyon Etrafındaki PP Değeri: `+ val[dataModel.radarPPI] + `</div>
                            <div>İstasyon Etrafındaki Şimşek Sayısı: `+ val[dataModel.lighteningCount] + `</div>
                            <div>Muhtemel Hadise: `+ Phenomenon(val) + `</div>
                            <div>CB `+ CB(val) + `</div>
                        </div>
    </div >
                      `

            }

            function Phenomenon(val) {
                if (val[dataModel.lighteningCount] > 0) return "Gökgürültüsü";
                else if (val[dataModel.radarPPI] > 0) return "Yağış";
                else return "--";
            }

            function CB(val) {
                if (val[dataModel.lighteningCount] > 0) return "var";
                else return "yok";
            }

            window.addEventListener('resize', function () {
                document.getElementById("map").style.height = window.innerHeight + 'px';
            })



        </script>
    </form>
</body>
</html>
