<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.renteasy.model.OwnerPayout"%>
<%@ page import="com.renteasy.model.BankDetails"%>

<%

// =====================================================
// OWNER PAYMENT LIST
// =====================================================

List<OwnerPayout> payoutList =
(List<OwnerPayout>)request.getAttribute("payoutList");

//=====================================================
//OWNER BANK DETAILS
//=====================================================

BankDetails bankDetails =
(BankDetails)request.getAttribute("bankDetails");
DecimalFormat df=new DecimalFormat("#,##0.00");

// =====================================================
// DASHBOARD TOTALS
// =====================================================

double totalEarnings=0;

double pendingAmount=0;

double paidAmount=0;

double thisMonth=0;

if(payoutList!=null){

for(OwnerPayout p:payoutList){

totalEarnings+=p.getOwnerAmount();

if("Pending".equalsIgnoreCase(p.getPayoutStatus())){

pendingAmount+=p.getOwnerAmount();

}

if("Paid".equalsIgnoreCase(p.getPayoutStatus())){

paidAmount+=p.getOwnerAmount();

thisMonth+=p.getOwnerAmount();

}

}

}

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Owner Payments | RentEasy</title>

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<link
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">

<style>

/* =====================================================
GENERAL
===================================================== */

body{

background:#f5f7fb;

font-family:'Segoe UI',sans-serif;

}

/* =====================================================
SUMMARY CARDS
===================================================== */

.summary-card{

border-radius:18px;

padding:22px;

color:white;

box-shadow:0 5px 15px rgba(0,0,0,.12);

margin-bottom:25px;

}

.summary-card h2{

font-weight:bold;

margin-top:10px;

}

.bg1{

background:#2563eb;

}

.bg2{

background:#16a34a;

}

.bg3{

background:#ea580c;

}

.bg4{

background:#7c3aed;

}

/* =====================================================
TABLE
===================================================== */

.payment-card{

background:white;

border-radius:18px;

padding:25px;

box-shadow:0 4px 15px rgba(0,0,0,.08);

}

/* =====================================================
   PAYOUT BANK ACCOUNT - PAYMENT HISTORY STYLE
===================================================== */

.bank-card{
    background:#ffffff;
    border-radius:20px;
    padding:28px 30px;
    box-shadow:0 4px 18px rgba(0,0,0,0.06);
    margin-bottom:28px;
}

.bank-card-top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:20px;
}

.bank-title{
    font-size:22px;
    font-weight:700;
    color:#111827;
    margin-bottom:18px;
}

.bank-title i{
    margin-right:8px;
}

.bank-holder{
    font-size:18px;
    font-weight:700;
    color:#111827;
    margin-bottom:8px;
}

.bank-detail{
    font-size:16px;
    color:#64748b;
    margin-bottom:7px;
}

.bank-detail strong{
    color:#475569;
}

.bank-right{
    text-align:right;
    min-width:210px;
}

.bank-ready{
    color:#16a34a;
    font-size:15px;
    font-weight:600;
    margin-bottom:18px;
}

.bank-edit-btn{
    display:inline-block;
    padding:11px 18px;
    background:#f1f5f9;
    color:#2563eb;
    border-radius:10px;
    text-decoration:none;
    font-weight:500;
    transition:.2s;
}

.bank-edit-btn:hover{
    background:#e2e8f0;
    color:#1d4ed8;
}

@media(max-width:768px){

    .bank-card-top{
        flex-direction:column;
        align-items:flex-start;
    }

    .bank-right{
        text-align:left;
    }
}

</style>

</head>

<body>

<div class="container-fluid mt-4">

<div class="d-flex
justify-content-between
align-items-center
mb-4">

<div>

<h2>

Owner Payments

</h2>

<p class="text-muted">

Track all your earnings and payouts.

</p>

</div>

</div>

<div class="row">

<div class="col-md-3">

<div class="summary-card bg1">

Total Earnings

<h2>

₹ <%=df.format(totalEarnings)%>

</h2>

</div>

</div>

<div class="col-md-3">

<div class="summary-card bg2">

Pending Payout

<h2>

₹ <%=df.format(pendingAmount)%>

</h2>

</div>

</div>

<div class="col-md-3">

<div class="summary-card bg3">

Paid Amount

<h2>

₹ <%=df.format(paidAmount)%>

</h2>

</div>

</div>

<div class="col-md-3">

<div class="summary-card bg4">

This Month

<h2>

₹ <%=df.format(thisMonth)%>

</h2>

</div>

</div>

</div>

<!-- =====================================================
PAYOUT BANK ACCOUNT
===================================================== -->

<div class="bank-card">

