<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%
ArrayList<HashMap<String,Object>> products =
    (ArrayList<HashMap<String,Object>>)
    request.getAttribute("trendingProducts");

int productCount = (products == null) ? 0 : products.size();
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Trending Products | RentEasy</title>


<!-- ================= GOOGLE FONT ================= -->

<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
      rel="stylesheet">


<!-- ================= BOOTSTRAP ================= -->

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">


<!-- ================= BOOTSTRAP ICONS ================= -->

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>

/* =====================================================
   GLOBAL
===================================================== */

*{
    box-sizing:border-box;
}

body{

    margin:0;

    font-family:'Poppins',sans-serif;

    background:#f5f7fb;

    color:#172033;

}


/* =====================================================
   NAVBAR
===================================================== */

.top-navbar{

    height:82px;

    background:#ffffff;

    display:flex;

    align-items:center;

    justify-content:space-between;

    padding:0 45px;

    border-bottom:1px solid #e9edf5;

    position:sticky;

    top:0;

    z-index:1000;

}

.brand{

    display:flex;

    align-items:center;

    gap:12px;

    text-decoration:none;

    color:#111827;

}

.brand-icon{

    width:46px;

    height:46px;

    background:#2563eb;

    color:#ffffff;

    display:flex;

    align-items:center;

    justify-content:center;

    border-radius:13px;

    font-size:22px;

}

.brand-name{

    font-size:27px;

    font-weight:700;

}

.nav-actions{

    display:flex;

    align-items:center;

    gap:15px;

}

.dashboard-btn{

    text-decoration:none;

    color:#334155;

    font-weight:500;

    padding:11px 20px;

    border-radius:10px;

    transition:.25s;

}

.dashboard-btn:hover{

    background:#edf4ff;

    color:#2563eb;

}

.back-btn{

    background:#2563eb;

    color:white;

    text-decoration:none;

    padding:11px 22px;

    border-radius:11px;

    font-weight:600;

    transition:.25s;

}

.back-btn:hover{

    background:#1d4ed8;

    color:white;

}


/* =====================================================
   MAIN CONTAINER
===================================================== */

.page-container{

    max-width:1450px;

    margin:auto;

    padding:45px 35px 80px;

}


/* =====================================================
   HERO
===================================================== */

.trending-hero{

    position:relative;

    overflow:hidden;

    background:
        linear-gradient(
            135deg,
            #fff7ed 0%,
            #fff 55%,
            #eff6ff 100%
        );

    border:1px solid #e8edf5;

    border-radius:24px;

    padding:45px 50px;

    margin-bottom:38px;

    box-shadow:
        0 12px 35px rgba(15,23,42,.06);

}

.hero-content{

    position:relative;

    z-index:2;

}

.hero-badge{

    display:inline-flex;

    align-items:center;

    gap:8px;

    background:#fff0e5;

    color:#ea580c;

    padding:8px 15px;

    border-radius:30px;

    font-size:14px;

    font-weight:600;

    margin-bottom:15px;

}

.hero-title{

    font-size:40px;

    font-weight:700;

    margin:0 0 10px;

    color:#111827;

}

.hero-title span{

    color:#f97316;

}

.hero-description{

    color:#64748b;

    font-size:16px;

    margin:0;

    max-width:700px;

    line-height:1.7;

}

.hero-fire{

    position:absolute;

    right:70px;

    top:50%;

    transform:translateY(-50%);

    font-size:110px;

    opacity:.13;

}


/* =====================================================
   SUMMARY
===================================================== */

.trending-summary{

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:25px;

}

.summary-left h2{

    font-size:25px;

    font-weight:700;

    margin:0;

}

.summary-left p{

    margin:6px 0 0;

    color:#64748b;

    font-size:14px;

}

.product-count{

    display:flex;

    align-items:center;

    gap:9px;

    background:#ffffff;

    border:1px solid #e5eaf2;

    border-radius:12px;

    padding:10px 17px;

    color:#475569;

    font-size:14px;

    box-shadow:0 5px 15px rgba(15,23,42,.04);

}

.product-count strong{

    color:#2563eb;

}


/* =====================================================
   PRODUCT GRID
===================================================== */

.product-grid{

    display:grid;

    grid-template-columns:
        repeat(auto-fill,minmax(300px,1fr));

    gap:25px;

}


/* =====================================================
   PRODUCT CARD
===================================================== */

.product-card{

    background:#ffffff;

    border-radius:20px;

    overflow:hidden;

    border:1px solid #e8edf4;

    transition:.3s ease;

    position:relative;

    box-shadow:
        0 8px 25px rgba(15,23,42,.05);

}

.product-card:hover{

    transform:translateY(-7px);

    box-shadow:
        0 18px 40px rgba(15,23,42,.11);

}


