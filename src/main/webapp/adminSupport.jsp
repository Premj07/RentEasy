<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* =========================================================
   ADMIN SECURITY
   ========================================================= */

if(!"ADMIN".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   SEARCH VARIABLES
   ========================================================= */

String searchEmail = request.getParameter("email");

String activeTab = request.getParameter("tab");

if(activeTab == null || activeTab.trim().isEmpty()){
    activeTab = "overview";
}

boolean searched = false;
boolean userFound = false;

int userId = 0;

String firstName = "";
String lastName = "";
String email = "";
String phone = "";

String kycStatus = "Not Submitted";

int rentalCount = 0;
int productCount = 0;

Connection con = null;


/* =========================================================
   SEARCH ACCOUNT
   ========================================================= */

if(searchEmail != null &&
   !searchEmail.trim().isEmpty()){

    searched = true;

    try{

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"
        );


        /* =================================================
           GET USER
           ================================================= */

        PreparedStatement userPs =
            con.prepareStatement(

                "SELECT id, first_name, last_name, email, phone " +
                "FROM users " +
                "WHERE LOWER(email)=LOWER(?)"
            );

        userPs.setString(
            1,
            searchEmail.trim()
        );

        ResultSet userRs =
            userPs.executeQuery();


        if(userRs.next()){

            userFound = true;

            userId =
                userRs.getInt("id");

            firstName =
                userRs.getString("first_name");

            lastName =
                userRs.getString("last_name");

            email =
                userRs.getString("email");

            phone =
                userRs.getString("phone");
        }


        userRs.close();
        userPs.close();



        /* =================================================
           LOAD EXTRA INFORMATION
           ================================================= */

        if(userFound){


            /* ---------------------------------------------
               KYC STATUS
               --------------------------------------------- */

            PreparedStatement kycPs =
                con.prepareStatement(

                    "SELECT status " +
                    "FROM kyc " +
                    "WHERE LOWER(email)=LOWER(?) " +
                    "LIMIT 1"
                );

            kycPs.setString(
                1,
                email
            );

            ResultSet kycRs =
                kycPs.executeQuery();


            if(kycRs.next()){

                String value =
                    kycRs.getString("status");

                if(value != null &&
                   !value.trim().isEmpty()){

                    kycStatus = value;
                }
            }


            kycRs.close();
            kycPs.close();



            /* ---------------------------------------------
               RENTAL COUNT
               --------------------------------------------- */

            PreparedStatement rentalPs =
                con.prepareStatement(

                    "SELECT COUNT(*) " +
                    "FROM rentals " +
                    "WHERE user_id=?"
                );

            rentalPs.setInt(
                1,
                userId
            );

            ResultSet rentalRs =
                rentalPs.executeQuery();


            if(rentalRs.next()){

                rentalCount =
                    rentalRs.getInt(1);
            }


            rentalRs.close();
            rentalPs.close();



            /* ---------------------------------------------
               OWNER PRODUCT COUNT
               --------------------------------------------- */

            PreparedStatement productPs =
                con.prepareStatement(

                    "SELECT COUNT(*) " +
                    "FROM products " +
                    "WHERE owner_id=?"
                );

            productPs.setInt(
                1,
                userId
            );

            ResultSet productRs =
                productPs.executeQuery();


            if(productRs.next()){

                productCount =
                    productRs.getInt(1);
            }


            productRs.close();
            productPs.close();

        }


    }catch(Exception e){

        e.printStackTrace();

        request.setAttribute(
            "supportError",
            e.getMessage()
        );

    }finally{

        try{

            if(con != null){
                con.close();
            }

        }catch(Exception ignored){}
    }
}


/* =========================================================
   NULL PROTECTION
   ========================================================= */

if(firstName == null) firstName = "";
if(lastName == null) lastName = "";
if(phone == null || phone.trim().isEmpty()) phone = "-";

String fullName =
    (firstName + " " + lastName).trim();

if(fullName.isEmpty()){
    fullName = "RentEasy User";
}

String firstLetter = "U";

if(!fullName.isEmpty()){
    firstLetter =
        fullName.substring(0,1).toUpperCase();
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>
Customer Support - RentEasy Admin
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

    font-size:18px;
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
        125px
        42px
        60px;
}


