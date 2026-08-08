package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.Random;

import com.renteasy.utils.EmailUtility;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/sendLoginOtp")
public class LoginOtpServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Check email exists
         // Allow Admin Email
            if(!email.equalsIgnoreCase("renteasy.project@gmail.com")){

                PreparedStatement check =
                        con.prepareStatement(
                        "SELECT * FROM users WHERE email=?");

                check.setString(1, email);

                ResultSet rs = check.executeQuery();

                if(!rs.next()){
                    response.getWriter().print("Email Not Registered");
                    return;
                }
            }

            // Generate OTP
            String otp =
                    String.valueOf(
                    100000 + new Random().nextInt(900000));

            // Delete old OTP
            PreparedStatement del =
                    con.prepareStatement(
                    "DELETE FROM otp_verification WHERE email=?");

            del.setString(1, email);
            del.executeUpdate();

            // Save new OTP
            PreparedStatement insert =
                    con.prepareStatement(
                    "INSERT INTO otp_verification(email,otp) VALUES(?,?)");

            insert.setString(1, email);
            insert.setString(2, otp);

            insert.executeUpdate();

            // Send email
            EmailUtility.sendLoginOTP(email, otp);

            response.getWriter().print(
                    "Login OTP Sent Successfully");

            con.close();

        } catch(Exception e){

            e.printStackTrace();

            response.getWriter().print(
                    "Error Sending OTP");
        }
    }
}