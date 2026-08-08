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

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

.returns-page{
    padding:15px 10px 50px;
}

.page-heading{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:30px;
}

.page-heading h2{
    margin:0;
    font-size:30px;
    font-weight:700;
    color:#0f172a;
}

.page-heading p{
    color:#64748b;
    margin:6px 0 0;
}

.back-dashboard{
    text-decoration:none;
    font-weight:600;
}


/* STATS */

.return-stat{
    background:white;
    border:1px solid #e8edf5;
    border-radius:16px;
    padding:22px;
    box-shadow:0 4px 14px rgba(15,23,42,.05);
}

.stat-label{
    color:#64748b;
    font-size:14px;
    font-weight:600;
}

.stat-value{
    font-size:30px;
    font-weight:700;
    color:#0f172a;
    margin-top:7px;
}


/* MAIN PANEL */

.returns-panel{
    background:#fff;
    border:1px solid #e8edf5;
    border-radius:18px;
    padding:25px;
    margin-top:28px;
    box-shadow:0 4px 14px rgba(15,23,42,.05);
}

.panel-title{
    font-size:19px;
    font-weight:700;
    color:#0f172a;
}

.panel-description{
    color:#64748b;
    font-size:14px;
    margin-bottom:22px;
}


/* TABLE */

.return-table{
    margin-bottom:0;
}

.return-table thead th{
    background:#111827;
    color:white;
    padding:15px;
    font-size:13px;
    border:none;
}

.return-table td{
    padding:16px 15px;
    vertical-align:middle;
    border-color:#edf1f5;
}


/* PRODUCT */

.product-box{
    display:flex;
    align-items:center;
    gap:13px;
}

.product-image{
    width:62px;
    height:62px;
    object-fit:cover;
    border-radius:10px;
    border:1px solid #e5e7eb;
}

.product-name{
    font-weight:700;
    color:#0f172a;
}

.rental-id{
    font-size:12px;
    color:#64748b;
}


/* BADGES */

.status-badge{
    display:inline-flex;
    align-items:center;
    gap:5px;
    padding:7px 11px;
    border-radius:30px;
    font-size:12px;
    font-weight:700;
}

.status-approved{
    background:#fff7ed;
    color:#c2410c;
}

.status-returned{
    background:#ecfdf5;
    color:#047857;
}

.status-requested{
    background:#fef3c7;
    color:#b45309;
}


/* EMPTY */

.empty-state{
    padding:60px 20px;
    text-align:center;
}

.empty-icon{
    width:65px;
    height:65px;
    margin:auto;
    display:flex;
    justify-content:center;
    align-items:center;
    border-radius:50%;
    background:#ecfdf5;
    color:#16a34a;
    font-size:30px;
}

.empty-state h4{
    margin-top:18px;
    font-weight:700;
}

.empty-state p{
    color:#64748b;
}


/* BUTTON */

.btn-details{
    background:#2563eb;
    color:white;
    border-radius:8px;
    padding:8px 13px;
    text-decoration:none;
    font-size:13px;
    font-weight:600;
}

.btn-details:hover{
    background:#1d4ed8;
    color:white;
}

</style>


<%

int approvedCount = 0;
int completedCount = 0;
int totalReturnCount = 0;

Connection con = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    // APPROVED RETURNS

    try(
        PreparedStatement ps =
            con.prepareStatement(
                "SELECT COUNT(*) FROM rentals " +
                "WHERE rental_status='RETURN_APPROVED'"
            );

        ResultSet rs = ps.executeQuery();
    ){

        if(rs.next()){
            approvedCount = rs.getInt(1);
        }
    }


    // COMPLETED RETURNS

    try(
        PreparedStatement ps =
            con.prepareStatement(
                "SELECT COUNT(*) FROM rentals " +
                "WHERE rental_status='RETURNED'"
            );

        ResultSet rs = ps.executeQuery();
    ){

        if(rs.next()){
            completedCount = rs.getInt(1);
        }
    }


    totalReturnCount =
        approvedCount + completedCount;

%>


