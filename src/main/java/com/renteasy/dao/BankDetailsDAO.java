package com.renteasy.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.renteasy.model.BankDetails;

public class BankDetailsDAO {

    // =====================================================
    // DATABASE CONNECTION
    // =====================================================

    private Connection conn;

    public BankDetailsDAO() {

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
    // GET BANK DETAILS BY USER ID
    // =====================================================

    public BankDetails getBankDetailsByUserId(int userId) {

        BankDetails bankDetails = null;

        try {

            String sql =
                    "SELECT id, user_id, account_holder, " +
                    "bank_name, account_number, ifsc_code, " +
                    "upi_id, method " +
                    "FROM bank_details " +
                    "WHERE user_id=? " +
                    "LIMIT 1";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                bankDetails = new BankDetails();

                bankDetails.setId(
                        rs.getInt("id"));

                bankDetails.setUserId(
                        rs.getInt("user_id"));

                bankDetails.setAccountHolder(
                        rs.getString("account_holder"));

                bankDetails.setBankName(
                        rs.getString("bank_name"));

                bankDetails.setAccountNumber(
                        rs.getString("account_number"));

                bankDetails.setIfscCode(
                        rs.getString("ifsc_code"));

                bankDetails.setUpiId(
                        rs.getString("upi_id"));

                bankDetails.setMethod(
                        rs.getString("method"));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR LOADING BANK DETAILS FOR USER ID: "
                    + userId
            );

            e.printStackTrace();
        }

        return bankDetails;
    }
}