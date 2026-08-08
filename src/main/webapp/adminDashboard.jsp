<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<%@ include file="adminLayout.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

/* =========================================
   ADMIN DASHBOARD
========================================= */

.admin-dashboard{
    padding: 10px 8px 40px 8px;
}

.dashboard-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:28px;
}

.dashboard-header h2{
    margin:0;
    font-size:30px;
    font-weight:700;
    color:#0f172a;
}

.dashboard-header p{
    margin:6px 0 0;
    color:#64748b;
    font-size:14px;
}


/* =========================================
   STAT CARDS
========================================= */

.stat-card{
    background:#ffffff;
    border:1px solid #e8edf5;
    border-radius:16px;
    padding:22px;
    height:100%;
    transition:all .25s ease;
    box-shadow:0 4px 14px rgba(15,23,42,.05);
}

.stat-card:hover{
    transform:translateY(-3px);
    box-shadow:0 10px 24px rgba(15,23,42,.10);
}

.stat-top{
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
}

.stat-title{
    color:#64748b;
    font-size:14px;
    font-weight:600;
}

.stat-number{
    font-size:30px;
    font-weight:700;
    color:#0f172a;
    margin-top:8px;
}

.stat-icon{
    width:46px;
    height:46px;
    border-radius:12px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:21px;
}


/* ICON BACKGROUNDS */

.icon-users{
    background:#eff6ff;
    color:#2563eb;
}

.icon-products{
    background:#f0fdf4;
    color:#16a34a;
}

.icon-rentals{
    background:#f5f3ff;
    color:#7c3aed;
}

.icon-return{
    background:#fff7ed;
    color:#ea580c;
}

.icon-refund{
    background:#fef2f2;
    color:#dc2626;
}

.icon-completed{
    background:#ecfdf5;
    color:#059669;
}

.icon-pending{
    background:#fffbeb;
    color:#d97706;
}


/* =========================================
   CLICKABLE CARDS
========================================= */

.dashboard-link{
    text-decoration:none;
    color:inherit;
    display:block;
    height:100%;
}

.dashboard-link:hover{
    color:inherit;
}

.card-action{
    font-size:13px;
    font-weight:600;
    margin-top:13px;
    display:inline-block;
    color:#2563eb;
}

.notification-dot{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-width:22px;
    height:22px;
    padding:0 6px;
    background:#ef4444;
    color:white;
    border-radius:20px;
    font-size:11px;
    margin-left:6px;
}


/* =========================================
   SECTION CARDS
========================================= */

.dashboard-panel{
    background:#ffffff;
    border:1px solid #e8edf5;
    border-radius:16px;
    padding:24px;
    box-shadow:0 4px 14px rgba(15,23,42,.05);
    height:100%;
}

.panel-title{
    font-size:18px;
    font-weight:700;
    color:#0f172a;
    margin-bottom:5px;
}

.panel-subtitle{
    font-size:13px;
    color:#64748b;
    margin-bottom:22px;
}


/* =========================================
   QUICK INFO
========================================= */

.quick-row{
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:14px 0;
    border-bottom:1px solid #eef2f7;
}

.quick-row:last-child{
    border-bottom:none;
}

.quick-label{
    color:#475569;
    font-weight:500;
}

.quick-number{
    font-weight:700;
}


/* =========================================
   RETURN FLOW
========================================= */

.return-flow{
    margin-top:30px;
}

.flow-item{
    position:relative;
    padding-left:42px;
    margin-bottom:22px;
}

.flow-icon{
    position:absolute;
    left:0;
    top:0;
    width:30px;
    height:30px;
    border-radius:50%;
    background:#eff6ff;
    color:#2563eb;
    display:flex;
    justify-content:center;
    align-items:center;
    font-weight:700;
}

.flow-title{
    font-weight:700;
    color:#1e293b;
    font-size:14px;
}

.flow-text{
    color:#64748b;
    font-size:13px;
    margin-top:3px;
}


/* =========================================
   RESPONSIVE
========================================= */

