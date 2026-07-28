<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%@ include file="adminLayout.jsp" %>
<%
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
}
%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
int users = 0;
int products = 0;
int pending = 0;
int approved = 0;
int rejected = 0;	
int activeRentCount = 0;
int returnRequestCount = 0;
int totalReturns = 0;

Connection con = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    Statement st = con.createStatement();

    // Total Users
    ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users");
    if(rs.next()) users = rs.getInt(1);

    // Total Products
    rs = st.executeQuery("SELECT COUNT(*) FROM products");
    if(rs.next()) products = rs.getInt(1);

    // Product Status Count
    rs = st.executeQuery(
        "SELECT status, COUNT(*) total FROM products GROUP BY status"
    );

    while(rs.next()) {
        String status = rs.getString("status");
        int total = rs.getInt("total");

        if("pending".equalsIgnoreCase(status))
            pending = total;

        if("approved".equalsIgnoreCase(status))
            approved = total;

        if("rejected".equalsIgnoreCase(status))
            rejected = total;
    }

    // Active Rentals
    rs = st.executeQuery(
        "SELECT COUNT(*) FROM rentals WHERE status='ACTIVE'"
    );
    if(rs.next())
        activeRentCount = rs.getInt(1);

    // Return Requests
    rs = st.executeQuery(
        "SELECT COUNT(*) FROM returns WHERE status='PENDING'"
    );
    if(rs.next())
        returnRequestCount = rs.getInt(1);

    // Total Returns
    rs = st.executeQuery(
        "SELECT COUNT(*) FROM returns"
    );
    if(rs.next())
        totalReturns = rs.getInt(1);

} catch(Exception e) {
    out.println("<p style='color:red'>" + e.getMessage() + "</p>");
} 
%>

<div class="container-fluid">

    <h2 class="mb-4">Dashboard</h2>

    <div class="row">

        <!-- Total Users -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Total Users</h5>
                <h2><%= users %></h2>
            </div>
        </div>
        
        <!-- Deposit Refund -->
<div class="col-md-4 mb-3">
    <a href="adminRefund.jsp" style="text-decoration:none;color:inherit;">

        <div class="card-box text-center">

            <h5>Deposit Refund</h5>

            <h2>
                <%
                PreparedStatement refundPs =
                con.prepareStatement(
                "SELECT COUNT(*) FROM rentals WHERE refund_status='PENDING'");

                ResultSet refundRs =
                refundPs.executeQuery();

                int refundCount = 0;

                if(refundRs.next()){
                    refundCount = refundRs.getInt(1);
                }
                %>

                <%= refundCount %>

            </h2>

            <small class="text-primary">
                Click to View
            </small>

        </div>

    </a>
</div>

        <!-- Total Products -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Total Products</h5>
                <h2><%= products %></h2>
            </div>
        </div>

        <!-- Active Rentals -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Active Rentals</h5>
                <h2><%= activeRentCount %></h2>
            </div>
        </div>

        <!-- Return Requests -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Return Requests</h5>
                <h2><%= returnRequestCount %></h2>
            </div>
        </div>

        <!-- Total Returns -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Total Returns</h5>
                <h2><%= totalReturns %></h2>

                <a href="adminReturns.jsp"
                   class="btn btn-primary btn-sm mt-2">
                    View Returns
                </a>
            </div>
        </div>

        <!-- Pending Products -->
        <div class="col-md-4 mb-3">
            <div class="card-box text-center">
                <h5>Pending Products</h5>
                <h2 style="color:orange;">
                    <%= pending %>
                </h2>
            </div>
        </div>

    </div>

    <!-- Analytics Section -->
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

                <p>
                    ✅ Approved:
                    <b style="color:green;">
                        <%= approved %>
                    </b>
                </p>

                <p>
                    ⏳ Pending:
                    <b style="color:orange;">
                        <%= pending %>
                    </b>
                </p>

                <p>
                    ❌ Rejected:
                    <b style="color:red;">
                        <%= rejected %>
                    </b>
                </p>

            </div>
        </div>

    </div>

</div>

<script>
new Chart(document.getElementById('myChart'), {
    type: 'pie',
    data: {
        labels: ['Pending', 'Approved', 'Rejected'],
        datasets: [{
            data: [
                <%= pending %>,
                <%= approved %>,
                <%= rejected %>
            ],
            backgroundColor: [
                'orange',
                'green',
                'red'
            ]
        }]
    }
});
</script>
<%
if(con!=null)
con.close();
%>