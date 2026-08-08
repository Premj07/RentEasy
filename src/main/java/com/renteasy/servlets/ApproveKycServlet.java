package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/approveKyc")
public class ApproveKycServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");

        // ==========================================
        // VALIDATE EMAIL
        // ==========================================
        if (email == null || email.trim().isEmpty()) {

            response.sendRedirect(
                "adminUsers.jsp?error=missing_email"
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

            con.setAutoCommit(false);


            // ==========================================
            // 1. APPROVE KYC TABLE
            // ==========================================

            PreparedStatement kycPs =
                con.prepareStatement(

                    "UPDATE kyc " +
                    "SET status='Approved', " +
                    "rejection_reason=NULL " +
                    "WHERE email=?"

                );

            kycPs.setString(1, email.trim());

            int kycUpdated = kycPs.executeUpdate();

            kycPs.close();


            // KYC record not found
            if (kycUpdated == 0) {

                con.rollback();

                response.sendRedirect(
                    "adminUsers.jsp?error=kyc_not_found"
                );

                return;
            }


            // ==========================================
            // 2. UPDATE USERS TABLE
            // ==========================================

            PreparedStatement userPs =
                con.prepareStatement(

                    "UPDATE users " +
                    "SET kyc_status='Approved' " +
                    "WHERE email=?"

                );

            userPs.setString(1, email.trim());

            userPs.executeUpdate();

            userPs.close();


            // ==========================================
            // 3. COMMIT
            // ==========================================

            con.commit();


            // ==========================================
            // 4. RETURN TO ADMIN USERS
            // ==========================================

            response.sendRedirect(
                "adminUsers.jsp?msg=kyc_approved"
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
                "adminUsers.jsp?error=approval_failed"
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