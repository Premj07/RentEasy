<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
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

<form action="payment.jsp" method="post">

    <input type="hidden"
           name="id"
           value="<%=request.getParameter("id")%>">

    <div class="mb-3">
        <label>Start Date</label>
        <input type="date"
               name="startDate"
               class="form-control"
               required>
    </div>

    <div class="mb-3">
        <label>End Date</label>
        <input type="date"
               name="endDate"
               class="form-control"
               required>
    </div>

    <button type="submit"
            class="btn btn-primary">
        Continue Payment
    </button>

</form>

</body>
</html>