<%@ page import="java.sql.*" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.renteasy.dao.SimilarProductDAO" %>
<%
ArrayList<HashMap<String,Object>> similarProducts =
        new ArrayList<HashMap<String,Object>>();
%>
<%
String id = request.getParameter("id");

%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Product Details - RentEasy</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
body{
    background:#f5f7fb;
    font-family:'Poppins',sans-serif;
}

.product-card{
    background:#fff;
    border-radius:18px;
    padding:30px;
    box-shadow:0 10px 35px rgba(0,0,0,.08);
    border:none;
}

.product-img{
    width:100%;
    height:520px;
    object-fit:cover;
    border-radius:18px;
    transition:.4s;
    cursor:pointer;
}

.product-img:hover{
    transform:scale(1.03);
}

.product-title{
    font-size:34px;
    font-weight:700;
    color:#222;
}

.price{
    font-size:34px;
    color:#198754;
    font-weight:700;
}

.selling-price{
    font-size:28px;
    color:#0d6efd;
    font-weight:700;
}

.info-box{
    background:#f8f9fa;
    border-radius:12px;
    padding:14px;
    margin-bottom:12px;
}

.owner-card{
    background:#ffffff;
    border:1px solid #ececec;
    border-radius:15px;
    padding:18px;
    margin-top:20px;
}

.badge-green{
    background:#198754;
    color:#fff;
    padding:6px 14px;
    border-radius:20px;
    font-size:13px;
}

.btn-rent{
    height:55px;
    font-size:18px;
    border-radius:12px;
    background:#198754;
    border:none;
    font-weight:600;
}

.btn-buy{
    height:55px;
    font-size:18px;
    border-radius:12px;
    font-weight:600;
}

.section-title{
    font-weight:700;
    margin-bottom:15px;
}

.back-btn{
    color:#198754;
    text-decoration:none;
    font-weight:600;
}

.back-btn:hover{
    color:#146c43;
}

.rule{
    padding:10px;
    border-bottom:1px solid #eee;
}/* Similar Products */

.similar-card{

transition:.3s;

cursor:pointer;

}

.similar-card:hover{

transform:translateY(-8px);

box-shadow:0 15px 30px rgba(0,0,0,.15);

}

.similar-img{

height:220px;

object-fit:cover;

border-radius:18px 18px 0 0;

}
.thumb-img{

width:100%;

height:90px;

object-fit:cover;

border-radius:12px;

margin-bottom:15px;

cursor:pointer;

border:2px solid transparent;

transition:.3s;

}

.thumb-img:hover{

transform:scale(1.05);

border:2px solid #198754;

}

.active-thumb{

border:2px solid #198754;

}

.product-img{

height:600px;

object-fit:cover;

border-radius:20px;

transition:.4s;

}

.product-img:hover{

transform:scale(1.02);

}
body{

padding-top:95px;

background:#f5f7fb;

}

</style>
</head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="css/dashboard.css">

<style>
...
</style>
<body>

<jsp:include page="includes/navbar.jsp"/>

<div class="container-fluid mt-4">

<div class="container">



