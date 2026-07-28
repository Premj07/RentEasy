package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RefundDepositServlet")
public class RefundDepositServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int rentalId = Integer.parseInt(request.getParameter("id"));

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Update refund status
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE rentals SET refund_status='COMPLETED' WHERE rental_id=?");

            ps.setInt(1, rentalId);

            ps.executeUpdate();

            // Notify user
            PreparedStatement notify = con.prepareStatement(
                    "INSERT INTO notifications(username,message) " +
                    "SELECT users.username, CONCAT('Your security deposit for rental ID ', rentals.rental_id, ' has been refunded successfully.') " +
                    "FROM rentals JOIN users ON rentals.user_id=users.id " +
                    "WHERE rentals.rental_id=?");

            notify.setInt(1, rentalId);

            notify.executeUpdate();

            con.close();

            response.sendRedirect("adminRefund.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}