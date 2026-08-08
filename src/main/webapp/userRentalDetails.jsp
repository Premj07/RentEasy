<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
String userIdParam = request.getParameter("userId");

if(userIdParam == null || userIdParam.trim().isEmpty()){
    response.sendRedirect("adminReturns.jsp");
    return;
}

int userId;

try{
    userId = Integer.parseInt(userIdParam);
}catch(NumberFormatException e){
    response.sendRedirect("adminReturns.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>User Rental Details - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
    background:#f6f8fc;
    color:#0f172a;
    font-family:Arial, sans-serif;
}

.page-wrapper{
    max-width:1400px;
    margin:45px auto;
    padding:0 25px;
}

/* HEADER */

.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}

.page-title{
    font-size:30px;
    font-weight:700;
    margin:0;
}

.page-subtitle{
    color:#64748b;
    margin-top:6px;
    margin-bottom:0;
}

.back-btn{
    border:1px solid #dbe3ef;
    background:#fff;
    color:#2563eb;
    text-decoration:none;
    padding:10px 16px;
    border-radius:9px;
    font-weight:600;
}

.back-btn:hover{
    background:#eff6ff;
}

/* USER CARD */

.user-card{
    background:white;
    border:1px solid #e6ebf2;
    border-radius:16px;
    padding:22px 25px;
    margin-bottom:24px;
    box-shadow:0 5px 18px rgba(15,23,42,.05);
}

.user-icon{
    width:48px;
    height:48px;
    border-radius:12px;
    background:#eff6ff;
    color:#2563eb;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:22px;
}

.user-name{
    font-size:19px;
    font-weight:700;
}

.user-email{
    color:#64748b;
    font-size:14px;
}

/* TABLE CARD */

.table-card{
    background:white;
    border:1px solid #e6ebf2;
    border-radius:16px;
    padding:22px;
    box-shadow:0 5px 18px rgba(15,23,42,.05);
}

.table-card h5{
    font-weight:700;
}

.table-card p{
    color:#64748b;
    font-size:14px;
}

table{
    margin-top:20px;
}

.table thead th{
    background:#111827;
    color:white;
    padding:14px;
    font-size:13px;
    border:none;
}

.table tbody td{
    padding:15px 14px;
    vertical-align:middle;
    border-color:#edf1f5;
}

/* PRODUCT */

.product-info{
    display:flex;
    align-items:center;
    gap:12px;
}

.product-img{
    width:60px;
    height:60px;
    border-radius:10px;
    object-fit:cover;
    border:1px solid #e5e7eb;
}

.product-name{
    font-weight:700;
}

/* BADGES */

.status{
    padding:7px 11px;
    border-radius:30px;
    font-size:12px;
    font-weight:700;
    display:inline-block;
}

.status-active{
    background:#dcfce7;
    color:#15803d;
}

.status-requested{
    background:#fef3c7;
    color:#b45309;
}

.status-approved{
    background:#ffedd5;
    color:#c2410c;
}

.status-returned{
    background:#d1fae5;
    color:#047857;
}

.status-default{
    background:#e2e8f0;
    color:#475569;
}

.btn-view{
    background:#2563eb;
    color:white;
    text-decoration:none;
    border-radius:8px;
    padding:8px 13px;
    font-size:13px;
    font-weight:600;
}

.btn-view:hover{
    background:#1d4ed8;
    color:white;
}

/* EMPTY */

.empty-box{
    text-align:center;
    padding:50px 20px;
}

.empty-icon{
    font-size:40px;
    color:#94a3b8;
}

.empty-box h5{
    margin-top:15px;
}

</style>

</head>

<body>

<div class="page-wrapper">

<div class="page-header">

<div>

<h1 class="page-title">
User Rental Details
</h1>

<p class="page-subtitle">
View the user's rentals and current return status.
</p>

</div>

<a href="adminReturns.jsp"
   class="back-btn">

<i class="bi bi-arrow-left"></i>
Back to Rentals

</a>

</div>


<%

