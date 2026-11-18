<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>

<head>

<title>Payments & Refunds - RentEasy</title>

<link rel="stylesheet" href="css/dashboard.css">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

.payment-page {
    max-width: 1200px;
    margin: auto;
}

/* =========================
   HEADER
========================= */

.payment-title {
    margin-bottom: 30px;
}

.payment-title h2 {
    font-size: 32px;
    color: #0f172a;
    margin-bottom: 7px;
}

.payment-title p {
    color: #64748b;
}


/* =========================
   SUMMARY CARDS
========================= */

.refund-summary {
    display: grid;
    grid-template-columns: repeat(3,1fr);
    gap: 20px;
    margin-bottom: 35px;
}

.summary-card {
    background: white;
    padding: 25px;
    border-radius: 18px;
    box-shadow: 0 8px 25px rgba(0,0,0,.07);
}

.summary-card i {
    font-size: 28px;
    color: #2563EB;
}

.summary-card h3 {
    margin-top: 15px;
    font-size: 27px;
    color: #0f172a;
}

.summary-card p {
    color: #64748b;
    margin-top: 5px;
}


/* =========================
   BANK ACCOUNT CARD
========================= */

.bank-card {
    background: white;
    border-radius: 18px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 8px 25px rgba(0,0,0,.07);
}

.bank-card-inner {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
}

.bank-title {
    margin: 0 0 8px 0;
    font-size: 21px;
    color: #0f172a;
}

.bank-description {
    margin: 0;
    color: #64748b;
}

.bank-holder {
    font-size: 18px;
    color: #0f172a;
}

.bank-name {
    margin: 6px 0;
    color: #475569;
}

.bank-info {
    margin: 5px 0;
    color: #64748b;
}

.bank-added {
    color: #16a34a;
    font-weight: 600;
    margin-bottom: 12px;
    text-align: right;
}

.bank-btn {
    display: inline-block;
    background: #2563eb;
    color: white;
    padding: 12px 20px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 600;
}

.bank-btn:hover {
    background: #1d4ed8;
}

.bank-edit-btn {
    display: inline-block;
    background: #f1f5f9;
    color: #2563eb;
    padding: 11px 18px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 600;
}

.bank-edit-btn:hover {
    background: #e2e8f0;
}


/* =========================
   REFUND CARD
========================= */

.refund-card {
    background: white;
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 25px;
    box-shadow: 0 8px 30px rgba(0,0,0,.07);
}

.refund-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #e5e7eb;
    padding-bottom: 18px;
    margin-bottom: 22px;
}

.product-name {
    font-size: 22px;
    font-weight: 700;
    color: #0f172a;
}

.rental-id {
    color: #64748b;
    margin-top: 5px;
}


/* =========================
   STATUS
========================= */

.status-badge {
    padding: 9px 17px;
    border-radius: 30px;
    font-weight: 700;
    font-size: 13px;
}

.status-held {
    background: #fef3c7;
    color: #92400e;
}

.status-pending {
    background: #dbeafe;
    color: #1d4ed8;
}

.status-refunded {
    background: #dcfce7;
    color: #166534;
}


/* =========================
   MONEY
========================= */

.money-grid {
    display: grid;
    grid-template-columns: repeat(3,1fr);
    gap: 20px;
    margin-bottom: 28px;
}

.money-box {
    background: #f8fafc;
    padding: 18px;
    border-radius: 14px;
}

.money-box span {
    color: #64748b;
    font-size: 14px;
}

.money-box h4 {
    margin-top: 8px;
    font-size: 21px;
    color: #0f172a;
}


/* =========================
   TIMELINE
========================= */

.refund-flow {
    margin-top: 15px;
}

.flow-item {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 13px 0;
    color: #94a3b8;
    font-weight: 600;
}

.flow-item.done {
    color: #16a34a;
}

.flow-item.current {
    color: #2563eb;
}

.flow-item i {
    font-size: 20px;
}


/* =========================
   DEDUCTION
========================= */

.deduction-info {
    margin-top: 20px;
    background: #fff7ed;
    border: 1px solid #fed7aa;
    padding: 18px;
    border-radius: 14px;
}

.deduction-info strong {
    color: #c2410c;
}


