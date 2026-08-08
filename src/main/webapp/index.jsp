<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>RentEasy | Rent Smarter</title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/navbar.css">
<link rel="stylesheet" href="css/hero.css">
<link rel="stylesheet" href="css/features.css">
<link rel="stylesheet" href="css/categories.css">
<link rel="stylesheet" href="css/delivery.css">
<link rel="stylesheet" href="css/products.css">
<link rel="stylesheet" href="css/testimonial.css">
<link rel="stylesheet" href="css/faq.css">
<link rel="stylesheet" href="css/footer.css">
<link rel="stylesheet" href="css/responsive.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
rel="stylesheet">

</head>

<body>

<!-- ================= NAVBAR ================= -->

<header class="navbar">

<div class="container nav-container">

<a href="index.jsp" class="logo">

<img src="images/logo.png.jpeg" alt="RentEasy">

<span>RentEasy</span>

</a>

<nav>

<ul class="nav-links">

<li><a href="#home">Home</a></li>

<li><a href="#features">Features</a></li>

<li><a href="#categories">Categories</a></li>

<li><a href="#delivery">Delivery</a></li>

<li><a href="#about">About</a></li>

<li><a href="#contact">Contact</a></li>

</ul>

</nav>

<div class="nav-buttons">

<button
class="btn btn-outline-primary"
data-bs-toggle="modal"
data-bs-target="#loginModal">

Login

</button>

<button
class="btn btn-primary"
data-bs-toggle="modal"
data-bs-target="#signupModal">

Sign Up

</button>

</div>

</div>

</header>

<!-- ================= HERO ================= -->

<section class="hero" id="home">

<div class="container hero-container">

<div class="hero-left">

<div class="hero-tag">

<i class="fa-solid fa-circle-check"></i>

Trusted by MIT-ADT Students

</div>

<h1>

Rent Smarter.

<br>

<span>Live Better.</span>

</h1>

<p>

RentEasy is an exclusive rental marketplace for MIT-ADT students and faculty.

Rent electronics, furniture, books, sports equipment, appliances and more

without paying full purchase cost.

</p>

<div class="hero-buttons">

<a href="products.jsp" class="primary-btn">

Browse Products

<i class="fa-solid fa-arrow-right"></i>

</a>

<a href="index.jsp" class="secondary-btn">

List Your Product

</a>

</div>

<div class="hero-info">

<div>

<i class="fa-solid fa-shield-halved"></i>

Verified Owners

</div>

<div>

<i class="fa-solid fa-truck-fast"></i>

Fast Delivery

</div>

<div>

<i class="fa-solid fa-wallet"></i>

Affordable Rentals

</div>

</div>

</div>





<div class="hero-right">

<img src="images/hero.jpg" alt="RentEasy Hero">

</div>

</div>

</section>

<!-- ================= STATISTICS ================= -->

<section class="stats">

<div class="container stats-container">

<div class="stat-card">

<h2>500+</h2>

<p>Products Listed</p>

</div>

<div class="stat-card">

<h2>300+</h2>

<p>MIT-ADT Students</p>

</div>

<div class="stat-card">

<h2>100%</h2>

<p>Verified Users</p>

</div>

<div class="stat-card">

<h2>24/7</h2>

<p>Support</p>

</div>

</div>

</section>

<!-- ================= WHY RENTEASY ================= -->

<section class="features" id="features">

<div class="container">

<div class="section-title">

<h5>WHY RENTEASY</h5>

<h2>Everything you need to rent with confidence</h2>

<p>

A secure, affordable and trusted rental platform exclusively built for MIT-ADT students.

</p>

</div>

<div class="feature-grid">

<div class="feature-card">

<i class="fas fa-user-check"></i>

<h3>Verified Users</h3>

<p>

Every user verifies College ID, Aadhaar and Email before renting.

</p>

</div>

<div class="feature-card">

<i class="fas fa-shield-alt"></i>

<h3>Secure Payments</h3>

<p>

Deposit protection and secure online payments.

</p>

</div>

<div class="feature-card">

<i class="fas fa-truck"></i>

<h3>Pickup or Porter</h3>

<p>

Choose Self Pickup or Porter Delivery.

</p>

</div>

<div class="feature-card">

<i class="fas fa-key"></i>

<h3>OTP Handover</h3>

<p>

Product handover starts only after OTP verification.

</p>

</div>

<div class="feature-card">

<i class="fas fa-file-contract"></i>

<h3>Digital Agreement</h3>

<p>

Automatic rental agreement generated instantly.

</p>

</div>

<div class="feature-card">

<i class="fas fa-map-marker-alt"></i>

<h3>Nearby Owners</h3>

<p>

View owner location and distance before renting.

</p>

</div>

</div>

