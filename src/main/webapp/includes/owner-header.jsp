<%
String firstName = (String) session.getAttribute("firstName");
String lastName = (String) session.getAttribute("lastName");
%>

<div class="owner-hero">

    <div class="owner-left">

        <span class="owner-badge">
            Owner Dashboard
        </span>

        <h2>
            Welcome,
            <%=firstName%> <%=lastName%>
        </h2>

        <p>
            Manage your rental products, approve bookings,
            track earnings and grow your rental business.
        </p>

        <div class="owner-buttons">

            <a href="addProduct.jsp"
               class="btn-owner-primary">

                <i class="bi bi-plus-circle"></i>
                Add Product

            </a>

            <a href="ownerProducts.jsp"
               class="btn-owner-outline">

                <i class="bi bi-box-seam"></i>
                My Products

            </a>

        </div>

    </div>

    <div class="owner-right">

        <div class="mini-card">

            <h3 id="productCount">0</h3>

            <p>Total Products</p>

        </div>

        <div class="mini-card">

            <h3 id="bookingCount">0</h3>

            <p>Pending Bookings</p>

        </div>

    </div>

</div>