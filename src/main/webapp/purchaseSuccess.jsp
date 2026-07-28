<%@ page session="true" %>

<!DOCTYPE html>
<html>

<head>

<title>Order Successful - RentEasy</title>

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{
    background:#f4f6f9;
    font-family:'Segoe UI';
}

.success-card{
    max-width:600px;
    margin:100px auto;
    background:white;
    padding:50px;
    text-align:center;
    border-radius:18px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
}

.success-icon{
    font-size:70px;
}

</style>

</head>

<body>

<div class="success-card">

<div class="success-icon">

✅

</div>

<h2>

Order Placed Successfully!

</h2>

<p class="text-muted mt-3">

Your product purchase has been confirmed.

</p>

<p>

The product owner has been notified and
will prepare the product for delivery.

</p>

<a
href="dashboard.jsp"
class="btn btn-success mt-3">

Continue Shopping

</a>

</div>

</body>

</html>