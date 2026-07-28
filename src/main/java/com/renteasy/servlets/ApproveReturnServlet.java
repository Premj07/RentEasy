package com.renteasy.servlets;

import java.io.IOException;
import java.io.File;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@WebServlet("/approveReturn")
public class ApproveReturnServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int id =
        Integer.parseInt(
        request.getParameter("id"));
        

        try {

            Class.forName(
            "com.mysql.cj.jdbc.Driver");

            Connection con =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/renteasy",
            "root",
            "123456");
            PreparedStatement getProduct =
            		con.prepareStatement(
            		"SELECT product_id FROM rentals WHERE rental_id=?");

            		getProduct.setInt(1, id);

            		ResultSet productRs =
            		getProduct.executeQuery();

            		int productId = 0;

            		if(productRs.next()){
            		    productId = productRs.getInt("product_id");
            		}

            PreparedStatement ps =
            		con.prepareStatement(
            				"UPDATE rentals SET rental_status='RETURNED' WHERE rental_id=?");
            		
            ps.setInt(1, id);

            ps.executeUpdate();
            
            PreparedStatement ps2 =
            		con.prepareStatement(
            		"UPDATE products SET status='AVAILABLE' WHERE id=?");

            		ps2.setInt(1, productId);

            		ps2.executeUpdate();
            
            PreparedStatement getUser =
            		con.prepareStatement(
            		"SELECT username FROM users WHERE id=(SELECT user_id FROM rentals WHERE rental_id=?)");

            		getUser.setInt(1,id);

            		ResultSet userRs = getUser.executeQuery();

            		String userName="";

            		if(userRs.next()){
            		    userName=userRs.getString("username");
            		}
            
            PreparedStatement notify =
            		con.prepareStatement(
            		"INSERT INTO notifications(username,message) VALUES(?,?)");

            		notify.setString(1,userName);

            		notify.setString(2,
            		"Your return request has been approved.");

            		notify.executeUpdate();

            response.sendRedirect(
            "adminReturns.jsp");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}