<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String email = (String) session.getAttribute("email");

if (email == null) {
    response.sendRedirect("index.jsp");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456");

PreparedStatement ps = con.prepareStatement(
        "SELECT status FROM kyc WHERE email=?");

ps.setString(1, email);

ResultSet rs = ps.executeQuery();

if (!rs.next()) {

    con.close();
    response.sendRedirect("kyc.jsp");
    return;

}

String status = rs.getString("status");

con.close();

if (!"Approved".equalsIgnoreCase(status)) {

    response.sendRedirect("kyc.jsp");
    return;

}
%>
<%
if(session.getAttribute("email")==null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Owner Dashboard - RentEasy</title>

<link rel="stylesheet" href="css/navbar.css">
<link rel="stylesheet" href="css/owner-dashboard.css">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<!-- Same Navbar -->
<jsp:include page="includes/navbar.jsp"/>

<!-- Owner Sidebar -->
<jsp:include page="includes/owner-sidebar.jsp"/>

<div class="main-content">

    <div class="container mt-4">

        <!-- Owner Welcome -->
        <jsp:include page="includes/owner-header.jsp"/>

        <!-- Statistics -->
        <jsp:include page="includes/owner-stats.jsp"/>

        <!-- Products -->
        <jsp:include page="includes/owner-products.jsp"/>

        <!-- Bookings -->
        <jsp:include page="includes/owner-bookings.jsp"/>

    </div>

</div>

<script src="js/dashboard.js"></script>

</body>
</html>