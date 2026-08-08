<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");

String accountHolder = "";
String bankName = "";
String accountNumber = "";
String ifscCode = "";

Connection con = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT account_holder, bank_name, account_number, ifsc_code " +
        "FROM bank_details WHERE user_id=? LIMIT 1"
    );

    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){

        accountHolder = rs.getString("account_holder");
        bankName = rs.getString("bank_name");
        accountNumber = rs.getString("account_number");
        ifscCode = rs.getString("ifsc_code");

        if(accountHolder == null) accountHolder = "";
        if(bankName == null) bankName = "";
        if(accountNumber == null) accountNumber = "";
        if(ifscCode == null) ifscCode = "";
    }

    rs.close();
    ps.close();

} catch(Exception e){

    e.printStackTrace();

} finally {

    if(con != null){
        try{
            con.close();
        }catch(Exception e){}
    }
}

boolean editing = !accountNumber.isEmpty();
%>

<!DOCTYPE html>
<html>

<head>

<title>Bank Account Details - RentEasy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
    background:#eef2f7;
    font-family:Arial, sans-serif;
}

.box{
    width:650px;
    max-width:92%;
    margin:50px auto;
    background:white;
    padding:40px;
    border-radius:18px;
    box-shadow:0 8px 25px rgba(0,0,0,.10);
}

.icon-box{
    width:65px;
    height:65px;
    margin:auto;
    border-radius:50%;
    background:#dbeafe;
    color:#2563eb;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:30px;
    margin-bottom:15px;
}

.subtitle{
    text-align:center;
    color:#64748b;
    margin-bottom:30px;
}

label{
    font-weight:600;
    color:#334155;
    margin-bottom:7px;
}

.form-control{
    padding:12px;
    border-radius:10px;
}

.save-btn{
    background:#2563eb;
    border:none;
    padding:12px;
    border-radius:10px;
    font-weight:600;
}

.save-btn:hover{
    background:#1d4ed8;
}

.back-btn{
    padding:12px;
    border-radius:10px;
}

.security-box{
    background:#f0fdf4;
    color:#166534;
    padding:14px;
    border-radius:10px;
    margin-bottom:25px;
    font-size:14px;
}

#errorMessage{
    display:none;
    background:#fee2e2;
    color:#b91c1c;
    padding:12px;
    border-radius:10px;
    margin-bottom:20px;
}

</style>

</head>

<body>

<div class="box">

<div class="icon-box">
<i class="bi bi-bank"></i>
</div>

<h2 class="text-center">

<%= editing ? "Edit Bank Account" : "Add Bank Account" %>

</h2>

<p class="subtitle">
This bank account will be used for your RentEasy security deposit refunds.
</p>


<div class="security-box">

<i class="bi bi-shield-check"></i>

Please make sure the bank details are correct before saving.
Refunds will be sent to this account.

</div>


<div id="errorMessage"></div>


<form action="SaveBankDetailsServlet"
      method="post"
      onsubmit="return validateBankForm();">


<input type="hidden"
       name="method"
       value="BANK">


<!-- ACCOUNT HOLDER -->

<div class="mb-3">

<label>
Account Holder Name
</label>

<input
type="text"
name="account_holder"
id="accountHolder"
class="form-control"
value="<%=accountHolder%>"
placeholder="Enter account holder name"
required>

</div>


<!-- BANK NAME -->

<div class="mb-3">

<label>
Bank Name
</label>

<input
type="text"
name="bank_name"
id="bankName"
class="form-control"
value="<%=bankName%>"
placeholder="Example: State Bank of India"
required>

</div>


<!-- ACCOUNT NUMBER -->

<div class="mb-3">

<label>
Account Number
</label>

<input
type="text"
name="account_number"
id="accountNumber"
class="form-control"
value="<%=accountNumber%>"
placeholder="Enter bank account number"
inputmode="numeric"
maxlength="18"
required>

</div>


<!-- CONFIRM ACCOUNT NUMBER -->

<div class="mb-3">

<label>
Confirm Account Number
</label>

<input
type="text"
id="confirmAccountNumber"
class="form-control"
value="<%=accountNumber%>"
placeholder="Re-enter bank account number"
inputmode="numeric"
maxlength="18"
required>

</div>


<!-- IFSC -->

<div class="mb-4">

<label>
IFSC Code
</label>

<input
type="text"
name="ifsc"
id="ifsc"
class="form-control"
value="<%=ifscCode%>"
placeholder="Example: SBIN0001234"
maxlength="11"
style="text-transform:uppercase;"
required>

</div>


<div class="d-grid gap-2">

<button
type="submit"
class="btn btn-primary save-btn">

<i class="bi bi-check-circle"></i>

<%= editing ? "Update Bank Details" : "Save Bank Details" %>

</button>


<a
href="paymentHistory.jsp"
class="btn btn-outline-secondary back-btn">

<i class="bi bi-arrow-left"></i>
Back to Payments

</a>

</div>

</form>

</div>


<script>

function validateBankForm(){

    const account =
        document.getElementById("accountNumber").value.trim();

    const confirmAccount =
        document.getElementById("confirmAccountNumber").value.trim();

    const ifsc =
        document.getElementById("ifsc").value.trim().toUpperCase();

    const errorBox =
        document.getElementById("errorMessage");


    // Account numbers must contain only numbers

    if(!/^[0-9]{6,18}$/.test(account)){

        errorBox.style.display = "block";

        errorBox.innerHTML =
        '<i class="bi bi-exclamation-circle"></i> ' +
        'Enter a valid bank account number.';

        return false;
    }


    // Account number matching

    if(account !== confirmAccount){

        errorBox.style.display = "block";

        errorBox.innerHTML =
        '<i class="bi bi-exclamation-circle"></i> ' +
        'Account Number and Confirm Account Number do not match.';

        return false;
    }


    // Indian IFSC validation
    // Example: SBIN0001234

    const ifscPattern =
        /^[A-Z]{4}0[A-Z0-9]{6}$/;


    if(!ifscPattern.test(ifsc)){

        errorBox.style.display = "block";

        errorBox.innerHTML =
        '<i class="bi bi-exclamation-circle"></i> ' +
        'Enter a valid IFSC code. Example: SBIN0001234';

        return false;
    }


    document.getElementById("ifsc").value = ifsc;

    errorBox.style.display = "none";

    return true;
}

</script>

</body>

</html>