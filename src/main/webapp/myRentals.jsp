<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>My Orders - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
    background:#f5f7fa;
}

.container-box{
    margin-top:40px;
    margin-bottom:40px;
    background:#fff;
    padding:30px;
    border-radius:15px;
    box-shadow:0 10px 25px rgba(0,0,0,0.1);
}

table img{
    width:80px;
    height:80px;
    object-fit:cover;
    border-radius:10px;
}

.action-buttons{
    display:flex;
    flex-direction:column;
    gap:7px;
    min-width:190px;
}

.return-status{
    padding:10px;
    border-radius:8px;
    font-size:13px;
    margin-bottom:5px;
}

.return-requested{
    background:#fff3cd;
    border:1px solid #ffe69c;
    color:#997404;
}

.return-approved{
    background:#cff4fc;
    border:1px solid #9eeaf9;
    color:#055160;
}

.return-completed{
    background:#d1e7dd;
    border:1px solid #a3cfbb;
    color:#0a3622;
}

</style>

</head>

<body>

<div class="container">

<div class="container-box">

<h1 class="mb-4">
    <i class="bi bi-box-seam"></i>
    My Orders
</h1>


<!-- =====================================================
     SUCCESS MESSAGE
===================================================== -->

<%
String success = request.getParameter("success");

if("returnRequested".equalsIgnoreCase(success)){
%>

<div class="alert alert-success">

    <i class="bi bi-check-circle-fill"></i>

    Return request sent successfully.
    Waiting for admin approval.

</div>

<%
}
%>


<!-- =====================================================
     RENTAL PRODUCTS
===================================================== -->

<h4 class="text-primary mb-3">

    <i class="bi bi-arrow-repeat"></i>
    Rental Products

</h4>


<table class="table table-bordered table-hover align-middle">

<thead class="table-dark">

<tr>

    <th>Image</th>
    <th>Product</th>
    <th>Owner</th>
    <th>Rent Date</th>
    <th>Return Date</th>
    <th>Status</th>
    <th style="width:220px;">Action</th>

</tr>

</thead>


<tbody>

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


    String rentalSql =

        "SELECT r.*, p.name, p.image, p.owner " +

        "FROM rentals r " +

        "JOIN products p ON r.product_id=p.id " +

        "WHERE r.user_id=? " +

        "ORDER BY r.rental_id DESC";


    ps = con.prepareStatement(rentalSql);

    ps.setInt(1,userId);

    rs = ps.executeQuery();


    boolean rentalFound = false;


    while(rs.next()){

        rentalFound = true;

        String status =
            rs.getString("rental_status");

        if(status == null){
            status = "ACTIVE";
        }

%>


<tr>


<!-- IMAGE -->

<td>

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
alt="Product">

</td>


<!-- PRODUCT -->

<td>

<strong>
<%=rs.getString("name")%>
</strong>

<br>

<small class="text-muted">

Rental ID:
#<%=rs.getInt("rental_id")%>

</small>

</td>


<!-- OWNER -->

<td>

<%=rs.getString("owner")%>

</td>


<!-- START DATE -->

<td>

<%=rs.getString("start_date")%>

</td>


<!-- END DATE -->

<td>

<%=rs.getString("end_date")%>

</td>



<!-- =====================================================
     STATUS
===================================================== -->

<td>


<%

if("ACTIVE".equalsIgnoreCase(status)){

%>

<span class="badge bg-success">
ACTIVE
</span>


<%

}
else if("RETURN_REQUESTED".equalsIgnoreCase(status)){

%>

<span class="badge bg-warning text-dark">

RETURN REQUESTED

</span>


<%

}
else if("RETURN_APPROVED".equalsIgnoreCase(status)){

%>

<span class="badge bg-info text-dark">

RETURN APPROVED

</span>


<%

}
else if(
    "RETURN_VERIFIED".equalsIgnoreCase(status)
    ||
    "RETURNED".equalsIgnoreCase(status)
){

%>

<span class="badge bg-success">

RETURNED

</span>


<%

}
else{

%>

<span class="badge bg-secondary">

<%=status.replace("_"," ")%>

</span>

<%

}

%>


</td>



<!-- =====================================================
     ACTIONS
===================================================== -->

<td>

<div class="action-buttons">


<!-- =====================================================
     VIEW DETAILS
     ALWAYS AVAILABLE
===================================================== -->

<a
href="BookingSuccessServlet?rentalId=<%=rs.getInt("rental_id")%>"
class="btn btn-primary btn-sm">

<i class="bi bi-eye"></i>

View Details

</a>



<!-- =====================================================
     RENTAL AGREEMENT
     ALWAYS AVAILABLE
===================================================== -->

<a
href="generateAgreement.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn btn-outline-primary btn-sm">

<i class="bi bi-file-earmark-text"></i>

Download Rental Agreement

</a>



<!-- =====================================================
     ACTIVE RENTAL
===================================================== -->

<%

if("ACTIVE".equalsIgnoreCase(status)){

%>


<a
href="userReturnDetails.jsp?rentalId=<%=rs.getInt("rental_id")%>"
class="btn btn-danger btn-sm">

<i class="bi bi-arrow-return-left"></i>

Return Product

</a>


<%

}


/* =====================================================
   RETURN REQUESTED
===================================================== */

else if("RETURN_REQUESTED".equalsIgnoreCase(status)){

%>


<div class="return-status return-requested">

<strong>

<i class="bi bi-hourglass-split"></i>

Return Requested

</strong>

<br>

Waiting for admin approval.

</div>


<%

}


/* =====================================================
   RETURN APPROVED
===================================================== */

else if("RETURN_APPROVED".equalsIgnoreCase(status)){

%>


<div class="return-status return-approved">

<strong>

<i class="bi bi-check-circle-fill"></i>

Return Approved

</strong>

<br>

Admin approved your return.

<br>

Prepare the product for handover.

</div>


<%

}


/* =====================================================
   RETURN VERIFIED / RETURNED
===================================================== */

else if(

    "RETURN_VERIFIED".equalsIgnoreCase(status)

    ||

    "RETURNED".equalsIgnoreCase(status)

){

%>


<div class="return-status return-completed">

<strong>

<i class="bi bi-check-circle-fill"></i>

Product Returned

</strong>

<br>

Return completed successfully.

</div>


<a
href="paymentHistory.jsp"
class="btn btn-success btn-sm">

<i class="bi bi-wallet2"></i>

Track Deposit Refund

</a>


<%

}

%>


</div>

</td>


</tr>


<%

    }


    if(!rentalFound){

%>


<tr>

<td colspan="7"
    class="text-center text-muted py-4">

<i class="bi bi-box-seam"
   style="font-size:35px;"></i>

<br><br>

No rental products found.

</td>

</tr>


<%

    }


    rs.close();
    ps.close();

