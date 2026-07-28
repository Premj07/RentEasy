Rental ID = <%= session.getAttribute("rentalId") %>
<%
Integer rentalId =
(Integer)session.getAttribute("rentalId");

out.println("Rental ID = " + rentalId);
%>
<!DOCTYPE html>
<html>
<head>
<title>Payment Successful</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background:#f4f6f9;
}

.box{
    width:600px;
    margin:100px auto;
    background:white;
    padding:40px;
    border-radius:15px;
    text-align:center;
    box-shadow:0 5px 20px rgba(0,0,0,0.1);
}
</style>

</head>

<body>

<div class="box">

<h2 class="text-success">
Payment Successful ✅
</h2>

<p>
Your rental has been created successfully.
</p>

<br>

<a href="generateAgreement.jsp?rentalId=<%=rentalId%>"
class="btn btn-primary">

Download Rental Agreement

</a>

<a href="myRentals.jsp"
class="btn btn-success">

My Rentals

</a>

<a href="dashboard.jsp"
class="btn btn-secondary">

Dashboard

</a>

</div>

</body>
</html>