/* =========================
   EMPTY
========================= */

.empty-box {
    background: white;
    padding: 50px;
    text-align: center;
    border-radius: 20px;
    color: #64748b;
    box-shadow: 0 8px 25px rgba(0,0,0,.06);
}

.empty-box i {
    font-size: 50px;
    color: #94a3b8;
}


/* =========================
   MESSAGE
========================= */

.success-message {
    background: #dcfce7;
    color: #166534;
    border: 1px solid #bbf7d0;
    padding: 14px 18px;
    border-radius: 12px;
    margin-bottom: 20px;
    font-weight: 600;
}


/* =========================
   RESPONSIVE
========================= */

@media(max-width: 800px) {

    .refund-summary {
        grid-template-columns: 1fr;
    }

    .money-grid {
        grid-template-columns: 1fr;
    }

    .bank-card-inner {
        flex-direction: column;
        align-items: flex-start;
    }

    .bank-added {
        text-align: left;
    }
}

</style>

</head>

<body>

<jsp:include page="includes/navbar.jsp"/>


<div class="main-content">

<div class="payment-page">


<!-- ==============================
     HEADER
============================== -->

<div class="payment-title">

<h2>
<i class="bi bi-wallet2"></i>
Payments & Refunds
</h2>

<p>
Track your security deposits, deductions and refund status.
</p>

</div>


<%

Connection con = null;

double totalDeposits = 0;
double pendingRefunds = 0;
double totalRefunded = 0;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    // ==============================================
    // SUMMARY
    // ==============================================

    PreparedStatement summaryPs =
        con.prepareStatement(

        "SELECT " +

        "IFNULL(SUM(original_deposit),0) total_deposit, " +

        "IFNULL(SUM(CASE " +
        "WHEN refund_status <> 'COMPLETED' " +
        "THEN refund_amount ELSE 0 END),0) pending_refund, " +

        "IFNULL(SUM(CASE " +
        "WHEN refund_status='COMPLETED' " +
        "THEN refund_amount ELSE 0 END),0) total_refunded " +

        "FROM deposit_refunds " +
        "WHERE user_id=?"
    );

    summaryPs.setInt(1,userId);

    ResultSet summaryRs =
        summaryPs.executeQuery();

    if(summaryRs.next()) {

        totalDeposits =
            summaryRs.getDouble("total_deposit");

        pendingRefunds =
            summaryRs.getDouble("pending_refund");

        totalRefunded =
            summaryRs.getDouble("total_refunded");
    }

    summaryRs.close();
    summaryPs.close();

%>


<!-- ==============================
     SUCCESS MESSAGE
============================== -->

<%

String message =
    request.getParameter("msg");

if("bank_saved".equals(message)) {

%>

<div class="success-message">

<i class="bi bi-check-circle-fill"></i>

Bank details saved successfully.
Your account is ready to receive security deposit refunds.

</div>

<%

}

%>


<!-- ==============================
     SUMMARY CARDS
============================== -->

<div class="refund-summary">


<div class="summary-card">

<i class="bi bi-shield-lock"></i>

<h3>
₹<%=String.format("%.2f",totalDeposits)%>
</h3>

<p>Total Security Deposits</p>

</div>



<div class="summary-card">

<i class="bi bi-hourglass-split"></i>

<h3>
₹<%=String.format("%.2f",pendingRefunds)%>
</h3>

<p>Deposit Currently Held</p>

</div>



<div class="summary-card">

<i class="bi bi-check-circle"></i>

<h3>
₹<%=String.format("%.2f",totalRefunded)%>
</h3>

<p>Total Refunded</p>

</div>


</div>


<!-- ==============================
     GET BANK DETAILS
============================== -->

<%

String bankHolder = null;
String bankName = null;
String accountNumber = null;
String ifscCode = null;

try {

    PreparedStatement bankPs =
        con.prepareStatement(

        "SELECT account_holder, bank_name, " +
        "account_number, ifsc_code " +
        "FROM bank_details " +
        "WHERE user_id=? " +
        "LIMIT 1"
    );

    bankPs.setInt(1,userId);

    ResultSet bankRs =
        bankPs.executeQuery();

    if(bankRs.next()) {

        bankHolder =
            bankRs.getString("account_holder");

        bankName =
            bankRs.getString("bank_name");

        accountNumber =
            bankRs.getString("account_number");

        ifscCode =
            bankRs.getString("ifsc_code");
    }

    bankRs.close();
    bankPs.close();

} catch(Exception bankException) {

    bankException.printStackTrace();
}

