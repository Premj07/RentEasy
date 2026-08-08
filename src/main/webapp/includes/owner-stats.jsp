<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
int totalProducts = 0;
int pendingProducts = 0;
int rentedProducts = 0;
double totalEarnings = 0.0;

String ownerEmail = (String) session.getAttribute("email");

Connection con = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    /* =====================================================
       1. GET OWNER USER ID
    ===================================================== */

    int ownerId = 0;

    PreparedStatement ownerPs = con.prepareStatement(
        "SELECT id FROM users WHERE email=?"
    );

    ownerPs.setString(1, ownerEmail);

    ResultSet ownerRs = ownerPs.executeQuery();

    if (ownerRs.next()) {
        ownerId = ownerRs.getInt("id");
    }

    ownerRs.close();
    ownerPs.close();


    /* =====================================================
       2. TOTAL PRODUCTS
    ===================================================== */

    PreparedStatement ps1 = con.prepareStatement(
        "SELECT COUNT(*) FROM products WHERE owner=?"
    );

    ps1.setString(1, ownerEmail);

    ResultSet rs1 = ps1.executeQuery();

    if (rs1.next()) {
        totalProducts = rs1.getInt(1);
    }

    rs1.close();
    ps1.close();


    /* =====================================================
       3. PENDING PRODUCT APPROVAL
    ===================================================== */

    PreparedStatement ps2 = con.prepareStatement(
        "SELECT COUNT(*) FROM products " +
        "WHERE owner=? AND LOWER(status)='pending'"
    );

    ps2.setString(1, ownerEmail);

    ResultSet rs2 = ps2.executeQuery();

    if (rs2.next()) {
        pendingProducts = rs2.getInt(1);
    }

    rs2.close();
    ps2.close();


    /* =====================================================
       4. ACTIVE RENTALS
    ===================================================== */

    if (ownerId > 0) {

        PreparedStatement ps3 = con.prepareStatement(
            "SELECT COUNT(*) FROM rentals " +
            "WHERE owner_id=? " +
            "AND rental_status NOT IN " +
            "('RETURN_VERIFIED','RETURN_APPROVED','COMPLETED','CANCELLED')"
        );

        ps3.setInt(1, ownerId);

        ResultSet rs3 = ps3.executeQuery();

        if (rs3.next()) {
            rentedProducts = rs3.getInt(1);
        }

        rs3.close();
        ps3.close();
    }


    /* =====================================================
       5. TOTAL OWNER EARNINGS
       
       Security deposit is NOT counted as owner earnings.
       Only rental amount is counted.
    ===================================================== */

    if (ownerId > 0) {

        PreparedStatement ps4 = con.prepareStatement(
            "SELECT COALESCE(SUM(rent_amount), 0) " +
            "FROM rentals " +
            "WHERE owner_id=? " +
            "AND payment_status='PAID'"
        );

        ps4.setInt(1, ownerId);

        ResultSet rs4 = ps4.executeQuery();

        if (rs4.next()) {
            totalEarnings = rs4.getDouble(1);
        }

        rs4.close();
        ps4.close();
    }


} catch (Exception e) {

    e.printStackTrace();
%>

<div class="alert alert-danger" style="margin-bottom:20px;">
    Unable to load owner statistics:
    <%= e.getMessage() %>
</div>

<%
} finally {

    if (con != null) {

        try {
            con.close();
        } catch (SQLException ignored) {
        }

    }
}
%>


<!-- =====================================================
     OWNER STATISTICS
===================================================== -->

<div class="stats-grid">


    <!-- TOTAL PRODUCTS -->

    <div class="stat-card">

        <i class="bi bi-box-seam"></i>

        <h2>
            <%= totalProducts %>
        </h2>

        <p>
            Total Products
        </p>

    </div>



    <!-- PENDING APPROVAL -->

    <div class="stat-card">

        <i class="bi bi-hourglass-split"></i>

        <h2>
            <%= pendingProducts %>
        </h2>

        <p>
            Pending Approval
        </p>

    </div>



    <!-- ACTIVE RENTALS -->

    <a href="OwnerRentalsServlet"
       class="owner-stat-link">

        <div class="stat-card">

            <i class="bi bi-arrow-repeat"></i>

            <h2>
                <%= rentedProducts %>
            </h2>

            <p>
                Active Rentals
            </p>

        </div>

    </a>



    <!-- TOTAL EARNINGS -->

    <div class="stat-card">

        <i class="bi bi-wallet2"></i>

        <h2>
            ₹<%= String.format("%.2f", totalEarnings) %>
        </h2>

        <p>
            Total Earnings
        </p>

    </div>


</div>