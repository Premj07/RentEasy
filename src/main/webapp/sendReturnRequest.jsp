<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
String renter = (String)session.getAttribute("user");

if(renter==null){
    response.sendRedirect("index.jsp");
    return;
}

int rentalId =
Integer.parseInt(request.getParameter("rentalId"));

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

/* Get rental details */

PreparedStatement ps=
con.prepareStatement(
"SELECT r.product_id,p.owner FROM rentals r JOIN products p ON r.product_id=p.id WHERE r.rental_id=?");

ps.setInt(1,rentalId);

ResultSet rs=ps.executeQuery();

String productId="";
String owner="";

if(rs.next()){
    productId=String.valueOf(rs.getInt("product_id"));
    owner=rs.getString("owner");
}

/* Insert return request */

PreparedStatement insert=
con.prepareStatement(
"INSERT INTO return_requests(order_id,product_id,renter_name,owner_name,return_date,status,delivery_status) VALUES(?,?,?,?,CURDATE(),?,?)");

insert.setString(1,String.valueOf(rentalId));
insert.setString(2,productId);
insert.setString(3,renter);
insert.setString(4,owner);
insert.setString(5,"PENDING");
insert.setString(6,"WAITING");

insert.executeUpdate();

con.close();

response.sendRedirect("myRentals.jsp");
return;

}catch(Exception e){
    out.println(e);
}
%>