package com.renteasy.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class PersonalizedRankingDAO {

    private static final String URL =
            "jdbc:mysql://localhost:3306/renteasy";

    private static final String USER = "root";
    private static final String PASSWORD = "123456";


    public ArrayList<HashMap<String, Object>>
            getPersonalizedProducts(int userId) {

        ArrayList<HashMap<String, Object>> products =
                new ArrayList<>();


        /*
         * AI PERSONALIZED RANKING
         *
         * Score is created using:
         *
         * User interactions  -> strongest signal
         * Recently viewed    -> interest signal
         * Trending activity  -> popularity signal
         *
         * Only approved and available products
         * are returned.
         */


        String sql =

            "SELECT p.*, " +

            // =====================================
            // USER PERSONAL INTERACTION SCORE
            // =====================================

            "COALESCE((" +

                "SELECT SUM(ui.interaction_weight) " +

                "FROM user_interactions ui " +

                "WHERE ui.product_id = p.id " +
                "AND ui.user_id = ? " +

            "),0) * 5 " +


            // =====================================
            // RECENTLY VIEWED SCORE
            // =====================================

            "+ COALESCE((" +

                "SELECT COUNT(*) " +

                "FROM recently_viewed rv " +

                "WHERE rv.product_id = p.id " +
                "AND rv.user_id = ? " +

            "),0) * 3 " +


            // =====================================
            // GLOBAL TRENDING SCORE
            // =====================================

            "+ COALESCE((" +

                "SELECT SUM(ui2.interaction_weight) " +

                "FROM user_interactions ui2 " +

                "WHERE ui2.product_id = p.id " +

            "),0) " +


            "AS ai_score " +


            // =====================================
            // PRODUCTS
            // =====================================

            "FROM products p " +

            "WHERE p.status = 'approved' " +
            "AND p.availability = 'AVAILABLE' " +

            "ORDER BY ai_score DESC, p.id DESC " +

            "LIMIT 12";


        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );


            try (
                Connection con =
                    DriverManager.getConnection(
                        URL,
                        USER,
                        PASSWORD
                    );

                PreparedStatement ps =
                    con.prepareStatement(sql)
            ) {


                // Same logged-in user for both
                // personalization signals

                ps.setInt(1, userId);

                ps.setInt(2, userId);


                try (
                    ResultSet rs =
                        ps.executeQuery()
                ) {

                    while (rs.next()) {

                        HashMap<String, Object> product =
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
                                "aiScore",
                                rs.getInt("ai_score")
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