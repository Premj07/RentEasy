<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
/* =========================================================
   ADMIN SECURITY
   ========================================================= */
if (!"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp");
    return;
}

/* =========================================================
   OWNER ID
   ========================================================= */
String ownerIdParam = request.getParameter("ownerId");

if (ownerIdParam == null) {
    response.sendRedirect("adminOwners.jsp");
    return;
}

int ownerId;

try {
    ownerId = Integer.parseInt(ownerIdParam);
} catch (Exception e) {
    response.sendRedirect("adminOwners.jsp");
    return;
}


/* =========================================================
   OWNER DATA
   ========================================================= */

String firstName = "";
String lastName = "";
String ownerEmail = "";
String ownerPhone = "";
String createdAt = "";
String kycStatus = "Not Submitted";

int totalProducts = 0;
int approvedProducts = 0;
int pendingProducts = 0;
int availableProducts = 0;

int totalRentals = 0;
int activeRentals = 0;

boolean ownerFound = false;

String loadError = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    /* =====================================================
       OWNER BASIC INFORMATION
       ===================================================== */

    PreparedStatement ownerPs = con.prepareStatement(

        "SELECT id, first_name, last_name, email, phone, " +
        "created_at, kyc_status " +
        "FROM users " +
        "WHERE id=?"

    );

    ownerPs.setInt(1, ownerId);

    ResultSet ownerRs = ownerPs.executeQuery();

    if (ownerRs.next()) {

        ownerFound = true;

        firstName = ownerRs.getString("first_name");
        lastName = ownerRs.getString("last_name");
        ownerEmail = ownerRs.getString("email");
        ownerPhone = ownerRs.getString("phone");

        Timestamp created =
            ownerRs.getTimestamp("created_at");

        if (created != null) {
            createdAt = created.toString();
        }

        String dbKycStatus =
            ownerRs.getString("kyc_status");

        if (dbKycStatus != null &&
            !dbKycStatus.trim().isEmpty()) {

            kycStatus = dbKycStatus;
        }
    }

    ownerRs.close();
    ownerPs.close();


    if (!ownerFound) {

        con.close();

        response.sendRedirect(
            "adminOwners.jsp?error=owner_not_found"
        );

        return;
    }


    /* =====================================================
       PRODUCT STATISTICS
       ===================================================== */

    PreparedStatement productStats =
        con.prepareStatement(

            "SELECT " +

            "COUNT(*) AS total_products, " +

            "SUM(CASE " +
            "WHEN LOWER(status)='approved' " +
            "THEN 1 ELSE 0 END) AS approved_products, " +

            "SUM(CASE " +
            "WHEN LOWER(status)='pending' " +
            "THEN 1 ELSE 0 END) AS pending_products, " +

            "SUM(CASE " +
            "WHEN LOWER(availability)='available' " +
            "THEN 1 ELSE 0 END) AS available_products " +

            "FROM products " +
            "WHERE owner_id=?"

        );

    productStats.setInt(1, ownerId);

    ResultSet productRs =
        productStats.executeQuery();

    if (productRs.next()) {

        totalProducts =
            productRs.getInt("total_products");

        approvedProducts =
            productRs.getInt("approved_products");

        pendingProducts =
            productRs.getInt("pending_products");

        availableProducts =
            productRs.getInt("available_products");
    }

    productRs.close();
    productStats.close();


    /* =====================================================
       RENTAL STATISTICS
       ===================================================== */

    PreparedStatement rentalStats =
        con.prepareStatement(

            "SELECT " +

            "COUNT(*) AS total_rentals, " +

            "SUM(CASE " +
            "WHEN UPPER(rental_status)='ACTIVE' " +
            "THEN 1 ELSE 0 END) AS active_rentals " +

            "FROM rentals " +
            "WHERE owner_id=?"

        );

    rentalStats.setInt(1, ownerId);

    ResultSet rentalRs =
        rentalStats.executeQuery();

    if (rentalRs.next()) {

        totalRentals =
            rentalRs.getInt("total_rentals");

        activeRentals =
            rentalRs.getInt("active_rentals");
    }

    rentalRs.close();
    rentalStats.close();

    con.close();

} catch (Exception e) {

    e.printStackTrace();

    loadError = e.getMessage();
}

String fullName =
    (firstName == null ? "" : firstName) +
    " " +
    (lastName == null ? "" : lastName);

