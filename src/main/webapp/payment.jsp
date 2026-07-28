<%@page import="java.sql.*"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>RentEasy Checkout</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<link rel="stylesheet" href="css/dashboard.css">

<style>

body{
    background:#f4f6fb;
    font-family:'Segoe UI',sans-serif;
    padding-top:90px;
}

.checkout-container{
    max-width:1400px;
}

.checkout-card{
    background:#fff;
    border-radius:18px;
    padding:25px;
    box-shadow:0 10px 25px rgba(0,0,0,.08);
    margin-bottom:25px;
}

.product-image{
    width:100%;
    height:320px;
    object-fit:cover;
    border-radius:15px;
    border:1px solid #ddd;
}

.product-title{
    font-size:30px;
    font-weight:bold;
    margin-top:20px;
}

.price{
    font-size:28px;
    font-weight:bold;
    color:#0d6efd;
}

.section-title{
    font-size:25px;
    font-weight:700;
    margin-bottom:20px;
}

.summary-row{
    display:flex;
    justify-content:space-between;
    padding:12px 0;
    border-bottom:1px solid #ececec;
}

.badge{
    font-size:13px;
    padding:8px 14px;
}
/* ========================================================= */
/* PART 3 CSS */
/* ========================================================= */

.pickup-card{

display:flex;

justify-content:space-between;

align-items:center;

padding:18px;

border:2px solid #ddd;

border-radius:15px;

cursor:pointer;

margin-bottom:15px;

transition:.3s;

background:#fff;

}

.pickup-card:hover{

border-color:#0d6efd;

transform:translateY(-2px);

}

.pickup-card.active{

border:2px solid #0d6efd;

background:#eef5ff;

}

.pickup-icon{

width:55px;

height:55px;

display:flex;

justify-content:center;

align-items:center;

font-size:28px;

background:#f3f6fb;

border-radius:50%;

}

</style>

</head>

<body>
<!-- ========================================================= -->
<!-- PART 2 JAVASCRIPT -->
<!-- ========================================================= -->

<script>

/* ========================================================= */
/* PART 4 START : LIVE CALCULATION */
/* ========================================================= */

function updateRentalDates(){

    let months = parseInt(document.getElementById("months").value);

    if(isNaN(months) || months < 1){
        months = 1;
        document.getElementById("months").value = 1;
    }

    let start = new Date();
    let end = new Date(start);

    end.setMonth(end.getMonth()+months);

    document.getElementById("startDate").value =
        start.toLocaleDateString("en-GB");

    document.getElementById("endDate").value =
        end.toLocaleDateString("en-GB");

    calculatePayment();

}

function calculatePayment(){

    let months = parseInt(document.getElementById("months").value);

    if(isNaN(months) || months < 1)
        months = 1;

    let pricePerDay = parseFloat(document.getElementById("productPrice").value);

    let deposit = parseFloat(document.getElementById("productDeposit").value);

    let rent = pricePerDay * (months * 30);

    let delivery = 0;

    let grandTotal = rent + deposit + delivery;

    document.getElementById("rentAmount").value = rent;
    document.getElementById("deliveryCharge").value = delivery;
    document.getElementById("grandTotal").value = grandTotal;

    if(document.getElementById("rentValue"))
        document.getElementById("rentValue").innerHTML="₹"+rent;

    if(document.getElementById("depositValue"))
        document.getElementById("depositValue").innerHTML="₹"+deposit;

    if(document.getElementById("deliveryValue"))
        document.getElementById("deliveryValue").innerHTML="₹"+delivery;

    if(document.getElementById("grandValue"))
        document.getElementById("grandValue").innerHTML="₹"+grandTotal;

}

window.onload=function(){

    updateRentalDates();

};

/* ========================================================= */
/* PART 4 END */
/* ========================================================= */
/* ========================================================= */
/* PART 3 JAVASCRIPT */
/* ========================================================= */

function selectPickup(type, element) {

    document.getElementById("pickupMethod").value = type;

    document.querySelectorAll(".pickup-card").forEach(function(card) {
        card.classList.remove("active");
    });

    element.classList.add("active");

    // We'll enable payment calculation in Part 5
    // calculatePayment();

}
<!-- ========================================================= -->
<!-- RAZORPAY PAYMENT -->
<!-- ========================================================= -->

