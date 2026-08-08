package com.renteasy.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/TrendingProductsServlet")
public class TrendingProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<HashMap<String,Object>> products =
                new ArrayList<>();

        String sql =
        	    "SELECT p.*, " +
        	    "COALESCE(SUM(ui.interaction_weight), 0) AS trending_score, " +
        	    "COUNT(ui.interaction_id) AS total_interactions " +

        	    "FROM products p " +

        	    "INNER JOIN user_interactions ui " +
        	    "ON p.id = ui.product_id " +

        	    "WHERE p.status = 'approved' " +
        	    "AND p.availability = 'AVAILABLE' " +

        	    "GROUP BY p.id " +

        	    "ORDER BY trending_score DESC, " +
        	    "total_interactions DESC, " +
        	    "p.id DESC " +

        	    "LIMIT 20";

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (
                Connection con =
                    DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/renteasy",
                        "root",
                        "123456"
                    );

                PreparedStatement ps =
                    con.prepareStatement(sql);

                ResultSet rs =
                    ps.executeQuery()
            ) {

                while (rs.next()) {

                    HashMap<String,Object> product =
                            new HashMap<>();

                    product.put(
                        "id",
                        rs.getInt("id")
                    );

                    product.put(
                        "name",
                        rs.getString("name")
                    );

                    product.put(
                        "price",
                        rs.getInt("price")
                    );

                    product.put(
                        "image",
                        rs.getString("image")
                    );

                    product.put(
                        "location",
                        rs.getString("location")
                    );

                    product.put(
                        "category",
                        rs.getString("category")
                    );

                    product.put(
                        "description",
                        rs.getString("description")
                    );

                    product.put(
                        "trendingScore",
                        rs.getInt("trending_score")
                    );

                    product.put(
                        "totalInteractions",
                        rs.getInt("total_interactions")
                    );

                    products.add(product);
                }
            }

            request.setAttribute(
                "trendingProducts",
                products
            );

            request.getRequestDispatcher(
                "/trendingProducts.jsp"
            ).forward(
                request,
                response
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                "Unable to load trending products.",
                e
            );
        }
    }
}