%>


<!-- ==============================
     REFUND BANK ACCOUNT CARD
============================== -->

<div class="bank-card">

<div class="bank-card-inner">


<div>

<h3 class="bank-title">

<i class="bi bi-bank"></i>
Refund Bank Account

</h3>


<%

if(accountNumber == null ||
   accountNumber.trim().isEmpty()) {

%>


<p class="bank-description">

Add your bank account to receive security deposit refunds.

</p>


<%

} else {

    String maskedAccount =
        accountNumber;

    if(accountNumber.length() > 4) {

        maskedAccount =
            "••••••" +
            accountNumber.substring(
                accountNumber.length() - 4
            );
    }

%>


<div style="margin-top:15px;">

<strong class="bank-holder">
<%=bankHolder%>
</strong>

<p class="bank-name">
<%=bankName%>
</p>

<p class="bank-info">

Account:
<strong>
<%=maskedAccount%>
</strong>

</p>

<p class="bank-info">

IFSC:
<strong>
<%=ifscCode%>
</strong>

</p>

</div>


<%

}

%>

</div>



<div>


<%

if(accountNumber == null ||
   accountNumber.trim().isEmpty()) {

%>


<a href="bankAccount.jsp"
class="bank-btn">

<i class="bi bi-plus-circle"></i>
Add Bank Details

</a>


<%

} else {

%>


<div class="bank-added">

<i class="bi bi-check-circle-fill"></i>
Ready for Refund

</div>


<a href="bankAccount.jsp"
class="bank-edit-btn">

<i class="bi bi-pencil-square"></i>
Edit Bank Details

</a>


<%

}

%>


</div>

</div>

</div>


<!-- ==============================
     GET USER REFUNDS
============================== -->

<%

PreparedStatement refundPs =
    con.prepareStatement(

    "SELECT dr.*, p.name AS product_name " +

    "FROM deposit_refunds dr " +

    "JOIN rentals r " +
    "ON dr.rental_id=r.rental_id " +

    "JOIN products p " +
    "ON r.product_id=p.id " +

    "WHERE dr.user_id=? " +

    "ORDER BY dr.refund_id DESC"
);

refundPs.setInt(1,userId);

ResultSet refundRs =
    refundPs.executeQuery();

boolean found = false;


