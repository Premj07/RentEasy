<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>

<%@ include file="adminLayout.jsp" %>

<%
/* ============================================================
   DATABASE DATA
============================================================ */

int totalUsers = 0;
int approvedUsers = 0;
int pendingUsers = 0;
int notSubmittedUsers = 0;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/renteasy",
        "root",
        "123456"
    );


    /* TOTAL USERS */

    PreparedStatement countPs = con.prepareStatement(
        "SELECT COUNT(*) FROM users"
    );

    ResultSet countRs = countPs.executeQuery();

    if(countRs.next()){
        totalUsers = countRs.getInt(1);
    }

    countRs.close();
    countPs.close();


    /* KYC SUMMARY */

    PreparedStatement summaryPs = con.prepareStatement(

        "SELECT " +

        "SUM(CASE WHEN LOWER(k.status)='approved' THEN 1 ELSE 0 END) approved, " +

        "SUM(CASE WHEN LOWER(k.status)='pending' THEN 1 ELSE 0 END) pending, " +

        "SUM(CASE WHEN k.status IS NULL THEN 1 ELSE 0 END) not_submitted " +

		"FROM users u LEFT JOIN kyc k ON u.email = k.email"
    );

    ResultSet summaryRs = summaryPs.executeQuery();

    if(summaryRs.next()){

        approvedUsers =
            summaryRs.getInt("approved");

        pendingUsers =
            summaryRs.getInt("pending");

        notSubmittedUsers =
            summaryRs.getInt("not_submitted");
    }

    summaryRs.close();
    summaryPs.close();

}
catch(Exception e){

    out.println(
        "<div class='alert alert-danger'>" +
        "Unable to load user information: " +
        e.getMessage() +
        "</div>"
    );
}
%>


<style>

/* ============================================================
   USER MANAGEMENT PAGE
============================================================ */

.user-stat-card{

    background:#ffffff;

    border:1px solid #e2e8f0;

    border-radius:14px;

    padding:20px;

    height:100%;

    box-shadow:0 3px 12px rgba(15,23,42,.04);
}


.user-stat-top{

    display:flex;

    justify-content:space-between;

    align-items:flex-start;
}


.user-stat-label{

    color:#64748b;

    font-size:13px;

    font-weight:600;
}


.user-stat-number{

    margin-top:9px;

    color:#0f172a;

    font-size:27px;

    font-weight:750;
}


.user-stat-icon{

    width:44px;

    height:44px;

    border-radius:11px;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:19px;
}


.icon-users{

    background:#eff6ff;

    color:#2563eb;
}


.icon-approved{

    background:#ecfdf5;

    color:#059669;
}


.icon-pending{

    background:#fff7ed;

    color:#ea580c;
}


.icon-not-submitted{

    background:#f1f5f9;

    color:#64748b;
}


/* ============================================================
   TOOLBAR
============================================================ */

.user-toolbar{

    display:flex;

    align-items:center;

    justify-content:space-between;

    gap:15px;

    flex-wrap:wrap;
}


.search-wrapper{

    position:relative;

    width:340px;

    max-width:100%;
}


.search-wrapper i{

    position:absolute;

    left:14px;

    top:50%;

    transform:translateY(-50%);

    color:#94a3b8;
}


.user-search{

    width:100%;

    height:42px;

    border:1px solid #dbe3ee;

    border-radius:9px;

    padding:0 14px 0 41px;

    outline:none;

    font-size:13px;
}


.user-search:focus{

    border-color:#2563eb;

    box-shadow:0 0 0 3px rgba(37,99,235,.08);
}


.filter-select{

    height:42px;

    min-width:160px;

    border:1px solid #dbe3ee;

    border-radius:9px;

    padding:0 12px;

    background:#ffffff;

    color:#475569;

    font-size:13px;

    outline:none;
}


/* ============================================================
   USER
============================================================ */

.user-profile-cell{

    display:flex;

    align-items:center;

    gap:12px;
}


.user-profile-photo{

    width:42px;

    height:42px;

    border-radius:50%;

    object-fit:cover;

    border:1px solid #e2e8f0;
}


.user-placeholder{

    width:42px;

    height:42px;

    border-radius:50%;

    background:#eff6ff;

    color:#2563eb;

    display:flex;

    align-items:center;

    justify-content:center;

    font-size:16px;

    font-weight:700;
}


.user-name{

    color:#0f172a;

    font-weight:650;

    font-size:14px;
}


.user-id{

    margin-top:2px;

    color:#94a3b8;

    font-size:11px;
}


