package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.Random;

import com.renteasy.utils.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/sendOtp")
public class SendOtpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        String email = request.getParameter("email");

        if(email == null || email.trim().isEmpty()) {
            response.getWriter().print("Please enter your email.");
            return;
        }

        try {

            String otp = String.valueOf(100000 + new Random().nextInt(900000));

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Delete old OTP
            PreparedStatement delete = con.prepareStatement(
                    "DELETE FROM otp_verification WHERE email=?");

            delete.setString(1, email);
            delete.executeUpdate();

            // Save new OTP
            PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO otp_verification(email, otp) VALUES(?, ?)");

            insert.setString(1, email);
            insert.setString(2, otp);

            insert.executeUpdate();

            // Send OTP Email
            EmailUtility.sendSignupOTP(email, otp);

            response.getWriter().print("✅ OTP Sent Successfully");

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().print("❌ Failed to Send OTP");

        }
    }
}