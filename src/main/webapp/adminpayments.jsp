<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.text.DecimalFormat"%>

<%
//=====================================================
//ADMIN LOGIN CHECK
//=====================================================

if (!"ADMIN".equals(session.getAttribute("role"))) {

 response.sendRedirect("index.jsp");
 return;
}

String adminEmail = (String) session.getAttribute("email");

if (adminEmail == null) {
 adminEmail = "renteasy.project@gmail.com";
}

/* =========================================================
   DASHBOARD VALUES
========================================================= */

double totalCollection = 0;
double ownerPayout = 0;
double platformRevenue = 0;
double depositHeld = 0;

int totalPayments = 0;
int pendingPayments = 0;
int completedPayments = 0;

DecimalFormat df = new DecimalFormat("#,##0.00");

Connection con = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    /* Total Collection */

    PreparedStatement ps =
        con.prepareStatement(

        "SELECT " +
        "COUNT(*) totalPayments," +
        "IFNULL(SUM(total_amount),0) totalCollection," +
        "IFNULL(SUM(rent_amount),0) ownerRent," +
        "IFNULL(SUM(deposit_amount),0) totalDeposit " +
        "FROM payments " +
        "WHERE payment_status='SUCCESS'"

    );

    ResultSet rs = ps.executeQuery();

    if(rs.next()){

        totalPayments =
            rs.getInt("totalPayments");

        totalCollection =
            rs.getDouble("totalCollection");

        ownerPayout =
            rs.getDouble("ownerRent");

        depositHeld =
            rs.getDouble("totalDeposit");
    }

    rs.close();
    ps.close();


    /* Pending */

    ps = con.prepareStatement(

        "SELECT COUNT(*) " +
        "FROM payments " +
        "WHERE payment_status='PENDING'"

    );

    rs = ps.executeQuery();

    if(rs.next()){

        pendingPayments =
            rs.getInt(1);

    }

    rs.close();
    ps.close();


    /* Completed */

    ps = con.prepareStatement(

        "SELECT COUNT(*) " +
        "FROM payments " +
        "WHERE payment_status='SUCCESS'"

    );

    rs = ps.executeQuery();

    if(rs.next()){

        completedPayments =
            rs.getInt(1);

    }

    rs.close();
    ps.close();


    /* Platform Revenue */

    platformRevenue =
            ownerPayout * 0.10;

    ownerPayout =
            ownerPayout - platformRevenue;

}catch(Exception e){

    e.printStackTrace();

}finally{

    if(con!=null){

        try{

            con.close();

        }catch(Exception ex){}

    }

}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<title>

Admin Payment Management

</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
href="css/admin.css">

<style>

/* =====================================================
   PAGE
===================================================== */

body{

background:#f4f7fb;

font-family:
'Segoe UI',sans-serif;

}

.payment-wrapper{

padding:30px;

}

/* =====================================================
   HEADER
===================================================== */

.page-header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:25px;

}

.page-title h2{

font-weight:700;

margin:0;

}

.page-title p{

margin-top:5px;

color:#777;

}

/* =====================================================
   DASHBOARD
===================================================== */

.dashboard-grid{

display:grid;

grid-template-columns:
repeat(4,1fr);

gap:20px;

margin-bottom:25px;

}

.dashboard-card{

background:white;

border-radius:16px;

padding:24px;

box-shadow:
0 4px 18px
rgba(0,0,0,.08);

transition:.3s;

}

.dashboard-card:hover{

transform:translateY(-5px);

}

.card-icon{

width:55px;

height:55px;

border-radius:14px;

display:flex;

align-items:center;

justify-content:center;

font-size:24px;

color:white;

margin-bottom:20px;

}

.bg-blue{

background:#2563eb;

}

.bg-green{

background:#16a34a;

}

.bg-orange{

background:#ea580c;

}

.bg-purple{

background:#7c3aed;

}

.dashboard-card h3{

margin:0;

font-size:28px;

font-weight:700;

}

.dashboard-card span{

color:#666;

}

/* =====================================================
   SEARCH
===================================================== */

.search-panel{

background:white;

border-radius:16px;

padding:20px;

margin-bottom:25px;

box-shadow:
0 3px 15px
rgba(0,0,0,.08);

}