.user-email{

    color:#475569;

    font-size:13px;
}


/* ============================================================
   STATUS BADGES
============================================================ */

.status-badge{

    display:inline-flex;

    align-items:center;

    gap:6px;

    padding:6px 10px;

    border-radius:20px;

    font-size:11px;

    font-weight:700;
}


.status-approved{

    background:#dcfce7;

    color:#15803d;
}


.status-pending{

    background:#ffedd5;

    color:#c2410c;
}


.status-rejected{

    background:#fee2e2;

    color:#b91c1c;
}


.status-none{

    background:#f1f5f9;

    color:#64748b;
}


/* ============================================================
   ACTION BUTTONS
============================================================ */

.action-group{

    display:flex;

    align-items:center;

    gap:7px;

    flex-wrap:wrap;
}


.action-btn{

    width:34px;

    height:34px;

    display:inline-flex;

    align-items:center;

    justify-content:center;

    border-radius:7px;

    border:1px solid #e2e8f0;

    background:#ffffff;

    color:#475569;

    text-decoration:none;

    transition:.2s;

    font-size:14px;
}


.action-btn:hover{

    background:#f8fafc;

    color:#2563eb;

    border-color:#bfdbfe;
}


.action-approve{

    color:#059669;
}


.action-approve:hover{

    color:#047857;

    background:#ecfdf5;

    border-color:#a7f3d0;
}


.action-reject{

    color:#ea580c;
}


.action-reject:hover{

    color:#c2410c;

    background:#fff7ed;

    border-color:#fed7aa;
}


.action-delete{

    color:#dc2626;
}


.action-delete:hover{

    color:#b91c1c;

    background:#fef2f2;

    border-color:#fecaca;
}


/* ============================================================
   EMPTY STATE
============================================================ */

.empty-users{

    padding:65px 20px;

    text-align:center;
}


.empty-users i{

    font-size:45px;

    color:#94a3b8;
}


.empty-users h5{

    margin-top:15px;

    color:#334155;

    font-weight:700;
}


.empty-users p{

    color:#94a3b8;

    font-size:13px;
}


/* ============================================================
   RESPONSIVE
============================================================ */

@media(max-width:768px){

    .search-wrapper{

        width:100%;
    }


    .filter-select{

        width:100%;
    }

}

</style>


<!-- ============================================================
     PAGE HEADER
============================================================ -->

<div class="admin-page-header">

    <div>

        <h1 class="admin-page-title">
            User Management
        </h1>

        <p class="admin-page-description">
            View registered users, monitor verification status
            and manage RentEasy accounts.
        </p>

    </div>


    <a href="adminKyc.jsp"
       class="admin-btn-light">

        <i class="bi bi-person-check"></i>

        KYC Verification

        <% if(pendingUsers > 0){ %>

            <span class="badge bg-danger ms-1">
                <%= pendingUsers %>
            </span>

        <% } %>

    </a>

</div>



<!-- ============================================================
     SUMMARY CARDS
============================================================ -->

<div class="row g-3 mb-4">


    <!-- TOTAL USERS -->

    <div class="col-xl-3 col-md-6">

        <div class="user-stat-card">

            <div class="user-stat-top">

                <div>

                    <div class="user-stat-label">
                        Total Users
                    </div>

                    <div class="user-stat-number">
                        <%= totalUsers %>
                    </div>

                </div>


                <div class="user-stat-icon icon-users">

                    <i class="bi bi-people"></i>

                </div>

            </div>

        </div>

    </div>



    <!-- VERIFIED -->

    <div class="col-xl-3 col-md-6">

        <div class="user-stat-card">

            <div class="user-stat-top">

                <div>

                    <div class="user-stat-label">
                        KYC Approved
                    </div>

                    <div class="user-stat-number">
                        <%= approvedUsers %>
                    </div>

                </div>


                <div class="user-stat-icon icon-approved">

                    <i class="bi bi-person-check"></i>

                </div>

            </div>

        </div>

    </div>



    <!-- PENDING -->

    <div class="col-xl-3 col-md-6">

        <div class="user-stat-card">

            <div class="user-stat-top">

                <div>

                    <div class="user-stat-label">
                        Pending Verification
                    </div>

                    <div class="user-stat-number">
                        <%= pendingUsers %>
                    </div>

                </div>


                <div class="user-stat-icon icon-pending">

                    <i class="bi bi-hourglass-split"></i>

                </div>

            </div>

        </div>

    </div>



    <!-- NOT SUBMITTED -->

    <div class="col-xl-3 col-md-6">

        <div class="user-stat-card">

            <div class="user-stat-top">

                <div>

                    <div class="user-stat-label">
                        KYC Not Submitted
                    </div>

                    <div class="user-stat-number">
                        <%= notSubmittedUsers %>
                    </div>

                </div>


                <div class="user-stat-icon icon-not-submitted">

                    <i class="bi bi-person-dash"></i>

                </div>

            </div>

        </div>

    </div>

