<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("username") == null){
    response.sendRedirect("login.jsp");
    return;
}
String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Owner Dashboard - RentEasy</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f5f7fa;
        }

        /* SIDEBAR */
        .sidebar {
            height: 100vh;
            background: #2c3e50;
            color: white;
            padding: 20px;
        }

        .sidebar h4 {
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            color: white;
            padding: 10px;
            text-decoration: none;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .sidebar a:hover {
            background: #36cfc9;
        }

        /* TOPBAR */
        .topbar {
            background: white;
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 20px;
        }

        /* CARDS */
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            transition: 0.3s;
        }

        .stat-card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        /* PRODUCT CARD */
        .card {
            border-radius: 15px;
            transition: 0.3s;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .btn-add {
            background: linear-gradient(45deg, #36cfc9, #5cdbd3);
            color: white;
            border: none;
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
            <div class="topbar d-flex justify-content-between align-items-center">
                <h5>Welcome, <%= username %> 👋</h5>

                <div>
                    <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm">User Mode</a>
                    <a href="logout.jsp" class="btn btn-danger btn-sm">Logout</a>
                </div>
            </div>

            <!-- STATS -->
            <div class="row mb-4">

                <div class="col-md-4">
                    <div class="stat-card">
                        <h6>Total Products</h6>
                        <h2>
                        <%
                        int total = 0;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

                            PreparedStatement ps = con.prepareStatement(
                                "SELECT COUNT(*) FROM products WHERE owner=?");

                            ps.setString(1, username);
                            ResultSet rs = ps.executeQuery();

                            if(rs.next()){
                                total = rs.getInt(1);
                            }

                            con.close();
                        } catch(Exception e){ out.println(e); }
                        %>
                        <%= total %>
                        </h2>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <h6>Active Rentals</h6>
                        <h2>8</h2> <!-- static for now -->
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <h6>Earnings</h6>
                        <h2>₹48,750</h2> <!-- static -->
                    </div>
                </div>

            </div>

            <!-- ADD BUTTON -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Your Products</h4>
                <a href="addProduct.jsp" class="btn btn-add">+ Add Product</a>
            </div>

            <!-- PRODUCTS -->
            <div class="row">

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM products WHERE owner=?");

    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    while(rs.next()) {
%>

                <div class="col-md-4">
                    <div class="card p-3 mb-4">
                        <img src="<%= rs.getString("image") %>" class="card-img-top">
                        <h5><%= rs.getString("name") %></h5>
                        <p>₹<%= rs.getInt("price") %>/day</p>

                        <div class="d-flex justify-content-between">
                            <button class="btn btn-outline-primary btn-sm">Edit</button>
                            <button class="btn btn-outline-danger btn-sm">Delete</button>
                        </div>
                    </div>
                </div>

<%
    }
    con.close();
} catch(Exception e) {
    out.println("Error: " + e);
}
%>

            </div>

        </div>

    </div>
</div>

</body>
</html>