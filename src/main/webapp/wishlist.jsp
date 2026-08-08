<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.text.DecimalFormat"%>

<%
    /* =====================================================
       LOGIN SECURITY
    ===================================================== */

    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    ResultSet wishlist =
        (ResultSet) request.getAttribute("wishlist");

    DecimalFormat df = new DecimalFormat("#,##0");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>My Wishlist | RentEasy</title>


<!-- =====================================================
     BOOTSTRAP
===================================================== -->

<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">


<!-- =====================================================
     BOOTSTRAP ICONS
===================================================== -->

<link
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">


<!-- =====================================================
     YOUR EXISTING DASHBOARD CSS
===================================================== -->

<link rel="stylesheet"
      href="css/dashboard.css">


<style>

/* =====================================================
   PAGE
===================================================== */

body {

    margin: 0;

    background: #f5f7fb;

    font-family: 'Segoe UI', sans-serif;

    color: #111827;

}


/* =====================================================
   MAIN CONTENT

   Navbar height approximately 80px
   Sidebar width approximately 270px
===================================================== */

.wishlist-main {

    margin-left: 270px;

    padding:

        110px
        36px
        50px
        36px;

    min-height: 100vh;

}


/* =====================================================
   PAGE HEADER
===================================================== */

.page-heading {

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 20px;

    margin-bottom: 25px;

}


.page-heading h2 {

    font-size: 28px;

    font-weight: 700;

    margin: 0 0 5px 0;

    color: #111827;

}


.page-heading p {

    margin: 0;

    color: #64748b;

    font-size: 15px;

}


.wishlist-count {

    background: #ffffff;

    border: 1px solid #e2e8f0;

    padding: 10px 16px;

    border-radius: 12px;

    font-size: 14px;

    color: #475569;

    box-shadow:

        0 2px 8px
        rgba(15, 23, 42, .04);

}


/* =====================================================
   WISHLIST HERO
===================================================== */

.wishlist-hero {

    position: relative;

    overflow: hidden;

    background:

        linear-gradient(
            135deg,
            #2563eb 0%,
            #3b82f6 100%
        );

    border-radius: 22px;

    padding: 34px 38px;

    margin-bottom: 30px;

    color: white;

    box-shadow:

        0 10px 30px
        rgba(37, 99, 235, .15);

}


.wishlist-hero::after {

    content: "";

    position: absolute;

    width: 260px;

    height: 260px;

    border-radius: 50%;

    background:

        rgba(255,255,255,.08);

    right: -70px;

    top: -100px;

}


.hero-content {

    position: relative;

    z-index: 2;

}


.hero-icon {

    width: 52px;

    height: 52px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 14px;

    background:

        rgba(255,255,255,.17);

    font-size: 25px;

    margin-bottom: 17px;

}


.wishlist-hero h1 {

    font-size: 30px;

    font-weight: 700;

    margin-bottom: 8px;

}


.wishlist-hero p {

    margin: 0;

    font-size: 15px;

    opacity: .90;

}


/* =====================================================
   SECTION HEADER
===================================================== */

.products-section {

    margin-top: 10px;

}


.section-heading {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 18px;

}


.section-heading h3 {

    margin: 0;

    font-size: 21px;

    font-weight: 700;

}


.section-heading h3 i {

    color: #2563eb;

    margin-right: 6px;

}


.browse-small-btn {

    text-decoration: none;

    border: 1px solid #2563eb;

    color: #2563eb;

    padding: 9px 15px;

    border-radius: 9px;

    font-size: 14px;

    font-weight: 600;

    transition: .2s;

}


.browse-small-btn:hover {

    background: #2563eb;

    color: white;

}


/* =====================================================
   PRODUCT CARD
===================================================== */

.wishlist-product-card {

    position: relative;

    background: #ffffff;

    border: 1px solid #e8edf5;

    border-radius: 17px;

    overflow: hidden;

    height: 100%;

    box-shadow:

        0 4px 16px
        rgba(15,23,42,.06);

    transition:

        transform .25s ease,
        box-shadow .25s ease;

}


.wishlist-product-card:hover {

    transform: translateY(-5px);

    box-shadow:

        0 12px 28px
        rgba(15,23,42,.11);

}


/* =====================================================
   PRODUCT IMAGE
===================================================== */

.product-image-wrapper {

    position: relative;

    height: 210px;

    overflow: hidden;

    background: #f1f5f9;

}


.product-image {

    width: 100%;

    height: 100%;

    object-fit: cover;

    transition: transform .35s ease;

}


.wishlist-product-card:hover
.product-image {

    transform: scale(1.04);

}


/* =====================================================
   CATEGORY BADGE
===================================================== */

