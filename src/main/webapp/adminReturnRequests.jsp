<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<title>Return Requests - RentEasy Admin</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
    background:#f5f7fb;
}

.page-container{
    max-width:1250px;
    margin:40px auto;
}

.page-title{
    font-size:32px;
    font-weight:700;
    color:#0f172a;
}

.subtitle{
    color:#64748b;
    margin-bottom:30px;
}

.return-card{
    background:white;
    border-radius:18px;
    padding:25px;
    margin-bottom:25px;
    box-shadow:0 8px 25px rgba(0,0,0,.07);
}

.product-img{
    width:140px;
    height:140px;
    object-fit:cover;
    border-radius:15px;
}

.info-label{
    font-weight:600;
    color:#475569;
}

.request-badge{
    display:inline-block;
    padding:7px 14px;
    background:#fef3c7;
    color:#b45309;
    border-radius:20px;
    font-weight:600;
}

.empty-box{
    background:white;
    padding:60px;
    border-radius:18px;
    text-align:center;
    box-shadow:0 8px 25px rgba(0,0,0,.07);
}

</style>

</head>

<body>

<div class="page-container">

<h1 class="page-title">

<i class="bi bi-arrow-return-left"></i>

Return Requests

</h1>

<p class="subtitle">
Review product return requests submitted by rental users.
</p>

<%
String success = request.getParameter("success");

if("approved".equalsIgnoreCase(success)){
%>

<div class="alert alert-success">

<i class="bi bi-check-circle-fill"></i>

Return request approved successfully.

</div>

<%
}
%>

<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    String sql =

        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.rent_amount, " +
        "r.security_deposit, " +
        "r.rental_status, " +

        "p.name AS product_name, " +
        "p.image AS product_image, " +

        "CONCAT(u.first_name,' ',u.last_name) AS user_name, " +
        "u.email AS user_email, " +
        "u.phone AS user_phone, " +

        "CONCAT(o.first_name,' ',o.last_name) AS owner_name, " +
        "o.email AS owner_email, " +
        "o.phone AS owner_phone " +

        "FROM rentals r " +

        "JOIN products p ON r.product_id=p.id " +

        "JOIN users u ON r.user_id=u.id " +

        "JOIN users o ON r.owner_id=o.id " +

        "WHERE r.rental_status='RETURN_REQUESTED' " +

        "ORDER BY r.rental_id DESC";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();

    boolean found = false;

    while(rs.next()){

        found = true;
%>

<div class="return-card">

<div class="row">

<div class="col-md-2">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("product_image")%>"
class="product-img">

</div>


<div class="col-md-6">

<h4>
<%=rs.getString("product_name")%>
</h4>

<p class="text-muted">
Rental ID #<%=rs.getInt("rental_id")%>
</p>

<span class="request-badge">

<i class="bi bi-hourglass-split"></i>

RETURN REQUESTED

</span>

<hr>

<p>

<span class="info-label">
Renter:
</span>

<%=rs.getString("user_name")%>

</p>

<p>

<span class="info-label">
Renter Email:
</span>

<%=rs.getString("user_email")%>

</p>

<p>

<span class="info-label">
Renter Phone:
</span>

<%=rs.getString("user_phone")%>

</p>

<p>

<span class="info-label">
Owner:
</span>

<%=rs.getString("owner_name")%>

</p>

<p>

<span class="info-label">
Rental Period:
</span>

<%=rs.getDate("start_date")%>

to

<%=rs.getDate("end_date")%>

</p>

<p>

<span class="info-label">
Security Deposit:
</span>

<strong>
₹<%=rs.getDouble("security_deposit")%>
</strong>

</p>

</div>


<div class="col-md-4">

<div class="alert alert-warning">

<strong>Return approval required</strong>

<br><br>

Approve this request to start the physical product return process.

</div>


<form action="ApproveNewReturnServlet"
      method="post">

<input type="hidden"
       name="rentalId"
       value="<%=rs.getInt("rental_id")%>">

<button
type="submit"
class="btn btn-success w-100 mb-2">

<i class="bi bi-check-circle"></i>

Approve Return

</button>

</form>


<a
href="userReturnDetails.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn btn-outline-primary w-100">

<i class="bi bi-eye"></i>

View Rental Details

</a>

</div>

</div>

</div>

<%
    }

    if(!found){
%>

<div class="empty-box">

<i class="bi bi-check-circle"
style="font-size:60px;color:#16a34a;"></i>

<h3 class="mt-3">
No Pending Return Requests
</h3>

<p class="text-muted">

New user return requests will appear here.

</p>

</div>

<%
    }

}
catch(Exception e){
%>

<div class="alert alert-danger">

<strong>Database Error:</strong>

<%=e.getMessage()%>

</div>

<%
}
finally{

    if(rs != null){
        try{
            rs.close();
        }catch(Exception ignored){}
    }

    if(ps != null){
        try{
            ps.close();
        }catch(Exception ignored){}
    }

    if(con != null){
        try{
            con.close();
        }catch(Exception ignored){}
    }
}
%>

</div>

</body>

</html>