.table-card{

background:white;

border-radius:16px;

padding:25px;

box-shadow:
0 3px 15px
rgba(0,0,0,.08);

}

.status{

padding:6px 14px;

border-radius:20px;

font-size:12px;

font-weight:600;

}

.success{

background:#dcfce7;

color:#15803d;

}

.pending{

background:#fff7ed;

color:#ea580c;

}

.failed{

background:#fee2e2;

color:#dc2626;

}

</style>

</head>

<body>

<!-- =====================================================
     SAME ADMIN LAYOUT
===================================================== -->

<jsp:include page="adminLayout.jsp"/>

<div class="payment-wrapper">

<!-- =====================================================
     HEADER
===================================================== -->

<div class="page-header">

<div class="page-title">

<h2>

Payment Management

</h2>

<p>

Monitor payments, owner payouts,
commissions and deposits.

</p>

</div>

</div>

<!-- =====================================================
     DASHBOARD
===================================================== -->

<div class="dashboard-grid">

<div class="dashboard-card">

<div class="card-icon bg-blue">

<i class="bi bi-wallet2"></i>

</div>

<h3>

₹<%=df.format(totalCollection)%>

</h3>

<span>Total Collection</span>

</div>

<div class="dashboard-card">

<div class="card-icon bg-green">

<i class="bi bi-bank"></i>

</div>

<h3>

₹<%=df.format(ownerPayout)%>

</h3>

<span>Owner Payout</span>

</div>

<div class="dashboard-card">

<div class="card-icon bg-orange">

<i class="bi bi-percent"></i>

</div>

<h3>

₹<%=df.format(platformRevenue)%>

</h3>

<span>Platform Revenue</span>

</div>

<div class="dashboard-card">

<div class="card-icon bg-purple">

<i class="bi bi-shield-lock"></i>

</div>

<h3>

₹<%=df.format(depositHeld)%>

</h3>

<span>Held Deposits</span>

</div>

</div>

<!-- =====================================================
     SEARCH
===================================================== -->

<div class="search-panel">

<div class="row">

<div class="col-md-5">

<input
type="text"
class="form-control"
placeholder="Search Payment ID, User, Owner">

</div>

<div class="col-md-3">

<select class="form-select">

<option>All Status</option>
<option>SUCCESS</option>
<option>PENDING</option>
<option>FAILED</option>

</select>

</div>

<div class="col-md-2">

<button
class="btn btn-primary w-100">

<i class="bi bi-search"></i>

Search

</button>

</div>

<div class="col-md-2">

<button
class="btn btn-success w-100">

<i class="bi bi-download"></i>

Export

</button>

</div>

</div>

</div>

<!-- =====================================================
     PAYMENT TABLE STARTS HERE
===================================================== -->

<div class="table-card">

<h4 class="mb-4">

Recent Payments

</h4>

<table
class="table table-hover align-middle">

<thead class="table-light">

<tr>

<th>#</th>

<th>User</th>

<th>Owner</th>

<th>Product</th>

<th>Rent</th>

<th>Deposit</th>

<th>Total</th>

<th>Status</th>

<th>Actions</th>

</tr>

</thead>

