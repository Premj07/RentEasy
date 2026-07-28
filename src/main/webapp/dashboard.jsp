<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

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
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
    return;
}

String firstName =
(String)session.getAttribute("firstName");

String lastName =
(String)session.getAttribute("lastName");
%>

<!DOCTYPE html>
<html>

<head>

<title>Dashboard - RentEasy</title>

<link rel="stylesheet" href="css/dashboard.css">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body>

<jsp:include page="includes/navbar.jsp"/>

<jsp:include page="includes/sidebar.jsp"/>

<div class="main-content">

<div class="container mt-4">

    <!-- HERO -->
   <jsp:include page="includes/dashboard-header.jsp"/>

    <!-- IMAGE -->
    <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7"
         style="width:100%; height:300px; object-fit:cover; border-radius:12px;">
<jsp:include page="includes/categories.jsp"/>

<jsp:include page="includes/featured-products.jsp"/>

</div>

<script src="js/dashboard.js"></script>

</body>
</html>