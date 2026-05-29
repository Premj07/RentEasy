<%@ page import="java.sql.*" %>

<h2>My Profile</h2>

<%
String user = (String)session.getAttribute("username");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy","root","123456");

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM kyc WHERE username=?");

ps.setString(1,user);
ResultSet rs = ps.executeQuery();

if(rs.next()){
%>

<p>Status: <b><%= rs.getString("status") %></b></p>

<%
if(rs.getString("status").equals("approved")){
%>
<p>✅ KYC Approved - You can rent & upload products</p>
<%
}else{
%>
<p>⏳ Waiting for admin approval</p>
<%
}

}else{
%>

<a href="kyc.jsp" class="btn btn-primary">Complete KYC</a>

<%
}
%>