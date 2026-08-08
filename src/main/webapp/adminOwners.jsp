<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
/* =========================================================
   ADMIN SECURITY
   ========================================================= */
if(!"ADMIN".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   DASHBOARD COUNTERS
   ========================================================= */

int totalOwners = 0;
int totalListings = 0;
int availableProducts = 0;
int activeRentals = 0;

String loadError = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    try(Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456")) {


        /* TOTAL OWNERS */

        try(PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(DISTINCT owner_id) " +
                "FROM products " +
                "WHERE owner_id IS NOT NULL");
            ResultSet rs = ps.executeQuery()) {

            if(rs.next()){
                totalOwners = rs.getInt(1);
            }
        }


        /* TOTAL PRODUCT LISTINGS */

        try(PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) " +
                "FROM products " +
                "WHERE owner_id IS NOT NULL");
            ResultSet rs = ps.executeQuery()) {

            if(rs.next()){
                totalListings = rs.getInt(1);
            }
        }


        /* AVAILABLE PRODUCTS */

        try(PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) " +
                "FROM products " +
                "WHERE owner_id IS NOT NULL " +
                "AND UPPER(availability)='AVAILABLE'");
            ResultSet rs = ps.executeQuery()) {

            if(rs.next()){
                availableProducts = rs.getInt(1);
            }
        }


        /* ACTIVE RENTALS */

        try(PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) " +
                "FROM rentals " +
                "WHERE UPPER(rental_status)='ACTIVE'");
            ResultSet rs = ps.executeQuery()) {

            if(rs.next()){
                activeRentals = rs.getInt(1);
            }
        }

    }

} catch(Exception e) {

    e.printStackTrace();
    loadError = e.getMessage();
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Owner Management - RentEasy Admin</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<!-- BOOTSTRAP -->

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">


<!-- BOOTSTRAP ICONS -->

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>

/* =========================================================
   GENERAL
   ========================================================= */

*{
    box-sizing:border-box;
}

body{

    margin:0;

    background:#f6f8fc;

    font-family:
        Inter,
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        sans-serif;

    color:#0f172a;
}


/* =========================================================
   SIDEBAR
   ========================================================= */

.sidebar{

    position:fixed;

    top:0;
    left:0;

    width:285px;
    height:100vh;

    background:#0f1a2e;

    color:white;

    overflow-y:auto;

    z-index:1000;

    border-right:1px solid rgba(255,255,255,.05);
}


/* LOGO AREA */

.sidebar-brand{

    height:190px;

    padding:22px 24px;

    display:flex;

    align-items:flex-start;

    border-bottom:1px solid rgba(255,255,255,.08);
}


.brand-wrapper{

    display:flex;

    align-items:center;

    gap:15px;
}


.brand-logo{

    width:52px;
    height:52px;

    background:white;

    border-radius:12px;

    padding:5px;

    object-fit:contain;
}


.brand-text h4{

    margin:0;

    color:white;

    font-weight:700;

    font-size:21px;
}


.brand-text span{

    display:block;

    color:#8da2c7;

    font-size:12px;

    margin-top:3px;

    letter-spacing:.5px;
}


/* SIDEBAR CONTENT */

.sidebar-menu{

    padding:23px 15px 40px 15px;
}


.menu-title{

    color:#7186aa;

    font-size:11px;

    font-weight:700;

    letter-spacing:1px;

    margin:22px 15px 12px;
}


.sidebar-link{

    position:relative;

    display:flex;

    align-items:center;

    gap:16px;

    padding:14px 16px;

    margin:4px 0;

    color:#e2e8f0;

    text-decoration:none;

    border-radius:10px;

    font-size:15px;

    font-weight:500;

    transition:.2s;
}


.sidebar-link i{

    width:20px;

    text-align:center;

    font-size:18px;
}


.sidebar-link:hover{

    background:#172640;

    color:white;
}


.sidebar-link.active{

    background:#2f6bea;

    color:white;
}


.sidebar-link.active::before{

    content:"";

    position:absolute;

    left:-15px;

    top:11px;

    width:4px;

    height:30px;

    background:#7db0ff;

    border-radius:0 5px 5px 0;
}


/* =========================================================
   TOP NAVBAR
   ========================================================= */

.topbar{

    position:fixed;

    top:0;
    left:285px;
    right:0;

    height:80px;

    background:white;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 35px;

    border-bottom:1px solid #e5eaf1;

    z-index:900;
}


.topbar-left{

    display:flex;

    align-items:center;

    gap:16px;
}


.topbar-logo{

    width:32px;
    height:32px;

    object-fit:contain;
}


.topbar-brand{

    font-size:22px;

    font-weight:700;

    color:#2563eb;
}


.admin-pill{

    padding:7px 14px;

    background:#fff1f2;

    color:#dc2626;

    border:1px solid #fecaca;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


.topbar-right{

    display:flex;

    align-items:center;

    gap:18px;
}


.notification-btn{

    width:43px;
    height:43px;

    display:flex;

    align-items:center;

    justify-content:center;

    border:1px solid #e2e8f0;

    border-radius:11px;

    font-size:19px;

    background:#f8fafc;
}


.profile-divider{

    width:1px;

    height:42px;

    background:#e2e8f0;
}


.admin-avatar{

    width:43px;
    height:43px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#2563eb;

    color:white;

    border-radius:50%;

    font-weight:700;
}


.admin-profile{

    display:flex;

    align-items:center;

    gap:12px;
}


.admin-info strong{

    display:block;

    font-size:14px;
}


.admin-info small{

    display:block;

    color:#64748b;

    font-size:11px;
}


/* =========================================================
   MAIN
   ========================================================= */

.main{

    margin-left:285px;

    padding-top:80px;

    min-height:100vh;
}


.content{

    padding:42px 42px 60px;
}


/* =========================================================
   PAGE HEADER
   ========================================================= */

.page-header{

    display:flex;

    align-items:center;

    justify-content:space-between;

    margin-bottom:28px;
}


.page-header h1{

    margin:0;

    font-size:32px;

    font-weight:750;

    color:#0f172a;
}


.page-header p{

    margin:6px 0 0;

    color:#64748b;

    font-size:15px;
}


/* =========================================================
   STATS
   ========================================================= */

.stats-grid{

    display:grid;

    grid-template-columns:repeat(4,1fr);

    gap:25px;

    margin-bottom:35px;
}


.stat-card{

    background:white;

    border:1px solid #e3e9f1;

    border-radius:16px;

    min-height:155px;

    padding:25px;

    display:flex;

    align-items:flex-start;

    justify-content:space-between;

    box-shadow:0 5px 18px rgba(15,23,42,.035);
}


.stat-label{

    color:#526581;

    font-size:14px;

    margin-bottom:12px;
}


.stat-number{

    margin:0;

    font-size:31px;

    font-weight:750;

    color:#0f172a;
}


.stat-icon{

    width:50px;
    height:50px;

    display:flex;

    align-items:center;

    justify-content:center;

    border-radius:13px;

    font-size:22px;
}


.icon-blue{
    background:#eef4ff;
    color:#2563eb;
}

.icon-green{
    background:#eafbf3;
    color:#059669;
}

.icon-orange{
    background:#fff5e9;
    color:#ea580c;
}

.icon-purple{
    background:#f3efff;
    color:#7c3aed;
}


/* =========================================================
   CONTENT CARD
   ========================================================= */

.content-card{

    background:white;

    border:1px solid #e3e9f1;

    border-radius:17px;

    overflow:hidden;

    box-shadow:0 5px 18px rgba(15,23,42,.035);
}


.card-header-custom{

    padding:23px 24px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    border-bottom:1px solid #e8edf3;
}


.card-header-custom h4{

    margin:0;

    font-size:20px;

    font-weight:700;
}


.card-header-custom p{

    margin:4px 0 0;

    color:#64748b;

    font-size:13px;
}


/* =========================================================
   SEARCH
   ========================================================= */

.search-box{

    width:340px;

    height:46px;

    display:flex;

    align-items:center;

    gap:10px;

    border:1px solid #dce3ed;

    border-radius:10px;

    padding:0 14px;

    background:white;
}


.search-box i{

    color:#94a3b8;

    font-size:18px;
}


.search-box input{

    width:100%;

    border:none;

    outline:none;

    font-size:14px;

    color:#334155;
}


/* =========================================================
   TABLE
   ========================================================= */

.admin-table{

    width:100%;

    border-collapse:collapse;
}


.admin-table thead{

    background:#f8fafc;
}


.admin-table th{

    padding:17px 20px;

    font-size:12px;

    color:#334155;

    font-weight:700;

    border-bottom:1px solid #e2e8f0;
}


.admin-table td{

    padding:19px 20px;

    border-bottom:1px solid #edf1f5;

    vertical-align:middle;

    font-size:14px;
}


.admin-table tbody tr:hover{

    background:#fbfdff;
}


/* =========================================================
   OWNER
   ========================================================= */

.owner-info{

    display:flex;

    align-items:center;

    gap:13px;
}


.owner-avatar{

    width:43px;
    height:43px;

    min-width:43px;

    display:flex;

    align-items:center;

    justify-content:center;

    border-radius:50%;

    background:#eaf1ff;

    color:#2563eb;

    font-weight:700;

    font-size:16px;
}


.owner-info strong{

    display:block;

    font-size:14px;

    color:#0f172a;
}


.owner-info small{

    display:block;

    color:#94a3b8;

    margin-top:3px;
}


/* =========================================================
   BADGES
   ========================================================= */

.number-badge{

    display:inline-flex;

    min-width:35px;

    height:30px;

    padding:0 10px;

    align-items:center;

    justify-content:center;

    border-radius:8px;

    background:#eef4ff;

    color:#2563eb;

    font-weight:700;
}


.approved-badge{

    display:inline-flex;

    min-width:35px;

    height:30px;

    padding:0 10px;

    align-items:center;

    justify-content:center;

    border-radius:8px;

    background:#eafbf3;

    color:#059669;

    font-weight:700;
}


.pending-badge{

    display:inline-flex;

    min-width:35px;

    height:30px;

    padding:0 10px;

    align-items:center;

    justify-content:center;

    border-radius:8px;

    background:#fff7e8;

    color:#d97706;

    font-weight:700;
}


.rental-badge{

    display:inline-flex;

    min-width:35px;

    height:30px;

    padding:0 10px;

    align-items:center;

    justify-content:center;

    border-radius:8px;

    background:#f3efff;

    color:#7c3aed;

    font-weight:700;
}


/* =========================================================
   BUTTON
   ========================================================= */

.view-btn{

    display:inline-flex;

    align-items:center;

    gap:7px;

    padding:8px 13px;

    border:1px solid #cfd9e8;

    border-radius:8px;

    color:#2563eb;

    text-decoration:none;

    font-weight:600;

    font-size:13px;

    background:white;

    transition:.2s;
}


.view-btn:hover{

    background:#2563eb;

    border-color:#2563eb;

    color:white;
}


/* =========================================================
   EMPTY STATE
   ========================================================= */

.empty-state{

    text-align:center;

    padding:65px 20px;
}


.empty-state i{

    font-size:45px;

    color:#22c55e;
}


.empty-state h4{

    margin-top:15px;

    font-size:20px;
}


.empty-state p{

    color:#64748b;
}


/* =========================================================
   ERROR
   ========================================================= */

.error-box{

    margin-bottom:25px;

    padding:15px 18px;

    background:#fee2e2;

    color:#991b1b;

    border:1px solid #fecaca;

    border-radius:10px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1200px){

    .stats-grid{
        grid-template-columns:repeat(2,1fr);
    }

}


@media(max-width:900px){

    .sidebar{
        width:230px;
    }

    .topbar{
        left:230px;
    }

    .main{
        margin-left:230px;
    }

    .content{
        padding:30px 20px;
    }

}


</style>

</head>


<body>


<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<div class="sidebar">


    <div class="sidebar-brand">

        <div class="brand-wrapper">

            <img src="images/logo.png.jpeg"
                 class="brand-logo">

            <div class="brand-text">

                <h4>RentEasy</h4>

                <span>
                    ADMINISTRATION
                </span>

            </div>

        </div>

    </div>


    <div class="sidebar-menu">


        <a href="adminDashboard.jsp"
           class="sidebar-link">

            <i class="bi bi-grid-fill"></i>

            Dashboard

        </a>


        <div class="menu-title">
            MANAGEMENT
        </div>


        <a href="adminUsers.jsp"
           class="sidebar-link">

            <i class="bi bi-people"></i>

            Users

        </a>


        <a href="adminOwners.jsp"
           class="sidebar-link active">

            <i class="bi bi-shop"></i>

            Owners

        </a>


        <a href="adminProducts.jsp"
           class="sidebar-link">

            <i class="bi bi-box-seam"></i>

            Products

        </a>


        <a href="adminRentals.jsp"
           class="sidebar-link">

            <i class="bi bi-arrow-repeat"></i>

            Rentals

        </a>


        <div class="menu-title">
            RETURN & PAYMENTS
        </div>


        <a href="adminReturnRequests.jsp"
           class="sidebar-link">

            <i class="bi bi-arrow-return-left"></i>

            Return Requests

        </a>


        <a href="adminReturns.jsp"
           class="sidebar-link">

            <i class="bi bi-box-arrow-left"></i>

            Returns

        </a>


        <a href="adminRefund.jsp"
           class="sidebar-link">

            <i class="bi bi-cash-coin"></i>

            Refunds

        </a>


        <a href="adminPayments.jsp"
           class="sidebar-link">

            <i class="bi bi-credit-card"></i>

            Payments

        </a>


        <div class="menu-title">
            VERIFICATION
        </div>


        <a href="adminKyc.jsp"
           class="sidebar-link">

            <i class="bi bi-person-check"></i>

            KYC Verification

        </a>


        <a href="logout"
           class="sidebar-link">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>


    </div>

</div>



<!-- =========================================================
     TOP NAVBAR
     ========================================================= -->

<div class="topbar">


    <div class="topbar-left">

        <img src="images/logo.png.jpeg"
             class="topbar-logo">

        <span class="topbar-brand">
            RentEasy
        </span>

        <span class="admin-pill">
            ADMIN PANEL
        </span>

    </div>


    <div class="topbar-right">


        <div class="notification-btn">

            <i class="bi bi-bell"></i>

        </div>


        <div class="profile-divider"></div>


        <div class="admin-profile">

            <div class="admin-avatar">
                A
            </div>


            <div class="admin-info">

                <strong>
                    Administrator
                </strong>

                <small>
                    <%
                    Object adminEmail =
                        session.getAttribute("email");

                    if(adminEmail != null){
                        out.print(adminEmail);
                    }else{
                        out.print("Admin");
                    }
                    %>
                </small>

            </div>

        </div>


    </div>

</div>



<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="main">

<div class="content">


    <!-- PAGE HEADER -->

    <div class="page-header">

        <div>

            <h1>
                Owner Management
            </h1>

            <p>
                Monitor product owners, listings and rental
                activity across RentEasy.
            </p>

        </div>

    </div>



    <% if(loadError != null){ %>

        <div class="error-box">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Unable to load owner statistics:

            <%= loadError %>

        </div>

    <% } %>



    <!-- =====================================================
         STATISTICS
         ===================================================== -->

    <div class="stats-grid">


        <div class="stat-card">

            <div>

                <div class="stat-label">
                    Total Owners
                </div>

                <h2 class="stat-number">
                    <%= totalOwners %>
                </h2>

            </div>


            <div class="stat-icon icon-blue">

                <i class="bi bi-shop"></i>

            </div>

        </div>



        <div class="stat-card">

            <div>

                <div class="stat-label">
                    Total Listings
                </div>

                <h2 class="stat-number">
                    <%= totalListings %>
                </h2>

            </div>


            <div class="stat-icon icon-green">

                <i class="bi bi-box-seam"></i>

            </div>

        </div>



        <div class="stat-card">

            <div>

                <div class="stat-label">
                    Available Products
                </div>

                <h2 class="stat-number">
                    <%= availableProducts %>
                </h2>

            </div>


            <div class="stat-icon icon-orange">

                <i class="bi bi-check-circle"></i>

            </div>

        </div>



        <div class="stat-card">

            <div>

                <div class="stat-label">
                    Active Rentals
                </div>

                <h2 class="stat-number">
                    <%= activeRentals %>
                </h2>

            </div>


            <div class="stat-icon icon-purple">

                <i class="bi bi-arrow-repeat"></i>

            </div>

        </div>


    </div>



    <!-- =====================================================
         OWNERS TABLE
         ===================================================== -->

    <div class="content-card">


        <div class="card-header-custom">


            <div>

                <h4>
                    Registered Owners
                </h4>

                <p>
                    Users who currently have products listed
                    on RentEasy.
                </p>

            </div>


            <div class="search-box">

                <i class="bi bi-search"></i>

                <input type="text"
                       id="ownerSearch"
                       placeholder="Search owner or email..."
                       onkeyup="filterOwners()">

            </div>


        </div>



        <div class="table-responsive">


            <table class="admin-table"
                   id="ownerTable">


                <thead>

                    <tr>

                        <th>OWNER</th>

                        <th>CONTACT</th>

                        <th>PRODUCTS</th>

                        <th>APPROVED</th>

                        <th>PENDING</th>

                        <th>ACTIVE RENTALS</th>

                        <th>ACTION</th>

                    </tr>

                </thead>


                <tbody>


<%

Connection ownerCon = null;
PreparedStatement ownerPs = null;
ResultSet ownerRs = null;

try {

    Class.forName(
        "com.mysql.cj.jdbc.Driver"
    );


    ownerCon =
        DriverManager.getConnection(

            "jdbc:mysql://localhost:3306/renteasy",

            "root",

            "123456"

        );


    String ownerSql =

        "SELECT " +

        "u.id, " +

        "u.first_name, " +

        "u.last_name, " +

        "u.email, " +

        "u.phone, " +


        "COUNT(DISTINCT p.id) " +
        "AS total_products, " +


        "COUNT(DISTINCT CASE " +

        "WHEN LOWER(p.status)='approved' " +

        "THEN p.id END) " +

        "AS approved_products, " +


        "COUNT(DISTINCT CASE " +

        "WHEN LOWER(p.status)='pending' " +

        "THEN p.id END) " +

        "AS pending_products, " +


        "COUNT(DISTINCT CASE " +

        "WHEN LOWER(r.rental_status)='active' " +

        "THEN r.rental_id END) " +

        "AS active_rentals " +


        "FROM users u " +


        "JOIN products p " +

        "ON p.owner_id = u.id " +


        "LEFT JOIN rentals r " +

        "ON r.owner_id = u.id " +


        "GROUP BY " +

        "u.id, " +

        "u.first_name, " +

        "u.last_name, " +

        "u.email, " +

        "u.phone " +


        "ORDER BY total_products DESC";


    ownerPs =
        ownerCon.prepareStatement(
            ownerSql
        );


    ownerRs =
        ownerPs.executeQuery();


    boolean ownerFound = false;


    while(ownerRs.next()) {


        ownerFound = true;


        int ownerId =
            ownerRs.getInt("id");


        String firstName =
            ownerRs.getString("first_name");


        String lastName =
            ownerRs.getString("last_name");


        String email =
            ownerRs.getString("email");


        String phone =
            ownerRs.getString("phone");


        if(firstName == null){
            firstName = "";
        }


        if(lastName == null){
            lastName = "";
        }


        String fullName =
            (firstName + " " + lastName).trim();


        if(fullName.isEmpty()){
            fullName = "RentEasy Owner";
        }


        String initial = "O";


        if(!firstName.trim().isEmpty()){

            initial =
                firstName.substring(0,1)
                         .toUpperCase();

        }

%>


<tr>


    <!-- OWNER -->

    <td>


        <div class="owner-info">


            <div class="owner-avatar">

                <%= initial %>

            </div>


            <div>


                <strong>

                    <%= fullName %>

                </strong>


                <small>

                    Owner ID #<%= ownerId %>

                </small>


            </div>


        </div>


    </td>



    <!-- CONTACT -->

    <td>


        <strong>

            <%= email != null ? email : "-" %>

        </strong>


        <small class="d-block text-muted mt-1">

            <i class="bi bi-telephone me-1"></i>

            <%= phone != null ? phone : "No phone" %>

        </small>


    </td>



    <!-- PRODUCTS -->

    <td>

        <span class="number-badge">

            <%= ownerRs.getInt("total_products") %>

        </span>

    </td>



    <!-- APPROVED -->

    <td>

        <span class="approved-badge">

            <%= ownerRs.getInt("approved_products") %>

        </span>

    </td>



    <!-- PENDING -->

    <td>

        <span class="pending-badge">

            <%= ownerRs.getInt("pending_products") %>

        </span>

    </td>



    <!-- ACTIVE RENTALS -->

    <td>

        <span class="rental-badge">

            <%= ownerRs.getInt("active_rentals") %>

        </span>

    </td>



    <!-- ACTION -->

    <td>


        <a href="adminOwnerDetails.jsp?ownerId=<%= ownerId %>"
           class="view-btn">


            <i class="bi bi-eye"></i>


            View


        </a>


    </td>


</tr>


<%

    }


    /* =====================================================
       NO OWNERS
       ===================================================== */

    if(!ownerFound){

%>


<tr>


    <td colspan="7">


        <div class="empty-state">


            <i class="bi bi-shop"></i>


            <h4>
                No Owners Found
            </h4>


            <p>
                Users who list products will automatically
                appear here.
            </p>


        </div>


    </td>


</tr>


<%

    }


} catch(Exception e) {

    e.printStackTrace();

%>


<tr>


    <td colspan="7">


        <div class="alert alert-danger m-4">


            <i class="bi bi-exclamation-triangle me-2"></i>


            Unable to load owners:


            <%= e.getMessage() %>


        </div>


    </td>


</tr>


<%

} finally {


    try {

        if(ownerRs != null){
            ownerRs.close();
        }

    } catch(Exception ignored){}


    try {

        if(ownerPs != null){
            ownerPs.close();
        }

    } catch(Exception ignored){}


    try {

        if(ownerCon != null){
            ownerCon.close();
        }

    } catch(Exception ignored){}

}

%>


                </tbody>


            </table>


        </div>


    </div>


</div>

</div>



<!-- =========================================================
     SEARCH SCRIPT
     ========================================================= -->

<script>


function filterOwners(){


    const input =
        document.getElementById("ownerSearch");


    const filter =
        input.value.toLowerCase();


    const table =
        document.getElementById("ownerTable");


    const rows =
        table.getElementsByTagName("tbody")[0]
             .getElementsByTagName("tr");


    for(let i = 0; i < rows.length; i++){


        const rowText =
            rows[i].innerText.toLowerCase();


        if(rowText.includes(filter)){

            rows[i].style.display = "";

        }else{

            rows[i].style.display = "none";

        }

    }

}


</script>


</body>

</html>