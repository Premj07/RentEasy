<%@ page import="java.sql.*" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
/* =========================================================
   RentEasy - User Dashboard
   Self-contained dashboard.jsp
   ========================================================= */

String email = (String) session.getAttribute("email");

if (email == null) {
    response.sendRedirect("index.jsp");
    return;
}

/* ---------- KYC CHECK ---------- */
Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy", "root", "123456"
    );

    ps = con.prepareStatement("SELECT status FROM kyc WHERE email=?");
    ps.setString(1, email);
    rs = ps.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("kyc.jsp");
        return;
    }

    if (!"Approved".equalsIgnoreCase(rs.getString("status"))) {
        response.sendRedirect("kyc.jsp");
        return;
    }
} finally {
    try { if (rs != null) rs.close(); } catch(Exception e) {}
    try { if (ps != null) ps.close(); } catch(Exception e) {}
    try { if (con != null) con.close(); } catch(Exception e) {}
}

if (session.getAttribute("user") == null) {
    response.sendRedirect("index.jsp");
    return;
}

String firstName = (String) session.getAttribute("firstName");
String lastName  = (String) session.getAttribute("lastName");

if (firstName == null) firstName = "";
if (lastName == null) lastName = "";

String fullName = (firstName + " " + lastName).trim();
if (fullName.isEmpty()) fullName = "User";

String firstLetter = fullName.substring(0, 1).toUpperCase();

/* ---------- DASHBOARD COUNTS ---------- */
int totalProducts = 0;
int notificationCount = 0;

try {
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy", "root", "123456"
    );

    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM products " +
        "WHERE status='APPROVED' OR status='AVAILABLE' OR status='approved'"
    );
    rs = ps.executeQuery();

    if (rs.next()) totalProducts = rs.getInt(1);

    rs.close();
    ps.close();

    ps = con.prepareStatement(
        "SELECT COUNT(*) FROM notifications WHERE email=?"
    );
    ps.setString(1, email);
    rs = ps.executeQuery();

    if (rs.next()) notificationCount = rs.getInt(1);

} catch(Exception e) {
    System.out.println("Dashboard count error: " + e.getMessage());
} finally {
    try { if (rs != null) rs.close(); } catch(Exception e) {}
    try { if (ps != null) ps.close(); } catch(Exception e) {}
    try { if (con != null) con.close(); } catch(Exception e) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Dashboard - RentEasy</title>

<link rel="stylesheet"
 href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:"Segoe UI",Arial,sans-serif;
}

body{
    background:#f5f7fb;
    color:#111827;
}

/* ================= NAVBAR ================= */

.top-navbar{
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:72px;
    background:#fff;
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:0 35px;
    box-shadow:0 4px 18px rgba(15,23,42,.06);
    z-index:1000;
}

.nav-left{
    display:flex;
    align-items:center;
    gap:14px;
}

.menu-btn{
    width:44px;
    height:44px;
    border:0;
    border-radius:12px;
    background:#2563eb;
    color:#fff;
    font-size:21px;
    cursor:pointer;
}

.logo{
    display:flex;
    align-items:center;
    gap:10px;
    text-decoration:none;
    color:#111827;
    font-size:26px;
    font-weight:750;
}

.logo img{
    width:42px;
    height:42px;
    object-fit:contain;
}

.nav-center{
    flex:1;
    display:flex;
    justify-content:center;
    padding:0 25px;
}

.search-box{
    width:min(700px,100%);
}

.search-box input{
    width:100%;
    height:52px;
    border:0;
    outline:0;
    border-radius:28px;
    background:#eff6ff;
    padding:0 23px;
    font-size:15px;
}

.search-box input:focus{
    background:#fff;
    box-shadow:0 0 0 3px rgba(37,99,235,.14);
}

.nav-right{
    display:flex;
    align-items:center;
    gap:14px;
}

.notification-btn{
    width:44px;
    height:44px;
    border:0;
    border-radius:50%;
    background:#eff6ff;
    color:#2563eb;
    display:flex;
    align-items:center;
    justify-content:center;
    text-decoration:none;
    font-size:19px;
}

