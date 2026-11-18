<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
    return;
}

String username=(String)session.getAttribute("user");

String productId=request.getParameter("id");

String name = "";
String category = "";
String description = "";
String location = "";
String pincode = "";
String listingType = "RENT";

int price = 0;
int deposit = 0;
int actualPrice = 0;

double sellingPrice = 0.0;

if(productId!=null){

    try{

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con=
        DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456");

        PreparedStatement ps=
        con.prepareStatement(
        "SELECT * FROM products WHERE id=?");

        ps.setInt(1,Integer.parseInt(productId));

        ResultSet rs=ps.executeQuery();

        if(rs.next()){

            name = rs.getString("name");
            category = rs.getString("category");
            description = rs.getString("description");
            location = rs.getString("location");
            pincode = rs.getString("pincode");
            listingType = rs.getString("listing_type");

            price = rs.getInt("price");
            deposit = rs.getInt("deposit");
            actualPrice = rs.getInt("actual_price");
            sellingPrice = rs.getDouble("selling_price");

            if(listingType == null || listingType.trim().isEmpty()){
                listingType = "RENT";
            }
        }

        con.close();

        } catch(Exception e){
            out.println(e);
        }
}
%>

<!-- ==========================================================
                    PART 1 START
     Replace everything from <!DOCTYPE html> to before
     <div class="col-md-6 mb-3"> Product Name
=========================================================== -->

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>
<%= productId!=null ? "Edit Product" : "Add Product" %>
</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<link rel="stylesheet" href="css/navbar.css">
<link rel="stylesheet" href="css/owner-dashboard.css">
<link rel="stylesheet" href="css/add-product.css">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>

<script async
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDzKVEoUwy3YJ3CfIdE0V0qFm4hY6HeZeE&libraries=places&callback=initLocationMap">
</script>
</head>


<body>

<!-- ================= NAVBAR ================= -->

<jsp:include page="includes/navbar.jsp"/>

<!-- ================= SIDEBAR ================= -->
<jsp:include page="includes/owner-sidebar.jsp"/>
<!-- ================= MAIN CONTENT ================= -->

<div class="main-content">

<div class="container-fluid">

<!-- PAGE HEADER -->

<div class="d-flex justify-content-between align-items-center mb-4">

<div>

<h2 class="fw-bold text-primary">

<i class="fa-solid fa-box-open"></i>

<%= productId!=null ?
"Edit Product" :
"Add Product" %>

</h2>

<p class="text-muted">

Manage your rental products easily.

</p>

</div>

</div>

<!-- ================= CARD ================= -->

<div class="card shadow-lg border-0 rounded-4">

<div class="card-header bg-primary text-white rounded-top-4">

<h4 class="mb-0">

<i class="fa-solid fa-circle-plus"></i>

Product Information

</h4>

</div>

<div class="card-body p-4">

<form
action="<%= productId!=null ? "UpdateProductServlet" : "addProduct" %>"
method="post"
enctype="multipart/form-data">

<input
type="hidden"
name="id"
value="<%=productId!=null?productId:""%>">

<input type="hidden"
       name="owner"
       value="<%=session.getAttribute("email")%>">
       
<input type="hidden" id="latitude" name="latitude">
<input type="hidden" id="longitude" name="longitude">

<div class="row">

<!-- ==========================================================
                    PART 2 START
=========================================================== -->

<!-- Product Name -->

<div class="col-md-6 mb-3">

    <label class="form-label fw-semibold">
        Product Name
    </label>

    <input
        type="text"
        name="name"
        class="form-control"
        value="<%=name%>"
        placeholder="Enter Product Name"
        required>

</div>

<!-- Category -->

<div class="col-md-6 mb-3">

<label class="form-label fw-semibold">
Category
</label>

<select
name="category"
class="form-select"
required>

<option value="">Select Category</option>

<option value="Electronics"
<%= "Electronics".equals(category)?"selected":"" %>>
Electronics
</option>

<option value="Furniture"
<%= "Furniture".equals(category)?"selected":"" %>>
Furniture
</option>

<option value="Vehicle"
<%= "Vehicle".equals(category)?"selected":"" %>>
Vehicle
</option>

<option value="Tools"
<%= "Tools".equals(category)?"selected":"" %>>
Tools
</option>

<option value="Sports"
<%= "Sports".equals(category)?"selected":"" %>>
Sports
</option>