<div class="container-fluid returns-page">


    <!-- HEADER -->

    <div class="page-heading">

        <div>

            <h2>
                Return Management
            </h2>

            <p>
                Track approved product returns,
                owner verification and completed returns.
            </p>

        </div>

        <a href="adminDashboard.jsp"
           class="back-dashboard">

            <i class="bi bi-arrow-left"></i>
            Dashboard

        </a>

    </div>



    <!-- STATS -->

    <div class="row g-4">


        <div class="col-md-4">

            <div class="return-stat">

                <div class="stat-label">
                    Total Returns
                </div>

                <div class="stat-value">
                    <%= totalReturnCount %>
                </div>

            </div>

        </div>



        <div class="col-md-4">

            <div class="return-stat">

                <div class="stat-label">
                    Waiting for Owner
                </div>

                <div class="stat-value"
                     style="color:#ea580c;">

                    <%= approvedCount %>

                </div>

            </div>

        </div>



        <div class="col-md-4">

            <div class="return-stat">

                <div class="stat-label">
                    Completed Returns
                </div>

                <div class="stat-value"
                     style="color:#059669;">

                    <%= completedCount %>

                </div>

            </div>

        </div>


    </div>



    <!-- RETURNS -->

    <div class="returns-panel">

        <div class="panel-title">
            Return Records
        </div>

        <div class="panel-description">
            Approved returns waiting for owner verification
            and successfully completed returns.
        </div>


        <div class="table-responsive">

        <table class="table return-table">

        <thead>

        <tr>

            <th>Product</th>

            <th>Renter</th>

            <th>Owner</th>

            <th>Rental Period</th>

            <th>Deposit</th>

            <th>Status</th>

            <th>Action</th>

        </tr>

        </thead>

        <tbody>


<%

    String sql =

        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.security_deposit, " +
        "r.rental_status, " +

        "p.name AS product_name, " +
        "p.image AS product_image, " +

        "CONCAT(u.first_name,' ',u.last_name) " +
        "AS renter_name, " +

        "u.email AS renter_email, " +

        "CONCAT(o.first_name,' ',o.last_name) " +
        "AS owner_name, " +

        "o.email AS owner_email " +

        "FROM rentals r " +

        "JOIN products p " +
        "ON r.product_id=p.id " +

        "JOIN users u " +
        "ON r.user_id=u.id " +

        "JOIN users o " +
        "ON r.owner_id=o.id " +

        "WHERE r.rental_status IN " +
        "('RETURN_APPROVED','RETURNED') " +

        "ORDER BY r.rental_id DESC";


    PreparedStatement ps =
        con.prepareStatement(sql);

    ResultSet rs =
        ps.executeQuery();


    boolean found = false;


    while(rs.next()){

        found = true;

        String status =
            rs.getString("rental_status");

%>


<tr>


<!-- PRODUCT -->

<td>

<div class="product-box">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("product_image")%>"
class="product-image">

<div>

<div class="product-name">
<%=rs.getString("product_name")%>
</div>

<div class="rental-id">
Rental #<%=rs.getInt("rental_id")%>
</div>

</div>

</div>

</td>



<!-- RENTER -->

<td>

<strong>
<%=rs.getString("renter_name")%>
</strong>

<br>

<small class="text-muted">
<%=rs.getString("renter_email")%>
</small>

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

<span class="text-muted">
to
</span>

<br>

<%=rs.getDate("end_date")%>

</td>



<!-- DEPOSIT -->

<td>

<strong>
₹<%=String.format("%.2f",
rs.getDouble("security_deposit"))%>
</strong>

</td>



<!-- STATUS -->

<td>

<%

if("RETURN_APPROVED".equalsIgnoreCase(status)){

%>

<span class="status-badge status-approved">

<i class="bi bi-clock"></i>

Waiting for Owner

</span>

<%

}
else if("RETURNED".equalsIgnoreCase(status)){

%>

<span class="status-badge status-returned">

<i class="bi bi-check-circle"></i>

Returned

</span>

<%

}

%>

</td>



<!-- ACTION -->

<td>

<a
href="adminReturnDetails.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn-details">

<i class="bi bi-eye"></i>

Details

</a>

</td>


</tr>


<%

    }


    if(!found){

%>


<tr>

<td colspan="7">

<div class="empty-state">

<div class="empty-icon">

<i class="bi bi-arrow-return-left"></i>

</div>

<h4>
No Return Records
</h4>

<p>
Approved and completed returns will appear here.
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


</div>


<%

}
catch(Exception e){

%>

<div class="container mt-4">

<div class="alert alert-danger">

<strong>Return Management Error:</strong>

<%=e.getMessage()%>

</div>

</div>

<%

}
finally{

    if(con != null){

        try{
            con.close();
        }
        catch(Exception ignored){}
    }
}

%>