.user-name{
    background:#2563eb;
    color:#fff;
    padding:10px 19px;
    border-radius:25px;
    font-weight:650;
    text-decoration:none;
}

/* ================= SIDEBAR ================= */

.sidebar{
    position:fixed;
    top:72px;
    left:0;
    width:250px;
    height:calc(100vh - 72px);
    background:#fff;
    box-shadow:5px 0 20px rgba(15,23,42,.06);
    z-index:999;
    display:flex;
    flex-direction:column;
    overflow:hidden;
    transition:.3s;
}

.sidebar-header{
    padding:20px;
    border-bottom:1px solid #eef1f5;
}

.user-profile{
    display:flex;
    align-items:center;
    gap:12px;
}

.user-avatar{
    width:45px;
    height:45px;
    border-radius:12px;
    background:#2563eb;
    color:#fff;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:20px;
    font-weight:700;
}

.user-profile h4{
    font-size:15px;
    margin-bottom:2px;
}

.user-profile small{
    color:#64748b;
    font-size:11px;
}

.verified-badge{
    display:inline-flex;
    align-items:center;
    gap:4px;
    margin-top:7px;
    padding:4px 8px;
    border-radius:12px;
    background:#eff6ff;
    color:#2563eb;
    font-size:10px;
    font-weight:700;
}

.sidebar-scroll{
    flex:1;
    overflow-y:auto;
    padding:12px 0;
}

.sidebar-section-title{
    padding:12px 20px 5px;
    color:#94a3b8;
    font-size:10px;
    font-weight:800;
    letter-spacing:1px;
    text-transform:uppercase;
}

.sidebar ul{
    list-style:none;
    padding:0;
}

.sidebar li{
    margin:3px 10px;
}

.sidebar li a{
    display:flex;
    align-items:center;
    gap:12px;
    padding:11px 13px;
    border-radius:10px;
    text-decoration:none;
    color:#475569;
    font-size:13px;
    font-weight:600;
}

.sidebar li a:hover,
.sidebar li a.active{
    background:#2563eb;
    color:#fff;
}

.sidebar li a i{
    width:20px;
    text-align:center;
    font-size:16px;
}

.sidebar-bottom{
    border-top:1px solid #e5e7eb;
    padding:12px 10px;
    background:#fff;
}

.sidebar-bottom a{
    display:flex;
    align-items:center;
    gap:11px;
    padding:11px 13px;
    border-radius:10px;
    text-decoration:none;
    color:#475569;
    font-size:13px;
    font-weight:600;
}

.sidebar-bottom a:hover{
    background:#eff6ff;
    color:#2563eb;
}

.sidebar-bottom .logout:hover{
    background:#fff1f2;
    color:#dc2626;
}

/* ================= MAIN ================= */

.main-content{
    margin-left:250px;
    padding:102px 35px 45px;
    min-height:100vh;
}

.dashboard-container{
    max-width:1450px;
    margin:auto;
}

/* ================= WELCOME ================= */

