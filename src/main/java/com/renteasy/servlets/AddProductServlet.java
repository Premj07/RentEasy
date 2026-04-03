package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String category = request.getParameter("category");

        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String pincode = request.getParameter("pincode");

        String owner = (String) request.getSession().getAttribute("username");

        // IMAGE LOGIC
        String imageUrl = request.getParameter("imageUrl");
        Part filePart = request.getPart("imageFile");

        String finalImage = "";

        if (imageUrl != null && !imageUrl.isEmpty()) {
            finalImage = imageUrl;
        } else if (filePart != null && filePart.getSize() > 0) {

            String fileName = filePart.getSubmittedFileName();

            String uploadPath = "C:/RentEasyUploads";
            java.io.File uploadDir = new java.io.File(uploadPath);

            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + "/" + fileName);

            finalImage = "file:///C:/RentEasyUploads/" + fileName;
        }

        if (finalImage.equals("")) {
            response.getWriter().println("Please upload image or provide URL");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy", "root", "123456");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO products(name, price, image, owner, category, description, location, pincode) VALUES(?,?,?,?,?,?,?,?)");

            ps.setString(1, name);
            ps.setInt(2, Integer.parseInt(price));
            ps.setString(3, finalImage);
            ps.setString(4, owner);
            ps.setString(5, category);
            ps.setString(6, description);
            ps.setString(7, location);
            ps.setString(8, pincode);

            ps.executeUpdate();

            response.sendRedirect("ownerDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(e);
        }
    }
}