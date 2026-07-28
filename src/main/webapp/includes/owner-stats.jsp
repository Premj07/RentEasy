<%@ page import="java.sql.*" %>

<%
int totalProducts = 0;
int pendingProducts = 0;
int rentedProducts = 0;
double totalEarnings = 0;

String ownerEmail = (String) session.getAttribute("email");

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456");

    // Total Products
    PreparedStatement ps1 = con.prepareStatement(
            "SELECT COUNT(*) FROM products WHERE owner=?");

    ps1.setString(1, ownerEmail);

    ResultSet rs1 = ps1.executeQuery();

    if(rs1.next()){
        totalProducts = rs1.getInt(1);
    }

    // Pending Approval
    PreparedStatement ps2 = con.prepareStatement(
            "SELECT COUNT(*) FROM products WHERE owner=? AND status='pending'");

    ps2.setString(1, ownerEmail);

    ResultSet rs2 = ps2.executeQuery();

    if(rs2.next()){
        pendingProducts = rs2.getInt(1);
    }

    // Active Rentals
    PreparedStatement ps3 = con.prepareStatement(
            "SELECT COUNT(*) FROM rent_orders WHERE owner=? AND status='ACTIVE'");

    ps3.setString(1, ownerEmail);

    ResultSet rs3 = ps3.executeQuery();

    if(rs3.next()){
        rentedProducts = rs3.getInt(1);
    }

    // Earnings
    PreparedStatement ps4 = con.prepareStatement(
            "SELECT IFNULL(SUM(total_amount),0) FROM rent_orders WHERE owner=?");

    ps4.setString(1, ownerEmail);

    ResultSet rs4 = ps4.executeQuery();

    if(rs4.next()){
        totalEarnings = rs4.getDouble(1);
    }

    con.close();

}catch(Exception e){

    out.println(e);

}
%>

<div class="stats-grid">

    <div class="stat-card">
        <i class="bi bi-box-seam"></i>
        <h2><%=totalProducts%></h2>
        <p>Total Products</p>
    </div>

    <div class="stat-card">
        <i class="bi bi-hourglass-split"></i>
        <h2><%=pendingProducts%></h2>
        <p>Pending Approval</p>
    </div>

 <a href="OwnerRentalsServlet"
   class="text-decoration-none text-dark">

    <div class="stat-card">

        <i class="bi bi-arrow-repeat"></i>

        <h2><%=rentedProducts%></h2>

        <p>Active Rentals</p>

    </div>

</a>

    <div class="stat-card">
        <i class="bi bi-cash-stack"></i>
        <h2>₹<%=totalEarnings%></h2>
        <p>Total Earnings</p>
    </div>

</div>