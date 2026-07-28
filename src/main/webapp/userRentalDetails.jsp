<%@ page import="java.sql.*" %>

<%
int userId = Integer.parseInt(request.getParameter("userId"));
%>

<!DOCTYPE html>
<html>
<head>
<title>User Rental Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f5f7fb;
}

.card-box{
    background:white;
    padding:20px;
    border-radius:12px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
}

</style>

</head>

<body>

<div class="container mt-5">

<div class="card-box">

<h2 class="mb-4">User Rental Details</h2>

<table class="table table-bordered table-hover">

<thead class="table-dark">

<tr>
    <th>Rental ID</th>
    <th>Product</th>
    <th>Owner</th>
    <th>Status</th>
    <th>Action</th>
</tr>

</thead>

<tbody>

<%
Connection con = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/renteasy",
    "root",
    "123456");

    String sql =
    "SELECT r.rental_id, p.name AS product_name, " +
    "o.name AS owner_name, r.rental_status " +
    "FROM rentals r " +
    "JOIN products p ON r.product_id = p.id " +
    "JOIN users o ON r.owner_id = o.id " +
    "WHERE r.user_id=?";

    PreparedStatement ps =
    con.prepareStatement(sql);

    ps.setInt(1,userId);

    ResultSet rs =
    ps.executeQuery();

    while(rs.next()){
%>

<tr>

<td>
<%=rs.getInt("rental_id")%>
</td>

<td>
<%=rs.getString("product_name")%>
</td>

<td>
<%=rs.getString("owner_name")%>
</td>

<td>
<span class="badge bg-success">
<%=rs.getString("rental_status")%>
</span>
</td>

<td>

<a href="rentalView.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn btn-primary btn-sm">

View Full

</a>

</td>

</tr>

<%
    }

}catch(Exception e){
%>

<tr>
<td colspan="5" class="text-danger">
<%=e.getMessage()%>
</td>
</tr>

<%
}
%>

</tbody>

</table>

</div>

</div>

</body>
</html>