<option value="Others"
<%= "Others".equals(category)?"selected":"" %>>
Others
</option>

</select>

</div>

<!-- Rent Price -->

<div class="col-md-4 mb-3">

<label class="form-label fw-semibold">
Rent Per Day (₹)
</label>

<input
type="number"
name="price"
class="form-control"
value="<%=price%>"
required>

</div>

<!-- Deposit -->

<div class="col-md-4 mb-3">

<label class="form-label fw-semibold">
Security Deposit (₹)
</label>

<input
type="number"
name="deposit"
class="form-control"
value="<%=deposit%>"
required>

</div>

<!-- Actual Price -->

<div class="col-md-4 mb-3">

<label class="form-label fw-semibold">
Actual Product Price (₹)
</label>

<input
type="number"
name="actualPrice"
class="form-control"
value="<%=actualPrice%>"
required>

</div>

<!-- Listing Type -->

<div class="col-md-6 mb-3">

<label class="form-label fw-semibold">
Listing Type
</label>

<select
name="listingType"
id="listingType"
class="form-select"
onchange="toggleFields()">

<option value="RENT"
<%= "RENT".equals(listingType)?"selected":"" %>>
Rent Only
</option>

<option value="SELL"
<%= "SELL".equals(listingType)?"selected":"" %>>
Sell Only
</option>

<option value="BOTH"
<%= "BOTH".equals(listingType)?"selected":"" %>>
Rent & Sell
</option>

</select>

</div>

<!-- Selling Price -->

<div
class="col-md-6 mb-3"
id="sellingPriceDiv"
style="display:none;">

<label class="form-label fw-semibold">
Selling Price (₹)
</label>

<input
type="number"
name="sellingPrice"
id="sellingPrice"
class="form-control"
value="<%=sellingPrice%>"
step="0.01"
min="0">

</div>

<!-- Description -->

<div class="col-12 mb-3">

<label class="form-label fw-semibold">
Description
</label>

<textarea
name="description"
rows="5"
class="form-control"
placeholder="Describe your product..."><%=description%></textarea>

</div>

<!-- Pincode -->

<div class="col-md-6 mb-3">

<label class="form-label fw-semibold">
Pincode
</label>

<input
    type="text"
    id="pincode"
    name="pincode"
    class="form-control"
    value="<%=pincode%>"
    placeholder="Pincode"
    maxlength="10"
    required>

</div>

<!-- Location -->

<div class="col-md-6 mb-3">

<label class="form-label fw-semibold">
Location
</label>

<input
    type="text"
    id="location"
    name="location"
    class="form-control"
    value="<%=location%>"
    placeholder="City / Area"
    required>

</div>
<div id="mapContainer" style="display:none; margin-top:15px;">
    <iframe
        id="mapFrame"
        width="100%"
        height="350"
        style="border:0; border-radius:12px;"
        loading="lazy"
        allowfullscreen>
    </iframe>
</div>
<!--Google map Location -->
<button type="button"
class="btn btn-primary w-100"
data-bs-toggle="modal"
data-bs-target="#locationModal">

<i class="fa-solid fa-location-dot"></i>
Select Product Location

</button>
<!-- Google Map Modal -->

<div class="modal fade"
id="locationModal"
tabindex="-1">

<div class="modal-dialog modal-xl">

<div class="modal-content">

<div class="modal-header">

<h5 class="modal-title">

📍 Select Product Location

</h5>

<button
type="button"
class="btn-close"
data-bs-dismiss="modal">
</button>

</div>

<div class="modal-body">

<div class="mb-3">

<input
type="text"
id="searchLocation"
class="form-control form-control-lg"
placeholder="🔍 Search Product Location">

</div>

<div class="mb-3">
    <button
        type="button"
        class="btn btn-success"
        onclick="useCurrentLocation()">

        <i class="fa-solid fa-location-crosshairs"></i>
        Use My Current Location

    </button>
</div>

<div
id="googleMap"
style="height:500px;width:100%;">
</div>

</div>

<div class="modal-footer">

<button
    type="button"
    class="btn btn-secondary"
    data-bs-dismiss="modal">

    Close

</button>

<button
    type="button"
    class="btn btn-success"
    onclick="confirmLocation()">

    <i class="fa-solid fa-check"></i>
    Use This Location

</button>

</div>


</div>

</div>

</div>

</div>

<!-- Product Image -->

<div class="col-12 mb-4">

<label class="form-label fw-semibold">
Product Image
</label>

