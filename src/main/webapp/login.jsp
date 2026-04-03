<!DOCTYPE html>
<html>
<head>
    <title>Login - RentEasy</title>

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

        .brand-title {
   			 font-size: 42px;
   			 font-weight: 900;
    		 background: linear-gradient(45deg, #36cfc9, #5cdbd3);
    		-webkit-background-clip: text;
    		-webkit-text-fill-color: transparent;
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

                <!-- ✅ BRAND NAME -->
                <h1 class="brand-title">RentEasy</h1>

                <h3 class="mb-3">Login</h3>

                <!-- ERROR MESSAGE -->
                <%
                if(request.getParameter("error") != null){
                %>
                    <div class="alert alert-danger">
                        Invalid username or password ❌
                    </div>
                <%
                }
                %>

                <form action="login" method="post">

                    <input type="text" name="username" class="form-control mb-2" placeholder="Username" required>

                    <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

                    <button class="btn btn-primary w-100">Login</button>

                </form>

                <p class="mt-3 text-center">
                    Don't have an account? <a href="signup.jsp">Signup</a>
                </p>

            </div>
        </div>

    </div>
</div>

</body>
</html>