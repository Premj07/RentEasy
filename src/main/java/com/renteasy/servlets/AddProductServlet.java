package com.renteasy.servlets;

import java.io.File;

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
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;
@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String id = request.getParameter("id");

            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String pincode = request.getParameter("pincode");
            String status = "pending";
            String owner = (String) request.getSession().getAttribute("email");
            String latitude = request.getParameter("latitude");
            String longitude = request.getParameter("longitude");
            
            String listingType =
            		request.getParameter("listingType");

            		String sellingPrice =
            		request.getParameter("sellingPrice");

            		if(sellingPrice==null || sellingPrice.isEmpty()){

            		sellingPrice="0";

            		}

            int price = Integer.parseInt(
                    request.getParameter("price"));

            int deposit = Integer.parseInt(
                    request.getParameter("deposit"));
            
            int actualPrice = Integer.parseInt(
                    request.getParameter("actualPrice"));

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/renteasy",
                            "root",
                            "123456");

            String imagePath = "";

            Part filePart = request.getPart("imageFile");

            if(filePart != null &&
               filePart.getSize() > 0){

                String fileName =
                        filePart.getSubmittedFileName();

                String uploadPath =
                        getServletContext()
                        .getRealPath("")
                        + "uploads"
                        + File.separator;

                File uploadDir =
                        new File(uploadPath);

                if(!uploadDir.exists()){
                    uploadDir.mkdirs();
                }
                System.out.println("Upload Path : " + uploadPath);
                System.out.println("File Name : " + fileName);
                filePart.write(
                        uploadPath + fileName);

                imagePath =
                        "uploads/" + fileName;
            }

            /* ADD PRODUCT */

            if(id == null || id.trim().equals("")){

                PreparedStatement ps =
                        con.prepareStatement(

                                "INSERT INTO products(" +
                                		"name," +
                                		"price," +
                                		"deposit," +
                                		"actual_price," +
                                		"image," +
                                		"owner," +
                                		"owner_id," +
                                		"description," +
                                        "location," +
                                		"latitude,"+
                                		"longitude,"+                        
                                        "pincode," +
                                        "category," +
                                        "status," +
                                        "listing_type,"+
                                        "selling_price"+
                                        ") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
               
                HttpSession session = request.getSession();
                Integer ownerId = (Integer) session.getAttribute("userId");
                System.out.println("========== SESSION DEBUG ==========");
                System.out.println("userId = " + session.getAttribute("userId"));
                System.out.println("email = " + session.getAttribute("email"));
                System.out.println("===================================");
                ps.setString(1, name);
                ps.setInt(2, price);
                ps.setInt(3, deposit);
                ps.setInt(4, actualPrice);
                ps.setString(5, imagePath);
                ps.setString(6, owner);
                ps.setInt(7, ownerId);
                ps.setString(8, description);
                ps.setString(9, location);
                ps.setString(10, latitude);
                ps.setString(11, longitude);
                ps.setString(12, pincode);
                ps.setString(13, category);
                ps.setString(14, status);
                ps.setString(15, listingType);
                ps.setDouble(16, Double.parseDouble(sellingPrice));
                ps.executeUpdate();
            }

            /* UPDATE PRODUCT */

            else{

                PreparedStatement ps;

                if(imagePath.equals("")){

                	ps = con.prepareStatement(
                		    "UPDATE products SET " +
                		            "name=?," +
                		            "price=?," +
                		            "deposit=?," +
                		            "description=?," +
                		            "location=?," +
                		            "latitude=?," +
                		            "longitude=?," +
                		            "category=? " +
                		            "WHERE id=?");

                	ps.setString(1, name);
                	ps.setInt(2, price);
                	ps.setInt(3, deposit);
                	ps.setString(4, description);
                	ps.setString(5, location);
                	ps.setString(6, latitude);
                	ps.setString(7, longitude);
                	ps.setString(8, category);
                	ps.setInt(9, Integer.parseInt(id));

                }else{

                	ps = con.prepareStatement(
                		    "UPDATE products SET " +
                		            "name=?," +
                		            "price=?," +
                		            "deposit=?," +
                		            "image=?," +
                		            "description=?," +
                		            "location=?," +
                		            "latitude=?," +
                		            "longitude=?," +
                		            "category=? " +
                		            "WHERE id=?");

                	ps.setString(1, name);
                	ps.setInt(2, price);
                	ps.setInt(3, deposit);
                	ps.setString(4, imagePath);
                	ps.setString(5, description);
                	ps.setString(6, location);
                	ps.setString(7, latitude);
                	ps.setString(8, longitude);
                	ps.setString(9, category);
                	ps.setInt(10, Integer.parseInt(id));
                }

                ps.executeUpdate();
            }

            con.close();

            response.sendRedirect(
                    "ownerDashboard.jsp");

        }
        catch(Exception e){

            e.printStackTrace();

            response.getWriter()
                    .println(e.getMessage());
        }
    }
}
