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

<form action="SmartSearchServlet" method="get">

    <input
        type="text"
        name="query"
        class="search-input"
        placeholder="Try: Laptop under 500 near MIT ADT">

</form>

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