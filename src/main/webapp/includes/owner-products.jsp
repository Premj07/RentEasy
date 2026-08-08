<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String ownerEmail = (String) session.getAttribute("email");
%>


<!-- =====================================================
     MY PRODUCTS HEADER
===================================================== -->

<div class="section-header">

    <div>

        <h3>
            <i class="bi bi-box-seam"></i>
            My Products
        </h3>

        <p>
            Manage your rental listings, pricing and availability.
        </p>

    </div>


    <a href="addProduct.jsp"
       class="btn-add-product">

        <i class="bi bi-plus-circle"></i>

        Add Product

    </a>

</div>



<!-- =====================================================
     PRODUCT GRID
===================================================== -->

<div class="owner-product-grid">

<%

Connection productCon = null;
PreparedStatement productPs = null;
ResultSet productRs = null;

boolean productFound = false;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    productCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    productPs = productCon.prepareStatement(

        "SELECT " +
        "id, " +
        "name, " +
        "image, " +
        "location, " +
        "price, " +
        "status, " +
        "availability, " +
        "deposit " +

        "FROM products " +

        "WHERE owner=? " +

        "ORDER BY id DESC"
    );


    productPs.setString(
        1,
        ownerEmail
    );


    productRs =
        productPs.executeQuery();


    while(productRs.next()) {

        productFound = true;


        int productId =
            productRs.getInt("id");


        String productName =
            productRs.getString("name");


        String image =
            productRs.getString("image");


        String location =
            productRs.getString("location");


        double price =
            productRs.getDouble("price");


        double deposit =
            productRs.getDouble("deposit");


        String approvalStatus =
            productRs.getString("status");


        String availability =
            productRs.getString("availability");



        /* =============================================
           SAFE VALUES
        ============================================= */

        if(productName == null) {
            productName = "Unnamed Product";
        }

        if(location == null ||
           location.trim().isEmpty()) {

            location = "Location not specified";
        }

        if(approvalStatus == null) {
            approvalStatus = "Pending";
        }

        if(availability == null ||
           availability.trim().isEmpty()) {

            availability = "AVAILABLE";
        }



        /* =============================================
           STATUS CLASS
        ============================================= */

        String approvalClass =
            approvalStatus.toLowerCase();


        String availabilityClass =
            availability.toLowerCase();

%>


<!-- =====================================================
     PRODUCT CARD
===================================================== -->

<div class="owner-product-card">


    <!-- ================= IMAGE ================= -->

    <div class="product-image">


        <%
        if(image != null &&
           !image.trim().isEmpty()) {
        %>

        <img
            src="<%=request.getContextPath()%>/<%=image%>"
            alt="<%=productName%>"
            onerror="this.src='images/no-product.png';"
        >

        <%
        } else {
        %>

        <div class="product-no-image">

            <i class="bi bi-image"></i>

            <span>
                No Image
            </span>

        </div>

        <%
        }
        %>



        <!-- AVAILABILITY BADGE -->

        <span class="product-availability
                     <%=availabilityClass%>">

            <%

            if("RENTED".equalsIgnoreCase(
                    availability)) {

            %>

                <i class="bi bi-lock-fill"></i>
                Rented

            <%

            } else {

            %>

                <i class="bi bi-check-circle-fill"></i>
                Available

            <%

            }

            %>

        </span>


    </div>



    <!-- ================= DETAILS ================= -->

    <div class="product-details">


        <!-- APPROVAL STATUS -->

        <div class="product-status-row">

            <span class="approval-status
                         <%=approvalClass%>">

                <i class="bi bi-circle-fill"></i>

                <%=approvalStatus%>

            </span>


            <span class="product-id">

                #<%=productId%>

            </span>

        </div>



        <!-- PRODUCT NAME -->

        <h4 class="owner-product-name">

            <%=productName%>

        </h4>



        <!-- LOCATION -->

        <p class="product-location">

            <i class="bi bi-geo-alt"></i>

            <%=location%>

        </p>



        <!-- PRICE -->

        <div class="product-price-row">

            <div>

                <span class="price-label">
                    Rental Price
                </span>

                <div class="product-price">

                    ₹<%=String.format("%.0f", price)%>

                    <span>
                        / day
                    </span>

                </div>

            </div>


            <div class="deposit-info">

                <span>
                    Deposit
                </span>

                <strong>

                    ₹<%=String.format("%.0f", deposit)%>

                </strong>

            </div>

        </div>



        <!-- ================= ACTIONS ================= -->

        <div class="owner-product-actions">


            <!-- VIEW -->

            <a
                href="productDetails.jsp?id=<%=productId%>"
                class="product-action-btn view"
                title="View Product">

                <i class="bi bi-eye"></i>

                <span>
                    View
                </span>

            </a>



            <!-- EDIT -->

            <a
                href="editProduct.jsp?id=<%=productId%>"
                class="product-action-btn edit"
                title="Edit Product">

                <i class="bi bi-pencil-square"></i>

                <span>
                    Edit
                </span>

            </a>



            <!-- DELETE -->

            <a
                href="deleteProduct?id=<%=productId%>"
                class="product-action-btn delete"
                title="Delete Product"

                onclick="
                return confirm(
                'Are you sure you want to delete this product?'
                );
                ">

                <i class="bi bi-trash"></i>

            </a>


        </div>


    </div>

</div>


<%

    } // while


    /* =============================================
       NO PRODUCTS
    ============================================= */

    if(!productFound) {

%>


<div class="owner-products-empty">

    <div class="empty-product-icon">

        <i class="bi bi-box-seam"></i>

    </div>


    <h3>
        No products listed yet
    </h3>


    <p>
        Add your first rental product and start
        receiving bookings from RentEasy users.
    </p>


    <a href="addProduct.jsp"
       class="btn-add-product">

        <i class="bi bi-plus-circle"></i>

        Add Your First Product

    </a>

</div>


<%

    }


} catch(Exception e) {

    e.printStackTrace();

%>


<div class="owner-product-error">

    <i class="bi bi-exclamation-triangle"></i>

    <div>

        <strong>
            Unable to load products
        </strong>

        <p>
            <%=e.getMessage()%>
        </p>

    </div>

</div>


<%

} finally {

    try {

        if(productRs != null)
            productRs.close();

        if(productPs != null)
            productPs.close();

        if(productCon != null)
            productCon.close();

    } catch(SQLException ignored) {
    }

}

%>

</div>