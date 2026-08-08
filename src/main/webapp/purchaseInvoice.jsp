<%@ page import="java.sql.*" %>

<%
String purchaseId = request.getParameter("purchaseId");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con =
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps =
con.prepareStatement(

"SELECT po.*,p.name,p.image,p.owner,p.selling_price,p.actual_price," +
"u.full_name,u.username " +
"FROM purchase_orders po " +
"JOIN products p ON po.product_id=p.id " +
"JOIN users u ON po.buyer_id=u.id " +
"WHERE po.purchase_id=?");

ps.setInt(1,Integer.parseInt(purchaseId));

ResultSet rs=ps.executeQuery();
%>

<!DOCTYPE html>
<html>

<head>

<title>Purchase Invoice</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
background:#f5f5f5;
font-family:Segoe UI;
}

.invoice{

max-width:900px;
margin:40px auto;
background:white;
padding:40px;
border-radius:15px;
box-shadow:0 0 20px rgba(0,0,0,.15);

}

.logo{

font-size:34px;
font-weight:bold;
color:#0d6efd;

}

table td{

padding:8px;

}

</style>

</head>

<body>

<div class="invoice">

<%
if(rs.next()){
%>

<div class="row">

<div class="col-md-6">

<div class="logo">
RentEasy
</div>

<h5>Purchase Invoice</h5>

</div>

<div class="col-md-6 text-end">

<b>Invoice No :</b>
INV-<%=rs.getInt("purchase_id")%>

<br>

<b>Date :</b>

<%=rs.getString("purchase_date")%>

</div>

</div>

<hr>

<div class="row">

<div class="col-md-6">

<h5>Buyer Details</h5>

<b>Name :</b>
<%=rs.getString("full_name")%>

<br>

<b>Username :</b>
<%=rs.getString("username")%>

</div>

<div class="col-md-6">

<h5>Seller Details</h5>

<b>Owner :</b>
<%=rs.getString("owner")%>

</div>

</div>

<hr>

<div class="row">

<div class="col-md-4">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="img-fluid rounded">

</div>

<div class="col-md-8">

<h3>
<%=rs.getString("name")%>
</h3>

<table class="table">

<tr>

<td>Actual Price</td>

<td>

₹ <%=rs.getDouble("actual_price")%>

</td>

</tr>

<tr>

<td>Selling Price</td>

<td>

₹ <%=rs.getDouble("selling_price")%>

</td>

</tr>

<tr>

<td>Purchase Type</td>

<td>

Permanent Purchase

</td>

</tr>

<tr>

<td>Status</td>

<td>

Purchased Successfully

</td>

</tr>

</table>

</div>

</div>

<hr>

<h4 class="text-end">

Total Paid :

₹ <%=rs.getDouble("selling_price")%>

</h4>

<div class="text-center mt-5">

<h5>

Thank you for shopping with RentEasy ❤️

</h5>

<p>

This invoice is computer generated and does not require a signature.

</p>

</div>

<button
onclick="window.print()"
class="btn btn-success">

Print Invoice

</button>

<a
href="myRentals.jsp"
class="btn btn-primary">

Back

</a>

<%
}
rs.close();
ps.close();
con.close();
%>

</div>

</body>

</html>