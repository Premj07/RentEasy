<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%
ArrayList<HashMap<String,Object>> products =
    (ArrayList<HashMap<String,Object>>)
    request.getAttribute("products");

String selectedCategory =
    (String) request.getAttribute("selectedCategory");

if(selectedCategory == null){
    selectedCategory = "Products";
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
<%=selectedCategory%> | RentEasy
</title>

<!-- Bootstrap -->
<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
rel="stylesheet">

<!-- Bootstrap Icons -->
<link
rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Dashboard CSS -->
<link
rel="stylesheet"
href="<%=request.getContextPath()%>/css/dashboard.css">

<style>

/* =========================================
   PAGE
========================================= */

body{
    margin:0;
    background:#f4f7fc;
    font-family:
        Inter,
        Arial,
        sans-serif;
    color:#101828;
}

.category-page{
    padding-top:100px;
    min-height:100vh;
}

/* =========================================
   MAIN CONTENT
========================================= */

.category-content{
    margin-left:270px;
    padding:35px 45px 60px;
}

/* =========================================
   BACK BUTTON
========================================= */

.back-dashboard{
    display:inline-flex;
    align-items:center;
    gap:8px;

    color:#2563eb;
    text-decoration:none;

    font-size:15px;
    font-weight:600;

    margin-bottom:22px;

    transition:.2s;
}

.back-dashboard:hover{
    color:#174bb8;
    transform:translateX(-3px);
}

/* =========================================
   HEADER
========================================= */

.category-header{
    background:
        linear-gradient(
            135deg,
            #2563eb,
            #3b82f6
        );

    border-radius:24px;

    padding:32px 36px;

    color:white;

    margin-bottom:35px;

    box-shadow:
        0 15px 35px
        rgba(37,99,235,.15);
}

.category-header-top{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:20px;
}

.category-header h1{
    font-size:32px;
    font-weight:750;
    margin:0 0 8px;
}

.category-header p{
    margin:0;
    font-size:16px;
    opacity:.9;
}

.category-icon{
    width:65px;
    height:65px;

    display:flex;
    align-items:center;
    justify-content:center;

    background:rgba(255,255,255,.18);

    border-radius:18px;

    font-size:30px;
}

/* =========================================
   RESULT INFORMATION
========================================= */

.result-row{
    display:flex;
    justify-content:space-between;
    align-items:center;

    margin-bottom:22px;
}

.result-title{
    font-size:22px;
    font-weight:700;
}

.result-count{
    background:#e8f0ff;
    color:#2563eb;

    padding:8px 16px;

    border-radius:30px;

    font-size:14px;
    font-weight:600;
}

/* =========================================
   PRODUCT GRID
========================================= */

.product-grid{
    display:grid;

    grid-template-columns:
        repeat(
            auto-fill,
            minmax(270px,1fr)
        );

    gap:25px;
}

/* =========================================
   PRODUCT CARD
========================================= */

.product-card{
    background:white;

    border-radius:20px;

    overflow:hidden;

    border:1px solid #edf0f5;

    box-shadow:
        0 7px 25px
        rgba(16,24,40,.06);

    transition:
        transform .25s ease,
        box-shadow .25s ease;
}

.product-card:hover{
    transform:translateY(-6px);

    box-shadow:
        0 15px 35px
        rgba(16,24,40,.12);
}

/* =========================================
   IMAGE
========================================= */

.product-image-box{
    height:240px;

    position:relative;

    background:#f7f8fa;

    overflow:hidden;
}

.product-image{
    width:100%;
    height:100%;

    object-fit:cover;

    transition:.35s;
}

.product-card:hover
.product-image{
    transform:scale(1.04);
}

/* =========================================
   CATEGORY BADGE
========================================= */

.product-category{
    position:absolute;

    top:16px;
    left:16px;

    background:#2563eb;
    color:white;

    border-radius:20px;

    padding:6px 13px;

    font-size:12px;
    font-weight:600;
}

/* =========================================
   WISHLIST
========================================= */

.wishlist-button{
    position:absolute;

    top:15px;
    right:15px;

    width:40px;
    height:40px;

    border-radius:50%;

    border:none;

    background:white;

    display:flex;
    align-items:center;
    justify-content:center;

    font-size:19px;

    color:#ef4444;

    box-shadow:
        0 3px 12px
        rgba(0,0,0,.12);

    cursor:pointer;

    transition:.2s;
}

.wishlist-button:hover{
    background:#fff1f2;
    transform:scale(1.08);
}

/* =========================================
   PRODUCT INFORMATION
========================================= */

.product-info{
    padding:20px;
}

.product-name{
    font-size:19px;
    font-weight:700;

    margin-bottom:10px;

    color:#111827;
}

.product-location{
    display:flex;
    align-items:flex-start;
    gap:7px;

    min-height:45px;

    color:#667085;

    font-size:14px;

    line-height:1.45;
}

.product-location i{
    color:#2563eb;
    margin-top:2px;
}

/* =========================================
   PRICE
========================================= */

.product-bottom{
    margin-top:18px;

    display:flex;
    justify-content:space-between;
    align-items:flex-end;

    gap:10px;
}

.price{
    color:#2563eb;

    font-size:22px;
    font-weight:750;
}

.per-day{
    color:#667085;
    font-size:13px;
    margin-top:2px;
}

/* =========================================
   RENT BUTTON
========================================= */

.rent-button{
    display:inline-flex;

    align-items:center;
    justify-content:center;

    gap:7px;

    background:#2563eb;
    color:white;

    text-decoration:none;

    padding:11px 17px;

    border-radius:10px;

    font-size:14px;
    font-weight:600;

    transition:.2s;
}

.rent-button:hover{
    background:#1d4ed8;
    color:white;

    transform:translateY(-1px);
}

/* =========================================
   EMPTY STATE
========================================= */

.empty-state{
    grid-column:1/-1;

    background:white;

    border-radius:22px;

    padding:70px 30px;

    text-align:center;

    border:1px solid #edf0f5;
}

.empty-icon{
    width:85px;
    height:85px;

    margin:0 auto 20px;

    border-radius:50%;

    display:flex;
    align-items:center;
    justify-content:center;

    background:#eef4ff;

    color:#2563eb;

    font-size:35px;
}

.empty-state h3{
    font-weight:700;
    margin-bottom:8px;
}

.empty-state p{
    color:#667085;
    margin-bottom:22px;
}

.browse-button{
    display:inline-flex;

    align-items:center;
    gap:8px;

    background:#2563eb;
    color:white;

    text-decoration:none;

    padding:12px 22px;

    border-radius:10px;

    font-weight:600;
}

.browse-button:hover{
    background:#1d4ed8;
    color:white;
}

/* =========================================
   RESPONSIVE
========================================= */

@media(max-width:900px){

    .category-content{
        margin-left:0;
        padding:25px 20px;
    }

}

@media(max-width:600px){

    .category-header{
        padding:25px;
    }

    .category-header h1{
        font-size:25px;
    }

    .product-grid{
        grid-template-columns:1fr;
    }

}

</style>

</head>

<body>

<!-- =========================================
     NAVBAR
========================================= -->

<jsp:include page="includes/navbar.jsp"/>

<!-- =========================================
     SIDEBAR
========================================= -->

<jsp:include page="includes/sidebar.jsp"/>

<div class="category-page">

<div class="category-content">

<!-- =========================================
     BACK
========================================= -->

<a
href="<%=request.getContextPath()%>/dashboard.jsp"
class="back-dashboard">

<i class="bi bi-arrow-left"></i>

Back to Dashboard

</a>


<!-- =========================================
     CATEGORY HEADER
========================================= -->

<div class="category-header">

<div class="category-header-top">

<div>

<h1>
<%=selectedCategory%>
</h1>

<p>
Explore available
<%=selectedCategory%>
products on RentEasy.
</p>

</div>

<div class="category-icon">

<%
if("Electronics".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-phone"></i>

<%
}
else if("Furniture".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-house-door"></i>

<%
}
else if("Books".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-book"></i>

<%
}
else if("Sports".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-dribbble"></i>

<%
}
else if("Laptops".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-laptop"></i>

<%
}
else if("Appliances".equalsIgnoreCase(selectedCategory)){
%>

<i class="bi bi-tv"></i>

<%
}
else{
%>

<i class="bi bi-grid"></i>

<%
}
%>

</div>

</div>

</div>


<!-- =========================================
     RESULT HEADER
========================================= -->

<div class="result-row">

<div class="result-title">

Available <%=selectedCategory%>

</div>

<div class="result-count">

<%
int total =
    products == null
    ? 0
    : products.size();
%>

<%=total%> Products

</div>

</div>


<!-- =========================================
     PRODUCT GRID
========================================= -->

<div class="product-grid">

<%

if(products != null &&
   !products.isEmpty()){

for(HashMap<String,Object> p : products){

    int productId =
        ((Number)p.get("id")).intValue();

    String name =
        String.valueOf(p.get("name"));

    int price =
        ((Number)p.get("price")).intValue();

    String image =
        String.valueOf(p.get("image"));

    String location =
        String.valueOf(p.get("location"));

    String category =
        String.valueOf(p.get("category"));

%>


<div class="product-card">


<!-- IMAGE -->

<div class="product-image-box">

<img
src="<%=request.getContextPath()%>/<%=image%>"
class="product-image"
alt="<%=name%>">


<!-- CATEGORY -->

<span class="product-category">

<%=category%>

</span>


<!-- WISHLIST -->

<form action="<%=request.getContextPath()%>/WishlistServlet"
      method="post"
      class="wishlist-form">

    <input type="hidden"
           name="productId"
           value="<%=productId%>">

    <input type="hidden"
           name="action"
           value="add">

    <input type="hidden"
           name="redirect"
           value="category">

    <input type="hidden"
           name="category"
           value="<%=selectedCategory%>">

    <button type="submit"
            class="wishlist-button"
            title="Add to Wishlist">

        <i class="bi bi-heart"></i>

    </button>

</form>

</div>


<!-- PRODUCT DETAILS -->

<div class="product-info">

<div class="product-name">

<%=name%>

</div>


<div class="product-location">

<i class="bi bi-geo-alt"></i>

<span>
<%=location%>
</span>

</div>


<div class="product-bottom">


<div>

<div class="price">

₹<%=price%>

</div>

<div class="per-day">

/ Day

</div>

</div>


<a
href="<%=request.getContextPath()%>/rentProduct.jsp?id=<%=productId%>"
class="rent-button">

<i class="bi bi-cart3"></i>

Rent Now

</a>


</div>

</div>

</div>


<%
}

}else{
%>


<!-- =========================================
     NO PRODUCTS
========================================= -->

<div class="empty-state">

<div class="empty-icon">

<i class="bi bi-box-seam"></i>

</div>

<h3>
No <%=selectedCategory%> Available
</h3>

<p>
There are currently no available products
in this category.
</p>

<a
href="<%=request.getContextPath()%>/dashboard.jsp"
class="browse-button">

<i class="bi bi-arrow-left"></i>

Back to Dashboard

</a>

</div>


<%
}
%>


</div>

</div>

</div>

</body>
</html>