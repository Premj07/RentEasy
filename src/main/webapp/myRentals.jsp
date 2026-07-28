	<%@ page import="java.sql.*" %>
	<%@ page session="true" %>
	
	<%
	if(session.getAttribute("user")==null){
	    response.sendRedirect("index.jsp");
	    return;
	}
	
	Integer userId = (Integer) session.getAttribute("userId");

	if (userId == null) {
	    response.sendRedirect("login.jsp");
	    return;
	}
	%>
	
	<!DOCTYPE html>
	<html>
	<head>
	
	<title>My Order</title>
	
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<style>
	
	body{
	    background:#f5f7fa;
	}
	
	.container-box{
	    margin-top:40px;
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
	
	</style>
	
	</head>
	
	<body>
	
	<div class="container">
	
	<div class="container-box">
	
	<h1 class="mb-4">My Orders</h1>

	<h4 class="text-primary">
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
	    <th>Action</th>
	</tr>
	</thead>
	
	<tbody>
	
	<%
	
	try{
	
	    Class.forName("com.mysql.cj.jdbc.Driver");
	
	    Connection con =
	    DriverManager.getConnection(
	    "jdbc:mysql://localhost:3306/renteasy",
	    "root",
	    "123456");
	
	    PreparedStatement ps =
	    con.prepareStatement(
	
	    "SELECT r.*,p.name,p.image,p.owner " +
	    "FROM rentals r " +
	    "JOIN products p ON r.product_id=p.id " +
	    "WHERE r.user_id=?");
	
	    ps.setInt(1, userId);
	
	    ResultSet rs = ps.executeQuery();
	
	    while(rs.next()){
	
	%>
	
	<tr>
	
	<td>
	<img src="<%=request.getContextPath()%>/<%=rs.getString("image")%>">
	</td>
	
	<td>
	<%=rs.getString("name")%>
	</td>
	
	<td>
	<%=rs.getString("owner")%>
	</td>
	
	<td>
	<%=rs.getString("start_date")%>
	</td>
	
	<td>
	<%=rs.getString("end_date")%>
	</td>
	
	<td>
	
	<%
	
	String status = rs.getString("rental_status");
	
	if("RETURNED".equalsIgnoreCase(status)){
	%>
	
	<span class="badge bg-success">
	Returned
	</span>
	
	<%
	}else{
	%>
	
	<span class="badge bg-warning text-dark">
	Active
	</span>
	
	<%
	}
	%>
	
	</td>
	
	<td>
	
	<%
	
	if(!"RETURNED".equalsIgnoreCase(status)){
	%>
	
	<a href="BookingSuccessServlet?rentalId=<%=rs.getInt("rental_id")%>"
   class="btn btn-primary btn-sm mb-1">
    View Details
</a>
	
	<a href="userReturnDetails.jsp?rentalId=<%=rs.getInt("rental_id")%>"
	class="btn btn-danger">
	Return
	</a>
	
	<a href="generateAgreement.jsp?rentalId=<%=rs.getInt("rental_id")%>"
	class="btn btn-primary">
	Download Rental Agreement
	</a>
	
	<%
	}else{
	%>
	
	<span class="text-success">
	Completed
	</span>
	
	<%
	}
	%>
	
	</td>
	
	</tr>
	
	<%
	
	    }
	
	    rs.close();
	    ps.close();	
	    
	    %>

	    <hr class="mt-5">

	    <h4 class="text-success">
	    🛒 Purchased Products
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
	    PreparedStatement purchasePs =
	    con.prepareStatement(

	    "SELECT po.*,p.name,p.image,p.owner " +

	    "FROM purchase_orders po " +

	    "JOIN products p ON po.product_id=p.id " +

	    "WHERE po.buyer_id=?");

	    purchasePs.setInt(1, userId);

	    ResultSet purchaseRs =
	    purchasePs.executeQuery();

	    while(purchaseRs.next()){
	    	%>

	    	<tr>

	    	<td>
	    	<img src="<%=request.getContextPath()%>/<%=purchaseRs.getString("image")%>">
	    	</td>

	    	<td>
	    	<%=purchaseRs.getString("name")%>
	    	</td>

	    	<td>
	    	<%=purchaseRs.getString("owner")%>
	    	</td>

	    	<td>
	    	<%=purchaseRs.getString("purchase_date")%>
	    	</td>

	    	<td>
	    	<span class="badge bg-primary">
	    	Permanent Purchase
	    	</span>
	    	</td>

	    	<td>
	    	<span class="badge bg-success">
	    	Purchased
	    	</span>
	    	</td>

	    	<td>
	    	<a href="purchaseInvoice.jsp?purchaseId=<%=purchaseRs.getInt("purchase_id")%>"
	    	class="btn btn-success">
	    	Download Invoice
	    	</a>
	    	
	    	
	    	</td>

	    	</tr>

	    	<%
}

purchaseRs.close();
purchasePs.close();

con.close();

}catch(Exception e){
%>

	<tr>
	    <td colspan="7" style="color:red;">
	        <%=e.getMessage()%>
	    </td>
	</tr>

	<%
	}
	%>
	
</tbody>

</table>
	
	</div>
	
	</div>
	
	</body>
	</html>