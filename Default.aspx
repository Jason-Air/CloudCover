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
    <script src="js/JavaScript.js"></script>
</head>
<body>
    <div id="map"></div>
    <form id="form1" runat="server">
        <script type="text/javascript">
            var iconSize = 25;
            var miniIconSize = 10;
            var iconFolder = "image";

            function yukle() {
                var coverInfoColumn, coverAmount;
                for (var i = 0; i < value.length; i++) {
                    if (value[i][dataModel.autoMan] == 'Otomatik') coverAmount = value[i][dataModel.cloudCoverSat];
                    else coverAmount = value[i][dataModel.cloudCoverObs];
                    coverAmount = Math.round(coverAmount / 12.5);
                    console.log(value[i][dataModel.istNo] + " " + value[i][dataModel.ad] + " " + value[i][dataModel.autoMan] + " " + coverAmount + " " + value[i][dataModel.cloudBottomEst]);
                    L.marker([value[i][dataModel.lat], value[i][dataModel.lon]], { icon: GetIcon(value[i], coverAmount) /*GetIcon(coverAmount, value[i][dataModel.ad], value[i][dataModel.radarPPI] > 0)*/ }).addTo(map).bindPopup(PrintPopup(value[i], coverAmount));
                }
                ShowInfo('precipitation', false);
                ShowInfo('cloudInfo', false);
            }

            function GetIcon(val, cover) {
                var html = '<div class=\'cloudInfo\'><img src=./' + iconFolder + '/radar.svg alt=\'Radara Göre Bulut Tabanı\'> : ' + val[dataModel.cloudBottomRadar] + '<br/> <img src=./' + iconFolder + '/estimate.svg alt=\'Hesaplanan Bulut Tabanı\'>: ' + val[dataModel.cloudBottomEst] + '</div>'
                html += '<img src=./' + iconFolder + '/N' + cover + '.png height=' + iconSize + ' width=' + iconSize + '>';
                html += '<div class=\'cityName\'>' + val[dataModel.ad] + '</div>';
                if (val[dataModel.radarPPI] > 0) html += '<div class=\'precipitation\'><img src=./' + iconFolder + '/prec.svg height=' + iconSize + ' width=' + iconSize + '></div>';
                return L.divIcon({ html: html, iconSize: [iconSize, iconSize], className: 'divIcon' });
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
                                <div>Muhtemel Hadise: `+ Phenomenon(val)+ `</div>
                                <div>CB `+ CB(val) + `</div>
                            </div>
                        </div >
                      `
            }

            function Phenomenon(val) {
                if (val[dataModel.lighteningCount] > 0) return "Gökgürültüsü";
                else if (val[dataModel.radarPPI] > 0) return "Yağış";
                else if (val[dataModel.temperature] - val[dataModel.dewPoint] < 0.5) return "Sis/Pus"
                else return "--";
            }

            function CB(val) {
                if (val[dataModel.lighteningCount] > 0) return "var";
                else return "yok";
            }
            
        </script>
    </form>
    <script type="text/javascript">
            var map = L.map('map').setView([39.0, 35.5], 6);
            // add an OpenStreetMap tile layer
            L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.mgm.gov.tr">Meteoroloji Genel Müdürlüğü</a>'
            }).addTo(map);
            window.addEventListener('resize', function () {
                document.getElementById("map").style.height = window.innerHeight + 'px';
            })

            window.addEventListener('load', function () {
                document.getElementById("map").style.height = window.innerHeight + 'px';
                yukle();
            })

            map.on("zoomend", function () {                                if (map.getZoom() < 9) {
                    ShowInfo('cloudInfo', false);
                } else {                    ShowInfo('cloudInfo', true);                }                if (map.getZoom() < 8) {
                    ShowInfo('precipitation', false);
                } else {                    ShowInfo('precipitation', true);
                }            });            function ShowInfo(obj, show) {                var infos = document.getElementsByClassName(obj);
                if (show) {
                    for (var i = 0; i < infos.length; i++) {
                        infos[i].style.display = '';
                    }
                } else {
                    for (var i = 0; i < infos.length; i++) {
                        infos[i].style.display = 'none';
                    }
                }
            }
    </script>
</body>
</html>