fullName = fullName.trim();

String initial = "O";

if (firstName != null &&
    !firstName.trim().isEmpty()) {

    initial =
        firstName.substring(0,1).toUpperCase();
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Owner Details - RentEasy</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1">


<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">


<style>

/* =========================================================
   GLOBAL
   ========================================================= */

*{
    box-sizing:border-box;
}

body{

    margin:0;

    background:#f5f7fb;

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

    left:0;
    top:0;

    width:290px;
    height:100vh;

    background:#0f1b30;

    overflow-y:auto;

    z-index:1000;
}


/* SIDEBAR BRAND */

.sidebar-brand{

    height:95px;

    display:flex;

    align-items:center;

    padding:0 24px;

    border-bottom:1px solid rgba(255,255,255,.08);
}

.sidebar-brand img{

    width:52px;
    height:52px;

    object-fit:contain;

    background:white;

    border-radius:12px;

    padding:5px;

    margin-right:15px;
}

.sidebar-brand h4{

    color:white;

    margin:0;

    font-size:22px;

    font-weight:700;
}

.sidebar-brand small{

    color:#8ea9d4;

    font-size:12px;

    letter-spacing:.7px;
}


/* NAV */

.sidebar-nav{

    padding:22px 15px 40px;
}

.nav-section{

    color:#6f8bb8;

    font-size:12px;

    font-weight:700;

    letter-spacing:1px;

    margin:

        25px 15px
        10px;
}

.sidebar-nav a{

    display:flex;

    align-items:center;

    gap:15px;

    min-height:52px;

    color:#e2e8f0;

    text-decoration:none;

    padding:0 16px;

    border-radius:10px;

    margin-bottom:4px;

    font-weight:600;

    transition:.2s;
}

.sidebar-nav a:hover{

    background:#172844;

    color:white;
}

.sidebar-nav a.active{

    background:#2f6fec;

    color:white;
}

.nav-icon{

    width:20px;

    text-align:center;

    font-size:18px;
}


/* =========================================================
   TOPBAR
   ========================================================= */

.topbar{

    position:fixed;

    left:290px;
    right:0;
    top:0;

    height:86px;

    background:white;

    border-bottom:1px solid #e2e8f0;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 34px;

    z-index:900;
}


.topbar-brand{

    display:flex;

    align-items:center;

    gap:14px;
}

.topbar-brand img{

    width:35px;
    height:35px;

    object-fit:contain;
}

.topbar-brand h3{

    color:#2563eb;

    font-size:23px;

    margin:0;

    font-weight:700;
}

.admin-badge{

    margin-left:5px;

    padding:8px 14px;

    background:#fff1f2;

    border:1px solid #fecdd3;

    color:#dc2626;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


/* ADMIN */

.admin-area{

    display:flex;

    align-items:center;

    gap:18px;
}

.notification-btn{

    width:44px;
    height:44px;

    border:1px solid #e2e8f0;

    background:#f8fafc;

    border-radius:11px;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:19px;
}

.admin-divider{

    height:45px;

    width:1px;

    background:#e2e8f0;
}

.admin-avatar{

    width:44px;
    height:44px;

    border-radius:50%;

    background:#2563eb;

    color:white;

    display:flex;

    align-items:center;

    justify-content:center;

    font-weight:700;

    font-size:17px;
}

.admin-info{

    line-height:1.3;
}

.admin-info strong{

    display:block;

    font-size:15px;
}

.admin-info span{

    color:#64748b;

    font-size:12px;
}


/* =========================================================
   MAIN
   ========================================================= */

.main{

    margin-left:290px;

    padding:

        125px
        45px
        60px;
}

.page-container{

    max-width:1350px;

    margin:auto;
}


/* =========================================================
   BACK
   ========================================================= */

.back-link{

    display:inline-flex;

    align-items:center;

    gap:8px;

    color:#2563eb;

    text-decoration:none;

    font-weight:600;

    margin-bottom:18px;
}

.back-link:hover{

    text-decoration:underline;
}


/* =========================================================
   PAGE TITLE
   ========================================================= */

.page-title{

    font-size:32px;

    font-weight:750;

    margin:0;
}

.page-subtitle{

    color:#64748b;

    margin-top:7px;

    margin-bottom:28px;
}


/* =========================================================
   OWNER PROFILE
   ========================================================= */

.owner-profile-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:16px;

    padding:28px;

    display:flex;

    justify-content:space-between;

    align-items:center;

    box-shadow:0 5px 18px rgba(15,23,42,.04);
}


.owner-main{

    display:flex;

    align-items:center;

    gap:20px;
}

.owner-avatar{

    width:76px;
    height:76px;

    border-radius:50%;

    background:#eaf1ff;

    color:#2563eb;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:30px;

    font-weight:700;
}

.owner-name{

    font-size:24px;

    font-weight:700;

    margin-bottom:5px;
}

.owner-id{

    color:#64748b;

    font-size:14px;
}


.owner-contact{

    text-align:right;
}

.owner-contact div{

    margin:5px 0;

    color:#475569;
}


/* =========================================================
   KYC
   ========================================================= */

.kyc-badge{

    display:inline-block;

    padding:7px 13px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;

    margin-top:7px;
}

.kyc-approved{

    background:#dcfce7;

    color:#15803d;
}

.kyc-pending{

    background:#fff7ed;

    color:#ea580c;
}

.kyc-other{

    background:#f1f5f9;

    color:#475569;
}


/* =========================================================
   STATS
   ========================================================= */

.stats-grid{

    display:grid;

    grid-template-columns:
        repeat(4,1fr);

    gap:20px;

    margin-top:25px;
}

.stat-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:15px;

    padding:22px;

    box-shadow:0 5px 18px rgba(15,23,42,.03);
}

