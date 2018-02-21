<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="tr">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Bulut Kapalılık Haritası</title>
    <link rel="stylesheet" href="./css/site.css" />
    <link rel="stylesheet" href="./css/leaflet.css" />
    <link href="css/datepicker.css" rel="stylesheet" />
    <script src="./js/leaflet.js"></script>
    <script src="js/dataModel.js"></script>
    <script src="js/datepicker.js"></script>
    <%--<script src="js/JavaScript.js"></script>--%>
</head>
<body>
    <form id="form1" runat="server">
        <div id="map"></div>
        <div id="date" runat="server">
            <input id="datetime" type="text" runat="server" />
            <span id="saat">Saat :</span>
            <span class="custom-dropdown">
                <asp:DropDownList ID="DropDownList1" runat="server">
                    <asp:ListItem>00</asp:ListItem>
                    <asp:ListItem>01</asp:ListItem>
                    <asp:ListItem>02</asp:ListItem>
                    <asp:ListItem>03</asp:ListItem>
                    <asp:ListItem>04</asp:ListItem>
                    <asp:ListItem>05</asp:ListItem>
                    <asp:ListItem>06</asp:ListItem>
                    <asp:ListItem>07</asp:ListItem>
                    <asp:ListItem>08</asp:ListItem>
                    <asp:ListItem>09</asp:ListItem>
                    <asp:ListItem>10</asp:ListItem>
                    <asp:ListItem>11</asp:ListItem>
                    <asp:ListItem>12</asp:ListItem>
                    <asp:ListItem>13</asp:ListItem>
                    <asp:ListItem>14</asp:ListItem>
                    <asp:ListItem>15</asp:ListItem>
                    <asp:ListItem>16</asp:ListItem>
                    <asp:ListItem>17</asp:ListItem>
                    <asp:ListItem>18</asp:ListItem>
                    <asp:ListItem>19</asp:ListItem>
                    <asp:ListItem>20</asp:ListItem>
                    <asp:ListItem>21</asp:ListItem>
                    <asp:ListItem>22</asp:ListItem>
                    <asp:ListItem>23</asp:ListItem>
                </asp:DropDownList>
            </span>
            <asp:Button ID="button" runat="server" Text="Tamam" OnClick="button_Click" />

        </div>

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
                    L.marker([value[i][dataModel.lat], value[i][dataModel.lon]], { icon: GetIcon(value[i], coverAmount) }).addTo(map).bindPopup(PrintPopup(value[i], coverAmount));
                }
                ShowInfo('precipitation', false);
                ShowInfo('cloudInfo', false);
            }

            function GetIcon(val, cover) {
                var html = '<div class=\'cloudInfo\'> ' + val[dataModel.cloudBottomInterpole] + '<br/> ' + val[dataModel.cloudBottomEst] + '</div>'
                html += '<img src=./' + iconFolder + '/N' + cover + '.png height=' + iconSize + ' width=' + iconSize + '>';
                html += '<div class=\'cityName\'>' + val[dataModel.ad] + '</div>';
                if (val[dataModel.lighteningCount] > 0 && val[dataModel.radarPPI] > 0) html += '<div class=\'pheno\'><img src=./' + iconFolder + '/lightning.svg height=' + iconSize + ' width=' + iconSize + '></div>';
                else if (val[dataModel.radarPPI] > 0) html += '<div class=\'pheno\'><img src=./' + iconFolder + '/prec.svg height=' + iconSize + ' width=' + iconSize + '></div>';


                return L.divIcon({ html: html, iconSize: [iconSize, iconSize], className: 'divIcon' });
            }

            function PrintPopup(val, coverAmout) {
                return `<div id='popup'>
                        <div id= 'istAd' > `+ val[dataModel.ad] + `</div >` + AutoMan(val) +
                    `<div id='istBilgi'>
                                <div class='arabaslik'>İstasyon Bilgileri</div>
                                <div>Enlem: `+ val[dataModel.lat] + ` | Boylam: ` + val[dataModel.lon] + ` | Yükseklik: ` + val[dataModel.alt] + ` | Çalışma Şekli: ` + val[dataModel.autoMan] + `</div>
                            </div>
                            <div class='arabaslik'>Ölçülen Değerler</div>
                            <div id='olcumler'>
                                Sıcaklık: `+ val[dataModel.temperature] + ` | İşba: ` + val[dataModel.dewPoint] + ` | Görüş Mesafesi: ` + val[dataModel.visibility] + ` | Rüzgar:  ` + val[dataModel.windDirection] + ` / ` + val[dataModel.windSpeed] + ` | Toplam Kapalılık: ` + coverAmout + ` / 8 | Bulut Taban: ` + val[dataModel.cloudBottomObs] + ` 
                            </div>
                            <div id='hesaplanan'>
                                <div class='arabaslik'>Hesaplanan Değerler</div>
                                <div>Bulut Kapalılığı (%): `+ val[dataModel.cloudCoverSat] + `</div>
                                <div>Hesaplanan: `+ val[dataModel.cloudBottomEst] + `m | Enterpole Edilen: ` + val[dataModel.cloudBottomInterpole] + `m </div>
                                <hr />
                                <div>Alçak Bulut Miktarı: `+ val[dataModel.cloudLowSat] + ` | Orta Bulut Miktarı: ` + val[dataModel.cloudMidSat] + ` | Yüksek Bulut Miktarı: ` + val[dataModel.cloudHiSat] + `</div>
                                <div>En Yakın Radar PPI Değeri: `+ val[dataModel.radarPPI] + `</div>
                                <div>İstasyon Etrafındaki Şimşek Sayısı: `+ val[dataModel.lighteningCount] + `</div>
                                <div>Muhtemel Hadise: `+ Phenomenon(val) + `</div>
                                <div>CB `+ CB(val) + `</div>
                                <hr/>
                                <div id='tarih'> Gözlem Tarih ve Saati:<br/>`+ val[dataModel.hour] + ` ` + val[dataModel.day] + `.` + val[dataModel.month] + `.` + val[dataModel.year] + `</div>
                            </div>
                        </div >
                      `
            }

            function AutoMan(val) {
                if (val[dataModel.autoMan] == "Otomatik") return '<div class=\'autoMan\'><img src=./' + iconFolder + '/auto.svg height=' + iconSize + ' width=' + iconSize + '></div>';
                else return '<div class=\'autoMan\'><img src=./' + iconFolder + '/man.svg height=' + iconSize + ' width=' + iconSize + '></div>';
            }

            function Phenomenon(val) {
                if (val[dataModel.lighteningCount] > 0 && val[dataModel.radarPPI] > 0) return "Gökgürültülü Sağanak";
                else if (val[dataModel.lighteningCount] > 0) return "Gökgürültülü";
                else if (val[dataModel.radarPPI] > 0) return "Yağış";
                else if (val[dataModel.temperature] - val[dataModel.dewPoint] < 0.5) return "Sis/Pus"
                else return "--";
            }

            function CB(val) {
                if (val[dataModel.lighteningCount] > 0) return "var";
                else return "yok";
            }

        </script>
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
    </form>
    <script type="text/javascript">
            var map = L.map('map').setView([39.0, 35.5], 6);
            map.zoomControl.setPosition('topright');
            // add an OpenStreetMap tile layer
            L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                attribution: 'Bu çalışma deneme aşamasındadır. Haritada Gösterilen noktalarda, hesaplanan değerlerden daha farklı hava durumu gözlenebilir. Bu üründen faydalanılması, kullanıcının inisiyatifindedir. MGM hiçbir şekilde sorumlu tutulamaz. | &copy; <a href="http://www.mgm.gov.tr">Meteoroloji Genel Müdürlüğü</a>'
            }).addTo(map);
            window.addEventListener('resize', function () {
                document.getElementById("map").style.height = window.innerHeight-20 + 'px';
            })

            window.addEventListener('load', function () {
                document.getElementById("map").style.height = window.innerHeight-20 + 'px';
                yukle();
            })

            map.on("zoomend", function () {

                if (map.getZoom() < 9) {
                    ShowInfo('cloudInfo', false);
                } else {
                    ShowInfo('cloudInfo', true);
                }

                if (map.getZoom() < 8) {
                    ShowInfo('precipitation', false);
                } else {
                    ShowInfo('precipitation', true);
                }
            });

            function ShowInfo(obj, show) {
                var infos = document.getElementsByClassName(obj);
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



            const picker = datepicker(document.querySelector('#datetime'), {
                position: 'bl', // bottom left.
                startDate: new Date(), // This month.
                startDay: 1, // Calendar week starts on a Monday.
                dateSelected: new Date(), // Today is selected.
                minDate: new Date(2016, 5, 1), // June 1st, 2016.
                maxDate: new Date(2099, 0, 1), // Jan 1st, 2099.
                noWeekends: false, // Weekends will be unselectable.
                formatter: function (el, date) {
                    // This will display the date as `1/1/2017`.
                    //el.value = date.toDateString();
                    //el.value = date.getDate() + "." + (Number(date.getMonth()) + 1) + "." + date.getFullYear();
                },
                onSelect: function (instance) {
                    // Show which date was selected.
                    console.log(instance.dateSelected);
                    instance.el.value = instance.dateSelected.getDate() + "." + (Number(instance.dateSelected.getMonth()) + 1) + "." + instance.dateSelected.getFullYear();
                },
                onShow: function (instance) {
                    console.log('Calendar showing.');
                },
                onHide: function (instance) {
                    console.log('Calendar hidden.');
                },
                onMonthChange: function (instance) {
                    // Show the month of the selected date.
                    console.log(instance.currentMonthName);
                },
                customMonths: ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'],
                customDays: ['Paz', 'Pts', 'Sal', 'Çar', 'Per', 'Cum', 'Cts'],
                overlayPlaceholder: 'Yılı giriniz.',
                overlayButton: 'Tamam',
                disableMobile: true // Conditionally disabled on mobile devices.
            });
    </script>
</body>
</html>