<input
type="file"
name="imageFile"
id="imageFile"
class="form-control"
accept="image/*"
onchange="previewImage(event)">

<br>

<img
id="preview"
src="#"
style="display:none;
width:220px;
border-radius:12px;
border:1px solid #ddd;">

</div>

</div>

<div class="d-grid">

<button
type="submit"
class="btn btn-primary btn-lg">

<i class="fa-solid fa-floppy-disk"></i>

<%= productId!=null ?
" Update Product" :
" Add Product" %>

</button>

</div>

</form>

</div>

</div>

</div>

</div>

<!-- ==========================================================
                    PART 3 START
=========================================================== -->

<script>

function toggleFields(){

    var type=document.getElementById("listingType").value;

    var sellingDiv=document.getElementById("sellingPriceDiv");

    if(type=="SELL" || type=="BOTH"){
        sellingDiv.style.display="block";
    }else{
        sellingDiv.style.display="none";
        document.getElementById("sellingPrice").value="";
    }

}

function previewImage(event){

    var preview=document.getElementById("preview");

    preview.src=URL.createObjectURL(event.target.files[0]);

    preview.style.display="block";

}

window.onload=function(){

    toggleFields();

};
let map;
let marker;
let geocoder;
let searchBox;

function initLocationMap() {

    const defaultLocation = {
        lat: 18.5204,
        lng: 73.8567
    };

    geocoder = new google.maps.Geocoder();
    const input = document.getElementById("searchLocation");

    const autocomplete = new google.maps.places.Autocomplete(input, {
        fields: ["geometry", "formatted_address", "name"]
    });
    map = new google.maps.Map(document.getElementById("googleMap"), {
        center: defaultLocation,
        zoom: 13,
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: true
    });

    marker = new google.maps.Marker({
        map: map,
        position: defaultLocation,
        draggable: true,
        animation: google.maps.Animation.DROP
    });
    
    autocomplete.addListener("place_changed", function () {

        const place = autocomplete.getPlace();

        if (!place.geometry) {
            alert("Please select a valid location.");
            return;
        }

        map.setCenter(place.geometry.location);
        map.setZoom(17);

        marker.setPosition(place.geometry.location);

        document.getElementById("location").value =
            place.formatted_address;

        document.getElementById("latitude").value =
            place.geometry.location.lat();

        document.getElementById("longitude").value =
            place.geometry.location.lng();

    });

    updateLocation(marker.getPosition());

    // Click anywhere on map
    map.addListener("click", function(event) {

        marker.setPosition(event.latLng);

        updateLocation(event.latLng);

    });

    // Drag marker
    marker.addListener("dragend", function(event) {

        updateLocation(event.latLng);

    });
 // Automatically get user's current location
// Automatically get user's current location
if (navigator.geolocation && !window.locationInitialized) {

    window.locationInitialized = true;

    navigator.geolocation.getCurrentPosition(

        function(position) {

            const currentLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };

            map.setCenter(currentLocation);
            map.setZoom(17);

            marker.setPosition(currentLocation);

            updateLocation(marker.getPosition());

        },

        function(error) {

            console.log(error);

            updateLocation(marker.getPosition());

        }

    );

} else {

    updateLocation(marker.getPosition());

}

// Close initLocationMap()
}
function useCurrentLocation() {

    if (!navigator.geolocation) {

        alert("Your browser does not support location detection.");
        return;
    }

    navigator.geolocation.getCurrentPosition(

        function(position) {

            const currentLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };

            map.setCenter(currentLocation);
            map.setZoom(17);

            marker.setPosition(currentLocation);

            updateLocation(currentLocation);

        },

        function(error) {

            if (error.code === 1) {

                alert(
                    "Location permission denied. " +
                    "Please allow location access in your browser."
                );

            } else if (error.code === 2) {

                alert("Your current location is unavailable.");

            } else if (error.code === 3) {

                alert("Location request timed out.");

            } else {

                alert("Unable to detect your current location.");

            }

        },

        {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
    );
}

