<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
    return;
}

String username = (String) session.getAttribute("user");
String email = (String) session.getAttribute("email");

String status = "Not Submitted";
String photo = null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");


    // KYC DETAILS
PreparedStatement ps2 = con.prepareStatement(
    "SELECT status, photo FROM kyc WHERE email=?");

ps2.setString(1, email);
    ResultSet rs2 = ps2.executeQuery();

    if(rs2.next()){
        status = rs2.getString("status");
        photo = rs2.getString("photo");
    }

    con.close();

}catch(Exception e){
    out.println(e);
}
%>
<jsp:include page="includes/authCheck.jsp"/>
<!DOCTYPE html>
<html>
<head>
<title>Profile - RentEasy</title>

<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background:#f4f7fb;
}

.profile-card{
    max-width:600px;
    margin:auto;
    margin-top:60px;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 4px 12px rgba(0,0,0,0.1);
}

.profile-img{
    width:120px;
    height:120px;
    border-radius:50%;
    object-fit:cover;
    border:3px solid #36cfc9;
}

.badge{
    font-size:14px;
    padding:8px 12px;
}
</style>

</head>

<body>

<div class="profile-card text-center">

    <h2 class="mb-3">My Profile</h2>
    <hr>

    <!-- PROFILE PHOTO -->
    <% if(photo != null && !photo.equals("")){ %>
        <img src="<%= photo %>" class="profile-img mb-3">
    <% } else { %>
        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" 
             class="profile-img mb-3">
    <% } %>
    <!-- DETAILS -->
    <p><b>Username:</b> <%= username %></p>
    <p><b>Email:</b> <%= email %></p>

    <!-- STATUS -->
    <p><b>KYC Status:</b><br>

        <% if(status.equalsIgnoreCase("Approved")){ %>
            <span class="badge bg-success">Approved</span>
        <% } else if(status.equalsIgnoreCase("Pending")){ %>
            <span class="badge bg-warning text-dark">Pending</span>
        <% } else if(status.equalsIgnoreCase("Rejected")){ %>
            <span class="badge bg-danger">Rejected</span>
        <% } else { %>
            <span class="badge bg-secondary">Not Submitted</span>
        <% } %>

    </p>

    <!-- BUTTON LOGIC -->
    <% if(status.equals("Not Submitted") || status.equals("Rejected")){ %>
        <a href="kyc.jsp" class="btn btn-primary mt-3">Complete KYC</a>
    <% } %>

</div>

</body>
</html>