<!DOCTYPE html>
<html>
<head>
    <title>Signup - RentEasy</title>

    <meta charset="UTF-8">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            height: 100vh;
        }

        .left-side {
            background: url('https://images.unsplash.com/photo-1586023492125-27b2c045efd7');
            background-size: cover;
            background-position: center;
        }

        .form-box {
            padding: 40px;
        }

        .form-control {
            border-radius: 10px;
        }
    </style>
</head>

<body>

<div class="container-fluid">
    <div class="row vh-100">

        <!-- LEFT IMAGE -->
        <div class="col-md-6 d-none d-md-block left-side"></div>

        <!-- RIGHT FORM -->
        <div class="col-md-6 d-flex align-items-center justify-content-center">
            <div class="form-box w-75">

                <h3 class="mb-3">Create Account</h3>

                <form action="signup" method="post">

                    <input type="text" name="name" class="form-control mb-2" placeholder="Full Name" required>

                    <input type="text" name="username" class="form-control mb-2" placeholder="Username" required>

                    <input type="email" name="email" class="form-control mb-2" placeholder="Email" required>

                    <input type="text" name="phone" class="form-control mb-2" placeholder="Phone Number" required>

                    <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

                    <!-- AGREEMENT -->
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" required>
                        <label class="form-check-label">
                            I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">terms & conditions</a>
                        </label>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox">
                        <label class="form-check-label">
                            Get updates from RentEasy
                        </label>
                    </div>

                    <button class="btn btn-success w-100">Signup</button>

                </form>

                <p class="mt-3 text-center">
                    Already have account? <a href="login.jsp">Login</a>
                </p>

            </div>
        </div>

    </div>
</div>

<!-- MODAL (Learn More) -->
<div class="modal fade" id="termsModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <div class="modal-header">
        <h5>Terms & Conditions</h5>
        <button class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <ul>
            <li>You must provide valid details</li>
            <li>Products should be returned on time</li>
            <li>Damage charges applicable</li>
            <li>📍 Location must be ON while using RentEasy</li>
        </ul>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>