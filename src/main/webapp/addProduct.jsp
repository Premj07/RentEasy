<%@ page session="true" %>
<%
if(session.getAttribute("user") == null){
    response.sendRedirect("login.jsp");
    return;
}
String username = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Product - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#eef2f7; }

.box {
    max-width:700px;
    margin:40px auto;
    background:white;
    border-radius:15px;
    box-shadow:0 10px 30px rgba(0,0,0,0.1);
}

.header {
    background:#20c997;
    color:white;
    padding:20px;
    text-align:center;
}

.form-section { padding:25px; }

.btn-main {
    background:#20c997;
    color:white;
    width:100%;
    border:none;
    padding:12px;
    border-radius:8px;
}
</style>
</head>

<body>

<div class="box">

<div class="header">
    <h3>Add Product</h3>
</div>

<div class="form-section">

<!-- ✅ IMPORTANT FIX: correct action -->
<form action="addProduct" method="post" enctype="multipart/form-data">

    <input type="hidden" name="owner" value="<%= username %>">

    <label>Name</label>
    <input type="text" name="name" class="form-control mb-3" required>

    <label>Category</label>
    <select name="category" class="form-select mb-3">
        <option value="Electronics">Electronics</option>
        <option value="Furniture">Furniture</option>
    </select>

    <label>Price</label>
    <input type="number" name="price" class="form-control mb-3" required>

    <label>Description</label>
    <textarea name="description" class="form-control mb-3"></textarea>
    
    <label>Owner name</label>
    <textarea name="Owner name" class="form-control mb-3"></textarea>
    
    <label>Owner Contact number</label>
    <textarea name="Owner Contact number" class="form-control mb-3"></textarea>

    <label>Upload Image</label>
    <input type="file" name="imageFile" class="form-control mb-3">

    <label>Location</label>
    <input type="text" name="location" class="form-control mb-3" required>

    <button type="submit" class="btn-main">Add Product</button>

</form>

</div>
</div>

</body>
</html>