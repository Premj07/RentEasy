<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.renteasy.model.OwnerRental" %>

<%
if (session.getAttribute("email") == null) {
    response.sendRedirect("index.jsp");
    return;
}

List<OwnerRental> rentals =
        (List<OwnerRental>) request.getAttribute("rentals");

int totalRentals = 0;
int activeRentals = 0;
int returnRequests = 0;
int completedReturns = 0;

if (rentals != null) {

    totalRentals = rentals.size();

    for (OwnerRental r : rentals) {

        String pickup = r.getPickupStatus();
        String rentalStatus = r.getRentalStatus();
        String refundStatus = r.getRefundStatus();

        boolean pickupCompleted =
                "COMPLETED".equalsIgnoreCase(pickup) ||
                "PICKED_UP".equalsIgnoreCase(pickup);

        boolean returnApproved =
                "RETURN_APPROVED".equalsIgnoreCase(rentalStatus);

        boolean returnVerified =
                "RETURN_VERIFIED".equalsIgnoreCase(
                        rentalStatus
                )
                ||
                "RETURNED".equalsIgnoreCase(
                        rentalStatus
                );

        if (pickupCompleted && !returnApproved && !returnVerified) {
            activeRentals++;
        }

        if (returnApproved && !returnVerified) {
            returnRequests++;
        }

        if (returnVerified) {
            completedReturns++;
        }
    }
}
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Rental Management - RentEasy</title>

<!-- EXISTING RENT EASY NAVBAR -->
<link rel="stylesheet"
      href="css/navbar.css">

<!-- OWNER DASHBOARD CSS -->
<link rel="stylesheet"
      href="css/owner-dashboard.css">

<!-- BOOTSTRAP -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<!-- BOOTSTRAP ICONS -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

/* =========================================================
   PAGE
========================================================= */

body {
    margin: 0;
    background: #f5f7fb;
    color: #0f172a;
    font-family: Inter, Arial, sans-serif;
}

.rental-page {
    margin-left: 270px;
    padding: 105px 32px 50px;
    min-height: 100vh;
}

.rental-container {
    max-width: 1500px;
    margin: auto;
}


/* =========================================================
   HEADER
========================================================= */

.rental-page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 26px;
}

.page-title-area h1 {
    font-size: 30px;
    font-weight: 750;
    margin: 0 0 7px;
    letter-spacing: -0.5px;
}

.page-title-area p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.back-dashboard {
    height: 44px;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 0 17px;
    background: white;
    border: 1px solid #dbe2ea;
    border-radius: 10px;
    text-decoration: none;
    color: #334155;
    font-weight: 600;
    font-size: 14px;
    transition: .2s;
}

.back-dashboard:hover {
    border-color: #2563eb;
    color: #2563eb;
}


/* =========================================================
   SUMMARY CARDS
========================================================= */

.rental-summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
    margin-bottom: 28px;
}

.rental-summary-card {
    background: white;
    border: 1px solid #e7ebf0;
    border-radius: 16px;
    padding: 22px;
    display: flex;
    align-items: center;
    gap: 16px;
    box-shadow: 0 3px 12px rgba(15,23,42,.035);
}

.summary-icon {
    width: 52px;
    height: 52px;
    border-radius: 13px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
}

.summary-icon.blue {
    background: #eff6ff;
    color: #2563eb;
}

.summary-icon.green {
    background: #ecfdf5;
    color: #059669;
}

.summary-icon.orange {
    background: #fff7ed;
    color: #ea580c;
}

.summary-icon.purple {
    background: #f5f3ff;
    color: #7c3aed;
}

.summary-info span {
    display: block;
    font-size: 13px;
    color: #64748b;
    margin-bottom: 3px;
}

.summary-info strong {
    font-size: 26px;
    font-weight: 750;
    color: #0f172a;
}


/* =========================================================
   RENTAL CARD
========================================================= */

