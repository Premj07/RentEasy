package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String id = request.getParameter("id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy","root","123456");

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM users WHERE id=?");

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            response.sendRedirect("adminUsers.jsp");

        } catch(Exception e){
            response.getWriter().println(e);
        }
    }
}