@media(max-width:768px){

    .dashboard-header{
        align-items:flex-start;
        flex-direction:column;
    }

    .stat-number{
        font-size:26px;
    }
}

</style>


<%

// ============================================================
// DASHBOARD COUNTERS
// ============================================================

int users = 0;
int products = 0;

int pendingProducts = 0;
int approvedProducts = 0;
int rejectedProducts = 0;

int activeRentals = 0;

int returnRequests = 0;
int approvedReturns = 0;
int completedReturns = 0;

int refundWaiting = 0;

Connection con = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    // ============================================================
    // TOTAL USERS
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(
            "SELECT COUNT(*) FROM users"
        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            users = rs.getInt(1);
        }
    }


    // ============================================================
    // TOTAL PRODUCTS
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(
            "SELECT COUNT(*) FROM products"
        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            products = rs.getInt(1);
        }
    }


    // ============================================================
    // PRODUCT STATUS
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT status, COUNT(*) AS total " +
            "FROM products " +
            "GROUP BY status"

        );
        ResultSet rs = ps.executeQuery()) {

        while(rs.next()){

            String productStatus =
                rs.getString("status");

            int total =
                rs.getInt("total");

            if("Pending".equalsIgnoreCase(productStatus)){
                pendingProducts = total;
            }

            else if("Approved".equalsIgnoreCase(productStatus)){
                approvedProducts = total;
            }

            else if("Rejected".equalsIgnoreCase(productStatus)){
                rejectedProducts = total;
            }
        }
    }


    // ============================================================
    // ACTIVE RENTALS
    //
    // IMPORTANT:
    // Using rental_status instead of old "status"
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT COUNT(*) " +
            "FROM rentals " +
            "WHERE rental_status='ACTIVE'"

        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            activeRentals = rs.getInt(1);
        }
    }


    // ============================================================
    // NEW RETURN REQUESTS WAITING FOR ADMIN
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT COUNT(*) " +
            "FROM rentals " +
            "WHERE rental_status='RETURN_REQUESTED'"

        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            returnRequests = rs.getInt(1);
        }
    }


    // ============================================================
    // ADMIN APPROVED / OWNER HANDOVER PENDING
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT COUNT(*) " +
            "FROM rentals " +
            "WHERE rental_status='RETURN_APPROVED'"

        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            approvedReturns = rs.getInt(1);
        }
    }


    // ============================================================
    // COMPLETED RETURNS
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT COUNT(*) " +
            "FROM rentals " +
            "WHERE rental_status='RETURNED'"

        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            completedReturns = rs.getInt(1);
        }
    }


    // ============================================================
    // REFUNDS WAITING / PROCESSING
    //
    // deposit_refunds is now our main refund table.
    // ============================================================

    try(PreparedStatement ps =
        con.prepareStatement(

            "SELECT COUNT(*) " +
            "FROM deposit_refunds " +
            "WHERE refund_status IN " +
            "('RETURN_VERIFIED','APPROVED','PENDING','HELD')"

        );
        ResultSet rs = ps.executeQuery()) {

        if(rs.next()){
            refundWaiting = rs.getInt(1);
        }
    }


} catch(Exception e) {

%>

<div class="alert alert-danger">
    <strong>Dashboard Error:</strong>
    <%= e.getMessage() %>
</div>

<%

}

%>


