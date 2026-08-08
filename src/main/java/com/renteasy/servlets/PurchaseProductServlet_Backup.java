package com.renteasy.servlets;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PurchaseProductServlet")
public class PurchaseProductServlet_Backup extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        String username =
                (String) session.getAttribute("user");

        Connection con = null;

        try {

            /* =========================================
               GET FORM DATA
               ========================================= */

            int productId =
                    Integer.parseInt(
                            request.getParameter("productId")
                    );

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


            /* =========================================
               DATABASE CONNECTION
               ========================================= */

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456"
            );

            con.setAutoCommit(false);


            /* =========================================
               GET BUYER
               ========================================= */

            PreparedStatement userPs =
                    con.prepareStatement(
                            "SELECT id, name " +
                            "FROM users " +
                            "WHERE username=?"
                    );

            userPs.setString(1, username);

            ResultSet userRs =
                    userPs.executeQuery();

            if (!userRs.next()) {

                throw new Exception(
                        "Buyer not found"
                );
            }

            int buyerId =
                    userRs.getInt("id");

            String buyerName =
                    userRs.getString("name");


            /* =========================================
               GET PRODUCT
               ========================================= */

            PreparedStatement productPs =
                    con.prepareStatement(
                            "SELECT * FROM products " +
                            "WHERE id=? FOR UPDATE"
                    );

            productPs.setInt(1, productId);

            ResultSet productRs =
                    productPs.executeQuery();

            if (!productRs.next()) {

                throw new Exception(
                        "Product not found"
                );
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
                    productRs.getDouble("actual_price");

            double sellingPrice =
                    productRs.getDouble("selling_price");


            /* =========================================
               CHECK PRODUCT CAN BE PURCHASED
               ========================================= */

            if (!"SELL".equalsIgnoreCase(listingType)
                    &&
                    !"BOTH".equalsIgnoreCase(listingType)) {

                throw new Exception(
                        "This product is not available for purchase"
                );
            }

            if ("SOLD".equalsIgnoreCase(productStatus)) {

                throw new Exception(
                        "Product already sold"
                );
            }


            /* =========================================
               INSERT PURCHASE ORDER
               ========================================= */

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
                            "?,?,?,?,?,?,?,?,?,?,?,?)",

                            Statement.RETURN_GENERATED_KEYS
                    );


            purchasePs.setInt(
                    1,
                    productId
            );

            purchasePs.setInt(
                    2,
                    buyerId
            );

            purchasePs.setString(
                    3,
                    ownerName
            );

            purchasePs.setDouble(
                    4,
                    actualPrice
            );

            purchasePs.setDouble(
                    5,
                    sellingPrice
            );

            purchasePs.setString(
                    6,
                    deliveryName
            );

            purchasePs.setString(
                    7,
                    deliveryPhone
            );

            purchasePs.setString(
                    8,
                    deliveryAddress
            );

            purchasePs.setString(
                    9,
                    deliveryPincode
            );

            purchasePs.setString(
                    10,
                    paymentMethod
            );


            /* PAYMENT STATUS */

            if ("COD".equalsIgnoreCase(paymentMethod)) {

                purchasePs.setString(
                        11,
                        "PENDING"
                );

            } else {

                purchasePs.setString(
                        11,
                        "PAID"
                );
            }


            purchasePs.setString(
                    12,
                    "ORDER_PLACED"
            );

            purchasePs.executeUpdate();


            /* =========================================
               GET GENERATED PURCHASE ID
               ========================================= */

            int purchaseId;

            ResultSet generatedKeys =
                    purchasePs.getGeneratedKeys();

            if (generatedKeys.next()) {

                purchaseId =
                        generatedKeys.getInt(1);

            } else {

                throw new Exception(
                        "Purchase ID could not be generated"
                );
            }


            /* =========================================
               FIND PRODUCT OWNER USER ID
               ========================================= */

            PreparedStatement payoutOwnerPs =
                    con.prepareStatement(

                            "SELECT id FROM users " +
                            "WHERE username=? OR name=? " +
                            "LIMIT 1"
                    );

            payoutOwnerPs.setString(
                    1,
                    ownerName
            );

            payoutOwnerPs.setString(
                    2,
                    ownerName
            );

            ResultSet payoutOwnerRs =
                    payoutOwnerPs.executeQuery();

            if (!payoutOwnerRs.next()) {

                throw new Exception(
                        "Product owner account not found"
                );
            }

            int payoutOwnerId =
                    payoutOwnerRs.getInt("id");


            /* =========================================
               CALCULATE PURCHASE PAYOUT
               ========================================= */

            double commissionPercent = 10.0;

            double commissionAmount =
                    sellingPrice *
                    commissionPercent / 100.0;

            double ownerAmount =
                    sellingPrice -
                    commissionAmount;


            /* =========================================
               CREATE PENDING OWNER PAYOUT
               ========================================= */

            PreparedStatement payoutPs =
                    con.prepareStatement(

                            "INSERT INTO owner_payouts(" +

                            "transaction_type," +
                            "rental_id," +
                            "purchase_id," +
                            "payment_id," +
                            "owner_id," +
                            "user_id," +
                            "rent_amount," +
                            "commission_percent," +
                            "commission_amount," +
                            "owner_amount," +
                            "payout_status" +

                            ") VALUES(" +
                            "?,?,?,?,?,?,?,?,?,?,?)"
                    );


            /* 1 - Purchase transaction */

            payoutPs.setString(
                    1,
                    "PURCHASE"
            );


            /* 2 - No rental for purchase */

            payoutPs.setNull(
                    2,
                    Types.INTEGER
            );


            /* 3 - Purchase ID */

            payoutPs.setInt(
                    3,
                    purchaseId
            );


            /* 4 - No rental payment ID */

            payoutPs.setNull(
                    4,
                    Types.INTEGER
            );


            /* 5 - Owner ID */

            payoutPs.setInt(
                    5,
                    payoutOwnerId
            );


            /* 6 - Buyer ID */

            payoutPs.setInt(
                    6,
                    buyerId
            );


            /*
             * Existing column name is rent_amount.
             * For PURCHASE we store selling price here.
             */

            payoutPs.setDouble(
                    7,
                    sellingPrice
            );


            /* 8 - Commission percentage */

            payoutPs.setDouble(
                    8,
                    commissionPercent
            );


            /* 9 - Commission amount */

            payoutPs.setDouble(
                    9,
                    commissionAmount
            );


            /* 10 - Amount owner will receive */

            payoutPs.setDouble(
                    10,
                    ownerAmount
            );


            /* 11 - Admin has not released payment yet */

            payoutPs.setString(
                    11,
                    "Pending"
            );


            payoutPs.executeUpdate();


            /* =========================================
               MARK PRODUCT SOLD
               ========================================= */

            PreparedStatement soldPs =
                    con.prepareStatement(

                            "UPDATE products " +
                            "SET status='SOLD' " +
                            "WHERE id=?"
                    );

            soldPs.setInt(
                    1,
                    productId
            );

            soldPs.executeUpdate();


            /* =========================================
               OWNER NOTIFICATION
               ========================================= */

            PreparedStatement notificationPs =
                    con.prepareStatement(

                            "INSERT INTO notifications(" +
                            "username,message" +
                            ") VALUES(?,?)"
                    );


            notificationPs.setString(
                    1,
                    ownerName
            );

            notificationPs.setString(
                    2,

                    buyerName +
                    " has purchased your " +
                    productName +
                    ". Please be ready with your product."
            );

            notificationPs.executeUpdate();


            /* =========================================
               BUYER NOTIFICATION
               ========================================= */

            PreparedStatement buyerNotification =
                    con.prepareStatement(

                            "INSERT INTO notifications(" +
                            "username,message" +
                            ") VALUES(?,?)"
                    );

            buyerNotification.setString(
                    1,
                    username
            );

            buyerNotification.setString(
                    2,

                    "Your order for " +
                    productName +
                    " has been placed successfully."
            );

            buyerNotification.executeUpdate();


            /* =========================================
               COMMIT EVERYTHING
               ========================================= */

            con.commit();


            /* =========================================
               CLOSE RESOURCES
               ========================================= */

            buyerNotification.close();

            notificationPs.close();

            soldPs.close();

            payoutPs.close();

            payoutOwnerRs.close();
            payoutOwnerPs.close();

            generatedKeys.close();
            purchasePs.close();

            productRs.close();
            productPs.close();

            userRs.close();
            userPs.close();


            /* =========================================
               REDIRECT SUCCESS PAGE
               ========================================= */

            response.sendRedirect(
                    "purchaseSuccess.jsp?id=" +
                    productId
            );


        } catch (Exception e) {

            /* =========================================
               ROLLBACK IF ANYTHING FAILS
               ========================================= */

            try {

                if (con != null) {

                    con.rollback();
                }

            } catch (Exception ignored) {
            }

            e.printStackTrace();

            response.setContentType("text/plain");

            response.getWriter().println(
                    "Purchase Error: " +
                    e.getMessage()
            );


        } finally {

            try {

                if (con != null) {

                    con.close();
                }

            } catch (Exception ignored) {
            }
        }
    }
}