<%@ page session="true" %>

<%
if(!"ADMIN".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp");
    return;
}

String currentPage = request.getRequestURI();

String adminEmail = (String) session.getAttribute("email");

if(adminEmail == null){
    adminEmail = "renteasy.project@gmail.com";
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>RentEasy Admin</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

/* ============================================================
   GLOBAL
============================================================ */

*{
    box-sizing:border-box;
}

html,
body{
    margin:0;
    padding:0;
    min-height:100%;
}

body{
    background:#f8fafc;
    color:#0f172a;
    font-family:
        Inter,
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        Roboto,
        Arial,
        sans-serif;
}


/* ============================================================
   SIDEBAR
============================================================ */

.admin-sidebar{

    position:fixed;

    left:0;
    top:0;
    bottom:0;

    width:270px;

    background:#0f172a;

    z-index:1100;

    overflow-y:auto;

    border-right:1px solid rgba(255,255,255,.05);
}


/* ============================================================
   SIDEBAR BRAND
============================================================ */

.sidebar-brand{

    min-height:90px;

    display:flex;

    align-items:center;

    padding:18px 22px;

    border-bottom:1px solid rgba(255,255,255,.08);
}

.sidebar-brand-inner{

    display:flex;

    align-items:center;

    gap:13px;
}

.sidebar-logo{

    width:48px;

    height:48px;

    border-radius:12px;

    object-fit:contain;

    background:#ffffff;

    padding:3px;
}

.sidebar-brand-name{

    margin:0;

    color:#ffffff;

    font-size:21px;

    font-weight:750;
}

.sidebar-brand-label{

    margin-top:2px;

    color:#94a3b8;

    font-size:11px;

    font-weight:600;

    letter-spacing:.8px;
}


/* ============================================================
   SIDEBAR NAVIGATION
============================================================ */

.sidebar-navigation{

    padding:20px 14px 30px;
}


.sidebar-section-title{

    padding:18px 14px 8px;

    color:#64748b;

    font-size:10px;

    font-weight:700;

    letter-spacing:1.2px;

    text-transform:uppercase;
}


.sidebar-link{

    position:relative;

    display:flex;

    align-items:center;

    gap:13px;

    width:100%;

    min-height:46px;

    padding:11px 14px;

    margin:3px 0;

    color:#cbd5e1;

    text-decoration:none;

    border-radius:9px;

    font-size:14px;

    font-weight:500;

    transition:
        background .2s ease,
        color .2s ease;
}


.sidebar-link i{

    width:20px;

    text-align:center;

    font-size:17px;
}


.sidebar-link:hover{

    background:#1e293b;

    color:#ffffff;
}


.sidebar-link.active{

    background:#2563eb;

    color:#ffffff;

    font-weight:600;
}


.sidebar-link.active::before{

    content:"";

    position:absolute;

    left:-14px;

    top:10px;

    bottom:10px;

    width:3px;

    background:#60a5fa;

    border-radius:0 4px 4px 0;
}


/* ============================================================
   SIDEBAR BADGE
============================================================ */

.sidebar-count{

    margin-left:auto;

    min-width:22px;

    height:22px;

    padding:0 6px;

    border-radius:20px;

    background:#dc2626;

    color:#ffffff;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:10px;

    font-weight:700;
}


/* ============================================================
   LOGOUT
============================================================ */

.logout-link{

    margin-top:18px;

    border-top:1px solid rgba(255,255,255,.08);

    padding-top:18px;
}

.logout-link .sidebar-link{

    color:#fca5a5;
}

.logout-link .sidebar-link:hover{

    background:rgba(220,38,38,.15);

    color:#fecaca;
}


/* ============================================================
   TOPBAR
============================================================ */

.admin-topbar{

    position:fixed;

    top:0;

    left:270px;

    right:0;

    height:76px;

    background:#ffffff;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 32px;

    border-bottom:1px solid #e5e7eb;

    z-index:1050;
}


/* ============================================================
   TOPBAR LEFT
============================================================ */

.topbar-left{

    display:flex;

    align-items:center;

    gap:14px;
}


.mobile-menu-btn{

    display:none;

    width:40px;

    height:40px;

    border:none;

    background:#f1f5f9;

    border-radius:9px;

    align-items:center;

    justify-content:center;

    font-size:20px;
}


.topbar-logo{

    width:38px;

    height:38px;

    object-fit:contain;
}


.topbar-title{

    font-size:20px;

    font-weight:750;

    color:#2563eb;
}


.admin-panel-badge{

    background:#fef2f2;

    color:#dc2626;

    border:1px solid #fecaca;

    padding:6px 11px;

    border-radius:20px;

    font-size:11px;

    font-weight:700;
}


/* ============================================================
   TOPBAR RIGHT
============================================================ */

.topbar-right{

    display:flex;

    align-items:center;

    gap:16px;
}


.admin-notification{

    width:40px;

    height:40px;

    border-radius:10px;

    background:#f8fafc;

    border:1px solid #e2e8f0;

    display:flex;

    align-items:center;

    justify-content:center;

    color:#475569;

    font-size:18px;

    text-decoration:none;

    transition:.2s;
}


.admin-notification:hover{

    background:#eff6ff;

    color:#2563eb;
}


.admin-profile{

    display:flex;

    align-items:center;

    gap:11px;

    padding-left:16px;

    border-left:1px solid #e5e7eb;
}


.admin-avatar{

    width:39px;

    height:39px;

    border-radius:50%;

    background:#2563eb;

    color:#ffffff;

    display:flex;

    align-items:center;

    justify-content:center;

    font-weight:700;

    font-size:14px;
}


.admin-profile-info{

    line-height:1.3;
}


.admin-profile-name{

    font-size:13px;

    font-weight:700;

    color:#0f172a;
}


.admin-profile-email{

    color:#64748b;

    font-size:11px;

    max-width:210px;

    overflow:hidden;

    white-space:nowrap;

    text-overflow:ellipsis;
}


/* ============================================================
   MAIN CONTENT
============================================================ */

.main{

    margin-left:270px;

    padding:104px 32px 40px;

    min-height:100vh;
}


/* ============================================================
   COMMON ADMIN PAGE STYLES
============================================================ */

.admin-page-header{

    display:flex;

    align-items:flex-start;

    justify-content:space-between;

    gap:20px;

    margin-bottom:26px;
}


.admin-page-title{

    margin:0;

    font-size:28px;

    font-weight:750;

    color:#0f172a;
}


.admin-page-description{

    margin:6px 0 0;

    color:#64748b;

    font-size:14px;
}


.admin-card{

    background:#ffffff;

    border:1px solid #e2e8f0;

    border-radius:14px;

    box-shadow:0 3px 12px rgba(15,23,42,.04);
}


.admin-card-header{

    padding:20px 22px;

    border-bottom:1px solid #e2e8f0;
}


.admin-card-body{

    padding:22px;
}


/* ============================================================
   COMMON TABLE
============================================================ */

.admin-table{

    width:100%;

    margin:0;
}


.admin-table thead th{

    background:#f8fafc;

    color:#475569;

    border-bottom:1px solid #e2e8f0;

    padding:13px 16px;

    font-size:12px;

    font-weight:700;

    text-transform:uppercase;

    letter-spacing:.35px;
}


.admin-table tbody td{

    padding:15px 16px;

    border-bottom:1px solid #eef2f7;

    vertical-align:middle;

    font-size:14px;

    color:#334155;
}


.admin-table tbody tr:hover{

    background:#f8fafc;
}


/* ============================================================
   COMMON BUTTONS
============================================================ */

.admin-btn-primary{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    gap:7px;

    padding:9px 15px;

    border:none;

    border-radius:8px;

    background:#2563eb;

    color:#ffffff;

    font-size:13px;

    font-weight:600;

    text-decoration:none;

    transition:.2s;
}


.admin-btn-primary:hover{

    background:#1d4ed8;

    color:#ffffff;
}


.admin-btn-light{

    display:inline-flex;

    align-items:center;

    gap:7px;

    padding:9px 15px;

    border:1px solid #e2e8f0;

    border-radius:8px;

    background:#ffffff;

    color:#334155;

    font-size:13px;

    font-weight:600;

    text-decoration:none;
}


.admin-btn-light:hover{

    background:#f8fafc;

    color:#0f172a;
}


/* ============================================================
   SCROLLBAR
============================================================ */

.admin-sidebar::-webkit-scrollbar{

    width:5px;
}


.admin-sidebar::-webkit-scrollbar-thumb{

    background:#334155;

    border-radius:20px;
}


/* ============================================================
   RESPONSIVE
============================================================ */

@media(max-width:991px){

    .admin-sidebar{

        transform:translateX(-100%);

        transition:.25s ease;
    }


    .admin-sidebar.mobile-open{

        transform:translateX(0);
    }


    .admin-topbar{

        left:0;

        padding:0 18px;
    }


    .main{

        margin-left:0;

        padding:98px 18px 30px;
    }


    .mobile-menu-btn{

        display:flex;
    }


    .topbar-logo,
    .topbar-title{

        display:none;
    }

}


@media(max-width:650px){

    .admin-profile-info{

        display:none;
    }


    .admin-panel-badge{

        display:none;
    }


    .admin-page-header{

        flex-direction:column;
    }

}

</style>

</head>

<body>


<!-- ============================================================
     SIDEBAR
============================================================ -->

<aside class="admin-sidebar"
       id="adminSidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

        <div class="sidebar-brand-inner">

            <img src="images/logo.png.jpeg"
                 class="sidebar-logo"
                 alt="RentEasy">

            <div>

                <h2 class="sidebar-brand-name">
                    RentEasy
                </h2>

                <div class="sidebar-brand-label">
                    ADMINISTRATION
                </div>

            </div>

        </div>

    </div>



    <!-- NAVIGATION -->

    <nav class="sidebar-navigation">


        <!-- DASHBOARD -->

        <a href="adminDashboard.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminDashboard.jsp")
               ? "active" : "" %>">

            <i class="bi bi-grid-1x2-fill"></i>

            <span>Dashboard</span>

        </a>



        <!-- MANAGEMENT -->

        <div class="sidebar-section-title">
            Management
        </div>


        <a href="adminUsers.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminUsers.jsp")
               ? "active" : "" %>">

            <i class="bi bi-people"></i>

            <span>Users</span>

        </a>


        <a href="adminOwners.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminOwners.jsp")
               ? "active" : "" %>">

            <i class="bi bi-shop"></i>

            <span>Owners</span>

        </a>


        <a href="adminProducts.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminProducts.jsp")
               ? "active" : "" %>">

            <i class="bi bi-box-seam"></i>

            <span>Products</span>

        </a>


        <a href="adminRentals.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminRentals.jsp")
               ? "active" : "" %>">

            <i class="bi bi-arrow-repeat"></i>

            <span>Rentals</span>

        </a>



        <!-- RETURN AND PAYMENTS -->

        <div class="sidebar-section-title">
            Return & Payments
        </div>


        <a href="adminReturnRequests.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminReturnRequests.jsp")
               ? "active" : "" %>">

            <i class="bi bi-arrow-return-left"></i>

            <span>Return Requests</span>

        </a>


        <a href="adminReturns.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminReturns.jsp")
               ? "active" : "" %>">

            <i class="bi bi-box-arrow-in-left"></i>

            <span>Returns</span>

        </a>


        <a href="adminRefund.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminRefund.jsp")
               ? "active" : "" %>">

            <i class="bi bi-cash-coin"></i>

            <span>Refunds</span>

        </a>


        <a href="AdminPaymentsServlet"

           class="sidebar-link
           <%= currentPage.contains("adminpayments.jsp")
               ? "active" : "" %>">

            <i class="bi bi-credit-card"></i>

            <span>Payments</span>

        </a>



        <!-- VERIFICATION -->

        <div class="sidebar-section-title">
            Verification
        </div>


        <a href="adminKyc.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminKyc.jsp")
               ? "active" : "" %>">

            <i class="bi bi-person-check"></i>

            <span>KYC Verification</span>

        </a>

		<a href="adminSupport.jsp"
   class="sidebar-link <%= request.getRequestURI().contains("adminSupport.jsp") ? "active" : "" %>">

    <i class="bi bi-headset"></i>

    <span>Customer Support</span>

