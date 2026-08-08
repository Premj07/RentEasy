package com.renteasy.dao;

import java.sql.*;

public class AISearchHistoryDAO {

    private Connection con;

    public AISearchHistoryDAO() {

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

    public ResultSet getRecentSearches(int userId) {

        try {

            String sql =
                    "SELECT search_query " +
                    "FROM ai_search_history " +
                    "WHERE user_id=? " +
                    "ORDER BY searched_at DESC " +
                    "LIMIT 8";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            return ps.executeQuery();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

}