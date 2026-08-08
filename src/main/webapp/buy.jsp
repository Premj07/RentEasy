<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
/* =========================================================
   LOGIN CHECK
   ========================================================= */

String username = (String) session.getAttribute("user");

if (username == null) {
    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   GET PRODUCT ID
   ========================================================= */

String idParam = request.getParameter("id");

if (idParam == null || idParam.trim().isEmpty()) {
    response.sendRedirect("dashboard.jsp");
    return;
}

int productId = 0;

try {

    productId = Integer.parseInt(idParam);

} catch (Exception e) {

    response.sendRedirect("dashboard.jsp");
    return;
}


/* =========================================================
   PRODUCT VARIABLES
   ========================================================= */

String productName = "";
String productImage = "";
String productLocation = "";
String productCategory = "";
String ownerName = "";
String productDescription = "";

double actualPrice = 0;
double sellingPrice = 0;

String listingType = "";
String productStatus = "";


/* =========================================================
   USER VARIABLES
   ========================================================= */

String userFullName = "";
String userPhone = "";
String userAddress = "";


/* =========================================================
   DATABASE
   ========================================================= */

Connection con = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"
    );


    /* =====================================================
       GET PRODUCT
       ===================================================== */

    PreparedStatement ps =
            con.prepareStatement(
                    "SELECT * FROM products WHERE id=?"
            );

    ps.setInt(1, productId);

    ResultSet rs =
            ps.executeQuery();


    if (!rs.next()) {

        rs.close();
        ps.close();
        con.close();

        response.sendRedirect("dashboard.jsp");
        return;
    }


    productName =
            rs.getString("name");

    productImage =
            rs.getString("image");

    productLocation =
            rs.getString("location");

    productCategory =
            rs.getString("category");

    ownerName =
            rs.getString("owner");

    actualPrice =
            rs.getDouble("actual_price");

    sellingPrice =
            rs.getDouble("selling_price");

    listingType =
            rs.getString("listing_type");

    productStatus =
            rs.getString("status");


    try {

        productDescription =
                rs.getString("description");

    } catch (Exception ignored) {

        productDescription = "";
    }


    rs.close();
    ps.close();


    /* =====================================================
       VALIDATE PRODUCT
       ===================================================== */

    if (!"SELL".equalsIgnoreCase(listingType)
            &&
        !"BOTH".equalsIgnoreCase(listingType)) {

        con.close();

        response.sendRedirect(
                "rentProduct.jsp?id=" + productId
        );

        return;
    }


    if ("SOLD".equalsIgnoreCase(productStatus)) {

        con.close();

        response.sendRedirect(
                "rentProduct.jsp?id=" + productId
        );

        return;
    }


    /* =====================================================
       GET LOGGED IN USER
       ===================================================== */

    PreparedStatement userPs =
            con.prepareStatement(
                    "SELECT * FROM users WHERE username=?"
            );

    userPs.setString(
            1,
            username
    );

    ResultSet userRs =
            userPs.executeQuery();


    if (userRs.next()) {

        try {

            userFullName =
                    userRs.getString("name");

        } catch (Exception ignored) {}


        try {

            userPhone =
                    userRs.getString("phone");

        } catch (Exception ignored) {}


        try {

            userAddress =
                    userRs.getString("address");

        } catch (Exception ignored) {}
    }


    userRs.close();
    userPs.close();

    con.close();


} catch (Exception e) {

    e.printStackTrace();

    if (con != null) {

        try {

            con.close();

        } catch (Exception ignored) {}
    }
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Buy <%=productName%> | RentEasy
</title>


<!-- BOOTSTRAP -->
<link rel="stylesheet" href="css/dashboard.css">

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- BOOTSTRAP ICONS -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>

/* =========================================================
   GLOBAL
   ========================================================= */

* {

    box-sizing: border-box;
}


body {

    margin: 0;

    background: #f5f7fb;

    color: #172033;

    font-family:
        "Segoe UI",
        Arial,
        Helvetica,
        sans-serif;
}


/* =========================================================
   PAGE
   ========================================================= */

.checkout-container {

    max-width: 1450px;

    margin: 0 auto;

    padding: 32px 28px 70px;
}


.checkout-heading {

    margin-bottom: 28px;
}


.checkout-heading h2 {

    margin: 0 0 7px;

    font-size: 27px;

    font-weight: 750;

    color: #172033;
}


.checkout-heading p {

    margin: 0;

    color: #7b8495;

    font-size: 14px;
}


/* =========================================================
   BACK LINK
   ========================================================= */

.back-link {

    display: inline-flex;

    align-items: center;

    gap: 7px;

    margin-bottom: 18px;

    color: #667085;

    text-decoration: none;

    font-size: 14px;

    font-weight: 600;

    transition: .2s;
}


.back-link:hover {

    color: #0d6efd;
}


/* =========================================================
   MAIN CARD
   ========================================================= */

.checkout-card {

    background: #ffffff;

    border: 1px solid #e7eaf0;

    border-radius: 16px;

    box-shadow:
        0 6px 22px
        rgba(20, 31, 56, .06);

    overflow: hidden;
}


.card-inner {

    padding: 24px;
}


/* =========================================================
   CARD TITLE
   ========================================================= */

.card-title-custom {

    display: flex;

    align-items: center;

    gap: 10px;

    font-size: 18px;

    font-weight: 700;

    color: #202939;

    margin-bottom: 20px;
}


.card-title-custom i {

    color: #0d6efd;

    font-size: 19px;
}


/* =========================================================
   PRODUCT IMAGE
   ========================================================= */

.product-image-wrap {

    width: 100%;

    height: 300px;

    background: #f2f4f7;

    overflow: hidden;
}


.product-image {

    width: 100%;

    height: 100%;

    object-fit: cover;

    display: block;

    transition: transform .35s ease;
}


.product-image:hover {

    transform: scale(1.025);
}


/* =========================================================
   PRODUCT INFO
   ========================================================= */

.product-content {

    padding: 23px;
}


.available-badge {

    display: inline-flex;

    align-items: center;

    gap: 6px;

    padding: 6px 11px;

    margin-bottom: 13px;

    background: #eaf8ef;

    color: #198754;

    border-radius: 20px;

    font-size: 12px;

    font-weight: 700;
}


.product-name {

    margin: 0 0 12px;

    color: #172033;

    font-size: 24px;

    line-height: 1.3;

    font-weight: 750;
}


.meta-row {

    display: flex;

    align-items: center;

    gap: 9px;

    margin-bottom: 10px;

    color: #697386;

    font-size: 14px;
}


.meta-row i {

    width: 18px;

    color: #87909f;

    text-align: center;
}


/* =========================================================
   PRICE
   ========================================================= */

.product-price-box {

    margin-top: 19px;

    padding: 16px;

    background: #f8faff;

    border: 1px solid #e9efff;

    border-radius: 12px;
}


.small-price-label {

    margin-bottom: 4px;

    color: #7b8495;

    font-size: 12px;

    font-weight: 600;

    text-transform: uppercase;

    letter-spacing: .4px;
}


.main-price {

    color: #0d6efd;

    font-size: 27px;

    font-weight: 750;
}


.original-price {

    margin-top: 4px;

    color: #7b8495;

    font-size: 13px;
}


/* =========================================================
   DESCRIPTION
   ========================================================= */

.description-box {

    margin-top: 19px;

    padding-top: 17px;

    border-top: 1px solid #edf0f4;
}


.description-title {

    margin-bottom: 7px;

    color: #394150;

    font-size: 13px;

    font-weight: 700;
}


.description-text {

    margin: 0;

    color: #7b8495;

    font-size: 13px;

    line-height: 1.65;
}


/* =========================================================
   FORM
   ========================================================= */

.form-label {

    margin-bottom: 7px;

    color: #3f4755;

    font-size: 13px;

    font-weight: 650;
}


.form-control {

    min-height: 47px;

    padding: 10px 13px;

    border: 1px solid #dce1e8;

    border-radius: 9px;

    color: #222b3a;

    font-size: 14px;

    box-shadow: none !important;

    transition: .2s;
}


.form-control:focus {

    border-color: #6ea8fe;

    box-shadow:
        0 0 0 3px
        rgba(13, 110, 253, .08)
        !important;
}


textarea.form-control {

    min-height: 105px;

    resize: vertical;
}


/* =========================================================
   INFO STRIP
   ========================================================= */

.info-strip {

    display: flex;

    gap: 11px;

    margin-top: 18px;

    padding: 13px 14px;

    background: #f8faff;

    border-radius: 9px;

    color: #667085;

    font-size: 12px;

    line-height: 1.5;
}


.info-strip i {

    color: #0d6efd;

    font-size: 16px;
}


/* =========================================================
   PAYMENT METHOD
   ========================================================= */

.payment-method {

    display: flex;

    align-items: center;

    gap: 13px;

    padding: 15px;

    border: 1.5px solid #dce2eb;

    border-radius: 11px;

    cursor: pointer;

    transition: .2s;

    margin-bottom: 11px;
}


.payment-method:hover {

    border-color: #0d6efd;

    background: #f8faff;
}


.payment-method input {

    width: 17px;

    height: 17px;

    flex-shrink: 0;

    accent-color: #0d6efd;
}


.payment-icon {

    display: flex;

    align-items: center;

    justify-content: center;

    width: 42px;

    height: 42px;

    border-radius: 10px;

    background: #eef4ff;

    color: #0d6efd;

    font-size: 19px;
}


.payment-content {

    flex: 1;
}


.payment-name {

    margin-bottom: 2px;

    color: #283142;

    font-size: 14px;

    font-weight: 700;
}


.payment-description {

    color: #8a93a3;

    font-size: 12px;
}


/* =========================================================
   ORDER SUMMARY
   ========================================================= */

.summary-card {

    position: sticky;

    top: 95px;
}


.summary-header {

    padding: 20px 22px;

    border-bottom: 1px solid #edf0f4;
}


.summary-header h5 {

    margin: 0;

    color: #202939;

    font-size: 18px;

    font-weight: 700;
}


.summary-body {

    padding: 22px;
}


.summary-product {

    display: flex;

    gap: 12px;

    padding-bottom: 18px;

    margin-bottom: 18px;

    border-bottom: 1px solid #edf0f4;
}


.summary-image {

    width: 65px;

    height: 65px;

    object-fit: cover;

    border-radius: 9px;

    background: #f2f4f7;
}


.summary-product-info {

    min-width: 0;

    flex: 1;
}


.summary-product-name {

    margin-bottom: 5px;

    color: #283142;

    font-size: 14px;

    font-weight: 700;

    overflow: hidden;

    white-space: nowrap;

    text-overflow: ellipsis;
}


.summary-product-location {

    color: #8a93a3;

    font-size: 12px;
}


/* =========================================================
   SUMMARY ROWS
   ========================================================= */

.summary-row {

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 15px;

    margin-bottom: 14px;

    color: #687386;

    font-size: 13px;
}


.summary-row strong {

    color: #30394a;

    font-weight: 650;
}


.free-text {

    color: #198754 !important;

    font-weight: 700 !important;
}


.summary-divider {

    height: 1px;

    margin: 18px 0;

    background: #edf0f4;
}


.summary-total {

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 15px;
}


.summary-total-label {

    color: #202939;

    font-size: 16px;

    font-weight: 700;
}


.summary-total-price {

    color: #0d6efd;

    font-size: 23px;

    font-weight: 800;
}


/* =========================================================
   BUTTON
   ========================================================= */

.checkout-button {

    width: 100%;

    min-height: 50px;

    margin-top: 22px;

    border: 0;

    border-radius: 9px;

    background: #0d6efd;

    color: #ffffff;

    font-size: 14px;

    font-weight: 700;

    transition: .2s;
}


.checkout-button:hover {

    background: #0b5ed7;

    transform: translateY(-1px);

    box-shadow:
        0 7px 17px
        rgba(13, 110, 253, .18);
}


/* =========================================================
   SECURE
   ========================================================= */

.secure-checkout {

    display: flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    margin-top: 13px;

    color: #8a93a3;

    font-size: 11px;
}


.secure-checkout i {

    color: #198754;
}


/* =========================================================
   BUYER PROTECTION
   ========================================================= */

.protection-box {

    margin-top: 18px;

    padding: 14px;

    background: #f8faff;

    border: 1px solid #edf1f7;

    border-radius: 9px;
}


.protection-title {

    display: flex;

    align-items: center;

    gap: 7px;

    margin-bottom: 6px;

    color: #394150;

    font-size: 12px;

    font-weight: 700;
}


.protection-title i {

    color: #198754;
}


.protection-text {

    margin: 0;

    color: #8a93a3;

    font-size: 11px;

    line-height: 1.5;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width: 991px) {

    .summary-card {

        position: static;
    }


    .checkout-container {

        padding-left: 18px;

        padding-right: 18px;
    }
}


@media(max-width: 576px) {

    .checkout-container {

        padding-top: 22px;
    }


    .product-image-wrap {

        height: 240px;
    }


    .card-inner,
    .summary-body {

        padding: 18px;
    }
}

</style>

</head>


<body>


<!-- =========================================================
     SAME RENTEASY NAVBAR
     ========================================================= -->

<jsp:include page="includes/navbar.jsp"/>


<!-- =========================================================
     PAGE
     ========================================================= -->

<div class="checkout-container">


    <a
        href="rentProduct.jsp?id=<%=productId%>"
        class="back-link">

        <i class="bi bi-arrow-left"></i>

        Back to Product

    </a>


    <div class="checkout-heading">

        <h2>
            Complete Your Purchase
        </h2>

        <p>
            Review the product and enter your details to continue.
        </p>

    </div>


    <!-- =====================================================
         PURCHASE FORM
         ===================================================== -->

    <form
        action="<%=request.getContextPath()%>/PurchaseProductServlet"
        method="post">


        <input
            type="hidden"
            name="productId"
            value="<%=productId%>">


        <div class="row g-4">


            <!-- =================================================
                 LEFT COLUMN
                 PRODUCT DETAILS
                 ================================================= -->

            <div class="col-xl-4 col-lg-4">


                <div class="checkout-card h-100">


                    <!-- PRODUCT IMAGE -->

                    <div class="product-image-wrap">


                        <%
                        if (productImage != null &&
                            !productImage.trim().isEmpty()) {
                        %>


                        <img
                            src="<%=request.getContextPath()%>/<%=productImage%>"
                            class="product-image"
                            alt="<%=productName%>">


                        <%
                        } else {
                        %>


                        <div
                            class="d-flex align-items-center justify-content-center h-100 text-muted">

                            <i
                                class="bi bi-image"
                                style="font-size:60px;">
                            </i>

                        </div>


                        <%
                        }
                        %>


                    </div>


                    <!-- PRODUCT CONTENT -->

                    <div class="product-content">


                        <div class="available-badge">

                            <i class="bi bi-check-circle-fill"></i>

                            Available for Purchase

                        </div>


                        <h3 class="product-name">

                            <%=productName%>

                        </h3>


                        <!-- CATEGORY -->

                        <div class="meta-row">

                            <i class="bi bi-grid"></i>

                            <span>
                                <%=productCategory%>
                            </span>

                        </div>


                        <!-- LOCATION -->

                        <div class="meta-row">

                            <i class="bi bi-geo-alt"></i>

                            <span>
                                <%=productLocation%>
                            </span>

                        </div>


                        <!-- OWNER -->

                        <div class="meta-row">

                            <i class="bi bi-person-circle"></i>

                            <span>

                                Owner:
                                <strong>
                                    <%=ownerName%>
                                </strong>

                            </span>

                        </div>


                        <!-- PRICE -->

                        <div class="product-price-box">


                            <div class="small-price-label">

                                Selling Price

                            </div>


                            <div class="main-price">

                                ₹<%=String.format("%.2f", sellingPrice)%>

                            </div>


                            <div class="original-price">

                                Original Product Price:
                                ₹<%=String.format("%.2f", actualPrice)%>

                            </div>


                        </div>


                        <!-- DESCRIPTION -->

                        <%
                        if (productDescription != null &&
                            !productDescription.trim().isEmpty()) {
                        %>


                        <div class="description-box">


                            <div class="description-title">

                                Product Description

                            </div>


                            <p class="description-text">

                                <%=productDescription%>

                            </p>


                        </div>


                        <%
                        }
                        %>


                    </div>

                </div>

            </div>



            <!-- =================================================
                 MIDDLE COLUMN
                 DELIVERY + PAYMENT
                 ================================================= -->

            <div class="col-xl-5 col-lg-5">


                <!-- =================================================
     BUYER DETAILS
     ================================================= -->

<div class="checkout-card mb-4">

    <div class="card-inner">

        <div class="card-title-custom">

            <i class="bi bi-person-check"></i>

            Buyer Details

        </div>


        <div class="row g-3">

            <!-- FULL NAME -->

            <div class="col-md-6">

                <label class="form-label">
                    Full Name
                </label>

                <input
                    type="text"
                    name="deliveryName"
                    class="form-control"
                    value="<%=userFullName != null ? userFullName : ""%>"
                    placeholder="Enter full name"
                    required>

            </div>


            <!-- PHONE -->

            <div class="col-md-6">

                <label class="form-label">
                    Phone Number
                </label>

                <input
                    type="tel"
                    name="deliveryPhone"
                    class="form-control"
                    value="<%=userPhone != null ? userPhone : ""%>"
                    placeholder="10-digit mobile number"
                    maxlength="10"
                    pattern="[0-9]{10}"
                    required>

            </div>


            <!-- PINCODE -->

            <div class="col-md-6">

                <label class="form-label">
                    Pincode
                </label>

                <input
                    type="text"
                    name="deliveryPincode"
                    class="form-control"
                    placeholder="6-digit pincode"
                    maxlength="6"
                    pattern="[0-9]{6}"
                    required>

            </div>

        </div>


        <!--
             Keep parameter for current servlet,
             but don't ask user for address.
        -->

        <input
            type="hidden"
            name="deliveryAddress"
            value="">


        <div class="info-strip">

            <i class="bi bi-info-circle"></i>

            <div>
                The product handover/pickup location will be
                provided by the owner after the purchase.
            </div>

        </div>

    </div>

</div>



               <!-- =================================================
     PAYMENT METHOD - ONLINE ONLY
     ================================================= -->

<div class="checkout-card">

    <div class="card-inner">

        <div class="card-title-custom">

            <i class="bi bi-credit-card"></i>

            Payment Method

        </div>


        <div
            class="payment-method"
            style="
                border-color:#0d6efd;
                background:#f8faff;
                cursor:default;
            ">

            <div class="payment-icon">

                <i class="bi bi-shield-lock"></i>

            </div>


            <div class="payment-content">

                <div class="payment-name">

                    Secure Online Payment

                </div>


                <div class="payment-description">

                    Pay securely using UPI, Debit Card,
                    Credit Card, Net Banking or Wallet.

                </div>

            </div>


            <div class="ms-auto">

                <i
                    class="bi bi-check-circle-fill"
                    style="
                        color:#198754;
                        font-size:20px;
                    ">
                </i>

            </div>

        </div>


        <!-- Purchase servlet still receives ONLINE -->

        <input
            type="hidden"
            name="paymentMethod"
            value="ONLINE">


        <div class="info-strip">

            <i class="bi bi-shield-check"></i>

            <div>
                Your payment will be processed securely before
                the purchase is confirmed.
            </div>

        </div>

    </div>

</div>


            </div>



            <!-- =================================================
                 RIGHT COLUMN
                 ORDER SUMMARY
                 ================================================= -->

            <div class="col-xl-3 col-lg-3">


                <div class="checkout-card summary-card">


                    <div class="summary-header">


                        <h5>

                            Order Summary

                        </h5>


                    </div>


                    <div class="summary-body">


                        <!-- PRODUCT MINI CARD -->

                        <div class="summary-product">


                            <%
                            if (productImage != null &&
                                !productImage.trim().isEmpty()) {
                            %>


                            <img
                                src="<%=request.getContextPath()%>/<%=productImage%>"
                                class="summary-image"
                                alt="<%=productName%>">


                            <%
                            }
                            %>


                            <div class="summary-product-info">


                                <div class="summary-product-name">

                                    <%=productName%>

                                </div>


                                <div class="summary-product-location">

                                    <i class="bi bi-geo-alt"></i>

                                    <%=productLocation%>

                                </div>


                            </div>


                        </div>



                        <!-- ORIGINAL PRICE -->

                        <div class="summary-row">


                            <span>

                                Original Price

                            </span>


                            <strong>

                                ₹<%=String.format("%.2f", actualPrice)%>

                            </strong>


                        </div>



                        <!-- SELLING PRICE -->

                        <div class="summary-row">


                            <span>

                                Selling Price

                            </span>


                            <strong>

                                ₹<%=String.format("%.2f", sellingPrice)%>

                            </strong>


                        </div>



                        <!-- DELIVERY -->

                        <div class="summary-row">


                            <span>

                                Delivery

                            </span>


                            <strong class="free-text">

                                FREE

                            </strong>


                        </div>



                        <div class="summary-divider"></div>



                        <!-- TOTAL -->

                        <div class="summary-total">


                            <span class="summary-total-label">

                                Grand Total

                            </span>


                            <span class="summary-total-price">

                                ₹<%=String.format("%.2f", sellingPrice)%>

                            </span>


                        </div>



                        <!-- BUTTON -->

                        <button
                            type="submit"
                            class="checkout-button">


                            Proceed to Payment

                            <i class="bi bi-arrow-right ms-1"></i>


                        </button>



                        <!-- SECURITY -->

                        <div class="secure-checkout">


                            <i class="bi bi-shield-lock-fill"></i>


                            <span>

                                100% Secure Checkout

                            </span>


                        </div>



                        <!-- BUYER PROTECTION -->

                        <div class="protection-box">


                            <div class="protection-title">


                                <i class="bi bi-shield-check"></i>


                                RentEasy Buyer Protection


                            </div>


                            <p class="protection-text">

                                Your purchase is tracked through RentEasy.
                                Owner payout is handled through the platform
                                after the required purchase process is
                                completed.

                            </p>


                        </div>


                    </div>

                </div>

            </div>


        </div>

    </form>

</div>


<script>

/* =========================================================
   PAYMENT METHOD SELECTION UI
   ========================================================= */

document.querySelectorAll(".payment-method").forEach(function(method) {

    method.addEventListener("click", function() {

        document.querySelectorAll(".payment-method")
            .forEach(function(item) {

                item.style.borderColor = "#dce2eb";
                item.style.background = "#ffffff";

            });


        this.style.borderColor = "#0d6efd";
        this.style.background = "#f8faff";

    });

});

</script>


</body>

</html>