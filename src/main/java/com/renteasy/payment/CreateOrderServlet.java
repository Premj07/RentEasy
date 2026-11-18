package com.renteasy.payment;

import java.io.IOException;

import org.json.JSONObject;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

@WebServlet("/CreateOrderServlet")
public class CreateOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        
     // ======================================================
     // Read Booking Details
     // ======================================================

     String productId = request.getParameter("productId");
     String ownerId = request.getParameter("ownerId");
     String rentAmount = request.getParameter("rentAmount");
     String depositAmount = request.getParameter("depositAmount");
     String pickupMethod = request.getParameter("pickupMethod");
     String rentalMonths = request.getParameter("rentalMonths");

        try {

        	// ======================================================
        	// Save Booking Details in Session
        	// ======================================================

        	System.out.println("productId = " + productId);
        	System.out.println("ownerId = " + ownerId);
        	System.out.println("rentAmount = " + rentAmount);
        	System.out.println("depositAmount = " + depositAmount);
        	System.out.println("pickupMethod = " + pickupMethod);
        	System.out.println("rentalMonths = " + rentalMonths);
        	
        	HttpSession session = request.getSession();
        	
        	System.out.println("CREATE ORDER SESSION = " + session.getId());
        	System.out.println("userId = " + session.getAttribute("userId"));
        	System.out.println("email = " + session.getAttribute("email"));
        	
        	session.setAttribute("productId", productId);
        	session.setAttribute("ownerId", ownerId);
        	session.setAttribute("rentAmount", rentAmount);
        	session.setAttribute("depositAmount", depositAmount);
        	session.setAttribute("pickupMethod", pickupMethod);
        	session.setAttribute("rentalMonths", rentalMonths);
        	
        	String amountParam = request.getParameter("amount");

        	System.out.println("=================================");
        	System.out.println("RAZORPAY DEBUG");
        	System.out.println("Received amount = " + amountParam);

        	double totalAmount = Double.parseDouble(amountParam);

        	int amountInPaise = (int) Math.round(totalAmount * 100);

        	System.out.println("Total amount in rupees = ₹" + totalAmount);
        	System.out.println("Amount sent to Razorpay = " + amountInPaise + " paise");
        	System.out.println("=================================");

            // ======================================================
            // Create Razorpay Client
            // ======================================================

            RazorpayClient client =
                    RazorpayConfig.getClient();

            // ======================================================
            // Create Order
            // ======================================================

            JSONObject orderRequest = new JSONObject();

            orderRequest.put("amount", amountInPaise);

            orderRequest.put("currency", "INR");

            orderRequest.put("receipt",
                    "RENTEASY_" + System.currentTimeMillis());

            Order order =
                    client.orders.create(orderRequest);

            // ======================================================
            // Return JSON
            // ======================================================

            response.getWriter().print(order.toString());

        }

        catch (Exception e) {

            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().print(
                "{\"error\":\"Unable to create Razorpay Order\", " +
                "\"details\":\"" +
                e.getClass().getName() + ": " +
                e.getMessage() +
                "\"}"
            );
        }

    }

}