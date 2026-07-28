<%@ page session="true" %>
<%
if(!"ADMIN".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Panel</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
/* TOP NAVBAR */

.topbar{

    position:fixed;

    top:0;

    left:280px;

    right:0;

    height:80px;

    background:#fff;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 30px;

    box-shadow:0 2px 15px rgba(0,0,0,.08);

    z-index:999;

}

.brand{
    display:flex;
    align-items:center;
    gap:15px;
}

.brand img{
    width:45px;
    height:45px;
}

.brand h3{
    margin:0;
    font-weight:700;
    color:#2563eb;
}

.admin-badge{
    background:#dc3545;
    color:white;
    padding:5px 12px;
    border-radius:20px;
    font-size:13px;
    font-weight:bold;
}

.admin-right{
    display:flex;
    align-items:center;
    gap:15px;
}

.admin-profile{
    text-align:right;
}

.admin-profile h6{
    margin:0;
    font-weight:600;
}

.admin-profile small{
    color:#666;
}

.logout-btn{
    background:#dc3545;
    color:white;
    border:none;
    padding:8px 18px;
    border-radius:8px;
    text-decoration:none;
}

.logout-btn:hover{
    background:#bb2d3b;
    color:white;
}

/* MAIN */

.main{
    margin-left:280px;
    margin-top:100px;
    padding:30px;
}
.sidebar{
    position:fixed;
    left:0;
    top:0;
    width:280px;
    height:100vh;
    background:#111827;
    overflow-y:auto;
    z-index:1000;
}

.sidebar a{

    display:block;

    margin:12px 0;

    padding:12px 15px;

    border-radius:10px;

    text-decoration:none;

    color:#d1d5db;

    transition:.3s;
}

.sidebar a:hover{

    background:#2563eb;

    color:white;
}
}
</style>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">

    <div class="text-center mb-4">

        <img src="images/logo.png.jpeg"
             width="60"
             class="mb-2 rounded-circle">

        <h4>RentEasy</h4>

        <small class="text-light">
            ADMIN PANEL
        </small>

    </div>

    <a href="adminDashboard.jsp">
        Dashboard
    </a>

    <a href="adminUsers.jsp">
        Users
    </a>

    <a href="adminProducts.jsp">
        Products
    </a>

    <a href="adminRentals.jsp">
        Rentals
    </a>

    <a href="adminReturns.jsp">
        Returns
    </a>

    <a href="adminRefund.jsp">
        Refunds
    </a>

    <a href="logout">
        Logout
    </a>

</div>

<!-- TOP NAVBAR -->

<div class="topbar">

    <div class="brand">

        <img src="images/logo.png.jpeg">

        <h3>RentEasy</h3>

        <span class="admin-badge">
            ADMIN PANEL
        </span>

    </div>

    <div class="admin-right">

        <div class="admin-profile">

            <h6>
                Admin
            </h6>

            <small>

                <%= session.getAttribute("email") %>

            </small>

        </div>

       

    </div>

</div>

<!-- MAIN START -->

<div class="main">