.rental-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 18px;
    margin-bottom: 22px;
    overflow: hidden;
    box-shadow: 0 5px 18px rgba(15,23,42,.045);
}

.rental-card-top {
    padding: 24px 26px;
    border-bottom: 1px solid #edf0f4;
}

.rental-main-grid {
    display: grid;
    grid-template-columns: 120px minmax(300px, 1fr) 390px;
    gap: 26px;
    align-items: start;
}


/* =========================================================
   PRODUCT IMAGE
========================================================= */

.product-image-wrapper {
    width: 120px;
    height: 120px;
    border-radius: 14px;
    overflow: hidden;
    border: 1px solid #e5e7eb;
    background: #f8fafc;
}

.product-image-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}


/* =========================================================
   RENTAL DETAILS
========================================================= */

.rental-id {
    font-size: 12px;
    color: #2563eb;
    font-weight: 700;
    margin-bottom: 5px;
}

.rental-product-name {
    font-size: 22px;
    font-weight: 750;
    margin: 0 0 15px;
}

.customer-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(160px, 1fr));
    gap: 14px 24px;
}

.detail-item {
    display: flex;
    gap: 10px;
    align-items: flex-start;
}

.detail-icon {
    color: #64748b;
    font-size: 16px;
    margin-top: 2px;
}

.detail-content span {
    display: block;
    color: #94a3b8;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: .5px;
    font-weight: 650;
    margin-bottom: 2px;
}

.detail-content strong {
    display: block;
    font-size: 14px;
    color: #334155;
    font-weight: 600;
    word-break: break-word;
}


/* =========================================================
   STATUS PANEL
========================================================= */

.stage-panel {
    padding: 20px;
    border-radius: 14px;
    min-height: 145px;
}

.stage-panel h5 {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 7px;
}

.stage-panel p {
    font-size: 13px;
    line-height: 1.6;
    margin-bottom: 0;
}

.stage-pickup {
    background: #eff6ff;
    border: 1px solid #bfdbfe;
}

.stage-pickup h5 {
    color: #1d4ed8;
}

.stage-active {
    background: #ecfdf5;
    border: 1px solid #bbf7d0;
}

.stage-active h5 {
    color: #15803d;
}

.stage-return {
    background: #fff7ed;
    border: 1px solid #fed7aa;
}

.stage-return h5 {
    color: #c2410c;
}

.stage-complete {
    background: #ecfdf5;
    border: 1px solid #bbf7d0;
}

.stage-complete h5 {
    color: #15803d;
}

.stage-panel .form-control {
    height: 44px;
    border-radius: 9px;
    font-size: 14px;
}

.stage-panel .btn {
    min-height: 43px;
    border-radius: 9px;
    font-weight: 650;
    font-size: 14px;
}


/* =========================================================
   STATUS BADGES
========================================================= */

.rental-status-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 18px;
}

.status-badge {
    padding: 6px 10px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
}

.badge-blue {
    background: #eff6ff;
    color: #2563eb;
}

.badge-green {
    background: #ecfdf5;
    color: #15803d;
}

.badge-orange {
    background: #fff7ed;
    color: #c2410c;
}

.badge-gray {
    background: #f1f5f9;
    color: #475569;
}


/* =========================================================
   INSPECTION
========================================================= */

.inspection-section {
    padding: 24px 26px;
    background: #fbfcfe;
}

.inspection-heading {
    display: flex;
    align-items: flex-start;
    gap: 13px;
    margin-bottom: 20px;
}

.inspection-icon {
    width: 42px;
    height: 42px;
    background: #eff6ff;
    color: #2563eb;
    border-radius: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 19px;
}

.inspection-heading h4 {
    font-size: 18px;
    font-weight: 700;
    margin: 0 0 4px;
}

.inspection-heading p {
    margin: 0;
    color: #64748b;
    font-size: 13px;
}

.inspection-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}

.inspection-option {
    background: white;
    border-radius: 13px;
    padding: 20px;
}

