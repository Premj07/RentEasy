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
<title>Owner Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f5f7fa; }

/* SIDEBAR */
.sidebar {
    height:100vh;
    background:#2c3e50;
    color:white;
    padding:20px;
}

.sidebar a {
    display:block;
    color:white;
    padding:10px;
    text-decoration:none;
    margin-bottom:10px;
}

.sidebar a:hover {
    background:#36cfc9;
}

/* TOPBAR */
.topbar {
    background:white;
    padding:15px;
    border-radius:10px;
}

/* CARD */
.card {
    border-radius:12px;
    padding:15px;
}
</style>

</head>

<body>

<div class="container-fluid">
<div class="row">

<!-- SIDEBAR -->
<div class="col-md-2 sidebar">
    <h4>RentEasy Owner</h4>

    <a href="#">Dashboard</a>
    <a href="#">My Products</a>
    <a href="addProduct.jsp">Add Product</a>
    <a href="#">Bookings</a>
    <a href="#">Earnings</a>
</div>

<!-- MAIN -->
<div class="col-md-10 p-4">

    <!-- TOPBAR -->
    <div class="topbar d-flex justify-content-between">

        <h5>Welcome, <%= username %> 👋</h5>

        <div>
            <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm">User Mode</a>
            <a href="logout" class="btn btn-danger btn-sm">Logout</a>
        </div>
    </div>

    <!-- ADD BUTTON -->
    <div class="d-flex justify-content-between mt-4 mb-3">
        <h4>Your Products</h4>
        <a href="addProduct.jsp" class="btn btn-success">+ Add Product</a>
    </div>

    <!-- PRODUCTS -->
    <div class="row">

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM products WHERE owner=?");

    ps.setString(1, username);

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

    <div class="col-md-4 mb-4">
        <div class="card">

            <img src="<%=request.getContextPath()%>/<%= rs.getString("image") %>" 
                 style="height:200px; object-fit:cover; border-radius:10px;">

            <h5 class="mt-2"><%= rs.getString("name") %></h5>
            <p>₹<%= rs.getInt("price") %>/day</p>

            <div class="d-flex justify-content-between">
                <a href="#" class="btn btn-primary btn-sm">Edit</a>
                <a href="DeleteProductServlet?id=<%= rs.getInt("id") %>" 
                   class="btn btn-danger btn-sm">Delete</a>
            </div>

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
</div>
</div>

</body>
</html>