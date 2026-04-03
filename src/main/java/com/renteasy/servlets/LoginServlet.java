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

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // 🔐 ADMIN LOGIN (ONLY THIS CAN ACCESS ADMIN PANEL)
        if(username.equals("admin") && password.equals("admin123")) {
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
                session.setAttribute("username", username);
                response.sendRedirect("ownerDashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}