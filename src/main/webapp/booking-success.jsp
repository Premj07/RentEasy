<%@page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@page import="com.renteasy.model.BookingDetails"%>

<%
BookingDetails booking = (BookingDetails) request.getAttribute("booking");

if(booking==null){
    response.sendRedirect("dashboard.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Booking Successful | RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<link rel="stylesheet" href="css/booking-success.css">

<link rel="icon" href="images/logo.png">

</head>

<body>

<!-- ========================= NAVBAR ========================= -->

<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow">

<div class="container">

<a class="navbar-brand fw-bold" href="dashboard.jsp">

<i class="bi bi-box-seam-fill"></i>

RentEasy

</a>

<button class="navbar-toggler"
type="button"
data-bs-toggle="collapse"
data-bs-target="#navbar">

<span class="navbar-toggler-icon"></span>

</button>

<div class="collapse navbar-collapse"
id="navbar">

<ul class="navbar-nav ms-auto">

<li class="nav-item">

<a class="nav-link"
href="dashboard.jsp">

<i class="bi bi-house-door"></i>

Dashboard

</a>

</li>

<li class="nav-item">

<a class="nav-link"
href="my-rentals.jsp">

<i class="bi bi-bag-check"></i>

My Rentals

</a>

</li>

<li class="nav-item">

<a class="nav-link"
href="profile.jsp">

<i class="bi bi-person-circle"></i>

Profile

</a>

</li>

</ul>

</div>

</div>

</nav>

<!-- ========================= SUCCESS HEADER ========================= -->

<section class="success-section py-5">

<div class="container">

<div class="row justify-content-center">

<div class="col-lg-10">

<div class="success-card text-center">

<div class="success-icon">

<i class="bi bi-check-circle-fill"></i>

</div>

<h1 class="display-5 fw-bold mt-3">

Payment Successful

</h1>

<p class="lead text-muted">

Your booking has been confirmed successfully.

</p>

<div class="row mt-5">

<div class="col-md-3 mb-3">

<div class="mini-box">

<h6>Booking ID</h6>

<h5>

#RE<%=booking.getRentalId()%>

</h5>

</div>

</div>

<div class="col-md-3 mb-3">

<div class="mini-box">

<h6>Payment</h6>

<span class="badge bg-success fs-6">

<%=booking.getPaymentStatus()%>

</span>

</div>

</div>

<div class="col-md-3 mb-3">

<div class="mini-box">

<h6>Pickup</h6>

<h5>

<%=booking.getPickupMethod()%>

</h5>

</div>

</div>

<div class="col-md-3 mb-3">

<div class="mini-box">

<h6>Total Paid</h6>

<h4 class="text-success">

₹ <%=String.format("%.2f",booking.getTotalAmount())%>

</h4>

</div>

</div>

</div>

<hr class="my-5">

<div class="row text-start">

<div class="col-md-6">

<p>

<i class="bi bi-calendar-check-fill text-success"></i>

<strong>Rental Start :</strong>

<%=booking.getStartDate()%>

</p>

<p>

<i class="bi bi-calendar-x-fill text-danger"></i>

<strong>Rental End :</strong>

<%=booking.getEndDate()%>

</p>

</div>

<div class="col-md-6">

<p>

<i class="bi bi-credit-card-fill text-primary"></i>

<strong>Razorpay Payment ID :</strong>

<br>

<small>

<%=booking.getRazorpayPaymentId()%>

</small>

</p>

<p>

<i class="bi bi-receipt-cutoff text-warning"></i>

<strong>Order ID :</strong>

<br>

<small>

<%=booking.getRazorpayOrderId()%>

</small>

</p>

</div>

</div>

</div>

</div>

</div>

</div>

</section>

<!-- ========================= MAIN CONTENT ========================= -->

<div class="container pb-5">

<div class="row">
<!-- ========================= LEFT COLUMN ========================= -->

<div class="col-lg-8">

    <!-- ================= PRODUCT CARD ================= -->

    <div class="card shadow-lg border-0 rounded-4 mb-4">

        <div class="card-header bg-success text-white rounded-top-4">

            <h4 class="mb-0">
                <i class="bi bi-box-seam-fill"></i>
                Product Details
            </h4>

        </div>

        <div class="card-body">

            <div class="row">

                <div class="col-md-4 text-center">

                    <img
    src="<%=request.getContextPath()%>/<%=booking.getProductImage()%>"
    class="img-fluid rounded shadow product-image"
    alt="Product">

                </div>

                <div class="col-md-8">

                    <h3 class="fw-bold">
                        <%=booking.getProductName()%>
                    </h3>

                    <hr>

                    <div class="row">

                        <div class="col-md-6 mb-3">

                            <label class="text-muted">
                                Category
                            </label>

                            <h6>

                                <span class="badge bg-primary">

                                    <%=booking.getCategory()%>

                                </span>

                            </h6>

                        </div>

                        <div class="col-md-6 mb-3">

                            <label class="text-muted">
                                Pickup Method
                            </label>

                            <h6>

                                <%=booking.getPickupMethod()%>

                            </h6>

                        </div>

                        <div class="col-md-6 mb-3">

                            <label class="text-muted">
                                Rental Duration
                            </label>

                            <h6>

                                <%=booking.getRentalMonths()%> Month(s)

                            </h6>

                        </div>

                        <div class="col-md-6 mb-3">

                            <label class="text-muted">
                                Payment Status
                            </label>

                            <h6>

                                <span class="badge bg-success">

                                    <%=booking.getPaymentStatus()%>

                                </span>

                            </h6>

                        </div>

                    </div>

                    <hr>

                    <i class="bi bi-geo-alt-fill text-danger"></i>

                    <strong>Location</strong>

                    <br>

                    <%=booking.getLocation()%>

                </div>

            </div>

        </div>

    </div>



    <!-- ================= RENT DETAILS ================= -->

    <div class="card shadow border-0 rounded-4 mb-4">

        <div class="card-header bg-dark text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-receipt"></i>

                Booking Details

            </h4>

        </div>

        <div class="card-body">

            <div class="row">

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Booking ID

                        </h6>

                        <h5>

                            RE<%=booking.getRentalId()%>

                        </h5>

                    </div>

                </div>

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Rent Amount

                        </h6>

                        <h4 class="text-success">

                            ₹<%=String.format("%.2f",booking.getRentAmount())%>

                        </h4>

                    </div>

                </div>

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Security Deposit

                        </h6>

                        <h4 class="text-warning">

                            ₹<%=String.format("%.2f",booking.getSecurityDeposit())%>

                        </h4>

                    </div>

                </div>

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Total Paid

                        </h6>

                        <h4 class="text-primary">

                            ₹<%=String.format("%.2f",booking.getTotalAmount())%>

                        </h4>

                    </div>

                </div>

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Rental Starts

                        </h6>

                        <h5>

                            <%=booking.getStartDate()%>

                        </h5>

                    </div>

                </div>

                <div class="col-md-6 mb-4">

                    <div class="detail-box">

                        <h6 class="text-muted">

                            Rental Ends

                        </h6>

                        <h5>

                            <%=booking.getEndDate()%>

                        </h5>

                    </div>

                </div>

                <div class="col-md-12">

                    <div class="alert alert-success">

                        <i class="bi bi-shield-check"></i>

                        Your booking has been confirmed successfully.
                        Please carry your registered College ID during pickup.

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>



<!-- ========================= RIGHT COLUMN ========================= -->

<div class="col-lg-4">
    <!-- ================= OWNER DETAILS ================= -->

    <div class="card shadow border-0 rounded-4 mb-4">

        <div class="card-header bg-primary text-white rounded-top-4">

            <h4 class="mb-0">
                <i class="bi bi-person-badge-fill"></i>
                Owner Details
            </h4>

        </div>

        <div class="card-body">

            <div class="text-center mb-3">

                <i class="bi bi-person-circle display-1 text-primary"></i>

            </div>

            <table class="table table-borderless">

                <tr>
                    <th>Name</th>
                    <td><%=booking.getOwnerName()%></td>
                </tr>

                <tr>
                    <th>Email</th>
                    <td><%=booking.getOwnerEmail()%></td>
                </tr>

                <tr>
                    <th>Phone</th>
                    <td>
                        <a href="tel:<%=booking.getOwnerPhone()%>"
                           class="text-decoration-none">

                            <%=booking.getOwnerPhone()%>

                        </a>
                    </td>
                </tr>

            </table>

            <a href="tel:<%=booking.getOwnerPhone()%>"
               class="btn btn-success w-100">

                <i class="bi bi-telephone-fill"></i>

                Call Owner

            </a>

        </div>

    </div>



    <!-- ================= CUSTOMER DETAILS ================= -->

    <div class="card shadow border-0 rounded-4 mb-4">

        <div class="card-header bg-info text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-person-check-fill"></i>

                Your Details

            </h4>

        </div>

        <div class="card-body">

            <div class="text-center mb-3">

                <i class="bi bi-person-fill display-1 text-info"></i>

            </div>

            <table class="table table-borderless">

                <tr>

                    <th>Name</th>

                    <td>

                        <%=booking.getCustomerName()%>

                    </td>

                </tr>

                <tr>

                    <th>Email</th>

                    <td>

                        <%=booking.getCustomerEmail()%>

                    </td>

                </tr>

                <tr>

                    <th>Phone</th>

                    <td>

                        <%=booking.getCustomerPhone()%>

                    </td>

                </tr>

            </table>

        </div>

    </div>



    <!-- ================= PICKUP OTP ================= -->

    <div class="card shadow-lg border-0 rounded-4 mb-4">

        <div class="card-header bg-warning rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-shield-lock-fill"></i>

                Pickup Verification OTP

            </h4>

        </div>

        <div class="card-body text-center">

            <p class="text-muted">

                Share this OTP with the owner only at the time of pickup.

            </p>

            <div class="otp-box mb-3">

                <span id="pickupOTP">

                    <%=booking.getPickupOtp()%>

                </span>

            </div>

            <button
                class="btn btn-dark"
                onclick="copyOTP()">

                <i class="bi bi-copy"></i>

                Copy OTP

            </button>

            <hr>

            <h6 class="text-muted">

                Pickup Status

            </h6>

            <span class="badge bg-secondary fs-6">

                <%=booking.getPickupStatus()%>

            </span>

            <hr>

            <div class="alert alert-warning mb-0">

                <i class="bi bi-exclamation-triangle-fill"></i>

                Never share this OTP before receiving the product.
                The owner will ask for this code during pickup.

            </div>

        </div>

    </div>



    <!-- ================= PAYMENT SUMMARY ================= -->

    <div class="card shadow border-0 rounded-4">

        <div class="card-header bg-success text-white rounded-top-4">

            <h5 class="mb-0">

                <i class="bi bi-wallet2"></i>

                Payment Summary

            </h5>

        </div>

        <div class="card-body">

            <table class="table">

                <tr>

                    <td>Rent Amount</td>

                    <td class="text-end">

                        ₹<%=String.format("%.2f", booking.getRentAmount())%>

                    </td>

                </tr>

                <tr>

                    <td>Security Deposit</td>

                    <td class="text-end">

                        ₹<%=String.format("%.2f", booking.getSecurityDeposit())%>

                    </td>

                </tr>

                <tr class="table-success">

                    <th>Total Paid</th>

                    <th class="text-end">

                        ₹<%=String.format("%.2f", booking.getTotalAmount())%>

                    </th>

                </tr>

            </table>

        </div>

    </div>

</div>

<!-- ================= END RIGHT COLUMN ================= -->

</div>

<!-- ================= NEXT SECTION START ================= -->

<div class="row mt-4">
<!-- ================= GOOGLE MAP ================= -->

<div class="col-lg-6 mb-4">

    <div class="card shadow border-0 rounded-4 h-100">

        <div class="card-header bg-danger text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-geo-alt-fill"></i>

                Pickup Location

            </h4>

        </div>

        <div class="card-body">

            <h5 class="fw-bold mb-3">

                <%=booking.getProductName()%>

            </h5>

            <p>

                <i class="bi bi-pin-map-fill text-danger"></i>

                <%=booking.getLocation()%>

            </p>

            <div class="ratio ratio-16x9 rounded overflow-hidden shadow-sm mb-3">

                <iframe
                    src="https://maps.google.com/maps?q=<%=booking.getLatitude()%>,<%=booking.getLongitude()%>&hl=en&z=15&output=embed"
                    style="border:0;"
                    allowfullscreen=""
                    loading="lazy">
                </iframe>

            </div>

            <div class="d-grid">

                <a
                    href="https://www.google.com/maps/search/?api=1&query=<%=booking.getLatitude()%>,<%=booking.getLongitude()%>"
                    target="_blank"
                    class="btn btn-danger">

                    <i class="bi bi-map"></i>

                    Open in Google Maps

                </a>

            </div>

        </div>

    </div>

</div>



<!-- ================= BOOKING TIMELINE ================= -->

<div class="col-lg-6 mb-4">

    <div class="card shadow border-0 rounded-4 h-100">

        <div class="card-header bg-dark text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-clock-history"></i>

                Booking Timeline

            </h4>

        </div>

        <div class="card-body">

            <ul class="timeline list-unstyled">

                <li class="mb-4">

                    <i class="bi bi-check-circle-fill text-success fs-4"></i>

                    <div class="ms-3 d-inline-block">

                        <h6 class="mb-1">

                            Booking Confirmed

                        </h6>

                        <small class="text-muted">

                            Payment completed successfully.

                        </small>

                    </div>

                </li>

                <li class="mb-4">

                    <i class="bi bi-credit-card-fill text-primary fs-4"></i>

                    <div class="ms-3 d-inline-block">

                        <h6 class="mb-1">

                            Payment Verified

                        </h6>

                        <small class="text-muted">

                            Razorpay transaction verified.

                        </small>

                    </div>

                </li>

                <li class="mb-4">

                    <i class="bi bi-shield-lock-fill text-warning fs-4"></i>

                    <div class="ms-3 d-inline-block">

                        <h6 class="mb-1">

                            Pickup OTP Generated

                        </h6>

                        <small class="text-muted">

                            Show OTP only during pickup.

                        </small>

                    </div>

                </li>

                <li>

                    <i class="bi bi-box-seam text-secondary fs-4"></i>

                    <div class="ms-3 d-inline-block">

                        <h6 class="mb-1">

                            Awaiting Pickup

                        </h6>

                        <small class="text-muted">

                            Current Status :

                            <strong>

                                <%=booking.getPickupStatus()%>

                            </strong>

                        </small>

                    </div>

                </li>

            </ul>

        </div>

    </div>

</div>



<!-- ================= RENTAL AGREEMENT ================= -->

<div class="col-lg-12 mb-4">

    <div class="card shadow border-0 rounded-4">

        <div class="card-header bg-primary text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-file-earmark-text-fill"></i>

                Rental Agreement Summary

            </h4>

        </div>

        <div class="card-body">

            <div class="row">

                <div class="col-md-6">

                    <table class="table table-bordered">

                        <tr>

                            <th>Customer</th>

                            <td>

                                <%=booking.getCustomerName()%>

                            </td>

                        </tr>

                        <tr>

                            <th>Owner</th>

                            <td>

                                <%=booking.getOwnerName()%>

                            </td>

                        </tr>

                        <tr>

                            <th>Product</th>

                            <td>

                                <%=booking.getProductName()%>

                            </td>

                        </tr>

                        <tr>

                            <th>Rental Duration</th>

                            <td>

                                <%=booking.getRentalMonths()%> Month(s)

                            </td>

                        </tr>

                    </table>

                </div>

                <div class="col-md-6">

                    <table class="table table-bordered">

                        <tr>

                            <th>Rent</th>

                            <td>

                                ₹<%=String.format("%.2f", booking.getRentAmount())%>

                            </td>

                        </tr>

                        <tr>

                            <th>Deposit</th>

                            <td>

                                ₹<%=String.format("%.2f", booking.getSecurityDeposit())%>

                            </td>

                        </tr>

                        <tr>

                            <th>Total Paid</th>

                            <td>

                                ₹<%=String.format("%.2f", booking.getTotalAmount())%>

                            </td>

                        </tr>

                        <tr>

                            <th>Payment Status</th>

                            <td>

                                <span class="badge bg-success">

                                    <%=booking.getPaymentStatus()%>

                                </span>

                            </td>

                        </tr>

                    </table>

                </div>

            </div>

            <div class="alert alert-info mt-3 mb-0">

                <i class="bi bi-info-circle-fill"></i>

                This page serves as your booking confirmation.
                Keep your Pickup OTP safe and present your College ID while collecting the product.
                The security deposit will be handled according to the RentEasy rental policy.

            </div>

        </div>

    </div>

</div>
<!-- ================= HELP & SUPPORT ================= -->

<div class="col-lg-12 mb-5">

    <div class="card border-0 shadow rounded-4">

        <div class="card-header bg-success text-white rounded-top-4">

            <h4 class="mb-0">

                <i class="bi bi-headset"></i>

                Need Help?

            </h4>

        </div>

        <div class="card-body">

            <div class="row text-center">

                <div class="col-md-4 mb-3">

                    <i class="bi bi-envelope-fill display-5 text-success"></i>

                    <h5 class="mt-3">

                        Email Support

                    </h5>

                    <p>

                        support@renteasy.com

                    </p>

                </div>

                <div class="col-md-4 mb-3">

                    <i class="bi bi-telephone-fill display-5 text-primary"></i>

                    <h5 class="mt-3">

                        Phone Support

                    </h5>

                    <p>

                        +91 9876543210

                    </p>

                </div>

                <div class="col-md-4 mb-3">

                    <i class="bi bi-clock-fill display-5 text-warning"></i>

                    <h5 class="mt-3">

                        Working Hours

                    </h5>

                    <p>

                        Mon - Sat<br>

                        9:00 AM - 6:00 PM

                    </p>

                </div>

            </div>

        </div>

    </div>

</div>

<!-- ================= ACTION BUTTONS ================= -->

<div class="col-lg-12 mb-5">

    <div class="card shadow border-0 rounded-4">

        <div class="card-body text-center">

            <h4 class="fw-bold mb-4">

                Booking Completed Successfully

            </h4>

            <div class="d-flex flex-wrap justify-content-center gap-3">

                <button
                        class="btn btn-success btn-lg"
                        onclick="window.print();">

                    <i class="bi bi-printer-fill"></i>

                    Print Receipt

                </button>

                <button
                        class="btn btn-primary btn-lg"
                        onclick="downloadReceipt();">

                    <i class="bi bi-download"></i>

                    Download Receipt

                </button>

                <button
                        class="btn btn-warning btn-lg"
                        onclick="shareBooking();">

                    <i class="bi bi-share-fill"></i>

                    Share Booking

                </button>

                <a
                        href="dashboard.jsp"
                        class="btn btn-dark btn-lg">

                    <i class="bi bi-house-fill"></i>

                    Dashboard

                </a>

            </div>

        </div>

    </div>

</div>

</div>

</div>

<footer class="bg-dark text-white py-4 mt-5">

    <div class="container text-center">

        <h5 class="fw-bold">

            RentEasy

        </h5>

        <p class="mb-1">

            Making renting simple, secure and convenient.

        </p>

        <small>

            © 2026 RentEasy. All Rights Reserved.

        </small>

    </div>

</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="js/booking-success.js"></script>

</body>

</html>