</div>

</section>



<!-- FEATURES -->

<!-- ================= FEATURED PRODUCTS ================= -->

<section class="products">

<div class="container">

<div class="section-title">

<h5>FEATURED PRODUCTS</h5>

<h2>Popular Rentals Around You</h2>

<p>
Browse the most rented products by MIT-ADT students.
</p>

</div>

<div class="product-grid">

<!-- Product Card -->

<div class="product-card">

<div class="wishlist">
<i class="far fa-heart"></i>
</div>

<img src="images/laptop.jpeg">

<div class="product-info">

<span class="category-tag">
Electronics
</span>

<h3>HP Laptop</h3>

<div class="rating">

<i class="fas fa-star"></i>
<i class="fas fa-star"></i>
<i class="fas fa-star"></i>
<i class="fas fa-star"></i>
<i class="fas fa-star-half-alt"></i>

<span>(4.8)</span>

</div>

<h4>

₹250

<span>/day</span>

</h4>

<div class="product-buttons">

<a href="#" class="rent-btn">
Rent Now
</a>

<a href="#" class="buy-btn">
Buy
</a>

</div>

</div>

</div>

<!-- Product 2 -->

<div class="product-card">

<div class="wishlist">
<i class="far fa-heart"></i>
</div>

<img src="images/chair.jpg">

<div class="product-info">

<span class="category-tag">
Furniture
</span>

<h3>Study Chair</h3>

<div class="rating">

★★★★★

<span>(4.9)</span>

</div>

<h4>

₹60

<span>/day</span>

</h4>

<div class="product-buttons">

<a href="#">Rent</a>

<a href="#">Buy</a>

</div>

</div>

</div>

<!-- Product 3 -->

<div class="product-card">

<div class="wishlist">
<i class="far fa-heart"></i>
</div>

<img src="images/camera.jpg">

<div class="product-info">

<span class="category-tag">

Electronics

</span>

<h3>Canon DSLR</h3>

<div class="rating">

★★★★★

<span>(5.0)</span>

</div>

<h4>

₹450

<span>/day</span>

</h4>

<div class="product-buttons">

<a href="#">Rent</a>

<a href="#">Buy</a>

</div>

</div>

</div>

</div>

</div>

</section>





<!-- CATEGORIES -->

<!-- ================= CATEGORIES ================= -->

<section class="categories" id="categories">

<div class="container">

<div class="section-title">

<h5>CATEGORIES</h5>

<h2>Find exactly what you need</h2>

<p>

Explore products available for rent around MIT-ADT.

</p>

</div>

<div class="category-grid">

<div class="category-card">
<i class="fas fa-laptop"></i>
<h3>Electronics</h3>
</div>

<div class="category-card">
<i class="fas fa-couch"></i>
<h3>Furniture</h3>
</div>

<div class="category-card">
<i class="fas fa-book"></i>
<h3>Books</h3>
</div>

<div class="category-card">
<i class="fas fa-football-ball"></i>
<h3>Sports</h3>
</div>

<div class="category-card">
<i class="fas fa-gamepad"></i>
<h3>Gaming</h3>
</div>

<div class="category-card">
<i class="fas fa-tshirt"></i>
<h3>Fashion</h3>
</div>

<div class="category-card">
<i class="fas fa-tools"></i>
<h3>Tools</h3>
</div>

<div class="category-card">
<i class="fas fa-blender"></i>
<h3>Appliances</h3>
</div>

</div>

</div>

</section>




<!-- DELIVERY -->

<!-- ================= DELIVERY ================= -->

<section class="delivery" id="delivery">

<div class="container">

<div class="section-title">
<h5>HOW IT WORKS</h5>
<h2>Rent in 5 Simple Steps</h2>
<p>
Choose your product, complete payment, and receive it through Self Pickup or Porter Delivery.
</p>
</div>

<div class="delivery-grid">

<div class="delivery-card">
<div class="step-number">1</div>
<i class="fas fa-search"></i>
<h3>Browse Products</h3>
<p>Find electronics, furniture, books, sports equipment and much more.</p>
</div>

<div class="delivery-card">
<div class="step-number">2</div>
<i class="fas fa-calendar-check"></i>
<h3>Book Instantly</h3>
<p>Select rental dates and submit your booking request.</p>
</div>

<div class="delivery-card">
<div class="step-number">3</div>
<i class="fas fa-credit-card"></i>
<h3>Pay Securely</h3>
<p>Pay rent and security deposit through our secure payment system.</p>
</div>

<div class="delivery-card">
<div class="step-number">4</div>
<i class="fas fa-truck"></i>
<h3>Pickup or Porter</h3>
<p>Choose Self Pickup or get the product delivered through Porter.</p>
</div>