async function startPayment() {

    let amount =
        document.getElementById("grandValue").innerText
                .replace("₹","")
                .replace(",","")
                .trim();

    try {

        const response =
        await fetch("CreateOrderServlet", {

            method: "POST",

            headers: {

                "Content-Type":
                "application/x-www-form-urlencoded"

            },

            body:
            	"amount=" + encodeURIComponent(amount)
            	+ "&productId=" + encodeURIComponent(document.getElementById("productId").value)
            	+ "&ownerId=" + encodeURIComponent(document.getElementById("ownerId").value)
                + "&rentAmount=" + encodeURIComponent(document.getElementById("rentAmount").value)
                + "&depositAmount=" + encodeURIComponent(document.getElementById("productDeposit").value)
                + "&pickupMethod=" + encodeURIComponent(document.getElementById("pickupMethod").value)
                + "&rentalMonths=" + encodeURIComponent(document.getElementById("months").value)

        });

        const order =
        await response.json();

        openRazorpay(order);

    }

    catch(error){

        alert("Unable to create payment.");

        console.error(error);

    }

}

function openRazorpay(order){

    var options = {

        key:
        "rzp_test_THRfTDCoXenpH0",

        amount:
        order.amount,

        currency:
        order.currency,

        name:
        "RentEasy",

        description:
        "Rental Payment",

        order_id:
        order.id,

        handler:function(response){

            window.location =
            "VerifyPaymentServlet"
            + "?payment_id="
            + response.razorpay_payment_id
            + "&order_id="
            + response.razorpay_order_id
            + "&signature="
            + response.razorpay_signature;

        },

        theme:{
            color:"#0d6efd"
        }

    };

    var rzp =
    new Razorpay(options);

    rzp.open();

}
</script>

<%

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

String id=request.getParameter("id");

String name="";
String category="";
String description="";
String image="";
String owner="";
int ownerId = 0;
double price=0;
double deposit=0;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456"
);

ps=con.prepareStatement(
"SELECT * FROM products WHERE id=?"
);

ps.setInt(1,Integer.parseInt(id));

rs=ps.executeQuery();

if(rs.next()){

name=rs.getString("name");
category=rs.getString("category");
description=rs.getString("description");
owner=rs.getString("owner");
image=rs.getString("image");
price=rs.getDouble("price");
deposit=rs.getDouble("deposit");
ownerId = rs.getInt("owner_id");

}else{

out.println("<h2 style='color:red;text-align:center;'>Product Not Found</h2>");

return;

}

}catch(Exception e){

out.println("<pre>");
e.printStackTrace(new java.io.PrintWriter(out));
out.println("</pre>");

}
%>
<jsp:include page="includes/navbar.jsp"/>
<div class="container checkout-container mt-4">

<div class="row">

<!-- ================= PRODUCT CARD ================= -->

<div class="col-lg-4">

<div class="checkout-card">

<img
src="<%=request.getContextPath()%>/<%=image%>"
class="product-image">

<h2 class="product-title">

<%=name%>

</h2>

<div class="mb-3">

<span class="badge bg-success">

Verified

</span>

<span class="badge bg-primary">

Available

</span>

</div>

<div class="summary-row">

<span>Category</span>

<strong>

<%=category%>

</strong>

</div>

<div class="summary-row">

<span>Owner</span>

<strong>

<%=owner%>

</strong>

</div>

<div class="summary-row">

<span>Rent Price</span>

<strong class="price">

₹<%=price%>/Day

</strong>

</div>

<div class="summary-row">

<span>Security Deposit</span>

<strong>

₹<%=deposit%>

</strong>

</div>

<div class="mt-4">

<h6>Description</h6>

<p>

<%=description%>

</p>

</div>

</div>

</div>

<!-- ================= RENTAL DETAILS ================= -->

<!-- ========================================================= -->
<!-- PART 2 START : RENTAL DETAILS -->
<!-- ========================================================= -->

<div class="col-lg-4">