</div>



<!-- ============================================================
     USER TABLE CARD
============================================================ -->

<div class="admin-card">


    <!-- CARD HEADER -->

    <div class="admin-card-header">

        <div class="user-toolbar">


            <div>

                <h5 class="mb-1 fw-bold">
                    Registered Users
                </h5>

                <div class="text-muted"
                     style="font-size:12px;">

                    Manage all customer accounts registered
                    on RentEasy.

                </div>

            </div>



            <div class="d-flex gap-2 flex-wrap">


                <!-- SEARCH -->

                <div class="search-wrapper">

                    <i class="bi bi-search"></i>

                    <input type="text"
                           id="userSearch"
                           class="user-search"
                           placeholder="Search name, username or email...">

                </div>



                <!-- FILTER -->

                <select id="kycFilter"
                        class="filter-select">

                    <option value="ALL">
                        All KYC Status
                    </option>

                    <option value="APPROVED">
                        Approved
                    </option>

                    <option value="PENDING">
                        Pending
                    </option>

                    <option value="REJECTED">
                        Rejected
                    </option>

                    <option value="NOT SUBMITTED">
                        Not Submitted
                    </option>

                </select>


            </div>

        </div>

    </div>



    <!-- TABLE -->

    <div class="table-responsive">

        <table class="admin-table"
               id="usersTable">

            <thead>

                <tr>

                    <th>User</th>

                    <th>Email</th>

                    <th>KYC Status</th>

                    <th>Document</th>

                    <th style="width:180px;">
                        Actions
                    </th>

                </tr>

            </thead>


            <tbody>


<%

boolean userFound = false;