function updateLocation(latLng) {

    // Save latitude
    document.getElementById("latitude").value =
        latLng.lat();

    // Save longitude
    document.getElementById("longitude").value =
        latLng.lng();

    // Reverse geocode
    geocoder.geocode(
        {
            location: latLng
        },
        function(results, status) {

            if (status === "OK" && results[0]) {

                const result = results[0];

                // Fill Location
                document.getElementById("location").value =
                    result.formatted_address;

                // Find Pincode
                let pincode = "";

                for (
                    let i = 0;
                    i < result.address_components.length;
                    i++
                ) {

                    const component =
                        result.address_components[i];

                    if (
                        component.types.includes("postal_code")
                    ) {

                        pincode = component.long_name;
                        break;
                    }
                }

                // Fill Pincode
                const pincodeField =
                    document.getElementById("pincode");

                if (pincodeField) {
                    pincodeField.value = pincode;
                }

                console.log("Location:", result.formatted_address);
                console.log("Pincode:", pincode);
                console.log("Latitude:", latLng.lat());
                console.log("Longitude:", latLng.lng());

            } else {

                console.log(
                    "Geocoder failed:",
                    status
                );

            }

        }
    );
}
map.setCenter(currentLocation);
map.setZoom(17);

marker.setPosition(currentLocation);

updateLocation(currentLocation);
const locationModal = document.getElementById("locationModal");

locationModal.addEventListener("shown.bs.modal", function () {

    if (!map) {

        initLocationMap();

    } else {

        google.maps.event.trigger(map, "resize");

    }

});
</script>

<style>

/* ===========================
        MAIN CONTENT
=========================== */

.main-content{

    margin-left:260px;
    margin-top:80px;

    padding:30px;

    transition:0.3s;

}

/* ===========================
            CARD
=========================== */

.card{

    border-radius:20px;

}

.card-header{

    padding:18px;

}

/* ===========================
            INPUTS
=========================== */

.form-control,
.form-select{

    height:48px;

    border-radius:10px;

}

textarea.form-control{

    height:auto;

}

/* ===========================
            BUTTON
=========================== */

.btn-primary{

    height:50px;

    font-size:18px;

    border-radius:10px;

}

/* ===========================
        IMAGE PREVIEW
=========================== */

#preview{

    max-width:220px;

    margin-top:15px;

    border-radius:12px;

    object-fit:cover;

}

/* ===========================
        MOBILE
=========================== */

@media(max-width:992px){

.main-content{
    padding:15px;
    margin-top:90px;
}

}

</style>
<script>

function confirmLocation() {

    const latitude =
        document.getElementById("latitude").value;

    const longitude =
        document.getElementById("longitude").value;


    // We need coordinates first
    if (!latitude || !longitude) {

        alert("Please select a location first.");

        return;
    }


    // If location is already available,
    // directly close the modal
    const existingLocation =
        document.getElementById("location").value;

    if (existingLocation) {

        closeLocationModal();

        return;
    }


    // Address is not available yet.
    // Do reverse geocoding NOW.

    const latLng = new google.maps.LatLng(
        parseFloat(latitude),
        parseFloat(longitude)
    );


    geocoder.geocode(
        {
            location: latLng
        },
        function(results, status) {

            if (status === "OK" && results[0]) {

                const result = results[0];


                // -----------------------------
                // LOCATION
                // -----------------------------

                document.getElementById("location").value =
                    result.formatted_address;


                // -----------------------------
                // PINCODE
                // -----------------------------

                let pincode = "";

                for (
                    let i = 0;
                    i < result.address_components.length;
                    i++
                ) {

                    const component =
                        result.address_components[i];

                    if (
                        component.types.includes("postal_code")
                    ) {

                        pincode =
                            component.long_name;

                        break;
                    }
                }


                const pincodeField =
                    document.getElementById("pincode");

                if (pincodeField) {

                    pincodeField.value =
                        pincode;
                }


                console.log(
                    "Confirmed Location:",
                    result.formatted_address
                );

                console.log(
                    "Confirmed Pincode:",
                    pincode
                );

                console.log(
                    "Confirmed Latitude:",
                    latitude
                );

                console.log(
                    "Confirmed Longitude:",
                    longitude
                );


                // -----------------------------
                // CLOSE MODAL
                // -----------------------------

                closeLocationModal();


            } else {

                alert(
                    "Unable to detect the address. " +
                    "Please try again."
                );

                console.log(
                    "Geocoder error:",
                    status
                );

            }

        }
    );
}
function closeLocationModal() {

    const modalElement =
        document.getElementById("locationModal");

    const modal =
        bootstrap.Modal.getInstance(modalElement);

    if (modal) {

        modal.hide();

    }

}
</script>
</body>
</html>

<!-- ==========================================================
                    PART 3 END
=========================================================== -->