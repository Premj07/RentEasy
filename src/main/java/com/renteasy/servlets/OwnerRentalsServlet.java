package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.renteasy.model.OwnerRental;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/OwnerRentalsServlet")
public class OwnerRentalsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");

        List<OwnerRental> rentals = new ArrayList<>();

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            String sql =
                    "SELECT r.*, " +
                    "p.name, p.image, " +
                    "u.first_name, u.last_name, u.email, u.phone " +
                    "FROM rentals r " +
                    "JOIN products p ON r.product_id=p.id " +
                    "JOIN users u ON r.user_id=u.id " +
                    "WHERE r.owner_id=? " +
                    "ORDER BY r.rental_id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, ownerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                OwnerRental rental = new OwnerRental();

                rental.setRentalId(rs.getInt("rental_id"));
                rental.setProductName(rs.getString("name"));
                rental.setProductImage(rs.getString("image"));

                rental.setCustomerName(
                        rs.getString("first_name") + " " +
                        rs.getString("last_name"));

                rental.setCustomerEmail(rs.getString("email"));
                rental.setCustomerPhone(rs.getString("phone"));

                rental.setStartDate(rs.getDate("start_date"));
                rental.setEndDate(rs.getDate("end_date"));

                rental.setRentAmount(rs.getDouble("rent_amount"));

                rental.setPickupOtp(rs.getString("pickup_otp"));
                rental.setPickupStatus(rs.getString("pickup_status"));

                rentals.add(rental);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("rentals", rentals);

        request.getRequestDispatcher("owner-rentals.jsp")
               .forward(request, response);
    }
}