.inspection-option.ok {
    border: 1px solid #bbf7d0;
}

.inspection-option.damage {
    border: 1px solid #fecaca;
}

.inspection-option h5 {
    font-size: 16px;
    font-weight: 700;
}

.inspection-option.ok h5 {
    color: #15803d;
}

.inspection-option.damage h5 {
    color: #dc2626;
}

.inspection-option p {
    font-size: 13px;
    color: #64748b;
    line-height: 1.6;
}

.inspection-option .btn {
    border-radius: 9px;
    font-weight: 650;
}


/* =========================================================
   COMPLETED INSPECTION
========================================================= */

.inspection-result {
    padding: 17px 19px;
    border-radius: 11px;
    font-size: 14px;
    line-height: 1.6;
}

.inspection-result.success {
    background: #ecfdf5;
    border: 1px solid #bbf7d0;
    color: #166534;
}

.inspection-result.warning {
    background: #fffbeb;
    border: 1px solid #fde68a;
    color: #92400e;
}


/* =========================================================
   EMPTY STATE
========================================================= */

.empty-rentals {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 18px;
    padding: 65px 30px;
    text-align: center;
}

.empty-icon {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    background: #eff6ff;
    color: #2563eb;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
    margin: 0 auto 18px;
}

.empty-rentals h3 {
    font-size: 20px;
    font-weight: 700;
}

.empty-rentals p {
    color: #64748b;
}


/* =========================================================
   MESSAGE
========================================================= */

.owner-message {
    border-radius: 11px;
    padding: 14px 17px;
    margin-bottom: 20px;
    font-size: 14px;
}

.owner-message.success {
    background: #ecfdf5;
    border: 1px solid #bbf7d0;
    color: #166534;
}

.owner-message.error {
    background: #fef2f2;
    border: 1px solid #fecaca;
    color: #991b1b;
}


/* =========================================================
   RESPONSIVE
========================================================= */

@media(max-width: 1200px) {

    .rental-main-grid {
        grid-template-columns: 100px 1fr;
    }

    .rental-main-grid > .stage-panel {
        grid-column: 1 / -1;
    }

    .rental-summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media(max-width: 768px) {

    .rental-page {
        margin-left: 0;
        padding: 95px 15px 30px;
    }

    .rental-page-header {
        align-items: flex-start;
        flex-direction: column;
    }

    .rental-summary-grid {
        grid-template-columns: 1fr;
    }

    .rental-main-grid {
        grid-template-columns: 1fr;
    }

    .product-image-wrapper {
        width: 100%;
        height: 220px;
    }

    .customer-grid {
        grid-template-columns: 1fr;
    }

    .inspection-grid {
        grid-template-columns: 1fr;
    }
   }
/*/* ==========================================
   RETURNED PRODUCT INSPECTION
   ========================================== */

.returned-inspection-panel {
    width: 100%;
    box-sizing: border-box;
    padding: 28px 26px;
    background: #fbfcfe;
    border-top: 1px solid #edf0f4;
}


/* HEADER */

.returned-inspection-header {
    width: 100%;
    margin-bottom: 24px;
}

.inspection-title-row {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    width: 100%;
}

.inspection-title-row .inspection-icon {
    flex: 0 0 42px;
    width: 42px;
    height: 42px;
    border-radius: 11px;
    background: #eff6ff;
    color: #2563eb;

    display: flex;
    align-items: center;
    justify-content: center;

    font-size: 19px;
}

.inspection-title-row h3 {
    margin: 0 0 6px 0;
    font-size: 22px;
    font-weight: 700;
    color: #0f172a;
}

.inspection-title-row p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
    line-height: 1.6;
    max-width: 700px;
}


/* INSPECTION OPTIONS */

.inspection-options-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
    width: 100%;
}


/* CARDS */

.inspection-card {
    width: 100%;
    min-width: 0;
    box-sizing: border-box;

    padding: 24px;
    border-radius: 14px;
    background: #ffffff;
}