<div class="delivery-card">
<div class="step-number">5</div>
<i class="fas fa-key"></i>
<h3>OTP Handover</h3>
<p>Verify the OTP and start using your rented product safely.</p>
</div>

</div>

</div>

</section>





<!-- TESTIMONIAL -->

<!-- ================= TESTIMONIALS ================= -->

<section class="testimonials" id="testimonials">

<div class="container">

<div class="section-title">

<h5>TESTIMONIALS</h5>

<h2>What Our Students Say</h2>

<p>
Hear from MIT-ADT students who have used RentEasy.
</p>

</div>

<div class="testimonial-grid">

<!-- Card 1 -->

<div class="testimonial-card">

<div class="user-avatar">
    PS
</div>

<div class="stars">
★★★★★
</div>

<p>
"RentEasy helped me rent a study table within minutes. The pickup process was smooth and the product quality was excellent."
</p>

<h3>Rahul Sharma</h3>

<span>B.Tech CSE, MIT-ADT</span>

</div>

<!-- Card 2 -->

<div class="testimonial-card">

<div class="user-avatar">
    DO
</div>

<div class="stars">
★★★★★
</div>

<p>
"I rented a DSLR camera for our college event. The booking was easy and the owner was verified."
</p>

<h3>Priya Patil</h3>

<span>BBA, MIT-ADT</span>

</div>

<!-- Card 3 -->

<div class="testimonial-card">

<div class="user-avatar">
    EC
</div>

<div class="stars">
★★★★★
</div>

<p>
"Porter Delivery saved me so much time. Everything was tracked and I received my product safely."
</p>

<h3>Aman Deshmukh</h3>

<span>B.Tech AI, MIT-ADT</span>

</div>

</div>

</div>

</section>





<!-- FAQ -->

<!-- ================= FAQ ================= -->

<section class="faq" id="faq">

<div class="container">

<div class="section-title">
<h5>FAQ</h5>
<h2>Frequently Asked Questions</h2>
<p>Everything you need to know about RentEasy.</p>
</div>

<div class="faq-container">

<div class="faq-item active">
<div class="faq-question">
<h3>Who can use RentEasy?</h3>
<span>+</span>
</div>
<div class="faq-answer">
<p>Only verified MIT-ADT students and faculty members can register and rent products.</p>
</div>
</div>

<div class="faq-item">
<div class="faq-question">
<h3>How do I verify my account?</h3>
<span>+</span>
</div>
<div class="faq-answer">
<p>Complete Email OTP verification and upload your College ID and Aadhaar details during KYC.</p>
</div>
</div>

<div class="faq-item">
<div class="faq-question">
<h3>Can I choose Self Pickup?</h3>
<span>+</span>
</div>
<div class="faq-answer">
<p>Yes. You can either pick up the product yourself or choose Porter Delivery if available.</p>
</div>
</div>

<div class="faq-item">
<div class="faq-question">
<h3>Is the security deposit refundable?</h3>
<span>+</span>
</div>
<div class="faq-answer">
<p>Yes. After the owner confirms the product is returned in good condition, the deposit is refunded.</p>
</div>
</div>

<div class="faq-item">
<div class="faq-question">
<h3>How does OTP handover work?</h3>
<span>+</span>
</div>
<div class="faq-answer">
<p>The rental starts only after the owner verifies the pickup OTP generated by RentEasy.</p>
</div>
</div>

</div>

</div>

</section>





<!-- FOOTER -->

<!-- ================= FOOTER ================= -->

<footer class="footer">

<div class="container">

<div class="footer-top">

<div class="footer-about">

<h2>RentEasy</h2>

<p>
India's trusted rental platform for MIT-ADT students.
Rent laptops, furniture, books, electronics, sports equipment and much more with confidence.
</p>

<div class="social-icons">

<a href="#"><i class="fab fa-facebook-f"></i></a>

<a href="#"><i class="fab fa-instagram"></i></a>

<a href="#"><i class="fab fa-linkedin-in"></i></a>

<a href="#"><i class="fab fa-x-twitter"></i></a>

</div>

</div>

<div class="footer-links">

<h3>RentEasy</h3>

<a href="#">About Us</a>

<a href="#">Our Team</a>

<a href="#">Careers</a>

<a href="#">Blog</a>

<a href="#">Contact</a>

</div>

<div class="footer-links">

<h3>Support</h3>

<a href="#">Help Center</a>

<a href="#">Rental Policy</a>

<a href="#">Return Policy</a>

<a href="#">Privacy Policy</a>

<a href="#">Terms & Conditions</a>

</div>

<div class="footer-links">

<h3>Contact</h3>

<p><i class="fas fa-map-marker-alt"></i> MIT-ADT University, Pune</p>

