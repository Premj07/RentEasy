<%
String firstName = (String) session.getAttribute("firstName");
String lastName = (String) session.getAttribute("lastName");

if (firstName == null || firstName.trim().isEmpty()) {
    firstName = "Owner";
}

if (lastName == null) {
    lastName = "";
}

String ownerFullName = (firstName + " " + lastName).trim();
%>

<!-- =========================
     OWNER WELCOME HERO
========================= -->

<section class="owner-hero">

    <!-- LEFT CONTENT -->
    <div class="owner-hero-content">

        <span class="owner-badge">
            <i class="bi bi-shop"></i>
            Owner Dashboard
        </span>

        <h1 class="owner-welcome-title">
            Welcome, <%= ownerFullName %>
        </h1>

        <p class="owner-welcome-text">
            Manage your rental products, review bookings,
            track active rentals and monitor your earnings.
        </p>

        <div class="owner-hero-actions">

            <a href="addProduct.jsp"
               class="owner-action-primary">

                <i class="bi bi-plus-circle"></i>
                Add Product

            </a>

            <a href="ownerProducts.jsp"
               class="owner-action-secondary">

                <i class="bi bi-box-seam"></i>
                My Products

            </a>

        </div>

    </div>


    <!-- RIGHT SUMMARY -->
    <div class="owner-hero-summary">

        <div class="owner-summary-card">

            <div class="owner-summary-icon">
                <i class="bi bi-box-seam"></i>
            </div>

            <div>
                <h3 id="productCount">0</h3>
                <span>Total Products</span>
            </div>

        </div>


        <div class="owner-summary-card">

            <div class="owner-summary-icon">
                <i class="bi bi-hourglass-split"></i>
            </div>

            <div>
                <h3 id="bookingCount">0</h3>
                <span>Pending Bookings</span>
            </div>

        </div>

    </div>

</section>