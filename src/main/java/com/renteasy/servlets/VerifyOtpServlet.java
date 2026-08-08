package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {

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

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM otp_verification WHERE email=? AND otp=?");

            ps.setString(1, email);
            ps.setString(2, otp);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();

                String name = (String) session.getAttribute("name");
                String username = (String) session.getAttribute("username");
                String phone = (String) session.getAttribute("phone");
                String password = (String) session.getAttribute("password");

                PreparedStatement insertUser = con.prepareStatement(
                    "INSERT INTO users(name, username, email, phone, password) VALUES (?, ?, ?, ?, ?)");

                insertUser.setString(1, name);
                insertUser.setString(2, username);
                insertUser.setString(3, email);
                insertUser.setString(4, phone);
                insertUser.setString(5, password);

                insertUser.executeUpdate();

                response.sendRedirect("index.jsp");

            } else {

                response.getWriter().println("Invalid OTP");

            }

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
}