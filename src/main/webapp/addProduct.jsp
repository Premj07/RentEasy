<%@ page session="true" %>
<%
if(session.getAttribute("username") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product - RentEasy</title>
    <meta charset="UTF-8">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background: #eef2f7; font-family: 'Segoe UI'; }
        .container-box {
            max-width: 700px; margin: 40px auto;
            background: white; border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .header {
            background: linear-gradient(45deg, #20c997, #36cfc9);
            color: white; padding: 25px; text-align: center;
        }
        .form-section { padding: 30px; }
        .btn-main {
            background: #20c997;
            border: none; border-radius: 10px;
            padding: 12px; width: 100%;
            color: white; font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container-box">

    <div class="header">
        <h2>Add New Product</h2>
    </div>

    <div class="form-section">

        <form action="addProduct" method="post" enctype="multipart/form-data">

            <label>Product Name</label>
            <input type="text" name="name" class="form-control mb-3" required>

            <label>Category</label>
            <select name="category" class="form-select mb-3">
                <option>Electronics</option>
                <option>Furniture</option>
                <option>Other</option>
            </select>

            <label>Price</label>
            <input type="number" name="price" class="form-control mb-3" required>

            <label>Description</label>
            <textarea name="description" class="form-control mb-3"></textarea>

            <label>Image URL</label>
            <input type="text" name="imageUrl" class="form-control mb-2">

            <p style="text-align:center;">OR</p>

            <input type="file" name="imageFile" class="form-control mb-3">

            <label>Location</label>
            <input type="text" name="location" class="form-control mb-3" required>

            <label>Pincode</label>
            <input type="text" name="pincode" class="form-control mb-3" required>

            <button type="submit" class="btn-main">Add Product</button>

        </form>

    </div>

</div>

</body>
</html>