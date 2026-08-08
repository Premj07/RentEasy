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
   PRODUCT ID
   ========================================================= */

String idParam = request.getParameter("id");

if(idParam == null || idParam.trim().isEmpty()){
    response.sendRedirect("adminProducts.jsp");
    return;
}

int productId;

try{

    productId = Integer.parseInt(idParam);

}catch(NumberFormatException e){

    response.sendRedirect("adminProducts.jsp");
    return;
}


/* =========================================================
   DATABASE VARIABLES
   ========================================================= */

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

boolean productFound = false;

String productName = "";
String image = "";
String owner = "";
String description = "";
String location = "";
String pincode = "";
String category = "";
String status = "";
String productType = "";
String listingType = "";
String availability = "";

int ownerId = 0;
int price = 0;
int deposit = 0;
int actualPrice = 0;

double sellingPrice = 0;
double latitude = 0;
double longitude = 0;


try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    ps = con.prepareStatement(

        "SELECT " +

        "id, " +
        "name, " +
        "price, " +
        "image, " +
        "owner, " +
        "owner_id, " +
        "description, " +
        "location, " +
        "pincode, " +
        "category, " +
        "status, " +
        "deposit, " +
        "actual_price, " +
        "product_type, " +
        "listing_type, " +
        "selling_price, " +
        "latitude, " +
        "longitude, " +
        "availability " +

        "FROM products " +

        "WHERE id=?"

    );


    ps.setInt(1, productId);

    rs = ps.executeQuery();


    if(rs.next()){

        productFound = true;

        productName = rs.getString("name");
        price = rs.getInt("price");
        image = rs.getString("image");

        owner = rs.getString("owner");
        ownerId = rs.getInt("owner_id");

        description = rs.getString("description");

        location = rs.getString("location");
        pincode = rs.getString("pincode");

        category = rs.getString("category");
        status = rs.getString("status");

        deposit = rs.getInt("deposit");
        actualPrice = rs.getInt("actual_price");

        productType = rs.getString("product_type");
        listingType = rs.getString("listing_type");

        sellingPrice = rs.getDouble("selling_price");

        latitude = rs.getDouble("latitude");
        longitude = rs.getDouble("longitude");

        availability = rs.getString("availability");
    }

}catch(Exception e){

    e.printStackTrace();

}finally{

    try{
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
    catch(Exception ignored){}
}


if(!productFound){

    response.sendRedirect(
        "adminProducts.jsp?error=product_not_found"
    );

    return;
}


/* =========================================================
   NULL PROTECTION
   ========================================================= */

if(productName == null) productName = "-";
if(owner == null || owner.trim().isEmpty())
    owner = "Owner #" + ownerId;

if(description == null || description.trim().isEmpty())
    description = "No description provided.";

if(location == null || location.trim().isEmpty())
    location = "-";

if(pincode == null || pincode.trim().isEmpty())
    pincode = "-";

if(category == null || category.trim().isEmpty())
    category = "-";

if(status == null)
    status = "Unknown";

if(productType == null || productType.trim().isEmpty())
    productType = "-";

if(listingType == null || listingType.trim().isEmpty())
    listingType = "-";

if(availability == null || availability.trim().isEmpty())
    availability = "-";


/* =========================================================
   STATUS CLASS
   ========================================================= */

String statusClass = "status-rejected";

if("approved".equalsIgnoreCase(status)){

    statusClass = "status-approved";

}
else if("pending".equalsIgnoreCase(status)){

    statusClass = "status-pending";
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>
<%=productName%> - RentEasy Admin
</title>

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

    gap:16px;
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
}


.admin-info strong{

    display:block;

    font-size:15px;
}


.admin-info span{

    display:block;

    color:#64748b;

    font-size:12px;

    margin-top:2px;
}


/* =========================================================
   MAIN
   ========================================================= */

.main{

    margin-left:290px;

    padding:
        122px
        42px
        60px;
}


.page-container{

    max-width:1400px;

    margin:auto;
}


.page-header{

    display:flex;

    justify-content:space-between;

    align-items:flex-start;

    margin-bottom:26px;
}


.page-title{

    font-size:31px;

    font-weight:750;

    margin:0;
}


.page-subtitle{

    color:#64748b;

    margin-top:6px;
}


.back-btn{

    text-decoration:none;

    border:1px solid #dbe3ef;

    background:white;

    color:#334155;

    padding:10px 16px;

    border-radius:9px;

    font-weight:600;
}


.back-btn:hover{

    background:#f8fafc;

    color:#2563eb;
}


/* =========================================================
   PRODUCT HERO
   ========================================================= */

.product-hero{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    padding:28px;

    display:grid;

    grid-template-columns:
        300px 1fr;

    gap:32px;

    box-shadow:
        0 5px 20px rgba(15,23,42,.04);
}


.image-wrapper{

    height:290px;

    border:1px solid #e2e8f0;

    border-radius:14px;

    background:#f8fafc;

    display:flex;

    align-items:center;

    justify-content:center;

    overflow:hidden;
}


.product-image{

    width:100%;
    height:100%;

    object-fit:contain;

    padding:12px;
}


.no-image{

    text-align:center;

    color:#94a3b8;
}


.no-image-icon{

    font-size:60px;

    margin-bottom:10px;
}


.hero-content{

    display:flex;

    flex-direction:column;

    justify-content:center;
}


.product-id{

    color:#64748b;

    font-size:13px;

    margin-bottom:8px;
}


.product-name{

    font-size:31px;

    font-weight:750;

    margin-bottom:12px;
}


.badges{

    display:flex;

    gap:8px;

    flex-wrap:wrap;

    margin-bottom:22px;
}


.status-badge{

    padding:7px 12px;

    border-radius:20px;

    font-size:12px;

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


.simple-badge{

    background:#eff6ff;

    color:#2563eb;

    padding:7px 12px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


.product-description{

    color:#64748b;

    line-height:1.7;

    max-width:750px;
}


/* =========================================================
   PRICE SUMMARY
   ========================================================= */

.price-grid{

    display:grid;

    grid-template-columns:
        repeat(3,1fr);

    gap:16px;

    margin-top:25px;
}


.price-box{

    padding:17px;

    background:#f8fafc;

    border-radius:12px;

    border:1px solid #edf2f7;
}


.price-label{

    color:#64748b;

    font-size:12px;

    margin-bottom:6px;
}


.price-value{

    font-size:20px;

    font-weight:750;

    color:#0f172a;
}


.deposit-value{

    color:#2563eb;
}


/* =========================================================
   CONTENT GRID
   ========================================================= */

.content-grid{

    display:grid;

    grid-template-columns:
        1.4fr .8fr;

    gap:24px;

    margin-top:24px;
}


.info-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:16px;

    padding:25px;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.card-title{

    font-size:19px;

    font-weight:700;

    margin-bottom:20px;
}


.detail-row{

    display:flex;

    justify-content:space-between;

    align-items:center;

    padding:14px 0;

    border-bottom:1px solid #edf2f7;

    gap:20px;
}


.detail-row:last-child{

    border-bottom:none;
}


.detail-label{

    color:#64748b;

    font-size:14px;
}


.detail-value{

    font-weight:650;

    color:#0f172a;

    text-align:right;
}


/* =========================================================
   OWNER
   ========================================================= */

.owner-profile{

    display:flex;

    align-items:center;

    gap:15px;

    padding-bottom:20px;

    border-bottom:1px solid #edf2f7;
}


.owner-avatar{

    width:54px;
    height:54px;

    border-radius:50%;

    background:#eaf1ff;

    color:#2563eb;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:20px;

    font-weight:700;
}


.owner-name{

    font-size:17px;

    font-weight:700;
}


.owner-id{

    color:#64748b;

    font-size:12px;

    margin-top:3px;
}


.owner-button{

    display:block;

    margin-top:20px;

    width:100%;

    text-align:center;

    padding:10px;

    border:1px solid #bfdbfe;

    color:#2563eb;

    text-decoration:none;

    border-radius:9px;

    font-weight:600;
}


.owner-button:hover{

    background:#eff6ff;
}


/* =========================================================
   ADMIN ACTIONS
   ========================================================= */

.action-card{

    margin-top:24px;

    background:white;

    border:1px solid #e2e8f0;

    border-radius:16px;

    padding:25px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.action-title{

    font-size:18px;

    font-weight:700;
}


.action-description{

    color:#64748b;

    font-size:13px;

    margin-top:5px;
}


.action-buttons{

    display:flex;

    gap:10px;
}


.action-btn{

    text-decoration:none;

    padding:11px 18px;

    border-radius:9px;

    font-size:13px;

    font-weight:700;
}


.approve-btn{

    background:#059669;

    color:white;
}


.approve-btn:hover{

    background:#047857;

    color:white;
}


.reject-btn{

    background:#fff7ed;

    border:1px solid #fed7aa;

    color:#c2410c;
}


.reject-btn:hover{

    background:#ea580c;

    color:white;
}


.delete-btn{

    background:#fff1f2;

    border:1px solid #fecdd3;

    color:#dc2626;
}


.delete-btn:hover{

    background:#dc2626;

    color:white;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1100px){

    .product-hero{

        grid-template-columns:1fr;
    }

    .image-wrapper{

        max-width:400px;
    }

    .content-grid{

        grid-template-columns:1fr;
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

    <img src="images/logo.png.jpeg">

    <div>

        <h4>RentEasy</h4>

        <small>
            ADMINISTRATION
        </small>

    </div>

</div>


<div class="sidebar-nav">


<a href="adminDashboard.jsp">

    <span class="nav-icon">
        ▦
    </span>

    Dashboard

</a>


<div class="nav-section">
MANAGEMENT
</div>


<a href="adminUsers.jsp">

    <span class="nav-icon">
        ♧
    </span>

    Users

</a>


<a href="adminOwners.jsp">

    <span class="nav-icon">
        ▥
    </span>

    Owners

</a>


<a href="adminProducts.jsp"
   class="active">

    <span class="nav-icon">
        ⬡
    </span>

    Products

</a>


<a href="adminRentals.jsp">

    <span class="nav-icon">
        ⟳
    </span>

    Rentals

</a>


<div class="nav-section">
RETURN & PAYMENTS
</div>


<a href="adminReturnRequests.jsp">

    <span class="nav-icon">
        ↩
    </span>

    Return Requests

</a>


<a href="adminReturns.jsp">

    <span class="nav-icon">
        ⇥
    </span>

    Returns

</a>


<a href="adminRefund.jsp">

    <span class="nav-icon">
        ◉
    </span>

    Refunds

</a>


<a href="adminPayments.jsp">

    <span class="nav-icon">
        ▣
    </span>

    Payments

</a>


<div class="nav-section">
VERIFICATION
</div>


<a href="adminKyc.jsp">

    <span class="nav-icon">
        ♙
    </span>

    KYC Verification

</a>


<div class="nav-section">
ACCOUNT
</div>


<a href="logout">

    <span class="nav-icon">
        ↪
    </span>

    Logout

</a>


</div>

</div>



<!-- =========================================================
     TOPBAR
     ========================================================= -->

<div class="topbar">


<div class="topbar-brand">

    <img src="images/logo.png.jpeg">

    <h3>
        RentEasy
    </h3>

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
        <%=session.getAttribute("email")%>
    </span>

</div>


</div>

</div>



<!-- =========================================================
     MAIN
     ========================================================= -->

<div class="main">

<div class="page-container">


<!-- PAGE HEADER -->

<div class="page-header">


<div>

<h1 class="page-title">
    Product Details
</h1>


<div class="page-subtitle">

    Review complete product listing information
    and manage approval status.

</div>

</div>


<a href="adminProducts.jsp"
   class="back-btn">

    ← Back to Products

</a>


</div>



<!-- =========================================================
     PRODUCT HERO
     ========================================================= -->

<div class="product-hero">


<!-- IMAGE -->

<div class="image-wrapper">


<%

if(image != null &&
   !image.trim().isEmpty()){

%>

<img
src="<%=request.getContextPath()%>/<%=image%>"
class="product-image"
alt="<%=productName%>"

onerror="
this.style.display='none';
document.getElementById('imageFallback').style.display='block';
">


<div
id="imageFallback"
class="no-image"
style="display:none;">

<div class="no-image-icon">
    📦
</div>

Image unavailable

</div>


<%

}
else{

%>


<div class="no-image">

<div class="no-image-icon">
    📦
</div>

No product image

</div>


<%

}

%>


</div>



<!-- PRODUCT INFORMATION -->

<div class="hero-content">


<div class="product-id">

    PRODUCT ID #<%=productId%>

</div>


<div class="product-name">

    <%=productName%>

</div>



<div class="badges">


<span class="status-badge <%=statusClass%>">

    <%=status%>

</span>


<span class="simple-badge">

    <%=category%>

</span>


<span class="simple-badge">

    <%=availability%>

</span>


<span class="simple-badge">

    <%=listingType%>

</span>


</div>



<div class="product-description">

    <%=description%>

</div>



<!-- PRICE SUMMARY -->

<div class="price-grid">


<div class="price-box">

<div class="price-label">

    Rental Price / Day

</div>

<div class="price-value">

    ₹<%=price%>

</div>

</div>



<div class="price-box">

<div class="price-label">

    Security Deposit

</div>

<div class="price-value deposit-value">

    ₹<%=deposit%>

</div>

</div>



<div class="price-box">

<div class="price-label">

    Actual Product Value

</div>

<div class="price-value">

    ₹<%=actualPrice%>

</div>

</div>


</div>


</div>


</div>



<!-- =========================================================
     DETAILS
     ========================================================= -->

<div class="content-grid">


<!-- PRODUCT INFORMATION -->

<div class="info-card">


<div class="card-title">

    Product Information

</div>



<div class="detail-row">

<span class="detail-label">
Category
</span>

<span class="detail-value">
<%=category%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Product Type
</span>

<span class="detail-value">
<%=productType%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Listing Type
</span>

<span class="detail-value">
<%=listingType%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Availability
</span>

<span class="detail-value">
<%=availability%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Rental Price
</span>

<span class="detail-value">
₹<%=price%> / day
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Security Deposit
</span>

<span class="detail-value">
₹<%=deposit%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Actual Price
</span>

<span class="detail-value">
₹<%=actualPrice%>
</span>

</div>



<%

if(sellingPrice > 0){

%>

<div class="detail-row">

<span class="detail-label">
Selling Price
</span>

<span class="detail-value">
₹<%=String.format("%.2f",sellingPrice)%>
</span>

</div>

<%

}

%>


</div>



<!-- OWNER INFORMATION -->

<div class="info-card">


<div class="card-title">

    Product Owner

</div>


<div class="owner-profile">


<div class="owner-avatar">

<%
if(owner != null &&
   !owner.trim().isEmpty()){
%>

<%=owner.substring(0,1).toUpperCase()%>

<%
}else{
%>

O

<%
}
%>

</div>



<div>

<div class="owner-name">

    <%=owner%>

</div>

<div class="owner-id">

    Owner ID #<%=ownerId%>

</div>

</div>


</div>



<div class="detail-row">

<span class="detail-label">
Owner ID
</span>

<span class="detail-value">
#<%=ownerId%>
</span>

</div>



<div class="detail-row">

<span class="detail-label">
Total Product
</span>

<span class="detail-value">
#<%=productId%>
</span>

</div>



<a
href="adminOwnerDetails.jsp?id=<%=ownerId%>"
class="owner-button">

    View Owner Profile →

</a>


</div>


</div>



<!-- =========================================================
     LOCATION
     ========================================================= -->

<div class="content-grid">


<div class="info-card">


<div class="card-title">

    Location Information

</div>


<div class="detail-row">

<span class="detail-label">
Location
</span>

<span class="detail-value">
<%=location%>
</span>

</div>


<div class="detail-row">

<span class="detail-label">
Pincode
</span>

<span class="detail-value">
<%=pincode%>
</span>

</div>


<div class="detail-row">

<span class="detail-label">
Latitude
</span>

<span class="detail-value">
<%=latitude%>
</span>

</div>


<div class="detail-row">

<span class="detail-label">
Longitude
</span>

<span class="detail-value">
<%=longitude%>
</span>

</div>


</div>



<!-- LISTING STATUS -->

<div class="info-card">


<div class="card-title">

    Listing Status

</div>


<div class="detail-row">

<span class="detail-label">
Approval Status
</span>

<span class="status-badge <%=statusClass%>">

    <%=status%>

</span>

</div>


<div class="detail-row">

<span class="detail-label">
Availability
</span>

<span class="detail-value">
<%=availability%>
</span>

</div>


<div class="detail-row">

<span class="detail-label">
Listing Type
</span>

<span class="detail-value">
<%=listingType%>
</span>

</div>


<div class="detail-row">

<span class="detail-label">
Product Type
</span>

<span class="detail-value">
<%=productType%>
</span>

</div>


</div>


</div>



<!-- =========================================================
     ADMIN ACTIONS
     ========================================================= -->

<div class="action-card">


<div>

<div class="action-title">

    Admin Product Controls

</div>


<div class="action-description">

    Approve, reject or permanently remove this
    product listing.

</div>

</div>



<div class="action-buttons">


<%

if(!"approved".equalsIgnoreCase(status)){

%>

<a
href="approveProduct?id=<%=productId%>"
class="action-btn approve-btn"

onclick="
return confirm(
'Approve this product listing?'
);
">

    ✓ Approve Product

</a>

<%

}

%>



<%

if(!"rejected".equalsIgnoreCase(status)){

%>

<a
href="rejectProduct?id=<%=productId%>"
class="action-btn reject-btn"

onclick="
return confirm(
'Reject this product listing?'
);
">

    Reject Product

</a>

<%

}

%>



<a
href="deleteProduct?id=<%=productId%>"
class="action-btn delete-btn"

onclick="
return confirm(
'Are you sure you want to permanently delete this product? This action cannot be undone.'
);
">

    Delete Product

</a>


</div>


</div>


</div>

</div>


</body>

</html>  