<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>RentEasy Google Maps Test</title>

    <style>
        #map {
            height: 600px;
            width: 100%;
        }

        #locationBtn {
            margin: 10px 0;
            padding: 12px 20px;
            font-size: 16px;
            cursor: pointer;
        }

        #locationStatus {
            margin: 10px 0;
            font-family: Arial, sans-serif;
        }
    </style>
</head>

<body>

<h2>RentEasy Google Maps Test</h2>

<button id="locationBtn" onclick="getCurrentLocation()">
    📍 Use My Current Location
</button>

<div id="locationStatus">
    Click the button to detect your current location.
</div>

<div id="map"></div>

<script>

let map;
let userMarker;

function initMap() {

    const pune = {
        lat: 18.5204,
        lng: 73.8567
    };

    map = new google.maps.Map(
        document.getElementById("map"),
        {
            zoom: 13,
            center: pune
        }
    );
}


function getCurrentLocation() {

    const status = document.getElementById("locationStatus");

    // Check browser support
    if (!navigator.geolocation) {

        status.innerHTML =
            "❌ Geolocation is not supported by your browser.";

        return;
    }

    status.innerHTML =
        "📍 Detecting your current location...";

    navigator.geolocation.getCurrentPosition(

        function(position) {

            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;

            const currentLocation = {
                lat: latitude,
                lng: longitude
            };

            // Move map to current location
            map.setCenter(currentLocation);
            map.setZoom(16);

            // Remove previous marker
            if (userMarker) {
                userMarker.setMap(null);
            }

            // Create marker
            userMarker = new google.maps.Marker({
                position: currentLocation,
                map: map,
                title: "Your Current Location"
            });

            status.innerHTML =
                "✅ Location detected!<br>" +
                "Latitude: " + latitude + "<br>" +
                "Longitude: " + longitude;

            console.log("Latitude:", latitude);
            console.log("Longitude:", longitude);

        },

        function(error) {

            if (error.code === 1) {

                status.innerHTML =
                    "❌ Location permission denied. Please allow location access.";

            }
            else if (error.code === 2) {

                status.innerHTML =
                    "❌ Current location is unavailable.";

            }
            else if (error.code === 3) {

                status.innerHTML =
                    "❌ Location request timed out.";

            }
            else {

                status.innerHTML =
                    "❌ Unable to detect your location.";

            }

            console.log("Geolocation error:", error);

        },

        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
    );
}

</script>


<script
    async
    defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDzKVEoUwy3YJ3CfIdE0V0qFm4hY6HeZeE&libraries=places&callback=initMap">
</script>

</body>
</html>