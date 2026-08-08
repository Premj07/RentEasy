package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");
        String otp       = request.getParameter("otp");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Verify OTP first
            PreparedStatement checkOtp = con.prepareStatement(
                    "SELECT * FROM otp_verification WHERE email=? AND otp=?");

            checkOtp.setString(1, email);
            checkOtp.setString(2, otp);

            ResultSet rs = checkOtp.executeQuery();

            if (!rs.next()) {

                response.getWriter().println(
                        "<script>alert('Invalid OTP');history.back();</script>");

                return;
            }

            // Check if email already exists
            PreparedStatement checkUser = con.prepareStatement(
                    "SELECT id FROM users WHERE email=?");

            checkUser.setString(1, email);

            ResultSet userRs = checkUser.executeQuery();

            if (userRs.next()) {

                response.getWriter().println(
                        "<script>alert('Email already registered');history.back();</script>");

                return;
            }

            // Insert user
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users(first_name,last_name,email,phone) VALUES(?,?,?,?)");

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);

            ps.executeUpdate();

            HttpSession session = request.getSession();

            session.setAttribute("user", firstName);
            session.setAttribute("firstName", firstName);
            session.setAttribute("lastName", lastName);
            session.setAttribute("email", email);
            session.setAttribute("phone", phone);

            response.sendRedirect("dashboard.jsp");

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}