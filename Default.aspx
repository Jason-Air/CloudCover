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

        <div id="skala">
            <div id="ok">
                <div id="kapat">
                    <div>«</div>
                </div>
            </div>
            <div id="renkIcerik">
                <div class="aciklama">
                    Görüş:<br />
                    Bulut Tabanı:
                </div>
                <div class="renk">
                    <div class="renkLejant kirmizi"></div>
                    <div class="deger">
                        &lt;800m<br />
                        &lt;200ft
                    </div>
                </div>
                <div class="renk">
                    <div class="renkLejant sari"></div>
                    <div class="deger">
                        &lt;1600m<br />
                        &lt;300ft
                    </div>
                </div>
                <div class="renk">
                    <div class="renkLejant gri"></div>
                    <div class="deger">
                        &lt;3700m<br />
                        &lt;700ft
                    </div>
                </div>
                <div class="renk">
                    <div class="renkLejant yesil"></div>
                    <div class="deger">
                        &lt;8000m<br />
                        &lt;2500ft
                    </div>
                </div>
                <div class="renk">
                    <div class="renkLejant mavi"></div>
                    <div class="deger">
                        &gt;8000m<br />
                        &gt;2500ft
                    </div>
                </div>
                <div class="renk">
                    <div class="renkLejant siyah"></div>
                    <div class="deger">Bulut ve Görüş Bilgisi Yok</div>
                </div>
            </div>
            <div class="clear"></div>
            <div id="bilgi">Bu çalışma deneme aşamasındadır. Haritada Gösterilen noktalarda, hesaplanan değerlerden daha farklı hava durumu gözlenebilir. Bu üründen faydalanılması, kullanıcının inisiyatifindedir. MGM hiçbir şekilde sorumlu tutulamaz.</div>
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
                ShowInfo('prec', false);
                ShowInfo('cloudInfo', false);
                ShowInfo('lightning', false);
            }

            function GetIcon(val, cover) {
                var cloudBottom = null, visibility = null, colorClass = "";
                if (!isNaN(val[dataModel.cloudBottomObs])) cloudBottom = val[dataModel.cloudBottomObs] * 3.3;
                else if (!isNaN(val[dataModel.cloudBottomEst])) cloudBottom = val[dataModel.cloudBottomEst] * 3.3;
                else if (!isNaN(val[dataModel.cloudBottomInterpole])) cloudBottom = val[dataModel.cloudBottomInterpole] * 3.3;
                if (cloudBottom == null && val[dataModel.visibility] == '---') colorClass = "siyah";
                else if (cloudBottom < 200 || val[dataModel.visibility] < 800) colorClass = "kirmizi";
                else if (cloudBottom < 300 || val[dataModel.visibility] < 1600) colorClass = "sari";
                else if (cloudBottom < 700 || val[dataModel.visibility] < 3700) colorClass = "gri";
                else if (cloudBottom < 2500 || val[dataModel.visibility] < 8000) colorClass = "yesil";
                else if (cloudBottom > 2500 || val[dataModel.visibility] > 8000) colorClass = "mavi";
                else colorClass = "siyah"

                var html = '<div class=\'cloudInfo\'> ' + val[dataModel.cloudBottomInterpole] + '<br/> ' + val[dataModel.cloudBottomEst] + '</div>'
                html += '<div class=\'icon ' + colorClass + ' n' + cover + '\'></div>';
                if (val[dataModel.lighteningCount] > 0 && val[dataModel.radarPPI] > 0) html += '<div class=\'icon lightning\'></div>'  //'<div class=\'pheno\'><img src=./' + iconFolder + '/lightning.svg height=' + iconSize + ' width=' + iconSize + '></div>';
                else if (val[dataModel.radarPPI] > 0) html += '<div class=\'icon prec\'></div>'  //'<div class=\'pheno\'><img src=./' + iconFolder + '/prec.svg height=' + iconSize + ' width=' + iconSize + '></div>';
                html += '<div class=\'cityName\'>' + val[dataModel.ad] + '</div>';

                return L.divIcon({ html: html, iconSize: [iconSize, iconSize], className: 'divIcon' });
            }

            function PrintPopup(val, coverAmout) {
                return `<div id='popup'>
                            <div id= 'istAd' > `+ val[dataModel.ad] + `</div >` + AutoMan(val) +
                    `<div id='istBilgi'>
                                    <div class='arabaslik'>İstasyon Bilgileri</div>
                                    <div class='bilgi'>
                                        <div>Enlem: `+ val[dataModel.lat] + `˚ </div><div>Boylam: ` + val[dataModel.lon] + `˚ </div><div> Yükseklik: ` + val[dataModel.alt] + `m </div><div>Çalışma Şekli: ` + val[dataModel.autoMan] + `</div>
                                    </div>
                                </div>
                                <div class='arabaslik'>Ölçülen Değerler</div>
                                <div id='olcumler' class='bilgi'>
                                    <div>Sıcaklık: `+ val[dataModel.temperature] + `˚C</div><div>İşba Sıcaklığı: ` + val[dataModel.dewPoint] + `˚C</div><div>Görüş Mesafesi: ` + val[dataModel.visibility] + `m</div><div>Rüzgar:  ` + val[dataModel.windDirection] + `˚ / ` + val[dataModel.windSpeed] + `kt</div><div>Toplam Kapalılık: ` + coverAmout + ` / 8</div><div>Bulut Taban: ` + val[dataModel.cloudBottomObs] + `m</div> 
                                </div>
                                <div class='clear'></div>
                                <div class='arabaslik'>Hesaplanan Değerler</div>
                                <div id='hesaplanan' class='bilgi'>
                                    <div>Bulut Kapalılığı (%): `+ val[dataModel.cloudCoverSat] + `</div>
                                    <div>Hesaplanan: `+ val[dataModel.cloudBottomEst] + `m</div><div>Enterpole Edilen: ` + val[dataModel.cloudBottomInterpole] + `m </div>
                                    
                                </div>
                                <div class='clear'></div>
                                <hr />
                                <div class='bilgi'> 
                                    <div>Alçak Bulut Miktarı: `+ val[dataModel.cloudLowSat] + `</div><div>Orta Bulut Miktarı: ` + val[dataModel.cloudMidSat] + `</div><div>Yüksek Bulut Miktarı: ` + val[dataModel.cloudHiSat] + `</div>
                                    <div>En Yakın Radar PPI Değeri: `+ val[dataModel.radarPPI] + `</div>
                                    <div>İstasyon Etrafındaki Şimşek Sayısı: `+ val[dataModel.lighteningCount] + `</div>
                                    <div>Muhtemel Hadise: `+ Phenomenon(val) + `</div>
                                    <div>CB `+ CB(val) + `</div>
                                </div>
                                <div class='clear'></div>
                                <hr/>    
                                <div class='bilgi'>
                                    <div id='tarih'> Gözlem Tarih ve Saati:<br/>`+ val[dataModel.hour] + ` ` + val[dataModel.day] + `.` + val[dataModel.month] + `.` + val[dataModel.year] + `</div>
                                </div>
                                <div class='clear'></div>
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

            function skalaAcKapat() {
                document.querySelector('#skala').classList.toggle('kapali');
            }
            document.querySelector('#ok').addEventListener('click', skalaAcKapat);
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
                document.getElementById("map").style.height = window.innerHeight - 20 + 'px';
            })

            window.addEventListener('load', function () {
                document.getElementById("map").style.height = window.innerHeight - 20 + 'px';
                yukle();
            })

            map.on("zoomend", function () {

                if (map.getZoom() < 9) {
                    ShowInfo('cloudInfo', false);
                } else {
                    ShowInfo('cloudInfo', true);
                }

                if (map.getZoom() < 8) {
                    ShowInfo('prec', false);
                    ShowInfo('lightning', false);

                } else {
                    ShowInfo('prec', true);
                    ShowInfo('lightning', true);
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
