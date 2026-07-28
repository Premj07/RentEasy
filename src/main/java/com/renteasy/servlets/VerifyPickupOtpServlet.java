package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/VerifyPickupOtpServlet")
public class VerifyPickupOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        int rentalId = Integer.parseInt(request.getParameter("rentalId"));
        String enteredOtp = request.getParameter("pickupOtp");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            PreparedStatement ps = con.prepareStatement(
                    "SELECT pickup_otp FROM rentals WHERE rental_id=?");

            ps.setInt(1, rentalId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String dbOtp = rs.getString("pickup_otp");

                if (enteredOtp.equals(dbOtp)) {
                	

                    PreparedStatement update = con.prepareStatement(
                        "UPDATE rentals SET pickup_status=?, otp_verified_at=NOW() WHERE rental_id=?");

                    update.setString(1, "COMPLETED");
                    update.setInt(2, rentalId);

                    update.executeUpdate();
                    update.close();
                }
                else {

                    response.sendRedirect("OwnerRentalsServlet?error=invalidotp");
                    con.close();
                    return;

                }
            }

            rs.close();
            ps.close();
            con.close();

            response.sendRedirect("OwnerRentalsServlet");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(e.getMessage());
        }
    }
}