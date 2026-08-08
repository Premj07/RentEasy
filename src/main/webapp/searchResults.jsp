<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="com.renteasy.dao.RecentlyViewedDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.*"%>
<%@ page import="com.renteasy.dao.AISearchHistoryDAO" %>
<%

ArrayList<HashMap<String,Object>> products =
(ArrayList<HashMap<String,Object>>)request.getAttribute("products");

String query=(String)request.getAttribute("query");

if(query==null)
query="";

int totalResults=0;

if(products!=null)
totalResults=products.size();

%>
<%
Integer userId = (Integer) session.getAttribute("userId");

RecentlyViewedDAO recentDAO = new RecentlyViewedDAO();

ResultSet recentRs = null;

if(userId != null){
    recentRs = recentDAO.getRecentlyViewed(userId);
}
%>
<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>AI Search | RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
rel="stylesheet">

<link rel="stylesheet"
href="css/dashboard.css">

<style>

body{

background:#f4f7fc;

font-family:'Segoe UI',sans-serif;

overflow-x:hidden;

}

/*==========================
MAIN CONTENT
==========================*/

.main-content{

margin-left:260px;

margin-top:95px;

padding:35px;

}

/*==========================
HERO
==========================*/

.ai-hero{

background:linear-gradient(135deg,#2563eb,#4f8dfd);

border-radius:28px;

padding:45px;

position:relative;

overflow:hidden;

box-shadow:0 15px 35px rgba(37,99,235,.25);

margin-bottom:35px;

color:#fff;

}

.ai-hero::before{

content:"";

position:absolute;

width:320px;

height:320px;

background:rgba(255,255,255,.08);

border-radius:50%;

top:-120px;

right:-80px;

}

.ai-hero::after{

content:"";

position:absolute;

width:180px;

height:180px;

background:rgba(255,255,255,.05);

border-radius:50%;

bottom:-70px;

left:-50px;

}

.ai-title{

font-size:42px;

font-weight:700;

margin-bottom:10px;

position:relative;

z-index:2;

}

.ai-sub{

font-size:18px;

opacity:.95;

position:relative;

z-index:2;

}

.ai-chip{

display:inline-block;

background:rgba(255,255,255,.15);

padding:8px 18px;

border-radius:50px;

margin-bottom:20px;

backdrop-filter:blur(8px);

font-weight:600;

}

/*==========================
SEARCH BOX
==========================*/

.search-card{

background:#fff;

padding:25px;

border-radius:20px;

margin-top:-45px;

position:relative;

z-index:5;

box-shadow:0 10px 30px rgba(0,0,0,.08);

}

.search-input{

height:60px;

border-radius:50px;

font-size:18px;

padding-left:25px;

}

.search-btn{

height:60px;

border-radius:50px;

padding:0 35px;

font-weight:600;

}

/*==========================
STATS
==========================*/

.stats{

margin-top:30px;

}

.stat-box{

background:white;

padding:25px;

border-radius:20px;

box-shadow:0 5px 18px rgba(0,0,0,.08);

text-align:center;

transition:.25s;

}

.stat-box:hover{

transform:translateY(-5px);

}

.stat-box i{

font-size:34px;

color:#2563eb;

margin-bottom:12px;

}

.stat-value{

font-size:32px;

font-weight:700;

color:#111827;

}

.stat-label{

color:#64748b;

font-size:15px;

}

/*==========================
BUTTONS
==========================*/

.action-btn{

border-radius:40px;

padding:12px 22px;

font-weight:600;

}
/*=========================
PRODUCT CARD
=========================*/

.ai-product-card{

background:white;

border-radius:22px;

overflow:hidden;

box-shadow:0 8px 30px rgba(0,0,0,.08);

transition:.35s;

height:100%;

}

.ai-product-card:hover{

transform:translateY(-10px);

box-shadow:0 15px 40px rgba(0,0,0,.15);

}

.product-image-box{

position:relative;

height:240px;

overflow:hidden;

}

.product-image{

width:100%;

height:100%;

object-fit:cover;

transition:.5s;

}

.ai-product-card:hover .product-image{

transform:scale(1.08);

}

.category-tag{

position:absolute;

top:18px;

left:18px;

background:#2563eb;

color:white;

padding:8px 16px;

border-radius:30px;

font-size:13px;

font-weight:600;

}

.wishlist-btn{

position:absolute;

top:18px;

right:18px;

width:48px;

height:48px;

border:none;

border-radius:50%;

background:white;

color:#ef4444;

font-size:22px;

box-shadow:0 5px 15px rgba(0,0,0,.15);

transition:.25s;

}

.wishlist-btn:hover{

background:#ef4444;

color:white;

transform:scale(1.1);

}

.product-content{

padding:24px;

}

.ai-score{

background:#eef4ff;

padding:16px;

border-radius:14px;

margin-top:20px;

}

.empty-card{

background:white;

padding:80px;

border-radius:25px;

text-align:center;

box-shadow:0 10px 30px rgba(0,0,0,.08);

}
/*==========================
FILTERS
==========================*/

.filter-container{

background:white;

padding:22px;

border-radius:18px;

margin-top:30px;

margin-bottom:25px;

box-shadow:0 6px 18px rgba(0,0,0,.08);

}

.chip-group{

display:flex;

flex-wrap:wrap;

gap:12px;

}

.filter-chip{

border:none;

background:#eef4ff;

padding:10px 18px;

border-radius:30px;

font-weight:600;

transition:.25s;

}

.filter-chip:hover{

background:#2563eb;

color:white;

}

.active-chip{

background:#2563eb;

color:white;

}

.ai-select{

height:48px;

border-radius:12px;

}

.price-filter-card{

margin-top:25px;

margin-bottom:25px;

background:white;

padding:25px;

border-radius:18px;

box-shadow:0 6px 18px rgba(0,0,0,.08);

}

.analytics-card{

margin-top:25px;

margin-bottom:40px;

}

.analytics-box{

background:white;

border-radius:18px;

padding:30px;

text-align:center;

box-shadow:0 6px 18px rgba(0,0,0,.08);

transition:.25s;

}

.analytics-box:hover{

transform:translateY(-6px);

}

.analytics-box h2{

font-size:34px;

font-weight:bold;

color:#2563eb;

}
/*====================================
AI INFO CARDS
====================================*/

.ai-info-card{

background:white;

border-radius:20px;

overflow:hidden;

box-shadow:0 8px 25px rgba(0,0,0,.08);

margin-bottom:25px;

}

.card-header-ai{

padding:18px;

font-size:20px;

font-weight:700;

color:white;

}

.ai-list{

list-style:none;

padding:20px;

margin:0;

}

.ai-list li{

display:flex;

justify-content:space-between;

padding:12px 0;

border-bottom:1px solid #eee;

font-weight:600;

}

.tip-box{

background:#f4f7fc;

padding:16px;

margin:15px;

border-radius:14px;

}

.category-box{

background:white;

padding:28px;

border-radius:20px;

text-align:center;

font-size:38px;

box-shadow:0 6px 18px rgba(0,0,0,.08);

transition:.3s;

cursor:pointer;

}

.category-box:hover{

transform:translateY(-8px);

background:#2563eb;

color:white;

}

.category-box h6{

margin-top:12px;

font-weight:700;

}

.recent-search-card{

background:white;

padding:30px;

border-radius:20px;

box-shadow:0 8px 25px rgba(0,0,0,.08);

}

.recent-chip{

display:inline-block;

background:#eef4ff;

padding:10px 18px;

border-radius:30px;

margin:8px;

font-weight:600;

transition:.3s;

}

.recent-chip:hover{

background:#2563eb;

color:white;

}

.section-title h2{

font-weight:700;

}

.section-title p{

color:#6b7280;

}
/*==========================
FLOATING AI BUTTON
==========================*/

.ai-float-btn{

position:fixed;

bottom:35px;

right:35px;

width:70px;

height:70px;

border-radius:50%;

background:linear-gradient(135deg,#2563eb,#5f8cff);

color:white;

display:flex;

justify-content:center;

align-items:center;

font-size:32px;

cursor:pointer;

box-shadow:0 15px 35px rgba(37,99,235,.35);

z-index:9999;

transition:.3s;

animation:floatAI 2.5s infinite;

}

.ai-float-btn:hover{

transform:scale(1.1);

}

@keyframes floatAI{

0%{

transform:translateY(0);

}

50%{

transform:translateY(-10px);

}

100%{

transform:translateY(0);

}

}

.ai-chat-box{

display:none;

position:fixed;

bottom:120px;

right:35px;

width:340px;

background:white;

border-radius:20px;

box-shadow:0 15px 40px rgba(0,0,0,.15);

overflow:hidden;

z-index:9999;

}

.ai-chat-header{

background:#2563eb;

color:white;

padding:18px;

font-size:20px;

font-weight:bold;

}

.ai-chat-body{

padding:20px;

}

.ai-msg{

background:#eef4ff;

padding:12px;

border-radius:12px;

margin-bottom:12px;

}

.ai-chip-chat{

display:inline-block;

padding:10px 16px;

background:#f4f7fc;

border-radius:30px;

margin:6px;

cursor:pointer;

transition:.25s;

}

.ai-chip-chat:hover{

background:#2563eb;

color:white;

}

.search-footer{

margin-top:70px;

padding:40px;

background:#111827;

color:white;

border-radius:25px;

}

.footer-link{

color:white;

margin-left:25px;

text-decoration:none;

font-weight:600;

}

.footer-link:hover{

color:#60a5fa;

}
/* =========================================
   REAL RECENT AI SEARCHES
========================================= */

.recent-search-section{
    background:#ffffff;
    border-radius:24px;
    padding:32px 42px;
    margin-top:35px;
    margin-bottom:35px;
    box-shadow:0 10px 35px rgba(15,23,42,0.06);
}

.recent-search-title{
    font-size:27px;
    font-weight:700;
    color:#111827;
    margin-bottom:22px;
}

.recent-search-chips{
    display:flex;
    align-items:center;
    gap:16px;
    flex-wrap:wrap;
}

.recent-search-chip{
    display:inline-flex;
    align-items:center;
    justify-content:center;

    padding:13px 23px;

    background:#edf3ff;

    color:#111827;

    border-radius:30px;

    font-size:16px;
    font-weight:600;

    text-decoration:none;

    border:1px solid transparent;

    transition:all .25s ease;
}

.recent-search-chip:hover{
    background:#2563eb;
    color:#ffffff;

    transform:translateY(-2px);

    box-shadow:0 7px 18px rgba(37,99,235,.20);
}

.no-search-history{
    color:#64748b;
    font-size:15px;
}

</style>

</head>
<script>

const slider=document.getElementById("priceSlider");

const value=document.getElementById("priceValue");

slider.oninput=function(){

value.innerHTML=this.value;

}

</script>
<body>

<jsp:include page="includes/navbar.jsp"/>

<jsp:include page="includes/sidebar.jsp"/>

<div class="main-content">

<div class="ai-hero">

<div class="ai-chip">

🤖 AI Powered Smart Search

</div>

<h1 class="ai-title">

Search Results

</h1>

<p class="ai-sub">

Showing intelligent recommendations based on your search.

</p>

</div>

<div class="search-card">

<form
action="SmartSearchServlet"
method="get">

<div class="row align-items-center">

<div class="col-lg-8">

<input

type="text"

name="query"

value="<%=query%>"

class="form-control search-input"

placeholder="Search like 'Laptop under 500 near MIT ADT'">

</div>

<div class="col-lg-2 d-grid">

<button
class="btn btn-primary search-btn">

<i class="bi bi-search"></i>

Search

</button>

</div>

<div class="col-lg-2 d-grid">

<a href="dashboard.jsp"

class="btn btn-outline-secondary search-btn">

<i class="bi bi-house"></i>

Dashboard

</a>

</div>

</div>

</form>

</div>

<div class="row stats">

<div class="col-md-3">

<div class="stat-box">

<i class="bi bi-box-seam"></i>

<div class="stat-value">

<%=totalResults%>

</div>

<div class="stat-label">

Products Found

</div>

</div>

</div>

<div class="col-md-3">

<div class="stat-box">

<i class="bi bi-search-heart"></i>

<div class="stat-value">

AI

</div>

<div class="stat-label">

Search Engine

</div>

</div>

</div>

<div class="col-md-3">

<div class="stat-box">

<i class="bi bi-lightning-charge-fill"></i>

<div class="stat-value">

98%

</div>

<div class="stat-label">

Match Accuracy

</div>

</div>

</div>

<div class="col-md-3">

<div class="stat-box">

<i class="bi bi-stars"></i>

<div class="stat-value">

Premium

</div>

<div class="stat-label">

AI Experience

</div>

</div>

</div>

</div>

<!-- ========= PART 2 STARTS HERE ========= -->
<!-- =====================================================
AI SEARCH RESULTS
===================================================== -->

<div class="d-flex justify-content-between align-items-center mt-5 mb-4">

    <div>

        <h3 class="fw-bold">

            <i class="bi bi-stars text-primary"></i>

            AI Recommended Results

        </h3>

        <p class="text-muted">

            Showing <strong><%=totalResults%></strong>
            products for

            <strong>

                "<%=query%>"

            </strong>

        </p>

    </div>

    <div>

        <span class="badge bg-primary fs-6 px-3 py-2">

            🤖 AI Search

        </span>

    </div>

</div>

<div class="row">

<%

if(products!=null && !products.isEmpty()){

for(HashMap<String,Object> p : products){

%>

<div class="col-xl-4 col-lg-6 mb-4">

<div class="ai-product-card">

<!-- IMAGE -->

<div class="product-image-box">

<img

src="<%=request.getContextPath()%>/<%=p.get("image")%>"

class="product-image">

<div class="category-tag">

<%=p.get("category")%>

</div>

<form

action="WishlistServlet"

method="post"

class="wishlist-form">

<input
type="hidden"
name="productId"
value="<%=p.get("id")%>">

<input
type="hidden"
name="action"
value="add">

<input
type="hidden"
name="redirect"
value="search">

<button
class="wishlist-btn">

<i class="bi bi-heart-fill"></i>

</button>

</form>

</div>

<!-- BODY -->

<div class="product-content">

<h4 class="fw-bold">

<%=p.get("name")%>

</h4>

<p class="text-muted mb-2">

<i class="bi bi-geo-alt-fill text-danger"></i>

<%=p.get("location")%>

</p>

<div class="d-flex
justify-content-between
align-items-center
mb-3">

<div>

<h3 class="text-primary fw-bold">

₹<%=p.get("price")%>

</h3>

<small class="text-muted">

Per Day

</small>

</div>

<div>

<span class="badge bg-success">

Available

</span>

</div>

</div>

<!-- AI SCORE -->

<div class="ai-score">

<div class="d-flex
justify-content-between">

<span>

🤖 AI Match

</span>

<span>

98%

</span>

</div>

<div class="progress mt-2">

<div

class="progress-bar"

style="width:98%;">

</div>

</div>

</div>

<!-- BUTTONS -->

<div class="mt-4 d-grid gap-2">

<a

href="rentProduct.jsp?id=<%=p.get("id")%>"

class="btn btn-primary btn-lg">

<i class="bi bi-cart-check-fill"></i>

Rent Now

</a>

<a

href="productDetails.jsp?id=<%=p.get("id")%>"

class="btn btn-outline-primary">

<i class="bi bi-eye-fill"></i>

View Details

</a>

</div>

</div>

</div>

</div>

<%

}

}else{

%>

<div class="col-12">

<div class="empty-card">

<i class="bi bi-search display-1 text-primary"></i>

<h2 class="mt-4">

No Products Found

</h2>

<p class="text-muted">

Try searching:

Laptop under 500

Chair near MIT ADT

Camera below 300

</p>

<a

href="dashboard.jsp"

class="btn btn-primary btn-lg mt-3">

<i class="bi bi-arrow-left-circle"></i>

Back to Dashboard

</a>

</div>

</div>

<%

}

%>

</div>
<!-- =====================================================
AI FILTER BAR
===================================================== -->

<div class="filter-container">

    <div class="row align-items-center">

        <div class="col-lg-7">

            <div class="chip-group">

                <button class="filter-chip active-chip">

                    <i class="bi bi-grid"></i>

                    All

                </button>

                <button class="filter-chip">

                    💻 Electronics

                </button>

                <button class="filter-chip">

                    📚 Books

                </button>

                <button class="filter-chip">

                    🪑 Furniture

                </button>

                <button class="filter-chip">

                    🚲 Sports

                </button>

            </div>

        </div>

        <div class="col-lg-5">

            <div class="row">

                <div class="col-md-6">

                    <select class="form-select ai-select">

                        <option>

                            Sort By

                        </option>

                        <option>

                            AI Match

                        </option>

                        <option>

                            Lowest Price

                        </option>

                        <option>

                            Highest Price

                        </option>

                        <option>

                            Latest

                        </option>

                    </select>

                </div>

                <div class="col-md-6">

                    <select class="form-select ai-select">

                        <option>

                            Availability

                        </option>

                        <option>

                            Available

                        </option>

                        <option>

                            Out Of Stock

                        </option>

                    </select>

                </div>

            </div>

        </div>

    </div>

</div>

<!-- =====================================================
PRICE FILTER
===================================================== -->

<div class="price-filter-card">

<div class="row align-items-center">

<div class="col-md-3">

<h5>

💰 Budget Filter

</h5>

</div>

<div class="col-md-6">

<input

type="range"

class="form-range"

min="50"

max="5000"

value="5000"

id="priceSlider">

</div>

<div class="col-md-3 text-end">

<h4 class="text-primary">

₹

<span id="priceValue">

5000

</span>

</h4>

</div>

</div>

</div>

<!-- =====================================================
AI ANALYTICS
===================================================== -->

<div class="analytics-card">

<div class="row">

<div class="col-md-3">

<div class="analytics-box">

<h2>

98%

</h2>

<p>

AI Accuracy

</p>

</div>

</div>

<div class="col-md-3">

<div class="analytics-box">

<h2>

<%=totalResults%>

</h2>

<p>

Matched Products

</p>

</div>

</div>

<div class="col-md-3">

<div class="analytics-box">

<h2>

0.21s

</h2>

<p>

Search Time

</p>

</div>

</div>

<div class="col-md-3">

<div class="analytics-box">

<h2>

Smart

</h2>

<p>

Recommendation

</p>

</div>

</div>

</div>

</div>
<!-- =====================================================
AI RECOMMENDATION SECTION
===================================================== -->

<div class="mt-5">

<div class="section-title">

<h2>

🤖 AI Recommendations

</h2>

<p>

Based on your wishlist, rental history and smart behaviour.

</p>

</div>

</div>

<div class="row mt-4">

<!-- ========================= -->
<!-- TRENDING -->
<!-- ========================= -->

<div class="col-lg-4">

<div class="ai-info-card">

<div class="card-header-ai bg-danger">

🔥 Trending Products

</div>

<ul class="ai-list">

<li>

💻 Laptop

<span>

98%

</span>

</li>

<li>

📱 Mobile

<span>

96%

</span>

</li>

<li>

🚲 Bicycle

<span>

92%

</span>

</li>

<li>

🪑 Study Chair

<span>

90%

</span>

</li>

<li>

🖥️ Monitor

<span>

88%

</span>

</li>

</ul>

</div>

</div>

<!-- ========================= -->
<!-- RECENT -->
<!-- ========================= -->

<div class="col-lg-4">

<div class="ai-info-card">

<div class="card-header-ai bg-success">

🕒 Recently Viewed

</div>

<ul class="ai-list">

<%
if(recentRs != null && recentRs.isBeforeFirst()){

    while(recentRs.next()){
%>

<li>

    <div style="display:flex;justify-content:space-between;align-items:center;width:100%;">

        <div>

            <strong><%=recentRs.getString("name")%></strong>

            <br>

            <small style="color:#666;">
                <%=recentRs.getString("category")%>
            </small>

        </div>

        <span class="badge bg-success">
            Viewed
        </span>

    </div>

</li>

<%
    }

}else{
%>

<li style="text-align:center;padding:25px;">

    <i class="bi bi-clock-history"
       style="font-size:40px;color:#999;"></i>

    <br><br>

    <strong>No Recently Viewed Products</strong>

    <br>

    <small style="color:#666;">
        Open any product and it will appear here.
    </small>

</li>

<%
}
%>

</ul>

</div>

</div>

<!-- ========================= -->
<!-- AI TIPS -->
<!-- ========================= -->

<div class="col-lg-4">

<div class="ai-info-card">

<div class="card-header-ai bg-primary">

💡 AI Tips

</div>

<div class="tip-box">

✔ Rent products with higher ratings.

</div>

<div class="tip-box">

✔ Add products to Wishlist to improve AI recommendations.

</div>

<div class="tip-box">

✔ Search naturally like

<b>

Laptop under ₹500 near MIT ADT

</b>

</div>

<div class="tip-box">

✔ Frequently rented products appear first.

</div>

</div>

</div>

</div>

<!-- =====================================================
POPULAR CATEGORIES
===================================================== -->

<div class="mt-5">

<h3 class="fw-bold mb-4">

⭐ Popular Categories

</h3>

<div class="row">

<div class="col-md-2">

<div class="category-box">

💻

<h6>

Electronics

</h6>

</div>

</div>

<div class="col-md-2">

<div class="category-box">

📚

<h6>

Books

</h6>

</div>

</div>

<div class="col-md-2">

<div class="category-box">

🪑

<h6>

Furniture

</h6>

</div>

</div>

<div class="col-md-2">

<div class="category-box">

🚲

<h6>

Sports

</h6>

</div>

</div>

<div class="col-md-2">

<div class="category-box">

🎮

<h6>

Gaming

</h6>

</div>

</div>

<div class="col-md-2">

<div class="category-box">

📷

<h6>

Camera

</h6>

</div>

</div>

</div>

</div>

<!-- =====================================================
RECENT SEARCHES
===================================================== -->

<!-- =====================================================
FLOATING AI ASSISTANT
===================================================== -->

<div class="ai-float-btn" onclick="toggleAIChat()">

    <i class="bi bi-robot"></i>

</div>

<div class="ai-chat-box" id="aiChat">

    <div class="ai-chat-header">

        <i class="bi bi-stars"></i>

        RentEasy AI Assistant

    </div>

    <div class="ai-chat-body">

        <div class="ai-msg">

            👋 Hello!

        </div>

        <div class="ai-msg">

            Try asking:

        </div>

        <div class="ai-chip-chat">

            Laptop under ₹500

        </div>

        <div class="ai-chip-chat">

            Chair near MIT ADT

        </div>

        <div class="ai-chip-chat">

            Calculator for students

        </div>

        <div class="ai-chip-chat">

            Bicycle below ₹300

        </div>

    </div>

</div>

<!-- =====================================================
FOOTER
===================================================== -->

<footer class="search-footer">

<div class="row">

<div class="col-lg-6">

<h4>

RentEasy AI Search

</h4>

<p>

Powered by Smart Search, Recommendation Engine,
Wishlist Intelligence and AI Ranking.

</p>

</div>

<div class="col-lg-6 text-end">

<a href="dashboard.jsp"

class="footer-link">

Dashboard

</a>

<a href="products.jsp"

class="footer-link">

Products

</a>

<a href="wishlist.jsp"

class="footer-link">

Wishlist

</a>

<a href="#"

class="footer-link">

Support

</a>

</div>

</div>

</footer>

<script>

function toggleAIChat(){

const box=document.getElementById("aiChat");

if(box.style.display=="block"){

box.style.display="none";

}else{

box.style.display="block";

}

}

</script>