.category-badge {

    position: absolute;

    left: 14px;

    top: 14px;

    background:

        rgba(255,255,255,.94);

    color: #2563eb;

    border-radius: 20px;

    padding: 6px 11px;

    font-size: 11px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: .3px;

    box-shadow:

        0 2px 8px
        rgba(0,0,0,.08);

}


/* =====================================================
   HEART BUTTON
===================================================== */

.remove-form {

    position: absolute;

    right: 14px;

    top: 14px;

    z-index: 5;

}


.heart-button {

    width: 40px;

    height: 40px;

    border: none;

    border-radius: 50%;

    background: #ffffff;

    color: #ef4444;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 19px;

    cursor: pointer;

    box-shadow:

        0 3px 12px
        rgba(15,23,42,.15);

    transition: .2s;

}


.heart-button:hover {

    background: #fee2e2;

    transform: scale(1.08);

}


/* =====================================================
   PRODUCT INFORMATION
===================================================== */

.product-content {

    padding: 18px;

}


.product-title {

    font-size: 18px;

    font-weight: 700;

    color: #111827;

    margin-bottom: 8px;

    white-space: nowrap;

    overflow: hidden;

    text-overflow: ellipsis;

}


.product-location {

    display: flex;

    gap: 5px;

    align-items: flex-start;

    color: #64748b;

    font-size: 13px;

    min-height: 38px;

    margin-bottom: 14px;

}


.product-location i {

    color: #2563eb;

    margin-top: 2px;

}


/* =====================================================
   PRICE
===================================================== */

.price-row {

    display: flex;

    justify-content: space-between;

    align-items: flex-end;

    padding-top: 13px;

    border-top: 1px solid #edf0f5;

}


.rental-label {

    font-size: 12px;

    color: #94a3b8;

    margin-bottom: 2px;

}


.product-price {

    font-size: 20px;

    font-weight: 700;

    color: #111827;

}


.product-price span {

    font-size: 12px;

    font-weight: 400;

    color: #64748b;

}


.deposit-box {

    text-align: right;

}


.deposit-label {

    font-size: 11px;

    color: #94a3b8;

}


.deposit-value {

    font-size: 13px;

    font-weight: 600;

    color: #475569;

}


/* =====================================================
   VIEW PRODUCT BUTTON
===================================================== */

.product-actions {

    margin-top: 16px;

}


.view-product-btn {

    display: flex;

    justify-content: center;

    align-items: center;

    gap: 7px;

    width: 100%;

    padding: 10px;

    border-radius: 9px;

    background: #2563eb;

    color: white;

    text-decoration: none;

    font-size: 14px;

    font-weight: 600;

    transition: .2s;

}


.view-product-btn:hover {

    background: #1d4ed8;

    color: white;

}


/* =====================================================
   EMPTY WISHLIST
===================================================== */

.empty-wishlist {

    background: white;

    border: 1px solid #e8edf5;

    border-radius: 20px;

    padding: 65px 30px;

    text-align: center;

    box-shadow:

        0 4px 18px
        rgba(15,23,42,.05);

}


.empty-icon {

    width: 85px;

    height: 85px;

    margin:

        0 auto
        22px auto;

    display: flex;

    justify-content: center;

    align-items: center;

    background: #eff6ff;

    color: #2563eb;

    border-radius: 50%;

    font-size: 38px;

}


.empty-wishlist h3 {

    font-size: 23px;

    font-weight: 700;

    margin-bottom: 8px;

}


.empty-wishlist p {

    color: #64748b;

    font-size: 14px;

    margin-bottom: 23px;

}


.empty-browse-btn {

    display: inline-flex;

    align-items: center;

    gap: 8px;

    background: #2563eb;

    color: white;

    padding: 11px 20px;

    border-radius: 9px;

    text-decoration: none;

    font-weight: 600;

    font-size: 14px;

}


.empty-browse-btn:hover {

    background: #1d4ed8;

    color: white;

}


/* =====================================================
   RESPONSIVE
===================================================== */

@media(max-width: 991px) {

    .wishlist-main {

        margin-left: 0;

        padding:

            100px
            20px
            40px
            20px;

    }

}


@media(max-width: 600px) {

    .wishlist-main {

        padding-left: 14px;

        padding-right: 14px;

    }


    .wishlist-hero {

        padding: 27px 24px;

    }


    .wishlist-hero h1 {

        font-size: 25px;

    }


    .page-heading {

        align-items: flex-start;

        flex-direction: column;

    }

}

</style>

</head>


<body>


<!-- =====================================================
     RENT EASY NAVBAR
===================================================== -->

<jsp:include page="includes/navbar.jsp"/>


<!-- =====================================================
     RENT EASY SIDEBAR
===================================================== -->

<jsp:include page="includes/sidebar.jsp"/>