.page-container{

    max-width:1400px;

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
   SEARCH PANEL
   ========================================================= */

.search-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    padding:28px;

    box-shadow:
        0 5px 18px rgba(15,23,42,.04);

    margin-bottom:25px;
}


.search-title{

    font-size:19px;

    font-weight:700;

    margin-bottom:5px;
}


.search-description{

    color:#64748b;

    font-size:13px;

    margin-bottom:20px;
}


.search-form{

    display:flex;

    gap:12px;
}


.search-input{

    flex:1;

    height:52px;

    border:1px solid #dbe3ef;

    border-radius:10px;

    padding:0 17px;

    font-size:15px;

    outline:none;
}


.search-input:focus{

    border-color:#2563eb;

    box-shadow:
        0 0 0 3px rgba(37,99,235,.08);
}


.search-btn{

    min-width:150px;

    border:none;

    border-radius:10px;

    background:#2563eb;

    color:white;

    font-weight:700;

    padding:0 22px;
}


.search-btn:hover{

    background:#1d4ed8;
}


/* =========================================================
   USER PROFILE
   ========================================================= */

.profile-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    padding:28px;

    box-shadow:
        0 5px 18px rgba(15,23,42,.04);

    margin-bottom:24px;
}


.profile-header{

    display:flex;

    align-items:center;

    justify-content:space-between;

    gap:20px;
}


.profile-main{

    display:flex;

    align-items:center;

    gap:18px;
}


.profile-avatar{

    width:72px;
    height:72px;

    border-radius:50%;

    background:#eaf1ff;

    color:#2563eb;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:27px;

    font-weight:750;
}


.profile-name{

    font-size:23px;

    font-weight:750;

    margin-bottom:5px;
}


.profile-email{

    color:#64748b;

    font-size:14px;
}


