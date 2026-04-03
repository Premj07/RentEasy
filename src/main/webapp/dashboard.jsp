<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("username") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - RentEasy</title>
    <meta charset="UTF-8">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f5f7fa;
        }

        .navbar {
            background: #2c3e50;
        }

        .navbar-brand {
            color: #fff !important;
            font-weight: bold;
        }

        .hero {
            background: linear-gradient(45deg, #36cfc9, #5cdbd3);
            color: white;
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .category-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            transition: 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: black;
        }

        .category-card img {
            width: 60px;
            margin-bottom: 10px;
        }

        .category-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .card {
            border-radius: 15px;
            transition: 0.3s;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .section-title {
            font-weight: bold;
            margin: 20px 0;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">

        <span class="navbar-brand">RentEasy</span>
        <div class="dropdown me-3">
    <button class="btn btn-light dropdown-toggle" data-bs-toggle="dropdown">
        Mode
    </button>
    <ul class="dropdown-menu">
        <li><a class="dropdown-item" href="dashboard.jsp">User Mode</a></li>
        <li><a class="dropdown-item" href="ownerDashboard.jsp">Owner Mode</a></li>
    </ul>
</div>

        <!-- SEARCH -->
        <form class="d-flex mx-auto w-50" method="get" action="dashboard.jsp">
            <input class="form-control me-2" type="search" name="search" placeholder="Search products...">
            <button class="btn btn-light">Search</button>
        </form>

        <a href="logout.jsp" class="btn btn-danger btn-sm">Logout</a>

    </div>
</nav>

<div class="container mt-4">

    <!-- HERO -->
    <div class="hero">
        <h2>Welcome, <%= session.getAttribute("username") %> 👋</h2>
        <p>Rent anything, anytime with RentEasy</p>
    </div>

    <!-- BANNER -->
    <div id="carouselExample" class="carousel slide mb-4">
        <div class="carousel-inner">

            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7" class="d-block w-100" height="300">
            </div>

            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1560185127-6ed189bf02f4" class="d-block w-100" height="300">
            </div>

            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1616627982500-ffbbd0e0c0d2" class="d-block w-100" height="300">
            </div>

        </div>

        <button class="carousel-control-prev" data-bs-target="#carouselExample" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>

        <button class="carousel-control-next" data-bs-target="#carouselExample" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- CATEGORY -->
    <h4 class="section-title">Explore Categories</h4>

    <div class="row g-4">

        <div class="col-md-2">
            <a href="dashboard.jsp?category=Sofas" class="category-card">
                <img src="https://img.icons8.com/color/96/sofa.png"/>
                <p>Sofas</p>
            </a>
        </div>

        <div class="col-md-2">
            <a href="dashboard.jsp?category=Beds" class="category-card">
                <img src="https://img.icons8.com/color/96/bed.png"/>
                <p>Beds</p>
            </a>
        </div>

        <div class="col-md-2">
            <a href="dashboard.jsp?category=TV" class="category-card">
                <img src="https://img.icons8.com/color/96/tv.png"/>
                <p>TV</p>
            </a>
        </div>

        <div class="col-md-2">
            <a href="dashboard.jsp?category=AC" class="category-card">
                <img src="https://img.icons8.com/color/96/air-conditioner.png"/>
                <p>AC</p>
            </a>
        </div>

        <div class="col-md-2">
            <a href="dashboard.jsp?category=Fridge" class="category-card">
                <img src="https://img.icons8.com/color/96/fridge.png"/>
                <p>Fridge</p>
            </a>
        </div>

        <div class="col-md-2">
            <a href="dashboard.jsp?category=Washing Machine" class="category-card">
                <img src="https://img.icons8.com/color/96/washing-machine.png"/>
                <p>Washing Machine</p>
            </a>
        </div>

    </div>

    <!-- SUCCESS MESSAGE -->
    <%
    if(request.getParameter("success") != null){
    %>
        <div class="alert alert-success mt-3">
            Product rented successfully ✅
        </div>
    <%
    }
    %>

    <!-- PRODUCTS -->
    <h4 class="section-title">Available Products</h4>

    <div class="row">

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

    Statement st = con.createStatement();

    String search = request.getParameter("search");
    String category = request.getParameter("category");

    String query = "SELECT * FROM products";

    if(search != null && !search.trim().equals("")) {
        query = "SELECT * FROM products WHERE name LIKE '%" + search + "%'";
    }

    if(category != null && !category.trim().equals("")) {
        query = "SELECT * FROM products WHERE category='" + category + "'";
    }

    ResultSet rs = st.executeQuery(query);

    while(rs.next()) {
%>

        <div class="col-md-4">
            <div class="card p-3 mb-4">
                <img src="<%= rs.getString("image") %>" class="card-img-top">
                <h5 class="mt-2"><%= rs.getString("name") %></h5>
                <p>₹<%= rs.getInt("price") %>/day</p>

                <form action="rent" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <input type="hidden" name="name" value="<%= rs.getString("name") %>">
                    <input type="hidden" name="price" value="<%= rs.getInt("price") %>">

                    <button class="btn btn-primary w-100">Rent Now</button>
                </form>

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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>