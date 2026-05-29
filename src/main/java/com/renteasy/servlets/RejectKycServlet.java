package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/rejectKyc")
public class RejectKycServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String username = request.getParameter("user");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy","root","123456");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE kyc SET status='Rejected' WHERE username=?");

            ps.setString(1, username);
            ps.executeUpdate();

            con.close();

            response.sendRedirect("adminUsers.jsp");

        } catch(Exception e){
            response.getWriter().println(e);
        }
    }
}