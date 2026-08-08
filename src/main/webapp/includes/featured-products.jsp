<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*" %>

<div class="section-header">

    <div>

        <h3>
            <i class="bi bi-stars"></i>
            Featured Products
        </h3>

        <p>
            Discover products uploaded by MIT-ADT students.
        </p>

    </div>

</div>


<div class="product-grid">

<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    String sql =
        "SELECT * FROM products " +
        "WHERE availability='AVAILABLE' " +
        "AND status='approved' " +
        "LIMIT 6";


    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    while (rs.next()) {

%>


<!-- =====================================================
     PRODUCT CARD
===================================================== -->

<div class="product-card-new">


    <!-- IMAGE -->

    <div class="image-box">

        <img
            src="<%=request.getContextPath()%>/<%=rs.getString("image")%>"
            alt="<%=rs.getString("name")%>">


        <span class="category-badge">

            <%=rs.getString("category")%>

        </span>

    </div>



    <!-- PRODUCT INFO -->

    <div class="product-info">


        <h5>

            <%=rs.getString("name")%>

        </h5>


        <p class="location">

            <i class="bi bi-geo-alt"></i>

            <%=rs.getString("location")%>

        </p>



        <!-- =================================================
             PRICE + WISHLIST + RENT
        ================================================== -->

        <div class="price-row">


            <!-- PRICE -->

            <div>

                <h4>

                    ₹<%=rs.getInt("price")%>

                </h4>

                <small>/ Day</small>

            </div>



            <!-- ACTIONS -->

            <div class="product-action-row">


                <!-- ===============================
                     WISHLIST BUTTON
                ================================ -->

 <button type="button"
        class="wishlist-heart"
        id="heart-<%=rs.getInt("id")%>"
        onclick="toggleWishlist(<%=rs.getInt("id")%>, this)"
        title="Add to Wishlist">

    <i class="bi bi-heart"></i>

</button>



                <!-- ===============================
                     RENT NOW
                ================================ -->

                <a
                    href="rentProduct.jsp?id=<%=rs.getInt("id")%>"
                    class="rent-btn">

                    <i class="bi bi-cart3"></i>

                    Rent Now

                </a>

            </div>


        </div>


    </div>


</div>


<%

    }

}
catch (Exception e) {

    out.println(
        "<p style='color:red;'>Error loading products: "
        + e.getMessage()
        + "</p>"
    );

}
finally {

    try {

        if (rs != null)
            rs.close();

    }
    catch (Exception e) {}


    try {

        if (ps != null)
            ps.close();

    }
    catch (Exception e) {}


    try {

        if (con != null)
            con.close();

    }
    catch (Exception e) {}

}

%>
<script>

function toggleWishlist(productId, button){

    const icon = button.querySelector("i");

    const alreadySaved =
        button.classList.contains("active");


    // -----------------------------------------
    // Immediately update UI
    // -----------------------------------------

    if(alreadySaved){

        button.classList.remove("active");

        icon.classList.remove("bi-heart-fill");
        icon.classList.add("bi-heart");

    }
    else{

        button.classList.add("active");

        icon.classList.remove("bi-heart");
        icon.classList.add("bi-heart-fill");

    }


    // -----------------------------------------
    // Send AJAX request
    // -----------------------------------------

    const params =
        new URLSearchParams();

    params.append("productId", productId);

    params.append(
        "action",
        alreadySaved ? "remove" : "add"
    );


    fetch("WishlistServlet", {

        method:"POST",

        headers:{
            "Content-Type":
            "application/x-www-form-urlencoded"
        },

        body:params.toString()

    })

    .then(response => {

        if(!response.ok){

            throw new Error(
                "Wishlist request failed"
            );

        }

        return response.text();

    })

    .then(data => {

        console.log(
            "Wishlist updated:",
            data
        );

    })

    .catch(error => {

        console.error(error);


        // ---------------------------------
        // Rollback heart if DB failed
        // ---------------------------------

        if(alreadySaved){

            button.classList.add("active");

            icon.classList.remove("bi-heart");
            icon.classList.add("bi-heart-fill");

        }
        else{

            button.classList.remove("active");

            icon.classList.remove("bi-heart-fill");
            icon.classList.add("bi-heart");

        }

        alert(
            "Unable to update wishlist."
        );

    });

}

</script>

</div>