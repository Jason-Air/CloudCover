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
    <script src="js/jquery-3.3.1.min.js"></script>

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
                var coverInfoColumn,coverAmount;
                for (var i = 0; i < value.length; i++){
                    if (value[i][dataModel.autoMan] == 'Otomatik') coverInfoColumn = dataModel.cloudCoverSat ;
                    else coverInfoColumn = dataModel.cloudCoverObs;
                    coverAmount = Math.round(value[i][coverInfoColumn] / 12.5);
                    console.log(value[i][dataModel.istNo] + " " + value[i][dataModel.ad] + " " + value[i][dataModel.autoMan] + " " + value[i][coverInfoColumn])
                    L.marker([value[i][dataModel.lat], value[i][dataModel.lon]], { icon: CoverIcon(coverAmount) }).addTo(map);
                }
            }

            //var coverIcon = L.icon({ iconUrl: './image/N5.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });

            var n0 = L.icon({ iconUrl: './' + iconFolder+'/N0.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n1 = L.icon({ iconUrl: './' + iconFolder +'/N1.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n2 = L.icon({ iconUrl: './' + iconFolder +'/N2.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n3 = L.icon({ iconUrl: './' + iconFolder +'/N3.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n4 = L.icon({ iconUrl: './' + iconFolder +'/N4.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n5 = L.icon({ iconUrl: './' + iconFolder +'/N5.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n6 = L.icon({ iconUrl: './' + iconFolder +'/N6.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n7 = L.icon({ iconUrl: './' + iconFolder +'/N7.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n8 = L.icon({ iconUrl: './' + iconFolder +'/N8.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });
            var n9 = L.icon({ iconUrl: './' + iconFolder +'/N9.png', iconSize: [iconSize, iconSize], popupAnchor: [-3, -76] });

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





        </script>
    </form>
</body>
</html>