<%
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    int productId = Integer.parseInt(id);

    PreparedStatement ps =
        con.prepareStatement(
            "SELECT * FROM products WHERE id=?"
        );

    ps.setInt(1, productId);

    ResultSet rs = ps.executeQuery();
    
    if(rs.next()){

        int currentProductId = rs.getInt("id");
        String currentCategory = rs.getString("category");
        int currentPrice = rs.getInt("price");
        String currentLocation = rs.getString("location");

        SimilarProductDAO similarDAO = new SimilarProductDAO();

        similarProducts =
                similarDAO.getSimilarProducts(
                        currentProductId,
                        currentCategory,
                        currentPrice,
                        currentLocation
                );

        Integer userId =
                (Integer)session.getAttribute("userId");

        if(userId != null){

            try{

                PreparedStatement viewPs =
                        con.prepareStatement(
                            "INSERT INTO recently_viewed(user_id,product_id) VALUES(?,?)"
                        );

                viewPs.setInt(1,userId);
                viewPs.setInt(2,productId);

                viewPs.executeUpdate();
                viewPs.close();

            }catch(Exception ex){

                ex.printStackTrace();
            }
        }

    %>

    <div class="row g-4">

<!-- ================= LEFT SIDE ================= -->

<div class="col-lg-6">

<div class="card border-0 shadow rounded-4 p-3">

<div class="row">

<div class="col-2">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="thumb-img active-thumb"
onclick="changeImage(this)">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="thumb-img"
onclick="changeImage(this)">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="thumb-img"
onclick="changeImage(this)">

<img
src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
class="thumb-img"
onclick="changeImage(this)">

</div>

<div class="col-10">

<img

id="mainImage"

src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"

class="product-img w-100 shadow"

>

</div>

</div>

</div>

</div>

<!-- ================= RIGHT SIDE ================= -->

<div class="col-lg-6">

<div class="product-card">

<h2 class="product-title">

<%=rs.getString("name")%>

</h2>

<span class="badge-green">

Verified Product

</span>

<p class="price mt-3">

₹<%=rs.getInt("price")%>

<small>/day</small>

</p>

<div class="info-box">

<b>Category</b>

<br>

<%=rs.getString("category")%>

</div>

<div class="info-box">

<b>Location</b>

<br>

📍 <%=rs.getString("location")%>

</div>

<div class="owner-card">

<h5>

Owner Information

</h5>

<hr>

<p>

👤 <b><%=rs.getString("owner")%></b>

</p>

<p>

✔ KYC Verified

</p>

<p>

✔ Trusted RentEasy User

</p>

</div>

<h5 class="mt-4">

Description

</h5>

<p>

<%=rs.getString("description")%>

</p>
<!-- ================= PRODUCT INFORMATION ================= -->

<div class="card border-0 shadow-sm rounded-4 mt-4">

<div class="card-header bg-success text-white">

<h5 class="mb-0">

Product Information

</h5>

</div>

<div class="card-body p-0">

<table class="table table-bordered mb-0">

<tr>

<th width="35%">Category</th>

<td><%=rs.getString("category")%></td>

</tr>

<tr>

<th>Rental Price</th>

<td class="text-success fw-bold">

₹<%=rs.getInt("price")%> / Day

</td>

</tr>

<tr>

<th>Location</th>

<td>

📍 <%=rs.getString("location")%>

</td>

</tr>

<tr>

<th>Owner</th>

<td>

<%=rs.getString("owner")%>

</td>

</tr>

<tr>

<th>Status</th>

<td>

<span class="badge bg-success">

Available

</span>

</td>

</tr>

<tr>

<th>KYC</th>

<td>

<span class="badge bg-primary">

Verified

</span>

</td>

</tr>

</table>

</div>

</div>

<!-- ================= RENTAL RULES ================= -->

<div class="card border-0 shadow-sm rounded-4 mt-4">

<div class="card-header bg-dark text-white">

Rental Rules

</div>

<div class="card-body">

<p>✔ Return on agreed date.</p>

<p>✔ Product should not be damaged.</p>

<p>✔ Valid College ID required.</p>

<p>✔ Security deposit refundable after inspection.</p>

<p>✔ Contact owner before pickup.</p>

</div>

</div>

<!-- ================= SECURITY DEPOSIT ================= -->

<div class="alert alert-warning mt-4 rounded-4">

<h5>

Security Deposit

</h5>

<hr>

Deposit amount depends on the product.

It will be refunded after successful inspection.

</div>

<%

String listingType=rs.getString("listing_type");

double sellingPrice=rs.getDouble("selling_price");

if(listingType==null){

listingType="RENT";

}

%>

<!-- ================= BUTTONS ================= -->

<div class="d-grid gap-3 mt-4">

<%

if("RENT".equalsIgnoreCase(listingType)){

%>

<a

href="payment.jsp?id=<%=rs.getInt("id")%>"

class="btn btn-success btn-lg">

Rent Now

</a>

<%

}

%>

<%

if("SELL".equalsIgnoreCase(listingType)){

%>

<p class="selling-price">

Selling Price : ₹<%=sellingPrice%>

</p>

<a

href="buy.jsp?id=<%=rs.getInt("id")%>"

class="btn btn-primary btn-lg">

Buy Now

</a>

<%

}

%>

<%

if("BOTH".equalsIgnoreCase(listingType)){

%>

<p class="selling-price">

Selling Price : ₹<%=sellingPrice%>

</p>

<div class="row">

<div class="col-6">

<a

href="payment.jsp?id=<%=rs.getInt("id")%>"

class="btn btn-success w-100">

Rent Now

</a>

</div>

<div class="col-6">

<a

href="buy.jsp?id=<%=rs.getInt("id")%>"

class="btn btn-primary w-100">

Buy Now

</a>

</div>

</div>

<%

}

%>

</div>

</div>

</div>

</div>

<!-- END OF MAIN PRODUCT ROW -->
<!-- ===================================================== -->
<!-- SIMILAR PRODUCTS -->
<!-- ===================================================== -->

<div class="container mt-5">

<h3 class="fw-bold mb-4">

You may also like

</h3>

<div class="row">

<%

PreparedStatement similarPs =
con.prepareStatement(
"SELECT * FROM products WHERE status='approved' AND id<>? LIMIT 4"
);

similarPs.setInt(1,Integer.parseInt(id));

ResultSet similarRs =
similarPs.executeQuery();

while(similarRs.next()){

%>

<div class="col-lg-3 col-md-6 mb-4">

<div class="card border-0 shadow-sm rounded-4 h-100 similar-card">

<img

src="<%=request.getContextPath()%>/<%=similarRs.getString("image")%>"

class="card-img-top similar-img">

<div class="card-body">

<h5 class="card-title">

<%=similarRs.getString("name")%>

</h5>

<p class="text-success fw-bold">

₹<%=similarRs.getInt("price")%> / Day

</p>

<p class="text-muted">

<%=similarRs.getString("location")%>

</p>

<a

href="rentProduct.jsp?id=<%=similarRs.getInt("id")%>"

class="btn btn-success w-100">

View Details

</a>

</div>

</div>

</div>

<%

}

similarRs.close();
similarPs.close();

%>

</div>

</div>

<script>

function changeImage(img){

document.getElementById("mainImage").src=img.src;

let thumbs=document.querySelectorAll(".thumb-img");

thumbs.forEach(function(t){

t.classList.remove("active-thumb");

});

img.classList.add("active-thumb");

}

</script>

<%

}else{

%>

<div class="alert alert-danger">

Product not found.

</div>

<%

}

