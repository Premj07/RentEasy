<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="section-header">

<div>

<h3>Browse Categories</h3>

<p>Choose a category to explore rentals.</p>

</div>

</div>

<div class="category-row">

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Electronics"
       class="category-btn">
        <i class="bi bi-phone"></i>
        Electronics
    </a>

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Furniture"
       class="category-btn">
        <i class="bi bi-house-door"></i>
        Furniture
    </a>

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Books"
       class="category-btn">
        <i class="bi bi-book"></i>
        Books
    </a>

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Sports"
       class="category-btn">
        <i class="bi bi-dribbble"></i>
        Sports
    </a>

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Laptops"
       class="category-btn">
        <i class="bi bi-laptop"></i>
        Laptops
    </a>

    <a href="<%=request.getContextPath()%>/CategoryProductsServlet?category=Appliances"
       class="category-btn">
        <i class="bi bi-tv"></i>
        Appliances
    </a>

    <a href="<%=request.getContextPath()%>/TrendingProductsServlet"
       class="category-btn trending-btn">
        <i class="bi bi-fire"></i>
        Trending
    </a>

</div>