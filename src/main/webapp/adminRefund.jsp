<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>

<title>Deposit Refund</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body class="container mt-5">

<h2>Pending Deposit Refunds</h2>

<table class="table table-bordered">

<tr>

<th>User</th>
<th>Product</th>
<th>Deposit</th>
<th>Method</th>
<th>Details</th>
<th>Action</th>

</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con =
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps =
con.prepareStatement(

"SELECT r.rental_id,u.name,p.name product,p.deposit,"
+
"b.method,b.bank_name,b.account_number,b.upi_id "
+
"FROM rentals r "
+
"JOIN users u ON r.user_id=u.id "
+
"JOIN products p ON r.product_id=p.id "
+
"JOIN bank_details b ON b.user_id=u.id "
+
"WHERE r.rental_status='RETURNED' "
+
"AND r.refund_status='PENDING'");

ResultSet rs=ps.executeQuery();

while(rs.next()){

%>

<tr>

<td><%=rs.getString("name")%></td>

<td><%=rs.getString("product")%></td>

<td>₹<%=rs.getInt("deposit")%></td>

<td><%=rs.getString("method")%></td>

<td>

<%

String method=rs.getString("method");

if(method.equals("BANK")){

out.print(
rs.getString("bank_name")
+"<br>"
+rs.getString("account_number"));

}else{

out.print(rs.getString("upi_id"));

}

%>

</td>

<td>

<a class="btn btn-success"

href="RefundDepositServlet?id=<%=rs.getInt("rental_id")%>">

Refund Done

</a>

</td>

</tr>

<%

}

%>

</table>

</body>
</html>