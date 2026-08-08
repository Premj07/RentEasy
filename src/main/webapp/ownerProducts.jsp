<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
/* =========================================================
   LOGIN CHECK
========================================================= */

String email = (String) session.getAttribute("email");

if(email == null){

    response.sendRedirect("index.jsp");
    return;
}


/* =========================================================
   KYC CHECK
========================================================= */

Connection checkCon = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    checkCon = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    PreparedStatement checkPs =
        checkCon.prepareStatement(

            "SELECT status FROM kyc WHERE email=?"

        );


    checkPs.setString(1,email);


    ResultSet checkRs =
        checkPs.executeQuery();


    if(!checkRs.next()){

        checkRs.close();
        checkPs.close();
        checkCon.close();

        response.sendRedirect("kyc.jsp");
        return;
    }


    String kycStatus =
        checkRs.getString("status");


    checkRs.close();
    checkPs.close();


    if(!"Approved".equalsIgnoreCase(kycStatus)){

        checkCon.close();

        response.sendRedirect("kyc.jsp");
        return;
    }


} catch(Exception e){

    e.printStackTrace();

} finally {

    if(checkCon != null){

        try{
            checkCon.close();
        }catch(SQLException ignored){}
    }
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    My Products - RentEasy
</title>


<!-- EXISTING NAVBAR CSS -->

<link rel="stylesheet"
      href="css/navbar.css">


<!-- OWNER DASHBOARD CSS -->

<link rel="stylesheet"
      href="css/owner-dashboard.css">


<!-- BOOTSTRAP ICONS -->

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>

/* =========================================================
   MY PRODUCTS PAGE
========================================================= */

.owner-page-header{

    display:flex;

    justify-content:space-between;

    align-items:center;

    gap:20px;

    margin-bottom:22px;

}


.owner-page-title{

    display:flex;

    align-items:center;

    gap:13px;

}


.owner-page-title-icon{

    width:45px;
    height:45px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#eff6ff;

    color:#2563eb;

    border-radius:12px;

    font-size:20px;

}


.owner-page-title h1{

    margin:0;

    color:#0f172a;

    font-size:24px;

    font-weight:700;

}


.owner-page-title p{

    margin:5px 0 0;

    color:#64748b;

    font-size:12px;

}


/* =========================================================
   SUMMARY
========================================================= */

.product-page-summary{

    display:grid;

    grid-template-columns:
        repeat(4,minmax(0,1fr));

    gap:14px;

    margin-bottom:24px;

}


.product-summary-card{

    background:#ffffff;

    border:1px solid #e5e7eb;

    border-radius:13px;

    padding:17px;

    display:flex;

    align-items:center;

    gap:12px;

    box-shadow:
        0 3px 10px
        rgba(15,23,42,.04);

}


.product-summary-icon{

    width:39px;
    height:39px;

    min-width:39px;

    border-radius:10px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:#eff6ff;

    color:#2563eb;

    font-size:17px;

}


.product-summary-card h3{

    margin:0;

    color:#0f172a;

    font-size:20px;

    font-weight:700;

}


.product-summary-card p{

    margin:3px 0 0;

    color:#64748b;

    font-size:10px;

}


/* =========================================================
   PRODUCTS PANEL
========================================================= */

.owner-products-panel{

    background:#ffffff;

    border:1px solid #e5e7eb;

    border-radius:15px;

    padding:20px;

    box-shadow:
        0 4px 14px
        rgba(15,23,42,.04);

}


/* Hide duplicate component header because this page
   already has its own page heading */

.owner-products-panel > .section-header{

    margin-top:0;

}


/* =========================================================
   RESPONSIVE
========================================================= */

@media(max-width:1000px){

    .product-page-summary{

        grid-template-columns:
            repeat(2,1fr);

    }

}


@media(max-width:600px){

    .owner-page-header{

        flex-direction:column;

        align-items:flex-start;

    }


    .product-page-summary{

        grid-template-columns:1fr;

    }

}

</style>

</head>


<body>


<!-- =========================================================
     SAME RENTEASY NAVBAR
========================================================= -->

<jsp:include page="includes/navbar.jsp"/>



<!-- =========================================================
     SAME OWNER SIDEBAR
========================================================= -->

<jsp:include page="includes/owner-sidebar.jsp"/>



<!-- =========================================================
     MAIN CONTENT
========================================================= -->

<div class="main-content">


    <!-- =====================================================
         PAGE HEADER
    ====================================================== -->

    <div class="owner-page-header">


        <div class="owner-page-title">


            <div class="owner-page-title-icon">

                <i class="bi bi-box-seam"></i>

            </div>


            <div>

                <h1>
                    My Products
                </h1>

                <p>
                    Manage all products listed on your
                    RentEasy owner account.
                </p>

            </div>


        </div>



        <a href="addProduct.jsp"
           class="btn-add-product">

            <i class="bi bi-plus-circle"></i>

            Add Product

        </a>


    </div>



    <!-- =====================================================
         PRODUCT COUNTERS
    ====================================================== -->

<%

int pageTotalProducts = 0;
int pageAvailableProducts = 0;
int pageRentedProducts = 0;
int pagePendingProducts = 0;

Connection summaryCon = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");


    summaryCon =
        DriverManager.getConnection(

            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456"

        );


    PreparedStatement summaryPs =
        summaryCon.prepareStatement(

        "SELECT " +

        "COUNT(*) AS total, " +

        "SUM(CASE " +
        "WHEN UPPER(availability)='AVAILABLE' " +
        "THEN 1 ELSE 0 END) AS available_count, " +

        "SUM(CASE " +
        "WHEN UPPER(availability)='RENTED' " +
        "THEN 1 ELSE 0 END) AS rented_count, " +

        "SUM(CASE " +
        "WHEN LOWER(status)='pending' " +
        "THEN 1 ELSE 0 END) AS pending_count " +

        "FROM products " +

        "WHERE owner=?"

    );


    summaryPs.setString(
        1,
        email
    );


    ResultSet summaryRs =
        summaryPs.executeQuery();


    if(summaryRs.next()){

        pageTotalProducts =
            summaryRs.getInt("total");

        pageAvailableProducts =
            summaryRs.getInt(
                "available_count"
            );

        pageRentedProducts =
            summaryRs.getInt(
                "rented_count"
            );

        pagePendingProducts =
            summaryRs.getInt(
                "pending_count"
            );

    }


    summaryRs.close();
    summaryPs.close();


}catch(Exception e){

    e.printStackTrace();

}finally{

    if(summaryCon != null){

        try{
            summaryCon.close();
        }catch(SQLException ignored){}
    }

}

