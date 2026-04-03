<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Products</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>

<div class="container mt-4">

<h2>All Products</h2>

<table class="table table-bordered">
<tr>
<th>Name</th>
<th>Price</th>
<th>Owner</th>
<th>Image</th>
</tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    PreparedStatement ps = con.prepareStatement("SELECT * FROM products");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>
<td><%= rs.getString("name") %></td>
<td><%= rs.getInt("price") %></td>
<td><%= rs.getString("owner") %></td>
<td>
<img src="<%= rs.getString("image") %>" width="80">
</td>
</tr>

<%
    }
} catch(Exception e){
    e.printStackTrace();
}
%>

</table>

</div>

</body>
</html>