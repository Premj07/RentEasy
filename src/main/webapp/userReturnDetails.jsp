<%@ page import="java.sql.*" %>

<%
int rentalId = Integer.parseInt(request.getParameter("rentalId"));
%>

<!DOCTYPE html>

<html>
<head>
<title>Rental Information</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background:#f5f7fb;
}
.card-box{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
}
.section-title{
    color:#0d6efd;
    margin-top:20px;
}
</style>

</head>

<body>

<div class="container mt-5">
<div class="card-box">

<h2 class="mb-4">Rental Information</h2>

<%
try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

String sql =
"SELECT r.*, " +
"CONCAT(u.first_name, ' ', u.last_name) AS renter, " +
"CONCAT(o.first_name, ' ', o.last_name) AS owner_name, " +
"p.name AS product_name, " +
"ku.address AS user_address, " +
"ko.address AS owner_address, " +
"ku.mobile AS user_mobile, " +
"ko.mobile AS owner_mobile " +
"FROM rentals r " +
"JOIN users u ON r.user_id=u.id " +
"JOIN users o ON r.owner_id=o.id " +
"JOIN products p ON r.product_id=p.id " +
"LEFT JOIN kyc ku ON ku.email=u.email " +
"LEFT JOIN kyc ko ON ko.email=o.email " +
"WHERE r.rental_id=?";

PreparedStatement ps = con.prepareStatement(sql);
ps.setInt(1,rentalId);

ResultSet rs = ps.executeQuery();

if(rs.next()){
%>

<h4 class="section-title">User Details</h4>

<p><b>Name:</b> <%=rs.getString("renter")%></p>

<p><b>KYC Address:</b>
<%=rs.getString("user_address")%>
</p>

<p><b>mobile:</b>
<%=rs.getString("user_mobile")%>
</p>

<hr>

<h4 class="section-title">Product Details</h4>

<p><b>Product:</b>
<%=rs.getString("product_name")%>
</p>

<p><b>Rent Amount:</b>
₹<%=rs.getDouble("rent_amount")%>
</p>

<p><b>Security Deposit:</b>
₹<%=rs.getDouble("security_deposit")%>
</p>

<p><b>Payment Status:</b>
<%=rs.getString("payment_status")%>
</p>

<p><b>Rental Status:</b>
<%=rs.getString("rental_status")%>
</p>

<p><b>Start Date:</b>
<%=rs.getDate("start_date")%>
</p>

<p><b>End Date:</b>
<%=rs.getDate("end_date")%>
</p>

<hr>

<h4 class="section-title">Owner Details</h4>

<p><b>Name:</b>
<%=rs.getString("owner_name")%>
</p>

<p><b>KYC Address:</b>
<%=rs.getString("owner_address")%>
</p>

<p><b>mobile:</b>
<%=rs.getString("owner_mobile")%>
</p>

<hr>

<h4 class="text-warning">
Return Request
</h4>

<p>
Click below to send a return request to the admin.
</p>

<a href="sendReturnRequest.jsp?rentalId=<%=rentalId%>"
class="btn btn-warning">
Send Return Request
</a>
<%
}

con.close();

}catch(Exception e){
%>

<div class="alert alert-danger">
<%=e.getMessage()%>
</div>

<%
}
%>

</div>
</div>

</body>
</html>
