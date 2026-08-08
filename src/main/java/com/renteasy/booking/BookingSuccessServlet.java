package com.renteasy.booking;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.renteasy.model.BookingDetails;

import java.sql.DriverManager;
import java.sql.Connection;

import jakarta.servlet.http.HttpSession;
@WebServlet("/BookingSuccessServlet")
public class BookingSuccessServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
	        HttpServletResponse response)
	        throws ServletException, IOException {

	    HttpSession session = request.getSession(false);

	    if (session == null || session.getAttribute("userId") == null) {
	        response.sendRedirect("login.jsp");
	        return;
	    }

	    String rentalId = request.getParameter("rentalId");

	    if (rentalId == null || rentalId.isEmpty()) {
	        response.sendRedirect("dashboard.jsp");
	        return;
	    }

	    try {

	    	Class.forName("com.mysql.cj.jdbc.Driver");

	    	Connection con = DriverManager.getConnection(
	    	        "jdbc:mysql://localhost:3306/renteasy",
	    	        "root",
	    	        "123456");

	        String sql =
	                "SELECT " +
	                "r.rental_id,r.pickup_otp,r.pickup_method,r.rental_months," +
	                "r.rent_amount,r.security_deposit,r.start_date,r.end_date," +
	                "r.payment_status,r.pickup_status," +

	                "pay.payment_id,pay.razorpay_payment_id,pay.razorpay_order_id,pay.total_amount," +

	                "pr.name,pr.image,pr.category,pr.location,pr.latitude,pr.longitude," +

	                "owner.first_name owner_first," +
	                "owner.last_name owner_last," +
	                "owner.phone owner_phone," +
	                "owner.email owner_email," +

	                "customer.first_name customer_first," +
	                "customer.last_name customer_last," +
	                "customer.phone customer_phone," +
	                "customer.email customer_email " +

	                "FROM rentals r " +

	                "JOIN payments pay ON r.rental_id=pay.rental_id " +

	                "JOIN products pr ON r.product_id=pr.id " +

	                "JOIN users owner ON owner.id=r.owner_id " +

	                "JOIN users customer ON customer.id=r.user_id " +

	                "WHERE r.rental_id=?";

	        PreparedStatement ps = con.prepareStatement(sql);

	        ps.setInt(1, Integer.parseInt(rentalId));

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            BookingDetails booking = new BookingDetails();

	            booking.setRentalId(rs.getInt("rental_id"));
	            booking.setPickupOtp(rs.getString("pickup_otp"));
	            booking.setPickupMethod(rs.getString("pickup_method"));
	            booking.setRentalMonths(rs.getInt("rental_months"));

	            booking.setRentAmount(rs.getDouble("rent_amount"));
	            booking.setSecurityDeposit(rs.getDouble("security_deposit"));

	            booking.setStartDate(rs.getString("start_date"));
	            booking.setEndDate(rs.getString("end_date"));

	            booking.setPaymentStatus(rs.getString("payment_status"));
	            booking.setPickupStatus(rs.getString("pickup_status"));

	            booking.setPaymentId(rs.getInt("payment_id"));
	            booking.setRazorpayPaymentId(rs.getString("razorpay_payment_id"));
	            booking.setRazorpayOrderId(rs.getString("razorpay_order_id"));
	            booking.setTotalAmount(rs.getDouble("total_amount"));

	            booking.setProductName(rs.getString("name"));
	            String image = rs.getString("image");
	            System.out.println("IMAGE FROM DB = " + image);

	            booking.setProductImage(image);
	            booking.setCategory(rs.getString("category"));

	            booking.setLocation(rs.getString("location"));
	            booking.setLatitude(rs.getDouble("latitude"));
	            booking.setLongitude(rs.getDouble("longitude"));

	            booking.setOwnerName(
	                    rs.getString("owner_first") + " " +
	                    rs.getString("owner_last"));

	            booking.setOwnerPhone(rs.getString("owner_phone"));
	            booking.setOwnerEmail(rs.getString("owner_email"));

	            booking.setCustomerName(
	                    rs.getString("customer_first") + " " +
	                    rs.getString("customer_last"));

	            booking.setCustomerPhone(rs.getString("customer_phone"));
	            booking.setCustomerEmail(rs.getString("customer_email"));

	            request.setAttribute("booking", booking);

	        }

	        rs.close();
	        ps.close();
	        con.close();

	        request.getRequestDispatcher("booking-success.jsp")
	                .forward(request, response);

	    }
	    catch (Exception e) {

	        e.printStackTrace();

	        response.sendRedirect("dashboard.jsp");

	    }

	} 
}