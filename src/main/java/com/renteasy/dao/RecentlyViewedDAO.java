package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RecentlyViewedDAO {

    private Connection con;

    public RecentlyViewedDAO() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ResultSet getRecentlyViewed(int userId) {

        try {

            String sql =
                    "SELECT p.id,p.name,p.category,p.price,p.image," +
                    "rv.viewed_at " +
                    "FROM recently_viewed rv " +
                    "INNER JOIN products p ON rv.product_id=p.id " +
                    "WHERE rv.user_id=? " +
                    "ORDER BY rv.viewed_at DESC " +
                    "LIMIT 5";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            return ps.executeQuery();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

}