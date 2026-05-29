package com.renteasy.servlets;

import java.io.IOException;
import java.io.File;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");

            String priceStr = request.getParameter("price");
            int price = 0;
            if(priceStr != null && !priceStr.isEmpty()){
                price = Integer.parseInt(priceStr);
            }

            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String owner = request.getParameter("owner");

            // FILE UPLOAD
            Part filePart = request.getPart("imageFile");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + "uploads/";
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + fileName);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy","root","123456");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO products(name,category,price,description,location,owner,image,status) VALUES(?,?,?,?,?,?,?,?)");

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setInt(3, price);
            ps.setString(4, description);
            ps.setString(5, location);
            ps.setString(6, owner);
            ps.setString(7, "uploads/" + fileName);
            ps.setString(8, "pending");

            ps.executeUpdate();

            response.sendRedirect("ownerDashboard.jsp?success=1");

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}