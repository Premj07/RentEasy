<%@ page session="true" %>
<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Panel</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    margin:0;
    background:#f4f6f9;
    font-family: 'Segoe UI';
}

/* SIDEBAR */
.sidebar {
    width:240px;
    height:100vh;
    position:fixed;
    background:#111827;
    color:white;
    padding:20px;
}

.sidebar h4 {
    color:#fff;
    font-weight:bold;
}

.sidebar a {
    display:block;
    padding:12px;
    margin:10px 0;
    border-radius:8px;
    text-decoration:none;
    color:#d1d5db;
    transition:0.3s;
}

.sidebar a:hover {
    background:#2563eb;
    color:white;
}

/* MAIN */
.main {
    margin-left:260px;
    padding:30px;
}

/* CARDS */
.card-box {
    background:white;
    padding:20px;
    border-radius:12px;
    box-shadow:0 4px 10px rgba(0,0,0,0.08);
    transition:0.3s;
}

.card-box:hover {
    transform:translateY(-5px);
}

/* TABLE */
.table-box {
    background:white;
    padding:20px;
    border-radius:12px;
    box-shadow:0 4px 10px rgba(0,0,0,0.08);
}

/* MOBILE */
@media(max-width:768px){
.sidebar{
    width:100%;
    height:auto;
    position:relative;
}
.main{
    margin-left:0;
}
}
</style>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4>🚀 RentEasy</h4>

    <a href="adminDashboard.jsp">Dashboard</a>
    <a href="adminUsers.jsp">Users</a>
    <a href="adminProducts.jsp">Products</a>

    <hr style="border-color:#374151;">

    <a href="logout" class="btn btn-danger w-100">Logout</a>
</div>

<!-- MAIN START -->
<div class="main">