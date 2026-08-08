package com.renteasy.servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApproveRefundServlet")
public class ApproveRefundServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        try {

            // ==========================================
            // 1. GET FORM DATA
            // ==========================================

            int refundId =
                    Integer.parseInt(request.getParameter("refundId"));

            int rentalId =
                    Integer.parseInt(request.getParameter("rentalId"));

            BigDecimal originalDeposit =
                    new BigDecimal(request.getParameter("originalDeposit"));

            String inspectionStatus =
                    request.getParameter("inspectionStatus");

            String deductionReason =
                    request.getParameter("deductionReason");

            String adminNote =
                    request.getParameter("adminNote");


            String deductionValue =
                    request.getParameter("deductionAmount");

            BigDecimal deductionAmount = BigDecimal.ZERO;

            if (deductionValue != null &&
                !deductionValue.trim().isEmpty()) {

                deductionAmount =
                        new BigDecimal(deductionValue);
            }


            // ==========================================
            // 2. VALIDATE INSPECTION
            // ==========================================

            if ("NO_DAMAGE".equalsIgnoreCase(inspectionStatus)) {

                deductionAmount = BigDecimal.ZERO;
                deductionReason = null;

            }
            else if ("DAMAGED".equalsIgnoreCase(inspectionStatus)) {

                if (deductionAmount.compareTo(BigDecimal.ZERO) <= 0) {

                    response.sendRedirect(
                        "adminRefund.jsp?error=invalid_deduction"
                    );

                    return;
                }

                if (deductionReason == null ||
                    deductionReason.trim().isEmpty()) {

                    response.sendRedirect(
                        "adminRefund.jsp?error=reason_required"
                    );

                    return;
                }

            }
            else {

                response.sendRedirect(
                    "adminRefund.jsp?error=inspection_required"
                );

                return;
            }


            // ==========================================
            // 3. VALIDATE DEDUCTION
            // ==========================================

            if (deductionAmount.compareTo(originalDeposit) > 0) {

                response.sendRedirect(
                    "adminRefund.jsp?error=deduction_too_high"
                );

                return;
            }


            // ==========================================
            // 4. CALCULATE FINAL REFUND
            // ==========================================

            BigDecimal refundAmount =
                    originalDeposit.subtract(deductionAmount);


            // ==========================================
            // 5. DATABASE CONNECTION
            // ==========================================

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );


            // ==========================================
            // 6. UPDATE DEPOSIT REFUND
            // ==========================================

            PreparedStatement ps = con.prepareStatement(

                "UPDATE deposit_refunds SET " +
                "deduction_amount=?, " +
                "deduction_reason=?, " +
                "refund_amount=?, " +
                "inspection_status=?, " +
                "refund_status=?, " +
                "admin_note=?, " +
                "approved_at=NOW() " +
                "WHERE refund_id=?"

            );

            ps.setBigDecimal(1, deductionAmount);
            ps.setString(2, deductionReason);
            ps.setBigDecimal(3, refundAmount);
            ps.setString(4, inspectionStatus);
            ps.setString(5, "READY_FOR_REFUND");
            ps.setString(6, adminNote);
            ps.setInt(7, refundId);

            ps.executeUpdate();
            ps.close();


            // ==========================================
            // 7. UPDATE RENTAL STATUS
            // ==========================================

            PreparedStatement rentalUpdate =
                    con.prepareStatement(

                    "UPDATE rentals " +
                    "SET refund_status=? " +
                    "WHERE rental_id=?"

            );

            rentalUpdate.setString(
                    1,
                    "READY_FOR_REFUND"
            );

            rentalUpdate.setInt(
                    2,
                    rentalId
            );

            rentalUpdate.executeUpdate();
            rentalUpdate.close();


         // ==========================================
         // 8. CREATE USER NOTIFICATION
         // ==========================================

         PreparedStatement notification =
                 con.prepareStatement(

                 "INSERT INTO notifications(email, message) " +
                 "SELECT u.email, ? " +
                 "FROM rentals r " +
                 "JOIN users u ON r.user_id = u.id " +
                 "WHERE r.rental_id = ?"
         );


         String message;

         if (deductionAmount.compareTo(BigDecimal.ZERO) > 0) {

             message =
                 "Your returned product has been inspected. " +
                 "Security deposit: ₹" + originalDeposit +
                 ", deduction: ₹" + deductionAmount +
                 ", final refund: ₹" + refundAmount +
                 ". Reason: " + deductionReason +
                 ". Refund is ready for processing.";

         } else {

             message =
                 "Your returned product has been inspected successfully. " +
                 "No deduction was applied. Your full security deposit " +
                 "of ₹" + refundAmount +
                 " is ready for refund.";
         }

         notification.setString(1, message);
         notification.setInt(2, rentalId);

         notification.executeUpdate();
         notification.close();


            // ==========================================
            // 9. CLOSE CONNECTION
            // ==========================================

            con.close();


            // ==========================================
            // 10. RETURN ADMIN TO REFUND PAGE
            // ==========================================

            response.sendRedirect(
                    "adminRefund.jsp?msg=approved"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "adminRefund.jsp?error=server"
            );
        }
    }
}