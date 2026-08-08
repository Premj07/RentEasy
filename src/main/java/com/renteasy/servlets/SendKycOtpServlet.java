package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Random;

import com.renteasy.utils.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/sendKycOtp")
public class SendKycOtpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try {

            String otp =
                String.valueOf(
                100000 + new Random().nextInt(900000));

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
                DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy",
                "root",
                "123456");

            // Delete old OTP
            PreparedStatement delete =
                con.prepareStatement(
                "DELETE FROM otp_verification WHERE email=?");

            delete.setString(1, email);
            delete.executeUpdate();

            // Insert new OTP
            PreparedStatement insert =
                con.prepareStatement(
                "INSERT INTO otp_verification(email, otp) VALUES(?, ?)");

            insert.setString(1, email);
            insert.setString(2, otp);

            insert.executeUpdate();

            // Send Email
            EmailUtility.sendKycOTP(email, otp);

            response.getWriter().print(
                "OTP Sent Successfully");

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print(
                "Failed To Send OTP");
        }
    }
}