.stat-label{

    color:#64748b;

    font-size:14px;

    margin-bottom:8px;
}

.stat-number{

    font-size:28px;

    font-weight:700;

    color:#0f172a;
}


/* =========================================================
   SECTION CARD
   ========================================================= */

.section-card{

    margin-top:25px;

    background:white;

    border:1px solid #e2e8f0;

    border-radius:16px;

    overflow:hidden;

    box-shadow:0 5px 18px rgba(15,23,42,.03);
}

.section-header{

    padding:22px 25px;

    border-bottom:1px solid #e2e8f0;

    display:flex;

    justify-content:space-between;

    align-items:center;
}

.section-header h4{

    font-size:19px;

    margin:0;

    font-weight:700;
}

.section-header p{

    margin:4px 0 0;

    color:#64748b;

    font-size:13px;
}


/* =========================================================
   TABLE
   ========================================================= */

.custom-table{

    width:100%;

    border-collapse:collapse;
}

.custom-table th{

    background:#f8fafc;

    color:#334155;

    font-size:12px;

    text-transform:uppercase;

    padding:16px 20px;

    border-bottom:1px solid #e2e8f0;
}

.custom-table td{

    padding:17px 20px;

    border-bottom:1px solid #eef2f7;

    vertical-align:middle;
}

.product-cell{

    display:flex;

    align-items:center;

    gap:12px;
}

.product-img{

    width:50px;
    height:50px;

    object-fit:cover;

    border-radius:9px;

    border:1px solid #e2e8f0;

    background:#f8fafc;
}

.status-badge{

    display:inline-block;

    padding:6px 10px;

    border-radius:15px;

    font-size:11px;

    font-weight:700;
}

.status-approved{

    background:#dcfce7;

    color:#15803d;
}

.status-pending{

    background:#fff7ed;

    color:#c2410c;
}

.status-other{

    background:#f1f5f9;

    color:#475569;
}


/* =========================================================
   EMPTY
   ========================================================= */

.empty-state{

    padding:50px;

    text-align:center;

    color:#64748b;
}


/* =========================================================
   BUTTON
   ========================================================= */

.view-btn{

    border:1px solid #bfdbfe;

    background:white;

    color:#2563eb;

    text-decoration:none;

    padding:8px 13px;

    border-radius:8px;

    font-size:13px;

    font-weight:600;
}

.view-btn:hover{

    background:#eff6ff;
}


/* =========================================================
   ERROR
   ========================================================= */

.error-box{

    background:#fee2e2;

    border:1px solid #fecaca;

    color:#991b1b;

    padding:15px;

    border-radius:10px;

    margin-bottom:20px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1000px){

    .stats-grid{

        grid-template-columns:
            repeat(2,1fr);
    }

    .owner-profile-card{

        align-items:flex-start;

        flex-direction:column;

        gap:20px;
    }

    .owner-contact{

        text-align:left;
    }
}

</style>

</head>


<body>


