package com.renteasy.servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AdminDamageReviewServlet")
public class AdminDamageReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String refundIdValue =
                request.getParameter("refundId");

        String rentalIdValue =
                request.getParameter("rentalId");

        String action =
                request.getParameter("action");

        String adminNote =
                request.getParameter("adminNote");


        if (refundIdValue == null ||
            rentalIdValue == null ||
            action == null) {

            response.sendRedirect(
                "adminRefund.jsp?error=missing_data"
            );

            return;
        }


        int refundId;
        int rentalId;

        try {

            refundId =
                    Integer.parseInt(refundIdValue);

            rentalId =
                    Integer.parseInt(rentalIdValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                "adminRefund.jsp?error=invalid_id"
            );

            return;
        }


        Connection con = null;

        try {

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy",
                "root",
                "123456"
            );

            con.setAutoCommit(false);


            // ==========================================
            // GET REFUND RECORD FROM DATABASE
            // ==========================================

            PreparedStatement checkPs =
                    con.prepareStatement(

                    "SELECT original_deposit, refund_status " +
                    "FROM deposit_refunds " +
                    "WHERE refund_id=? AND rental_id=?"
            );

            checkPs.setInt(1, refundId);
            checkPs.setInt(2, rentalId);

            ResultSet rs =
                    checkPs.executeQuery();


            if (!rs.next()) {

                rs.close();
                checkPs.close();

                con.rollback();

                response.sendRedirect(
                    "adminRefund.jsp?error=refund_not_found"
                );

                return;
            }


            BigDecimal originalDeposit =
                    rs.getBigDecimal(
                        "original_deposit"
                    );

            String currentStatus =
                    rs.getString(
                        "refund_status"
                    );


            rs.close();
            checkPs.close();


            // Only damage-review records can be processed

            if (!"DAMAGE_REVIEW"
                    .equalsIgnoreCase(currentStatus)) {

                con.rollback();

                response.sendRedirect(
                    "adminRefund.jsp?error=invalid_status"
                );

                return;
            }


            BigDecimal finalDeduction;


            // ==========================================
            // ADMIN APPROVES DAMAGE
            // ==========================================

            if ("APPROVE".equalsIgnoreCase(action)) {

                String deductionValue =
                        request.getParameter(
                            "finalDeduction"
                        );


                if (deductionValue == null ||
                    deductionValue.trim().isEmpty()) {

                    con.rollback();

                    response.sendRedirect(
                        "adminRefund.jsp?error=deduction_required"
                    );

                    return;
                }


                try {

                    finalDeduction =
                            new BigDecimal(
                                deductionValue
                            );

                } catch (NumberFormatException e) {

                    con.rollback();

                    response.sendRedirect(
                        "adminRefund.jsp?error=invalid_deduction"
                    );

                    return;
                }


                // Deduction cannot be negative or
                // greater than original deposit

                if (finalDeduction
                        .compareTo(BigDecimal.ZERO) < 0 ||

                    finalDeduction
                        .compareTo(originalDeposit) > 0) {

                    con.rollback();

                    response.sendRedirect(
                        "adminRefund.jsp?error=invalid_deduction"
                    );

                    return;
                }

            }


            // ==========================================
            // ADMIN REJECTS DAMAGE CLAIM
            // ==========================================

            else if ("REJECT"
                    .equalsIgnoreCase(action)) {

                finalDeduction =
                        BigDecimal.ZERO;

                if (adminNote == null ||
                    adminNote.trim().isEmpty()) {

                    adminNote =
                        "Damage claim rejected by admin.";
                }

            }

            else {

                con.rollback();

                response.sendRedirect(
                    "adminRefund.jsp?error=invalid_action"
                );

                return;
            }


            // ==========================================
            // CALCULATE FINAL REFUND
            // ==========================================

            BigDecimal finalRefund =
                    originalDeposit.subtract(
                        finalDeduction
                    );


            // ==========================================
            // UPDATE DEPOSIT REFUND
            // ==========================================

            PreparedStatement updateRefund =
                    con.prepareStatement(

                    "UPDATE deposit_refunds SET " +

                    "deduction_amount=?, " +
                    "refund_amount=?, " +
                    "refund_status=?, " +
                    "inspection_status=?, " +
                    "admin_note=?, " +
                    "approved_at=NOW() " +

                    "WHERE refund_id=?"
            );


            updateRefund.setBigDecimal(
                    1,
                    finalDeduction
            );

            updateRefund.setBigDecimal(
                    2,
                    finalRefund
            );

            updateRefund.setString(
                    3,
                    "READY_FOR_REFUND"
            );

            updateRefund.setString(
                    4,
                    "ADMIN_REVIEWED"
            );

            updateRefund.setString(
                    5,
                    adminNote
            );

            updateRefund.setInt(
                    6,
                    refundId
            );


            updateRefund.executeUpdate();
            updateRefund.close();


            // ==========================================
            // UPDATE RENTAL STATUS
            // ==========================================

            PreparedStatement updateRental =
                    con.prepareStatement(

                    "UPDATE rentals " +
                    "SET refund_status=? " +
                    "WHERE rental_id=?"
            );


            updateRental.setString(
                    1,
                    "READY_FOR_REFUND"
            );

            updateRental.setInt(
                    2,
                    rentalId
            );


            updateRental.executeUpdate();
            updateRental.close();


            // ==========================================
            // NOTIFY USER
            // ==========================================

            PreparedStatement notify =
                    con.prepareStatement(
                    "INSERT INTO notifications " +
                    "(email, message) " +
                    "SELECT u.email, ? " +
                    "FROM rentals r " +
                    "JOIN users u ON r.user_id = u.id " +
                    "WHERE r.rental_id = ?"
            );
            
            

            String message;

            if (finalDeduction
                    .compareTo(BigDecimal.ZERO) > 0) {

                message =
                    "Your security deposit refund for rental ID " +
                    rentalId +
                    " has been reviewed. Deduction: ₹" +
                    finalDeduction +
                    ". Final refund: ₹" +
                    finalRefund +
                    ".";

            } else {

                message =
                    "Your security deposit refund for rental ID " +
                    rentalId +
                    " has been approved for the full amount of ₹" +
                    finalRefund +
                    ".";
            }


            notify.setString(
                    1,
                    message
            );

            notify.setInt(
                    2,
                    rentalId
            );


            notify.executeUpdate();
            notify.close();


            con.commit();


            response.sendRedirect(
                "adminRefund.jsp?success=damage_reviewed"
            );


        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {

                try {
                    con.rollback();
                }
                catch (SQLException ignored) {
                }
            }

            response.sendRedirect(
                "adminRefund.jsp?error=server"
            );

        } finally {

            if (con != null) {

                try {

                    con.setAutoCommit(true);
                    con.close();

                }
                catch (SQLException ignored) {
                }
            }
        }
    }
}