<div class="container-fluid admin-dashboard">


    <!-- ========================================================
         HEADER
    ========================================================= -->

    <div class="dashboard-header">

        <div>

            <h2>Dashboard</h2>

            <p>
                Overview of RentEasy users, products,
                rentals, returns and refunds.
            </p>

        </div>

    </div>



    <!-- ========================================================
         FIRST ROW
    ========================================================= -->

    <div class="row g-4">


        <!-- USERS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminUsers.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Total Users
                            </div>

                            <div class="stat-number">
                                <%= users %>
                            </div>

                        </div>

                        <div class="stat-icon icon-users">
                            👥
                        </div>

                    </div>

                    <span class="card-action">
                        Manage Users →
                    </span>

                </div>

            </a>

        </div>



        <!-- PRODUCTS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminProducts.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Total Products
                            </div>

                            <div class="stat-number">
                                <%= products %>
                            </div>

                        </div>

                        <div class="stat-icon icon-products">
                            📦
                        </div>

                    </div>

                    <span class="card-action">
                        Manage Products →
                    </span>

                </div>

            </a>

        </div>



        <!-- ACTIVE RENTALS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminRentals.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Active Rentals
                            </div>

                            <div class="stat-number">
                                <%= activeRentals %>
                            </div>

                        </div>

                        <div class="stat-icon icon-rentals">
                            🔄
                        </div>

                    </div>

                    <span class="card-action">
                        View Rentals →
                    </span>

                </div>

            </a>

        </div>



        <!-- PENDING PRODUCTS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminProducts.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Pending Products
                            </div>

                            <div class="stat-number">
                                <%= pendingProducts %>
                            </div>

                        </div>

                        <div class="stat-icon icon-pending">
                            ⏳
                        </div>

                    </div>

                    <span class="card-action">
                        Review Products →
                    </span>

                </div>

            </a>

        </div>


    </div>



    <!-- ========================================================
         RETURN MANAGEMENT TITLE
    ========================================================= -->

    <div class="mt-5 mb-3">

        <h4 style="
            font-weight:700;
            color:#0f172a;
            margin-bottom:5px;
        ">
            Return & Refund Management
        </h4>

        <p style="
            color:#64748b;
            font-size:14px;
        ">
            Monitor the complete rental return and
            security deposit process.
        </p>

    </div>



    <!-- ========================================================
         RETURN CARDS
    ========================================================= -->

    <div class="row g-4">


        <!-- RETURN REQUEST -->

        <div class="col-xl-3 col-md-6">

            <a href="adminReturnRequests.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">

                                Return Requests

                                <%
                                if(returnRequests > 0){
                                %>

                                <span class="notification-dot">
                                    <%= returnRequests %>
                                </span>

                                <%
                                }
                                %>

                            </div>
                            

                            <div class="stat-number">
                                <%= returnRequests %>
                            </div>

                        </div>

                        <div class="stat-icon icon-return">
                            ↩
                        </div>

                    </div>

                    <span class="card-action">
                        Review Requests →
                    </span>

                </div>

            </a>

        </div>



        <!-- APPROVED RETURNS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminReturns.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Approved Returns
                            </div>

                            <div class="stat-number">
                                <%= approvedReturns %>
                            </div>

                        </div>

                        <div class="stat-icon icon-return">
                            ✓
                        </div>

                    </div>

                    <span class="card-action">
                        Track Returns →
                    </span>

                </div>

            </a>

        </div>



        <!-- REFUNDS -->

        <div class="col-xl-3 col-md-6">

            <a href="adminRefund.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Refund Processing
                            </div>

                            <div class="stat-number">
                                <%= refundWaiting %>
                            </div>

                        </div>

                        <div class="stat-icon icon-refund">
                            ₹
                        </div>

                    </div>

                    <span class="card-action">
                        Manage Refunds →
                    </span>

                </div>

            </a>

        </div>



        <!-- COMPLETED -->

        <div class="col-xl-3 col-md-6">

            <a href="adminReturns.jsp"
               class="dashboard-link">

                <div class="stat-card">

                    <div class="stat-top">

                        <div>

                            <div class="stat-title">
                                Completed Returns
                            </div>

                            <div class="stat-number">
                                <%= completedReturns %>
                            </div>

                        </div>

                        <div class="stat-icon icon-completed">
                            ✓
                        </div>

                    </div>

                    <span class="card-action">
                        View History →
                    </span>

                </div>

            </a>

        </div>


    </div>



    <!-- ========================================================
         ANALYTICS
    ========================================================= -->

    <div class="row g-4 mt-4">


        <!-- CHART -->

        <div class="col-lg-7">

            <div class="dashboard-panel">

                <div class="panel-title">
                    Product Status Analytics
                </div>

                <div class="panel-subtitle">
                    Current product approval distribution.
                </div>

                <div style="
                    max-width:390px;
                    margin:auto;
                ">

                    <canvas id="productChart"></canvas>

                </div>

            </div>

        </div>



        <!-- QUICK INFORMATION -->

        <div class="col-lg-5">

            <div class="dashboard-panel">

                <div class="panel-title">
                    Quick Information
                </div>

                <div class="panel-subtitle">
                    Product approval summary.
                </div>


                <div class="quick-row">

                    <span class="quick-label">
                        ✓ Approved Products
                    </span>

                    <span class="quick-number"
                          style="color:#16a34a;">
                        <%= approvedProducts %>
                    </span>

                </div>


                <div class="quick-row">

                    <span class="quick-label">
                        ⏳ Pending Products
                    </span>

                    <span class="quick-number"
                          style="color:#d97706;">
                        <%= pendingProducts %>
                    </span>

                </div>


                <div class="quick-row">

                    <span class="quick-label">
                        ✕ Rejected Products
                    </span>

                    <span class="quick-number"
                          style="color:#dc2626;">
                        <%= rejectedProducts %>
                    </span>

                </div>


                <div class="quick-row">

                    <span class="quick-label">
                        ↩ New Return Requests
                    </span>

                    <span class="quick-number"
                          style="color:#ea580c;">
                        <%= returnRequests %>
                    </span>

                </div>


                <div class="quick-row">

                    <span class="quick-label">
                        ₹ Refund Processing
                    </span>

                    <span class="quick-number"
                          style="color:#2563eb;">
                        <%= refundWaiting %>
                    </span>

                </div>

            </div>

        </div>

    </div>



    <!-- ========================================================
         RETURN WORKFLOW
    ========================================================= -->

    <div class="return-flow">

        <div class="dashboard-panel">

            <div class="panel-title">
                Return Process
            </div>

            <div class="panel-subtitle">
                Current RentEasy product return workflow.
            </div>


            <div class="row mt-4">


                <div class="col-lg-3">

                    <div class="flow-item">

                        <div class="flow-icon">
                            1
                        </div>

                        <div class="flow-title">
                            User Requests Return
                        </div>

                        <div class="flow-text">
                            Rental becomes
                            RETURN_REQUESTED.
                        </div>

                    </div>

                </div>


                <div class="col-lg-3">

                    <div class="flow-item">

                        <div class="flow-icon">
                            2
                        </div>

                        <div class="flow-title">
                            Admin Approval
                        </div>

                        <div class="flow-text">
                            Admin approves and the
                            return OTP is generated.
                        </div>

                    </div>

                </div>


                <div class="col-lg-3">

                    <div class="flow-item">

                        <div class="flow-icon">
                            3
                        </div>

                        <div class="flow-title">
                            Owner Verification
                        </div>

                        <div class="flow-text">
                            Owner verifies OTP and
                            checks product condition.
                        </div>

                    </div>

                </div>


                <div class="col-lg-3">

                    <div class="flow-item">

                        <div class="flow-icon">
                            4
                        </div>

                        <div class="flow-title">
                            Deposit Refund
                        </div>

                        <div class="flow-text">
                            Admin processes the final
                            security deposit refund.
                        </div>

                    </div>

                </div>


            </div>

        </div>

    </div>


</div>


<script>

const productChart =
document.getElementById('productChart');

new Chart(productChart, {

    type: 'doughnut',

    data: {

        labels: [
            'Pending',
            'Approved',
            'Rejected'
        ],

        datasets: [{

            data: [
                <%= pendingProducts %>,
                <%= approvedProducts %>,
                <%= rejectedProducts %>
            ],

            backgroundColor: [
                '#f59e0b',
                '#16a34a',
                '#ef4444'
            ],

            borderWidth: 3,

            borderColor: '#ffffff'

        }]
    },

    options: {

        responsive:true,

        maintainAspectRatio:true,

        cutout:'68%',

        plugins: {

            legend: {

                position:'bottom',

                labels:{
                    padding:20,
                    usePointStyle:true
                }

            }

        }

    }

});

</script>


<%

if(con != null){

    try{
        con.close();
    }
    catch(Exception ignored){}
}

%>