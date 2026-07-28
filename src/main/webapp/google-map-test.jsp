<!DOCTYPE html>
<html>
<head>
    <title>Google Maps Test</title>

    <style>
        #map{
            height:600px;
            width:100%;
        }
    </style>
</head>

<body>

<h2>RentEasy Google Maps Test</h2>

<div id="map"></div>

<script>

function initMap(){

    const pune = {
        lat:18.5204,
        lng:73.8567
    };

    new google.maps.Map(
        document.getElementById("map"),
        {
            zoom:13,
            center:pune
        }
    );

}

</script>

<script async defer
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvoe_2z74NwxiJuh-TVt76f7j_a52Zuqc&callback=initMap">
</script>

</body>
</html>