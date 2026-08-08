<%@ page import="java.sql.*" %>
<%@ page import="com.renteasy.dao.RecentlyViewedDAO" %>
<%@ page import="com.renteasy.dao.RecommendationDAO" %>
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.renteasy.dao.PersonalizedRankingDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%
Integer userId = (Integer) session.getAttribute("userId");


ArrayList<HashMap<String,Object>> personalizedProducts =
        new ArrayList<HashMap<String,Object>>();

if(userId != null){

    PersonalizedRankingDAO personalizedDAO =
            new PersonalizedRankingDAO();

    personalizedProducts =
            personalizedDAO.getPersonalizedProducts(userId);
}


RecentlyViewedDAO recentDAO = new RecentlyViewedDAO();
ResultSet recentRs = null;

if(userId != null){
    recentRs = recentDAO.getRecentlyViewed(userId);
}

RecommendationDAO dao = new RecommendationDAO();

ResultSet rs = dao.getRecommendedProducts(userId);
%>
<!-- ===================================================== -->
<!-- PERSONALIZED AI RECOMMENDATIONS -->
<!-- ===================================================== -->

<div class="section-header mt-5">

    <div>

        <h3>
            <i class="bi bi-stars"></i>
            Recommended For You
        </h3>

        <p>
            Personalized recommendations based on your
            RentEasy activity.
        </p>

    </div>

    <span class="ai-powered-badge">
        <i class="bi bi-cpu"></i>
        AI Personalized
    </span>

</div>


<div class="product-grid">

<%
if(personalizedProducts != null &&
   !personalizedProducts.isEmpty()){

    for(HashMap<String,Object> product :
            personalizedProducts){

        int recommendedId =
            ((Number)product.get("id")).intValue();

        String recommendedName =
            String.valueOf(product.get("name"));

        int recommendedPrice =
            ((Number)product.get("price")).intValue();

        String recommendedImage =
            String.valueOf(product.get("image"));

        String recommendedLocation =
            String.valueOf(product.get("location"));

        String recommendedCategory =
            String.valueOf(product.get("category"));

        int aiScore =
            ((Number)product.get("aiScore")).intValue();
%>


<!-- ================================================= -->
<!-- PRODUCT CARD -->
<!-- ================================================= -->

<div class="product-card-new personalized-card">


    <!-- IMAGE -->

    <div class="image-box">

        <img
            src="<%=request.getContextPath()%>/<%=recommendedImage%>"
            alt="<%=recommendedName%>">


        <!-- CATEGORY -->

        <span class="category-badge">

            <%=recommendedCategory%>

        </span>


        <!-- AI BADGE -->

        <span class="personalized-badge">

            <i class="bi bi-stars"></i>

            For You

        </span>

    </div>



    <!-- PRODUCT INFORMATION -->

    <div class="product-info">


        <h5>

            <%=recommendedName%>

        </h5>


        <p class="location">

            <i class="bi bi-geo-alt"></i>

            <%=recommendedLocation%>

        </p>



        <!-- AI SCORE -->

        <div class="ai-score-row">

            <div class="ai-score-left">

                <i class="bi bi-cpu"></i>

                AI Relevance

            </div>


            <div class="ai-score-value">

                <%=aiScore%> pts

            </div>

        </div>



        <!-- PRICE + ACTIONS -->

        <div class="price-row">


            <div>

                <h4>

                    ₹<%=recommendedPrice%>

                </h4>

                <small>
                    / Day
                </small>

            </div>



            <div class="recommendation-actions">


                <!-- WISHLIST -->

                <form
                    action="<%=request.getContextPath()%>/WishlistServlet"
                    method="post"
                    class="wishlist-form">

                    <input
                        type="hidden"
                        name="productId"
                        value="<%=recommendedId%>">


                    <input
                        type="hidden"
                        name="action"
                        value="add">


                    <input
                        type="hidden"
                        name="redirect"
                        value="dashboard">


                    <button
                        type="submit"
                        class="recommendation-heart"
                        title="Add to Wishlist">

                        <i class="bi bi-heart"></i>

                    </button>

                </form>



                <!-- RENT -->

                <a
                    href="<%=request.getContextPath()%>/rentProduct.jsp?id=<%=recommendedId%>"
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

}else{
%>


<!-- ================================================= -->
<!-- EMPTY STATE -->
<!-- ================================================= -->

<div class="personalized-empty">

    <div class="personalized-empty-icon">

        <i class="bi bi-stars"></i>

    </div>

    <h4>
        Start Exploring RentEasy
    </h4>

    <p>
        View, search and wishlist products to help
        RentEasy learn what you are interested in.
    </p>

</div>


<%
}
%>

</div>