.inspection-good {
    border: 1px solid #bbf7d0;
    background: #f0fdf4;
}

.inspection-damage {
    border: 1px solid #fecaca;
    background: #fff7f7;
}


/* CARD ICON */

.inspection-card-icon {
    width: 42px;
    height: 42px;
    border-radius: 10px;

    display: flex;
    align-items: center;
    justify-content: center;

    margin-bottom: 14px;
    font-size: 18px;
}

.inspection-good .inspection-card-icon {
    background: #dcfce7;
    color: #15803d;
}

.inspection-damage .inspection-card-icon {
    background: #fee2e2;
    color: #dc2626;
}


/* CARD TEXT */

.inspection-card h4 {
    margin: 0 0 10px 0;
    font-size: 18px;
    font-weight: 700;
}

.inspection-good h4 {
    color: #15803d;
}

.inspection-damage h4 {
    color: #dc2626;
}

.inspection-card p {
    margin: 0 0 20px 0;
    color: #64748b;
    font-size: 14px;
    line-height: 1.6;
}


/* BUTTONS */

.inspection-btn {
    width: 100%;
    min-height: 48px;

    border-radius: 9px;
    border: none;

    font-size: 14px;
    font-weight: 650;

    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    cursor: pointer;
}

.inspection-btn-good {
    background: #15803d;
    color: white;
}

.inspection-btn-good:hover {
    background: #166534;
}

.inspection-btn-damage {
    background: white;
    color: #dc2626;
    border: 1px solid #ef4444;
}

.inspection-btn-damage:hover {
    background: #fef2f2;
}

.inspection-btn-submit {
    background: #2563eb;
    color: white;
}

.inspection-btn-submit:hover {
    background: #1d4ed8;
}


/* DAMAGE FORM */

.damage-field {
    margin-bottom: 16px;
}

.damage-field label {
    display: block;
    margin-bottom: 6px;

    font-size: 13px;
    font-weight: 650;
    color: #334155;
}

.damage-field .form-control {
    width: 100%;
    border-radius: 9px;
}

.damage-field small {
    display: block;
    margin-top: 6px;

    color: #64748b;
    font-size: 12px;
}


/* COMPLETED INSPECTION */

.inspection-result {
    display: flex;
    align-items: flex-start;
    gap: 14px;

    width: 100%;
    box-sizing: border-box;

    padding: 20px;
    border-radius: 12px;
}

.inspection-result h4 {
    margin: 0 0 6px 0;
    font-size: 18px;
    font-weight: 700;
}

.inspection-result p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
}

.inspection-result-good {
    background: #ecfdf5;
    border: 1px solid #bbf7d0;
    color: #166534;
}

.inspection-result-damage {
    background: #fffbeb;
    border: 1px solid #fde68a;
    color: #92400e;
}


/* RESPONSIVE */

@media (max-width: 900px) {

    .inspection-options-grid {
        grid-template-columns: 1fr;
    }

}

