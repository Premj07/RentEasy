package com.renteasy.servlets;

import com.renteasy.ai.SmartSearchAI;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/SmartSearchServlet")
public class SmartSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // STEP 1 : GET SEARCH QUERY
        // ==========================================

        String query = request.getParameter("query");

        if (query == null) {
            query = "";
        }

        query = query.trim();

        // Keep query available for searchResults.jsp
        request.setAttribute("searchQuery", query);


        // ==========================================
        // STEP 2 : GET LOGGED-IN USER
        // ==========================================

        Integer userId =
                (Integer) request.getSession().getAttribute("userId");


        // ==========================================
        // STEP 3 : AI PARSE SEARCH
        // ==========================================

        Map<String, String> ai = SmartSearchAI.parse(query);

        String product = ai.get("product");
        String budget = ai.get("budget");
        String location = ai.get("location");


        // ==========================================
        // STEP 4 : PRODUCT RESULT LIST
        // ==========================================

        ArrayList<HashMap<String, Object>> products =
                new ArrayList<>();


        // ==========================================
        // STEP 5 : DATABASE CONNECTION
        // ==========================================

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/renteasy",
                    "root",
                    "123456")) {


                // ==========================================
                // STEP 6 : SAVE REAL AI SEARCH HISTORY
                // ==========================================
                //
                // IMPORTANT:
                // This has its OWN try/catch.
                //
                // If history saving fails,
                // Smart Search will STILL work.
                // ==========================================

                if (userId != null && !query.isEmpty()) {

                    try {

                        String historySql =
                                "INSERT INTO ai_search_history " +
                                "(user_id, search_query) " +
                                "VALUES (?, ?)";

                        try (PreparedStatement historyPs =
                                     con.prepareStatement(historySql)) {

                            historyPs.setInt(1, userId);
                            historyPs.setString(2, query);

                            historyPs.executeUpdate();
                        }

                    } catch (Exception historyException) {

                        System.out.println(
                                "AI Search History could not be saved:"
                        );

                        historyException.printStackTrace();

                        // DO NOT stop Smart Search here.
                    }
                }


                // ==========================================
                // STEP 7 : BUILD SMART PRODUCT QUERY
                // ==========================================

                StringBuilder sql = new StringBuilder();

                sql.append("SELECT * FROM products ");
                sql.append("WHERE status='approved' ");
                sql.append("AND availability='AVAILABLE' ");


                if (product != null && !product.trim().isEmpty()) {

                    sql.append("AND name LIKE ? ");
                }


                if (budget != null && !budget.trim().isEmpty()) {

                    sql.append("AND price <= ? ");
                }


                if (location != null && !location.trim().isEmpty()) {

                    sql.append("AND location LIKE ? ");
                }


                // ==========================================
                // STEP 8 : PREPARE SQL
                // ==========================================

                try (PreparedStatement ps =
                             con.prepareStatement(sql.toString())) {

                    int index = 1;


                    // Product
                    if (product != null &&
                            !product.trim().isEmpty()) {

                        ps.setString(
                                index++,
                                "%" + product.trim() + "%"
                        );
                    }


                    // Budget
                    if (budget != null &&
                            !budget.trim().isEmpty()) {

                        try {

                            ps.setInt(
                                    index++,
                                    Integer.parseInt(budget.trim())
                            );

                        } catch (NumberFormatException ex) {

                            System.out.println(
                                    "Invalid budget detected: " + budget
                            );

                            ps.setInt(index++, Integer.MAX_VALUE);
                        }
                    }


                    // Location
                    if (location != null &&
                            !location.trim().isEmpty()) {

                        ps.setString(
                                index++,
                                "%" + location.trim() + "%"
                        );
                    }


                    // ==========================================
                    // STEP 9 : EXECUTE SEARCH
                    // ==========================================

                    try (ResultSet rs = ps.executeQuery()) {

                        while (rs.next()) {

                            HashMap<String, Object> row =
                                    new HashMap<>();

                            row.put(
                                    "id",
                                    rs.getInt("id")
                            );

                            row.put(
                                    "name",
                                    rs.getString("name")
                            );

                            row.put(
                                    "price",
                                    rs.getInt("price")
                            );

                            row.put(
                                    "image",
                                    rs.getString("image")
                            );

                            row.put(
                                    "location",
                                    rs.getString("location")
                            );

                            row.put(
                                    "category",
                                    rs.getString("category")
                            );

                            products.add(row);
                        }
                    }
                }
            }


            // ==========================================
            // STEP 10 : SEND DATA TO JSP
            // ==========================================

            request.setAttribute(
                    "products",
                    products
            );


            // ==========================================
            // STEP 11 : OPEN SEARCH RESULTS PAGE
            // ==========================================

            request.getRequestDispatcher(
                    "/searchResults.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            // ==========================================
            // IMPORTANT ERROR HANDLING
            // ==========================================

            System.out.println(
                    "ERROR INSIDE SmartSearchServlet"
            );

            e.printStackTrace();

            // Don't leave browser as blank white screen.
            throw new ServletException(
                    "Smart Search failed.",
                    e
            );
        }
    }
}