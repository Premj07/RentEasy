package com.renteasy.dao;

import java.sql.*;
import java.util.*;

public class RecommendationDAO {

    private Connection conn;

    public RecommendationDAO() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy",
                "root",
                "123456"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // =====================================================
    // GET USER'S PREFERRED CATEGORY
    // =====================================================

    public String getPreferredCategory(int userId) {

        String sql =
            "SELECT p.category, " +
            "SUM(ui.interaction_weight) AS score " +
            "FROM user_interactions ui " +
            "JOIN products p ON ui.product_id = p.id " +
            "WHERE ui.user_id = ? " +
            "GROUP BY p.category " +
            "ORDER BY score DESC " +
            "LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("category");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
 // =====================================================
 // AI RECOMMENDED PRODUCTS
 // =====================================================
 public ResultSet getRecommendedProducts(int userId) {

     try {

         String category = getPreferredCategory(userId);

         String sql;

         PreparedStatement ps;

         if (category != null) {

             sql =
                 "SELECT p.*, " +
                 "COALESCE(SUM(ui.interaction_weight),0) AS score " +
                 "FROM products p " +
                 "LEFT JOIN user_interactions ui " +
                 "ON p.id = ui.product_id " +
                 "WHERE p.category=? " +
                 "AND p.status='approved' " +
                 "AND p.availability='AVAILABLE' " +
                 "GROUP BY p.id " +
                 "ORDER BY score DESC, RAND() " +
                 "LIMIT 6";

             ps = conn.prepareStatement(sql);

             ps.setString(1, category);

         } else {

             sql =
                 "SELECT p.*, " +
                 "0 AS score " +
                 "FROM products p " +
                 "WHERE p.status='approved' " +
                 "AND p.availability='AVAILABLE' " +
                 "ORDER BY RAND() " +
                 "LIMIT 6";

             ps = conn.prepareStatement(sql);

         }

         return ps.executeQuery();

     } catch (Exception e) {

         e.printStackTrace();

     }

     return null;
 }
}