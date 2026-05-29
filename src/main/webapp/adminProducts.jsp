<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Products</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background:#f4f6f9;
}

.table-box{
    background:white;
    padding:20px;
    border-radius:12px;
    box-shadow:0 4px 12px rgba(0,0,0,0.1);
}

img{
    border-radius:10px;
    object-fit:cover;
}
</style>

</head>

<body>

<div class="container mt-4">

<h3 class="mb-4">Product Management</h3>

<div class="table-box">

<table class="table table-hover align-middle text-center">

<thead class="table-dark">
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Price</th>
    <th>Owner</th>
    <th>Image</th>
    <th>Status</th>
    <th>Action</th>
</tr>
</thead>

<tbody>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT * FROM products");

    while(rs.next()){
        String status = rs.getString("status");
%>

<tr>

<td><%= rs.getInt("id") %></td>

<td><%= rs.getString("name") %></td>

<td class="text-success fw-bold"><%= rs.getInt("price") %></td>

<td><%= rs.getString("owner") %></td>

<td>
    <img src="<%=request.getContextPath()%>/<%= rs.getString("image") %>" 
         width="80" height="80">
</td>

<td>
    <% if("approved".equals(status)){ %>
        <span class="badge bg-success">Approved</span>
    <% } else if("pending".equals(status)){ %>
        <span class="badge bg-warning text-dark">Pending</span>
    <% } else { %>
        <span class="badge bg-danger">Rejected</span>
    <% } %>
</td>

<td>

    <a href="approveProduct?id=<%= rs.getInt("id") %>" 
       class="btn btn-success btn-sm me-1">
       Approve
    </a>

    <a href="rejectProduct?id=<%= rs.getInt("id") %>" 
       class="btn btn-warning btn-sm me-1 text-white">
       Reject
    </a>

    <a href="deleteProduct?id=<%= rs.getInt("id") %>" 
       class="btn btn-danger btn-sm"
       onclick="return confirm('Delete this product?')">
       Delete
    </a>

</td>

</tr>

<%
    }
}catch(Exception e){
    out.println("ERROR: "+e);
}
%>

</tbody>
</table>

</div>
</div>

</body>
</html>