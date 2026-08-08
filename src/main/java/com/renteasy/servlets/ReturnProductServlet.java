package com.renteasy.servlets;

import java.io.IOException;
import java.io.File;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@WebServlet("/returnProduct")
public class ReturnProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
                DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            PreparedStatement ps =
                con.prepareStatement(
                "update rent_orders set status=? where id=?");

            ps.setString(1,"Return Requested");
            ps.setInt(2,id);

            ps.executeUpdate();

            response.sendRedirect("myRentals.jsp");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}