package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SaveBankDetailsServlet")
public class SaveBankDetailsServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request,
	        HttpServletResponse response)
	        throws IOException {

	    String method = request.getParameter("method");

	    String accountHolder = request.getParameter("account_holder");
	    String bankName = request.getParameter("bank_name");
	    String accountNumber = request.getParameter("account_number");
	    String ifsc = request.getParameter("ifsc");

	    HttpSession session = request.getSession();

	    String username = (String) session.getAttribute("user");

	    try {

	        Class.forName("com.mysql.cj.jdbc.Driver");

	        Connection con = DriverManager.getConnection(
	                "jdbc:mysql://localhost:3306/renteasy",
	                "root",
	                "123456");

	        // Get logged-in user's ID
	        PreparedStatement ps1 = con.prepareStatement(
	                "SELECT id FROM users WHERE username=?");

	        ps1.setString(1, username);

	        ResultSet rs = ps1.executeQuery();

	        int userId = 0;

	        if (rs.next()) {
	            userId = rs.getInt("id");
	        }

	        // Save bank details
	        PreparedStatement ps2 = con.prepareStatement(
	                "INSERT INTO bank_details(user_id,method,account_holder,bank_name,account_number,ifsc_code) VALUES(?,?,?,?,?,?)");

	        ps2.setInt(1, userId);
	        ps2.setString(2, method);
	        ps2.setString(3, accountHolder);
	        ps2.setString(4, bankName);
	        ps2.setString(5, accountNumber);
	        ps2.setString(6, ifsc);

	        ps2.executeUpdate();

	        response.sendRedirect("profile.jsp?msg=Bank Details Saved");

	        con.close();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	} }