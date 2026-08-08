<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
/* =========================================================
   ADMIN SECURITY
   ========================================================= */

if (!"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   RENTAL ID VALIDATION
   ========================================================= */

String rentalIdParam = request.getParameter("rentalId");

if (rentalIdParam == null || rentalIdParam.trim().isEmpty()) {
    response.sendRedirect("adminSupport.jsp");
    return;
}

int rentalId;

try {
    rentalId = Integer.parseInt(rentalIdParam);
} catch (NumberFormatException e) {
    response.sendRedirect("adminSupport.jsp");
    return;
}
%>


<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Rental #<%=rentalId%> - RentEasy Admin</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>

/* =========================================================
   GLOBAL
   ========================================================= */

*{
    box-sizing:border-box;
}

body{
    margin:0;
    background:#f6f8fc;
    font-family:Inter,Segoe UI,Arial,sans-serif;
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

    background:#0f1b31;

    color:white;

    overflow-y:auto;

    z-index:1000;
}


.sidebar-brand{

    height:190px;

    padding:30px;

    border-bottom:1px solid rgba(255,255,255,.08);

    display:flex;

    align-items:flex-start;

    gap:15px;
}


.sidebar-brand img{

    width:52px;
    height:52px;

    object-fit:contain;

    background:white;

    border-radius:12px;

    padding:4px;
}


.sidebar-brand h4{

    margin:4px 0 2px;

    font-weight:700;

    font-size:22px;
}


.sidebar-brand small{

    color:#8fb3ea;

    letter-spacing:.7px;
}


.sidebar-menu{

    padding:22px 15px 40px;
}


.menu-heading{

    color:#7893bd;

    font-size:12px;

    font-weight:700;

    letter-spacing:1px;

    margin:25px 15px 10px;
}


.sidebar-link{

    display:flex;

    align-items:center;

    gap:15px;

    padding:14px 16px;

    margin:5px 0;

    color:#e5eaf3;

    text-decoration:none;

    border-radius:10px;

    font-weight:500;

    transition:.2s;
}


.sidebar-link i{

    width:20px;

    text-align:center;

    font-size:18px;
}


.sidebar-link:hover{

    background:#1e3a67;

    color:white;
}


.sidebar-link.active{

    background:#2f6fed;

    color:white;
}


/* =========================================================
   TOP NAVBAR
   ========================================================= */

.topbar{

    position:fixed;

    left:290px;
    right:0;
    top:0;

    height:82px;

    background:white;

    border-bottom:1px solid #e2e8f0;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 35px;

    z-index:900;
}


.top-left{

    display:flex;

    align-items:center;

    gap:15px;
}


.top-left img{

    width:35px;
    height:35px;

    object-fit:contain;
}


.top-left h4{

    color:#2563eb;

    font-weight:700;

    margin:0;
}


.admin-badge{

    background:#fff1f2;

    color:#dc2626;

    border:1px solid #fecaca;

    padding:7px 14px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


.top-right{

    display:flex;

    align-items:center;

    gap:16px;
}


.notification-btn{

    width:44px;
    height:44px;

    border:1px solid #e2e8f0;

    border-radius:12px;

    background:#f8fafc;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:19px;
}


.admin-avatar{

    width:44px;
    height:44px;

    background:#2563eb;

    color:white;

    border-radius:50%;

    display:flex;

    align-items:center;

    justify-content:center;

    font-weight:700;
}


.admin-info{

    line-height:1.3;
}


.admin-info strong{

    display:block;
}


.admin-info small{

    color:#64748b;
}


/* =========================================================
   MAIN
   ========================================================= */

.main{

    margin-left:290px;

    padding:120px 42px 60px;
}


.page-container{

    max-width:1450px;

    margin:auto;
}


/* =========================================================
   PAGE HEADER
   ========================================================= */

.back-link{

    color:#64748b;

    text-decoration:none;

    font-weight:500;

    display:inline-flex;

    align-items:center;

    gap:7px;

    margin-bottom:20px;
}


.back-link:hover{

    color:#2563eb;
}


.page-title-row{

    display:flex;

    justify-content:space-between;

    align-items:flex-start;

    margin-bottom:28px;
}


.page-title h1{

    font-size:32px;

    font-weight:750;

    margin-bottom:6px;
}


.page-title p{

    color:#64748b;

    margin:0;
}


.rental-number{

    background:#eaf2ff;

    color:#2563eb;

    padding:10px 18px;

    border-radius:20px;

    font-weight:700;
}


/* =========================================================
   CARDS
   ========================================================= */

.info-card{

    background:white;

    border:1px solid #e5eaf1;

    border-radius:16px;

    box-shadow:0 5px 18px rgba(15,23,42,.04);

    overflow:hidden;

    margin-bottom:24px;
}


.card-header-custom{

    padding:22px 25px;

    border-bottom:1px solid #edf0f5;

    display:flex;

    align-items:center;

    gap:13px;
}


.card-header-custom i{

    width:42px;
    height:42px;

    border-radius:10px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#edf4ff;

    color:#2563eb;

    font-size:20px;
}


.card-header-custom h5{

    margin:0;

    font-weight:700;
}


.card-header-custom small{

    color:#64748b;
}


.card-content{

    padding:25px;
}


/* =========================================================
   DETAIL ITEMS
   ========================================================= */

.detail-grid{

    display:grid;

    grid-template-columns:repeat(2,1fr);

    gap:22px 35px;
}


.detail-label{

    color:#64748b;

    font-size:13px;

    margin-bottom:5px;
}


.detail-value{

    font-weight:600;

    color:#111827;

    word-break:break-word;
}


/* =========================================================
   RENTAL SUMMARY
   ========================================================= */

.summary-grid{

    display:grid;

    grid-template-columns:repeat(4,1fr);

    gap:16px;

    margin-bottom:24px;
}


.summary-box{

    background:#f8fafc;

    border:1px solid #e7ebf1;

    border-radius:13px;

    padding:20px;
}


.summary-box span{

    display:block;

    color:#64748b;

    font-size:13px;

    margin-bottom:7px;
}


.summary-box strong{

    font-size:19px;
}


.money{

    color:#2563eb;
}


/* =========================================================
   STATUS
   ========================================================= */

.status-badge{

    display:inline-flex;

    align-items:center;

    padding:7px 12px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;

    text-transform:uppercase;
}


.status-paid{

    background:#e8faf1;

    color:#059669;
}


.status-pending{

    background:#fff7e6;

    color:#d97706;
}


.status-completed{

    background:#eaf2ff;

    color:#2563eb;
}


.status-default{

    background:#f1f5f9;

    color:#475569;
}


/* =========================================================
   DELIVERY
   ========================================================= */

.delivery-box{

    background:#f8fafc;

    border:1px solid #e2e8f0;

    border-radius:14px;

    padding:22px;

    height:100%;
}


.delivery-icon{

    width:44px;
    height:44px;

    border-radius:12px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#eaf2ff;

    color:#2563eb;

    font-size:21px;

    margin-bottom:15px;
}


.delivery-box h6{

    font-weight:700;
}


.delivery-box p{

    color:#475569;

    margin-bottom:7px;
}


/* =========================================================
   ACTIONS
   ========================================================= */

.action-card{

    background:white;

    border:1px solid #e5eaf1;

    border-radius:16px;

    padding:24px;

    margin-top:24px;
}


.action-card h5{

    font-weight:700;
}


.btn-action{

    padding:11px 18px;

    border-radius:9px;

    font-weight:600;
}


/* =========================================================
   ERROR
   ========================================================= */

.error-box{

    background:#fff1f2;

    border:1px solid #fecdd3;

    color:#be123c;

    border-radius:12px;

    padding:18px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1000px){

    .sidebar{
        width:230px;
    }

    .topbar{
        left:230px;
    }

    .main{
        margin-left:230px;
        padding-left:25px;
        padding-right:25px;
    }

    .summary-grid{
        grid-template-columns:repeat(2,1fr);
    }

}


@media(max-width:768px){

    .sidebar{
        display:none;
    }

    .topbar{
        left:0;
    }

    .main{
        margin-left:0;
    }

    .detail-grid{
        grid-template-columns:1fr;
    }

    .summary-grid{
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

            <small>ADMINISTRATION</small>

        </div>

    </div>


    <div class="sidebar-menu">


        <a href="adminDashboard.jsp"
           class="sidebar-link">

            <i class="bi bi-grid-fill"></i>

            Dashboard

        </a>


        <div class="menu-heading">
            MANAGEMENT
        </div>


        <a href="adminUsers.jsp"
           class="sidebar-link">

            <i class="bi bi-people"></i>

            Users

        </a>


        <a href="adminOwners.jsp"
           class="sidebar-link">

            <i class="bi bi-shop"></i>

            Owners

        </a>


        <a href="adminProducts.jsp"
           class="sidebar-link">

            <i class="bi bi-box-seam"></i>

            Products

        </a>


        <a href="adminRentals.jsp"
           class="sidebar-link active">

            <i class="bi bi-arrow-repeat"></i>

            Rentals

        </a>


        <div class="menu-heading">
            RETURN & PAYMENTS
        </div>


        <a href="adminReturnRequests.jsp"
           class="sidebar-link">

            <i class="bi bi-arrow-return-left"></i>

            Return Requests

        </a>


        <a href="adminReturns.jsp"
           class="sidebar-link">

            <i class="bi bi-box-arrow-in-left"></i>

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


        <div class="menu-heading">
            VERIFICATION
        </div>


        <a href="adminKyc.jsp"
           class="sidebar-link">

            <i class="bi bi-person-check"></i>

            KYC Verification

        </a>


        <div class="menu-heading">
            SUPPORT
        </div>


        <a href="adminSupport.jsp"
           class="sidebar-link">

            <i class="bi bi-headset"></i>

            Customer Support

        </a>


        <a href="logout"
           class="sidebar-link">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>


    </div>

</div>



<!-- =========================================================
     TOPBAR
     ========================================================= -->

<div class="topbar">


    <div class="top-left">

        <img src="images/logo.png.jpeg">

        <h4>RentEasy</h4>

        <span class="admin-badge">
            ADMIN PANEL
        </span>

    </div>


    <div class="top-right">


        <button class="notification-btn">

            <i class="bi bi-bell"></i>

        </button>


        <div class="admin-avatar">
            A
        </div>


        <div class="admin-info">

            <strong>Administrator</strong>

            <small>
                <%= session.getAttribute("email") != null
                    ? session.getAttribute("email")
                    : "renteasy.project@gmail.com" %>
            </small>

        </div>


    </div>

</div>



<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<div class="main">

<div class="page-container">


<a href="javascript:history.back()"
   class="back-link">

    <i class="bi bi-arrow-left"></i>

    Back to Customer Support

</a>


<div class="page-title-row">

    <div class="page-title">

        <h1>Rental Information</h1>

        <p>
            Complete rental, customer, owner and delivery
            information for this transaction.
        </p>

    </div>


    <div class="rental-number">

        Rental #<%=rentalId%>

    </div>

</div>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");


    con = DriverManager.getConnection(

        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"

    );


    /*
     * IMPORTANT:
     *
     * users table:
     * id
     * first_name
     * last_name
     * email
     * phone
     *
     * Therefore we DO NOT use:
     *
     * u.name
     * u.username
     *
     * KYC is connected using EMAIL.
     */


    String sql =

        "SELECT " +

        "r.*, " +

        /* CUSTOMER */
        "CONCAT(u.first_name,' ',u.last_name) AS renter, " +
        "u.email AS renter_email, " +
        "u.phone AS renter_phone, " +

        /* OWNER */
        "CONCAT(o.first_name,' ',o.last_name) AS owner_name, " +
        "o.email AS owner_email, " +
        "o.phone AS owner_phone, " +

        /* PRODUCT */
        /* PRODUCT */
"p.name AS product_name, " +
"p.image AS product_image, " +
"p.location AS product_location, " +
"p.pincode AS product_pincode, " +
"p.latitude AS product_latitude, " +
"p.longitude AS product_longitude, " +

        /* USER KYC */
        "ku.address AS user_address, " +
        "ku.mobile AS user_mobile, " +

        /* OWNER KYC */
        "ko.address AS owner_address, " +
        "ko.mobile AS owner_mobile " +

        "FROM rentals r " +

        "JOIN users u " +
        "ON r.user_id = u.id " +

        "JOIN users o " +
        "ON r.owner_id = o.id " +

        "JOIN products p " +
        "ON r.product_id = p.id " +

        "LEFT JOIN kyc ku " +
        "ON ku.email = u.email " +

        "LEFT JOIN kyc ko " +
        "ON ko.email = o.email " +

        "WHERE r.rental_id = ?";


    ps = con.prepareStatement(sql);

    ps.setInt(1, rentalId);


    rs = ps.executeQuery();


    if (rs.next()) {
		
    	String productLocation = rs.getString("product_location");
    	String productPincode = rs.getString("product_pincode");

    	String productLatitude = rs.getString("product_latitude");
    	String productLongitude = rs.getString("product_longitude");

        String renter =
            rs.getString("renter");


        String renterEmail =
            rs.getString("renter_email");


        String renterPhone =
            rs.getString("renter_phone");


        String userAddress =
            rs.getString("user_address");


        String userMobile =
            rs.getString("user_mobile");


        String ownerName =
            rs.getString("owner_name");


        String ownerEmail =
            rs.getString("owner_email");


        String ownerPhone =
            rs.getString("owner_phone");


        String ownerAddress =
            rs.getString("owner_address");


        String ownerMobile =
            rs.getString("owner_mobile");


        String productName =
            rs.getString("product_name");


        String productImage =
            rs.getString("product_image");


        String paymentStatus =
            rs.getString("payment_status");


        String rentalStatus =
            rs.getString("rental_status");


        double rentAmount =
            rs.getDouble("rent_amount");


        double securityDeposit =
            rs.getDouble("security_deposit");


        Date startDate =
            rs.getDate("start_date");


        Date endDate =
            rs.getDate("end_date");


        /* fallback phone */
        if(userMobile == null ||
           userMobile.trim().isEmpty()){

            userMobile = renterPhone;
        }


        if(ownerMobile == null ||
           ownerMobile.trim().isEmpty()){

            ownerMobile = ownerPhone;
        }

%>



<!-- =========================================================
     RENTAL SUMMARY
     ========================================================= -->

<div class="info-card">


    <div class="card-header-custom">

        <i class="bi bi-receipt"></i>

        <div>

            <h5>Rental Summary</h5>

            <small>
                Transaction and payment information
            </small>

        </div>

    </div>


    <div class="card-content">


        <div class="summary-grid">


            <div class="summary-box">

                <span>Rent Amount</span>

                <strong class="money">
                    ₹<%=String.format("%.2f",rentAmount)%>
                </strong>

            </div>


            <div class="summary-box">

                <span>Security Deposit</span>

                <strong>
                    ₹<%=String.format("%.2f",securityDeposit)%>
                </strong>

            </div>


            <div class="summary-box">

                <span>Payment Status</span>

                <strong>

                <%

                if("PAID".equalsIgnoreCase(paymentStatus)){

                %>

                    <span class="status-badge status-paid">
                        <i class="bi bi-check-circle me-1"></i>
                        PAID
                    </span>

                <%

                } else {

                %>

                    <span class="status-badge status-pending">
                        <%=paymentStatus != null
                           ? paymentStatus
                           : "PENDING"%>
                    </span>

                <%

                }

                %>

                </strong>

            </div>


            <div class="summary-box">

                <span>Rental Status</span>

                <strong>

                    <span class="status-badge status-completed">

                        <%=rentalStatus != null
                           ? rentalStatus
                           : "N/A"%>

                    </span>

                </strong>

            </div>


        </div>



        <div class="detail-grid">


            <div>

                <div class="detail-label">
                    Rental ID
                </div>

                <div class="detail-value">
                    #<%=rentalId%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Product
                </div>

                <div class="detail-value">
                    <%=productName%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Rental Start Date
                </div>

                <div class="detail-value">
                    <%=startDate%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Rental End Date
                </div>

                <div class="detail-value">
                    <%=endDate%>
                </div>

            </div>


        </div>


    </div>

</div>



<!-- =========================================================
     CUSTOMER + OWNER
     ========================================================= -->

<div class="row">


<!-- CUSTOMER -->

<div class="col-lg-6">

<div class="info-card h-100">


    <div class="card-header-custom">

        <i class="bi bi-person"></i>

        <div>

            <h5>Customer Details</h5>

            <small>
                User who rented this product
            </small>

        </div>

    </div>


    <div class="card-content">


        <div class="detail-grid">


            <div>

                <div class="detail-label">
                    Full Name
                </div>

                <div class="detail-value">
                    <%=renter%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    User ID
                </div>

                <div class="detail-value">
                    #<%=rs.getInt("user_id")%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Email Address
                </div>

                <div class="detail-value">
                    <%=renterEmail%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Mobile Number
                </div>

                <div class="detail-value">

                    <%=userMobile != null
                       ? userMobile
                       : "Not available"%>

                </div>

            </div>


            <div style="grid-column:1/-1;">

                <div class="detail-label">
                    KYC Address
                </div>

                <div class="detail-value">

                    <%=userAddress != null
                       ? userAddress
                       : "KYC address not available"%>

                </div>

            </div>


        </div>


    </div>

</div>

</div>



<!-- OWNER -->

<div class="col-lg-6">

<div class="info-card h-100">


    <div class="card-header-custom">

        <i class="bi bi-shop"></i>

        <div>

            <h5>Owner Details</h5>

            <small>
                Product owner information
            </small>

        </div>

    </div>


    <div class="card-content">


        <div class="detail-grid">


            <div>

                <div class="detail-label">
                    Full Name
                </div>

                <div class="detail-value">
                    <%=ownerName%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Owner ID
                </div>

                <div class="detail-value">
                    #<%=rs.getInt("owner_id")%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Email Address
                </div>

                <div class="detail-value">
                    <%=ownerEmail%>
                </div>

            </div>


            <div>

                <div class="detail-label">
                    Mobile Number
                </div>

                <div class="detail-value">

                    <%=ownerMobile != null
                       ? ownerMobile
                       : "Not available"%>

                </div>

            </div>


            <div style="grid-column:1/-1;">

                <div class="detail-label">
                    KYC Address
                </div>

                <div class="detail-value">

                    <%=ownerAddress != null
                       ? ownerAddress
                       : "KYC address not available"%>

                </div>

            </div>


        </div>


    </div>

</div>

</div>

</div>



<!-- =========================================================
     SELF PICKUP INFORMATION
     ========================================================= -->

<div class="info-card mt-4">

    <div class="card-header-custom">

        <i class="bi bi-geo-alt"></i>

        <div>
            <h5>Self Pickup Information</h5>
            <small>
                Product pickup location and customer address
            </small>
        </div>

    </div>


    <div class="card-content">

        <div class="row g-4">


            <!-- PRODUCT PICKUP LOCATION -->

            <div class="col-lg-6">

                <div class="delivery-box">

                    <div class="delivery-icon">
                        <i class="bi bi-box-seam"></i>
                    </div>

                    <h6>Product Pickup Location</h6>

                    <p>
                        <strong><%=productName%></strong>
                    </p>

                    <p>
                        <i class="bi bi-person me-2"></i>
                        Owner: <%=ownerName%>
                    </p>

                    <p>
                        <i class="bi bi-geo-alt me-2"></i>

                        <%=productLocation != null
                           ? productLocation
                           : "Product location unavailable"%>
                    </p>

                    <%
                    if(productPincode != null &&
                       !productPincode.trim().isEmpty()){
                    %>

                    <p>
                        <i class="bi bi-mailbox me-2"></i>
                        Pincode: <%=productPincode%>
                    </p>

                    <%
                    }
                    %>


                    <!-- GOOGLE MAP BUTTON -->

                    <%
                    if(productLatitude != null &&
                       productLongitude != null &&
                       !productLatitude.trim().isEmpty() &&
                       !productLongitude.trim().isEmpty()){
                    %>

                    <a
                       href="https://www.google.com/maps/search/?api=1&query=<%=productLatitude%>,<%=productLongitude%>"
                       target="_blank"
                       class="btn btn-outline-primary mt-3">

                        <i class="bi bi-map me-1"></i>
                        View Product Location

                    </a>

                    <%
                    }
                    %>

                </div>

            </div>



            <!-- CUSTOMER INFORMATION -->

            <div class="col-lg-6">

                <div class="delivery-box">

                    <div class="delivery-icon">
                        <i class="bi bi-person-check"></i>
                    </div>

                    <h6>Customer Information</h6>

                    <p>
                        <strong><%=renter%></strong>
                    </p>

                    <p>
                        <i class="bi bi-geo-alt me-2"></i>

                        KYC Address:
                        <%=userAddress != null
                           ? userAddress
                           : "Address unavailable"%>
                    </p>

                    <p>
                        <i class="bi bi-telephone me-2"></i>

                        <%=userMobile != null
                           ? userMobile
                           : "Phone unavailable"%>
                    </p>

                    <div class="alert alert-primary mt-3 mb-0">

                        <i class="bi bi-info-circle me-1"></i>

                        <strong>Self Pickup</strong><br>

                        Customer collects the product directly
                        from the product pickup location.

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>



<!-- =========================================================
     ADMIN ACTIONS
     ========================================================= -->

<div class="action-card">


    <div class="d-flex
                justify-content-between
                align-items-center
                flex-wrap
                gap-3">


        <div>

            <h5 class="mb-1">
                Admin Actions
            </h5>

            <small class="text-muted">

                Manage this rental transaction.

            </small>

        </div>


        <div class="d-flex gap-2 flex-wrap">


            <a href="adminSupport.jsp?email=<%=renterEmail%>&tab=rentals"
               class="btn btn-outline-secondary btn-action">

                <i class="bi bi-arrow-left me-1"></i>

                Customer Profile

            </a>


            <a href="approveReturn?id=<%=rentalId%>"
               class="btn btn-primary btn-action">

                <i class="bi bi-check-circle me-1"></i>

                Approve Return

            </a>


            <a href="forwardToEcart.jsp?rentalId=<%=rentalId%>"
               class="btn btn-success btn-action">

                <i class="bi bi-truck me-1"></i>

                Forward To E-Cart

            </a>


        </div>


    </div>


</div>


<%

    } else {

%>


<div class="error-box">

    <i class="bi bi-exclamation-triangle me-2"></i>

    Rental #<%=rentalId%> could not be found.

</div>


<%

    }


} catch(Exception e) {

    e.printStackTrace();

%>


<div class="error-box">

    <strong>
        <i class="bi bi-exclamation-triangle me-2"></i>
        Unable to load rental information
    </strong>

    <div class="mt-2">
        <%=e.getMessage()%>
    </div>

</div>


<%

} finally {


    try {

        if(rs != null)
            rs.close();

    } catch(Exception ignored) {}


    try {

        if(ps != null)
            ps.close();

    } catch(Exception ignored) {}


    try {

        if(con != null)
            con.close();

    } catch(Exception ignored) {}

}

%>


</div>

</div>


</body>

</html>