Connection con = null;
PreparedStatement userPs = null;
ResultSet userRs = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    /*
     * =========================================
     * GET USER INFORMATION
     * =========================================
     */

    String userSql =
        "SELECT first_name, last_name, email, phone " +
        "FROM users WHERE id=?";

    userPs = con.prepareStatement(userSql);

    userPs.setInt(1,userId);

    userRs = userPs.executeQuery();


    if(userRs.next()){

%>


<div class="user-card">

<div class="d-flex align-items-center gap-3">

<div class="user-icon">
<i class="bi bi-person"></i>
</div>

<div>

<div class="user-name">

<%=userRs.getString("first_name")%>
<%=userRs.getString("last_name")%>

</div>

<div class="user-email">

<%=userRs.getString("email")%>

&nbsp; • &nbsp;

<%=userRs.getString("phone")%>

</div>

</div>

</div>

</div>


<%

    }

    userRs.close();
    userPs.close();


    /*
     * =========================================
     * GET RENTALS
     * =========================================
     */

    String sql =

        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.rent_amount, " +
        "r.security_deposit, " +
        "r.rental_status, " +
        "r.payment_status, " +

        "p.name AS product_name, " +
        "p.image AS product_image, " +

        "CONCAT(o.first_name,' ',o.last_name) " +
        "AS owner_name, " +

        "o.email AS owner_email " +

        "FROM rentals r " +

        "JOIN products p " +
        "ON r.product_id=p.id " +

        "JOIN users o " +
        "ON r.owner_id=o.id " +

        "WHERE r.user_id=? " +

        "ORDER BY r.rental_id DESC";


    PreparedStatement ps =
        con.prepareStatement(sql);

    ps.setInt(1,userId);

    ResultSet rs =
        ps.executeQuery();

%>


<div class="table-card">

<h5>
<i class="bi bi-box-seam me-2"></i>
Rental History
</h5>

<p>
All rental transactions associated with this user.
</p>


<div class="table-responsive">

<table class="table align-middle">

<thead>

<tr>

<th>Rental</th>

<th>Product</th>

<th>Owner</th>

<th>Rental Period</th>

<th>Rent</th>

<th>Deposit</th>

<th>Status</th>

<th>Action</th>

</tr>

</thead>


<tbody>


<%

boolean found = false;

while(rs.next()){

    found = true;

    String status =
        rs.getString("rental_status");

    String badgeClass =
        "status-default";

    String displayStatus =
        status;


    if("ACTIVE".equalsIgnoreCase(status)){

        badgeClass =
            "status-active";

        displayStatus =
            "Active";

    }
    else if("RETURN_REQUESTED".equalsIgnoreCase(status)){

        badgeClass =
            "status-requested";

        displayStatus =
            "Return Requested";

    }
    else if("RETURN_APPROVED".equalsIgnoreCase(status)){

        badgeClass =
            "status-approved";

        displayStatus =
            "Waiting for Return";

    }
    else if("RETURNED".equalsIgnoreCase(status)){

        badgeClass =
            "status-returned";

        displayStatus =
            "Returned";

    }

%>


<tr>


<!-- RENTAL ID -->

<td>

<strong>
#<%=rs.getInt("rental_id")%>
</strong>

</td>



<!-- PRODUCT -->

<td>

<div class="product-info">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("product_image")%>"
class="product-img">

<div class="product-name">

<%=rs.getString("product_name")%>

</div>

</div>

</td>



<!-- OWNER -->

<td>

<strong>
<%=rs.getString("owner_name")%>
</strong>

<br>

<small class="text-muted">
<%=rs.getString("owner_email")%>
</small>

</td>



<!-- PERIOD -->

<td>

<%=rs.getDate("start_date")%>

<br>

<small class="text-muted">
to
</small>

<br>

<%=rs.getDate("end_date")%>

</td>



<!-- RENT -->

<td>

<strong style="color:#16a34a;">

₹<%=String.format("%.2f",
rs.getDouble("rent_amount"))%>

</strong>

</td>



<!-- DEPOSIT -->

<td>

₹<%=String.format("%.2f",
rs.getDouble("security_deposit"))%>

</td>



<!-- STATUS -->

<td>

<span class="status <%=badgeClass%>">

<%=displayStatus%>

</span>

</td>



<!-- ACTION -->

<td>

<a
href="userReturnDetails.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn-view">

<i class="bi bi-eye"></i>
View

</a>

</td>


</tr>


<%

}


if(!found){

%>


<tr>

<td colspan="8">

<div class="empty-box">

<div class="empty-icon">

<i class="bi bi-box"></i>

</div>

<h5>
No Rentals Found
</h5>

<p>
This user currently has no rental records.
</p>

</div>

</td>

</tr>


<%

}

rs.close();
ps.close();

%>


</tbody>

</table>

</div>

</div>


<%

}
catch(Exception e){

%>


<div class="alert alert-danger">

<strong>
<i class="bi bi-exclamation-triangle"></i>
Unable to load rental details
</strong>

<br>

<%=e.getMessage()%>

</div>


<%

}
finally{

    try{

        if(userRs != null)
            userRs.close();

        if(userPs != null)
            userPs.close();

        if(con != null)
            con.close();

    }
    catch(Exception ignored){}

}

%>


</div>

</body>
</html>