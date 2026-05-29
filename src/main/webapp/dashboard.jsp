<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}
String username = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f4f6f9; }

.navbar { background:#2c3e50; }
.navbar-brand { color:white !important; font-weight:bold; }

.hero {
    background: linear-gradient(45deg,#36cfc9,#5cdbd3);
    color:white;
    padding:30px;
    border-radius:15px;
}

.product-card {
    background:white;
    border-radius:12px;
    padding:15px;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);
}

.product-img {
    width:100%;
    height:200px;
    object-fit:cover;
    border-radius:10px;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar px-3">
    <a class="navbar-brand">RentEasy</a>

    <div class="ms-auto d-flex align-items-center">

        <!-- SWITCH BUTTON -->
        <a href="ownerDashboard.jsp" class="btn btn-outline-light btn-sm me-2">
            Switch to Owner
        </a>

        <span class="text-white me-3"> <%= username %></span>

        <a href="profile.jsp" class="btn btn-light btn-sm me-2">Profile</a>
        <a href="logout" class="btn btn-danger btn-sm">Logout</a>
    </div>
</nav>

<div class="container mt-4">

    <!-- HERO -->
    <div class="hero mb-4">
        <h3>Welcome, <%= username %> </h3>
        <p>Rent anything, anytime with RentEasy</p>
    </div>

    <!-- IMAGE -->
    <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7"
         style="width:100%; height:300px; object-fit:cover; border-radius:12px;">

    <!-- PRODUCTS -->
    <h4 class="mt-4">Available Products</h4>

    <div class="row">

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT * FROM products WHERE status='approved'");

    while(rs.next()){
%>

    <div class="col-md-4 mb-4">
        <div class="product-card">

            <img src="<%=request.getContextPath()%>/<%= rs.getString("image") %>" class="product-img">

            <h5 class="mt-2"><%= rs.getString("name") %></h5>
            <p><%= rs.getInt("price") %>/day</p>

            <a href="rentProduct.jsp?id=<%= rs.getInt("id") %>" 
               class="btn btn-primary w-100">Rent Now</a>

        </div>
    </div>

<%
    }
}catch(Exception e){
    out.println(e);
}
%>

    </div>

</div>

</body>
</html>