<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String username = (String)session.getAttribute("user");

if(username==null){
    response.sendRedirect("index.jsp");
    return;
}

try{

int productId =
Integer.parseInt(request.getParameter("productId"));

int months =
Integer.parseInt(request.getParameter("months"));

double amount =
Double.parseDouble(request.getParameter("amount"));

String startDate =
request.getParameter("startDate");

String endDate =
request.getParameter("endDate");

String paymentMethod =
request.getParameter("paymentMethod");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con =
DriverManager.getConnection(
"jdbc:mysql://localhost:3306/renteasy",
"root",
"123456");

/* SAVE PAYMENT */

PreparedStatement pay =
con.prepareStatement(
"INSERT INTO payments(username,product_id,months,amount,payment_method,status) VALUES(?,?,?,?,?,?)");

pay.setString(1,username);
pay.setInt(2,productId);
pay.setInt(3,months);
pay.setDouble(4,amount);
pay.setString(5,paymentMethod);
pay.setString(6,"PAID");

pay.executeUpdate();

/* SAVE BOOKING */

PreparedStatement book =
con.prepareStatement(
"INSERT INTO bookings(product_id,username,start_date,end_date,booking_status) VALUES(?,?,?,?,?)");

book.setInt(1,productId);
book.setString(2,username);
book.setString(3,startDate);
book.setString(4,endDate);
book.setString(5,"Booked");

book.executeUpdate();

/* GET USER ID */

int userId=0;

PreparedStatement ps1 =
con.prepareStatement(
"SELECT id FROM users WHERE username=?");

ps1.setString(1,username);

ResultSet rs1 =
ps1.executeQuery();

if(rs1.next()){
userId=rs1.getInt("id");
}

/* GET PRODUCT DETAILS */

String ownerUsername="";
double rentPrice=0;

PreparedStatement ps2 =
con.prepareStatement(
"SELECT owner,price FROM products WHERE id=?");

ps2.setInt(1,productId);

ResultSet rs2 =
ps2.executeQuery();

if(rs2.next()){

ownerUsername=
rs2.getString("owner");

rentPrice=
rs2.getDouble("price");

}

/* GET OWNER ID */

int ownerId=0;

PreparedStatement ps3 =
con.prepareStatement(
"SELECT id FROM users WHERE username=?");

ps3.setString(1,ownerUsername);

ResultSet rs3 =
ps3.executeQuery();

if(rs3.next()){
ownerId=rs3.getInt("id");
}

/* INSERT RENTAL */

PreparedStatement rent =
con.prepareStatement(
"INSERT INTO rentals(user_id,product_id,owner_id,rent_amount,security_deposit,start_date,end_date,payment_status,rental_status) VALUES(?,?,?,?,?,?,?,?,?)");

rent.setInt(1,userId);
rent.setInt(2,productId);
rent.setInt(3,ownerId);
rent.setDouble(4,rentPrice);
rent.setDouble(5,rentPrice*10);
rent.setString(6,startDate);
rent.setString(7,endDate);
rent.setString(8,"PAID");
rent.setString(9,"ACTIVE");

rent.executeUpdate();

/* UPDATE PRODUCT */

PreparedStatement update =
con.prepareStatement(
"UPDATE products SET status='RENTED' WHERE id=?");

update.setInt(1,productId);

update.executeUpdate();

/* OWNER NOTIFICATION */

PreparedStatement notify =
con.prepareStatement(
"INSERT INTO notifications(username,message) VALUES(?,?)");

notify.setString(1,ownerUsername);
notify.setString(2,
username + " rented your product.");

notify.executeUpdate();

con.close();

response.sendRedirect("success.jsp");
}catch(Exception e){
	

out.println("<h3>Error :</h3>");
out.println(e);

}
%>