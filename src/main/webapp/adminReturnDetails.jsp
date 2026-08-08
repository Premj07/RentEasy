<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%@ include file="adminLayout.jsp" %>

<%
String rentalIdParam = request.getParameter("rentalId");

if(rentalIdParam == null || rentalIdParam.trim().isEmpty()){
    response.sendRedirect("adminReturns.jsp");
    return;
}

int rentalId;

try{
    rentalId = Integer.parseInt(rentalIdParam);
}
catch(NumberFormatException e){
    response.sendRedirect("adminReturns.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    String sql =
        "SELECT " +

        "r.rental_id, " +
        "r.start_date, " +
        "r.end_date, " +
        "r.rent_amount, " +
        "r.security_deposit, " +
        "r.rental_status, " +
        "r.payment_status, " +
        "r.pickup_status, " +

        "p.name AS product_name, " +
        "p.image AS product_image, " +

        "CONCAT(u.first_name,' ',u.last_name) AS renter_name, " +
        "u.email AS renter_email, " +
        "u.phone AS renter_phone, " +

        "CONCAT(o.first_name,' ',o.last_name) AS owner_name, " +
        "o.email AS owner_email, " +
        "o.phone AS owner_phone " +

        "FROM rentals r " +

        "JOIN products p ON r.product_id=p.id " +
        "JOIN users u ON r.user_id=u.id " +
        "JOIN users o ON r.owner_id=o.id " +

        "WHERE r.rental_id=?";

    ps = con.prepareStatement(sql);

    ps.setInt(1, rentalId);

    rs = ps.executeQuery();

    if(!rs.next()){
%>

<div class="container-fluid px-4 py-4">

    <div class="alert alert-warning">
        Rental record not found.
    </div>

    <a href="adminReturns.jsp"
       class="btn btn-primary">
        Back to Returns
    </a>

</div>

<%
        return;
    }

    String status =
        rs.getString("rental_status");

    String statusText = status;

    String statusClass = "status-default";

    if("ACTIVE".equalsIgnoreCase(status)){

        statusText = "Active Rental";
        statusClass = "status-active";

    }
    else if("RETURN_REQUESTED".equalsIgnoreCase(status)){

        statusText = "Return Requested";
        statusClass = "status-requested";

    }
    else if("RETURN_APPROVED".equalsIgnoreCase(status)){

        statusText = "Waiting for Owner";
        statusClass = "status-approved";

    }
    else if("RETURNED".equalsIgnoreCase(status)){

        statusText = "Product Returned";
        statusClass = "status-returned";

    }
%>

<style>

.return-page{
    padding:38px 42px;
    background:#f8fafc;
    min-height:100vh;
}

.page-top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:30px;
}

.page-title{
    font-size:30px;
    font-weight:750;
    color:#0f172a;
    margin:0;
}

.page-subtitle{
    color:#64748b;
    margin-top:7px;
}

.back-link{
    text-decoration:none;
    color:#2563eb;
    font-weight:600;
}

.main-card{
    background:#fff;
    border:1px solid #e2e8f0;
    border-radius:18px;
    box-shadow:0 8px 28px rgba(15,23,42,.05);
    overflow:hidden;
}

.card-header-custom{
    padding:25px 28px;
    border-bottom:1px solid #e2e8f0;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.rental-number{
    color:#64748b;
    font-size:14px;
}

.status-badge{
    padding:9px 15px;
    border-radius:30px;
    font-size:13px;
    font-weight:700;
}

.status-active{
    background:#dcfce7;
    color:#15803d;
}

.status-requested{
    background:#fef3c7;
    color:#b45309;
}

.status-approved{
    background:#fff7ed;
    color:#c2410c;
}

.status-returned{
    background:#dcfce7;
    color:#15803d;
}

.status-default{
    background:#e2e8f0;
    color:#475569;
}

.card-content{
    padding:30px;
}

.product-section{
    display:flex;
    gap:22px;
    align-items:center;
    padding-bottom:28px;
    border-bottom:1px solid #e2e8f0;
}

.product-image{
    width:125px;
    height:125px;
    object-fit:cover;
    border-radius:14px;
    border:1px solid #e2e8f0;
}

.product-title{
    font-size:25px;
    font-weight:750;
    color:#0f172a;
}

.product-label{
    color:#64748b;
    font-size:14px;
}

.info-section{
    margin-top:28px;
}

.section-title{
    font-size:18px;
    font-weight:700;
    color:#0f172a;
    margin-bottom:18px;
}

.person-card{
    height:100%;
    padding:22px;
    border:1px solid #e2e8f0;
    border-radius:14px;
    background:#fff;
}

.person-type{
    color:#64748b;
    font-size:13px;
    font-weight:600;
    text-transform:uppercase;
    letter-spacing:.5px;
}

.person-name{
    font-size:19px;
    font-weight:700;
    color:#0f172a;
    margin-top:6px;
}

.person-info{
    color:#64748b;
    font-size:14px;
    margin-top:8px;
}

.details-box{
    margin-top:25px;
    padding:24px;
    border:1px solid #e2e8f0;
    border-radius:14px;
}

.detail-row{
    display:flex;
    justify-content:space-between;
    padding:13px 0;
    border-bottom:1px solid #edf2f7;
}

.detail-row:last-child{
    border-bottom:none;
}

.detail-label{
    color:#64748b;
}

.detail-value{
    color:#0f172a;
    font-weight:650;
}

.money{
    color:#16a34a;
    font-weight:750;
}

.return-flow{
    margin-top:28px;
    background:#f8fafc;
    border:1px solid #e2e8f0;
    border-radius:14px;
    padding:24px;
}

.flow-title{
    font-weight:700;
    margin-bottom:20px;
}

.flow{
    display:flex;
    align-items:center;
    justify-content:space-between;
}

.flow-step{
    text-align:center;
    flex:1;
}

.flow-circle{
    width:42px;
    height:42px;
    border-radius:50%;
    margin:auto;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:700;
    background:#e2e8f0;
    color:#64748b;
}

.flow-circle.done{
    background:#dcfce7;
    color:#16a34a;
}

.flow-circle.current{
    background:#fff7ed;
    color:#ea580c;
}

.flow-label{
    margin-top:8px;
    font-size:13px;
    font-weight:600;
}

.flow-line{
    height:2px;
    background:#e2e8f0;
    flex:.6;
}

.action-box{
    margin-top:28px;
    padding:22px;
    border-radius:14px;
    background:#fff7ed;
    border:1px solid #fed7aa;
}

.action-title{
    color:#9a3412;
    font-weight:700;
    font-size:17px;
}

.action-text{
    color:#9a3412;
    margin-top:8px;
    margin-bottom:0;
}

</style>


<div class="return-page">

    <div class="page-top">

        <div>

            <h1 class="page-title">
                Return Details
            </h1>

            <div class="page-subtitle">
                Review rental, renter, owner and return progress.
            </div>

        </div>

        <a href="adminReturns.jsp"
           class="back-link">

            ← Back to Returns

        </a>

    </div>


    <div class="main-card">

        <div class="card-header-custom">

            <div>

                <strong>
                    Rental Return
                </strong>

                <div class="rental-number">
                    Rental ID #<%=rs.getInt("rental_id")%>
                </div>

            </div>

            <span class="status-badge <%=statusClass%>">
                <%=statusText%>
            </span>

        </div>


        <div class="card-content">


            <!-- PRODUCT -->

            <div class="product-section">

                <img
                    src="<%=request.getContextPath()%>/<%=rs.getString("product_image")%>"
                    class="product-image"
                    alt="Product">

                <div>

                    <div class="product-label">
                        Product
                    </div>

                    <div class="product-title">
                        <%=rs.getString("product_name")%>
                    </div>

                    <div class="product-label mt-2">

                        Rental period:
                        <%=rs.getDate("start_date")%>
                        →
                        <%=rs.getDate("end_date")%>

                    </div>

                </div>

            </div>



            <!-- RENTER + OWNER -->

            <div class="info-section">

                <div class="section-title">
                    Rental Participants
                </div>

                <div class="row g-4">


                    <!-- RENTER -->

                    <div class="col-md-6">

                        <div class="person-card">

                            <div class="person-type">
                                Renter
                            </div>

                            <div class="person-name">
                                <%=rs.getString("renter_name")%>
                            </div>

                            <div class="person-info">

                                ✉
                                <%=rs.getString("renter_email")%>

                            </div>

                            <div class="person-info">

                                ☎
                                <%=rs.getString("renter_phone")%>

                            </div>

                        </div>

                    </div>



                    <!-- OWNER -->

                    <div class="col-md-6">

                        <div class="person-card">

                            <div class="person-type">
                                Product Owner
                            </div>

                            <div class="person-name">
                                <%=rs.getString("owner_name")%>
                            </div>

                            <div class="person-info">

                                ✉
                                <%=rs.getString("owner_email")%>

                            </div>

                            <div class="person-info">

                                ☎
                                <%=rs.getString("owner_phone")%>

                            </div>

                        </div>

                    </div>

                </div>

            </div>



            <!-- RENTAL DETAILS -->

            <div class="details-box">

                <div class="section-title">
                    Rental Information
                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Rental ID
                    </span>

                    <span class="detail-value">
                        #<%=rs.getInt("rental_id")%>
                    </span>

                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Rental Period
                    </span>

                    <span class="detail-value">

                        <%=rs.getDate("start_date")%>
                        -
                        <%=rs.getDate("end_date")%>

                    </span>

                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Rent Amount
                    </span>

                    <span class="money">

                        ₹<%=String.format(
                            "%.2f",
                            rs.getDouble("rent_amount")
                        )%>

                    </span>

                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Security Deposit
                    </span>

                    <span class="detail-value">

                        ₹<%=String.format(
                            "%.2f",
                            rs.getDouble("security_deposit")
                        )%>

                    </span>

                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Payment
                    </span>

                    <span class="detail-value">
                        <%=rs.getString("payment_status")%>
                    </span>

                </div>


                <div class="detail-row">

                    <span class="detail-label">
                        Pickup
                    </span>

                    <span class="detail-value">
                        <%=rs.getString("pickup_status")%>
                    </span>

                </div>

            </div>



            <!-- RETURN FLOW -->

            <div class="return-flow">

                <div class="flow-title">
                    Return Progress
                </div>

                <div class="flow">


                    <div class="flow-step">

                        <div class="flow-circle done">
                            ✓
                        </div>

                        <div class="flow-label">
                            Return Requested
                        </div>

                    </div>


                    <div class="flow-line"></div>


                    <div class="flow-step">

                        <div class="flow-circle done">
                            ✓
                        </div>

                        <div class="flow-label">
                            Admin Approved
                        </div>

                    </div>


                    <div class="flow-line"></div>


                    <div class="flow-step">

                        <div class="flow-circle
                        <%=
                        "RETURN_APPROVED".equalsIgnoreCase(status)
                        ? "current"
                        :
                        "RETURNED".equalsIgnoreCase(status)
                        ? "done"
                        : ""
                        %>">

                            <%=
                            "RETURNED".equalsIgnoreCase(status)
                            ? "✓"
                            : "3"
                            %>

                        </div>

                        <div class="flow-label">
                            Owner Verification
                        </div>

                    </div>


                    <div class="flow-line"></div>


                    <div class="flow-step">

                        <div class="flow-circle
                        <%=
                        "RETURNED".equalsIgnoreCase(status)
                        ? "current"
                        : ""
                        %>">

                            4

                        </div>

                        <div class="flow-label">
                            Deposit Refund
                        </div>

                    </div>


                </div>

            </div>


            <% if("RETURN_APPROVED".equalsIgnoreCase(status)){ %>

            <div class="action-box">

                <div class="action-title">
                    Waiting for Owner Verification
                </div>

                <p class="action-text">

                    The admin has approved this return.
                    The product owner must verify the return OTP
                    when the renter physically hands over the product.

                </p>

            </div>

            <% } %>


            <% if("RETURNED".equalsIgnoreCase(status)){ %>

            <div class="alert alert-success mt-4">

                <strong>
                    ✓ Product Return Verified
                </strong>

                <br>

                The product has been returned successfully.
                The security deposit can now proceed to refund processing.

            </div>

            <% } %>


        </div>

    </div>

</div>


<%

}
catch(Exception e){

%>

<div class="container-fluid px-5 py-4">

    <div class="alert alert-danger">

        <strong>
            Unable to load return details.
        </strong>

        <br>

        <%=e.getMessage()%>

    </div>

    <a href="adminReturns.jsp"
       class="btn btn-primary">

        Back to Returns

    </a>

</div>

<%

}
finally{

    try{

        if(rs != null)
            rs.close();

        if(ps != null)
            ps.close();

        if(con != null)
            con.close();

    }
    catch(Exception ignored){}

}
%>