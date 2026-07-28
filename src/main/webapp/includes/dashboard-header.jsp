<%@ page import="java.sql.*" %>

<%
int totalProducts = 0;
int notificationCount = 0;
String email = (String) session.getAttribute("email");
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456");

    // Total Available Products
    PreparedStatement ps1 = con.prepareStatement(
        "SELECT COUNT(*) FROM products WHERE status='APPROVED' OR status='AVAILABLE'");

    ResultSet rs1 = ps1.executeQuery();

    if(rs1.next()){
        totalProducts = rs1.getInt(1);
    }

    // User Notifications
PreparedStatement ps2 = con.prepareStatement(
"SELECT COUNT(*) FROM notifications WHERE email=?");

ps2.setString(1,
(String)session.getAttribute("email"));

    ResultSet rs2 = ps2.executeQuery();

    if(rs2.next()){
        notificationCount = rs2.getInt(1);
    }

    con.close();

}catch(Exception e){
    out.println(e);
}
%>

<div class="welcome-card">

    <div class="welcome-left">

        <span class="welcome-badge">
            Welcome Back
        </span>

       <h2>

Hello,

<%= session.getAttribute("firstName") %>

<%= session.getAttribute("lastName") %>

</h2>

        <p>
            Rent furniture, electronics, books, sports equipment and more
            from verified MIT-ADT students.
        </p>

        <div class="welcome-buttons">

            <a href="#featuredProducts"
               class="btn-primary-custom">

                Browse Products

            </a>

            <a href="myRentals.jsp"
               class="btn-outline-custom">

                My Rentals

            </a>

        </div>

    </div>

    <div class="welcome-right">

        <div class="stat-box">

            <h3><%= totalProducts %></h3>

            <p>Available Products</p>

        </div>

        <div class="stat-box">

            <h3><%= notificationCount %></h3>

            <p>Notifications</p>

        </div>

    </div>

</div>