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

<input type="text" name="name" class="form-control mb-2" placeholder="Full Name" required>

<input type="text" name="username" class="form-control mb-2" placeholder="Username" required>

<input type="email" name="email" class="form-control mb-2" placeholder="Email" required>

<input type="text" name="phone" class="form-control mb-2" placeholder="Phone Number">

<input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

<!-- ✅ AGREEMENT CHECKBOX -->
<div class="form-check mb-2">
  <input class="form-check-input" type="checkbox" id="terms">
  <label class="form-check-label checkbox-label">
    I agree to the <a href="#" style="color:#36cfc9;">Terms & Conditions</a>
  </label>
</div>

<div class="form-check mb-3">
  <input class="form-check-input" type="checkbox">
  <label class="form-check-label checkbox-label">
    Get updates from RentEasy
  </label>
</div>

<button class="btn-main">Signup</button>

</form>

<p class="mt-3 text-center">
<a href="login.jsp" style="color:white;">Already have account?</a>
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

</body>
</html>