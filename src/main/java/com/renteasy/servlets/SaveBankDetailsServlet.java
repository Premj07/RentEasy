package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SaveBankDetailsServlet")
public class SaveBankDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        // ==============================
        // CHECK LOGIN
        // ==============================

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        Integer userId =
            (Integer) session.getAttribute("userId");


        // ==============================
        // GET FORM DATA
        // ==============================

        String method =
            request.getParameter("method");

        String accountHolder =
            request.getParameter("account_holder");

        String bankName =
            request.getParameter("bank_name");

        String accountNumber =
            request.getParameter("account_number");

        String ifsc =
            request.getParameter("ifsc");


        // ==============================
        // CLEAN DATA
        // ==============================

        if (accountHolder != null)
            accountHolder = accountHolder.trim();

        if (bankName != null)
            bankName = bankName.trim();

        if (accountNumber != null)
            accountNumber = accountNumber.trim();

        if (ifsc != null)
            ifsc = ifsc.trim().toUpperCase();


        // ==============================
        // BASIC SERVER VALIDATION
        // ==============================

        if (accountHolder == null ||
            accountHolder.isEmpty() ||

            bankName == null ||
            bankName.isEmpty() ||

            accountNumber == null ||
            !accountNumber.matches("[0-9]{6,18}") ||

            ifsc == null ||
            !ifsc.matches("[A-Z]{4}0[A-Z0-9]{6}")) {

            response.sendRedirect(
                "bankAccount.jsp?error=invalid"
            );

            return;
        }


        Connection con = null;

        try {

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

            con = DriverManager.getConnection(

                "jdbc:mysql://localhost:3306/renteasy",

                "root",

                "123456"
            );


            // ==============================
            // CHECK EXISTING BANK ACCOUNT
            // ==============================

            PreparedStatement checkPs =
                con.prepareStatement(

                "SELECT user_id " +
                "FROM bank_details " +
                "WHERE user_id=? " +
                "LIMIT 1"
            );

            checkPs.setInt(1, userId);

            ResultSet checkRs =
                checkPs.executeQuery();

            boolean exists =
                checkRs.next();

            checkRs.close();
            checkPs.close();


            // ==============================
            // UPDATE EXISTING
            // ==============================

            if (exists) {

                PreparedStatement updatePs =
                    con.prepareStatement(

                    "UPDATE bank_details SET " +

                    "method=?, " +
                    "account_holder=?, " +
                    "bank_name=?, " +
                    "account_number=?, " +
                    "ifsc_code=? " +

                    "WHERE user_id=?"
                );


                updatePs.setString(
                    1,
                    method
                );

                updatePs.setString(
                    2,
                    accountHolder
                );

                updatePs.setString(
                    3,
                    bankName
                );

                updatePs.setString(
                    4,
                    accountNumber
                );

                updatePs.setString(
                    5,
                    ifsc
                );

                updatePs.setInt(
                    6,
                    userId
                );


                updatePs.executeUpdate();

                updatePs.close();

            }


            // ==============================
            // INSERT NEW ACCOUNT
            // ==============================

            else {

                PreparedStatement insertPs =
                    con.prepareStatement(

                    "INSERT INTO bank_details " +

                    "(user_id, method, account_holder, " +
                    "bank_name, account_number, ifsc_code) " +

                    "VALUES (?,?,?,?,?,?)"
                );


                insertPs.setInt(
                    1,
                    userId
                );

                insertPs.setString(
                    2,
                    method
                );

                insertPs.setString(
                    3,
                    accountHolder
                );

                insertPs.setString(
                    4,
                    bankName
                );

                insertPs.setString(
                    5,
                    accountNumber
                );

                insertPs.setString(
                    6,
                    ifsc
                );


                insertPs.executeUpdate();

                insertPs.close();

            }


            // ==============================
            // SUCCESS
            // ==============================

            response.sendRedirect(
                "paymentHistory.jsp?msg=bank_saved"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "bankAccount.jsp?error=database"
            );

        } finally {

            if (con != null) {

                try {

                    con.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }
}