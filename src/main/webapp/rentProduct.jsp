<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
%>

<!DOCTYPE html>
<html>
<head>
<title>Product Details - RentEasy</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f4f6f9;
    font-family:'Segoe UI';
}

/* CARD */
.product-card{
    background:white;
    border-radius:15px;
    padding:25px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
}

/* IMAGE */
.product-img{
    width:100%;
    height:350px;
    object-fit:cover;
    border-radius:12px;
}

/* TITLE */
.product-title{
    font-size:28px;
    font-weight:bold;
}

/* PRICE */
.price{
    font-size:22px;
    color:#20c997;
    font-weight:bold;
}

/* BUTTON */
.btn-rent{
    background:#20c997;
    color:white;
    border:none;
    padding:12px;
    font-size:16px;
}

.btn-rent:hover{
    background:#17b38a;
}

/* BACK */
.back-btn{
    text-decoration:none;
    color:#555;
}

</style>
</head>

<body>

<div class="container mt-4">

<a href="dashboard.jsp" class="back-btn">Back to Dashboard</a>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM products WHERE id=?");

    ps.setInt(1, Integer.parseInt(id));

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
%>

<div class="row mt-3">

    <!-- LEFT IMAGE -->
    <div class="col-md-6">
        <img src="<%=request.getContextPath()%>/<%= rs.getString("image") %>" 
             class="product-img">
    </div>

    <!-- RIGHT DETAILS -->
    <div class="col-md-6">

        <div class="product-card">

            <div class="product-title"><%= rs.getString("name") %></div>

            <p class="price mt-2"><%= rs.getInt("price") %> / day</p>

            <hr>

            <p><b>Category:</b> <%= rs.getString("category") %></p>

            <p><b>Description:</b><br>
            <%= rs.getString("description") %></p>

            <p><b>Location:</b> <%= rs.getString("location") %></p>

            <p><b>Owner:</b> <%= rs.getString("owner") %></p>

            <hr>

            <a href="payment.jsp?id=<%= rs.getInt("id") %>" 
               class="btn btn-rent w-100">
               Rent Now 
            </a>

        </div>

    </div>

</div>

<%
    } else {
%>
<h4>Product not found ❌</h4>
<%
    }

}catch(Exception e){
    out.println(e);
}
%>

</div>

</body>
</html>