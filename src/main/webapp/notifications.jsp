<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
    return;
}

String username=(String)session.getAttribute("user");
out.println("Session User : " + username);
%>

<!DOCTYPE html>
<html>
<head>

<title>Notifications</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{
    background:#f5f7fa;
}

.container-box{
    max-width:900px;
    margin:auto;
    margin-top:40px;
}

.card{
    border-radius:15px;
}

</style>

</head>

<body>

<div class="container-box">

<div class="d-flex justify-content-between mb-4">

<h2>My Notifications</h2>

<a href="ownerDashboard.jsp"
class="btn btn-primary">
Back
</a>

</div>

<div class="card shadow p-4">

<%

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM notifications WHERE username=? ORDER BY id DESC");

ps.setString(1,username);

ResultSet rs=ps.executeQuery();

while(rs.next()){

%>

<div class="alert alert-warning">

<b>
<%=rs.getString("message")%>
</b>

<br>

<small class="text-muted">
<%=rs.getString("created_at")%>
</small>

</div>

<%

}

con.close();

}catch(Exception e){

out.println(e);

}

%>

</div>

</div>

</body>

</html>