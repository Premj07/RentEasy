package com.renteasy.servlets;

import java.io.IOException;

import com.renteasy.dao.WishlistDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.renteasy.dao.UserInteractionDAO;

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session =
                request.getSession(false);


        if(session == null ||
           session.getAttribute("userId") == null){

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write("LOGIN_REQUIRED");

            return;
        }


        try {

            int userId =
                (Integer) session.getAttribute("userId");


            int productId =
                Integer.parseInt(
                    request.getParameter("productId")
                );


            String action =
                request.getParameter("action");


            WishlistDAO dao =
                new WishlistDAO();


            boolean success = false;


            if ("add".equalsIgnoreCase(action)) {

                success = dao.addToWishlist(userId, productId);

                // ==========================================
                // RECORD INTERACTION FOR AI RECOMMENDATION
                // ==========================================
                if (success) {

                    UserInteractionDAO interactionDAO =
                            new UserInteractionDAO();

                    interactionDAO.recordInteraction(
                            userId,
                            productId,
                            "WISHLIST"
                    );
                }
            }

            else if("remove".equalsIgnoreCase(action)){

                success =
                    dao.removeFromWishlist(
                        userId,
                        productId
                    );

            }


            response.setContentType(
                "text/plain;charset=UTF-8"
            );


            if(success){

                response.getWriter().write("SUCCESS");

            }
            else{

                response.getWriter().write("NO_CHANGE");

            }


            String redirect = request.getParameter("redirect");

            if ("category".equals(redirect)) {

                String category = request.getParameter("category");

                response.sendRedirect(
                    request.getContextPath()
                    + "/CategoryProductsServlet?category="
                    + java.net.URLEncoder.encode(
                        category,
                        java.nio.charset.StandardCharsets.UTF_8
                    )
                );

                return;
            } }
        catch(Exception e){

            e.printStackTrace();

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write("ERROR");

        }

    }

}