@media (max-width: 768px) {

	.rental-main-grid > .returned-inspection-panel {
    grid-column: 1 / -1 !important;
}

.rental-main-grid > .returned-inspection-panel .inspection-options-grid {
    grid-template-columns: 1fr !important;
}

    .returned-inspection-panel {
        padding: 22px 16px;
    }

    .inspection-title-row h3 {
        font-size: 19px;
    }

    .inspection-options-grid {
        grid-template-columns: 1fr;
    }

    .inspection-card {
        padding: 20px;
    }
    /* ==========================================
   FIX RETURNED INSPECTION WIDTH
   ========================================== */

/* Make inspection section use the full rental card width */
.rental-main-grid > .returned-inspection-panel {
    grid-column: 1 / -1 !important;
    width: 100% !important;
    max-width: none !important;
    box-sizing: border-box;
    display: block !important;
}
.rental-main-grid > .returned-inspection-panel .inspection-options-grid {
    width: 100% !important;
    display: grid !important;
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    gap: 20px !important;
}

.rental-main-grid > .returned-inspection-panel .inspection-card {
    width: 100% !important;
    min-width: 0 !important;
    box-sizing: border-box;
}

/* Inspection heading must use full width */
.rental-card .returned-inspection-header {
    width: 100% !important;
    max-width: none !important;
}

/* Keep the two inspection cards properly sized */
.rental-card .inspection-options-grid {
    width: 100% !important;
    max-width: none !important;
    display: grid !important;
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    gap: 20px !important;
}

/* Cards must be allowed to grow */
.rental-card .inspection-card {
    width: 100% !important;
    min-width: 0 !important;
    box-sizing: border-box;
}

/* Don't let text become a single narrow column */
.rental-card .inspection-card h4,
.rental-card .inspection-card p {
    width: auto !important;
    max-width: none !important;
}

/* Buttons should have proper width */
.rental-card .inspection-btn {
    width: 100% !important;
    box-sizing: border-box;
}

}

</style>

</head>

<body>


<!-- =====================================================
     SAME RENT EASY NAVBAR
===================================================== -->

<jsp:include page="includes/navbar.jsp"/>


<!-- =====================================================
     SAME OWNER SIDEBAR
===================================================== -->

<jsp:include page="includes/owner-sidebar.jsp"/>


<!-- =====================================================
     MAIN PAGE
===================================================== -->

<main class="rental-page">

<div class="rental-container">


<!-- =====================================================
     HEADER
===================================================== -->

<div class="rental-page-header">

    <div class="page-title-area">

        <h1>
            Rental Management
        </h1>

        <p>
            Track customer rentals, pickup verification,
            returns and product inspections.
        </p>

    </div>


    <a href="ownerDashboard.jsp"
       class="back-dashboard">

        <i class="bi bi-arrow-left"></i>

        Dashboard

    </a>

</div>


<!-- =====================================================
     MESSAGES
===================================================== -->

<%
String success = request.getParameter("success");
String error = request.getParameter("error");

if ("pickupverified".equals(success)) {
%>

<div class="owner-message success">

    <i class="bi bi-check-circle-fill"></i>

    Pickup OTP verified successfully.

</div>

<%
}

if ("invalidotp".equals(error)) {
%>

<div class="owner-message error">

    <i class="bi bi-exclamation-circle-fill"></i>

    Invalid Pickup OTP. Please enter the correct OTP.

</div>

<%
}
%>


<!-- =====================================================
     SUMMARY
===================================================== -->

<div class="rental-summary-grid">


    <div class="rental-summary-card">

        <div class="summary-icon blue">
            <i class="bi bi-receipt"></i>
        </div>

        <div class="summary-info">

            <span>
                Total Rentals
            </span>

            <strong>
                <%=totalRentals%>
            </strong>

        </div>

    </div>


    <div class="rental-summary-card">

        <div class="summary-icon green">
            <i class="bi bi-arrow-repeat"></i>
        </div>

        <div class="summary-info">

            <span>
                Active Rentals
            </span>

            <strong>
                <%=activeRentals%>
            </strong>

        </div>

    </div>


    <div class="rental-summary-card">

        <div class="summary-icon orange">
            <i class="bi bi-box-arrow-in-left"></i>
        </div>

        <div class="summary-info">

            <span>
                Return Requests
            </span>

            <strong>
                <%=returnRequests%>
            </strong>

        </div>

    </div>


    <div class="rental-summary-card">

        <div class="summary-icon purple">
            <i class="bi bi-check2-circle"></i>
        </div>

        <div class="summary-info">

            <span>
                Returned
            </span>

            <strong>
                <%=completedReturns%>
            </strong>

        </div>

    </div>


</div>


<!-- =====================================================
     RENTALS
===================================================== -->

<%