/* =====================================================
   IMAGE
===================================================== */

.product-image-box{

    height:250px;

    background:#f1f5f9;

    overflow:hidden;

    position:relative;

}

.product-image{

    width:100%;

    height:100%;

    object-fit:cover;

    transition:.4s;

}

.product-card:hover .product-image{

    transform:scale(1.05);

}


/* =====================================================
   TRENDING BADGE
===================================================== */

.trending-badge{

    position:absolute;

    top:15px;

    left:15px;

    background:#ffffff;

    color:#ef4444;

    padding:8px 13px;

    border-radius:30px;

    font-size:13px;

    font-weight:600;

    box-shadow:
        0 5px 18px rgba(0,0,0,.12);

}

.rank-badge{

    position:absolute;

    top:15px;

    right:15px;

    width:38px;

    height:38px;

    border-radius:50%;

    background:#2563eb;

    color:#ffffff;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:13px;

    font-weight:700;

    box-shadow:
        0 5px 15px rgba(37,99,235,.3);

}


/* =====================================================
   PRODUCT INFORMATION
===================================================== */

.product-info{

    padding:22px;

}

.category{

    color:#2563eb;

    font-size:13px;

    font-weight:600;

    margin-bottom:8px;

    text-transform:uppercase;

    letter-spacing:.4px;

}

.product-name{

    font-size:21px;

    font-weight:700;

    margin-bottom:15px;

    color:#111827;

}

.price-row{

    display:flex;

    align-items:end;

    justify-content:space-between;

    margin-bottom:18px;

}

.price{

    font-size:25px;

    font-weight:700;

    color:#2563eb;

}

.price small{

    font-size:13px;

    font-weight:500;

    color:#64748b;

}


/* =====================================================
   TRENDING STATISTICS
===================================================== */

.trending-stats{

    display:flex;

    gap:10px;

    margin-bottom:20px;

}

.stat{

    flex:1;

    background:#f8fafc;

    border:1px solid #edf0f5;

    border-radius:11px;

    padding:10px;

}

.stat-label{

    display:block;

    color:#94a3b8;

    font-size:11px;

    margin-bottom:3px;

}

.stat-value{

    font-size:14px;

    font-weight:600;

    color:#334155;

}

.score-value{

    color:#f97316;

}


/* =====================================================
   BUTTON
===================================================== */

.view-product-btn{

    display:flex;

    align-items:center;

    justify-content:center;

    gap:8px;

    width:100%;

    padding:13px;

    background:#2563eb;

    color:white;

    text-decoration:none;

    border-radius:11px;

    font-weight:600;

    transition:.25s;

}

.view-product-btn:hover{

    background:#1d4ed8;

    color:white;

    transform:translateY(-1px);

}


/* =====================================================
   EMPTY STATE
===================================================== */

.empty-state{

    background:#ffffff;

    border-radius:20px;

    border:1px solid #e7ebf2;

    text-align:center;

    padding:80px 20px;

}

.empty-icon{

    font-size:65px;

    margin-bottom:15px;

}

.empty-state h3{

    font-size:24px;

    font-weight:700;

}

.empty-state p{

    color:#64748b;

    max-width:500px;

    margin:10px auto 25px;

}


/* =====================================================
   FOOTER
===================================================== */

.footer{

    margin-top:70px;

    background:#111827;

    border-radius:22px;

    padding:30px 35px;

    color:white;

    display:flex;

    justify-content:space-between;

    align-items:center;

}

.footer-title{

    font-size:20px;

    font-weight:700;

}

.footer-text{

    color:#94a3b8;

    font-size:13px;

    margin-top:5px;

}

.footer-link{

    color:#cbd5e1;

    text-decoration:none;

    margin-left:25px;

}

.footer-link:hover{

    color:white;

}


/* =====================================================
   RESPONSIVE
===================================================== */

@media(max-width:768px){

    .top-navbar{

        padding:0 18px;

    }

    .brand-name{

        font-size:22px;

    }

    .dashboard-btn{

        display:none;

    }

    .page-container{

        padding:25px 15px 50px;

    }

    .trending-hero{

        padding:35px 25px;

    }

    .hero-title{

        font-size:31px;

    }

    .hero-fire{

        display:none;

    }

    .trending-summary{

        align-items:flex-start;

        flex-direction:column;

        gap:15px;

    }

    .product-grid{

        grid-template-columns:1fr;

    }

    .footer{

        flex-direction:column;

        align-items:flex-start;

        gap:20px;

    }

}

</style>

</head>


<body>


<!-- =====================================================
     NAVBAR
===================================================== -->

