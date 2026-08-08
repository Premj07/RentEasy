package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CompleteRefundServlet")
public class CompleteRefundServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String refundIdValue = request.getParameter("refundId");
        String rentalIdValue = request.getParameter("rentalId");
        String transactionId = request.getParameter("transactionId");

        // ==========================================
        // 1. BASIC VALIDATION
        // ==========================================

        if (refundIdValue == null ||
            rentalIdValue == null ||
            transactionId == null ||
            transactionId.trim().isEmpty()) {

            response.sendRedirect(
                    "adminRefund.jsp?error=missing_payment_details"
            );

            return;
        }

        int refundId;
        int rentalId;

        try {

            refundId = Integer.parseInt(refundIdValue);
            rentalId = Integer.parseInt(rentalIdValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "adminRefund.jsp?error=invalid_refund"
            );

            return;
        }

        Connection con = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );

            // Use transaction so all updates succeed together.
            con.setAutoCommit(false);


            // ==========================================
            // 2. CHECK REFUND IS ACTUALLY READY
            // ==========================================

            PreparedStatement check = con.prepareStatement(
                    "SELECT refund_status " +
                    "FROM deposit_refunds " +
                    "WHERE refund_id=? AND rental_id=?"
            );

            check.setInt(1, refundId);
            check.setInt(2, rentalId);

            ResultSet checkRs = check.executeQuery();

            if (!checkRs.next()) {

                checkRs.close();
                check.close();

                con.rollback();

                response.sendRedirect(
                        "adminRefund.jsp?error=refund_not_found"
                );

                return;
            }

            String currentStatus =
                    checkRs.getString("refund_status");

            checkRs.close();
            check.close();


            if (!"READY_FOR_REFUND".equalsIgnoreCase(currentStatus)) {

                con.rollback();

                response.sendRedirect(
                        "adminRefund.jsp?error=refund_not_ready"
                );

                return;
            }


            // ==========================================
            // 3. MARK DEPOSIT REFUND COMPLETED
            // ==========================================

            PreparedStatement refundUpdate =
                    con.prepareStatement(

                    "UPDATE deposit_refunds SET " +
                    "refund_status=?, " +
                    "transaction_id=?, " +
                    "refunded_at=NOW() " +
                    "WHERE refund_id=? AND rental_id=?"

            );

            refundUpdate.setString(1, "COMPLETED");
            refundUpdate.setString(2, transactionId.trim());
            refundUpdate.setInt(3, refundId);
            refundUpdate.setInt(4, rentalId);

            refundUpdate.executeUpdate();
            refundUpdate.close();


            // ==========================================
            // 4. UPDATE RENTALS TABLE
            // ==========================================

            PreparedStatement rentalUpdate =
                    con.prepareStatement(

                    		 "UPDATE rentals " +
                    		 "SET refund_status=?, " +
                    		 "rental_status=? " +
                    		 "WHERE rental_id=?"

            );

            rentalUpdate.setString(1,"COMPLETED");
            rentalUpdate.setString(2,"COMPLETED");
            rentalUpdate.setInt(3,rentalId);

            rentalUpdate.executeUpdate();
            rentalUpdate.close();

         // ==========================================
         // 5. MAKE PRODUCT AVAILABLE AGAIN
         // ==========================================

         PreparedStatement getProduct =
                 con.prepareStatement(
                     "SELECT product_id FROM rentals WHERE rental_id=?"
                 );

         getProduct.setInt(1, rentalId);

         ResultSet prs = getProduct.executeQuery();

         if(prs.next()){

             int productId = prs.getInt("product_id");

             PreparedStatement update =
                     con.prepareStatement(

                     "UPDATE products SET " +
                     "availability=?, " +
                     "product_type=?, " +
                     "status=? " +
                     "WHERE id=?"

             );

             update.setString(1, "AVAILABLE");
             update.setString(2, "AVAILABLE");
             update.setString(3, "approved");
             update.setInt(4, productId);

             update.executeUpdate();
             update.close();
         }

         prs.close();
         getProduct.close();
         
         // ==========================================
         // 5. CREATE USER NOTIFICATION
         // ==========================================

         PreparedStatement notification =
                 con.prepareStatement(

                 "INSERT INTO notifications(email, message) " +

                 "SELECT u.email, " +

                 "CONCAT(" +
                 "'Your security deposit refund of ₹', " +
                 "dr.refund_amount, " +
                 "' has been completed successfully. Transaction ID: ', ?" +
                 ") " +

                 "FROM deposit_refunds dr " +
                 "JOIN users u ON dr.user_id = u.id " +

                 "WHERE dr.refund_id = ?"
         );

         notification.setString(
                 1,
                 transactionId.trim()
         );

         notification.setInt(
                 2,
                 refundId
         );

         notification.executeUpdate();
         notification.close();


            // ==========================================
            // 6. COMMIT EVERYTHING
            // ==========================================

            con.commit();


            // ==========================================
             // 7. REDIRECT ADMIN
            // ==========================================

            response.sendRedirect(
                    "adminRefund.jsp?msg=refund_completed"
            );


        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {

                try {
                    con.rollback();
                } catch (SQLException ignored) {
                }
            }

            response.sendRedirect(
                    "adminRefund.jsp?error=refund_failed"
            );

        } finally {

            if (con != null) {

                try {

                    con.setAutoCommit(true);
                    con.close();

                } catch (SQLException ignored) {
                }
            }
        }
    }
}