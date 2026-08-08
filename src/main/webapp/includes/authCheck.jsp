<%@ page import="java.sql.*" %>

<%
String email = (String) session.getAttribute("email");

if(email == null){
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

if(!rs.next()){
    con.close();
    response.sendRedirect("kyc.jsp");
    return;
}

if(!"Approved".equalsIgnoreCase(rs.getString("status"))){
    con.close();
    response.sendRedirect("kyc.jsp");
    return;
}

con.close();
%>