.account-id{

    background:#f1f5f9;

    color:#475569;

    padding:8px 13px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


/* =========================================================
   PROFILE DETAILS
   ========================================================= */

.profile-details{

    display:grid;

    grid-template-columns:
        repeat(4,1fr);

    gap:15px;

    margin-top:25px;

    padding-top:25px;

    border-top:1px solid #edf2f7;
}


.detail-box{

    background:#f8fafc;

    border:1px solid #edf2f7;

    border-radius:12px;

    padding:16px;
}


.detail-label{

    color:#64748b;

    font-size:12px;

    margin-bottom:6px;
}


.detail-value{

    font-size:15px;

    font-weight:700;

    word-break:break-word;
}


.kyc-approved{

    color:#15803d;
}


.kyc-pending{

    color:#c2410c;
}
/* =========================================================
   SUPPORT DATA
   ========================================================= */

.support-data-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    margin-top:24px;

    overflow:hidden;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.support-data-header{

    padding:22px 24px;

    display:flex;

    align-items:center;

    justify-content:space-between;

    border-bottom:1px solid #e2e8f0;
}


.support-data-header h4{

    margin:0;

    font-size:19px;

    font-weight:700;
}


.support-data-header p{

    margin:5px 0 0;

    color:#64748b;

    font-size:13px;
}


.record-count{

    background:#eff6ff;

    color:#2563eb;

    padding:7px 12px;

    border-radius:20px;

    font-size:12px;

    font-weight:700;
}


.support-table{

    width:100%;

    border-collapse:collapse;
}


.support-table th{

    background:#f8fafc;

    color:#475569;

    font-size:11px;

    font-weight:700;

    text-transform:uppercase;

    padding:15px 14px;

    border-bottom:1px solid #e2e8f0;

    white-space:nowrap;
}


.support-table td{

    padding:16px 14px;

    border-bottom:1px solid #edf2f7;

    vertical-align:middle;

    font-size:13px;
}


.support-table tbody tr:hover{

    background:#fbfdff;
}


.rental-number{

    font-weight:750;

    color:#2563eb;
}


.table-primary-text{

    font-weight:700;

    color:#0f172a;
}


.date-range{

    min-width:95px;

    font-size:12px;
}


.date-range span{

    color:#94a3b8;

    font-size:10px;
}


.deposit-text{

    color:#2563eb;

    font-weight:700;
}


.mini-status{

    display:inline-block;

    background:#f1f5f9;

    color:#475569;

    padding:5px 8px;

    border-radius:6px;

    font-size:10px;

    font-weight:700;
}


.payment-status{

    background:#ecfdf5;

    color:#047857;
}


.rental-status{

    display:inline-block;

    padding:6px 9px;

    border-radius:20px;

    font-size:10px;

    font-weight:700;

    white-space:nowrap;
}


.status-active{

    background:#dcfce7;

    color:#15803d;
}


.status-completed{

    background:#e0f2fe;

    color:#0369a1;
}


.status-return{

    background:#fff7ed;

    color:#c2410c;
}


.status-neutral{

    background:#f1f5f9;

    color:#475569;
}


.support-view-btn{

    display:inline-block;

    text-decoration:none;

    border:1px solid #bfdbfe;

    color:#2563eb;

    background:white;

    padding:7px 10px;

    border-radius:7px;

    font-size:11px;

    font-weight:700;

    white-space:nowrap;
}


.support-view-btn:hover{

    background:#2563eb;

    color:white;
}


.no-support-records{

    padding:45px 20px;

    text-align:center;

    color:#64748b;
}


.no-record-icon{

    width:55px;

    height:55px;

    margin:0 auto 13px;

    border-radius:50%;

    background:#eff6ff;

    color:#2563eb;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:23px;
}


.no-support-records h5{

    color:#0f172a;

    font-weight:700;
}


.no-support-records p{

    margin:0;
}


.support-error{

    margin:10px;

    background:#fee2e2;

    color:#991b1b;

    border:1px solid #fecaca;

    padding:13px;

    border-radius:8px;
}

/* =========================================================
   STATS
   ========================================================= */

.stats-grid{

    display:grid;

    grid-template-columns:
        repeat(4,1fr);

    gap:18px;

    margin-bottom:24px;
}


.stat-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:15px;

    padding:21px;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.stat-label{

    color:#64748b;

    font-size:13px;

    margin-bottom:8px;
}


.stat-number{

    font-size:27px;

    font-weight:750;
}


.blue{
    color:#2563eb;
}


.green{
    color:#059669;
}


.purple{
    color:#7c3aed;
}


.orange{
    color:#ea580c;
}


/* =========================================================
   SUPPORT OPTIONS
   ========================================================= */

.support-card{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    padding:25px;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.support-card h4{

    font-size:19px;

    font-weight:700;

    margin-bottom:6px;
}


.support-card p{

    color:#64748b;

    font-size:13px;

    margin-bottom:22px;
}


.support-tabs{

    display:grid;

    grid-template-columns:
        repeat(6,1fr);

    gap:10px;
}


.support-tab{

    padding:14px 8px;

    text-align:center;

    border:1px solid #dbe3ef;

    background:#fff;

    color:#475569;

    border-radius:10px;

    font-size:13px;

    font-weight:650;

    cursor:default;
}


.support-tab:first-child{

    border-color:#bfdbfe;

    background:#eff6ff;

    color:#2563eb;
}
/* =========================================================
   SUPPORT PRODUCT LISTINGS
   ========================================================= */

.support-product-info{

    display:flex;

    align-items:center;

    gap:12px;

    min-width:210px;
}


.support-product-image{

    width:52px;

    height:52px;

    object-fit:cover;

    border-radius:9px;

    border:1px solid #e2e8f0;

    background:#f8fafc;
}


.support-product-placeholder{

    width:52px;

    height:52px;

    min-width:52px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#f1f5f9;

    border-radius:9px;

    font-size:21px;
}


.support-product-id{

    color:#94a3b8;

    font-size:11px;

    margin-top:3px;
}


.small-muted{

    color:#94a3b8;

    font-size:10px;

    margin-top:2px;
}


.support-listing-badge{

    display:inline-block;

    padding:5px 9px;

    background:#f3e8ff;

    color:#7e22ce;

    border-radius:6px;

    font-size:10px;

    font-weight:700;

    text-transform:capitalize;
}


.support-availability{

    display:inline-block;

    padding:5px 9px;

    background:#eff6ff;

    color:#2563eb;

    border-radius:6px;

    font-size:10px;

    font-weight:700;

    text-transform:capitalize;
}


.support-product-rejected{

    background:#fee2e2;

    color:#b91c1c;
}

/* =========================================================
   NOT FOUND
   ========================================================= */

.not-found{

    background:white;

    border:1px solid #e2e8f0;

    border-radius:17px;

    padding:55px 25px;

    text-align:center;

    box-shadow:
        0 5px 18px rgba(15,23,42,.03);
}


.not-found-icon{

    width:65px;
    height:65px;

    margin:0 auto 15px;

    background:#fff7ed;

    color:#ea580c;

    border-radius:50%;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:28px;
}


.not-found h4{

    font-weight:700;
}


.not-found p{

    color:#64748b;

    margin-bottom:0;
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

    .profile-details,
    .stats-grid{

        grid-template-columns:
            repeat(2,1fr);
    }

    .support-tabs{

        grid-template-columns:
            repeat(3,1fr);
    }
    .support-tab:first-child{
    border-color:#bfdbfe;
    background:#eff6ff;
    color:#2563eb;
}
.active-support-tab{
    border-color:#bfdbfe !important;
    background:#eff6ff !important;
    color:#2563eb !important;
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

<h4>
RentEasy
</h4>

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


<a href="adminProducts.jsp">

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



<!-- NEW SUPPORT SECTION -->

<div class="nav-section">
SUPPORT
</div>


<a href="adminSupport.jsp"
   class="active">

<span class="nav-icon">
☎
</span>

Customer Support

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


<div class="admin-divider">
</div>


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


<h1 class="page-title">

Customer Support

</h1>


<p class="page-subtitle">

Search a registered RentEasy account to investigate
rental, product, payment, return or refund issues.

</p>



<!-- ERROR -->

<%

String supportError =
    (String) request.getAttribute(
        "supportError"
    );


if(supportError != null){

%>


<div class="error-box">

Database error:
<%=supportError%>

</div>


<%

}

%>



<!-- =========================================================
     SEARCH
     ========================================================= -->

<div class="search-card">


<div class="search-title">

Find Customer Account

</div>


<div class="search-description">

Ask the customer for the email address registered
with their RentEasy account.

</div>



<form
method="get"
action="adminSupport.jsp"
class="search-form">


<input
type="email"
name="email"
class="search-input"
placeholder="Enter registered email address..."
value="<%=searchEmail == null ? "" : searchEmail%>"
required>


<button
type="submit"
class="search-btn">

Search Account

</button>


</form>


</div>



<!-- =========================================================
     SEARCH RESULT
     ========================================================= -->

<%

if(userFound){

%>
<%
if("rentals".equalsIgnoreCase(activeTab)){
%>
<%
if("payments".equalsIgnoreCase(activeTab)){
%>

<!-- PAYMENT HISTORY CODE HERE -->

<%
}
%>
<div class="support-data-card">

    <div class="support-data-header">

        <div>
            <h4>Rental History</h4>

            <p>
                Complete rental activity for
                <strong><%=fullName%></strong>.
            </p>
        </div>

        <span class="record-count">
            <%=rentalCount%> Rentals
        </span>

    </div>


    <div class="table-responsive">

    <table class="support-table">

        <thead>

        <tr>
            <th>Rental</th>
            <th>Product</th>
            <th>Owner</th>
            <th>Rental Period</th>
            <th>Rent</th>
            <th>Deposit</th>
            <th>Payment</th>
            <th>Pickup</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        </thead>


        <tbody>

<%

Connection rentalCon = null;

boolean rentalFound = false;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    rentalCon =
        DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"
        );


    String rentalSql =

        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.rent_amount, " +
        "r.security_deposit, " +
        "r.payment_status, " +
        "r.pickup_status, " +
        "r.rental_status, " +

        "p.name AS product_name, " +

        "o.first_name AS owner_first_name, " +
        "o.last_name AS owner_last_name " +

        "FROM rentals r " +

        "JOIN products p " +
        "ON r.product_id=p.id " +

        "JOIN users o " +
        "ON r.owner_id=o.id " +

        "WHERE r.user_id=? " +

        "ORDER BY r.rental_id DESC";


    PreparedStatement rentalPs =
        rentalCon.prepareStatement(
            rentalSql
        );


    rentalPs.setInt(
        1,
        userId
    );


    ResultSet rentalRs =
        rentalPs.executeQuery();


    while(rentalRs.next()){

        rentalFound = true;


        int rentalId =
            rentalRs.getInt(
                "rental_id"
            );


        String productName =
            rentalRs.getString(
                "product_name"
            );


        String ownerFirst =
            rentalRs.getString(
                "owner_first_name"
            );


        String ownerLast =
            rentalRs.getString(
                "owner_last_name"
            );


        if(ownerFirst == null){
            ownerFirst = "";
        }


        if(ownerLast == null){
            ownerLast = "";
        }


        String ownerName =
            (
                ownerFirst +
                " " +
                ownerLast
            ).trim();


        if(ownerName.isEmpty()){
            ownerName = "Owner";
        }


        String paymentStatus =
            rentalRs.getString(
                "payment_status"
            );


        String pickupStatus =
            rentalRs.getString(
                "pickup_status"
            );


        String rentalStatus =
            rentalRs.getString(
                "rental_status"
            );


        if(paymentStatus == null){
            paymentStatus = "-";
        }


        if(pickupStatus == null){
            pickupStatus = "-";
        }


        if(rentalStatus == null){
            rentalStatus = "-";
        }


        String rentalStatusClass =
            "status-neutral";


        if("ACTIVE".equalsIgnoreCase(
                rentalStatus)){

            rentalStatusClass =
                "status-active";
        }

        else if(
            "RETURNED".equalsIgnoreCase(
                rentalStatus
            ) ||

            "COMPLETED".equalsIgnoreCase(
                rentalStatus
            )
        ){

            rentalStatusClass =
                "status-completed";
        }

        else if(
            rentalStatus
                .toUpperCase()
                .contains("RETURN")
        ){

            rentalStatusClass =
                "status-return";
        }

%>


<tr>


<td>

<div class="rental-number">

    #<%=rentalId%>

</div>

</td>



<td>

<div class="table-primary-text">

    <%=productName%>

</div>

</td>



<td>

<%=ownerName%>

</td>



<td>

<div class="date-range">

    <div>
        <%=rentalRs.getDate("start_date")%>
    </div>

    <span>to</span>

    <div>
        <%=rentalRs.getDate("end_date")%>
    </div>

</div>

</td>



<td>

<strong>

₹<%=String.format(
        "%.2f",
        rentalRs.getDouble(
            "rent_amount"
        )
)%>

</strong>

</td>



<td>

<span class="deposit-text">

₹<%=String.format(
        "%.2f",
        rentalRs.getDouble(
            "security_deposit"
        )
)%>

</span>

</td>



<td>

<span class="mini-status payment-status">

    <%=paymentStatus%>

</span>

</td>



<td>

<span class="mini-status">

    <%=pickupStatus%>

</span>

</td>



<td>

<span class="rental-status
             <%=rentalStatusClass%>">

    <%=rentalStatus%>

</span>

</td>



<td>

<a
href="rentalView.jsp?rentalId=<%=rentalId%>"
class="support-view-btn">

    View Details

</a>

</td>


</tr>


<%

    }


    rentalRs.close();
    rentalPs.close();


}catch(Exception e){

    e.printStackTrace();

%>


<tr>

<td colspan="10">

<div class="support-error">

Unable to load rental history:

<%=e.getMessage()%>

</div>

</td>

</tr>


<%

}finally{

    try{

        if(rentalCon != null){
            rentalCon.close();
        }

    }catch(Exception ignored){}
}


if(!rentalFound){

%>


<tr>

<td colspan="10">


<div class="no-support-records">

<div class="no-record-icon">
    ⟳
</div>

<h5>
    No Rental History
</h5>

<p>

This customer has not rented any
products yet.

</p>

</div>


</td>

</tr>


<%

}

%>


</tbody>

</table>

</div>

</div>


<%
}
%>


<!-- PROFILE -->

<div class="profile-card">


<div class="profile-header">


<div class="profile-main">


<div class="profile-avatar">

<%=firstLetter%>

</div>


<div>


<div class="profile-name">

<%=fullName%>

</div>


<div class="profile-email">

<%=email%>

</div>


</div>


</div>



<div class="account-id">

ACCOUNT #<%=userId%>

</div>


</div>



<div class="profile-details">


<div class="detail-box">

<div class="detail-label">

Registered Email

</div>

<div class="detail-value">

<%=email%>

</div>

</div>



<div class="detail-box">

<div class="detail-label">

Phone Number

</div>

<div class="detail-value">

<%=phone%>

</div>

</div>



<div class="detail-box">

<div class="detail-label">

KYC Status

</div>

<div class="detail-value
<%=
"Approved".equalsIgnoreCase(kycStatus)
? "kyc-approved"
: "kyc-pending"
%>">

<%=kycStatus%>

</div>

</div>



<div class="detail-box">

<div class="detail-label">

Account Type

</div>

<div class="detail-value">

<%

if(productCount > 0){

%>

User + Owner

<%

}
else{

%>

User

<%

}

%>

</div>

</div>


</div>


</div>



<!-- =========================================================
     ACCOUNT ACTIVITY
     ========================================================= -->

<div class="stats-grid">


<div class="stat-card">

<div class="stat-label">

Rental Orders

</div>

<div class="stat-number blue">

<%=rentalCount%>

</div>

</div>



<div class="stat-card">

<div class="stat-label">

Products Listed

</div>

<div class="stat-number green">

<%=productCount%>

</div>

</div>



<div class="stat-card">

<div class="stat-label">

Account ID

</div>

<div class="stat-number purple">

#<%=userId%>

</div>

</div>



<div class="stat-card">

<div class="stat-label">

KYC

</div>

<div class="stat-number orange"
style="font-size:18px;margin-top:5px;">

<%=kycStatus%>

</div>

</div>


</div>



<!-- =========================================================
     SUPPORT MODULES
     ========================================================= -->

<div class="support-card">


<h4>

Customer Activity

</h4>


<p>

Select an area to investigate the customer's
RentEasy activity.

</p>



<div class="support-tabs">

<a href="adminSupport.jsp?email=<%=email%>"
   class="support-tab <%= "overview".equals(activeTab) ? "active-support-tab" : "" %>">
    Overview
</a>

<a href="adminSupport.jsp?email=<%=email%>&tab=rentals"
   class="support-tab <%= "rentals".equals(activeTab) ? "active-support-tab" : "" %>">
    Rentals
</a>

<a href="adminSupport.jsp?email=<%=email%>&tab=products"
   class="support-tab <%= "products".equals(activeTab) ? "active-support-tab" : "" %>">
    Products
</a>

<a href="adminSupport.jsp?email=<%=email%>&tab=payments"
   class="support-tab <%= "payments".equals(activeTab) ? "active-support-tab" : "" %>">
    Payments
</a>

<a href="adminSupport.jsp?email=<%=email%>&tab=returns"
   class="support-tab <%= "returns".equals(activeTab) ? "active-support-tab" : "" %>">
    Returns
</a>

<a href="adminSupport.jsp?email=<%=email%>&tab=refunds"
   class="support-tab <%= "refunds".equals(activeTab) ? "active-support-tab" : "" %>">
    Refunds
</a>

</div>


</div>



<%

}
else if(searched){

%>



<!-- =========================================================
     ACCOUNT NOT FOUND
     ========================================================= -->

<div class="not-found">


<div class="not-found-icon">

!

</div>


<h4>

Account Not Found

</h4>


<p>

No RentEasy account was found for
<strong><%=searchEmail%></strong>.

Please verify the registered email address
with the customer.

</p>


</div>
<%
if("products".equalsIgnoreCase(activeTab)){
%>

<div class="support-data-card">

    <!-- HEADER -->
    <div class="support-data-header">

        <div>

            <h4>Owner Product Listings</h4>

            <p>
                Products listed by
                <strong><%=fullName%></strong>
                on RentEasy.
            </p>

        </div>

        <span class="record-count">
            <%=productCount%> Products
        </span>

    </div>


    <div class="table-responsive">

        <table class="support-table">

            <thead>

                <tr>

                    <th>Product</th>

                    <th>Category</th>

                    <th>Rental Price</th>

                    <th>Deposit</th>

                    <th>Listing Type</th>

                    <th>Availability</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

<%

Connection productCon = null;

boolean productFound = false;

try{

    Class.forName(
        "com.mysql.cj.jdbc.Driver"
    );


    productCon =
        DriverManager.getConnection(

            "jdbc:mysql://localhost:3306/renteasy",

            "root",

            "123456"

        );


    String productSql =

        "SELECT " +

        "id, " +
        "name, " +
        "image, " +
        "category, " +
        "price, " +
        "deposit, " +
        "listing_type, " +
        "availability, " +
        "status " +

        "FROM products " +

        "WHERE owner_id=? " +

        "ORDER BY id DESC";


    PreparedStatement productPs =
        productCon.prepareStatement(
            productSql
        );


    productPs.setInt(
        1,
        userId
    );


    ResultSet productRs =
        productPs.executeQuery();


    while(productRs.next()){

        productFound = true;


        int supportProductId =
            productRs.getInt("id");


        String supportProductName =
            productRs.getString("name");


        String supportProductImage =
            productRs.getString("image");


        String supportCategory =
            productRs.getString("category");


        String supportListingType =
            productRs.getString(
                "listing_type"
            );


        String supportAvailability =
            productRs.getString(
                "availability"
            );


        String supportProductStatus =
            productRs.getString(
                "status"
            );


        if(supportProductName == null){

            supportProductName = "-";
        }


        if(supportCategory == null ||
           supportCategory.trim().isEmpty()){

            supportCategory = "-";
        }


        if(supportListingType == null ||
           supportListingType.trim().isEmpty()){

            supportListingType = "-";
        }


        if(supportAvailability == null ||
           supportAvailability.trim().isEmpty()){

            supportAvailability = "-";
        }


        if(supportProductStatus == null ||
           supportProductStatus.trim().isEmpty()){

            supportProductStatus = "Unknown";
        }


        String supportProductStatusClass =
            "status-neutral";


        if("approved".equalsIgnoreCase(
                supportProductStatus)){

            supportProductStatusClass =
                "status-completed";
        }

        else if("pending".equalsIgnoreCase(
                supportProductStatus)){

            supportProductStatusClass =
                "status-return";
        }

        else if("rejected".equalsIgnoreCase(
                supportProductStatus)){

            supportProductStatusClass =
                "support-product-rejected";
        }

%>


<tr>


<!-- PRODUCT -->

<td>

    <div class="support-product-info">


<%
if(supportProductImage != null &&
   !supportProductImage.trim().isEmpty()){
%>

        <img
        src="<%=request.getContextPath()%>/<%=supportProductImage%>"
        class="support-product-image"

        onerror="
        this.style.display='none';
        ">

<%
}
else{
%>

        <div class="support-product-placeholder">
            📦
        </div>

<%
}
%>


        <div>

            <div class="table-primary-text">

                <%=supportProductName%>

            </div>


            <div class="support-product-id">

                Product #<%=supportProductId%>

            </div>

        </div>


    </div>

</td>



<!-- CATEGORY -->

<td>

    <%=supportCategory%>

</td>



<!-- RENTAL PRICE -->

<td>

    <strong>

        ₹<%=String.format(
            "%.2f",
            productRs.getDouble("price")
        )%>

    </strong>

    <div class="small-muted">
        per day
    </div>

</td>



<!-- DEPOSIT -->

<td>

    <span class="deposit-text">

        ₹<%=String.format(
            "%.2f",
            productRs.getDouble("deposit")
        )%>

    </span>

</td>



<!-- LISTING TYPE -->

<td>

    <span class="support-listing-badge">

        <%=supportListingType%>

    </span>

</td>



<!-- AVAILABILITY -->

<td>

    <span class="support-availability">

        <%=supportAvailability%>

    </span>

</td>



<!-- STATUS -->

<td>

    <span class="rental-status
                 <%=supportProductStatusClass%>">

        <%=supportProductStatus%>

    </span>

</td>



<!-- ACTION -->

<td>

    <a
    href="adminProductDetails.jsp?id=<%=supportProductId%>"
    class="support-view-btn">

        View Details

    </a>

</td>


</tr>


<%

    }


    productRs.close();

    productPs.close();


}catch(Exception e){

    e.printStackTrace();

%>


<tr>

<td colspan="8">

    <div class="support-error">

        Unable to load product listings:

        <%=e.getMessage()%>

    </div>

</td>

</tr>


<%

}finally{

    try{

        if(productCon != null){

            productCon.close();
        }

    }catch(Exception ignored){}
}


if(!productFound){

%>


<tr>

<td colspan="8">


<div class="no-support-records">


    <div class="no-record-icon">

        📦

    </div>


    <h5>

        No Products Listed

    </h5>


    <p>

        This account has not listed any
        products on RentEasy.

    </p>


</div>


</td>

</tr>


<%

}

%>


            </tbody>

        </table>

    </div>

</div>


<%
}
%>

<%

}

%>


</div>

</div>


</body>

</html>