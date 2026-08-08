<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RentEasy Products</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
.card {
	margin-bottom: 20px;
}
</style>

</head>
<body>

	<div class="container mt-4">

		<h2>Available Products</h2>

		<div class="row">

			<%
			try {

				Class.forName("com.mysql.cj.jdbc.Driver");

				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/renteasy", "root", "123456");

				PreparedStatement ps = con.prepareStatement(

						"SELECT * FROM products ORDER BY id DESC"

						);

						ResultSet rs = ps.executeQuery();

				while (rs.next()) {

			%>

			<div class="col-md-4">

				<div class="card">

					<img src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
    				 class="card-img-top"
    				 height="220">

					<div class="card-body">

						<h5><%=rs.getString("name")%></h5>

						<p>
							<b>Price:</b> ₹<%=rs.getInt("price")%></p>

						<p>
							<b>Owner:</b>
							<%=rs.getString("owner")%></p>

						<p>
							<b>Location:</b>
							<%=rs.getString("location")%></p>

						<p><%=rs.getString("description")%></p>

						<%
String type = rs.getString("listing_type");

						String status = rs.getString("availability");

						if(status == null){
						    status = "AVAILABLE";
						}
						
if(type == null){
    type = "RENT";
}

if(status.equalsIgnoreCase("AVAILABLE")){
%>

<span class="badge bg-success">Available</span>
<br><br>

<%
if(type.equalsIgnoreCase("RENT")){
%>

<a href="rentProduct.jsp?id=<%=rs.getInt("id")%>"
   class="btn btn-primary">
    Rent Now
</a>

<%
}
else if(type.equalsIgnoreCase("SELL")){
%>

<p><b>Selling Price:</b>
₹<%=rs.getInt("selling_price")%></p>

<a href="rentCheckout.jsp?id=<%=rs.getInt("id")%>" class="btn btn-primary">
    Rent Now
</a>

<%
}
else if(type.equalsIgnoreCase("BOTH")){
%>

<p><b>Rent Price:</b>
₹<%=rs.getInt("price")%></p>

<p><b>Selling Price:</b>
₹<%=rs.getInt("selling_price")%></p>

<a href="rentProduct?id=<%=rs.getInt("id")%>"
   class="btn btn-primary">
    Rent Now
</a>

<a href="buyProduct.jsp?id=<%=rs.getInt("id")%>"
   class="btn btn-success">
    Buy Now
</a>

<%
}

} else {
%>

<span class="badge bg-danger">
Out Of Stock
</span>

<br><br>

<button class="btn btn-secondary" disabled>
Not Available
</button>

<%
}
%>
				
					</div>

				</div>

			</div>

			<%
			}

				rs.close();
				ps.close();
				con.close();

			} catch (Exception e) {
			out.println(e);
			}
			%>

		</div>

	</div>

</body>
</html>