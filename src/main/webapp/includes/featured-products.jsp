<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*" %>
 
<%@ page import="java.sql.*" %>

<div class="section-header">

    <div>

        <h3><i class="bi bi-stars"></i> Featured Products</h3>

        <p>Discover products uploaded by MIT-ADT students.</p>

    </div>

</div>

<div class="product-grid">

<%

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

Statement st=con.createStatement();

ResultSet rs=st.executeQuery(

"SELECT * FROM products WHERE status='APPROVED' OR status='AVAILABLE' LIMIT 6"

);

while(rs.next()){

%>

<div class="product-card-new">

<div class="image-box">

<img src="<%=request.getContextPath()%>/<%=rs.getString("image")%>">

<span class="category-badge">

<%=rs.getString("category")%>

</span>

</div>

<div class="product-info">

<h5><%=rs.getString("name")%></h5>

<p class="location">

<i class="bi bi-geo-alt"></i>
<%=rs.getString("location")%>

</p>

<div class="price-row">

<div>

<h4>

₹<%=rs.getInt("price")%>

</h4>

<small>/ Day</small>

</div>

<a href="rentProduct.jsp?id=<%=rs.getInt("id")%>"

class="rent-btn">

<i class="bi bi-cart-plus"></i> Rent Now

</a>

</div>

</div>

</div>

<%

}

con.close();

}catch(Exception e){

out.println(e);

}

%>

</div>