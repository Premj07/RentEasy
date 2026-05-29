<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Admin - Users</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background:#f4f6f9;
}

/* SIDEBAR */
.sidebar {
    width:220px;
    height:100vh;
    background:#0f172a;
    color:white;
    position:fixed;
    padding:20px;
}

.sidebar a {
    display:block;
    color:#cbd5f5;
    text-decoration:none;
    margin:15px 0;
}

.sidebar a:hover {
    color:white;
}

/* MAIN */
.main {
    margin-left:240px;
    padding:20px;
}

/* CARD */
.card-box {
    background:white;
    padding:20px;
    border-radius:15px;
    box-shadow:0 4px 12px rgba(0,0,0,0.1);
}

/* PROFILE IMAGE */
.profile-img {
    width:45px;
    height:45px;
    border-radius:50%;
    object-fit:cover;
}

/* STATUS */
.badge-approved {
    background:#28a745;
}

.badge-pending {
    background:#ffc107;
    color:black;
}

.badge-rejected {
    background:#dc3545;
}
</style>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4>🏠 RentEasy</h4>
    <a href="adminDashboard.jsp">Dashboard</a>
    <a href="adminUsers.jsp">Users</a>
    <a href="adminProducts.jsp">Products</a>
    <hr>
    <a href="logout" class="btn btn-danger w-100">Logout</a>
</div>

<!-- MAIN -->
<div class="main">

<h2>User Management</h2>

<div class="card-box mt-3">

<table class="table table-hover align-middle">

<tr class="table-dark">
    <th>ID</th>
    <th>Username</th>
    <th>Email</th>
    <th>Photo</th>
    <th>KYC Status</th>
    <th>Document</th>
    <th>Action</th>
</tr>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery(
        "SELECT u.id, u.username, u.email, k.photo, k.document, k.status " +
        "FROM users u LEFT JOIN kyc k ON u.username = k.username");

    while(rs.next()){
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getString("email") %></td>

    <!-- PHOTO -->
    <td>
        <%
        String photo = rs.getString("photo");
        if(photo != null){
        %>
            <img src="<%=request.getContextPath()%>/<%= photo %>" class="profile-img">
        <%
        } else {
        %>
            <span>No Photo</span>
        <%
        }
        %>
    </td>
    

    <!-- STATUS -->
    <td>
        <%
        String status = rs.getString("status");

        if(status == null){
        %>
            <span class="badge bg-secondary">Not Submitted</span>
        <%
        } else if(status.equals("Pending")){
        %>
            <span class="badge badge-pending">Pending</span>
        <%
        } else if(status.equals("Approved")){
        %>
            <span class="badge badge-approved">Approved</span>
        <%
        } else {
        %>
            <span class="badge badge-rejected">Rejected</span>
        <%
        }
        %>
    </td>

    <!-- DOCUMENT -->
    <td>
        <%
        String doc = rs.getString("document");
        if(doc != null){
        %>
            <a href="<%=request.getContextPath()%>/<%= doc %>" target="_blank">View</a>
        <%
        } else {
        %>
            -
        <%
        }
        %>
    </td>

    <!-- ACTION -->
    <td>
        <div class="d-flex gap-2">

           <a href="approveKyc?user=<%= rs.getString("username") %>" class="btn btn-success btn-sm">Approve</a>

<a href="rejectKyc?user=<%= rs.getString("username") %>" class="btn btn-warning btn-sm">Reject</a>

<a href="deleteUser?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm"
   onclick="return confirm('Delete user?')">Delete</a>

        </div>
    </td>
</tr>

<%
    }
}catch(Exception e){
    out.println(e);
}
%>

</table>

</div>

</div>

</body>
</html>