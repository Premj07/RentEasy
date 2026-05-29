<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>RentEasy</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family: 'Segoe UI', sans-serif;
}

body{
    background:#eee;
}

/* HERO SECTION */
.hero{
    height:95vh;
    background:url("https://images.unsplash.com/photo-1600585154340-be6161a56a0c") no-repeat center/cover;
    border-radius:25px;
    margin:20px;
    padding:30px;
    position:relative;
    color:white;
}

/* OVERLAY */
.hero::before{
    content:"";
    position:absolute;
    top:0;
    left:0;
    right:0;
    bottom:0;
    background:rgba(0,0,0,0.35);
    border-radius:25px;
}

/* CONTENT */
.hero-content{
    position:relative;
    z-index:2;
}

/* NAVBAR */
.navbar{
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.logo{
    font-size:55px;
    font-weight:bold;
}

.nav-links a{
    margin-left:20px;
    text-decoration:none;
    color:white;
}

.btn{
    padding:8px 18px;
    border-radius:20px;
    border:1px solid white;
}

/* HERO TEXT */
.hero-text{
    margin-top:80px;
    max-width:600px;
}

.hero-text h1{
    font-size:42px;
    line-height:1.2;
}

.hero-text p{
    margin-top:15px;
    color:#ddd;
}

/* SEARCH BOX */
.search-box{
    position:absolute;
    bottom:30px;
    left:50%;
    transform:translateX(-50%);
    width:80%;
    background:white;
    padding:20px;
    border-radius:15px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    box-shadow:0 10px 30px rgba(0,0,0,0.2);
}

/* SEARCH ITEMS */
.search-item{
    display:flex;
    flex-direction:column;
    margin-right:20px;
}

.search-item label{
    font-size:12px;
    color:#777;
}

.search-item select{
    border:none;
    outline:none;
    font-size:14px;
}

/* BUTTON */
.search-btn{
    background:black;
    color:white;
    padding:12px 25px;
    border:none;
    border-radius:25px;
    cursor:pointer;
}

</style>
</head>

<body>

<div class="hero">

    <div class="hero-content">

        <!-- NAVBAR -->
        <div class="navbar">
            <div class="logo">RentEasy</div>

            <div class="nav-links">
                <a href="#">Buy</a>
                <a href="#">Rent</a>
                <a href="#">Sell</a>
                <a href="#">Agents</a>
               <a href="login.jsp">Login</a>
                <a href="signup.jsp" class="btn">Register</a>
            </div>
        </div>

        <!-- TEXT -->
        <div class="hero-text">
            <h1>Find your ideal rental & start your best deal</h1>
            <p>
                Discover a seamless experience to rent products, homes, and services with RentEasy.
            </p>
        </div>

    </div>

    <!-- SEARCH BAR -->
    <div class="search-box">

        <div class="search-item">
            <label>Location</label>
            <select>
                <option>Pune</option>
                <option>Mumbai</option>
                <option>Delhi</option>
            </select>
        </div>

        <div class="search-item">
            <label>Type</label>
            <select>
                <option>House</option>
                <option>Flat</option>
                <option>Vehicle</option>
                <option>Vacation Homes</option>
                <option>Fashion</option>
                <option>Event Equipment</option>
                <option>Specialized Tols</option>
            </select>
        </div>

        <div class="search-item">
            <label>Price</label>
            <select>
                <option>5k - 10k</option>
                <option>10k - 20k</option>
            </select>
        </div>

        <button class="search-btn">Search</button>

    </div>

</div>

</body>
</html>