<!-- =====================================================
     SIDEBAR
     ===================================================== -->

<div class="sidebar">


<div class="sidebar-brand">

    <img src="images/logo.png.jpeg">

    <div>

        <h4>RentEasy</h4>

        <small>ADMINISTRATION</small>

    </div>

</div>


<div class="sidebar-nav">


<a href="adminDashboard.jsp">

    <span class="nav-icon">▦</span>

    Dashboard

</a>


<div class="nav-section">
MANAGEMENT
</div>


<a href="adminUsers.jsp">

    <span class="nav-icon">♧</span>

    Users

</a>


<a href="adminOwners.jsp"
   class="active">

    <span class="nav-icon">▥</span>

    Owners

</a>


<a href="adminProducts.jsp">

    <span class="nav-icon">⬡</span>

    Products

</a>


<a href="adminRentals.jsp">

    <span class="nav-icon">⟳</span>

    Rentals

</a>


<div class="nav-section">
RETURN & PAYMENTS
</div>


<a href="adminReturnRequests.jsp">

    <span class="nav-icon">↩</span>

    Return Requests

</a>


<a href="adminReturns.jsp">

    <span class="nav-icon">⇥</span>

    Returns

</a>


<a href="adminRefund.jsp">

    <span class="nav-icon">◉</span>

    Refunds

</a>


<a href="adminPayments.jsp">

    <span class="nav-icon">▣</span>

    Payments

</a>


<div class="nav-section">
VERIFICATION
</div>


<a href="adminKyc.jsp">

    <span class="nav-icon">♙</span>

    KYC Verification

</a>


<div class="nav-section">
ACCOUNT
</div>


<a href="logout">

    <span class="nav-icon">↪</span>

    Logout

</a>


</div>

</div>



<!-- =====================================================
     TOP NAVBAR
     ===================================================== -->

<div class="topbar">


<div class="topbar-brand">

    <img src="images/logo.png.jpeg">

    <h3>RentEasy</h3>

    <span class="admin-badge">
        ADMIN PANEL
    </span>

</div>


<div class="admin-area">


<div class="notification-btn">
    ♧
</div>


<div class="admin-divider"></div>


<div class="admin-avatar">
    A
</div>


<div class="admin-info">

    <strong>
        Administrator
    </strong>

    <span>
        <%= session.getAttribute("email") %>
    </span>

</div>


</div>

</div>



<!-- =====================================================
     MAIN
     ===================================================== -->

<div class="main">

<div class="page-container">


<a href="adminOwners.jsp"
   class="back-link">

    ← Back to Owner Management

</a>


<h1 class="page-title">
    Owner Details
</h1>


<p class="page-subtitle">

    View owner information, listings and rental activity.

</p>


<%

if(loadError != null){

%>

<div class="error-box">

    Unable to load complete owner information:

    <%= loadError %>

</div>

<%

}

%>



<!-- =====================================================
     OWNER PROFILE
     ===================================================== -->

<div class="owner-profile-card">


<div class="owner-main">


<div class="owner-avatar">

    <%= initial %>

</div>


<div>


<div class="owner-name">

    <%= fullName %>

</div>


<div class="owner-id">

    Owner ID #<%= ownerId %>

</div>


<%

String kycClass = "kyc-other";

if("Approved".equalsIgnoreCase(kycStatus)){

    kycClass = "kyc-approved";

}
else if("Pending".equalsIgnoreCase(kycStatus)){

    kycClass = "kyc-pending";
}

%>


<span class="kyc-badge <%=kycClass%>">

    KYC: <%=kycStatus%>

</span>


</div>

</div>



<div class="owner-contact">

    <div>

        ✉ <strong><%=ownerEmail%></strong>

    </div>


    <div>

        ☎ <%=ownerPhone%>

    </div>


<%

if(createdAt != null &&
   !createdAt.isEmpty()){

%>

    <div>

        Joined: <%=createdAt%>

    </div>

<%

}

%>


</div>


</div>



<!-- =====================================================
     OWNER STATISTICS
     ===================================================== -->

<div class="stats-grid">


<div class="stat-card">

    <div class="stat-label">
        Total Listings
    </div>

    <div class="stat-number">
        <%=totalProducts%>
    </div>

</div>



<div class="stat-card">

    <div class="stat-label">
        Approved Products
    </div>

    <div class="stat-number">
        <%=approvedProducts%>
    </div>

