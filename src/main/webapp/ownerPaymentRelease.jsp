<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.renteasy.model.PaymentReport"%>

<%

// =====================================================
// LOAD PAYMENT DATA
// =====================================================

PaymentReport payment =
(PaymentReport)request.getAttribute("payment");

DecimalFormat df = new DecimalFormat("#,##0.00");

if(payment==null){

response.sendRedirect("AdminPaymentsServlet");
return;

}

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Release Owner Payment | RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">

<style>

/*==================================================
GENERAL
==================================================*/

body{

background:#f5f7fb;

font-family:'Segoe UI',sans-serif;

}

/*==================================================
PAGE TITLE
==================================================*/

.page-title{

font-size:28px;

font-weight:700;

color:#1f2937;

}

/*==================================================
CARDS
==================================================*/

.info-card{

background:white;

border-radius:15px;

padding:25px;

margin-bottom:25px;

box-shadow:0 3px 15px rgba(0,0,0,.08);

}

.info-title{

font-size:18px;

font-weight:600;

margin-bottom:20px;

color:#2563eb;

}

/*==================================================
SUMMARY CARDS
==================================================*/

.summary{

border-radius:18px;

padding:25px;

color:white;

margin-bottom:25px;

}

.summary h3{

font-size:30px;

font-weight:bold;

margin-top:10px;

}

.bg-blue{

background:#2563eb;

}

.bg-green{

background:#16a34a;

}

.bg-orange{

background:#ea580c;

}

.bg-red{

background:#dc2626;

}

.label{

font-weight:600;

color:#555;

}

.value{

font-weight:600;

font-size:17px;

}

</style>

</head>

<body>

<jsp:include page="adminLayout.jsp"/>

<div class="container-fluid mt-4">

<div class="d-flex
justify-content-between
align-items-center
mb-4">

<div>

<h2 class="page-title">

Release Owner Payment

</h2>

<p class="text-muted">

Review payment details before transferring money.

</p>

</div>

<a href="AdminPaymentsServlet"
class="btn btn-secondary">

<i class="bi bi-arrow-left"></i>

Back

</a>

</div>

<div class="row">

<div class="col-md-3">

<div class="summary bg-blue">

Payment

<h3>

₹ <%=df.format(payment.getTotalAmount())%>

</h3>

</div>

</div>

<div class="col-md-3">

<div class="summary bg-green">

Owner Share

<h3>

₹ <%=df.format(payment.getOwnerAmount())%>

</h3>

</div>

</div>

<div class="col-md-3">

<div class="summary bg-orange">

Commission

<h3>

₹ <%=df.format(payment.getCommissionAmount())%>

</h3>

</div>

</div>

<div class="col-md-3">

<div class="summary bg-red">

Deposit

<h3>

₹ <%=df.format(payment.getDepositAmount())%>

</h3>

</div>

</div>

</div>
<!-- ===================================================== -->
<!-- OWNER INFORMATION -->
<!-- ===================================================== -->

<div class="row">

    <div class="col-lg-6">

        <div class="info-card">

            <div class="info-title">

                <i class="bi bi-person-circle"></i>

                Owner Information

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Owner Name
                </div>

                <div class="col-7 value">
                    <%=payment.getOwnerName()%>
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Owner ID
                </div>

                <div class="col-7 value">
                    #<%=payment.getOwnerId()%>
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Payment Status
                </div>

                <div class="col-7">

                    <span class="badge bg-success">

                        <%=payment.getPaymentStatus()%>

                    </span>

                </div>

            </div>

            <div class="row">

                <div class="col-5 label">
                    Payment Date
                </div>

                <div class="col-7 value">
                    <%=payment.getPaymentDate()%>
                </div>

            </div>

        </div>

    </div>



<!-- ===================================================== -->
<!-- PRODUCT INFORMATION -->
<!-- ===================================================== -->

    <div class="col-lg-6">

        <div class="info-card">

            <div class="info-title">

                <i class="bi bi-box-seam"></i>

                Product Information

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Product
                </div>

                <div class="col-7 value">
                    <%=payment.getProductName()%>
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Rental ID
                </div>

                <div class="col-7 value">
                    #<%=payment.getRentalId()%>
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Customer
                </div>

                <div class="col-7 value">
                    <%=payment.getCustomerName()%>
                </div>

            </div>

            <div class="row">

                <div class="col-5 label">
                    Payment ID
                </div>

                <div class="col-7 value">
                    #<%=payment.getPaymentId()%>
                </div>

            </div>

        </div>

    </div>

