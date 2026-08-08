package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/VerifyPickupOtpServlet")
public class VerifyPickupOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int rentalId =
                Integer.parseInt(
                        request.getParameter("rentalId"));

        String enteredOtp =
                request.getParameter("pickupOtp");

        Connection con = null;

        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            /*
             * =========================================
             * 1. GET RENTAL + OTP + DEPOSIT
             * =========================================
             */

            PreparedStatement ps =
                    con.prepareStatement(

                    "SELECT pickup_otp, user_id, security_deposit " +
                    "FROM rentals " +
                    "WHERE rental_id=?"
            );

            ps.setInt(1, rentalId);

            ResultSet rs =
                    ps.executeQuery();


            if (!rs.next()) {

                rs.close();
                ps.close();

                response.sendRedirect(
                        "OwnerRentalsServlet?error=rentalnotfound");

                return;
            }


            String dbOtp =
                    rs.getString("pickup_otp");

            int userId =
                    rs.getInt("user_id");

            double securityDeposit =
                    rs.getDouble("security_deposit");


            rs.close();
            ps.close();


            /*
             * =========================================
             * 2. VERIFY OTP
             * =========================================
             */

            if (dbOtp == null ||
                enteredOtp == null ||
                !enteredOtp.equals(dbOtp)) {

                response.sendRedirect(
                        "OwnerRentalsServlet?error=invalidotp");

                return;
            }


            /*
             * =========================================
             * 3. START TRANSACTION
             * =========================================
             */

            con.setAutoCommit(false);


            /*
             * =========================================
             * 4. MARK RETURN/PICKUP OTP COMPLETED
             * =========================================
             */

            PreparedStatement update =
                    con.prepareStatement(

                    "UPDATE rentals " +
                    "SET pickup_status=?, " +
                    "otp_verified_at=NOW(), " +
                    "refund_status=? " +
                    "WHERE rental_id=?"
            );

            update.setString(
                    1,
                    "COMPLETED");

            update.setString(
                    2,
                    "RETURN_VERIFIED");

            update.setInt(
                    3,
                    rentalId);

            update.executeUpdate();

            update.close();


            /*
             * =========================================
             * 5. CHECK IF REFUND RECORD EXISTS
             * =========================================
             */

            PreparedStatement checkRefund =
                    con.prepareStatement(

                    "SELECT refund_id " +
                    "FROM deposit_refunds " +
                    "WHERE rental_id=? " +
                    "LIMIT 1"
            );

            checkRefund.setInt(
                    1,
                    rentalId);

            ResultSet refundRs =
                    checkRefund.executeQuery();

            boolean refundExists =
                    refundRs.next();

            refundRs.close();
            checkRefund.close();


            /*
             * =========================================
             * 6A. REFUND EXISTS → UPDATE
             * =========================================
             */

            if (refundExists) {

                PreparedStatement refundUpdate =
                        con.prepareStatement(

                        "UPDATE deposit_refunds " +

                        "SET refund_status=?, " +
                        "inspection_status=?, " +
                        "original_deposit=?, " +
                        "refund_amount=? " +

                        "WHERE rental_id=?"
                );

                refundUpdate.setString(
                        1,
                        "RETURN_VERIFIED");

                refundUpdate.setString(
                        2,
                        "PENDING");

                refundUpdate.setDouble(
                        3,
                        securityDeposit);

                refundUpdate.setDouble(
                        4,
                        securityDeposit);

                refundUpdate.setInt(
                        5,
                        rentalId);

                refundUpdate.executeUpdate();

                refundUpdate.close();

            }


            /*
             * =========================================
             * 6B. NO REFUND → CREATE
             * =========================================
             */

            else {

                PreparedStatement insertRefund =
                        con.prepareStatement(

                        "INSERT INTO deposit_refunds " +

                        "(rental_id, user_id, " +
                        "original_deposit, " +
                        "deduction_amount, " +
                        "refund_amount, " +
                        "refund_status, " +
                        "inspection_status) " +

                        "VALUES (?, ?, ?, ?, ?, ?, ?)"
                );

                insertRefund.setInt(
                        1,
                        rentalId);

                insertRefund.setInt(
                        2,
                        userId);

                insertRefund.setDouble(
                        3,
                        securityDeposit);

                insertRefund.setDouble(
                        4,
                        0.00);

                insertRefund.setDouble(
                        5,
                        securityDeposit);

                insertRefund.setString(
                        6,
                        "RETURN_VERIFIED");

                insertRefund.setString(
                        7,
                        "PENDING");

                insertRefund.executeUpdate();

                insertRefund.close();

            }


            /*
             * =========================================
             * 7. COMMIT
             * =========================================
             */

            con.commit();


            /*
             * =========================================
             * 8. RETURN TO OWNER RENTALS
             * =========================================
             */

            response.sendRedirect(
                    "OwnerRentalsServlet?returnVerified=true");


        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {

                try {

                    con.rollback();

                } catch (SQLException ex) {

                    ex.printStackTrace();
                }
            }

            response.getWriter().println(
                    "Return verification failed: "
                    + e.getMessage());

        } finally {

            if (con != null) {

                try {

                    con.setAutoCommit(true);
                    con.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }
}