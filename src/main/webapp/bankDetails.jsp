<!DOCTYPE html>
<html>
<head>

<title>Select Refund Method</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:#eef2f7;
}

.box{
width:500px;
margin:80px auto;
background:white;
padding:40px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.15);
}

</style>

</head>

<body>

<div class="box">

<h2 class="text-center mb-4">
Select Refund Method
</h2>

<form>

<div class="form-check mb-3">

<input
class="form-check-input"
type="radio"
name="method"
value="bank">

<label class="form-check-label">

Bank Account

</label>

</div>

<div class="form-check mb-3">

<input
class="form-check-input"
type="radio"
name="method"
value="upi">

<label class="form-check-label">

UPI

</label>

</div>

<div class="form-check mb-4">

<input
class="form-check-input"
type="radio"
name="method"
value="card">

<label class="form-check-label">

Debit / Credit Card

</label>

</div>

<button
type="button"
class="btn btn-success w-100"
onclick="goNext()">

Continue

</button>

</form>

</div>

<script>

function goNext(){

let method=document.querySelector(
'input[name="method"]:checked');

if(method==null){

alert("Select refund method");

return;

}

if(method.value=="bank")
location="bankAccount.jsp";

if(method.value=="upi")
location="upiDetails.jsp";

if(method.value=="card")
location="cardDetails.jsp";

}

</script>

</body>
</html>