package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/rejectProduct")
public class RejectProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String id = request.getParameter("id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE products SET status='rejected' WHERE id=?");

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

            response.sendRedirect("adminProducts.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}