<nav class="top-navbar">

    <a href="dashboard.jsp"
       class="brand">

        <div class="brand-icon">

            <i class="bi bi-box-seam"></i>

        </div>

        <span class="brand-name">
            RentEasy
        </span>

    </a>


    <div class="nav-actions">

        <a href="dashboard.jsp"
           class="dashboard-btn">

            <i class="bi bi-grid"></i>

            Dashboard

        </a>


        <a href="dashboard.jsp"
           class="back-btn">

            <i class="bi bi-arrow-left"></i>

            Back to Dashboard

        </a>

    </div>

</nav>



<!-- =====================================================
     PAGE
===================================================== -->

<main class="page-container">


<!-- =====================================================
     HERO
===================================================== -->

<section class="trending-hero">

    <div class="hero-content">

        <div class="hero-badge">

            <i class="bi bi-fire"></i>

            LIVE TRENDING

        </div>


        <h1 class="hero-title">

            🔥 Trending
            <span>Products</span>

        </h1>


        <p class="hero-description">

            Discover products that are currently getting
            the most attention on RentEasy. Rankings are
            generated dynamically from real user
            interactions.

        </p>

    </div>


    <div class="hero-fire">

        🔥

    </div>

</section>



<!-- =====================================================
     SUMMARY
===================================================== -->

<div class="trending-summary">

    <div class="summary-left">

        <h2>
            What's Trending Now
        </h2>

        <p>
            Ranked using real RentEasy user activity.
        </p>

    </div>


    <div class="product-count">

        <i class="bi bi-graph-up-arrow"></i>

        Trending Products:

        <strong>
            <%=productCount%>
        </strong>

    </div>

</div>



<!-- =====================================================
     PRODUCTS
===================================================== -->

<%

if(products != null && !products.isEmpty()){

%>


<div class="product-grid">


<%

int rank = 1;

for(HashMap<String,Object> product : products){

    int id =
        ((Number)product.get("id")).intValue();

    String name =
        String.valueOf(product.get("name"));

    String category =
        String.valueOf(product.get("category"));

    String image =
        String.valueOf(product.get("image"));

    int price =
        ((Number)product.get("price")).intValue();

    int score =
    	    ((Number)product.get("trendingScore")).intValue();

    int interactions =
    	    ((Number)product.get("totalInteractions")).intValue();

%>


<div class="product-card">


    <!-- ================= IMAGE ================= -->

    <div class="product-image-box">


        <img
            src="<%=request.getContextPath()%>/<%=image%>"
            class="product-image"
            alt="<%=name%>">


        <div class="trending-badge">

            🔥 Trending

        </div>


        <div class="rank-badge">

            #<%=rank%>

        </div>


    </div>



    <!-- ================= INFORMATION ================= -->

    <div class="product-info">


        <div class="category">

            <%=category%>

        </div>


        <div class="product-name">

            <%=name%>

        </div>



        <!-- PRICE -->

        <div class="price-row">

            <div class="price">

                ₹<%=price%>

                <small>
                    / Day
                </small>

            </div>

        </div>



        <!-- ================= STATS ================= -->

        <div class="trending-stats">


            <div class="stat">

                <span class="stat-label">

                    Trending Score

                </span>

                <span class="stat-value score-value">

                    🔥 <%=score%>

                </span>

            </div>



            <div class="stat">

                <span class="stat-label">

                    Interactions

                </span>

                <span class="stat-value">

                    <i class="bi bi-people"></i>

                    <%=interactions%>

                </span>

            </div>


        </div>



        <!-- ================= VIEW BUTTON ================= -->

        <a
            href="rentProduct.jsp?id=<%=id%>"
            class="view-product-btn">

            View Product

            <i class="bi bi-arrow-right"></i>

        </a>


    </div>

</div>


<%

rank++;

}

%>


</div>


<%

}else{

%>


<!-- =====================================================
     NO TRENDING PRODUCTS
===================================================== -->

<div class="empty-state">


    <div class="empty-icon">

        🔥

    </div>


    <h3>

        No Trending Products Yet

    </h3>


    <p>

        Trending products will automatically appear here
        when users start viewing, wishlisting and renting
        products.

    </p>


    <a href="dashboard.jsp"
       class="back-btn">

        Browse Products

    </a>


</div>


<%

}

%>



<!-- =====================================================
     FOOTER
===================================================== -->

<footer class="footer">


    <div>

        <div class="footer-title">

            RentEasy

        </div>

        <div class="footer-text">

            Smart student rental marketplace.

        </div>

    </div>


    <div>

        <a href="dashboard.jsp"
           class="footer-link">

            Dashboard

        </a>

        <a href="products.jsp"
           class="footer-link">

            Products

        </a>

    </div>


</footer>


</main>


</body>

</html>