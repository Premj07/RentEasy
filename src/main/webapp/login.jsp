<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<title>Login - RentEasy</title>

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

/* DARK OVERLAY */
.overlay{
    position:absolute;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
}

/* CENTER BOX */
.container-box{
    position:relative;
    z-index:2;
    height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
}

/* GLASS EFFECT */
.form-box{
    width:350px;
    padding:30px;
    border-radius:15px;
    background:rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    box-shadow:0 8px 25px rgba(0,0,0,0.4);
    color:white;
}

/* INPUT */
.form-control{
    background:rgba(255,255,255,0.2);
    border:none;
    color:white;
}

.form-control::placeholder{
    color:#ddd;
}

/* BUTTON */
.btn-main{
    background:#36cfc9;
    border:none;
    width:100%;
    padding:10px;
    color:white;
}
</style>
</head>

<body>

<div class="overlay"></div>

<div class="container-box">

<div class="form-box">

<h2 class="text-center">RentEasy</h2>
<h4 class="mb-3 text-center">Login</h4>

<!-- ERROR -->
<%
if(request.getParameter("error") != null){
%>
<div class="alert alert-danger">Invalid login ❌</div>
<%
}
%>

<form action="login" method="post">

<input type="text" name="username" class="form-control mb-3" placeholder="Username" required>

<input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

<button class="btn-main">Login</button>

</form>

<p class="mt-3 text-center">
<a href="signup.jsp" style="color:white;">Create Account</a>
</p>

</div>
</div>

</body>
</html>