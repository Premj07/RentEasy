<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<%
/* =========================================================
   ADMIN SECURITY
   ========================================================= */
String role = (String) session.getAttribute("role");

if(role == null || !"ADMIN".equals(role)){
    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   DASHBOARD COUNTS
   ========================================================= */
int totalProducts = 0;
int approvedProducts = 0;
int pendingProducts = 0;
int availableProducts = 0;

String countError = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    PreparedStatement ps = con.prepareStatement(

        "SELECT " +

        "COUNT(*) AS total, " +

        "SUM(CASE WHEN LOWER(status)='approved' " +
        "THEN 1 ELSE 0 END) AS approved, " +

        "SUM(CASE WHEN LOWER(status)='pending' " +
        "THEN 1 ELSE 0 END) AS pending, " +

        "SUM(CASE WHEN LOWER(availability)='available' " +
        "THEN 1 ELSE 0 END) AS available " +

        "FROM products"

    );

    ResultSet rs = ps.executeQuery();

    if(rs.next()){

        totalProducts =
            rs.getInt("total");

        approvedProducts =
            rs.getInt("approved");

        pendingProducts =
            rs.getInt("pending");

        availableProducts =
            rs.getInt("available");
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){

    e.printStackTrace();

    countError = e.getMessage();
}
%>


<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Product Management - RentEasy</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1">


<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
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


.sidebar-brand{

    height:95px;

    display:flex;

    align-items:center;

    padding:0 24px;

    border-bottom:
        1px solid rgba(255,255,255,.08);
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


.sidebar-nav{

    padding:22px 15px 40px;
}


.nav-section{

    color:#6f8bb8;

    font-size:12px;

    font-weight:700;

    letter-spacing:1px;

    margin:25px 15px 10px;
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
        42px
        60px;
}


.page-container{

    max-width:1450px;

    margin:auto;
}


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
   STATISTICS
   ========================================================= */

.stats-grid{

    display:grid;

    grid-template-columns:
        repeat(4,1fr);

    gap:20px;

    margin-bottom:28px;
}


.stat-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:15px;

    padding:22px;

    display:flex;

    justify-content:space-between;

    align-items:flex-start;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.stat-label{

    color:#64748b;

    font-size:14px;

    margin-bottom:8px;
}


.stat-number{

    font-size:29px;

    font-weight:700;
}


.stat-icon{

    width:50px;
    height:50px;

    border-radius:12px;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:22px;
}


.icon-blue{

    background:#edf4ff;

    color:#2563eb;
}


.icon-green{

    background:#eafaf3;

    color:#059669;
}


.icon-orange{

    background:#fff6e9;

    color:#ea580c;
}


.icon-purple{

    background:#f3efff;

    color:#7c3aed;
}


/* =========================================================
   PRODUCT CARD
   ========================================================= */

.products-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:16px;

    overflow:hidden;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.products-header{

    min-height:92px;

    padding:20px 24px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    border-bottom:1px solid #e2e8f0;
}


.products-header h4{

    font-size:20px;

    font-weight:700;

    margin:0;
}


.products-header p{

    margin:5px 0 0;

    color:#64748b;

    font-size:13px;
}


/* =========================================================
   SEARCH AND FILTER
   ========================================================= */

.table-tools{

    display:flex;

    align-items:center;

    gap:10px;
}


.search-box{

    width:310px;

    height:46px;

    border:1px solid #dbe3ef;

    border-radius:10px;

    padding:0 15px;

    outline:none;

    color:#334155;
}


.search-box:focus{

    border-color:#2563eb;

    box-shadow:
        0 0 0 3px rgba(37,99,235,.08);
}


.filter-select{

    height:46px;

    border:1px solid #dbe3ef;

    border-radius:10px;

    padding:0 35px 0 14px;

    background:white;

    color:#475569;

    outline:none;
}


/* =========================================================
   TABLE
   ========================================================= */

.table-responsive{

    overflow-x:auto;
}


.product-table{

    width:100%;

    border-collapse:collapse;
}


.product-table th{

    padding:16px 18px;

    background:#f8fafc;

    border-bottom:1px solid #e2e8f0;

    color:#334155;

    font-size:12px;

    font-weight:700;

    text-transform:uppercase;

    white-space:nowrap;
}


.product-table td{

    padding:17px 18px;

    border-bottom:1px solid #edf2f7;

    vertical-align:middle;
}


.product-table tbody tr:hover{

    background:#fbfdff;
}


/* PRODUCT */

.product-info{

    display:flex;

    align-items:center;

    gap:13px;

    min-width:230px;
}


.product-image{

    width:58px;
    height:58px;

    object-fit:cover;

    border-radius:10px;

    border:1px solid #e2e8f0;

    background:#f8fafc;
}


.no-image{

    width:58px;
    height:58px;

    border-radius:10px;

    background:#f1f5f9;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:23px;
}


.product-name{

    font-weight:700;

    color:#0f172a;

    margin-bottom:3px;
}


.product-id{

    color:#94a3b8;

    font-size:12px;
}


/* OWNER */

.owner-name{

    font-weight:600;

    color:#334155;
}


.owner-id{

    font-size:12px;

    color:#94a3b8;

    margin-top:3px;
}


/* PRICE */

.price{

    font-weight:700;

    color:#0f172a;
}


.deposit{

    color:#2563eb;

    font-weight:650;
}


/* BADGES */

.status-badge{

    display:inline-flex;

    align-items:center;

    padding:6px 11px;

    border-radius:20px;

    font-size:11px;

    font-weight:700;

    text-transform:capitalize;
}


.status-approved{

    background:#dcfce7;

    color:#15803d;
}


.status-pending{

    background:#fff7ed;

    color:#c2410c;
}


.status-rejected{

    background:#fee2e2;

    color:#b91c1c;
}


.availability-badge{

    display:inline-block;

    padding:6px 10px;

    border-radius:7px;

    font-size:11px;

    font-weight:700;

    background:#eff6ff;

    color:#2563eb;
}


/* =========================================================
   ACTION BUTTONS
   ========================================================= */

.actions{

    display:flex;

    align-items:center;

    gap:6px;

    flex-wrap:wrap;
}


.action-btn{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    min-height:34px;

    padding:0 11px;

    border-radius:7px;

    font-size:12px;

    font-weight:600;

    text-decoration:none;

    transition:.15s;
}


.view-btn{

    border:1px solid #bfdbfe;

    color:#2563eb;

    background:white;
}


.view-btn:hover{

    background:#eff6ff;

    color:#1d4ed8;
}


.approve-btn{

    background:#ecfdf5;

    color:#059669;

    border:1px solid #a7f3d0;
}


.approve-btn:hover{

    background:#059669;

    color:white;
}


.reject-btn{

    background:#fff7ed;

    color:#ea580c;

    border:1px solid #fed7aa;
}


.reject-btn:hover{

    background:#ea580c;

    color:white;
}


.delete-btn{

    background:#fff1f2;

    color:#dc2626;

    border:1px solid #fecdd3;
}


.delete-btn:hover{

    background:#dc2626;

    color:white;
}


/* =========================================================
   EMPTY / ERROR
   ========================================================= */

.empty-state{

    padding:60px 25px;

    text-align:center;

    color:#64748b;
}


.empty-icon{

    width:65px;
    height:65px;

    margin:0 auto 15px;

    background:#ecfdf5;

    color:#16a34a;

    border-radius:50%;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:30px;
}


.error-box{

    background:#fee2e2;

    border:1px solid #fecaca;

    color:#991b1b;

    padding:15px 18px;

    border-radius:10px;

    margin-bottom:20px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1100px){

    .stats-grid{

        grid-template-columns:
            repeat(2,1fr);
    }

    .products-header{

        align-items:flex-start;

        flex-direction:column;

        gap:15px;
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


<a href="adminOwners.jsp">

    <span class="nav-icon">▥</span>

    Owners

</a>


<a href="adminProducts.jsp"
   class="active">

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


<%
if(countError != null){
%>

<div class="error-box">

    Unable to load product statistics:
    <%=countError%>

</div>

<%
}
%>


<!-- PAGE HEADER -->

<h1 class="page-title">
    Product Management
</h1>

<p class="page-subtitle">

    Review product listings, manage approvals and monitor
    product availability across RentEasy.

</p>



<!-- =====================================================
     STATISTICS
     ===================================================== -->

<div class="stats-grid">


<div class="stat-card">

<div>

    <div class="stat-label">
        Total Products
    </div>

    <div class="stat-number">
        <%=totalProducts%>
    </div>

</div>

<div class="stat-icon icon-blue">
    ◇
</div>

</div>



<div class="stat-card">

<div>

    <div class="stat-label">
        Approved Products
    </div>

    <div class="stat-number">
        <%=approvedProducts%>
    </div>

</div>

<div class="stat-icon icon-green">
    ✓
</div>

</div>



<div class="stat-card">

<div>

    <div class="stat-label">
        Pending Approval
    </div>

    <div class="stat-number">
        <%=pendingProducts%>
    </div>

</div>

<div class="stat-icon icon-orange">
    ⏳
</div>

</div>



<div class="stat-card">

<div>

    <div class="stat-label">
        Available Products
    </div>

    <div class="stat-number">
        <%=availableProducts%>
    </div>

</div>

<div class="stat-icon icon-purple">
    ◎
</div>

</div>


</div>



<!-- =====================================================
     PRODUCT TABLE
     ===================================================== -->

<div class="products-card">


<div class="products-header">


<div>

<h4>
    Product Listings
</h4>

<p>

    Manage all products currently registered on RentEasy.

</p>

</div>



<div class="table-tools">


<input
type="text"
id="productSearch"
class="search-box"
placeholder="Search product, owner or category..."
onkeyup="filterProducts()">


<select
id="statusFilter"
class="filter-select"
onchange="filterProducts()">

<option value="">
    All Status
</option>

<option value="approved">
    Approved
</option>

<option value="pending">
    Pending
</option>

<option value="rejected">
    Rejected
</option>

</select>


</div>


</div>



<div class="table-responsive">


<table
class="product-table"
id="productTable">


<thead>

<tr>

<th>
Product
</th>

<th>
Owner
</th>

<th>
Category
</th>

<th>
Price / Day
</th>

<th>
Deposit
</th>

<th>
Status
</th>

<th>
Availability
</th>

<th>
Actions
</th>

</tr>

</thead>


<tbody>


<%

boolean hasProducts = false;

try{

    Class.forName(
        "com.mysql.cj.jdbc.Driver"
    );


    Connection con =
        DriverManager.getConnection(

            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"

        );


    PreparedStatement ps =
        con.prepareStatement(

            "SELECT " +

            "p.id, " +
            "p.name, " +
            "p.price, " +
            "p.deposit, " +
            "p.owner, " +
            "p.owner_id, " +
            "p.image, " +
            "p.status, " +
            "p.category, " +
            "p.availability, " +
            "p.product_type, " +
            "p.listing_type " +

            "FROM products p " +

            "ORDER BY " +

            "CASE " +
            "WHEN LOWER(p.status)='pending' THEN 0 " +
            "ELSE 1 END, " +

            "p.id DESC"

        );


    ResultSet rs =
        ps.executeQuery();


    while(rs.next()){

        hasProducts = true;


        String status =
            rs.getString("status");


        String statusClass =
            "status-rejected";


        if("approved".equalsIgnoreCase(status)){

            statusClass =
                "status-approved";

        }
        else if("pending".equalsIgnoreCase(status)){

            statusClass =
                "status-pending";
        }


        String image =
            rs.getString("image");


        String owner =
            rs.getString("owner");


        if(owner == null ||
           owner.trim().isEmpty()){

            owner = "Owner #" +
                rs.getInt("owner_id");
        }


        String category =
            rs.getString("category");


        if(category == null ||
           category.trim().isEmpty()){

            category = "-";
        }


        String availability =
            rs.getString("availability");


        if(availability == null){

            availability = "-";
        }

%>


<tr
data-status="<%=status == null ? "" : status.toLowerCase()%>">


<!-- PRODUCT -->

<td>

<div class="product-info">


<%

if(image != null &&
   !image.trim().isEmpty()){

%>

<img
src="<%=request.getContextPath()%>/<%=image%>"
class="product-image"
onerror="this.style.display='none';">

<%

}
else{

%>

<div class="no-image">
    📦
</div>

<%

}

%>


<div>

<div class="product-name">

    <%=rs.getString("name")%>

</div>


<div class="product-id">

    Product ID #<%=rs.getInt("id")%>

</div>

</div>


</div>

</td>



<!-- OWNER -->

<td>

<div class="owner-name">

    <%=owner%>

</div>


<div class="owner-id">

    Owner ID #<%=rs.getInt("owner_id")%>

</div>

</td>



<!-- CATEGORY -->

<td>

<%=category%>

</td>



<!-- PRICE -->

<td>

<span class="price">

    ₹<%=rs.getInt("price")%>

</span>

</td>



<!-- DEPOSIT -->

<td>

<span class="deposit">

    ₹<%=rs.getInt("deposit")%>

</span>

</td>



<!-- STATUS -->

<td>

<span class="status-badge
             <%=statusClass%>">

    <%=status == null ? "Unknown" : status%>

</span>

</td>



<!-- AVAILABILITY -->

<td>

<span class="availability-badge">

    <%=availability%>

</span>

</td>



<!-- ACTIONS -->

<td>

<div class="actions">


<a
href="adminProductDetails.jsp?id=<%=rs.getInt("id")%>"
class="action-btn view-btn">

    View

</a>


<%

if(!"approved".equalsIgnoreCase(status)){

%>

<a
href="approveProduct?id=<%=rs.getInt("id")%>"
class="action-btn approve-btn">

    Approve

</a>

<%

}

if(!"rejected".equalsIgnoreCase(status)){

%>

<a
href="rejectProduct?id=<%=rs.getInt("id")%>"
class="action-btn reject-btn">

    Reject

</a>

<%

}

%>


<a
href="deleteProduct?id=<%=rs.getInt("id")%>"
class="action-btn delete-btn"

onclick="
return confirm(
'Are you sure you want to permanently delete this product?'
);
">

    Delete

</a>


</div>

</td>


</tr>


<%

    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){

    e.printStackTrace();

%>


<tr>

<td colspan="8">

<div class="error-box m-3">

    Unable to load products:
    <%=e.getMessage()%>

</div>

</td>

</tr>


<%

}

%>


</tbody>

</table>



<%

if(!hasProducts){

%>


<div class="empty-state"
     id="emptyProducts">


<div class="empty-icon">
    ✓
</div>


<h5>
    No Products Found
</h5>


<p class="mb-0">

    Product listings will appear here when users
    add products to RentEasy.

</p>


</div>


<%

}

%>


<div
class="empty-state"
id="searchEmpty"
style="display:none;">


<div class="empty-icon">
    🔍
</div>


<h5>
    No Matching Products
</h5>


<p class="mb-0">

    Try changing your search or status filter.

</p>


</div>


</div>

</div>


</div>

</div>



<!-- =====================================================
     SEARCH / FILTER
     ===================================================== -->

<script>

function filterProducts(){

    const search =
        document
        .getElementById("productSearch")
        .value
        .toLowerCase()
        .trim();


    const status =
        document
        .getElementById("statusFilter")
        .value
        .toLowerCase();


    const table =
        document.getElementById("productTable");


    const rows =
        table
        .getElementsByTagName("tbody")[0]
        .getElementsByTagName("tr");


    let visibleCount = 0;


    for(let i = 0; i < rows.length; i++){


        const row = rows[i];


        /*
         Ignore database error row
        */

        if(row.cells.length < 8){
            continue;
        }


        const rowText =
            row.innerText.toLowerCase();


        const rowStatus =
            (
                row.getAttribute("data-status")
                || ""
            ).toLowerCase();


        const matchesSearch =
            search === "" ||
            rowText.includes(search);


        const matchesStatus =
            status === "" ||
            rowStatus === status;


        if(matchesSearch &&
           matchesStatus){

            row.style.display = "";

            visibleCount++;

        }
        else{

            row.style.display = "none";
        }

    }


    const empty =
        document.getElementById(
            "searchEmpty"
        );


    if(empty){

        empty.style.display =
            visibleCount === 0
            ? "block"
            : "none";
    }

}

</script>


</body>
</html>