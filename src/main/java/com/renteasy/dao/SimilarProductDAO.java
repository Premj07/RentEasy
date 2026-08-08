package com.renteasy.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class SimilarProductDAO {

    public ArrayList<HashMap<String, Object>> getSimilarProducts(
            int currentProductId,
            String category,
            int currentPrice,
            String location) {

        ArrayList<HashMap<String, Object>> products = new ArrayList<>();

        String sql =
                "SELECT p.*, " +

                // Category similarity
                "(CASE WHEN p.category = ? THEN 40 ELSE 0 END) + " +

                // Price similarity
                "(CASE " +
                "WHEN ABS(p.price - ?) <= 100 THEN 25 " +
                "WHEN ABS(p.price - ?) <= 300 THEN 15 " +
                "ELSE 5 END) + " +

                // Location similarity
                "(CASE WHEN p.location LIKE ? THEN 20 ELSE 0 END) + " +

                // Popularity / interaction score
                "(CASE " +
                "WHEN COALESCE(SUM(ui.interaction_weight),0) >= 10 THEN 15 " +
                "WHEN COALESCE(SUM(ui.interaction_weight),0) >= 5 THEN 10 " +
                "WHEN COALESCE(SUM(ui.interaction_weight),0) > 0 THEN 5 " +
                "ELSE 0 END) " +

                "AS similarity_score " +

                "FROM products p " +

                "LEFT JOIN user_interactions ui " +
                "ON p.id = ui.product_id " +

                "WHERE p.id != ? " +
                "AND p.status = 'approved' " +
                "AND p.availability = 'AVAILABLE' " +

                "GROUP BY p.id " +

                "ORDER BY similarity_score DESC, p.id DESC " +

                "LIMIT 6";

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/renteasy",
                        "root",
                        "123456"
                );

                PreparedStatement ps = con.prepareStatement(sql)
            ) {

                ps.setString(1, category);

                ps.setInt(2, currentPrice);

                ps.setInt(3, currentPrice);

                if (location != null && !location.trim().isEmpty()) {
                    ps.setString(4, "%" + location + "%");
                } else {
                    ps.setString(4, "%%");
                }

                ps.setInt(5, currentProductId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        HashMap<String, Object> product = new HashMap<>();

                        product.put("id", rs.getInt("id"));

                        product.put("name", rs.getString("name"));

                        product.put("price", rs.getInt("price"));

                        product.put("image", rs.getString("image"));

                        product.put("location", rs.getString("location"));

                        product.put("category", rs.getString("category"));

                        product.put(
                                "description",
                                rs.getString("description")
                        );

                        product.put(
                                "similarityScore",
                                rs.getInt("similarity_score")
                        );

                        products.add(product);
                    }
                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return products;
    }
}