%>


</tbody>

</table>



<!-- =====================================================
     PURCHASED PRODUCTS
===================================================== -->


<hr class="mt-5 mb-4">


<h4 class="text-success mb-3">

<i class="bi bi-cart-check"></i>

Purchased Products

</h4>


<table class="table table-bordered table-hover align-middle">


<thead class="table-dark">


<tr>

<th>Image</th>

<th>Product</th>

<th>Owner</th>

<th>Purchase Date</th>

<th>Type</th>

<th>Status</th>

<th>Action</th>

</tr>


</thead>


<tbody>


<%

PreparedStatement purchasePs = con.prepareStatement(

    "SELECT po.*,p.name,p.image,p.owner " +

    "FROM purchase_orders po " +

    "JOIN products p ON po.product_id=p.id " +

    "WHERE po.buyer_id=? " +

    "ORDER BY po.purchase_id DESC"

);


purchasePs.setInt(
    1,
    userId
);


ResultSet purchaseRs =
    purchasePs.executeQuery();


boolean purchaseFound =
    false;


while(purchaseRs.next()){


    purchaseFound =
        true;

%>


<tr>


<!-- IMAGE -->

<td>

<img
src="<%=request.getContextPath()%>/<%=purchaseRs.getString("image")%>"
alt="Product">

</td>



<!-- PRODUCT -->

<td>

<strong>

<%=purchaseRs.getString("name")%>

</strong>

</td>



<!-- OWNER -->

<td>

<%=purchaseRs.getString("owner")%>

</td>



<!-- PURCHASE DATE -->

<td>

<%=purchaseRs.getString("purchase_date")%>

</td>



<!-- TYPE -->

<td>

<span class="badge bg-primary">

Permanent Purchase

</span>

</td>



<!-- STATUS -->

<td>

<span class="badge bg-success">

Purchased

</span>

</td>



<!-- ACTION -->

<td>


<a
href="purchaseInvoice.jsp?purchaseId=<%=purchaseRs.getInt("purchase_id")%>"
class="btn btn-success btn-sm">


<i class="bi bi-file-earmark-arrow-down"></i>

Download Invoice


</a>


</td>


</tr>


<%

}


if(!purchaseFound){

%>


<tr>

<td colspan="7"
    class="text-center text-muted py-4">

<i class="bi bi-cart"
   style="font-size:35px;"></i>

<br><br>

No purchased products found.

</td>

</tr>


<%

}


purchaseRs.close();

purchasePs.close();


}
catch(Exception e){

%>


<tr>

<td colspan="7"
    style="color:red;">

<strong>Database Error:</strong>

<%=e.getMessage()%>

</td>

</tr>


<%

}
finally{


    if(rs != null){

        try{
            rs.close();
        }
        catch(Exception ignored){}

    }


    if(ps != null){

        try{
            ps.close();
        }
        catch(Exception ignored){}

    }


    if(con != null){

        try{
            con.close();
        }
        catch(Exception ignored){}

    }

}

%>


</tbody>

</table>


</div>

</div>


<script
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>