<% if(bankDetails != null){ %>

    <div class="bank-card-top">

        <!-- LEFT SIDE -->
        <div>

            <div class="bank-title">
                <i class="bi bi-bank"></i>
                Payout Bank Account
            </div>

            <div class="bank-holder">
                <%= bankDetails.getAccountHolder() %>
            </div>

            <div class="bank-detail">
                <%= bankDetails.getBankName() %>
            </div>

            <div class="bank-detail">
                Account:
                <strong>
                    <%= bankDetails.getMaskedAccountNumber() %>
                </strong>
            </div>

            <div class="bank-detail">
                IFSC:
                <strong>
                    <%= bankDetails.getIfscCode() %>
                </strong>
            </div>

        </div>


        <!-- RIGHT SIDE -->
        <div class="bank-right">

            <div class="bank-ready">

                <i class="bi bi-check-circle-fill"></i>
                Ready for Payout

            </div>

            <a href="bankAccount.jsp?from=ownerPayments"
               class="bank-edit-btn">

                <i class="bi bi-pencil-square"></i>
                Edit Bank Details

            </a>

        </div>

    </div>


<% } else { %>

    <div class="bank-card-top">

        <div>

            <div class="bank-title">
                <i class="bi bi-bank"></i>
                Payout Bank Account
            </div>

            <div class="bank-detail">
                No bank account has been added yet.
            </div>

        </div>

        <div class="bank-right">

            <a href="bankAccount.jsp?from=ownerPayments"
               class="bank-edit-btn">

                <i class="bi bi-plus-circle"></i>
                Add Bank Details

            </a>

        </div>

    </div>

<% } %>

</div>
<!-- =====================================================
SEARCH & FILTER
===================================================== -->

<div class="payment-card mb-4">

    <div class="row">

        <div class="col-md-8">

            <input
                type="text"
                id="searchPayment"
                class="form-control"
                placeholder="Search by Product, Transaction Reference or Status">

        </div>

        <div class="col-md-4">

            <select id="statusFilter"
                    class="form-select">

                <option value="">All Payments</option>

                <option>Paid</option>

                <option>Pending</option>

                <option>Processing</option>

            </select>

        </div>

    </div>

</div>

<!-- =====================================================
PAYMENT HISTORY
===================================================== -->

<div class="payment-card">

    <h4 class="mb-4">

        <i class="bi bi-wallet2"></i>

        Payment History

    </h4>

    <div class="table-responsive">

        <table
        class="table table-hover align-middle"
        id="paymentTable">

            <thead class="table-primary">

            <tr>

                <th>Payment ID</th>

                <th>Product</th>

                <th>Rent</th>

                <th>Commission</th>

                <th>Owner Amount</th>

                <th>Status</th>

                <th>Reference</th>

                <th>Date</th>

                <th>Remarks</th>

            </tr>

            </thead>

            <tbody>

<%

if(payoutList!=null){

for(OwnerPayout p:payoutList){

String badge="secondary";

if("Paid".equalsIgnoreCase(p.getPayoutStatus()))
badge="success";

else if("Pending".equalsIgnoreCase(p.getPayoutStatus()))
badge="warning";

else if("Processing".equalsIgnoreCase(p.getPayoutStatus()))
badge="primary";

%>

<tr>

<td>

#<%=p.getPaymentId()%>

</td>

<td>

<%=p.getProductName()%>

</td>

<td>

₹ <%=df.format(p.getRentAmount())%>

</td>

<td class="text-danger fw-bold">

₹ <%=df.format(p.getCommissionAmount())%>

</td>

<td class="text-success fw-bold">

₹ <%=df.format(p.getOwnerAmount())%>

</td>

<td>

<span class="badge bg-<%=badge%>">

<%=p.getPayoutStatus()%>

</span>

</td>

<td>

<%=p.getTransactionReference()==null ?
"-"
:
p.getTransactionReference()%>

</td>

<td>

<%=p.getPayoutDate()==null ?
"-"
:
p.getPayoutDate()%>

</td>

<td>

<%=p.getRemarks()==null ?
"-"
:
p.getRemarks()%>

</td>

</tr>

<%

}

}

%>

            </tbody>

        </table>

    </div>

</div>
<!-- =====================================================
ACTION BUTTONS
===================================================== -->

<div class="mt-4 d-flex justify-content-between">

    <a href="OwnerDashboardServlet"
       class="btn btn-secondary">

        <i class="bi bi-arrow-left"></i>

        Back to Dashboard

    </a>

    <div>

        <button class="btn btn-outline-primary">

            <i class="bi bi-download"></i>

            Download Statement

        </button>

        <button class="btn btn-success">

            <i class="bi bi-printer"></i>

            Print

        </button>

    </div>

</div>

<!-- =====================================================
VIEW PAYMENT DETAILS MODAL
===================================================== -->

<div class="modal fade"
     id="paymentModal"
     tabindex="-1">

<div class="modal-dialog modal-lg">

<div class="modal-content">

<div class="modal-header">

<h5 class="modal-title">

Payment Details

</h5>

<button
type="button"
class="btn-close"
data-bs-dismiss="modal">

</button>

</div>

<div class="modal-body">

<p class="text-muted">

Detailed payment information will be displayed
here in the next version.

</p>

</div>

<div class="modal-footer">

<button
class="btn btn-secondary"
data-bs-dismiss="modal">

Close

</button>

</div>

</div>

</div>

</div>

<!-- =====================================================
LIVE SEARCH
===================================================== -->

<script>

const search=document.getElementById("searchPayment");

const filter=document.getElementById("statusFilter");

const rows=document.querySelectorAll("#paymentTable tbody tr");

function filterTable(){

const text=search.value.toLowerCase();

const status=filter.value.toLowerCase();

rows.forEach(row=>{

const rowText=row.innerText.toLowerCase();

const rowStatus=row.cells[5].innerText.toLowerCase();

const matchText=rowText.includes(text);

const matchStatus=status=="" || rowStatus.includes(status);

row.style.display=(matchText && matchStatus) ? "" : "none";

});

}

search.addEventListener("keyup",filterTable);

filter.addEventListener("change",filterTable);

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</div>

</body>

</html>