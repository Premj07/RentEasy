package com.renteasy.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/CategoryProductsServlet")
public class CategoryProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String category =
                request.getParameter("category");

        ArrayList<HashMap<String,Object>> products =
                new ArrayList<>();

        if(category == null || category.trim().isEmpty()){

            response.sendRedirect(
                request.getContextPath() + "/dashboard.jsp"
            );

            return;
        }

        String sql =
            "SELECT * FROM products " +
            "WHERE category = ? " +
            "AND status = 'approved' " +
            "AND availability = 'AVAILABLE' " +
            "ORDER BY id DESC";

        try{

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

            try(
                Connection con =
                    DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/renteasy",
                        "root",
                        "123456"
                    );

                PreparedStatement ps =
                    con.prepareStatement(sql)
            ){

                ps.setString(
                    1,
                    category
                );

                try(ResultSet rs = ps.executeQuery()){

                    while(rs.next()){

                        HashMap<String,Object> p =
                                new HashMap<>();

                        p.put(
                            "id",
                            rs.getInt("id")
                        );

                        p.put(
                            "name",
                            rs.getString("name")
                        );

                        p.put(
                            "price",
                            rs.getInt("price")
                        );

                        p.put(
                            "image",
                            rs.getString("image")
                        );

                        p.put(
                            "location",
                            rs.getString("location")
                        );

                        p.put(
                            "category",
                            rs.getString("category")
                        );

                        p.put(
                            "description",
                            rs.getString("description")
                        );

                        products.add(p);
                    }
                }
            }

        }catch(Exception e){

            e.printStackTrace();

            throw new ServletException(
                "Error loading category products",
                e
            );
        }

        request.setAttribute(
            "products",
            products
        );

        request.setAttribute(
            "selectedCategory",
            category
        );

        request.getRequestDispatcher(
            "/categoryProducts.jsp"
        ).forward(
            request,
            response
        );
    }
}