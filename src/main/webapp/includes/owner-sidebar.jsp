<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
/* =========================================================
   CURRENT PAGE
   Used to highlight the active sidebar option
========================================================= */

String ownerCurrentPage = request.getRequestURI();

String ownerName = (String) session.getAttribute("firstName");

if(ownerName == null || ownerName.trim().isEmpty()){
    ownerName = "Owner";
}
%>

<style>

/* =========================================================
   OWNER SIDEBAR
========================================================= */

.owner-sidebar{
    position:fixed;
    top:72px;
    left:0;

    width:250px;
    height:calc(100vh - 72px);

    background:#ffffff;

    border-right:1px solid #e8edf5;

    box-shadow:
        4px 0 18px rgba(15,23,42,.05);

    z-index:998;

    display:flex;
    flex-direction:column;

    overflow:hidden;
}


/* =========================================================
   OWNER PROFILE
========================================================= */

.owner-sidebar-profile{

    padding:22px 20px 20px;

    border-bottom:1px solid #eef2f7;

    background:
        linear-gradient(
            135deg,
            #f8fbff,
            #ffffff
        );
}


.owner-profile-row{

    display:flex;

    align-items:center;

    gap:12px;
}


.owner-avatar{

    width:44px;
    height:44px;

    min-width:44px;

    border-radius:13px;

    background:
        linear-gradient(
            135deg,
            #2563eb,
            #1d4ed8
        );

    color:#ffffff;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:19px;

    font-weight:700;

    box-shadow:
        0 5px 12px
        rgba(37,99,235,.22);
}


.owner-profile-info{

    min-width:0;
}


.owner-profile-info h6{

    margin:0;

    color:#0f172a;

    font-size:15px;

    font-weight:700;

    white-space:nowrap;

    overflow:hidden;

    text-overflow:ellipsis;
}


.owner-profile-info span{

    display:block;

    margin-top:3px;

    color:#64748b;

    font-size:12px;
}


.owner-badge{

    display:inline-flex;

    align-items:center;

    gap:5px;

    margin-top:12px;

    padding:5px 9px;

    border-radius:20px;

    background:#eff6ff;

    color:#2563eb;

    font-size:11px;

    font-weight:700;
}


/* =========================================================
   NAVIGATION AREA
========================================================= */

.owner-navigation{

    flex:1;

    overflow-y:auto;

    padding:16px 12px 20px;
}


/* SCROLLBAR */

.owner-navigation::-webkit-scrollbar{
    width:5px;
}

.owner-navigation::-webkit-scrollbar-thumb{

    background:#dbe3ef;

    border-radius:20px;
}


/* =========================================================
   SECTION TITLE
========================================================= */

.owner-menu-title{

    padding:8px 12px 7px;

    color:#94a3b8;

    font-size:10px;

    font-weight:800;

    letter-spacing:1.1px;

    text-transform:uppercase;
}


/* =========================================================
   MENU LINK
========================================================= */

.owner-menu-link{

    position:relative;

    display:flex;

    align-items:center;

    gap:12px;

    width:100%;

    padding:11px 12px;

    margin:3px 0;

    border-radius:10px;

    color:#475569;

    text-decoration:none;

    font-size:13px;

    font-weight:600;

    transition:
        background .2s ease,
        color .2s ease,
        transform .2s ease;
}


.owner-menu-link:hover{

    background:#f1f5ff;

    color:#2563eb;

    transform:translateX(2px);
}


.owner-menu-link.active{

    background:#2563eb;

    color:#ffffff;

    box-shadow:
        0 5px 12px
        rgba(37,99,235,.18);
}


.owner-menu-link.active::before{

    content:"";

    position:absolute;

    left:-12px;

    top:9px;

    bottom:9px;

    width:3px;

    border-radius:0 4px 4px 0;

    background:#2563eb;
}


/* =========================================================
   ICON
========================================================= */

.owner-menu-icon{

    width:30px;
    height:30px;

    min-width:30px;

    border-radius:8px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#f8fafc;

    color:#64748b;

    font-size:15px;

    transition:.2s ease;
}


.owner-menu-link:hover
.owner-menu-icon{

    background:#dbeafe;

    color:#2563eb;
}


.owner-menu-link.active
.owner-menu-icon{

    background:
        rgba(255,255,255,.16);

    color:#ffffff;
}


/* =========================================================
   MENU TEXT
========================================================= */

.owner-menu-text{
    flex:1;
}


/* =========================================================
   SMALL BADGE
========================================================= */

.owner-menu-badge{

    min-width:21px;
    height:21px;

    padding:0 6px;

    border-radius:20px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#fee2e2;

    color:#dc2626;

    font-size:10px;

    font-weight:800;
}


.owner-menu-link.active
.owner-menu-badge{

    background:#ffffff;

    color:#2563eb;
}


/* =========================================================
   BOTTOM ACCOUNT SECTION
========================================================= */

.owner-sidebar-bottom{

    padding:12px;

    border-top:1px solid #eef2f7;

    background:#ffffff;
}


