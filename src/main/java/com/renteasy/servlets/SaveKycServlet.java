package com.renteasy.servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/saveKyc")
@MultipartConfig
public class SaveKycServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            String username = request.getParameter("username");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String aadhaar = request.getParameter("aadhaar");
            String address = request.getParameter("address");

            // FILES
            Part photoPart = request.getPart("photo");
            Part docPart = request.getPart("document");

            String photoName = photoPart.getSubmittedFileName();
            String docName = docPart.getSubmittedFileName();

            String path = getServletContext().getRealPath("") + "uploads/";
            File dir = new File(path);
            if(!dir.exists()) dir.mkdirs();

            photoPart.write(path + photoName);
            docPart.write(path + docName);

            // DB CONNECTION
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/renteasy","root","123456");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO kyc(username, fullname, email, mobile, aadhaar, address, photo, document, status) VALUES(?,?,?,?,?,?,?,?,?)"
            );

            ps.setString(1, username);
            ps.setString(2, fullname);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, aadhaar);
            ps.setString(6, address);
            ps.setString(7, "uploads/" + photoName);
            ps.setString(8, "uploads/" + docName);
            ps.setString(9, "Pending");

            ps.executeUpdate();

            con.close();

            response.sendRedirect("profile.jsp?kyc=success");

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e);
        }
    }
}