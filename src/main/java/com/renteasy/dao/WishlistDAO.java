package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class WishlistDAO {
    // =====================================================
    // DATABASE CONNECTION
    // =====================================================

    private Connection conn;

    public WishlistDAO() {

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

    // ==========================================
    // ADD PRODUCT TO WISHLIST
    // ==========================================
    public boolean addToWishlist(int userId, int productId) {

        String sql =
            "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

 // ==========================================
 // REMOVE PRODUCT FROM WISHLIST
 // ==========================================
 public boolean removeFromWishlist(int userId, int productId) {

     String sql =
         "DELETE FROM wishlist " +
         "WHERE user_id=? AND product_id=?";

     try (PreparedStatement ps = conn.prepareStatement(sql)) {

         ps.setInt(1, userId);
         ps.setInt(2, productId);

         return ps.executeUpdate() > 0;

     } catch (Exception e) {

         e.printStackTrace();
     }

     return false;
 }


    // ==========================================
    // CHECK PRODUCT IN WISHLIST
    // ==========================================
    public boolean isInWishlist(int userId, int productId) {

        String sql =
            "SELECT wishlist_id FROM wishlist " +
            "WHERE user_id=? AND product_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public ResultSet getWishlistProducts(int userId) {

        try {

            String sql =
                "SELECT " +
                "w.wishlist_id, " +
                "w.created_at, " +
                "p.id AS product_id, " +
                "p.name, " +
                "p.price, " +
                "p.image, " +
                "p.description, " +
                "p.location, " +
                "p.category, " +
                "p.deposit, " +
                "p.availability " +
                "FROM wishlist w " +
                "INNER JOIN products p ON w.product_id = p.id " +
                "WHERE w.user_id=? " +
                "ORDER BY w.created_at DESC";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            return ps.executeQuery();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}