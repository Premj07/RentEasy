
<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
%><%@ page import="java.sql.*" %>
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
<title>Users</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>

<div class="container mt-4">

<h2>All Users</h2>

<table class="table table-bordered">
<tr>
<th>ID</th>
<th>Username</th>
<th>Email</th>
<th>Action</th>
</tr>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    PreparedStatement ps = con.prepareStatement("SELECT * FROM users");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>
<td><%= rs.getInt("id") %></td>
<td><%= rs.getString("username") %></td>
<td><%= rs.getString("email") %></td>
<td>
<button class="btn btn-danger btn-sm">Delete</button>
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