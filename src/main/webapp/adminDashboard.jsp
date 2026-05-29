<%@ include file="adminLayout.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- CHART LIBRARY -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
int users = 0;
int products = 0;
int pending = 0;
int approved = 0;
int rejected = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    // TOTAL USERS
    ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM users");
    if(rs.next()) users = rs.getInt(1);

    // TOTAL PRODUCTS
    rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM products");
    if(rs.next()) products = rs.getInt(1);

    // STATUS COUNT
    rs = con.createStatement().executeQuery(
        "SELECT status, COUNT(*) total FROM products GROUP BY status");

    while(rs.next()){
        String s = rs.getString("status");
        int t = rs.getInt("total");

        if("pending".equals(s)) pending = t;
        if("approved".equals(s)) approved = t;
        if("rejected".equals(s)) rejected = t;
    }

} catch(Exception e){
    out.println(e);
}
%>

<h2>Dashboard</h2>

<!-- CARDS -->
<div class="row mt-4">

    <div class="col-md-4">
        <div class="card-box text-center">
            <h5>Total Users</h5>
            <h2><%= users %></h2>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card-box text-center">
            <h5>Total Products</h5>
            <h2><%= products %></h2>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card-box text-center">
            <h5>Pending Products</h5>
            <h2 style="color:orange;"><%= pending %></h2>
        </div>
    </div>

</div>

<!-- CHART SECTION -->
<div class="row mt-5">

    <div class="col-md-6">
        <div class="card-box">
            <h5>Product Status Analytics</h5>
            <canvas id="myChart"></canvas>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card-box">
            <h5>Quick Info</h5>

            <p>✅ Approved: <b style="color:green;"><%= approved %></b></p>
            <p>⏳ Pending: <b style="color:orange;"><%= pending %></b></p>
            <p>❌ Rejected: <b style="color:red;"><%= rejected %></b></p>

        </div>
    </div>

</div>

<!-- CHART SCRIPT -->
<script>
new Chart(document.getElementById('myChart'), {
    type: 'pie',
    data: {
        labels: ['Pending', 'Approved', 'Rejected'],
        datasets: [{
            data: [<%=pending%>, <%=approved%>, <%=rejected%>],
            backgroundColor: ['orange', 'green', 'red']
        }]
    }
});
</script>

</div>
</body>
</html>