<tbody>
<%
Connection tableCon = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    tableCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    PreparedStatement ps =
        tableCon.prepareStatement(

        "SELECT " +

        "p.payment_id, " +
        "p.payment_date, " +
        "p.payment_status, " +
        "p.razorpay_payment_id, " +
        "p.rent_amount, " +
        "p.deposit_amount, " +
        "p.total_amount, " +

        "u.first_name userFirst, " +
        "u.last_name userLast, " +

        "o.first_name ownerFirst, " +
        "o.last_name ownerLast, " +

        "pr.name productName " +

        "FROM payments p " +

        "JOIN users u " +
        "ON p.user_id=u.id " +

        "JOIN users o " +
        "ON p.owner_id=o.id " +

        "JOIN products pr " +
        "ON p.product_id=pr.id " +

        "ORDER BY p.payment_id DESC"

    );

    ResultSet rs = ps.executeQuery();

    while(rs.next()){

        String status =
            rs.getString("payment_status");

        String badge="pending";

        if("SUCCESS".equalsIgnoreCase(status))
            badge="success";

        else if("FAILED".equalsIgnoreCase(status))
            badge="failed";
%>

<tr>

<td>

<b>

#<%=rs.getInt("payment_id")%>

</b>

</td>

<td>

<%=rs.getString("userFirst")%>
<%=rs.getString("userLast")%>

</td>

<td>

<%=rs.getString("ownerFirst")%>
<%=rs.getString("ownerLast")%>

</td>

<td>

<%=rs.getString("productName")%>

</td>

<td>

₹<%=df.format(
rs.getDouble("rent_amount"))%>

</td>

<td>

₹<%=df.format(
rs.getDouble("deposit_amount"))%>

</td>

<td>

<b>

₹<%=df.format(
rs.getDouble("total_amount"))%>

</b>

</td>

<td>

<span class="status <%=badge%>">

<%=status%>

</span>

</td>

<td>

<div class="dropdown">

<button
class="btn btn-sm btn-outline-primary dropdown-toggle"
data-bs-toggle="dropdown">

Actions

</button>

<ul class="dropdown-menu">

<li>

<a
class="dropdown-item"

href="adminPaymentDetails.jsp?id=<%=rs.getInt("payment_id")%>">

<i class="bi bi-eye"></i>

View Details

</a>

</li>

<li>

<a
class="dropdown-item"

href="ownerPayout.jsp?id=<%=rs.getInt("payment_id")%>">

<i class="bi bi-bank"></i>

Release Owner Payment

</a>

</li>

<li>

<a
class="dropdown-item"

href="adminRefund.jsp?paymentId=<%=rs.getInt("payment_id")%>">

<i class="bi bi-arrow-counterclockwise"></i>

Deposit Refund

</a>

</li>

<li><hr class="dropdown-divider"></li>

<li>

<a
class="dropdown-item"

href="#">

<i class="bi bi-receipt"></i>

Download Receipt

</a>

</li>

</ul>

</div>

</td>

</tr>

<%
    }

    rs.close();
    ps.close();

}catch(Exception e){
%>

<tr>

<td colspan="9"
class="text-center text-danger">

<%=e.getMessage()%>

</td>

</tr>

<%

}finally{

    if(tableCon!=null){

        try{

            tableCon.close();

        }catch(Exception ex){}

    }

}
%>

</tbody>

</table>

</div>

<!-- =====================================================
     PAYMENT SUMMARY
===================================================== -->

<div class="row mt-4">

<div class="col-md-4">

<div class="dashboard-card">

<div class="card-icon bg-blue">

<i class="bi bi-credit-card"></i>

</div>

<h3>

<%=completedPayments%>

</h3>

<span>

Completed Payments

</span>

</div>

</div>

<div class="col-md-4">

<div class="dashboard-card">

<div class="card-icon bg-orange">

<i class="bi bi-clock-history"></i>

</div>

<h3>

<%=pendingPayments%>

</h3>

<span>

Pending Payments

</span>

</div>

</div>

<div class="col-md-4">

<div class="dashboard-card">

<div class="card-icon bg-green">

<i class="bi bi-wallet-fill"></i>

</div>

<h3>

<%=totalPayments%>

</h3>

<span>

Total Successful Payments

</span>

</div>

</div>

</div>

<!-- =====================================================
     OWNER PAYOUT SECTION STARTS
===================================================== -->
<div class="row mt-4">

<!-- =====================================================
     OWNER PAYOUT PANEL
===================================================== -->

<div class="col-lg-7">

<div class="table-card">

<h4 class="mb-4">

<i class="bi bi-bank"></i>

Owner Payout Queue

</h4>

<table class="table table-hover align-middle">

<thead class="table-light">

<tr>

<th>Payment</th>

<th>Owner</th>

<th>Rent</th>

<th>Commission</th>

<th>Payout</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

Connection payoutCon = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

payoutCon = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps =
payoutCon.prepareStatement(

"SELECT " +

"p.payment_id," +
"p.rent_amount," +
"p.payment_status," +

"u.first_name," +
"u.last_name " +

"FROM payments p " +

"JOIN users u " +
"ON p.owner_id=u.id " +

"WHERE p.payment_status='SUCCESS' " +

"ORDER BY p.payment_id DESC"

);

