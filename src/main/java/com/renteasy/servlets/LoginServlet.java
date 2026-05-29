package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("USERNAME: " + username);
        System.out.println("PASSWORD: " + password);

        HttpSession session = request.getSession();

        // 🔐 ADMIN LOGIN
        if("admin".equals(username) && "admin123".equals(password)) {
            session.setAttribute("admin", username);
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy","root","123456");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password=?");

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                System.out.println("LOGIN SUCCESS");

                // ✅ SESSION FIX
                session.setAttribute("user", username);

                response.sendRedirect("dashboard.jsp");

            } else {
                System.out.println("LOGIN FAILED");
                response.sendRedirect("login.jsp?error=1");
            }

            con.close();

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e);
        }
    }
}