</div>



<div class="stat-card">

    <div class="stat-label">
        Available Products
    </div>

    <div class="stat-number">
        <%=availableProducts%>
    </div>

</div>



<div class="stat-card">

    <div class="stat-label">
        Active Rentals
    </div>

    <div class="stat-number">
        <%=activeRentals%>
    </div>

</div>


</div>



<!-- =====================================================
     PRODUCT LISTINGS
     ===================================================== -->

<div class="section-card">


<div class="section-header">


<div>

<h4>
    Product Listings
</h4>

<p>

    Products currently listed by this owner.

</p>

</div>


<div>

<strong>
    <%=totalProducts%> Products
</strong>

</div>


</div>



<%

boolean hasProducts = false;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con =
        DriverManager.getConnection(

            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"

        );


    PreparedStatement ps =
        con.prepareStatement(

            "SELECT " +

            "id, name, image, category, " +
            "price, deposit, status, availability " +

            "FROM products " +

            "WHERE owner_id=? " +

            "ORDER BY id DESC"

        );


    ps.setInt(1, ownerId);

    ResultSet rs =
        ps.executeQuery();


%>


<table class="custom-table">


<thead>

<tr>

<th>
Product
</th>

<th>
Category
</th>

<th>
Rent / Day
</th>

<th>
Deposit
</th>

<th>
Approval
</th>

<th>
Availability
</th>

<th>
Action
</th>

</tr>

</thead>


<tbody>


<%

while(rs.next()){

    hasProducts = true;

    String productStatus =
        rs.getString("status");

    String productStatusClass =
        "status-other";

    if("Approved".equalsIgnoreCase(
        productStatus)){

        productStatusClass =
            "status-approved";

    }
    else if("Pending".equalsIgnoreCase(
        productStatus)){

        productStatusClass =
            "status-pending";

    }

%>


<tr>


<td>

<div class="product-cell">


<%

String image =
    rs.getString("image");

if(image != null &&
   !image.trim().isEmpty()){

%>


<img
src="<%=request.getContextPath()%>/<%=image%>"
class="product-img">


<%

}
else{

%>


<div class="product-img"
     style="
     display:flex;
     align-items:center;
     justify-content:center;
     ">

    📦

</div>


<%

}

%>


<div>

<strong>

    <%=rs.getString("name")%>

</strong>

<br>

<small class="text-muted">

    Product #<%=rs.getInt("id")%>

</small>

</div>


</div>

</td>



<td>

<%=rs.getString("category")%>

</td>



<td>

₹<%=rs.getInt("price")%>

</td>



<td>

₹<%=rs.getInt("deposit")%>

</td>



<td>

<span class="status-badge
             <%=productStatusClass%>">

    <%=productStatus%>

</span>

</td>



<td>

<%=rs.getString("availability")%>

</td>



<td>

<a
href="adminProductDetails.jsp?id=<%=rs.getInt("id")%>"
class="view-btn">

    View

</a>

</td>


</tr>


<%

}

%>


</tbody>

</table>


<%

    rs.close();
    ps.close();
    con.close();


} catch(Exception e){

%>


<div class="error-box m-4">

Unable to load products:

<%=e.getMessage()%>

</div>


<%

}

if(!hasProducts){

%>


<div class="empty-state">

    <h5>No Products Listed</h5>

    <p class="mb-0">

        This owner currently has no product listings.

    </p>

</div>


<%

}

%>


</div>



<!-- =====================================================
     RENTAL ACTIVITY SUMMARY
     ===================================================== -->

<div class="section-card">


<div class="section-header">


<div>

<h4>
    Rental Activity
</h4>

<p>

    Rental activity generated from this owner's products.

</p>

</div>


<a href="adminRentals.jsp"
   class="view-btn">

    View All Rentals

</a>


</div>


<div style="padding:25px;">


<div class="row">


<div class="col-md-4">

<div class="stat-label">

Total Rentals

</div>

<div class="stat-number">

<%=totalRentals%>

</div>

</div>


<div class="col-md-4">

<div class="stat-label">

Active Rentals

</div>

<div class="stat-number">

<%=activeRentals%>

</div>

</div>


<div class="col-md-4">

<div class="stat-label">

Pending Listings

</div>

<div class="stat-number">

<%=pendingProducts%>

</div>

</div>


</div>


</div>

</div>


</div>

</div>


</body>

</html>