ResultSet rs = ps.executeQuery();

while(rs.next()){

double rent =
rs.getDouble("rent_amount");

double commission =
rent*0.10;

double payout =
rent-commission;

%>

<tr>

<td>

#<%=rs.getInt("payment_id")%>

</td>

<td>

<%=rs.getString("first_name")%>
<%=rs.getString("last_name")%>

</td>

<td>

₹<%=df.format(rent)%>

</td>

<td class="text-danger">

₹<%=df.format(commission)%>

</td>

<td class="text-success fw-bold">

₹<%=df.format(payout)%>

</td>

<td>

<a href="OwnerPaymentReleaseServlet?paymentId=<%=rs.getInt("payment_id")%>"
   class="btn btn-success btn-sm">
    <i class="bi bi-send-check"></i>
    Release
</a>

</td>

</tr>

<%

}

rs.close();
ps.close();

}catch(Exception e){

%>

<tr>

<td colspan="6">

<%=e.getMessage()%>

</td>

</tr>

<%

}finally{

if(payoutCon!=null){

try{

payoutCon.close();

}catch(Exception ex){}

}

}

%>

</tbody>

</table>

</div>

</div>

<!-- =====================================================
     DEPOSIT SUMMARY
===================================================== -->

<div class="col-lg-5">

<div class="dashboard-card mb-4">

<div class="card-icon bg-purple">

<i class="bi bi-shield-lock-fill"></i>

</div>

<h3>

₹<%=df.format(depositHeld)%>

</h3>

<span>

Security Deposits Held

</span>

</div>

<div class="dashboard-card mb-4">

<div class="card-icon bg-green">

<i class="bi bi-arrow-counterclockwise"></i>

</div>

<h3>

₹<%=df.format(ownerPayout)%>

</h3>

<span>

Owner Payment Released

</span>

</div>

<div class="dashboard-card">

<div class="card-icon bg-orange">

<i class="bi bi-percent"></i>

</div>

<h3>

₹<%=df.format(platformRevenue)%>

</h3>

<span>

Platform Commission

</span>

</div>

</div>

</div>

<!-- =====================================================
     MONTHLY REPORT
===================================================== -->

<div class="table-card mt-4">

<h4 class="mb-4">

Monthly Revenue Report

</h4>

<table class="table table-bordered">

<thead class="table-light">

<tr>

<th>Month</th>

<th>Payments</th>

<th>Collection</th>

<th>Commission</th>

<th>Payout</th>

</tr>

</thead>

<tbody>

<tr>

<td>This Month</td>

<td><%=completedPayments%></td>

<td>

₹<%=df.format(totalCollection)%>

</td>

<td>

₹<%=df.format(platformRevenue)%>

</td>

<td>

₹<%=df.format(ownerPayout)%>

</td>

</tr>

</tbody>

</table>

</div>

<!-- =====================================================
     RECENT TRANSACTIONS
===================================================== -->

<div class="table-card mt-4">

<h4 class="mb-4">

Recent Transactions

</h4>

<div class="list-group">

<%

Connection recentCon = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

recentCon = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps =
recentCon.prepareStatement(

"SELECT payment_id,total_amount,payment_date " +

"FROM payments " +

"WHERE payment_status='SUCCESS' " +

"ORDER BY payment_date DESC LIMIT 5"

);

ResultSet rs = ps.executeQuery();

while(rs.next()){

%>

<div class="list-group-item">

<div class="d-flex justify-content-between">

<div>

<b>

Payment #

<%=rs.getInt("payment_id")%>

</b>

<br>

<small>

<%=rs.getTimestamp("payment_date")%>

</small>

</div>

<div class="text-success fw-bold">

₹<%=df.format(
rs.getDouble("total_amount"))%>

</div>

</div>

</div>

<%

}

rs.close();
ps.close();

}catch(Exception e){

out.println(e);

}finally{

if(recentCon!=null){

try{

recentCon.close();

}catch(Exception ex){}

}

}

%>

</div>

</div>

<!-- =====================================================
     FINAL REPORT SECTION STARTS
===================================================== -->
<!-- =====================================================
     PAYMENT ANALYTICS
