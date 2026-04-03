<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}

int users=0, products=0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM users");
    if(rs.next()) users = rs.getInt(1);

    rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM products");
    if(rs.next()) products = rs.getInt(1);

} catch(Exception e){ e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Panel</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { margin:0; background:#f5f7fa; font-family:Segoe UI; }

.sidebar {
    width:240px; height:100vh;
    background:white; position:fixed;
    padding:20px;
}

.sidebar a {
    display:block; padding:12px;
    border-radius:10px;
    text-decoration:none;
    color:#333;
    transition:0.3s;
}

.sidebar a:hover { background:#e6f0ff; }

.content { margin-left:260px; padding:30px; }

.card-box {
    padding:20px;
    border-radius:15px;
    background:white;
    box-shadow:0 5px 15px rgba(0,0,0,0.1);
    transition:0.3s;
}
.card-box:hover { transform:translateY(-5px); }
</style>
</head>

<body>

<div class="sidebar">
    <h4>RentEasy Admin</h4>
    <a href="adminDashboard.jsp">Dashboard</a>
    <a href="adminUsers.jsp">Users</a>
    <a href="adminProducts.jsp">Products</a>
    <a href="logout">Logout</a>
</div>

<div class="content">

<h2>Dashboard</h2>

<div class="row mt-4">

<div class="col-md-4">
<div class="card-box">
<h5>Total Users</h5>
<h2><%= users %></h2>
</div>
</div>

<div class="col-md-4">
<div class="card-box">
<h5>Total Products</h5>
<h2><%= products %></h2>
</div>
</div>

</div>

</div>

</body>
</html>