<div class="checkout-card">

<h3 class="section-title">

Rental Details

</h3>

<form id="rentalForm">

<!-- Hidden fields for future use -->

<input type="hidden" id="rentAmount" name="rentAmount">
<input type="hidden" id="deliveryCharge" name="deliveryCharge">
<input type="hidden" id="grandTotal" name="grandTotal">
<input type="hidden" id="productPrice" value="<%=price%>">
<input type="hidden" id="productDeposit" value="<%=deposit%>">
<input type="hidden" id="totalDays" name="days">
<input type="hidden" id="productId" value="<%=id%>">
<input type="hidden" id="ownerId" value="<%=ownerId%>">
<input type="hidden" id="pickupMethod" name="pickupMethod">
<input type="hidden" id="rentalMonths" name="rentalMonths">

<!-- Rental Months -->

<!-- Rental Duration -->

<div class="mb-4">

<label class="form-label fw-bold">

Rental Duration (Months)

</label>

<input
type="number"
id="months"
class="form-control"
min="1"
max="24"
value="1"
placeholder="Enter number of months"
oninput="updateRentalDates()">

<small class="text-muted">
Enter how many months you want to rent this product.
</small>

</div>

<!-- Start Date -->

<div class="mb-4">

<label class="form-label fw-bold">

Rental Starts

</label>

<input
type="text"
id="startDate"
class="form-control"
readonly>

</div>

<!-- End Date -->

<div class="mb-4">

<label class="form-label fw-bold">

Rental Ends

</label>

<input
type="text"
id="endDate"
class="form-control"
readonly>

</div>
<!-- ========================================================= -->
<!-- PART 3 START : PICKUP METHOD -->
<!-- ========================================================= -->

<h5 class="fw-bold mt-4 mb-3">

Pickup Method

</h5>

<input
type="hidden"
id="pickupMethod"
name="pickupMethod"
value="SELF">

<div
class="pickup-card active"
onclick="selectPickup('SELF',this)">

<div class="d-flex align-items-center">

<div class="pickup-icon">

🚶

</div>

<div class="ms-3">

<h6 class="mb-1">

Self Pickup

</h6>

<small class="text-muted">

Collect product from owner

</small>

</div>

</div>

<span class="badge bg-success">

FREE

</span>

</div>


<!-- ========================================================= -->
<!-- PART 3 END -->
<!-- ========================================================= -->
</form>

</div>

</div>

<!-- ========================================================= -->
<!-- PART 2 END -->
<!-- ========================================================= -->

<!-- ================= PAYMENT SUMMARY ================= -->

<!-- ========================================================= -->
<!-- PART 5 START : PAYMENT SUMMARY -->
<!-- ========================================================= -->

<div class="col-lg-4">

<div class="checkout-card sticky-top" style="top:100px;">

<h3 class="section-title">

Payment Summary

</h3>

<div class="summary-row">

<span>Rent Amount</span>

<strong id="rentValue">

₹0

</strong>

</div>

<div class="summary-row">

<span>Security Deposit</span>

<strong id="depositValue">

₹<%=deposit%>

</strong>

</div>

<div class="summary-row">

<span>Delivery Charge</span>

<strong id="deliveryValue">

₹0

</strong>

</div>

<div class="summary-row">

<span>

GST

</span>

<strong>

₹0

</strong>

</div>

<hr>

<div class="d-flex justify-content-between align-items-center">

<h4>

Grand Total

</h4>

<h3
id="grandValue"
class="text-primary">

₹0

</h3>

</div>

<div class="mt-4">

<button
    type="button"
    class="btn btn-primary w-100"
    onclick="startPayment()">

    Proceed To Payment

</button>

</div>

<div class="mt-3 text-center">

<small class="text-success">

<i class="fa-solid fa-shield-halved"></i>

100% Secure Checkout

</small>

</div>

</div>

</div>

<!-- ========================================================= -->
<!-- PART 5 END -->
<!-- ========================================================= -->		

</div>

</div>
<!-- ========================================================= -->
<!-- RAZORPAY CHECKOUT -->
<!-- ========================================================= -->

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</body>

</html>