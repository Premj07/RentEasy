<%@ page session="true" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>KYC | RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="css/dashboard.css">
<link rel="stylesheet" href="css/navbar.css">
<link rel="stylesheet" href="css/kyc.css">

</head>

<body>

<jsp:include page="includes/navbar.jsp"/>

<div class="dashboard-layout">

    <jsp:include page="includes/sidebar.jsp"/>

    <main class="main-content">

<div class="kyc-card">

    <div class="card-header">

        <h2>Complete Your KYC</h2>

        <p>
            Verify your identity to rent and list products on RentEasy.
        </p>

    </div>

    <form action="saveKyc"
          method="post"
          enctype="multipart/form-data">

        <!-- ================= NAME ================= -->

<div class="row g-4">

    <div class="col-md-4">

        <label class="form-label">
            First Name
        </label>

        <input
            type="text"
            name="firstName"
            class="form-control"
            value="<%= session.getAttribute("firstName") %>"
            readonly>

    </div>

    <div class="col-md-4">

        <label class="form-label">
            Middle Name
        </label>

        <input
            type="text"
            name="middleName"
            class="form-control"
            placeholder="Optional">

    </div>

    <div class="col-md-4">

        <label class="form-label">
            Last Name
        </label>

        <input
            type="text"
            name="lastName"
            class="form-control"
            value="<%= session.getAttribute("lastName") %>"
            readonly>

    </div>
    <!-- ================= EMAIL ================= -->

<div class="row mt-3">

    <div class="col-md-9">

        <label class="form-label">
            Email Address
        </label>

        <input
            type="email"
            id="email"
            name="email"
            class="form-control"
            value="<%= session.getAttribute("email") %>"
            readonly>

    </div>

    <div class="col-md-3 d-flex align-items-end">

        <button
            type="button"
            class="btn btn-primary w-100"
            onclick="sendEmailOtp()">

            Send OTP

        </button>

    </div>

</div>

<div class="row mt-4">

    <div class="col-md-12">

        <label class="form-label">
            Email OTP
        </label>

        <input
            type="text"
            id="otp"
            name="otp"
            class="form-control"
            placeholder="Enter Email OTP">

    </div>

</div>
<!-- ================= ADDRESS ================= -->

<div class="row mt-4">

    <div class="col-md-12">

        <label class="form-label">
            Current Address
        </label>

        <textarea
            class="form-control"
            name="address"
            rows="4"
            placeholder="Enter your current address"></textarea>

    </div>

</div>
<!-- ================= DOCUMENTS ================= -->

<div class="row mt-4">

    <div class="col-md-4">

        <label class="form-label">
            College ID Card
        </label>

        <input
            type="file"
            class="form-control"
            name="collegeId"
            required>

    </div>

    <div class="col-md-4">

        <label class="form-label">
            Aadhaar Card
        </label>

        <input
            type="file"
            class="form-control"
            name="aadhaarCard"
            required>

    </div>

    <div class="col-md-4">

        <label class="form-label">
            Profile Photo
        </label>

        <input
            type="file"
            class="form-control"
            name="photo"
            required>

    </div>

</div>

<div class="form-check mt-4">

    <input
        class="form-check-input"
        type="checkbox"
        required
        id="agree">

    <label
        class="form-check-label"
        for="agree">

        I agree to the
        <a href="terms.jsp">
            Terms & Conditions
        </a>

    </label>

</div>
<div class="d-grid mt-4">

    <button
        class="btn btn-primary btn-lg">

        Complete KYC

    </button>

</div>

</div>

    </form>

</div>

</main>
</div>

<script src="js/dashboard.js"></script>
<script>
function sendEmailOtp(){

    var email = document.getElementById("email").value;

    fetch("sendKycOtp?email=" + encodeURIComponent(email))
        .then(response => response.text())
        .then(data => {
            alert(data);
        })
        .catch(error => {
            alert("Failed to send OTP");
        });

}
</script>
</body>
</html>
