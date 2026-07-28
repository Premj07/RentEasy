<%@ page import="java.sql.*" %>

<%
String ownerEmail = (String)session.getAttribute("email");
%>

<div class="section-header">

    <div>
        <h3><i class="bi bi-box-seam"></i> My Products</h3>
        <p>Manage all your listed rental products.</p>
    </div>

    <a href="addProduct.jsp" class="btn-add-product">
        <i class="bi bi-plus-circle"></i> Add Product
    </a>

</div>

<div class="owner-product-grid">

<%

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

PreparedStatement ps=con.prepareStatement(

"SELECT * FROM products WHERE owner=? ORDER BY id DESC");

ps.setString(1,ownerEmail);

ResultSet rs=ps.executeQuery();

while(rs.next()){

%>

<div class="owner-product-card">

    <div class="product-image">

        <img src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
             alt="Product">

        <span class="status">

            <%=rs.getString("status")%>

        </span>

    </div>

    <div class="product-details">

        <h4><%=rs.getString("name")%></h4>

        <p>
            <i class="bi bi-geo-alt"></i>
            <%=rs.getString("location")%>
        </p>

        <h3>₹<%=rs.getInt("price")%> / Day</h3>

        <div class="owner-actions">

            <a href="editProduct.jsp?id=<%=rs.getInt("id")%>"
               class="btn-edit">

               <i class="bi bi-pencil-square"></i>

            </a>

            <a href="deleteProduct?id=<%=rs.getInt("id")%>"
               class="btn-delete">

               <i class="bi bi-trash"></i>

            </a>

            <a href="productDetails.jsp?id=<%=rs.getInt("id")%>"
               class="btn-view">

               <i class="bi bi-eye"></i>

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