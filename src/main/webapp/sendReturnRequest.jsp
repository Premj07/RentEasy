<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
String loggedUser = (String) session.getAttribute("user");

if (loggedUser == null) {
    response.sendRedirect("index.jsp");
    return;
}

String rentalIdParam = request.getParameter("rentalId");

if (rentalIdParam == null || rentalIdParam.trim().isEmpty()) {
    response.sendRedirect("myRentals.jsp?error=invalidRental");
    return;
}

int rentalId = Integer.parseInt(rentalIdParam);

Connection con = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    /*
     * Get rental information
     */
    PreparedStatement rentalPs = con.prepareStatement(
        "SELECT r.rental_id, r.product_id, r.user_id, r.owner_id, " +
        "r.rental_status, " +
        "u.first_name, u.last_name, " +
        "o.first_name AS owner_first_name, " +
        "o.last_name AS owner_last_name " +
        "FROM rentals r " +
        "JOIN users u ON r.user_id = u.id " +
        "JOIN users o ON r.owner_id = o.id " +
        "WHERE r.rental_id = ?"
    );

    rentalPs.setInt(1, rentalId);

    ResultSet rentalRs = rentalPs.executeQuery();

    if (!rentalRs.next()) {

        rentalRs.close();
        rentalPs.close();
        con.close();

        response.sendRedirect(
            "myRentals.jsp?error=rentalNotFound"
        );

        return;
    }

    int productId =
        rentalRs.getInt("product_id");

    int userId =
        rentalRs.getInt("user_id");

    int ownerId =
        rentalRs.getInt("owner_id");

    String renterName =
        rentalRs.getString("first_name") +
        " " +
        rentalRs.getString("last_name");

    String ownerName =
        rentalRs.getString("owner_first_name") +
        " " +
        rentalRs.getString("owner_last_name");

    rentalRs.close();
    rentalPs.close();


    /*
     * Prevent duplicate return request
     */
    PreparedStatement checkPs = con.prepareStatement(
        "SELECT COUNT(*) FROM return_requests " +
        "WHERE order_id = ?"
    );

    checkPs.setInt(1, rentalId);

    ResultSet checkRs = checkPs.executeQuery();

    boolean alreadyRequested = false;

    if (checkRs.next()) {
        alreadyRequested =
            checkRs.getInt(1) > 0;
    }

    checkRs.close();
    checkPs.close();


    if (alreadyRequested) {

        con.close();

        response.sendRedirect(
            "myRentals.jsp?error=alreadyRequested"
        );

        return;
    }


    /*
     * Insert return request
     *
     * For now order_id stores rental_id because
     * the existing return_requests table uses
     * the old column name.
     */
    PreparedStatement insertPs =
        con.prepareStatement(
            "INSERT INTO return_requests " +
            "(order_id, product_id, renter_name, " +
            "owner_name, return_date, status, delivery_status) " +
            "VALUES (?, ?, ?, ?, CURDATE(), ?, ?)"
        );

    insertPs.setInt(1, rentalId);
    insertPs.setInt(2, productId);
    insertPs.setString(3, renterName);
    insertPs.setString(4, ownerName);
    insertPs.setString(5, "PENDING");
    insertPs.setString(6, "WAITING");

    insertPs.executeUpdate();

    insertPs.close();


    /*
     * IMPORTANT:
     * Update new rentals table
     */
    PreparedStatement updateRental =
        con.prepareStatement(
            "UPDATE rentals " +
            "SET rental_status = ? " +
            "WHERE rental_id = ?"
        );

    updateRental.setString(
        1,
        "RETURN_REQUESTED"
    );

    updateRental.setInt(
        2,
        rentalId
    );

    updateRental.executeUpdate();

    updateRental.close();


    con.close();

    response.sendRedirect(
        "myRentals.jsp?success=returnRequested"
    );

    return;

}
catch(Exception e) {

    if (con != null) {
        try {
            con.close();
        }
        catch(Exception ignored) {}
    }

%>

<!DOCTYPE html>
<html>
<head>

<title>Return Request Error</title>

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

</head>

<body>

<div class="container mt-5">

<div class="alert alert-danger">

<h4>Unable to send return request</h4>

<p>
<%=e.getMessage()%>
</p>

</div>

<a
href="myRentals.jsp"
class="btn btn-primary">

Back to My Rentals

</a>

</div>

</body>
</html>

<%
}
%>

