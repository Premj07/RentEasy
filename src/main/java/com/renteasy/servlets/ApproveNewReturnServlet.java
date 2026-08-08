package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;

import com.renteasy.utils.EmailUtility;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApproveNewReturnServlet")
public class ApproveNewReturnServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String rentalIdParam = request.getParameter("rentalId");

        // =====================================================
        // 1. CHECK RENTAL ID
        // =====================================================

        if (rentalIdParam == null ||
            rentalIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    "adminReturnRequests.jsp?error=missingid");

            return;
        }

        int rentalId;

        try {

            rentalId = Integer.parseInt(rentalIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "adminReturnRequests.jsp?error=invalidid");

            return;
        }


        Connection con = null;

        try {

            // =====================================================
            // 2. DATABASE CONNECTION
            // =====================================================

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );

            con.setAutoCommit(false);


            // =====================================================
            // 3. GET RENTAL + USER + OWNER + PRODUCT INFORMATION
            // =====================================================
            //
            // IMPORTANT:
            // Your users table contains:
            //
            // id
            // first_name
            // last_name
            // email
            // phone
            //
            // It DOES NOT contain:
            // name
            // username
            //
            // Therefore we use CONCAT(first_name, last_name).
            // =====================================================

            String detailsSql =

                    "SELECT " +

                    "r.rental_id, " +

                    "u.email AS user_email, " +
                    "u.first_name AS user_first_name, " +
                    "u.last_name AS user_last_name, " +
                    "u.phone AS user_phone, " +

                    "o.email AS owner_email, " +
                    "o.first_name AS owner_first_name, " +
                    "o.last_name AS owner_last_name, " +
                    "o.phone AS owner_phone, " +

                    "p.name AS product_name " +

                    "FROM rentals r " +

                    "JOIN users u " +
                    "ON r.user_id = u.id " +

                    "JOIN users o " +
                    "ON r.owner_id = o.id " +

                    "JOIN products p " +
                    "ON r.product_id = p.id " +

                    "WHERE r.rental_id = ?";


            PreparedStatement detailsPs =
                    con.prepareStatement(detailsSql);

            detailsPs.setInt(1, rentalId);

            ResultSet detailsRs =
                    detailsPs.executeQuery();


            // =====================================================
            // 4. CHECK RENTAL EXISTS
            // =====================================================

            if (!detailsRs.next()) {

                detailsRs.close();
                detailsPs.close();

                con.rollback();

                response.sendRedirect(
                        "adminReturnRequests.jsp?error=notfound");

                return;
            }


            // =====================================================
            // 5. GET DETAILS
            // =====================================================

            String userEmail =
                    detailsRs.getString("user_email");

            String userFirstName =
                    detailsRs.getString("user_first_name");

            String userLastName =
                    detailsRs.getString("user_last_name");

            String userPhone =
                    detailsRs.getString("user_phone");


            String ownerEmail =
                    detailsRs.getString("owner_email");

            String ownerFirstName =
                    detailsRs.getString("owner_first_name");

            String ownerLastName =
                    detailsRs.getString("owner_last_name");


            String productName =
                    detailsRs.getString("product_name");


            // =====================================================
            // 6. CREATE FULL NAMES
            // =====================================================

            String userName =
                    (userFirstName + " " + userLastName).trim();

            String ownerName =
                    (ownerFirstName + " " + ownerLastName).trim();


            detailsRs.close();
            detailsPs.close();


            // =====================================================
            // 7. GENERATE 6 DIGIT RETURN OTP
            // =====================================================

            int otpNumber =
                    100000 + new Random().nextInt(900000);

            String returnOtp =
                    String.valueOf(otpNumber);


            // =====================================================
            // 8. APPROVE RETURN + SAVE OTP
            // =====================================================

            String updateSql =

                    "UPDATE rentals " +

                    "SET rental_status = ?, " +
                    "return_otp = ? " +

                    "WHERE rental_id = ? " +

                    "AND rental_status = 'RETURN_REQUESTED'";


            PreparedStatement updateRental =
                    con.prepareStatement(updateSql);


            updateRental.setString(
                    1,
                    "RETURN_APPROVED"
            );

            updateRental.setString(
                    2,
                    returnOtp
            );

            updateRental.setInt(
                    3,
                    rentalId
            );


            int updated =
                    updateRental.executeUpdate();

            updateRental.close();


            // =====================================================
            // 9. CHECK UPDATE
            // =====================================================

            if (updated == 0) {

                con.rollback();

                response.sendRedirect(
                        "adminReturnRequests.jsp?error=notfound");

                return;
            }


            // =====================================================
            // 10. CREATE USER NOTIFICATION
            // =====================================================

            String notificationSql =

                    "INSERT INTO notifications " +

                    "(email, message) " +

                    "VALUES (?, ?)";


            PreparedStatement notification =
                    con.prepareStatement(notificationSql);


            notification.setString(
                    1,
                    userEmail
            );


            notification.setString(
                    2,

                    "Your return request for "
                    + productName
                    + " (Rental ID "
                    + rentalId
                    + ") has been approved. "
                    + "Please return the product to the owner."
            );


            notification.executeUpdate();

            notification.close();


            // =====================================================
            // 11. COMMIT DATABASE CHANGES
            // =====================================================

            con.commit();


            // =====================================================
            // 12. SEND RETURN EMAIL TO USER
            // =====================================================
            //
            // USER receives the OTP.
            //
            // The user gives this OTP to the owner
            // physically during product return.
            // =====================================================

            try {

                EmailUtility.sendReturnApprovedUserEmail(

                        userEmail,
                        userName,
                        productName,
                        rentalId,
                        returnOtp
                );

                System.out.println(
                        "Return OTP email sent to USER: "
                        + userEmail
                );

            } catch (Exception emailException) {

                System.out.println(
                        "User return email failed:"
                );

                emailException.printStackTrace();
            }


            // =====================================================
            // 13. SEND RETURN INFORMATION TO OWNER
            // =====================================================
            //
            // IMPORTANT:
            // We DO NOT send the OTP to the owner.
            //
            // Owner must ask the renter for OTP
            // during physical handover.
            // =====================================================

            try {

                EmailUtility.sendReturnApprovedOwnerEmail(

                        ownerEmail,
                        ownerName,
                        userName,
                        userPhone,
                        productName,
                        rentalId
                );

                System.out.println(
                        "Return email sent to OWNER: "
                        + ownerEmail
                );

            } catch (Exception emailException) {

                System.out.println(
                        "Owner return email failed:"
                );

                emailException.printStackTrace();
            }


            // =====================================================
            // 14. SUCCESS
            // =====================================================

            response.sendRedirect(

                    "adminReturnRequests.jsp"
                    + "?success=approved"
            );


        } catch (Exception e) {

            // =====================================================
            // ROLLBACK
            // =====================================================

            try {

                if (con != null &&
                    !con.getAutoCommit()) {

                    con.rollback();
                }

            } catch (Exception rollbackException) {

                rollbackException.printStackTrace();
            }


            e.printStackTrace();


            response.setContentType(
                    "text/html;charset=UTF-8"
            );


            response.getWriter().println(
                    "<h3>Return approval failed</h3>"
            );


            response.getWriter().println(
                    "<p>"
                    + e.getMessage()
                    + "</p>"
            );


        } finally {

            // =====================================================
            // CLOSE CONNECTION
            // =====================================================

            try {

                if (con != null) {

                    con.close();
                }

            } catch (Exception closeException) {

                closeException.printStackTrace();
            }
        }
    }
}