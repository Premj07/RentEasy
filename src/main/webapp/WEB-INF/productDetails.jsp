<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");
%>

<!DOCTYPE html>
<html>
<head>
<title>Product Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<div class="container mt-5">

<h3>Product Details</h3>

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

<img src="<%=request.getContextPath()%>/<%= rs.getString("image") %>" 
     style="width:300px;height:200px;">

<h4><%= rs.getString("name") %></h4>

<p>Price: ₹<%= rs.getInt("price") %></p>
<p><%= rs.getString("description") %></p>

<a href="rentProduct.jsp?id=<%= rs.getInt("id") %>" 
   class="btn btn-success">Rent Now</a>

<%
    } else {
        out.println("Product not found");
    }

}catch(Exception e){
    out.println(e);
}
%>

</div>

</body>
</html>