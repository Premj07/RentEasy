<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("index.jsp");
    return;
}

String username = (String)session.getAttribute("user");
String id = request.getParameter("id");

if(id == null || id.trim().isEmpty()){
    response.sendRedirect("products.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<title>Buy Product - RentEasy</title>

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{
    background:#f3f4f6;
    font-family:'Segoe UI',sans-serif;
}

.checkout-container{
    max-width:1200px;
    margin:40px auto;
}

.checkout-card{
    background:white;
    border-radius:14px;
    padding:25px;
    box-shadow:0 4px 20px rgba(0,0,0,0.08);
}

.product-image{
    width:100%;
    height:280px;
    object-fit:cover;
    border-radius:10px;
}

.product-title{
    font-size:26px;
    font-weight:700;
}

.actual-price{
    color:#777;
    text-decoration:line-through;
    font-size:18px;
}

.selling-price{
    color:#B12704;
    font-size:30px;
    font-weight:700;
}

.discount{
    color:#CC0C39;
    font-size:20px;
}

.section-title{
    font-size:20px;
    font-weight:700;
    margin-bottom:18px;
}

.price-row{
    display:flex;
    justify-content:space-between;
    margin-bottom:12px;
}

.total-row{
    border-top:1px solid #ddd;
    padding-top:15px;
    font-size:20px;
    font-weight:700;
}

.buy-btn{
    background:#FFD814;
    border:1px solid #FCD200;
    color:#111;
    border-radius:20px;
    padding:11px;
    font-weight:600;
}

.buy-btn:hover{
    background:#F7CA00;
}

.secure-text{
    color:#007600;
    font-size:14px;
}

</style>

</head>

<body>

<div class="container checkout-container">

<a href="rentProduct.jsp?id=<%=id%>"
class="text-decoration-none">

← Back to Product

</a>

<div class="row mt-3 g-4">

<%

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con =
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps =
con.prepareStatement(
"SELECT * FROM products WHERE id=?");

ps.setInt(
1,
Integer.parseInt(id)
);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

double actualPrice =
rs.getDouble("actual_price");

double sellingPrice =
rs.getDouble("selling_price");

double discount = 0;

if(actualPrice > 0 &&
sellingPrice < actualPrice){

discount =
((actualPrice-sellingPrice)
/ actualPrice) * 100;

}

%>

<!-- PRODUCT -->

<div class="col-md-7">

<div class="checkout-card">

<div class="row">

<div class="col-md-5">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="product-image">

</div>

<div class="col-md-7">

<div class="product-title">

<%=rs.getString("name")%>

</div>

<p class="text-muted mt-2">

<%=rs.getString("description")%>

</p>

<p>

<b>Category:</b>

<%=rs.getString("category")%>

</p>

<p>

<b>Location:</b>

<%=rs.getString("location")%>

</p>

<p>

<b>Sold by:</b>

<%=rs.getString("owner")%>

</p>

<div class="actual-price">

MRP ₹<%=actualPrice%>

</div>

<div class="selling-price">

₹<%=sellingPrice%>

</div>

<%

if(discount > 0){

%>

<div class="discount">

-<%=Math.round(discount)%>% OFF

</div>

<%

}

%>

</div>

</div>

</div>


<!-- DELIVERY -->

<div class="checkout-card mt-4">

<div class="section-title">

Delivery Details

</div>

<form
action="PurchaseProductServlet"
method="post">

<input
type="hidden"
name="productId"
value="<%=rs.getInt("id")%>">

<div class="mb-3">

<label class="form-label">

Full Name

</label>

<input
type="text"
name="deliveryName"
class="form-control"
required>

</div>

<div class="mb-3">

<label class="form-label">

Mobile Number

</label>

<input
type="tel"
name="deliveryPhone"
class="form-control"
pattern="[0-9]{10}"
maxlength="10"
required>

</div>

<div class="mb-3">

<label class="form-label">

Delivery Address

</label>

<textarea
name="deliveryAddress"
class="form-control"
rows="3"
required></textarea>

</div>

<div class="mb-3">

<label class="form-label">

Pincode

</label>

<input
type="text"
name="deliveryPincode"
class="form-control"
pattern="[0-9]{6}"
maxlength="6"
required>

</div>

<div class="section-title mt-4">

Payment Method

</div>

<div class="form-check mb-2">

<input
class="form-check-input"
type="radio"
name="paymentMethod"
value="COD"
id="cod"
checked>

<label
class="form-check-label"
for="cod">

Cash on Delivery

</label>

</div>

<div class="form-check">

<input
class="form-check-input"
type="radio"
name="paymentMethod"
value="UPI"
id="upi">

<label
class="form-check-label"
for="upi">

UPI Payment

</label>

</div>

</div>

</div>


<!-- ORDER SUMMARY -->

<div class="col-md-5">

<div class="checkout-card">

<div class="section-title">

Order Summary

</div>

<div class="price-row">

<span>Actual Price</span>

<span>

₹<%=actualPrice%>

</span>

</div>

<div class="price-row">

<span>Product Price</span>

<span>

₹<%=sellingPrice%>

</span>

</div>

<div class="price-row">

<span>Delivery</span>

<span class="text-success">

FREE

</span>

</div>

<div class="price-row total-row">

<span>Order Total</span>

<span>

₹<%=sellingPrice%>

</span>

</div>

<p class="secure-text mt-3">

🔒 Secure Purchase with RentEasy

</p>

<button
type="submit"
class="btn buy-btn w-100 mt-3">

Place Your Order

</button>

</form>

</div>

</div>

<%

}

rs.close();
ps.close();
con.close();

}catch(Exception e){

out.println(e);

}

%>

</div>

</div>

</body>

</html>