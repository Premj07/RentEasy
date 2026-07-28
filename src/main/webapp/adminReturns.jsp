<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Active Rental Users</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f4f7fc;
}

.page-title{
    font-size:32px;
    font-weight:700;
    color:#1e293b;
}

.card-box{
    background:white;
    border-radius:15px;
    padding:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
    margin-bottom:20px;
}

.table-container{
    background:white;
    border-radius:15px;
    padding:20px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
}

.user-badge{
    background:#dbeafe;
    color:#1d4ed8;
    padding:6px 12px;
    border-radius:20px;
    font-weight:600;
}

.active-badge{
    background:#dcfce7;
    color:#15803d;
    padding:6px 12px;
    border-radius:20px;
    font-weight:600;
}

.btn-view{
    background:#2563eb;
    color:white;
    border:none;
    border-radius:8px;
}

.btn-view:hover{
    background:#1e40af;
    color:white;
}

</style>

</head>
<body>

<div class="container mt-5">

<h2 class="page-title mb-4">
Active Rental Users
</h2>

<%
int totalUsers=0;
int totalProducts=0;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

/* Dashboard Counts */

Statement st=con.createStatement();

ResultSet countRs=st.executeQuery(
"SELECT COUNT(DISTINCT user_id) totalUsers FROM rentals");

if(countRs.next()){
    totalUsers=countRs.getInt("totalUsers");
}

countRs=st.executeQuery(
"SELECT COUNT(*) totalProducts FROM rentals");

if(countRs.next()){
    totalProducts=countRs.getInt("totalProducts");
}
%>

<div class="row mb-4">

<div class="col-md-6">
<div class="card-box text-center">
<h5>Total Active Users</h5>
<h2><%=totalUsers%></h2>
</div>
</div>

<div class="col-md-6">
<div class="card-box text-center">
<h5>Total Rented Products</h5>
<h2><%=totalProducts%></h2>
</div>
</div>

</div>

<div class="table-container">

<table class="table table-hover align-middle">

<thead class="table-dark">

<tr>
<th>User Name</th>
<th>Email</th>
<th>Phone</th>
<th>Total Rentals</th>
<th>Status</th>
<th>Action</th>
</tr>

</thead>

<tbody>

<%

String sql=
"SELECT u.id,u.name,u.email,u.phone,COUNT(r.rental_id) totalRentals "+
"FROM rentals r "+
"JOIN users u ON r.user_id=u.id "+
"GROUP BY u.id,u.name,u.email,u.phone";

PreparedStatement ps=con.prepareStatement(sql);

ResultSet rs=ps.executeQuery();

boolean dataFound=false;

while(rs.next()){

dataFound=true;

%>

<tr>

<td>
<strong><%=rs.getString("name")%></strong>
</td>

<td>
<%=rs.getString("email")%>
</td>

<td>
<%=rs.getString("phone")%>
</td>

<td>
<span class="user-badge">
<%=rs.getInt("totalRentals")%>
</span>
</td>

<td>
<span class="active-badge">
Active
</span>
</td>

<td>

<a href="userRentalDetails.jsp?userId=<%=rs.getInt("id")%>"
class="btn btn-view">

View Details

</a>

</td>

</tr>

<%
}

if(!dataFound){
%>

<tr>
<td colspan="6" class="text-center text-muted">
No Active Rental Users Found
</td>
</tr>

<%
}

con.close();
%>

</tbody>
</table>

</div>

<%
}catch(Exception e){
%>

<div class="alert alert-danger">
<%=e.getMessage()%>
</div>

<%
}
%>

</div>

</body>
</html>