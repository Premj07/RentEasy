package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PurchaseProductServlet")
public class PurchaseProductServlet_Backup extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if(session == null ||
           session.getAttribute("user") == null){

            response.sendRedirect("index.jsp");
            return;
        }

        String username =
                (String)session.getAttribute("user");

        Connection con = null;

        try{

            int productId =
                    Integer.parseInt(
                    request.getParameter("productId"));

            String deliveryName =
                    request.getParameter("deliveryName");

            String deliveryPhone =
                    request.getParameter("deliveryPhone");

            String deliveryAddress =
                    request.getParameter("deliveryAddress");

            String deliveryPincode =
                    request.getParameter("deliveryPincode");

            String paymentMethod =
                    request.getParameter("paymentMethod");

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");

            con =
            DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456");

            con.setAutoCommit(false);


            /* GET BUYER */

            PreparedStatement userPs =
            con.prepareStatement(

            "SELECT id,name FROM users " +
            "WHERE username=?"

            );

            userPs.setString(
                    1,
                    username);

            ResultSet userRs =
                    userPs.executeQuery();

            if(!userRs.next()){

                throw new Exception(
                        "Buyer not found");

            }

            int buyerId =
                    userRs.getInt("id");

            String buyerName =
                    userRs.getString("name");


            /* GET PRODUCT */

            PreparedStatement productPs =
            con.prepareStatement(

            "SELECT * FROM products " +
            "WHERE id=? FOR UPDATE"

            );

            productPs.setInt(
                    1,
                    productId);

            ResultSet productRs =
                    productPs.executeQuery();

            if(!productRs.next()){

                throw new Exception(
                        "Product not found");

            }

            String productName =
                    productRs.getString("name");

            String ownerName =
                    productRs.getString("owner");

            String listingType =
                    productRs.getString("listing_type");

            String productStatus =
                    productRs.getString("status");

            double actualPrice =
                    productRs.getDouble(
                            "actual_price");

            double sellingPrice =
                    productRs.getDouble(
                            "selling_price");


            /* CHECK PRODUCT */

            if(!"SELL".equalsIgnoreCase(listingType)
            &&
            !"BOTH".equalsIgnoreCase(listingType)){

                throw new Exception(
                        "This product is not available for purchase");

            }

            if("SOLD".equalsIgnoreCase(productStatus)){

                throw new Exception(
                        "Product already sold");

            }


            /* INSERT PURCHASE */

            PreparedStatement purchasePs =
            con.prepareStatement(

            "INSERT INTO purchase_orders(" +

            "product_id," +
            "buyer_id," +
            "owner_name," +
            "actual_price," +
            "selling_price," +
            "delivery_name," +
            "delivery_phone," +
            "delivery_address," +
            "delivery_pincode," +
            "payment_method," +
            "payment_status," +
            "order_status" +

            ") VALUES(" +
            "?,?,?,?,?,?,?,?,?,?,?,?)"

            );

            purchasePs.setInt(
                    1,
                    productId);

            purchasePs.setInt(
                    2,
                    buyerId);

            purchasePs.setString(
                    3,
                    ownerName);

            purchasePs.setDouble(
                    4,
                    actualPrice);

            purchasePs.setDouble(
                    5,
                    sellingPrice);

            purchasePs.setString(
                    6,
                    deliveryName);

            purchasePs.setString(
                    7,
                    deliveryPhone);

            purchasePs.setString(
                    8,
                    deliveryAddress);

            purchasePs.setString(
                    9,
                    deliveryPincode);

            purchasePs.setString(
                    10,
                    paymentMethod);

            if("COD".equalsIgnoreCase(paymentMethod)){

                purchasePs.setString(
                        11,
                        "PENDING");

            }else{

                purchasePs.setString(
                        11,
                        "PAID");

            }

            purchasePs.setString(
                    12,
                    "ORDER_PLACED");

            purchasePs.executeUpdate();


            /* PRODUCT SOLD */

            PreparedStatement soldPs =
            con.prepareStatement(

            "UPDATE products " +
            "SET status='SOLD' " +
            "WHERE id=?"

            );

            soldPs.setInt(
                    1,
                    productId);

            soldPs.executeUpdate();


            /* OWNER NOTIFICATION */

            PreparedStatement ownerPs =
            con.prepareStatement(

            "SELECT id FROM users " +
            "WHERE username=? OR name=? " +
            "LIMIT 1"

            );

            ownerPs.setString(
                    1,
                    ownerName);

            ownerPs.setString(
                    2,
                    ownerName);

            ResultSet ownerRs =
                    ownerPs.executeQuery();

            if(ownerRs.next()){

                int ownerId =
                        ownerRs.getInt("id");

                PreparedStatement notificationPs =
                con.prepareStatement(

                		"INSERT INTO notifications(username,message) VALUES(?,?)");

               

                notificationPs.setString(
                        1,
                        username);

                notificationPs.setString(
                        2,

                        buyerName +
                        " has purchased your " +
                        productName +
                        ". Please be ready with your product."
                );

                notificationPs.executeUpdate();

            }


            /* USER NOTIFICATION */

            PreparedStatement buyerNotification =
            con.prepareStatement(

            		"INSERT INTO notifications(username,message) VALUES(?,?)");

            buyerNotification.setString(
                    1,
                    username);

            buyerNotification.setString(
                    2,

                    "Your order for " +
                    productName +
                    " has been placed successfully."
            );

            buyerNotification.executeUpdate();


            con.commit();

            response.sendRedirect(
                    "purchaseSuccess.jsp?id=" +
                    productId);


        }catch(Exception e){

            try{

                if(con != null){

                    con.rollback();

                }

            }catch(Exception ignored){}

            e.printStackTrace();

            response.getWriter()
                    .println(
                    "Purchase Error: " +
                    e.getMessage());

        }finally{

            try{

                if(con != null){

                    con.close();

                }

            }catch(Exception ignored){}

        }

    }

}