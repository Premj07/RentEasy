package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/rent")
public class RentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = (String) request.getSession().getAttribute("username");
        String productId = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String owner = request.getParameter("owner");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String pincode = request.getParameter("pincode");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

            PreparedStatement ps = con.prepareStatement(
            		"INSERT INTO orders(username, product_id, product_name, price, owner) VALUES(?,?,?,?,?)");

            		ps.setString(1, username);
            		ps.setInt(2, Integer.parseInt(productId));
            		ps.setString(3, name);
            		ps.setInt(4, Integer.parseInt(price));
            		ps.setString(5,owner);
            		

            ps.executeUpdate();

            con.close(); // ✅ important

            response.sendRedirect("dashboard.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e);
        }
    }
}