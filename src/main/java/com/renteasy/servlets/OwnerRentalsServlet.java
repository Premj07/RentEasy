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

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        int ownerId =
                (Integer) session.getAttribute("userId");

        List<OwnerRental> rentals =
                new ArrayList<>();

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (
                Connection con =
                    DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/renteasy",
                        "root",
                        "123456"
                    );

                PreparedStatement ps =
                    con.prepareStatement(

                        "SELECT " +

                        "r.rental_id, " +
                        "r.start_date, " +
                        "r.end_date, " +
                        "r.rent_amount, " +
                        "r.pickup_otp, " +
                        "r.pickup_status, " +
                        "r.rental_status, " +
                        "r.refund_status, " +

                        "p.name AS product_name, " +
                        "p.image AS product_image, " +

                        "u.first_name, " +
                        "u.last_name, " +
                        "u.email, " +
                        "u.phone, " +

                        "dr.inspection_status " +

                        "FROM rentals r " +

                        "JOIN products p " +
                        "ON r.product_id = p.id " +

                        "JOIN users u " +
                        "ON r.user_id = u.id " +

                        "LEFT JOIN deposit_refunds dr " +
                        "ON r.rental_id = dr.rental_id " +

                        "WHERE r.owner_id = ? " +

                        "ORDER BY r.rental_id DESC"
                    )
            ) {

                ps.setInt(1, ownerId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        OwnerRental rental =
                                new OwnerRental();

                        rental.setRentalId(
                                rs.getInt("rental_id")
                        );

                        rental.setProductName(
                                rs.getString("product_name")
                        );

                        rental.setProductImage(
                                rs.getString("product_image")
                        );

                        rental.setCustomerName(
                                rs.getString("first_name")
                                + " "
                                + rs.getString("last_name")
                        );

                        rental.setCustomerEmail(
                                rs.getString("email")
                        );

                        rental.setCustomerPhone(
                                rs.getString("phone")
                        );

                        rental.setStartDate(
                                rs.getDate("start_date")
                        );

                        rental.setEndDate(
                                rs.getDate("end_date")
                        );

                        rental.setRentAmount(
                                rs.getDouble("rent_amount")
                        );

                        rental.setPickupOtp(
                                rs.getString("pickup_otp")
                        );

                        rental.setPickupStatus(
                                rs.getString("pickup_status")
                        );

                        // IMPORTANT
                        rental.setRentalStatus(
                                rs.getString("rental_status")
                        );

                        rental.setRefundStatus(
                                rs.getString("refund_status")
                        );

                        rental.setInspectionStatus(
                                rs.getString("inspection_status")
                        );

                        rentals.add(rental);
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "loadError",
                    "Unable to load rental records."
            );
        }

        request.setAttribute(
                "rentals",
                rentals
        );

        request.getRequestDispatcher(
                "owner-rentals.jsp"
        ).forward(request, response);
    }
}