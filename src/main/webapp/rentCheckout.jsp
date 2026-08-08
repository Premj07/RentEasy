<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>RentEasy | Rental Checkout</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

body{
    background:#f5f7fb;
    font-family:Arial,Helvetica,sans-serif;
}

.checkout-title{
    font-size:34px;
    font-weight:bold;
    color:#0d6efd;
}

.card-box{
    background:#fff;
    border-radius:18px;
    box-shadow:0 6px 20px rgba(0,0,0,.08);
    padding:25px;
}

.section-title{
    font-size:22px;
    font-weight:600;
    margin-bottom:20px;
}

</style>

</head>

<body>

<!-- Navbar -->

<%@ include file="includes/navbar.jsp" %>

<div class="container-fluid px-5 mt-5 mb-5">

    <div class="text-center mb-5">

        <h1 class="checkout-title">
            Rent Checkout
        </h1>

        <p class="text-muted">
            Review your rental details before payment.
        </p>

    </div>

    <div class="row align-items-start g-4">

        <!-- LEFT SIDE -->

        <div class="col-lg-7">

            <div class="card-box">

                <%@ include file="includes/rent-product.jsp" %>

            </div>

        </div>

        <!-- RIGHT SIDE -->

        <div class="col-lg-5">

            <div class="card-box">

                <%@ include file="includes/rent-summary.jsp" %>

            </div>

        </div>

    </div>

</div>

<!-- Footer -->

<%-- <%@ include file="includes/footer.jsp" %> --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="js/rent-duration.js"></script>

</body>
</html>