rs.close();

ps.close();

con.close();

}

catch(Exception e){

%>

<div class="alert alert-danger">

<%=e.getMessage()%>

</div>

<%

}

%>
<!-- ===================================================== -->
<!-- AI SIMILAR PRODUCT RECOMMENDATIONS -->
<!-- ===================================================== -->

<%
if(similarProducts != null && !similarProducts.isEmpty()){
%>

<div class="mt-5 mb-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>
            <h2 style="font-weight:700; margin-bottom:5px;">
                🤖 AI Similar Products
            </h2>

            <p class="text-muted mb-0">
                Products selected for you based on category,
                price, location and popularity.
            </p>
        </div>

        <span class="badge bg-primary px-3 py-2">
            AI Powered
        </span>

    </div>


    <div class="row g-4">

        <%
        for(HashMap<String,Object> product : similarProducts){

            int similarId =
                ((Number)product.get("id")).intValue();

            String similarName =
                (String)product.get("name");

            int similarPrice =
                ((Number)product.get("price")).intValue();

            String similarImage =
                (String)product.get("image");

            String similarLocation =
                (String)product.get("location");

            String similarCategory =
                (String)product.get("category");

            int matchScore =
                ((Number)product.get("similarityScore")).intValue();
        %>


        <div class="col-lg-4 col-md-6">

            <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden">

                <!-- PRODUCT IMAGE -->

                <img
                    src="<%=request.getContextPath()%>/<%=similarImage%>"
                    style="
                        width:100%;
                        height:230px;
                        object-fit:cover;
                    "
                    alt="<%=similarName%>"
                >


                <div class="card-body p-4">


                    <!-- CATEGORY + MATCH -->

                    <div class="d-flex justify-content-between
                                align-items-center mb-3">

                        <span class="badge bg-light text-primary border">

                            <%=similarCategory%>

                        </span>


                        <span class="badge bg-success">

                            <%=matchScore%>% Match

                        </span>

                    </div>


                    <!-- NAME -->

                    <h4 style="font-weight:700;">

                        <%=similarName%>

                    </h4>


                    <!-- LOCATION -->

                    <p class="text-muted"
                       style="min-height:48px;">

                        📍 <%=similarLocation%>

                    </p>


                    <!-- PRICE -->

                    <div class="d-flex justify-content-between
                                align-items-center mt-4">

                        <div>

                            <small class="text-muted">
                                Rent From
                            </small>

                            <div
                                style="
                                    font-size:22px;
                                    font-weight:700;
                                    color:#198754;
                                ">

                                ₹<%=similarPrice%>/Day

                            </div>

                        </div>


                        <a
                            href="rentProduct.jsp?id=<%=similarId%>"
                            class="btn btn-primary rounded-3 px-3">

                            View Product

                        </a>

                    </div>


                </div>

            </div>

        </div>


        <%
        }
        %>


    </div>

</div>


<%
}
%>

</div>
</div>
</body>

</html>