<!-- =====================================================
     MAIN CONTENT
===================================================== -->

<main class="wishlist-main">


<!-- =====================================================
     PAGE HEADING
===================================================== -->

<div class="page-heading">

    <div>

        <h2>

            My Wishlist

        </h2>

        <p>

            Products you've saved for later.

        </p>

    </div>

</div>


<!-- =====================================================
     HERO
===================================================== -->

<div class="wishlist-hero">

    <div class="hero-content">

        <div class="hero-icon">

            <i class="bi bi-heart-fill"></i>

        </div>

        <h1>

            Your Favourite Products

        </h1>

        <p>

            Keep your favourite rental products
            in one place and rent them whenever
            you're ready.

        </p>

    </div>

</div>


<%

boolean hasProducts = false;

int wishlistCount = 0;

%>


<!-- =====================================================
     PRODUCT GRID
===================================================== -->

<div class="products-section">


<div class="section-heading">

    <h3>

        <i class="bi bi-heart"></i>

        Saved Products

    </h3>


    <!-- IMPORTANT:
         Change this URL only if your existing
         Browse Products page uses another servlet.
    -->

    <a href="products.jsp"
       class="browse-small-btn">

        <i class="bi bi-grid"></i>

        Browse Products

    </a>

</div>


<div class="row g-4">


<%

if (wishlist != null) {

    while (wishlist.next()) {

        hasProducts = true;

        wishlistCount++;

        int productId =
            wishlist.getInt("product_id");


        String name =
            wishlist.getString("name");


        String image =
            wishlist.getString("image");


        String category =
            wishlist.getString("category");


        String location =
            wishlist.getString("location");


        double price =
            wishlist.getDouble("price");


        double deposit =
            wishlist.getDouble("deposit");


        if (name == null)
            name = "Rental Product";


        if (category == null ||
            category.trim().isEmpty())

            category = "Product";


        if (location == null ||
            location.trim().isEmpty())

            location =
                "Location not specified";

%>


<!-- =====================================================
     PRODUCT
===================================================== -->

<div class="col-xl-3 col-lg-4 col-md-6">


<div class="wishlist-product-card">


<!-- =====================================================
     IMAGE
===================================================== -->

<div class="product-image-wrapper">


    <img
        src="<%=image%>"
        class="product-image"
        alt="<%=name%>">


    <!-- CATEGORY -->

    <span class="category-badge">

        <%=category%>

    </span>


    <!-- =================================================
         REMOVE HEART
    ================================================== -->

    <form
        action="WishlistServlet"
        method="post"
        class="remove-form">


        <input
            type="hidden"
            name="productId"
            value="<%=productId%>">


        <input
            type="hidden"
            name="action"
            value="remove">


        <button
            type="submit"
            class="heart-button"
            title="Remove from Wishlist">

            <i class="bi bi-heart-fill"></i>

        </button>


    </form>


</div>


<!-- =====================================================
     PRODUCT BODY
===================================================== -->

<div class="product-content">


    <div class="product-title">

        <%=name%>

    </div>


    <div class="product-location">

        <i class="bi bi-geo-alt-fill"></i>

        <span>

            <%=location%>

        </span>

    </div>


    <!-- PRICE -->

    <div class="price-row">


        <div>

            <div class="rental-label">

                Rental Price

            </div>


            <div class="product-price">

                ₹<%=df.format(price)%>

                <span>/ day</span>

            </div>

        </div>


        <div class="deposit-box">

            <div class="deposit-label">

                Deposit

            </div>

            <div class="deposit-value">

                ₹<%=df.format(deposit)%>

            </div>

        </div>


    </div>


    <!-- =================================================
         ACTION
    ================================================== -->

    <div class="product-actions">


        <!-- Change URL here ONLY if your existing
             product-details flow uses another URL -->

        <a
            href="productDetails.jsp?id=<%=productId%>"
            class="view-product-btn">

            <i class="bi bi-eye"></i>

            View Product

        </a>


    </div>


</div>


</div>


</div>


<%

    }

}

%>


</div>


<!-- =====================================================
     EMPTY WISHLIST
===================================================== -->

<%

if (!hasProducts) {

%>


<div class="empty-wishlist">


    <div class="empty-icon">

        <i class="bi bi-heart"></i>

    </div>


    <h3>

        Your Wishlist is Empty

    </h3>


    <p>

        Save products you're interested in
        and they'll appear here for quick access.

    </p>


    <!-- IMPORTANT:
         Use your actual Browse Products URL
         if it is different.
    -->

    <a
        href="products.jsp"
        class="empty-browse-btn">

        <i class="bi bi-grid"></i>

        Browse Products

    </a>


</div>


<%

}

%>


</div>


</main>


<script
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>