package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        HttpSession session = request.getSession();

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM users WHERE email=?");

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // =====================================================
                // SAVE LOGGED-IN USER DETAILS IN SESSION
                // =====================================================

                session.setAttribute("userId", rs.getInt("id"));

                session.setAttribute("user", email);

                session.setAttribute("email", rs.getString("email"));

                session.setAttribute("firstName", rs.getString("first_name"));

                session.setAttribute("lastName", rs.getString("last_name"));

                // IMPORTANT: REQUIRED FOR OWNER SECURITY CHECK
                session.setAttribute("role", rs.getString("role"));

                // =====================================================
                // DEBUG - TEMPORARY
                // =====================================================

                System.out.println("LOGIN USER ID = " + rs.getInt("id"));
                System.out.println("LOGIN EMAIL = " + rs.getString("email"));
                System.out.println("LOGIN ROLE = " + rs.getString("role"));

                // =====================================================
                // CONTINUE OTP LOGIN
                // =====================================================

                response.sendRedirect("verifyLoginOtp.jsp");

            } else {

                response.sendRedirect("index.jsp");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("ERROR : " + e.getMessage());

        }

    }
}