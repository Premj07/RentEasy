<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.renteasy.model.OwnerRental" %>

<%
List<OwnerRental> rentals =
(List<OwnerRental>)request.getAttribute("rentals");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Owner Rentals</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f5f7fa;
}

.card{
    border:none;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,.08);
    margin-bottom:25px;
}

.product-img{
    width:120px;
    height:120px;
    object-fit:cover;
    border-radius:10px;
}

.status{
    font-weight:bold;
}

</style>

</head>

<body>

<div class="container mt-4">

<h2 class="mb-4">
Owner Rental Requests
</h2>

<%
if(rentals==null || rentals.isEmpty()){
%>

<div class="alert alert-info">

No Rental Requests Found.

</div>

<%
}else{

for(OwnerRental rental : rentals){
%>

<div class="card">

<div class="card-body">

<div class="row">

<div class="col-md-2">

<img
src="<%=request.getContextPath()%>/<%=rental.getProductImage()%>"
class="product-img">

</div>

<div class="col-md-6">

<h4>

<%=rental.getProductName()%>

</h4>

<hr>

<p>

<b>Customer :</b>

<%=rental.getCustomerName()%>

</p>

<p>

<b>Email :</b>

<%=rental.getCustomerEmail()%>

</p>

<p>

<b>Phone :</b>

<%=rental.getCustomerPhone()%>

</p>

<p>

<b>Rental Period :</b>

<%=rental.getStartDate()%>

to

<%=rental.getEndDate()%>

</p>

<p>

<b>Rent Amount :</b>

₹ <%=rental.getRentAmount()%>

</p>

<p class="status">

Pickup Status :

<%=rental.getPickupStatus()%>

</p>

</div>

<div class="col-md-4">

<%
if("PICKED_UP".equalsIgnoreCase(rental.getPickupStatus())){
%>

<div class="alert alert-success">

Pickup Verified Successfully

</div>

<%

}else{

%>

<form
action="VerifyPickupOtpServlet"
method="post">

<input
type="hidden"
name="rentalId"
value="<%=rental.getRentalId()%>">

<label class="form-label">

Enter Pickup OTP

</label>

<input
type="text"
name="pickupOtp"
class="form-control"
maxlength="6"
required>

<br>

<button
class="btn btn-primary w-100">

Verify Pickup

</button>

</form>

<%

}

%>

</div>

</div>

</div>

</div>

<%

}

}

%>
<%
String success = request.getParameter("success");
String error = request.getParameter("error");

if("pickupverified".equals(success)){
%>

<div class="alert alert-success">
    ✅ Pickup OTP verified successfully.
</div>

<%
}

if("invalidotp".equals(error)){
%>

<div class="alert alert-danger">
    ❌ Invalid Pickup OTP. Please enter the correct OTP.
</div>

<%
}
%>

</div>

</body>

</html>