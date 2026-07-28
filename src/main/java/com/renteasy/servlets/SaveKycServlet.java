package com.renteasy.servlets;

import java.io.File;
import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.renteasy.ocr.KYCVerifier;
import com.renteasy.ocr.ValidationResult;
import jakarta.servlet.ServletException;
import com.renteasy.utils.EmailUtility;

@WebServlet("/saveKyc")
@MultipartConfig
public class SaveKycServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
throws ServletException, IOException {

        try {

            // ===== FORM DATA =====
            String firstName = request.getParameter("firstName");
            String middleName = request.getParameter("middleName");
            String lastName = request.getParameter("lastName");

            String username = firstName;

            String fullname = firstName + " "
                    + (middleName == null ? "" : middleName) + " "
                    + lastName;

            String email = request.getParameter("email");
            String otp = request.getParameter("otp");

            String address = request.getParameter("address");

            // Old database fields (keep blank for now)
            String phone = "";
            String aadhaar = "";
            String district = "";
            String city = "";
            String pincode = "";

            // ===== FILES =====
            Part photoPart = request.getPart("photo");
            Part collegePart = request.getPart("collegeId");
            Part aadhaarPart = request.getPart("aadhaarCard");

            String photoName = photoPart.getSubmittedFileName();
            String collegeName = collegePart.getSubmittedFileName();
            String aadhaarName = aadhaarPart.getSubmittedFileName();

            String path = getServletContext().getRealPath("") + "uploads/";

            File dir = new File(path);

            if (!dir.exists()) {
                dir.mkdirs();
            }

            photoPart.write(path + photoName);
            collegePart.write(path + collegeName);
            aadhaarPart.write(path + aadhaarName);

         // OCR Verification
            String collegePath = path + collegeName;
            String aadhaarPath = path + aadhaarName;

            ValidationResult kycResult =
                    KYCVerifier.verify(collegePath, aadhaarPath);
            
            // ===== DATABASE =====

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            // Verify OTP
            PreparedStatement verify = con.prepareStatement(
                    "SELECT * FROM otp_verification WHERE email=? AND otp=?");

            verify.setString(1, email);
            verify.setString(2, otp);

            ResultSet rs = verify.executeQuery();

            if (!rs.next()) {

                response.getWriter().println("Invalid Email OTP");
                con.close();
                return;
            }

            // Prevent duplicate KYC

            PreparedStatement check = con.prepareStatement(
                    "SELECT id, status FROM kyc WHERE email=?");

            check.setString(1, email);

            ResultSet checkRs = check.executeQuery();

            boolean updateExisting = false;
            int kycId = 0;

            if (checkRs.next()) {

                String status = checkRs.getString("status");

                if ("Approved".equalsIgnoreCase(status)) {

                    response.getWriter().println("Your KYC is already approved.");
                    con.close();
                    return;

                }

                if ("Rejected".equalsIgnoreCase(status)) {

                    updateExisting = true;
                    kycId = checkRs.getInt("id");

                }

            }

            PreparedStatement ps;

            if (updateExisting) {

                ps = con.prepareStatement(

                    "UPDATE kyc SET username=?, fullname=?, mobile=?, aadhaar=?, address=?, photo=?, document=?, aadhaar_document=?, status=? WHERE id=?");

                ps.setString(1, username);
                ps.setString(2, fullname);
                ps.setString(3, phone);
                ps.setString(4, aadhaar);
                ps.setString(5, address);
                ps.setString(6, "uploads/" + photoName);
                ps.setString(7, "uploads/" + collegeName);
                ps.setString(8, "uploads/" + aadhaarName);

                if (kycResult.isValid()) {
                    ps.setString(9, "Approved");
                } else {
                    ps.setString(9, "Rejected");
                }

                ps.setInt(10, kycId);

            } else {

                ps = con.prepareStatement(

                    "INSERT INTO kyc(username, fullname, email, mobile, aadhaar, address, photo, document, aadhaar_document, status) VALUES(?,?,?,?,?,?,?,?,?,?)");

                ps.setString(1, username);
                ps.setString(2, fullname);
                ps.setString(3, email);
                ps.setString(4, phone);
                ps.setString(5, aadhaar);
                ps.setString(6, address);
                ps.setString(7, "uploads/" + photoName);
                ps.setString(8, "uploads/" + collegeName);
                ps.setString(9, "uploads/" + aadhaarName);

                if (kycResult.isValid()) {
                    ps.setString(10, "Approved");
                } else {
                    ps.setString(10, "Rejected");
                }

            }

            ps.executeUpdate();

            con.close();

            if (kycResult.isValid()) {

                EmailUtility.sendKYCSuccessEmail(
                        email,
                        fullname);

                response.sendRedirect("dashboard.jsp");

            } else {

                request.setAttribute("reason", kycResult.getMessage());
                request.getRequestDispatcher("kyc-status.jsp")
                       .forward(request, response);

            }

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("ERROR : " + e);

        }

    }
}