%>


    <div class="product-page-summary">


        <!-- TOTAL -->

        <div class="product-summary-card">

            <div class="product-summary-icon">

                <i class="bi bi-box-seam"></i>

            </div>

            <div>

                <h3>
                    <%=pageTotalProducts%>
                </h3>

                <p>
                    Total Products
                </p>

            </div>

        </div>



        <!-- AVAILABLE -->

        <div class="product-summary-card">

            <div class="product-summary-icon">

                <i class="bi bi-check-circle"></i>

            </div>

            <div>

                <h3>
                    <%=pageAvailableProducts%>
                </h3>

                <p>
                    Available
                </p>

            </div>

        </div>



        <!-- RENTED -->

        <div class="product-summary-card">

            <div class="product-summary-icon">

                <i class="bi bi-arrow-repeat"></i>

            </div>

            <div>

                <h3>
                    <%=pageRentedProducts%>
                </h3>

                <p>
                    Currently Rented
                </p>

            </div>

        </div>



        <!-- PENDING -->

        <div class="product-summary-card">

            <div class="product-summary-icon">

                <i class="bi bi-hourglass-split"></i>

            </div>

            <div>

                <h3>
                    <%=pagePendingProducts%>
                </h3>

                <p>
                    Pending Approval
                </p>

            </div>

        </div>


    </div>



    <!-- =====================================================
         PRODUCT LIST

         Reuse the component we already created.
    ====================================================== -->

    <div class="owner-products-panel">

        <jsp:include page="includes/owner-products.jsp"/>

    </div>


</div>



<script src="js/dashboard.js"></script>


</body>

</html>