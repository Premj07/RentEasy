<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KYC Verification Status</title>

<style>
body{
    font-family:Arial,Helvetica,sans-serif;
    background:#f4f6f9;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    margin:0;
}

.card{
    width:500px;
    background:white;
    padding:30px;
    border-radius:10px;
    box-shadow:0 0 15px rgba(0,0,0,.15);
    text-align:center;
}

.cross{
    font-size:60px;
}

h2{
    color:#d32f2f;
}

.reason{
    background:#fff3cd;
    color:#856404;
    padding:15px;
    border-radius:5px;
    margin:20px 0;
    font-weight:bold;
}

.btn{
    display:inline-block;
    padding:12px 25px;
    background:#0d6efd;
    color:white;
    text-decoration:none;
    border-radius:5px;
    font-weight:bold;
}

.btn:hover{
    background:#0b5ed7;
}
</style>

</head>

<body>

<div class="card">

    <div class="cross">❌</div>

    <h2>KYC Verification Failed</h2>

    <p>Your documents could not be verified.</p>

    <div class="reason">
        Reason:
        <br><br>
        <%= request.getAttribute("reason") %>
    </div>

    <a href="kyc.jsp" class="btn">
        Upload Documents Again
    </a>

</div>

</body>
</html>