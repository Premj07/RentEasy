<%@ page import="java.sql.*" %>

<%
String id = request.getParameter("id");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String name = "";
String image = "";
String owner = "";
String category = "";
String location = "";
String description = "";
int rentPrice = 0;
int deposit = 0;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456");

    ps = con.prepareStatement(
            "SELECT * FROM products WHERE id=?");

    ps.setInt(1,Integer.parseInt(id));

    rs = ps.executeQuery();

    if(rs.next()){

        name = rs.getString("name");
        image = rs.getString("image");
        owner = rs.getString("owner");
        category = rs.getString("category");
        location = rs.getString("location");
        description = rs.getString("description");

        rentPrice = rs.getInt("price");
        deposit = rs.getInt("deposit");
    }

}catch(Exception e){

    out.println(e);

}
%>

<h3 class="mb-4">Product Details</h3>

<div class="text-center mb-4">

    <img src="<%=image%>"
         class="img-fluid rounded"
         style="max-height:300px;">

</div>

<table class="table">

<tr>
    <th>Product</th>
    <td><%=name%></td>
</tr>

<tr>
    <th>Category</th>
    <td><%=category%></td>
</tr>

<tr>
    <th>Owner</th>
    <td><%=owner%></td>
</tr>

<tr>
    <th>Location</th>
    <td><%=location%></td>
</tr>

<tr>
    <th>Rent / Day</th>
    <td>
        ₹
        <span id="rentPrice">
            <%=rentPrice%>
        </span>
    </td>
</tr>

<tr>
    <th>Security Deposit</th>
    <td>
        ₹
        <span id="deposit">
            <%=deposit%>
        </span>
    </td>
</tr>

</table>

<div class="mb-3">

<label class="form-label">

Rental Duration

</label>

<select
class="form-select"
id="rentalDays">

<option value="1">1 Day</option>
<option value="2">2 Days</option>
<option value="3">3 Days</option>
<option value="7">7 Days</option>
<option value="15">15 Days</option>
<option value="30">30 Days</option>

</select>

</div>

<div class="row">

<div class="col-md-6">

<label class="form-label">

Start Date

</label>

<input
type="date"
class="form-control"
id="startDate">

</div>

<div class="col-md-6">

<label class="form-label">

End Date

</label>

<input
type="date"
class="form-control"
id="endDate"
readonly>

</div>

</div>

<input
type="hidden"
id="productId"
value="<%=id%>">