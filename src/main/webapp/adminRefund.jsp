<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>

<title>Deposit Refund Management - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
    background:#f4f7fb;
}

.page-title{
    font-weight:700;
}

.refund-card{
    background:white;
    border-radius:16px;
    padding:25px;
    margin-bottom:25px;
    box-shadow:0 5px 20px rgba(0,0,0,0.07);
}

.deposit{
    font-size:22px;
    font-weight:700;
    color:#2563eb;
}

.status{
    display:inline-block;
    padding:6px 12px;
    border-radius:20px;
    background:#fff3cd;
    color:#856404;
    font-weight:600;
}

.bank-box{
    background:#f8fafc;
    padding:15px;
    border-radius:10px;
    margin-top:10px;
}

</style>

</head>

<body>

<div class="container mt-5 mb-5">

<h2 class="page-title">

<i class="bi bi-wallet2"></i>
Deposit Refund Management

</h2>

<p class="text-muted mb-4">

Review owner inspections and process security deposit refunds.

</p>


<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
);

PreparedStatement ps = con.prepareStatement(

    "SELECT " +

    "dr.refund_id, " +
    "dr.rental_id, " +
    "dr.original_deposit, " +
    "dr.deduction_amount, " +
    "dr.refund_amount, " +
    "dr.refund_status, " +
    "dr.inspection_status, " +

"CONCAT(u.first_name, ' ', u.last_name) AS user_name, " +
    "p.name AS product_name, " +

    "b.method, " +
    "b.account_holder, " +
    "b.bank_name, " +
    "b.account_number, " +
    "b.ifsc_code, " +
    "b.upi_id " +

    "FROM deposit_refunds dr " +

    "JOIN rentals r ON dr.rental_id = r.rental_id " +

    "JOIN users u ON dr.user_id = u.id " +

    "JOIN products p ON r.product_id = p.id " +

    "LEFT JOIN bank_details b ON dr.user_id = b.user_id " +

    "WHERE dr.refund_status='RETURN_VERIFIED' " +

    "ORDER BY dr.requested_at DESC"

);

ResultSet rs = ps.executeQuery();

boolean found = false;

while(rs.next()){

found = true;

%>


<div class="refund-card">

<div class="row">

<!-- LEFT SIDE -->

<div class="col-md-7">

<h4>

<i class="bi bi-box-seam"></i>

<%=rs.getString("product_name")%>

</h4>

<hr>

<p>

<strong>Rental ID:</strong>

#<%=rs.getInt("rental_id")%>

</p>


<p>

<strong>User:</strong>

<%=rs.getString("user_name")%>

</p>


<p>

<strong>Security Deposit:</strong>

<span class="deposit">

₹<%=rs.getBigDecimal("original_deposit")%>

</span>

</p>


<p>

<strong>Return Status:</strong>

<span class="status">

Return Verified

</span>

</p>


<p>

<strong>Inspection:</strong>

<%=rs.getString("inspection_status")%>

</p>

</div>


<!-- RIGHT SIDE -->

<div class="col-md-5">

<h5>

<i class="bi bi-bank"></i>

Refund Account

</h5>


<div class="bank-box">

<%

String method = rs.getString("method");

if(method == null){

%>

<div class="alert alert-danger mb-0">

<i class="bi bi-exclamation-triangle"></i>

User has not added refund bank details.

</div>

<%

}
else if("BANK".equalsIgnoreCase(method)){

String account = rs.getString("account_number");

String masked = account;

if(account != null && account.length() > 4){

    masked =
    "••••••" +
    account.substring(account.length()-4);

}

%>

<p>

<strong>
<%=rs.getString("account_holder")%>
</strong>

</p>

<p>

Bank:
<%=rs.getString("bank_name")%>

</p>

<p>

Account:
<%=masked%>

</p>

<p>

IFSC:
<%=rs.getString("ifsc_code")%>

</p>

<%

}
else{

%>

<p>

<strong>UPI</strong>

</p>

<p>

<%=rs.getString("upi_id")%>

</p>

<%

}

%>

</div>

</div>

</div>


<hr>




</div>


<%

}

if(!found){

%>


<div class="refund-card text-center">

<i class="bi bi-check-circle"
style="font-size:55px;color:#16a34a;"></i>

<h4 class="mt-3">

No Returns Waiting for Owner Inspection

</h4>

<p class="text-muted">

Returns waiting for owner inspection will appear here.

</p>

</div>


<%

}


%>

<%
rs.close();
ps.close();
%>
<!-- ==========================================
     OWNER DAMAGE CLAIM REVIEW
=========================================== -->

<hr style="margin-top:50px;margin-bottom:35px;">

<h2 class="page-title">

<i class="bi bi-exclamation-triangle"></i>
Damage Claims Awaiting Review

</h2>

<p class="text-muted mb-4">

Review damage reported by product owners before approving
any security deposit deduction.

</p>


<%

