<%@ page session="true" %>

<%
String username = (String)session.getAttribute("user");
if(username==null){
    username="Guest";
}
%>

<nav class="top-navbar">

<div class="nav-left">

<button id="menuToggle" class="menu-btn">
    <i class="bi bi-list"></i>
</button>

<div class="logo">

    <img src="images/logo.png.jpeg" alt="Logo">

    <span>RentEasy</span>

</div>

</div>

<div class="nav-center">

<div class="search-box">

<input
type="text"
placeholder="Search products, furniture, books...">

</div>

</div>

<div class="nav-right">

<button class="notification-btn">
    <i class="bi bi-bell"></i>
</button>

<div class="user-name">

<%=username%>

</div>

</div>

</nav>