</div>



<!-- ===================================================== -->
<!-- PAYMENT BREAKDOWN -->
<!-- ===================================================== -->

<div class="info-card">

    <div class="info-title">

        <i class="bi bi-wallet2"></i>

        Payment Breakdown

    </div>

    <table class="table table-bordered align-middle">

        <tr>

            <th width="40%">
                Rental Amount
            </th>

            <td>

                ₹ <%=df.format(payment.getRentAmount())%>

            </td>

        </tr>

        <tr>

            <th>

                Security Deposit

            </th>

            <td>

                ₹ <%=df.format(payment.getDepositAmount())%>

            </td>

        </tr>

        <tr>

            <th>

                Platform Commission

            </th>

            <td class="text-danger fw-bold">

                ₹ <%=df.format(payment.getCommissionAmount())%>

            </td>

        </tr>

        <tr>

            <th>

                Damage Deduction

            </th>

            <td>

                ₹ <%=df.format(payment.getDeductionAmount())%>

            </td>

        </tr>

        <tr>

            <th>

                Owner Compensation

            </th>

            <td>

                ₹ <%=df.format(payment.getOwnerCompensation())%>

            </td>

        </tr>

        <tr class="table-success">

            <th>

                Final Owner Payout

            </th>

            <td class="fw-bold fs-5">

                ₹ <%=df.format(payment.getOwnerAmount()
                    + payment.getOwnerCompensation())%>

            </td>

        </tr>

    </table>

</div>
<!-- ===================================================== -->
<!-- BANK DETAILS & PAYMENT RELEASE -->
<!-- ===================================================== -->

<div class="row">

    <!-- ===================================================== -->
    <!-- BANK DETAILS -->
    <!-- ===================================================== -->

    <div class="col-lg-6">

        <div class="info-card">

            <div class="info-title">

                <i class="bi bi-bank"></i>

                Bank Details

            </div>

            <div class="alert alert-warning">

                <i class="bi bi-info-circle"></i>

                Owner bank details will appear here after KYC Bank
                Verification is completed.

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Bank Name
                </div>

                <div class="col-7 value">
                    ICICI Bank
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Account Holder
                </div>

                <div class="col-7 value">
                    <%=payment.getOwnerName()%>
                </div>

            </div>

            <div class="row mb-3">

                <div class="col-5 label">
                    Account Number
                </div>

                <div class="col-7 value">
                    ********4521
                </div>

            </div>

            <div class="row">

                <div class="col-5 label">
                    IFSC
                </div>

                <div class="col-7 value">
                    ICIC0001234
                </div>

            </div>

        </div>

    </div>



    <!-- ===================================================== -->
    <!-- CONFIRM RELEASE -->
    <!-- ===================================================== -->

    <div class="col-lg-6">

        <div class="info-card">

            <div class="info-title">

                <i class="bi bi-cash-stack"></i>

                Confirm Owner Payment

            </div>

            <form action="CompleteOwnerPaymentServlet"
                  method="post">

                <input type="hidden"
                       name="paymentId"
                       value="<%=payment.getPaymentId()%>">

                <input type="hidden"
                       name="ownerId"
                       value="<%=payment.getOwnerId()%>">

                <div class="mb-3">

                    <label class="form-label">

                        Transaction Reference

                    </label>

                    <input
                        type="text"
                        class="form-control"
                        name="transactionReference"
                        placeholder="Enter UTR / Bank Reference"
                        required>

                </div>

                <div class="mb-4">

                    <label class="form-label">

                        Remarks

                    </label>

                    <textarea
                        class="form-control"
                        name="remarks"
                        rows="4"
                        placeholder="Optional remarks..."></textarea>

                </div>

                <div class="alert alert-success">

                    <h5>

                        Final Amount to Transfer

                    </h5>

                    <h2>

                        ₹ <%=df.format(payment.getOwnerAmount()
                        + payment.getOwnerCompensation())%>

                    </h2>

                </div>

                <div class="d-flex justify-content-between">

                    <a href="AdminPaymentsServlet"
                       class="btn btn-secondary">

                        Cancel

                    </a>

                    <button
                        type="submit"
                        class="btn btn-success">

                        <i class="bi bi-send-check"></i>

                        Confirm Release

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>