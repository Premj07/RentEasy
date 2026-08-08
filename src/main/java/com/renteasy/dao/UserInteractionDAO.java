package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class UserInteractionDAO {

    private Connection conn;

    // ==========================================
    // DATABASE CONNECTION
    // ==========================================
    public UserInteractionDAO() {

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
    // RECORD USER INTERACTION
    // ==========================================
    public boolean recordInteraction(
            int userId,
            int productId,
            String interactionType) {

        int weight = getInteractionWeight(interactionType);

        String sql =
                "INSERT INTO user_interactions " +
                "(user_id, product_id, interaction_type, interaction_weight) " +
                "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, interactionType.toUpperCase());
            ps.setInt(4, weight);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // ==========================================
    // AI INTERACTION WEIGHTS
    // ==========================================
    private int getInteractionWeight(String type) {

        if (type == null) {
            return 1;
        }

        switch (type.toUpperCase()) {

            case "RENT":
                return 5;

            case "WISHLIST":
                return 3;

            case "VIEW":
                return 1;

            default:
                return 1;
        }
    }
}
