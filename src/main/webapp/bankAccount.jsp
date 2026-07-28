<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
response.sendRedirect("index.jsp");
return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Bank Account Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:#eef2f7;
}

.box{
width:650px;
margin:50px auto;
background:white;
padding:40px;
border-radius:15px;
box-shadow:0 5px 20px rgba(0,0,0,.15);
}

</style>

</head>

<body>

<div class="box">

<h2 class="text-center mb-4">
Bank Account Details
</h2>

<form action="SaveBankDetailsServlet" method="post">

<input type="hidden"
name="method"
value="BANK">

<div class="mb-3">

<label>Account Holder Name</label>

<input
type="text"
name="account_holder"
class="form-control"
required>

</div>

<div class="mb-3">

<label>Bank Name</label>

<input
type="text"
name="bank_name"
class="form-control"
required>

</div>

<div class="mb-3">

<label>Account Number</label>

<input
type="text"
name="account_number"
class="form-control"
required>

</div>

<div class="mb-3">

<label>IFSC Code</label>

<input
type="text"
name="ifsc"
class="form-control"
required>

</div>

<button
class="btn btn-success">

Save

</button>

<a
href="bankDetails.jsp"
class="btn btn-secondary">

Back

</a>

</form>

</div>

</body>
</html>