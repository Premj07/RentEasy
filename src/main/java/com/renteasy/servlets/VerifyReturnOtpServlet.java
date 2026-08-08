package com.renteasy.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyReturnOtpServlet")
public class VerifyReturnOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        // ==========================================
        // CHECK OWNER LOGIN
        // ==========================================

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        int ownerId =
                (Integer) session.getAttribute("userId");


        // ==========================================
        // GET FORM VALUES
        // ==========================================

        String rentalIdParam =
                request.getParameter("rentalId");

        String enteredOtp =
                request.getParameter("returnOtp");


        if (rentalIdParam == null ||
            enteredOtp == null ||
            rentalIdParam.trim().isEmpty() ||
            enteredOtp.trim().isEmpty()) {

            response.sendRedirect(
                    "OwnerRentalsServlet?returnError=missing"
            );

            return;
        }


        int rentalId;

        try {

            rentalId =
                    Integer.parseInt(rentalIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "OwnerRentalsServlet?returnError=invalid"
            );

            return;
        }


        enteredOtp = enteredOtp.trim();


        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );


            try (Connection con =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/renteasy",
                            "root",
                            "123456"
                    )) {


                con.setAutoCommit(false);


                try {

                    // ==========================================
                    // GET RETURN OTP
                    // ==========================================

                    String checkSql =
                            "SELECT return_otp, rental_status " +
                            "FROM rentals " +
                            "WHERE rental_id=? " +
                            "AND owner_id=?";


                    String storedOtp = null;
                    String rentalStatus = null;


                    try (PreparedStatement ps =
                            con.prepareStatement(checkSql)) {


                        ps.setInt(
                                1,
                                rentalId
                        );

                        ps.setInt(
                                2,
                                ownerId
                        );


                        try (ResultSet rs =
                                ps.executeQuery()) {


                            if (rs.next()) {

                                storedOtp =
                                        rs.getString(
                                                "return_otp"
                                        );

                                rentalStatus =
                                        rs.getString(
                                                "rental_status"
                                        );

                            } else {

                                con.rollback();

                                response.sendRedirect(
                                    "OwnerRentalsServlet?returnError=notfound"
                                );

                                return;
                            }
                        }
                    }


                    // ==========================================
                    // CHECK RETURN STATUS
                    // ==========================================

                    if (!"RETURN_APPROVED"
                            .equalsIgnoreCase(rentalStatus)) {

                        con.rollback();

                        response.sendRedirect(
                            "OwnerRentalsServlet?returnError=notapproved"
                        );

                        return;
                    }


                    // ==========================================
                    // VERIFY OTP
                    // ==========================================

                    if (storedOtp == null ||
                        !storedOtp.equals(enteredOtp)) {

                        con.rollback();

                        response.sendRedirect(
                            "OwnerRentalsServlet?returnError=wrongotp"
                        );

                        return;
                    }


                    // ==========================================
                    // OTP CORRECT
                    // MARK PRODUCT AS PHYSICALLY RETURNED
                    // ==========================================

                    String updateSql =
                            "UPDATE rentals " +
                            "SET rental_status='RETURN_VERIFIED', " +
                            "return_otp=NULL " +
                            "WHERE rental_id=? " +
                            "AND owner_id=? " +
                            "AND rental_status='RETURN_APPROVED'";


                    int updated;


                    try (PreparedStatement updatePs =
                            con.prepareStatement(updateSql)) {


                        updatePs.setInt(
                                1,
                                rentalId
                        );

                        updatePs.setInt(
                                2,
                                ownerId
                        );


                        updated =
                                updatePs.executeUpdate();
                    }


                    if (updated == 0) {

                        con.rollback();

                        response.sendRedirect(
                            "OwnerRentalsServlet?returnError=updatefailed"
                        );

                        return;
                    }


                    // ==========================================
                    // SUCCESS
                    // ==========================================

                    con.commit();


                    response.sendRedirect(
                        "OwnerRentalsServlet?returnVerified=true"
                    );


                } catch (Exception e) {

                    con.rollback();
                    throw e;
                }
            }


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "OwnerRentalsServlet?returnError=server"
            );
        }
    }
}