<p><i class="fas fa-envelope"></i> renteasy.project@gmail.com</p>


</div>

</div>

<hr>

<div class="footer-bottom">

<p>© 2026 RentEasy. All Rights Reserved.</p>

<p>Made with ❤️ by Team RentEasy</p>

</div>

</div>

</footer>
<!-- ================= LOGIN MODAL ================= -->

<div class="modal fade" id="loginModal" tabindex="-1">

<div class="modal-dialog modal-dialog-centered">

<div class="modal-content signup-modal">

<div class="modal-header border-0">

<h4 class="modal-title fw-bold">

Login

</h4>

<button
type="button"
class="btn-close"
data-bs-dismiss="modal"></button>

</div>

<div class="modal-body">

<form action="verifyLoginOtp" method="post">

    <div class="input-group mb-3">
        <input
            type="email"
            id="loginEmail"
            name="email"
            class="form-control"
            placeholder="Registered Email"
            required>

        <button
            type="button"
            class="btn btn-primary"
            onclick="sendLoginOTP()">
            Send OTP
        </button>
    </div>

    <input
        type="text"
        name="otp"
        class="form-control mb-2"
        placeholder="Enter OTP"
        required>

    <button type="submit" class="btn btn-primary w-100 mt-3">
        Verify & Login
    </button>

</form>

<hr>

<p class="text-center">

New User?

<a href="#"
onclick="openSignup()">

Create Account

</a>

</p>

</div>

</div>

</div>

</div>
<!-- Signup Modal -->
<!-- ================= SIGNUP MODAL ================= -->

<div class="modal fade" id="signupModal" tabindex="-1">

<div class="modal-dialog modal-dialog-centered">

<div class="modal-content signup-modal">

<div class="modal-header border-0">

<h4 class="modal-title fw-bold">

Create Account

</h4>

<button
type="button"
class="btn-close"
data-bs-dismiss="modal">

</button>

</div>

<div class="modal-body">

<form action="signup" method="post" onsubmit="return validateForm()">

<div class="row">

<div class="col-6">

<input
type="text"
name="firstName"
class="form-control mb-3"
placeholder="First Name"
required>

</div>

<div class="col-6">

<input
type="text"
name="lastName"
class="form-control mb-3"
placeholder="Last Name"
required>

</div>

</div>

<div class="input-group mb-3">

<input
type="email"
id="email"
name="email"
class="form-control"
placeholder="MIT-ADT Email"
required>

<button
class="btn btn-primary"
type="button"
onclick="sendOTP()">

Send OTP

</button>

</div>

<input
type="text"
name="otp"
class="form-control"
placeholder="Enter OTP"
required>

<small
id="otpMessage"
style="display:block;
margin-top:8px;
font-weight:600;
color:green;">
</small>

<br>

<small
id="otpMessage"
class="text-success fw-bold">
</small>

<input
type="text"
name="phone"
class="form-control mb-3"
placeholder="Mobile Number"
required>

<div class="form-check mb-3">

<input
class="form-check-input"
type="checkbox"
id="terms">

<label class="form-check-label">

I agree to the
<a href="#">Terms & Conditions</a>

</label>

</div>

<button class="btn btn-primary w-100">

Create Account

</button>

</form>

<hr>

<p class="text-center">

Already have an account?

<a href="#">

Login

</a>

</p>

</div>

</div>

</div>

</div>





<script>

function sendOTP(){

    let email = document.getElementById("email").value.trim();

    if(email==""){
        alert("Please enter your email.");
        return;
    }

    fetch("sendOtp?email=" + encodeURIComponent(email))
    .then(response => response.text())
    .then(data => {

        document.getElementById("otpMessage").innerHTML = data;

    })
    .catch(error => {

        document.getElementById("otpMessage").innerHTML =
        "❌ Unable to send OTP.";

    });

}
function sendLoginOTP(){

    let email =
    document.getElementById("loginEmail").value.trim();

    if(email==""){
        alert("Please enter your email.");
        return;
    }

    fetch("sendLoginOtp?email=" + encodeURIComponent(email))
    .then(response => response.text())
    .then(data => {

        document.getElementById("loginOtpMessage").innerHTML = data;

    })
    .catch(error => {

        document.getElementById("loginOtpMessage").innerHTML =
        "❌ Unable to send OTP.";

    });

}

function openSignup(){

    const loginModal = bootstrap.Modal.getInstance(
        document.getElementById("loginModal"));

    if(loginModal){
        loginModal.hide();
    }

    setTimeout(function(){

        const signupModal = new bootstrap.Modal(
            document.getElementById("signupModal"));

        signupModal.show();

    },300);

}

</script>
<script src="js/main.js"></script>
<script src="js/faq.js"></script>
<script src="js/faq.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>