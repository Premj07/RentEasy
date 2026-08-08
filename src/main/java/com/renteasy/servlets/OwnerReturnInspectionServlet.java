package com.renteasy.servlets;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/OwnerReturnInspectionServlet")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)

public class OwnerReturnInspectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
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

        String rentalIdValue =
                request.getParameter("rentalId");

        String condition =
                request.getParameter("condition");


        if (rentalIdValue == null ||
            condition == null) {

            response.sendRedirect(
                "OwnerRentalsServlet?error=inspection"
            );

            return;
        }


        int rentalId;

        try {

            rentalId =
                Integer.parseInt(rentalIdValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                "OwnerRentalsServlet?error=inspection"
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

            con.setAutoCommit(false);


            // ==========================================
            // 1. VERIFY THIS RENTAL BELONGS TO OWNER
            // ==========================================

            PreparedStatement rentalCheck =
                    con.prepareStatement(

                    "SELECT refund_status " +
                    "FROM rentals " +
                    "WHERE rental_id=? AND owner_id=?"
            );

            rentalCheck.setInt(1, rentalId);
            rentalCheck.setInt(2, ownerId);

            ResultSet rentalRs =
                    rentalCheck.executeQuery();


            if (!rentalRs.next()) {

                rentalRs.close();
                rentalCheck.close();

                con.rollback();

                response.sendRedirect(
                    "OwnerRentalsServlet?error=unauthorized"
                );

                return;
            }


            String refundStatus =
                    rentalRs.getString("refund_status");

            rentalRs.close();
            rentalCheck.close();


            // Owner can inspect only after return OTP verification

            if (!"RETURN_VERIFIED"
                    .equalsIgnoreCase(refundStatus)) {

                con.rollback();

                response.sendRedirect(
                    "OwnerRentalsServlet?error=return_not_verified"
                );

                return;
            }


            // ==========================================
            // 2. CHECK REFUND RECORD
            // ==========================================

            PreparedStatement refundCheck =
                    con.prepareStatement(

                    "SELECT refund_id, original_deposit " +
                    "FROM deposit_refunds " +
                    "WHERE rental_id=? " +
                    "LIMIT 1"
            );

            refundCheck.setInt(1, rentalId);

            ResultSet refundRs =
                    refundCheck.executeQuery();


            if (!refundRs.next()) {

                refundRs.close();
                refundCheck.close();

                con.rollback();

                response.sendRedirect(
                    "OwnerRentalsServlet?error=refund_not_found"
                );

                return;
            }


            int refundId =
                    refundRs.getInt("refund_id");

            BigDecimal originalDeposit =
                    refundRs.getBigDecimal(
                        "original_deposit"
                    );

            refundRs.close();
            refundCheck.close();


            // ==========================================
            // 3. PRODUCT HAS NO DAMAGE
            // ==========================================

            if ("NO_DAMAGE"
                    .equalsIgnoreCase(condition)) {

                PreparedStatement updateRefund =
                        con.prepareStatement(

                        "UPDATE deposit_refunds SET " +

                        "inspection_status=?, " +
                        "deduction_amount=?, " +
                        "deduction_reason=?, " +
                        "refund_amount=?, " +
                        "refund_status=?, " +
                        "approved_at=NOW() " +

                        "WHERE refund_id=?"
                );


                updateRefund.setString(
                        1,
                        "NO_DAMAGE"
                );

                updateRefund.setBigDecimal(
                        2,
                        BigDecimal.ZERO
                );

                updateRefund.setNull(
                        3,
                        Types.VARCHAR
                );

                updateRefund.setBigDecimal(
                        4,
                        originalDeposit
                );

                updateRefund.setString(
                        5,
                        "DAMAGE_REVIEW"
                );

                updateRefund.setInt(
                        6,
                        refundId
                );


                updateRefund.executeUpdate();
                updateRefund.close();


                PreparedStatement rentalUpdate =
                        con.prepareStatement(

                        "UPDATE rentals " +
                        "SET refund_status=? " +
                        "WHERE rental_id=?"
                );

                rentalUpdate.setString(
                        1,
                        "READY_FOR_REFUND"
                );

                rentalUpdate.setInt(
                        2,
                        rentalId
                );

                rentalUpdate.executeUpdate();
                rentalUpdate.close();


                con.commit();


                response.sendRedirect(
                    "OwnerRentalsServlet?success=no_damage"
                );

                return;
            }


            // ==========================================
            // 4. DAMAGE REPORTED
            // ==========================================

            if ("DAMAGED"
                    .equalsIgnoreCase(condition)) {

                String description =
                        request.getParameter(
                            "damageDescription"
                        );

                String deductionValue =
                        request.getParameter(
                            "requestedDeduction"
                        );


                if (description == null ||
                    description.trim().isEmpty() ||
                    deductionValue == null ||
                    deductionValue.trim().isEmpty()) {

                    con.rollback();

                    response.sendRedirect(
                        "OwnerRentalsServlet?error=damage_details"
                    );

                    return;
                }


                BigDecimal requestedDeduction;

                try {

                    requestedDeduction =
                        new BigDecimal(
                            deductionValue
                        );

                } catch (NumberFormatException e) {

                    con.rollback();

                    response.sendRedirect(
                        "OwnerRentalsServlet?error=invalid_deduction"
                    );

                    return;
                }


                if (requestedDeduction
                        .compareTo(BigDecimal.ZERO) <= 0 ||

                    requestedDeduction
                        .compareTo(originalDeposit) > 0) {

                    con.rollback();

                    response.sendRedirect(
                        "OwnerRentalsServlet?error=invalid_deduction"
                    );

                    return;
                }


                // ======================================
                // SAVE DAMAGE IMAGE
                // ======================================

                Part evidencePart =
                        request.getPart(
                            "damageEvidence"
                        );


                if (evidencePart == null ||
                    evidencePart.getSize() == 0) {

                    con.rollback();

                    response.sendRedirect(
                        "OwnerRentalsServlet?error=evidence_required"
                    );

                    return;
                }


                String submittedFile =
                        evidencePart.getSubmittedFileName();


                String extension = "";

                if (submittedFile != null &&
                    submittedFile.contains(".")) {

                    extension =
                        submittedFile.substring(
                            submittedFile
                                .lastIndexOf(".")
                        );
                }


                String newFileName =
                        "damage_" +
                        rentalId +
                        "_" +
                        System.currentTimeMillis() +
                        extension;


                String uploadPath =
                        getServletContext()
                            .getRealPath(
                                "/uploads/damage"
                            );


                File uploadDirectory =
                        new File(uploadPath);


                if (!uploadDirectory.exists()) {

                    uploadDirectory.mkdirs();
                }


                evidencePart.write(
                    uploadPath +
                    File.separator +
                    newFileName
                );


                String databaseImagePath =
                        "uploads/damage/" +
                        newFileName;


                // ======================================
                // SAVE DAMAGE CLAIM
                // ======================================

                PreparedStatement damageUpdate =
                        con.prepareStatement(

                        "UPDATE deposit_refunds SET " +

                        "inspection_status=?, " +
                        "deduction_amount=?, " +
                        "deduction_reason=?, " +
                        "damage_evidence=?, " +
                        "refund_status=? " +

                        "WHERE refund_id=?"
                );


                damageUpdate.setString(
                        1,
                        "DAMAGE_REPORTED"
                );

                /*
                 * This is the OWNER'S REQUESTED
                 * deduction for now.
                 *
                 * Admin can later change the final
                 * deduction before approval.
                 */
                damageUpdate.setBigDecimal(
                        2,
                        requestedDeduction
                );

                damageUpdate.setString(
                        3,
                        description.trim()
                );

                damageUpdate.setString(
                        4,
                        databaseImagePath
                );

                damageUpdate.setString(
                        5,
                        "DAMAGE_REVIEW"
                );

                damageUpdate.setInt(
                        6,
                        refundId
                );


                damageUpdate.executeUpdate();
                damageUpdate.close();


                PreparedStatement rentalUpdate =
                        con.prepareStatement(

                        "UPDATE rentals " +
                        "SET refund_status=? " +
                        "WHERE rental_id=?"
                );


                rentalUpdate.setString(
                        1,
                        "DAMAGE_REVIEW"
                );

                rentalUpdate.setInt(
                        2,
                        rentalId
                );


                rentalUpdate.executeUpdate();
                rentalUpdate.close();


                con.commit();


                response.sendRedirect(
                    "OwnerRentalsServlet?success=damage_reported"
                );

                return;
            }


            // Unknown condition

            con.rollback();

            response.sendRedirect(
                "OwnerRentalsServlet?error=inspection"
            );


        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {

                try {
                    con.rollback();
                } catch (SQLException ignored) {
                }
            }

            response.sendRedirect(
                "OwnerRentalsServlet?error=server"
            );

        } finally {

            if (con != null) {

                try {

                    con.setAutoCommit(true);
                    con.close();

                } catch (SQLException ignored) {
                }
            }
        }
    }
}