try {

	String sql =
		    "SELECT " +
		    "u.id, " +
		    "u.first_name, " +
		    "u.last_name, " +
		    "u.email, " +
		    "u.phone, " +
		    "u.created_at, " +
		    "u.kyc_status, " +
		    "k.fullname AS kyc_fullname, " +
		    "k.photo, " +
		    "k.document, " +
		    "k.status AS kyc_detail_status " +
		    "FROM users u " +
		    "LEFT JOIN kyc k ON u.email = k.email " +
		    "ORDER BY u.id DESC";


    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    while(rs.next()){

        userFound = true;


        int userId =
            rs.getInt("id");


        String email =
        	    rs.getString("email");

        	String firstName =
        	    rs.getString("first_name");

        	String lastName =
        	    rs.getString("last_name");

        	String photo =
        	    rs.getString("photo");

        	String document =
        	    rs.getString("document");

        	String status =
        	    rs.getString("kyc_detail_status");

        	String kycFullName =
        	    rs.getString("kyc_fullname");


        	String displayName = "";

        	if(firstName != null && !firstName.trim().isEmpty()){
        	    displayName = firstName.trim();
        	}

        	if(lastName != null && !lastName.trim().isEmpty()){
        	    displayName +=
        	        (displayName.isEmpty() ? "" : " ")
        	        + lastName.trim();
        	}

        	if(displayName.isEmpty() &&
        	   kycFullName != null &&
        	   !kycFullName.trim().isEmpty()){

        	    displayName = kycFullName.trim();
        	}

        	if(displayName.isEmpty()){
        	    displayName = "User";
        	}


        String filterStatus =
            status == null
            ? "NOT SUBMITTED"
            : status.toUpperCase();


        String initial = "U";


        if(displayName != null &&
           !displayName.trim().isEmpty()){

            initial =
                displayName.substring(0,1).toUpperCase();
        }

%>


<tr class="user-row"
    data-status="<%= filterStatus %>">


    <!-- USER -->

    <td>

        <div class="user-profile-cell">


            <% if(photo != null &&
                  !photo.trim().isEmpty()){ %>


                <img src="<%= request.getContextPath() %>/<%= photo %>"
                     class="user-profile-photo"
                     alt="User">


            <% } else { %>


                <div class="user-placeholder">

                    <%= initial %>

                </div>


            <% } %>


            <div>

                <div class="user-name">

                    <%= displayName %>

                </div>


                <div class="user-id">

                   <div class="user-id">
   					 ID #<%= userId %>
					</div>

                </div>

            </div>


        </div>

    </td>



    <!-- EMAIL -->

    <td>

        <div class="user-email">

            <i class="bi bi-envelope me-1"></i>

            <%= email %>

        </div>

    </td>



    <!-- KYC STATUS -->

    <td>


        <% if(status == null){ %>


            <span class="status-badge status-none">

                <i class="bi bi-dash-circle"></i>

                Not Submitted

            </span>


        <% }
           else if("Pending".equalsIgnoreCase(status)){ %>


            <span class="status-badge status-pending">

                <i class="bi bi-clock"></i>

                Pending

            </span>


        <% }
           else if("Approved".equalsIgnoreCase(status)){ %>


            <span class="status-badge status-approved">

                <i class="bi bi-check-circle"></i>

                Approved

            </span>


        <% }
           else { %>


            <span class="status-badge status-rejected">

                <i class="bi bi-x-circle"></i>

                Rejected

            </span>


        <% } %>


    </td>



    <!-- DOCUMENT -->

    <td>


        <% if(document != null &&
              !document.trim().isEmpty()){ %>


            <a href="<%= request.getContextPath() %>/<%= document %>"
               target="_blank"
               class="admin-btn-light">

                <i class="bi bi-file-earmark-text"></i>

                View

            </a>


        <% } else { %>


            <span class="text-muted"
                  style="font-size:12px;">

                No document

            </span>


        <% } %>


    </td>



    <!-- ACTIONS -->

    <td>

        <div class="action-group">


            <!-- DETAILS -->

            <a href="adminUserDetails.jsp?userId=<%= userId %>"
               class="action-btn"
               title="View User Details">

                <i class="bi bi-eye"></i>

            </a>



            <% if("Pending".equalsIgnoreCase(status)){ %>


                <!-- APPROVE -->

                <a href="approveKyc?email=<%= java.net.URLEncoder.encode(email, "UTF-8") %>"
   class="action-btn action-approve"
   title="Approve KYC"
   onclick="return confirm('Approve KYC for this user?');">

    <i class="bi bi-check-lg"></i>
</a>



                <!-- REJECT -->

                <a href="rejectKyc?email=<%= java.net.URLEncoder.encode(email, "UTF-8") %>"
   class="action-btn action-reject"
   title="Reject KYC"
   onclick="return confirm('Reject KYC for this user?');">

    <i class="bi bi-x-lg"></i>
</a>


            <% } %>



            <!-- DELETE -->

            <a href="deleteUser?id=<%= userId %>"
               class="action-btn action-delete"
               title="Delete User"

               onclick="return confirm(
               'Are you sure you want to permanently delete this user?'
               );">

                <i class="bi bi-trash"></i>

            </a>


        </div>

    </td>


</tr>


<%

    }

}
catch(Exception e){

%>

<tr>

    <td colspan="5">

        <div class="alert alert-danger m-3">

            <i class="bi bi-exclamation-triangle me-2"></i>

            Unable to load users:
            <%= e.getMessage() %>

        </div>

    </td>

</tr>

<%

}

if(!userFound){

%>


<tr>

    <td colspan="5">

        <div class="empty-users">

            <i class="bi bi-people"></i>

            <h5>
                No Users Found
            </h5>

            <p>
                Registered RentEasy users will appear here.
            </p>

        </div>

    </td>

</tr>


<%

}

%>


            </tbody>

        </table>

    </div>

</div>



<!-- ============================================================
     SEARCH + FILTER
============================================================ -->

<script>

const userSearch =
    document.getElementById("userSearch");

const kycFilter =
    document.getElementById("kycFilter");


function filterUsers(){

    const search =
        userSearch.value.toLowerCase().trim();

    const selectedStatus =
        kycFilter.value;


    document
        .querySelectorAll(".user-row")
        .forEach(function(row){


            const rowText =
                row.innerText.toLowerCase();


            const rowStatus =
                row.getAttribute("data-status");


            const matchesSearch =
                rowText.includes(search);


            const matchesStatus =
                selectedStatus === "ALL"
                || rowStatus === selectedStatus;


            row.style.display =
                matchesSearch && matchesStatus
                ? ""
                : "none";

        });

}


userSearch.addEventListener(
    "input",
    filterUsers
);


kycFilter.addEventListener(
    "change",
    filterUsers
);

</script>


<%
/* ============================================================
   CLOSE DATABASE
============================================================ */

try{

    if(rs != null)
        rs.close();

    if(ps != null)
        ps.close();

    if(con != null)
        con.close();

}
catch(Exception ignored){
}
%>