</a>



        <!-- SYSTEM -->

        <div class="sidebar-section-title">
            System
        </div>


        <a href="adminReports.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminReports.jsp")
               ? "active" : "" %>">

            <i class="bi bi-bar-chart"></i>

            <span>Reports</span>

        </a>


        <a href="adminNotifications.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminNotifications.jsp")
               ? "active" : "" %>">

            <i class="bi bi-bell"></i>

            <span>Notifications</span>

        </a>


        <a href="adminSettings.jsp"

           class="sidebar-link
           <%= currentPage.contains("adminSettings.jsp")
               ? "active" : "" %>">

            <i class="bi bi-gear"></i>

            <span>Settings</span>

        </a>



        <!-- LOGOUT -->

        <div class="logout-link">

            <a href="logout"
               class="sidebar-link">

                <i class="bi bi-box-arrow-right"></i>

                <span>Logout</span>

            </a>

        </div>


    </nav>

</aside>



<!-- ============================================================
     TOPBAR
============================================================ -->

<header class="admin-topbar">


    <!-- LEFT -->

    <div class="topbar-left">


        <button type="button"
                class="mobile-menu-btn"
                onclick="toggleAdminSidebar()">

            <i class="bi bi-list"></i>

        </button>


        <img src="images/logo.png.jpeg"
             class="topbar-logo"
             alt="RentEasy">


        <span class="topbar-title">
            RentEasy
        </span>


        <span class="admin-panel-badge">
            ADMIN PANEL
        </span>


    </div>



    <!-- RIGHT -->

    <div class="topbar-right">


        <a href="adminNotifications.jsp"
           class="admin-notification"
           title="Notifications">

            <i class="bi bi-bell"></i>

        </a>


        <div class="admin-profile">


            <div class="admin-avatar">
                A
            </div>


            <div class="admin-profile-info">

                <div class="admin-profile-name">
                    Administrator
                </div>

                <div class="admin-profile-email">
                    <%= adminEmail %>
                </div>

            </div>


        </div>


    </div>

</header>



<!-- ============================================================
     MAIN CONTENT START
============================================================ -->

<main class="main">


<script>

function toggleAdminSidebar(){

    document
        .getElementById("adminSidebar")
        .classList
        .toggle("mobile-open");
}

</script>