<%@ page import="java.sql.*" %>

<%
int rentalId=Integer.parseInt(
request.getParameter("rentalId"));

Connection con=null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps=
con.prepareStatement(
"UPDATE rentals SET rental_status='FORWARDED_TO_ECART' WHERE rental_id=?");

ps.setInt(1,rentalId);

ps.executeUpdate();
%>

<h2>Request Sent To E-Cart Successfully</h2>

<a href="adminReturns.jsp">Back</a>

<%
}catch(Exception e){
out.println(e);
}
%>