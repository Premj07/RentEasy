package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TrendingProductDAO {

    private Connection con;

    public TrendingProductDAO() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );

        } catch (Exception e) {

            e.printStackTrace();
        }
    }


    // ==========================================
    // GET REAL TRENDING PRODUCTS
    // ==========================================

    public ResultSet getTrendingProducts() {

        try {

            String sql =

                "SELECT " +
                "p.id, " +
                "p.name, " +
                "p.category, " +
                "p.price, " +
                "p.image, " +

                "(" +

                // RENTAL SCORE
                "(SELECT COUNT(*) " +
                " FROM rentals r " +
                " WHERE r.product_id = p.id) * 5 " +

                "+" +

                // WISHLIST SCORE
                "(SELECT COUNT(*) " +
                " FROM wishlist w " +
                " WHERE w.product_id = p.id) * 3 " +

                "+" +

                // VIEW SCORE
                "(SELECT COUNT(*) " +
                " FROM recently_viewed rv " +
                " WHERE rv.product_id = p.id) * 1 " +

                ") AS trend_score " +

                "FROM products p " +

                "WHERE p.status='approved' " +

                "ORDER BY trend_score DESC, p.id DESC " +

                "LIMIT 5";


            PreparedStatement ps =
                    con.prepareStatement(sql);

            return ps.executeQuery();

        } catch (Exception e) {

            System.out.println(
                    "Error loading trending products:"
            );

            e.printStackTrace();
        }

        return null;
    }
}