while(refundRs.next()) {

    found = true;


    int rentalId =
        refundRs.getInt("rental_id");


    String productName =
        refundRs.getString("product_name");


    double deposit =
        refundRs.getDouble("original_deposit");


    double deduction =
        refundRs.getDouble("deduction_amount");


    double refundAmount =
        refundRs.getDouble("refund_amount");


    String refundStatus =
        refundRs.getString("refund_status");


    String inspectionStatus =
        refundRs.getString("inspection_status");


    String reason =
        refundRs.getString("deduction_reason");


    String transactionId =
        refundRs.getString("transaction_id");


    Timestamp refundedAt =
        refundRs.getTimestamp("refunded_at");


    if(refundStatus == null) {
        refundStatus = "HELD";
    }

    if(inspectionStatus == null) {
        inspectionStatus = "PENDING";
    }


    String badgeClass =
        "status-pending";


    if("HELD".equalsIgnoreCase(refundStatus)) {

        badgeClass =
            "status-held";

    } else if(
    		"COMPLETED".equalsIgnoreCase(refundStatus)
    ) {

        badgeClass =
            "status-refunded";
    }

%>


<!-- ==============================
     REFUND CARD
============================== -->

<div class="refund-card">


<div class="refund-top">


<div>

<div class="product-name">

<i class="bi bi-box-seam"></i>

<%=productName%>

</div>


<div class="rental-id">

Rental ID #<%=rentalId%>

</div>

</div>



<span class="status-badge <%=badgeClass%>">

<%=refundStatus.replace("_"," ")%>

</span>


</div>



<!-- ==============================
     MONEY
============================== -->

<div class="money-grid">


<div class="money-box">

<span>
Original Deposit
</span>

<h4>
₹<%=String.format("%.2f",deposit)%>
</h4>

</div>



<div class="money-box">

<span>
Deduction
</span>

<h4>
₹<%=String.format("%.2f",deduction)%>
</h4>

</div>



<div class="money-box">

<span>
Expected Refund
</span>

<h4>
₹<%=String.format("%.2f",refundAmount)%>
</h4>

</div>


</div>



<!-- ==============================
     REFUND PROGRESS
============================== -->

<div class="refund-flow">

<h4>
Refund Progress
</h4>



<div class="flow-item done">

<i class="bi bi-check-circle-fill"></i>

Security deposit paid

</div>



<div class="flow-item
<%=
"HELD".equalsIgnoreCase(refundStatus)
? "current"
: "done"
%>">

<i class="bi bi-shield-lock-fill"></i>

Security deposit held securely

</div>



<div class="flow-item
<%=
!"HELD".equalsIgnoreCase(refundStatus)
? "done"
: ""
%>">

<i class="bi bi-box-arrow-left"></i>

Product returned & OTP verified

</div>



<div class="flow-item
<%=
"NO_DAMAGE".equalsIgnoreCase(inspectionStatus)
||
"DAMAGED".equalsIgnoreCase(inspectionStatus)
? "done"
: ""
%>">

<i class="bi bi-search"></i>

Product inspection completed

</div>



<div class="flow-item
<%=
"READY_FOR_REFUND".equalsIgnoreCase(refundStatus)
||
"COMPLETED".equalsIgnoreCase(refundStatus)

? "done"
: ""
%>">

<i class="bi bi-check2-circle"></i>

Refund approved

</div>



<div class="flow-item
<%=
"READY_FOR_REFUND".equalsIgnoreCase(refundStatus)

? "current"

:

	"COMPLETED".equalsIgnoreCase(refundStatus)

? "done"

: ""
%>">

<i class="bi bi-arrow-repeat"></i>

Refund processing

</div>



<div class="flow-item
<%=
"COMPLETED".equalsIgnoreCase(refundStatus)

? "done"

: ""
%>">

<i class="bi bi-bank"></i>

Refund completed

</div>


</div>



<!-- ==============================
     DEDUCTION DETAILS
============================== -->

<%

if(deduction > 0) {

%>


<div class="deduction-info">

<strong>

<i class="bi bi-exclamation-triangle"></i>

Deduction Applied:
₹<%=String.format("%.2f",deduction)%>

</strong>


<br><br>


Reason:


<%=
reason != null
? reason
: "Damage/charges applied by RentEasy."
%>


</div>


<%

}

%>



<!-- ==============================
     REFUND COMPLETED DETAILS
============================== -->

<%

if("COMPLETED".equalsIgnoreCase(refundStatus)) {

%>


<div class="deduction-info"
style="
background:#f0fdf4;
border-color:#bbf7d0;
">


<strong style="color:#166534;">

<i class="bi bi-check-circle-fill"></i>

Refund Completed

</strong>


<br><br>


Transaction ID:

<b>

<%=
transactionId != null
? transactionId
: "-"
%>

</b>


<br>


Refund Date:

<b>

<%=
refundedAt != null
? refundedAt
: "-"
%>

</b>


</div>


<%

}

%>


</div>


<%

}


/* ==============================
   EMPTY STATE
============================== */

if(!found) {

%>


<div class="empty-box">

<i class="bi bi-wallet2"></i>

<h3>
No payment records yet
</h3>

<p>

Your security deposits and refunds will appear here after you rent a product.

</p>

</div>


<%

}


refundRs.close();
refundPs.close();


} catch(Exception e) {

%>


<div class="empty-box">

<i class="bi bi-exclamation-circle"></i>

<h3 style="color:#dc2626;">

Unable to load payment information

</h3>

<p>

<%=e.getMessage()%>

</p>

</div>


<%

} finally {

    if(con != null) {

        try {

            con.close();

        } catch(Exception e) {

            e.printStackTrace();

        }

    }
}

%>


</div>

</div>


<script src="js/dashboard.js"></script>

</body>

</html>