if (rentals == null || rentals.isEmpty()) {

%>


<div class="empty-rentals">

    <div class="empty-icon">

        <i class="bi bi-box-seam"></i>

    </div>

    <h3>
        No rental records yet
    </h3>

    <p>
        Customer rental requests will appear here
        when one of your products is rented.
    </p>

</div>


<%

} else {

for (OwnerRental rental : rentals) {


String pickupStatus =
        rental.getPickupStatus();

String rentalStatus =
        rental.getRentalStatus();

String refundStatus =
        rental.getRefundStatus();

String inspectionStatus =
        rental.getInspectionStatus();


boolean pickupCompleted =
        "COMPLETED".equalsIgnoreCase(pickupStatus)
        ||
        "PICKED_UP".equalsIgnoreCase(pickupStatus);


boolean returnApproved =
        "RETURN_APPROVED".equalsIgnoreCase(
                rentalStatus
        );


boolean returnVerified =
        "RETURN_VERIFIED".equalsIgnoreCase(
                refundStatus
        )
        ||
        "RETURN_VERIFIED".equalsIgnoreCase(
                rentalStatus
        )
        ||
        "RETURNED".equalsIgnoreCase(
                rentalStatus
        );


String productImage =
        rental.getProductImage();

%>


<div class="rental-card">


<!-- =================================================
     MAIN INFORMATION
================================================= -->

<div class="rental-card-top">

<div class="rental-main-grid">


<!-- PRODUCT IMAGE -->

<div class="product-image-wrapper">

<%

if (productImage != null &&
    !productImage.trim().isEmpty()) {

%>

<img
src="<%=request.getContextPath()%>/<%=productImage%>"
alt="<%=rental.getProductName()%>"
onerror="this.src='images/no-product.png';">

<%

} else {

%>

<div style="
height:100%;
display:flex;
align-items:center;
justify-content:center;
font-size:35px;
color:#94a3b8;
">

<i class="bi bi-image"></i>

</div>

<%
}
%>

</div>


<!-- =================================================
     CUSTOMER INFORMATION
================================================= -->

<div>

<div class="rental-id">

Rental #<%=rental.getRentalId()%>

</div>


<h3 class="rental-product-name">

<%=rental.getProductName()%>

</h3>


<div class="customer-grid">


<div class="detail-item">

    <i class="bi bi-person detail-icon"></i>

    <div class="detail-content">

        <span>
            Customer
        </span>

        <strong>
            <%=rental.getCustomerName()%>
        </strong>

    </div>

</div>


<div class="detail-item">

    <i class="bi bi-envelope detail-icon"></i>

    <div class="detail-content">

        <span>
            Email
        </span>

        <strong>
            <%=rental.getCustomerEmail()%>
        </strong>

    </div>

</div>


<div class="detail-item">

    <i class="bi bi-telephone detail-icon"></i>

    <div class="detail-content">

        <span>
            Phone
        </span>

        <strong>
            <%=rental.getCustomerPhone()%>
        </strong>

    </div>

</div>


<div class="detail-item">

    <i class="bi bi-calendar3 detail-icon"></i>

    <div class="detail-content">

        <span>
            Rental Period
        </span>

        <strong>

            <%=rental.getStartDate()%>

            &nbsp;→&nbsp;

            <%=rental.getEndDate()%>

        </strong>

    </div>

</div>


<div class="detail-item">

    <i class="bi bi-currency-rupee detail-icon"></i>

    <div class="detail-content">

        <span>
            Rent Amount
        </span>

        <strong>

            ₹<%=String.format("%.2f",
                    rental.getRentAmount())%>

        </strong>

    </div>

</div>


</div>


<!-- STATUS -->

<div class="rental-status-row">


<span class="status-badge
<%=pickupCompleted ?
"badge-green" :
"badge-gray"%>">

Pickup:
<%=pickupStatus == null ?
"Pending" :
pickupStatus%>

</span>


<%

if (rentalStatus != null) {

%>

<span class="status-badge badge-blue">

Rental:
<%=rentalStatus%>

</span>

<%

}

%>


<%

if (refundStatus != null) {

%>

<span class="status-badge badge-orange">

Refund:
<%=refundStatus%>

</span>

<%

}

%>


</div>

</div>


<!-- =================================================
     RENTAL STAGE
================================================= -->

<%

if (!pickupCompleted) {

%>

<!-- ================= PICKUP VERIFICATION ================= -->

<div class="stage-panel stage-pickup">

    <div class="mb-2">
        <span class="status-badge badge-blue">
            PICKUP VERIFICATION
        </span>
    </div>

    <h4>Pickup Verification</h4>

    <p>
        Enter the OTP provided by the customer
        when handing over the product.
    </p>

    <form action="VerifyPickupOtpServlet" method="post">

        <input type="hidden"
               name="rentalId"
               value="<%=rental.getRentalId()%>">

        <input type="text"
               name="pickupOtp"
               class="form-control"
               maxlength="6"
               inputmode="numeric"
               pattern="[0-9]{6}"
               placeholder="Enter 6-digit Pickup OTP"
               required>

        <button type="submit"
                class="btn btn-primary w-100 mt-3">

            <i class="bi bi-shield-check"></i>
            Verify Pickup OTP

        </button>

    </form>

</div>

<%

}

else if (
    pickupCompleted &&
    !returnApproved &&
    !returnVerified
) {

%>

<!-- ================= PRODUCT WITH RENTER ================= -->

<div class="stage-panel stage-active">

    <div class="mb-2">
        <span class="status-badge badge-green">
            PICKUP COMPLETED
        </span>
    </div>

    <h4>Pickup Completed</h4>

    <p>
        Pickup verification was completed successfully.
    </p>

    <p>
        The product is currently with the renter.
    </p>

</div>

<%

}

else if (
    returnApproved &&
    !returnVerified
) {

%>

<!-- ================= RETURN VERIFICATION ================= -->

<div class="stage-panel stage-return">

    <div class="mb-2">
        <span class="status-badge badge-orange">
            RETURN APPROVED
        </span>
    </div>

    <h4>Return Verification</h4>

    <p>
        The return request has been approved.
    </p>

    <p>
        Meet the renter and receive the product.
        Enter the Return OTP provided by the renter.
    </p>

    <form action="VerifyReturnOtpServlet" method="post">

        <input type="hidden"
               name="rentalId"
               value="<%=rental.getRentalId()%>">

        <input type="text"
               name="returnOtp"
               class="form-control"
               maxlength="6"
               inputmode="numeric"
               pattern="[0-9]{6}"
               placeholder="Enter 6-digit Return OTP"
               required>

        <button type="submit"
                class="btn btn-warning w-100 mt-3">

            <i class="bi bi-check-circle"></i>
            Verify Return OTP

        </button>

    </form>

</div>

<%

}

else if (returnVerified) {

%>

<!-- ================= PRODUCT RETURNED ================= -->

<div class="stage-panel stage-return">

    <div class="mb-2">
        <span class="status-badge badge-green">
            PRODUCT RETURNED
        </span>
    </div>

    <h4>Product Returned</h4>

    <p>
        Return OTP has been successfully verified.
    </p>

    <p>
        The product has been physically received
        from the renter.
    </p>

</div>

<%

}

%>
</div>

<!-- =====================================================
     RETURN INSPECTION
===================================================== -->

<%
if (returnVerified) {
%>

<div class="returned-inspection-panel">

    <!-- Inspection Header -->
    <div class="returned-inspection-header">

        <div class="inspection-title-row">
            <div class="inspection-icon">
                <i class="bi bi-search"></i>
            </div>

            <div>
                <h3>Returned Product Inspection</h3>

                <p>
                    Inspect the returned product before the security
                    deposit is processed.
                </p>
            </div>
        </div>

    </div>


    <%
    if (inspectionStatus == null ||
        "PENDING".equalsIgnoreCase(inspectionStatus)) {
    %>

    <!-- INSPECTION OPTIONS -->

    <div class="inspection-options-grid">

        <!-- NO DAMAGE -->
        <div class="inspection-card inspection-good">

            <div class="inspection-card-icon">
                <i class="bi bi-check-circle-fill"></i>
            </div>

            <h4>Product in Good Condition</h4>

            <p>
                Select this option if the product was returned
                in acceptable condition and no deduction is required.
            </p>

            <form action="ConfirmNoDamageServlet" method="post">

                <input type="hidden"
                       name="rentalId"
                       value="<%=rental.getRentalId()%>">

                <button type="submit"
                        class="inspection-btn inspection-btn-good">

                    <i class="bi bi-check-lg"></i>
                    Confirm No Damage

                </button>

            </form>

        </div>


        <!-- DAMAGE -->
        <div class="inspection-card inspection-damage">

            <div class="inspection-card-icon">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>

            <h4>Damage Found</h4>

            <p>
                Report product damage and request a deduction.
                RentEasy admin will review the evidence before
                deciding the amount.
            </p>

            <button type="button"
                    class="inspection-btn inspection-btn-damage"
                    onclick="document.getElementById('damageForm_<%=rental.getRentalId()%>').style.display='block'; this.style.display='none';">

                <i class="bi bi-camera"></i>
                Report Damage

            </button>


            <!-- DAMAGE FORM -->

            <form id="damageForm_<%=rental.getRentalId()%>"
                  action="ReportDamageServlet"
                  method="post"
                  enctype="multipart/form-data"
                  style="display:none; margin-top:20px;">

                <input type="hidden"
                       name="rentalId"
                       value="<%=rental.getRentalId()%>">


                <div class="damage-field">

                    <label>
                        Damage Description
                    </label>

                    <textarea name="damageDescription"
                              class="form-control"
                              rows="4"
                              placeholder="Describe the damage found..."
                              required></textarea>

                </div>


                <div class="damage-field">

                    <label>
                        Requested Deduction
                    </label>

                    <input type="number"
                           name="requestedDeduction"
                           class="form-control"
                           min="0"
                           step="0.01"
                           placeholder="Enter deduction amount"
                           required>

                </div>


                <div class="damage-field">

                    <label>
                        Damage Evidence
                    </label>

                    <input type="file"
                           name="damageEvidence"
                           class="form-control"
                           accept="image/*"
                           required>

                    <small>
                        Upload a clear photograph showing the damaged area.
                    </small>

                </div>


                <button type="submit"
                        class="inspection-btn inspection-btn-submit">

                    <i class="bi bi-send"></i>
                    Submit Damage Report

                </button>

            </form>

        </div>

    </div>


    <%
    }

    else if ("NO_DAMAGE".equalsIgnoreCase(inspectionStatus)) {
    %>

    <!-- NO DAMAGE COMPLETED -->

    <div class="inspection-result inspection-result-good">

        <i class="bi bi-check-circle-fill"></i>

        <div>
            <h4>Inspection Completed</h4>

            <p>
                You confirmed that the product was returned without
                damage. The full security deposit has been forwarded
                for refund processing.
            </p>
        </div>

    </div>


    <%
    }

    else if (
        "DAMAGE_REPORTED".equalsIgnoreCase(inspectionStatus)
        ||
        "DAMAGED".equalsIgnoreCase(inspectionStatus)
    ) {
    %>

    <!-- DAMAGE SUBMITTED -->

    <div class="inspection-result inspection-result-damage">

        <i class="bi bi-exclamation-triangle-fill"></i>

        <div>
            <h4>Damage Report Submitted</h4>

            <p>
                Your damage claim has been sent to RentEasy admin
                for review. The admin will determine the final
                deduction before the security deposit is refunded.
            </p>
        </div>

    </div>

    <%
    }
    %>

</div>

<%
}
%>


</div>


<%

} // for

} // else

%>


</div>

</main>


<script
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>