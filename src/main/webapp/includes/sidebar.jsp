<%@ page session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
/* =========================================================
   RentEasy - Reusable User Sidebar
   ========================================================= */

String sidebarFirstName =
        (String) session.getAttribute("firstName");

String sidebarLastName =
        (String) session.getAttribute("lastName");

if (sidebarFirstName == null) sidebarFirstName = "";
if (sidebarLastName == null) sidebarLastName = "";

String sidebarFullName =
        (sidebarFirstName + " " + sidebarLastName).trim();

if (sidebarFullName.isEmpty()) {
    sidebarFullName = "User";
}

String sidebarFirstLetter =
        sidebarFullName.substring(0, 1).toUpperCase();
%>


<!-- ================= RENTEASY SIDEBAR ================= -->

<aside class="re-sidebar" id="sidebar">

    <!-- USER PROFILE -->
    <div class="re-sidebar-header">

        <div class="re-user-profile">

            <div class="re-user-avatar">
                <%= sidebarFirstLetter %>
            </div>

            <div class="re-user-details">

                <h4>
                    <%= sidebarFullName %>
                </h4>

                <small>
                    Student / User
                </small>

                <div class="re-verified-badge">
                    <i class="bi bi-patch-check-fill"></i>
                    Verified User
                </div>

            </div>

        </div>

    </div>


    <!-- ================= SIDEBAR MENU ================= -->

    <div class="re-sidebar-scroll">

        <!-- OVERVIEW -->
        <div class="re-sidebar-section-title">
            Overview
        </div>

        <ul class="re-sidebar-menu">

            <li>
                <a href="dashboard.jsp"
                   class="re-sidebar-link active">

                    <i class="bi bi-grid-fill"></i>

                    <span>
                        Dashboard
                    </span>

                </a>
            </li>

        </ul>


        <!-- RENTING -->
        <div class="re-sidebar-section-title">
            Renting
        </div>

        <ul class="re-sidebar-menu">

            <li>
                <a href="products.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-box-seam"></i>

                    <span>
                        Browse Products
                    </span>

                </a>
            </li>


            <li>
                <a href="WishlistPageServlet"
                   class="re-sidebar-link">

                    <i class="bi bi-heart"></i>

                    <span>
                        Wishlist
                    </span>

                </a>
            </li>


            <li>
                <a href="myRentals.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-bag-check"></i>

                    <span>
                        My Rentals
                    </span>

                </a>
            </li>


            <li>
                <a href="history.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-clock-history"></i>

                    <span>
                        Rental History
                    </span>

                </a>
            </li>

        </ul>


        <!-- FINANCE -->
        <div class="re-sidebar-section-title">
            Finance
        </div>

        <ul class="re-sidebar-menu">

            <li>
                <a href="paymentHistory.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-credit-card"></i>

                    <span>
                        Payments
                    </span>

                </a>
            </li>


            <li>
                <a href="delivery.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-truck"></i>

                    <span>
                        Delivery
                    </span>

                </a>
            </li>

        </ul>


        <!-- ACCOUNT -->
        <div class="re-sidebar-section-title">
            Account
        </div>

        <ul class="re-sidebar-menu">

            <li>
                <a href="profile.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-person"></i>

                    <span>
                        Profile
                    </span>

                </a>
            </li>


            <li>
                <a href="kyc.jsp"
                   class="re-sidebar-link">

                    <i class="bi bi-shield-check"></i>

                    <span>
                        KYC Verification
                    </span>

                </a>
            </li>

        </ul>

    </div>


    <!-- ================= BOTTOM ================= -->

    <div class="re-sidebar-bottom">

        <a href="ownerDashboard.jsp"
           class="re-sidebar-bottom-link">

            <i class="bi bi-arrow-left-right"></i>

            <span>
                Switch to Owner
            </span>

        </a>


        <a href="logout"
           class="re-sidebar-bottom-link re-logout">

            <i class="bi bi-box-arrow-right"></i>

            <span>
                Logout
            </span>

        </a>

    </div>

</aside>