.owner-switch{

    display:flex;

    align-items:center;

    gap:12px;

    padding:11px 12px;

    border-radius:10px;

    text-decoration:none;

    color:#2563eb;

    background:#eff6ff;

    font-size:13px;

    font-weight:700;

    margin-bottom:7px;

    transition:.2s;
}


.owner-switch:hover{

    background:#dbeafe;

    color:#1d4ed8;
}


.owner-logout{

    display:flex;

    align-items:center;

    gap:12px;

    padding:11px 12px;

    border-radius:10px;

    text-decoration:none;

    color:#dc2626;

    font-size:13px;

    font-weight:700;

    transition:.2s;
}


.owner-logout:hover{

    background:#fef2f2;

    color:#b91c1c;
}


/* =========================================================
   MOBILE
========================================================= */

@media(max-width:900px){

    .owner-sidebar{

        left:-250px;

        transition:left .3s ease;
    }


    .owner-sidebar.active{

        left:0;
    }

}

</style>


<!-- =========================================================
     OWNER SIDEBAR
========================================================= -->

<aside class="owner-sidebar"
       id="sidebar">


    <!-- =====================================================
         OWNER PROFILE
    ====================================================== -->

    <div class="owner-sidebar-profile">

        <div class="owner-profile-row">


            <div class="owner-avatar">

                <%=ownerName.substring(0,1).toUpperCase()%>

            </div>


            <div class="owner-profile-info">

                <h6>
                    <%=ownerName%>
                </h6>

                <span>
                    Product Owner
                </span>

            </div>

        </div>


        <div class="owner-badge">

            <i class="bi bi-patch-check-fill"></i>

            Verified Owner

        </div>

    </div>



    <!-- =====================================================
         NAVIGATION
    ====================================================== -->

    <nav class="owner-navigation">


        <!-- ================= OVERVIEW ================= -->

        <div class="owner-menu-title">
            Overview
        </div>


        <a href="ownerDashboard.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("ownerDashboard.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-grid-1x2-fill"></i>

            </span>

            <span class="owner-menu-text">
                Dashboard
            </span>

        </a>



        <!-- ================= PRODUCTS ================= -->

        <div class="owner-menu-title">
            Product Management
        </div>


        <a href="ownerProducts.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("ownerProducts.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-box-seam"></i>

            </span>

            <span class="owner-menu-text">
                My Products
            </span>

        </a>


        <a href="addProduct.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("addProduct.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-plus-square"></i>

            </span>

            <span class="owner-menu-text">
                Add Product
            </span>

        </a>



        <!-- ================= RENTALS ================= -->

        <div class="owner-menu-title">
            Rental Management
        </div>


        <a href="ownerBookings.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("ownerBookings.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-calendar-check"></i>

            </span>

            <span class="owner-menu-text">
                Bookings
            </span>

        </a>


        <!-- IMPORTANT:
             This uses your existing OwnerRentalsServlet.
             Do NOT change this to a fake JSP.
        -->

        <a href="OwnerRentalsServlet"
           class="owner-menu-link">

            <span class="owner-menu-icon">

                <i class="bi bi-arrow-repeat"></i>

            </span>

            <span class="owner-menu-text">
                Active Rentals
            </span>

        </a>


        <a href="OwnerRentalsServlet"
           class="owner-menu-link">

            <span class="owner-menu-icon">

                <i class="bi bi-arrow-return-left"></i>

            </span>

            <span class="owner-menu-text">
                Return Management
            </span>

        </a>



        <!-- ================= FINANCE ================= -->

        <div class="owner-menu-title">
            Finance
        </div>


        <a href="ownerEarnings.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("ownerEarnings.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-graph-up-arrow"></i>

            </span>

            <span class="owner-menu-text">
                Earnings
            </span>

        </a>


        <a href="OwnerPaymentsServlet"
   class="owner-menu-link
   <%=ownerCurrentPage.endsWith("ownerpayments.jsp")
   ? "active" : ""%>">

    <span class="owner-menu-icon">
        <i class="bi bi-credit-card"></i>
    </span>

    <span class="owner-menu-text">
        Payments
    </span>

</a>



        <!-- ================= ACCOUNT ================= -->

        <div class="owner-menu-title">
            Account
        </div>


        <a href="notifications.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("notifications.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-bell"></i>

            </span>

            <span class="owner-menu-text">
                Notifications
            </span>

        </a>


        <a href="profile.jsp"
           class="owner-menu-link
           <%=ownerCurrentPage.endsWith("profile.jsp")
           ? "active" : ""%>">

            <span class="owner-menu-icon">

                <i class="bi bi-person"></i>

            </span>

            <span class="owner-menu-text">
                Profile
            </span>

        </a>


    </nav>



    <!-- =====================================================
         BOTTOM
    ====================================================== -->

    <div class="owner-sidebar-bottom">


        <a href="switchMode?mode=user"
           class="owner-switch">

            <i class="bi bi-arrow-left-right"></i>

            Switch to User

        </a>


        <a href="logout"
           class="owner-logout">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>


    </div>


</aside>