===================================================== -->

<div class="row mt-4">

    <!-- Payment Statistics -->

    <div class="col-lg-6">

        <div class="table-card">

            <h4 class="mb-4">

                <i class="bi bi-graph-up-arrow"></i>

                Payment Analytics

            </h4>

            <table class="table">

                <tr>

                    <td>Total Successful Payments</td>

                    <td class="fw-bold">
                        <%=completedPayments%>
                    </td>

                </tr>

                <tr>

                    <td>Pending Payments</td>

                    <td class="fw-bold text-warning">
                        <%=pendingPayments%>
                    </td>

                </tr>

                <tr>

                    <td>Total Collection</td>

                    <td class="fw-bold text-success">
                        ₹<%=df.format(totalCollection)%>
                    </td>

                </tr>

                <tr>

                    <td>Owner Payout</td>

                    <td class="fw-bold">
                        ₹<%=df.format(ownerPayout)%>
                    </td>

                </tr>

                <tr>

                    <td>Platform Revenue</td>

                    <td class="fw-bold text-primary">
                        ₹<%=df.format(platformRevenue)%>
                    </td>

                </tr>

                <tr>

                    <td>Security Deposit Held</td>

                    <td class="fw-bold">
                        ₹<%=df.format(depositHeld)%>
                    </td>

                </tr>

            </table>

        </div>

    </div>



    <!-- Finance Summary -->

    <div class="col-lg-6">

        <div class="table-card">

            <h4 class="mb-4">

                <i class="bi bi-journal-text"></i>

                Finance Summary

            </h4>

            <div class="alert alert-success">

                <b>Total Revenue</b>

                <br>

                ₹<%=df.format(totalCollection)%>

            </div>

            <div class="alert alert-primary">

                <b>Commission Earned</b>

                <br>

                ₹<%=df.format(platformRevenue)%>

            </div>

            <div class="alert alert-warning">

                <b>Owner Payments</b>

                <br>

                ₹<%=df.format(ownerPayout)%>

            </div>

            <div class="alert alert-info">

                <b>Deposits Under Hold</b>

                <br>

                ₹<%=df.format(depositHeld)%>

            </div>

        </div>

    </div>

</div>

<!-- =====================================================
     ADMIN NOTES
===================================================== -->

<div class="table-card mt-4">

    <h4>

        Admin Notes

    </h4>

    <textarea

        class="form-control mt-3"

        rows="5"

        placeholder="Write internal payment notes here..."></textarea>

    <button

        class="btn btn-primary mt-3">

        Save Notes

    </button>

</div>

<!-- =====================================================
     QUICK ACTIONS
===================================================== -->

<div class="table-card mt-4">

    <h4>

        Quick Actions

    </h4>

    <div class="row mt-3">

        <div class="col-md-3">

            <a href="adminRefund.jsp"

               class="btn btn-warning w-100">

                <i class="bi bi-arrow-counterclockwise"></i>

                Refund Center

            </a>

        </div>

        <div class="col-md-3">

            <a href="adminDashboard.jsp"

               class="btn btn-primary w-100">

                <i class="bi bi-speedometer2"></i>

                Dashboard

            </a>

        </div>

        <div class="col-md-3">

            <a href="adminProducts.jsp"

               class="btn btn-success w-100">

                <i class="bi bi-box-seam"></i>

                Products

            </a>

        </div>

        <div class="col-md-3">

            <button

                onclick="window.print()"

                class="btn btn-dark w-100">

                <i class="bi bi-printer"></i>

                Print Report

            </button>

        </div>

    </div>

</div>

</div>

<!-- =====================================================
     JAVASCRIPT
===================================================== -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

function searchPayments(){

    let input =
        document.querySelector(
        "input[type='text']"
        ).value.toLowerCase();

    let rows =
        document.querySelectorAll(
        "tbody tr"
        );

    rows.forEach(function(row){

        let text =
            row.innerText.toLowerCase();

        if(text.indexOf(input)>-1){

            row.style.display="";

        }else{

            row.style.display="none";

        }

    });

}

document.querySelector(
"input[type='text']"
).addEventListener(
"keyup",
searchPayments
);

</script>

</body>

</html>