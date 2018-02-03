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

            var map = L.map('map').setView([39.0, 35.5], 4);
            // add an OpenStreetMap tile layer
            L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.mgm.gov.tr">Meteoroloji Genel Müdürlüğü</a>'
            }).addTo(map);

            function yukle() {
                console.log(title);
                console.log(value);
                console.log(title[dataModel.istNo] + " " + value[0][dataModel.istNo]);
            }


            
        </script>
    </form>
</body>
</html>
