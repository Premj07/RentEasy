<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String bookingOwnerEmail = (String) session.getAttribute("email");

int bookingOwnerId = 0;
boolean bookingFound = false;

Connection bookingCon = null;
PreparedStatement bookingPs = null;
ResultSet bookingRs = null;
%>


<!-- =====================================================
     OWNER BOOKINGS HEADER
===================================================== -->

<div class="section-header">

    <div>

        <h3>
            <i class="bi bi-calendar-check"></i>
            Recent Bookings
        </h3>

        <p>
            Track customers currently renting your products.
        </p>

    </div>


    <a href="OwnerRentalsServlet"
       class="btn-view-all">

        View All

        <i class="bi bi-arrow-right"></i>

    </a>

</div>



<!-- =====================================================
     BOOKINGS
===================================================== -->

<div class="owner-booking-list">

<%

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    bookingCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    /* =================================================
       GET OWNER ID
    ================================================= */

    PreparedStatement ownerIdPs =
        bookingCon.prepareStatement(

            "SELECT id " +
            "FROM users " +
            "WHERE email=?"

        );

    ownerIdPs.setString(
        1,
        bookingOwnerEmail
    );

    ResultSet ownerIdRs =
        ownerIdPs.executeQuery();


    if(ownerIdRs.next()) {

        bookingOwnerId =
            ownerIdRs.getInt("id");

    }


    ownerIdRs.close();
    ownerIdPs.close();



    /* =================================================
       LOAD RECENT RENTALS
    ================================================= */

    bookingPs =
        bookingCon.prepareStatement(

        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.rent_amount, " +
        "r.payment_status, " +
        "r.rental_status, " +

        "p.name AS product_name, " +
        "p.image AS product_image, " +

        "u.first_name, " +
        "u.last_name, " +
        "u.email AS customer_email " +

        "FROM rentals r " +

        "JOIN products p " +
        "ON r.product_id = p.id " +

        "JOIN users u " +
        "ON r.user_id = u.id " +

        "WHERE r.owner_id=? " +

        "ORDER BY r.rental_id DESC " +

        "LIMIT 5"

    );


    bookingPs.setInt(
        1,
        bookingOwnerId
    );


    bookingRs =
        bookingPs.executeQuery();



    while(bookingRs.next()) {

        bookingFound = true;


        int rentalId =
            bookingRs.getInt(
                "rental_id"
            );


        String productName =
            bookingRs.getString(
                "product_name"
            );


        String productImage =
            bookingRs.getString(
                "product_image"
            );


        String customerFirstName =
            bookingRs.getString(
                "first_name"
            );


        String customerLastName =
            bookingRs.getString(
                "last_name"
            );


        String customerEmail =
            bookingRs.getString(
                "customer_email"
            );


        Date startDate =
            bookingRs.getDate(
                "start_date"
            );


        Date endDate =
            bookingRs.getDate(
                "end_date"
            );


        double rentAmount =
            bookingRs.getDouble(
                "rent_amount"
            );


        String paymentStatus =
            bookingRs.getString(
                "payment_status"
            );


        String rentalStatus =
            bookingRs.getString(
                "rental_status"
            );


        if(productName == null) {
            productName = "Product";
        }


        if(customerFirstName == null) {
            customerFirstName = "";
        }


        if(customerLastName == null) {
            customerLastName = "";
        }


        String customerName =
            (
                customerFirstName
                + " "
                + customerLastName
            ).trim();


        if(customerName.isEmpty()) {
            customerName = "Customer";
        }


        if(paymentStatus == null) {
            paymentStatus = "PENDING";
        }


        if(rentalStatus == null) {
            rentalStatus = "PENDING";
        }


        String rentalStatusClass =
            rentalStatus
                .toLowerCase()
                .replace("_", "-");


        String paymentStatusClass =
            paymentStatus
                .toLowerCase()
                .replace("_", "-");

%>


<!-- =====================================================
     BOOKING CARD
===================================================== -->

<div class="owner-booking-card">


    <!-- PRODUCT -->

    <div class="booking-product">


        <div class="booking-product-image">

            <%

            if(productImage != null &&
               !productImage.trim().isEmpty()) {

            %>

            <img
                src="<%=request.getContextPath()%>/<%=productImage%>"
                alt="<%=productName%>"
            >

            <%

            } else {

            %>

            <div class="booking-no-image">

                <i class="bi bi-image"></i>

            </div>

            <%

            }

            %>

        </div>



        <div class="booking-product-info">

            <span class="booking-number">

                Rental #<%=rentalId%>

            </span>


            <h4>

                <%=productName%>

            </h4>


            <span class="booking-customer">

                <i class="bi bi-person"></i>

                <%=customerName%>

            </span>


            <small>

                <%=customerEmail%>

            </small>

        </div>

    </div>



    <!-- DATES -->

    <div class="booking-column">

        <span class="booking-label">
            Rental Period
        </span>

        <strong>

            <%=startDate%>

        </strong>

        <small>

            to <%=endDate%>

        </small>

    </div>



    <!-- AMOUNT -->

    <div class="booking-column">

        <span class="booking-label">
            Rent Amount
        </span>

        <strong class="booking-amount">

            ₹<%=String.format("%.2f",rentAmount)%>

        </strong>


        <span class="booking-payment
                     <%=paymentStatusClass%>">

            <%=paymentStatus%>

        </span>

    </div>



    <!-- RENTAL STATUS -->

    <div class="booking-column">

        <span class="booking-label">
            Rental Status
        </span>


        <span class="booking-status
                     <%=rentalStatusClass%>">

            <%=rentalStatus
                .replace("_"," ")%>

        </span>

    </div>



    <!-- ACTION -->

    <div class="booking-action">

        <a href="OwnerRentalsServlet"
           class="booking-view-btn">

            View

            <i class="bi bi-arrow-right"></i>

        </a>

    </div>


</div>


<%

    } // while



    /* =================================================
       NO BOOKINGS
    ================================================= */

    if(!bookingFound) {

%>


<div class="owner-booking-empty">

    <div class="booking-empty-icon">

        <i class="bi bi-calendar2-check"></i>

    </div>


    <h3>
        No rentals yet
    </h3>


    <p>
        New customer rentals for your products
        will appear here.
    </p>

</div>


<%

    }


} catch(Exception e) {

    e.printStackTrace();

%>


<div class="owner-booking-error">

    <i class="bi bi-exclamation-triangle"></i>

    <div>

        <strong>
            Unable to load bookings
        </strong>

        <p>
            <%=e.getMessage()%>
        </p>

    </div>

</div>


<%

} finally {

    try {

        if(bookingRs != null)
            bookingRs.close();

        if(bookingPs != null)
            bookingPs.close();

        if(bookingCon != null)
            bookingCon.close();

    } catch(SQLException ignored) {
    }

}

%>

</div>