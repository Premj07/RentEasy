<!DOCTYPE html>
<html>
<head>
<title>Signup - RentEasy</title>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    margin:0;
    height:100vh;
    background:url("https://images.unsplash.com/photo-1600585154340-be6161a56a0c") no-repeat center/cover;
    font-family:'Segoe UI';
}

.overlay{
    position:absolute;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
}

.container-box{
    position:relative;
    z-index:2;
    height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
}

.form-box{
    width:380px;
    padding:30px;
    border-radius:15px;
    background:rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    box-shadow:0 8px 25px rgba(0,0,0,0.4);
    color:white;
}

.form-control{
    background:rgba(255,255,255,0.2);
    border:none;
    color:white;
}

.form-control::placeholder{
    color:#ddd;
}

.btn-main{
    background:#28a745;
    border:none;
    width:100%;
    padding:10px;
    color:white;
}

.checkbox-label{
    font-size:14px;
    color:#ddd;
}
</style>
</head>

<body>

<div class="overlay"></div>

<div class="container-box">

<div class="form-box">

<h2 class="text-center">Create Account</h2>

<form action="signup" method="post" onsubmit="return validateForm()">

<div class="row">

<div class="col-6">
<input
type="text"
name="firstName"
class="form-control mb-3"
placeholder="First Name"
required>
</div>

<div class="col-6">
<input
type="text"
name="lastName"
class="form-control mb-3"
placeholder="Last Name"
required>
</div>

</div>

<label class="mb-2">MIT-ADT Email</label>

<div class="input-group mb-3">

<input
type="email"
id="email"
name="email"
class="form-control"
placeholder="Enter Email"
required>

<button
class="btn btn-primary"
type="button"
onclick="sendOTP()">

Send OTP

</button>

</div>

<input
type="text"
name="otp"
class="form-control mb-3"
placeholder="Enter Email OTP"
required>

<small
id="otpMessage"
style="color:green;font-weight:bold;"></small>

<input
type="text"
name="phone"
class="form-control mb-3"
placeholder="Mobile Number"
required>

<div class="form-check mb-4">

<input
class="form-check-input"
type="checkbox"
id="terms">

<label class="form-check-label">

I agree to
<a href="#">
Terms & Conditions
</a>

</label>

</div>

<h2 class="text-center mb-2">
Welcome to RentEasy
</h2>

<p class="text-center mb-4">
Create your account in less than a minute.
</p>
	
</form>

<p class="mt-3 text-center">
<a href="index.jsp" style="color:white;">Already have account?</a>
</p>

</div>
</div>

<!-- ✅ VALIDATION SCRIPT -->
<script>
function validateForm(){
    let terms = document.getElementById("terms");

    if(!terms.checked){
        alert("Please accept Terms & Conditions ❌");
        return false;
    }

    return true;
}
</script>
<script>


</script>
<script>

function sendOTP(){

    let email =
    document.getElementById("email").value;

    if(email==""){

        alert("Enter Email First");
        return;

    }

    fetch(
    "sendOtp?email="
    + encodeURIComponent(email))

    .then(response=>response.text())

    .then(data=>{

        document.getElementById(
        "otpMessage").innerHTML=data;

    });

}

</script>
</body>
</html>