PreparedStatement damagePs = con.prepareStatement(

    "SELECT " +

    "dr.refund_id, " +
    "dr.rental_id, " +
    "dr.original_deposit, " +
    "dr.deduction_amount, " +
    "dr.deduction_reason, " +
    "dr.damage_evidence, " +
    "dr.refund_status, " +

    "CONCAT(u.first_name, ' ', u.last_name) AS user_name, " +

    "p.name AS product_name " +

    "FROM deposit_refunds dr " +

    "JOIN rentals r ON dr.rental_id=r.rental_id " +

    "JOIN users u ON dr.user_id=u.id " +

    "JOIN products p ON r.product_id=p.id " +

    "WHERE dr.refund_status='DAMAGE_REVIEW' " +

    "ORDER BY dr.requested_at DESC"
);


ResultSet damageRs =
        damagePs.executeQuery();


boolean damageFound = false;


while(damageRs.next()) {

    damageFound = true;

%>


<div class="refund-card">

<div class="row">


<!-- LEFT SIDE -->

<div class="col-md-7">

<h4>

<i class="bi bi-box-seam"></i>

<%=damageRs.getString("product_name")%>

</h4>


<p>

<strong>Rental ID:</strong>

#<%=damageRs.getInt("rental_id")%>

</p>


<p>

<strong>Customer:</strong>

<%=damageRs.getString("user_name")%>

</p>


<hr>


<p>

<strong>Original Security Deposit:</strong>

<span class="deposit">

₹<%=damageRs.getBigDecimal("original_deposit")%>

</span>

</p>


<p>

<strong>Owner Requested Deduction:</strong>

<span style="
color:#dc2626;
font-weight:700;
font-size:20px;
">

₹<%=damageRs.getBigDecimal("deduction_amount")%>

</span>

</p>


<p>

<strong>Damage Reason:</strong>

<br>

<%=damageRs.getString("deduction_reason")%>

</p>


</div>



<!-- DAMAGE EVIDENCE -->

<div class="col-md-5">

<h5>

<i class="bi bi-image"></i>
Damage Evidence

</h5>


<%

String damageImage =
        damageRs.getString("damage_evidence");


if(damageImage != null &&
   !damageImage.trim().isEmpty()) {

%>


<img
src="<%=request.getContextPath()%>/<%=damageImage%>"
style="
width:100%;
max-height:250px;
object-fit:contain;
border-radius:12px;
border:1px solid #e2e8f0;
background:#f8fafc;
padding:5px;
">


<a
href="<%=request.getContextPath()%>/<%=damageImage%>"
target="_blank"
class="btn btn-outline-primary w-100 mt-2">

<i class="bi bi-eye"></i>
View Full Evidence

</a>


<%

}
else {

%>


<div class="alert alert-warning">

No damage evidence uploaded.

</div>


<%

}

%>

</div>

</div>


<hr>


<h5>

<i class="bi bi-shield-check"></i>
Admin Decision

</h5>


<p class="text-muted">

Review the owner's claim and determine the final deduction.

</p>



<form action="AdminDamageReviewServlet"
      method="post">


<input
type="hidden"
name="refundId"
value="<%=damageRs.getInt("refund_id")%>">


<input
type="hidden"
name="rentalId"
value="<%=damageRs.getInt("rental_id")%>">


<input
type="hidden"
name="originalDeposit"
value="<%=damageRs.getBigDecimal("original_deposit")%>">



<div class="row">


<div class="col-md-6">

<label class="form-label">

Final Deduction Amount ₹

</label>


<input
type="number"
name="finalDeduction"
class="form-control"
min="0"
max="<%=damageRs.getBigDecimal("original_deposit")%>"
step="0.01"
value="<%=damageRs.getBigDecimal("deduction_amount")%>"
required>

<small class="text-muted">

You can reduce or change the owner's requested amount.

</small>

</div>



<div class="col-md-6">

<label class="form-label">

Admin Note

</label>


<textarea
name="adminNote"
class="form-control"
rows="2"
placeholder="Explain the final deduction decision"></textarea>

</div>

</div>



<div class="mt-4 d-flex gap-2">


<button
type="submit"
name="action"
value="APPROVE"
class="btn btn-danger">

<i class="bi bi-check-circle"></i>

Approve Deduction

</button>



<button
type="submit"
name="action"
value="REJECT"
class="btn btn-success">

<i class="bi bi-x-circle"></i>

Reject Damage Claim

</button>


</div>


</form>


</div>


<%

}


if(!damageFound) {

%>


<div class="refund-card text-center">

<i
class="bi bi-shield-check"
style="
font-size:55px;
color:#16a34a;
"></i>


<h4 class="mt-3">

No Damage Claims Awaiting Review

</h4>


<p class="text-muted">

Owner-reported product damage will appear here for admin review.

</p>

</div>


<%

}


damageRs.close();
damagePs.close();

%>

<!-- ==========================================
  READY FOR REFUND SECTION
=========================================== -->

<hr style="margin-top:50px;margin-bottom:35px;">

<h2 class="page-title">

<i class="bi bi-credit-card"></i>
Ready for Payment

</h2>

<p class="text-muted mb-4">

