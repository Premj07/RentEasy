<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
String id = request.getParameter("id");
String username = (String) session.getAttribute("user");

String name="", image="";
int price=0;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy","root","123456");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM products WHERE id=?");

    ps.setInt(1, Integer.parseInt(id));
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        name = rs.getString("name");
        price = rs.getInt("price");
        image = rs.getString("image");
    }
}catch(Exception e){
    out.println(e);
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Payment - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background:#f4f6f9;
    font-family:'Segoe UI';
}

/* CARD */
.card-box{
    background:white;
    border-radius:15px;
    padding:25px;
    box-shadow:0 10px 25px rgba(0,0,0,0.1);
}

/* IMAGE */
.product-img{
    width:100%;
    height:200px;
    object-fit:cover;
    border-radius:10px;
}

/* BILL */
.bill{
    background:white;
    border-radius:15px;
    padding:20px;
    margin-top:30px;
}

/* LOGO */
.logo{
    font-size:22px;
    font-weight:bold;
    color:#20c997;
}

/* TABLE */
.table th{
    background:#20c997;
    color:white;
}
</style>

<script>
function calculateTotal(){
    let price = <%= price %>;
    let months = document.getElementById("months").value;

    let days = months * 30;
    let deposit = price * 10; // fixed deposit

    let total = (price * days) + deposit;

    document.getElementById("totalAmount").innerHTML = total;
    document.getElementById("days").innerHTML = days;
    document.getElementById("deposit").innerHTML = deposit;
}

function togglePayment(){
    let method = document.getElementById("method").value;

    document.getElementById("upiBox").style.display = "none";
    document.getElementById("cardBox").style.display = "none";

    if(method==="UPI"){
        document.getElementById("upiBox").style.display = "block";
    }else{
        document.getElementById("cardBox").style.display = "block";
    }
}

function printBill(){
    window.print();
}
</script>

</head>

<body onload="calculateTotal()">

<div class="container mt-5">

<div class="row">

<!-- PRODUCT -->
<div class="col-md-6">
    <div class="card-box">

        <img src="<%=request.getContextPath()%>/<%= image %>" class="product-img">

        <h4 class="mt-3"><%= name %></h4>
        <h5 class="text-success"><%= price %> / day</h5>

        <label class="mt-3">Select Months (Min 3)</label>
        <input type="number" id="months" value="3" min="3"
               class="form-control" onchange="calculateTotal()">

    </div>
</div>

<!-- PAYMENT -->
<div class="col-md-6">
    <div class="card-box">

        <h4>Payment Details</h4>

        <label>Payment Method</label>
        <select id="method" class="form-control mb-3" onchange="togglePayment()">
            <option>UPI</option>
            <option>Card</option>
        </select>

        <!-- UPI -->
        <div id="upiBox">
            <input type="text" class="form-control mb-3"
                   placeholder="Enter UPI ID (example@upi)">
        </div>

        <!-- CARD -->
        <div id="cardBox" style="display:none;">
            <input type="text" class="form-control mb-2" placeholder="Card Number">
            <input type="text" class="form-control mb-2" placeholder="Name on Card">
            <input type="text" class="form-control mb-2" placeholder="Expiry (MM/YY)">
            <input type="password" class="form-control mb-3" placeholder="CVV">
        </div>

        <button class="btn btn-success w-100">
            Pay <span id="totalAmount"></span>
        </button>

    </div>
</div>

</div>

<!-- BILL -->
<div class="bill">

    <div class="d-flex justify-content-between">
        <div class="logo">RentEasy</div>
        <div>Date: <%= new java.util.Date() %></div>
    </div>

    <hr>

    <p><b>User:</b> <%= username %></p>

    <table class="table table-bordered mt-3">

        <tr>
            <th>Product</th>
            <th>Price/Day</th>
            <th>Days</th>
            <th>Deposit</th>
            <th>Total</th>
        </tr>

        <tr>
            <td><%= name %></td>
            <td><%= price %></td>
            <td id="days"></td>
            <td id="deposit"></td>
            <td><span id="totalAmount"></span></td>
        </tr>

    </table>

    <button onclick="printBill()" class="btn btn-dark">
        Print Bill 
    </button>

</div>

</div>

</body>
</html>