.welcome-card{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:35px;
    background:linear-gradient(135deg,#2563eb,#3b82f6);
    border-radius:20px;
    padding:35px 38px;
    color:#fff;
    box-shadow:0 12px 30px rgba(37,99,235,.20);
    margin-bottom:25px;
}

.welcome-left{
    flex:1;
}

.welcome-badge{
    display:inline-flex;
    padding:6px 12px;
    border-radius:18px;
    background:rgba(255,255,255,.16);
    font-size:11px;
    font-weight:700;
    margin-bottom:12px;
}

.welcome-left h2{
    font-size:30px;
    margin-bottom:9px;
}

.welcome-left p{
    font-size:13px;
    line-height:1.6;
    max-width:600px;
    margin-bottom:20px;
}

.welcome-buttons{
    display:flex;
    gap:10px;
}

.btn-primary-custom,
.btn-outline-custom{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:10px 17px;
    border-radius:9px;
    font-size:12px;
    font-weight:700;
    text-decoration:none;
}

.btn-primary-custom{
    background:#fff;
    color:#2563eb;
}

.btn-outline-custom{
    border:1px solid rgba(255,255,255,.8);
    color:#fff;
}

.welcome-right{
    display:flex;
    gap:12px;
}

.stat-box{
    width:125px;
    min-height:105px;
    background:#fff;
    color:#2563eb;
    border-radius:14px;
    padding:18px 12px;
    text-align:center;
}

.stat-box h3{
    font-size:28px;
    margin-bottom:5px;
}

.stat-box p{
    font-size:10px;
    color:#475569;
    font-weight:650;
}

/* ================= SECTIONS ================= */

.section-header{
    display:flex;
    align-items:flex-end;
    justify-content:space-between;
    margin:28px 0 14px;
}

.section-header h3{
    font-size:20px;
    color:#0f172a;
}

.section-header p{
    color:#64748b;
    font-size:11px;
    margin-top:4px;
}

/* ================= CATEGORIES ================= */

.category-row{
    display:flex;
    gap:9px;
    flex-wrap:wrap;
    margin-bottom:25px;
}

.category-btn{
    height:38px;
    padding:0 15px;
    display:flex;
    align-items:center;
    gap:6px;
    border:1px solid #e2e8f0;
    background:#fff;
    color:#334155;
    border-radius:20px;
    text-decoration:none;
    font-size:11px;
    font-weight:650;
    transition:.2s;
}

.category-btn:hover{
    background:#2563eb;
    border-color:#2563eb;
    color:#fff;
}

/* ================= PRODUCT GRID ================= */

.product-grid{
    display:grid;
    grid-template-columns:repeat(4,minmax(0,1fr));
    gap:16px;
}

.product-card{
    background:#fff;
    border:1px solid #edf0f4;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 5px 16px rgba(15,23,42,.06);
    transition:.22s;
}

.product-card:hover{
    transform:translateY(-4px);
    box-shadow:0 12px 28px rgba(37,99,235,.12);
}

.image-box{
    height:175px;
    position:relative;
    background:#f8fafc;
    overflow:hidden;
}

.image-box img{
    width:100%;
    height:100%;
    object-fit:cover;
}

.category-badge{
    position:absolute;
    top:10px;
    left:10px;
    padding:5px 8px;
    border-radius:12px;
    background:#2563eb;
    color:#fff;
    font-size:9px;
    font-weight:700;
}

.product-info{
    padding:13px;
}

.product-info h4{
    font-size:14px;
    margin-bottom:6px;
    color:#0f172a;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}

.location{
    display:flex;
    gap:4px;
    color:#64748b;
    font-size:10px;
    min-height:28px;
    line-height:1.4;
    margin-bottom:9px;
}

.location i{
    color:#2563eb;
}

.price-row{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:8px;
}

.price strong{
    display:block;
    color:#2563eb;
    font-size:16px;
}

.price span{
    color:#64748b;
    font-size:9px;
}

.product-actions{
    display:flex;
    align-items:center;
    gap:6px;
}

.wishlist-heart{
    width:34px;
    height:34px;
    border:1px solid #dbe3ef;
    border-radius:9px;
    background:#fff;
    color:#64748b;
    cursor:pointer;
}

.wishlist-heart:hover,
.wishlist-heart.active{
    color:#ef4444;
    border-color:#fecdd3;
    background:#fff1f2;
}

.rent-btn{
    height:34px;
    padding:0 12px;
    border-radius:8px;
    background:#2563eb;
    color:#fff;
    display:flex;
    align-items:center;
    gap:5px;
    text-decoration:none;
    font-size:10px;
    font-weight:700;
}

.rent-btn:hover{
    background:#1d4ed8;
}

.recommended-card{
    position:relative;
}

.for-you-badge{
    position:absolute;
    top:10px;
    right:10px;
    z-index:2;
    padding:5px 8px;
    border-radius:12px;
    background:#4f46e5;
    color:#fff;
    font-size:8px;
    font-weight:700;
}

.empty-card{
    grid-column:1/-1;
    background:#fff;
    border:1px solid #edf0f4;
    border-radius:15px;
    padding:45px 20px;
    text-align:center;
    color:#64748b;
}

.empty-card i{
    font-size:35px;
    color:#2563eb;
}

.empty-card h4{
    color:#0f172a;
    margin:10px 0 6px;
}

/* ================= RESPONSIVE ================= */

@media(max-width:1200px){
    .product-grid{
        grid-template-columns:repeat(3,minmax(0,1fr));
    }
}

@media(max-width:900px){
    .nav-center{
        display:none;
    }

    .sidebar{
        left:-250px;
    }

    .sidebar.active{
        left:0;
    }

    .main-content{
        margin-left:0;
        padding-left:20px;
        padding-right:20px;
    }

    .welcome-card{
        flex-direction:column;
        align-items:flex-start;
    }

    .welcome-right{
        width:100%;
    }

    .stat-box{
        flex:1;
    }

    .product-grid{
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
}

@media(max-width:600px){
    .top-navbar{
        padding:0 14px;
    }

    .logo{
        font-size:21px;
    }

    .logo img{
        width:35px;
        height:35px;
    }

    .user-name{
        display:none;
    }

    .main-content{
        padding:88px 12px 30px;
    }

    .welcome-card{
        padding:23px;
    }

    .welcome-left h2{
        font-size:25px;
    }

    .product-grid{
        grid-template-columns:1fr;
    }

    .image-box{
        height:210px;
    }
}
</style>
</head>

<body>

<!-- ================= NAVBAR ================= -->

<header class="top-navbar">

    <div class="nav-left">

        <button type="button" class="menu-btn" id="menuToggle">
            <i class="bi bi-list"></i>
        </button>

        <a href="dashboard.jsp" class="logo">
            <img src="images/logo.png.jpeg" alt="RentEasy">
            <span>RentEasy</span>
        </a>

    </div>

    <div class="nav-center">
        <div class="search-box">
            <input
                type="text"
                placeholder="Try: Laptop under 500 near MIT ADT"
                onclick="window.location.href='products.jsp';">
        </div>
    </div>

    <div class="nav-right">

        <a href="notifications.jsp"
           class="notification-btn"
           title="Notifications">
            <i class="bi bi-bell"></i>
        </a>

        <a href="profile.jsp" class="user-name">
            <%= firstName.isEmpty() ? "User" : firstName %>
        </a>

    </div>

</header>


<!-- ================= SIDEBAR ================= -->

<aside class="sidebar" id="sidebar">

    <div class="sidebar-header">

        <div class="user-profile">

            <div class="user-avatar">
                <%= firstLetter %>
            </div>

            <div>
                <h4><%= fullName %></h4>
                <small>Student / User</small>

                <div class="verified-badge">
                    <i class="bi bi-patch-check-fill"></i>
                    Verified User
                </div>
            </div>

        </div>

    </div>


    <div class="sidebar-scroll">

        <div class="sidebar-section-title">Overview</div>

        <ul>
            <li>
                <a href="dashboard.jsp" class="active">
                    <i class="bi bi-grid-fill"></i>
                    Dashboard
                </a>
            </li>
        </ul>


        <div class="sidebar-section-title">Renting</div>

        <ul>

            <li>
                <a href="products.jsp">
                    <i class="bi bi-box-seam"></i>
                    Browse Products
                </a>
            </li>

            <li>
                <a href="WishlistPageServlet">
                    <i class="bi bi-heart"></i>
                    Wishlist
                </a>
            </li>

            <li>
                <a href="myRentals.jsp">
                    <i class="bi bi-bag-check"></i>
                    My Rentals
                </a>
            </li>

            <li>
                <a href="history.jsp">
                    <i class="bi bi-clock-history"></i>
                    Rental History
                </a>
            </li>

        </ul>


        <div class="sidebar-section-title">Finance</div>

        <ul>

            <li>
                <a href="paymentHistory.jsp">
                    <i class="bi bi-credit-card"></i>
                    Payments
                </a>
            </li>

            <li>
                <a href="delivery.jsp">
                    <i class="bi bi-truck"></i>
                    Delivery
                </a>
            </li>

        </ul>


        <div class="sidebar-section-title">Account</div>

        <ul>

            <li>
                <a href="profile.jsp">
                    <i class="bi bi-person"></i>
                    Profile
                </a>
            </li>

            <li>
                <a href="kyc.jsp">
                    <i class="bi bi-shield-check"></i>
                    KYC Verification
                </a>
            </li>

        </ul>

    </div>


    <div class="sidebar-bottom">

        <a href="ownerDashboard.jsp">
            <i class="bi bi-arrow-left-right"></i>
            Switch to Owner
        </a>

        <a href="logout" class="logout">
            <i class="bi bi-box-arrow-right"></i>
            Logout
        </a>

    </div>

</aside>


<!-- ================= MAIN ================= -->

<main class="main-content">

<div class="dashboard-container">


    <!-- ================= WELCOME ================= -->

    <section class="welcome-card">

        <div class="welcome-left">

            <span class="welcome-badge">
                <i class="bi bi-person-check"></i>
                Welcome Back
            </span>

            <h2>Hello, <%= fullName %></h2>

            <p>
                Rent furniture, electronics, books, sports equipment
                and more from verified MIT-ADT students.
            </p>

            <div class="welcome-buttons">

                <a href="#featuredProducts"
                   class="btn-primary-custom">
                    <i class="bi bi-search"></i>&nbsp;
                    Browse Products
                </a>

                <a href="myRentals.jsp"
                   class="btn-outline-custom">
                    <i class="bi bi-bag-check"></i>&nbsp;
                    My Rentals
                </a>

            </div>

        </div>


        <div class="welcome-right">

            <div class="stat-box">
                <h3><%= totalProducts %></h3>
                <p>Available Products</p>
            </div>

            <div class="stat-box">
                <h3><%= notificationCount %></h3>
                <p>Notifications</p>
            </div>

        </div>

    </section>


    <!-- ================= CATEGORIES ================= -->

    <div class="section-header">

        <div>
            <h3>Browse Categories</h3>
            <p>Choose a category to explore rentals.</p>
        </div>

    </div>

    <div class="category-row">

        <a href="products.jsp?category=Electronics" class="category-btn">
            <i class="bi bi-phone"></i> Electronics
        </a>

        <a href="products.jsp?category=Furniture" class="category-btn">
            <i class="bi bi-house"></i> Furniture
        </a>

        <a href="products.jsp?category=Books" class="category-btn">
            <i class="bi bi-book"></i> Books
        </a>

        <a href="products.jsp?category=Sports" class="category-btn">
            <i class="bi bi-trophy"></i> Sports
        </a>

        <a href="products.jsp?category=Laptops" class="category-btn">
            <i class="bi bi-laptop"></i> Laptops
        </a>

        <a href="products.jsp?category=Appliances" class="category-btn">
            <i class="bi bi-plug"></i> Appliances
        </a>

        <a href="products.jsp?sort=trending" class="category-btn">
            <i class="bi bi-fire"></i> Trending
        </a>

    </div>


    <!-- ================= FEATURED PRODUCTS ================= -->

    <section id="featuredProducts">

        <div class="section-header">

            <div>
                <h3>
                    <i class="bi bi-stars"></i>
                    Featured Products
                </h3>

                <p>
                    Discover products uploaded by MIT-ADT students.
                </p>
            </div>

            <a href="products.jsp"
               class="btn-outline-custom"
               style="background:#2563eb;color:#fff;border-color:#2563eb;">
                View All
            </a>

        </div>


        <div class="product-grid">

<%
Connection productCon = null;
PreparedStatement productPs = null;
ResultSet productRs = null;
int featuredCount = 0;

try {

    productCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    productPs = productCon.prepareStatement(
        "SELECT * FROM products " +
        "WHERE availability='AVAILABLE' " +
        "AND (status='approved' OR status='APPROVED') " +
        "ORDER BY id DESC LIMIT 8"
    );

    productRs = productPs.executeQuery();

    while(productRs.next()) {

        featuredCount++;

        int productId = productRs.getInt("id");
        String productName = productRs.getString("name");
        String category = productRs.getString("category");
        String location = productRs.getString("location");
        String image = productRs.getString("image");
        int price = productRs.getInt("price");
%>

            <div class="product-card">

                <div class="image-box">

                    <img
                        src="<%=request.getContextPath()%>/<%=image%>"
                        alt="<%=productName%>">

                    <span class="category-badge">
                        <%=category%>
                    </span>

                </div>


                <div class="product-info">

                    <h4 title="<%=productName%>">
                        <%=productName%>
                    </h4>

                    <p class="location">
                        <i class="bi bi-geo-alt-fill"></i>
                        <span><%=location%></span>
                    </p>


                    <div class="price-row">

                        <div class="price">

                            <strong>₹<%=price%></strong>
                            <span>/ Day</span>

                        </div>


                        <div class="product-actions">

                            <button
                                type="button"
                                class="wishlist-heart"
                                onclick="toggleWishlist(<%=productId%>,this)"
                                title="Add to Wishlist">

                                <i class="bi bi-heart"></i>

                            </button>


                            <a
                                href="rentProduct.jsp?id=<%=productId%>"
                                class="rent-btn">

                                <i class="bi bi-cart3"></i>
                                Rent Now

                            </a>

                        </div>

                    </div>

                </div>

            </div>

<%
    }

} catch(Exception e) {

    out.println(
        "<div class='empty-card'>" +
        "<i class='bi bi-exclamation-circle'></i>" +
        "<h4>Unable to load products</h4>" +
        "<p>Please try again later.</p>" +
        "</div>"
    );

} finally {

    try { if(productRs != null) productRs.close(); } catch(Exception e) {}
    try { if(productPs != null) productPs.close(); } catch(Exception e) {}
    try { if(productCon != null) productCon.close(); } catch(Exception e) {}
}

if(featuredCount == 0) {
%>

            <div class="empty-card">

                <i class="bi bi-box-seam"></i>

                <h4>No Products Available</h4>

                <p>New rental products will appear here.</p>

                <a href="products.jsp"
                   class="rent-btn"
                   style="display:inline-flex;margin-top:12px;">
                    Browse Products
                </a>

            </div>

<%
}
%>

        </div>

    </section>


    <!-- ================= RECOMMENDED ================= -->

    <section>

        <div class="section-header">

            <div>
                <h3>
                    <i class="bi bi-magic"></i>
                    Recommended For You
                </h3>

                <p>
                    Personalized recommendations based on your RentEasy activity.
                </p>
            </div>

            <span style="
                background:#eef2ff;
                color:#4f46e5;
                padding:6px 10px;
                border-radius:15px;
                font-size:9px;
                font-weight:700;">
                <i class="bi bi-stars"></i>
                AI Personalized
            </span>

        </div>


        <div class="product-grid">

<%
Connection recCon = null;
PreparedStatement recPs = null;
ResultSet recRs = null;
int recommendationCount = 0;

try {

    recCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    recPs = recCon.prepareStatement(
        "SELECT * FROM products " +
        "WHERE availability='AVAILABLE' " +
        "AND (status='approved' OR status='APPROVED') " +
        "ORDER BY RAND() LIMIT 4"
    );

    recRs = recPs.executeQuery();

    while(recRs.next()) {

        recommendationCount++;

        int productId = recRs.getInt("id");
        String productName = recRs.getString("name");
        String category = recRs.getString("category");
        String location = recRs.getString("location");
        String image = recRs.getString("image");
        int price = recRs.getInt("price");
%>

            <div class="product-card recommended-card">

                <span class="for-you-badge">
                    <i class="bi bi-stars"></i> For You
                </span>

                <div class="image-box">

                    <img
                        src="<%=request.getContextPath()%>/<%=image%>"
                        alt="<%=productName%>">

                    <span class="category-badge">
                        <%=category%>
                    </span>

                </div>


                <div class="product-info">

                    <h4 title="<%=productName%>">
                        <%=productName%>
                    </h4>

                    <p class="location">
                        <i class="bi bi-geo-alt-fill"></i>
                        <span><%=location%></span>
                    </p>


                    <div style="
                        display:flex;
                        justify-content:space-between;
                        align-items:center;
                        margin-bottom:10px;
                        padding:7px 9px;
                        background:#f8faff;
                        border:1px solid #e6eaff;
                        border-radius:8px;">

                        <span style="
                            color:#64748b;
                            font-size:9px;
                            font-weight:600;">
                            <i class="bi bi-stars"
                               style="color:#4f46e5;"></i>
                            AI Match
                        </span>

                        <strong style="
                            color:#4f46e5;
                            font-size:10px;">
                            Recommended
                        </strong>

                    </div>


                    <div class="price-row">

                        <div class="price">
                            <strong>₹<%=price%></strong>
                            <span>/ Day</span>
                        </div>


                        <div class="product-actions">

                            <button
                                type="button"
                                class="wishlist-heart"
                                onclick="toggleWishlist(<%=productId%>,this)"
                                title="Add to Wishlist">

                                <i class="bi bi-heart"></i>

                            </button>


                            <a
                                href="rentProduct.jsp?id=<%=productId%>"
                                class="rent-btn">

                                <i class="bi bi-cart3"></i>
                                Rent Now

                            </a>

                        </div>

                    </div>

                </div>

            </div>

<%
    }

} catch(Exception e) {

    System.out.println("Recommendation error: " + e.getMessage());

} finally {

    try { if(recRs != null) recRs.close(); } catch(Exception e) {}
    try { if(recPs != null) recPs.close(); } catch(Exception e) {}
    try { if(recCon != null) recCon.close(); } catch(Exception e) {}
}

if(recommendationCount == 0) {
%>

            <div class="empty-card">

                <i class="bi bi-stars"></i>

                <h4>Recommendations Coming Soon</h4>

                <p>
                    Browse and rent products to improve your recommendations.
                </p>

            </div>

<%
}
%>

        </div>

    </section>

</div>
</main>


<script>

/* ================= SIDEBAR ================= */

const menuBtn = document.getElementById("menuToggle");
const sidebar = document.getElementById("sidebar");

if(menuBtn && sidebar){
    menuBtn.onclick = function(){
        sidebar.classList.toggle("active");
    };
}


/* ================= WISHLIST ================= */

function toggleWishlist(productId, button){

    const icon = button.querySelector("i");
    const alreadySaved = button.classList.contains("active");

    if(alreadySaved){

        button.classList.remove("active");

        icon.classList.remove("bi-heart-fill");
        icon.classList.add("bi-heart");

    }else{

        button.classList.add("active");

        icon.classList.remove("bi-heart");
        icon.classList.add("bi-heart-fill");
    }


    const params = new URLSearchParams();

    params.append("productId", productId);
    params.append(
        "action",
        alreadySaved ? "remove" : "add"
    );


    fetch("WishlistServlet",{

        method:"POST",

        headers:{
            "Content-Type":
            "application/x-www-form-urlencoded"
        },

        body:params.toString()

    })
    .then(response => {

        if(!response.ok){
            throw new Error("Wishlist request failed");
        }

        return response.text();

    })
    .then(data => {

        console.log("Wishlist updated:", data);

    })
    .catch(error => {

        console.error(error);

        /* Rollback */

        if(alreadySaved){

            button.classList.add("active");
            icon.classList.remove("bi-heart");
            icon.classList.add("bi-heart-fill");

        }else{

            button.classList.remove("active");
            icon.classList.remove("bi-heart-fill");
            icon.classList.add("bi-heart");
        }

        alert("Unable to update wishlist.");
    });
}

</script>

</body>
</html>