Approved security deposit refunds waiting for payment.

</p>


<%

PreparedStatement readyPs = con.prepareStatement(

 "SELECT " +

 "dr.refund_id, " +
 "dr.rental_id, " +
 "dr.original_deposit, " +
 "dr.deduction_amount, " +
 "dr.deduction_reason, " +
 "dr.refund_amount, " +
 "dr.inspection_status, " +

"CONCAT(u.first_name, ' ', u.last_name) AS user_name, " +

 "p.name AS product_name, " +

 "b.method, " +
 "b.account_holder, " +
 "b.bank_name, " +
 "b.account_number, " +
 "b.ifsc_code, " +
 "b.upi_id " +

 "FROM deposit_refunds dr " +

 "JOIN rentals r ON dr.rental_id=r.rental_id " +

 "JOIN users u ON dr.user_id=u.id " +

 "JOIN products p ON r.product_id=p.id " +

 "LEFT JOIN bank_details b ON dr.user_id=b.user_id " +

 "WHERE dr.refund_status='READY_FOR_REFUND' " +

 "ORDER BY dr.approved_at DESC"

);

ResultSet readyRs = readyPs.executeQuery();

boolean readyFound = false;

while(readyRs.next()){

 readyFound = true;

 String readyAccount =
         readyRs.getString("account_number");

 String readyMasked = readyAccount;

 if(readyAccount != null &&
    readyAccount.length() > 4){

     readyMasked =
         "••••••" +
         readyAccount.substring(
             readyAccount.length()-4
         );
 }

%>


<div class="refund-card">

<div class="row">

<!-- REFUND INFORMATION -->

<div class="col-md-7">

<h4>

<i class="bi bi-box-seam"></i>

<%=readyRs.getString("product_name")%>

</h4>

<p>

<strong>Rental ID:</strong>

#<%=readyRs.getInt("rental_id")%>

</p>

<p>

<strong>User:</strong>

<%=readyRs.getString("user_name")%>

</p>

<hr>


<p>

Original Security Deposit:

<strong>

₹<%=readyRs.getBigDecimal("original_deposit")%>

</strong>

</p>


<p>

Deduction:

<strong style="color:#dc2626;">

- ₹<%=readyRs.getBigDecimal("deduction_amount")%>

</strong>

</p>


<%

String reason =
 readyRs.getString("deduction_reason");

if(reason != null &&
!reason.trim().isEmpty()){

%>

<p>

<strong>Deduction Reason:</strong>

<%=reason%>

</p>

<%

}

%>


<div style="
background:#ecfdf5;
padding:15px;
border-radius:10px;
margin-top:15px;
">

Final Refund Amount

<h3 style="
color:#16a34a;
margin-top:5px;
">

₹<%=readyRs.getBigDecimal("refund_amount")%>

</h3>

</div>

</div>


<!-- BANK DETAILS -->

<div class="col-md-5">

<h5>

<i class="bi bi-bank"></i>
Refund Account

</h5>

<div class="bank-box">

<%

String readyMethod =
     readyRs.getString("method");

if(readyMethod == null){

%>

<div class="alert alert-danger">

User has not added refund details.

</div>

<%

}
else if("BANK".equalsIgnoreCase(readyMethod)){

%>

<p>

<strong>

<%=readyRs.getString("account_holder")%>

</strong>

</p>

<p>

<%=readyRs.getString("bank_name")%>

</p>

<p>

Account:

<strong>
<%=readyMasked%>
</strong>

</p>

<p>

IFSC:

<strong>

<%=readyRs.getString("ifsc_code")%>

</strong>

</p>

<%

}
else{

%>

<p>

<strong>UPI ID</strong>

</p>

<p>

<%=readyRs.getString("upi_id")%>

</p>

<%

}

%>

</div>


<!-- PAYMENT CONFIRMATION -->

<%

if(readyMethod != null){

%>

<form action="CompleteRefundServlet"
   method="post"
   class="mt-3">

<input type="hidden"
    name="refundId"
    value="<%=readyRs.getInt("refund_id")%>">

<input type="hidden"
    name="rentalId"
    value="<%=readyRs.getInt("rental_id")%>">


<label class="form-label">

Transaction / UTR ID

</label>

<input type="text"
    name="transactionId"
    class="form-control"
    placeholder="Enter bank transaction ID"
    required>


<button type="submit"
     class="btn btn-success w-100 mt-3">

<i class="bi bi-check-circle"></i>

Mark Refund as Paid

</button>

</form>

<%

}

%>

</div>

</div>

</div>


<%

}

if(!readyFound){

%>

<div class="refund-card text-center">

<i class="bi bi-wallet2"
style="
font-size:50px;
color:#94a3b8;
"></i>

<h4 class="mt-3">

No Refunds Ready for Payment

</h4>

<p class="text-muted">

Approved refunds will appear here.

</p>

</div>

<%

}

readyRs.close();
readyPs.close();


//FINALLY CLOSE DATABASE CONNECTION

con.close();

%>


</div>

</body>

</html>