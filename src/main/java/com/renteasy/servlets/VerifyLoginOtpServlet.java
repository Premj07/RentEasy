package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
@WebServlet("/verifyLoginOtp")
public class VerifyLoginOtpServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
throws ServletException, IOException {

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Verify OTP
            PreparedStatement otpPs = con.prepareStatement(
                    "SELECT * FROM otp_verification WHERE email=? AND otp=?");

            otpPs.setString(1, email);
            otpPs.setString(2, otp);

            ResultSet otpRs = otpPs.executeQuery();

            if (!otpRs.next()) {

                response.sendRedirect("index.jsp");
                con.close();
                return;
            }

            // Delete OTP after successful verification
            PreparedStatement deleteOtp = con.prepareStatement(
                    "DELETE FROM otp_verification WHERE email=?");
            deleteOtp.setString(1, email);
            deleteOtp.executeUpdate();

            HttpSession session = request.getSession();

            // ===========================
            // ADMIN LOGIN
            // ===========================
            if ("renteasy.project@gmail.com".equalsIgnoreCase(email)) {

                session.setAttribute("user", "Admin");
                session.setAttribute("firstName", "Admin");
                session.setAttribute("lastName", "RentEasy");
                session.setAttribute("email", email);
                session.setAttribute("role", "ADMIN");

                response.sendRedirect("adminDashboard.jsp");
                con.close();
                return;
            }

            // ===========================
            // USER LOGIN
            // ===========================
            PreparedStatement userPs = con.prepareStatement(
            	    "SELECT id, first_name, last_name, email FROM users WHERE email=?");

            userPs.setString(1, email);

            ResultSet userRs = userPs.executeQuery();

            if (userRs.next()) {
            	
            	session.setAttribute("userId", userRs.getInt("id"));
                session.setAttribute("user", userRs.getString("first_name"));
                session.setAttribute("firstName", userRs.getString("first_name"));
                session.setAttribute("lastName", userRs.getString("last_name"));
                session.setAttribute("email", userRs.getString("email"));
                session.setAttribute("role", "USER");

                // Check KYC
                PreparedStatement kycPs = con.prepareStatement(
                        "SELECT status FROM kyc WHERE email=?");

                kycPs.setString(1, email);

                ResultSet kycRs = kycPs.executeQuery();

                if (kycRs.next()) {

                    String status = kycRs.getString("status");

                    if ("Approved".equalsIgnoreCase(status)) {

                        response.sendRedirect("dashboard.jsp");

                    } else if ("Rejected".equalsIgnoreCase(status)) {

                        request.setAttribute("reason",
                                "Your KYC verification was rejected. Please upload valid documents.");

                        request.getRequestDispatcher("kyc-status.jsp")
                               .forward(request, response);

                    } else {

                        // Pending or any other future status
                        response.sendRedirect("kyc.jsp");
                    }

                } else {

                    // No KYC submitted
                    response.sendRedirect("kyc.jsp");

                }

            } else {

                session.invalidate();
                response.sendRedirect("index.jsp");

            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println(e.getMessage());

        }
    }
}