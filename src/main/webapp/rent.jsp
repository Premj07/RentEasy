<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}

String username = (String) session.getAttribute("user");

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/renteasy","root","123456");

PreparedStatement ps = con.prepareStatement(
    "SELECT status FROM kyc WHERE username=?");

ps.setString(1, username);

ResultSet rs = ps.executeQuery();

String status = "not_submitted";

if(rs.next()){
    status = rs.getString("status");
}

if(!"approved".equals(status)){
    response.sendRedirect("kyc.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Rent</title>
</head>

<body class="container mt-5">

<h3>Proceed to Payment</h3>

<a href="payment.jsp" class="btn btn-primary">
    Continue Payment
</a>

</body>
</html>	