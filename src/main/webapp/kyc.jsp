<%@ page session="true" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("login.jsp");
    return;
}
String user = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>KYC - RentEasy</title>

<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background: url("https://images.unsplash.com/photo-1600585154340-be6161a56a0c") no-repeat center/cover;
    height: 100vh;
}

.overlay {
    position: fixed;
    top:0; left:0; right:0; bottom:0;
    background: rgba(0,0,0,0.5);
}

.kyc-card {
    position: relative;
    z-index: 2;
    max-width: 550px;
    margin: auto;
    margin-top: 50px;
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(15px);
    padding: 30px;
    border-radius: 20px;
    color: white;
}

.form-control {
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
}

.form-control::placeholder {
    color: #ddd;
}

.btn-success {
    background: #36cfc9;
    border: none;
}
</style>

</head>

<body>

<div class="overlay"></div>

<div class="kyc-card">

<h2 class="text-center mb-4">Complete KYC</h2>

<form action="saveKyc" method="post" enctype="multipart/form-data" onsubmit="return validateOTP()">

<input type="hidden" name="username" value="<%= user %>">

<!-- NAME -->
<label>Full Name</label>
<input type="text" name="fullname" class="form-control mb-3" required>

<!-- EMAIL -->
<label>Email</label>
<input type="email" name="email" class="form-control mb-3" required>

<!-- PHONE -->
<label>Phone</label>
<div class="d-flex mb-2">
    <input type="text" id="phone" name="phone" class="form-control me-2" required>
    <button type="button" class="btn btn-primary" onclick="sendOTP()">Send OTP</button>
</div>

<label>Enter OTP</label>
<input type="text" id="otpInput" class="form-control mb-3" required>

<!-- AADHAAR -->
<label>Aadhaar Number</label>
<input type="text" name="aadhaar" class="form-control mb-3" required>

<!-- ADDRESS -->
<label>Address</label>
<textarea name="address" class="form-control mb-3" required></textarea>

<!-- PHOTO -->
<label>Profile Photo</label>
<input type="file" name="photo" class="form-control mb-3" required>

<!-- DOCUMENT -->
<label>ID Proof</label>
<input type="file" name="document" class="form-control mb-3" required>

<button class="btn btn-success w-100">Submit KYC</button>

</form>
</div>

<script>
let generatedOTP = "";

function sendOTP(){
    let phone = document.getElementById("phone").value;

    if(phone.length < 10){
        alert("Enter valid phone number");
        return;
    }

    generatedOTP = Math.floor(1000 + Math.random() * 9000);
    alert("OTP: " + generatedOTP);
}

function validateOTP(){
    let entered = document.getElementById("otpInput").value;

    if(entered != generatedOTP){
        alert("Invalid OTP");
        return false;
    }

    return true;
}
</script>

</body>
</html>