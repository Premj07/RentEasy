package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateProductServlet")
@MultipartConfig
public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String priceStr = request.getParameter("price");
            String depositStr = request.getParameter("deposit");

            if(idStr == null || idStr.trim().isEmpty()){
                throw new Exception("Product ID Missing");
            }

            int id = Integer.parseInt(idStr);
            int price = Integer.parseInt(priceStr);
            int deposit = Integer.parseInt(depositStr);

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456");

            PreparedStatement ps =
            con.prepareStatement(

            "UPDATE products SET " +
            "name=?," +
            "category=?," +
            "price=?," +
            "deposit=?," +
            "description=?," +
            "location=?," +
            "status='pending' " +
            "WHERE id=?");

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setInt(3, price);
            ps.setInt(4, deposit);
            ps.setString(5, description);
            ps.setString(6, location);
            ps.setInt(7, id);

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if(rows > 0){
                response.sendRedirect(
                "ownerDashboard.jsp?updated=1");
            }
            else{
                response.getWriter().println(
                "No Product Found");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
            "<h2 style='color:red'>Update Failed</h2>");

            response.getWriter().println(
            "<h3>" + e.getMessage() + "</h3>");
        }
    }
}