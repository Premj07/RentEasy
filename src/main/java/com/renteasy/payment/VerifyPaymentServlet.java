package com.renteasy.payment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.Calendar;
import java.util.Random;

import org.json.JSONObject;

import com.razorpay.Utils;
import com.renteasy.utils.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyPaymentServlet")
public class VerifyPaymentServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String paymentId = request.getParameter("payment_id");
        String orderId = request.getParameter("order_id");
        String signature = request.getParameter("signature");

        Connection con = null;

        try {

            JSONObject attributes = new JSONObject();

            attributes.put("razorpay_order_id", orderId);
            attributes.put("razorpay_payment_id", paymentId);
            attributes.put("razorpay_signature", signature);

            String secret = "6IyH9aojY21uwZhSl2uw2WdB";

            boolean paymentVerified =
                    Utils.verifyPaymentSignature(attributes, secret);

            if (!paymentVerified) {

                response.sendRedirect("payment-failed.jsp");
                return;
            }

            HttpSession session = request.getSession(false);
            
            System.out.println("SESSION ID = " + session.getId());
            System.out.println("userId = " + session.getAttribute("userId"));
            System.out.println("email = " + session.getAttribute("email"));
            System.out.println("firstName = " + session.getAttribute("firstName"));
            
            if (session == null) {

                response.sendRedirect("index.jsp");
                return;
            }

            Integer userId =
                    (Integer) session.getAttribute("userId");

            String userEmail =
                    (String) session.getAttribute("email");

            String userName =
                    (String) session.getAttribute("firstName");

            int productId =
                    Integer.parseInt(
                            session.getAttribute("productId").toString());

            int ownerId =
                    Integer.parseInt(
                            session.getAttribute("ownerId").toString());

            int rentAmount =
                    Integer.parseInt(
                            session.getAttribute("rentAmount").toString());

            int depositAmount =
                    (int) Double.parseDouble(
                            session.getAttribute("depositAmount").toString());

            int rentalMonths =
                    Integer.parseInt(
                            session.getAttribute("rentalMonths").toString());

            String pickupMethod =
                    session.getAttribute("pickupMethod").toString();

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            con.setAutoCommit(false);

            PreparedStatement productPs =
                    con.prepareStatement(
                            "SELECT * FROM products WHERE id=?");

            productPs.setInt(1, productId);

            ResultSet productRs =
                    productPs.executeQuery();

            if (!productRs.next()) {

                throw new Exception("Product not found.");
            }

            String productName =
                    productRs.getString("name");

            String ownerLocation =
                    productRs.getString("location");

            PreparedStatement ownerPs =
                    con.prepareStatement(
                            "SELECT * FROM users WHERE id=?");

            ownerPs.setInt(1, ownerId);

            ResultSet ownerRs =
                    ownerPs.executeQuery();

            if (!ownerRs.next()) {

                throw new Exception("Owner not found.");
            }

            String ownerEmail =
                    ownerRs.getString("email");

            String ownerPhone =
                    ownerRs.getString("phone");

            String ownerName =
                    ownerRs.getString("first_name") + " "
                  + ownerRs.getString("last_name");

            String pickupOtp =
                    String.valueOf(
                            100000 +
                            new Random().nextInt(900000));

            Date startDate =
                    new Date(System.currentTimeMillis());

            Calendar calendar =
                    Calendar.getInstance();

            calendar.setTime(startDate);
            calendar.add(Calendar.MONTH, rentalMonths);

            Date endDate =
                    new Date(calendar.getTimeInMillis());

// ==========================================================
// PART 1 END
// ==========================================================
            
         // ==========================================================
         // STEP 2 : CREATE RENTAL
         // ==========================================================

         PreparedStatement rentalPs =
                 con.prepareStatement(

                 "INSERT INTO rentals(" +
                 "product_id," +
                 "owner_id," +
                 "user_id," +
                 "pickup_method," +
                 "rental_months," +
                 "rent_amount," +
                 "security_deposit," +
                 "start_date," +
                 "end_date," +
                 "payment_status," +
                 "rental_status," +
                 "refund_status," +
                 "pickup_otp," +
                 "pickup_status" +
                 ") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",

                 PreparedStatement.RETURN_GENERATED_KEYS);

         rentalPs.setInt(1, productId);
         rentalPs.setInt(2, ownerId);
         rentalPs.setInt(3, userId);
         rentalPs.setString(4, pickupMethod);
         rentalPs.setInt(5, rentalMonths);
         rentalPs.setInt(6, rentAmount);
         rentalPs.setInt(7, depositAmount);
         rentalPs.setDate(8, startDate);
         rentalPs.setDate(9, endDate);

         rentalPs.setString(10, "PAID");
         rentalPs.setString(11, "ACTIVE");
         rentalPs.setString(12, "PENDING");

         rentalPs.setString(13, pickupOtp);
         rentalPs.setString(14, "WAITING_FOR_PICKUP");

         rentalPs.executeUpdate();

         // ==========================================================
         // GET GENERATED RENTAL ID
         // ==========================================================

         int rentalId = 0;

         ResultSet rentalKeys =
                 rentalPs.getGeneratedKeys();

         if (rentalKeys.next()) {

             rentalId = rentalKeys.getInt(1);

         } else {

             throw new Exception("Unable to create rental.");

         }
      // ==========================================================
      // STEP 3 : SAVE PAYMENT
      // ==========================================================

      PreparedStatement paymentPs =
              con.prepareStatement(

              "INSERT INTO payments(" +
              "razorpay_payment_id," +
              "razorpay_order_id," +
              "user_id," +
              "product_id," +
              "owner_id," +
              "rent_amount," +
              "deposit_amount," +
              "total_amount," +
              "payment_status," +
              "payment_date," +
              "rental_id" +
              ") VALUES(?,?,?,?,?,?,?,?,?,?,?)");

      paymentPs.setString(1, paymentId);
      paymentPs.setString(2, orderId);

      paymentPs.setInt(3, userId);
      paymentPs.setInt(4, productId);
      paymentPs.setInt(5, ownerId);

      paymentPs.setInt(6, rentAmount);
      paymentPs.setInt(7, depositAmount);
      paymentPs.setInt(8, rentAmount + depositAmount);

      paymentPs.setString(9, "SUCCESS");
      paymentPs.setTimestamp(
              10,
              new java.sql.Timestamp(
                      System.currentTimeMillis()));

      paymentPs.setInt(11, rentalId);

      paymentPs.executeUpdate();
   // ==========================================================
   // STEP 4 : UPDATE PRODUCT AVAILABILITY
   // ==========================================================

   PreparedStatement updateProductPs =
           con.prepareStatement(

           "UPDATE products " +
           "SET availability=? " +
           "WHERE id=?");

   updateProductPs.setString(1, "RENTED");
   updateProductPs.setInt(2, productId);

   int updatedRows =
           updateProductPs.executeUpdate();

   if (updatedRows == 0) {

       throw new Exception(
               "Failed to update product availability.");

   }
// ==========================================================
// STEP 5A : EMAIL TO RENTER
// ==========================================================

EmailUtility.sendBookingConfirmation(

        userEmail,
        productName,
        ownerName,
        ownerPhone,
        ownerLocation,
        pickupOtp
);
//==========================================================
//GET RENTER PHONE
//==========================================================

String userPhone = "";

PreparedStatement userPs =
     con.prepareStatement(
             "SELECT phone FROM users WHERE id=?");

userPs.setInt(1, userId);

ResultSet userRs = userPs.executeQuery();

if (userRs.next()) {

 userPhone = userRs.getString("phone");

}
//==========================================================
//EMAIL TO OWNER
//==========================================================

EmailUtility.sendOwnerBookingNotification(

     ownerEmail,
     ownerName,
     userName,
     userEmail,
     userPhone,
     productName,
     pickupOtp
);       // ==========================================================
//STEP 6 : COMMIT & REDIRECT
//==========================================================

con.commit();

response.sendRedirect("BookingSuccessServlet?rentalId=" + rentalId);

}

catch (Exception e) {

 e.printStackTrace();

 if (con != null) {

     try {

         con.rollback();

     } catch (Exception ex) {

         ex.printStackTrace();

     }

 }

 response.sendRedirect("payment.jsp");

}

finally {

 if (con != null) {

     try {

         con.close();

     } catch (Exception e) {

         e.printStackTrace();

     }

 }

}

}

}