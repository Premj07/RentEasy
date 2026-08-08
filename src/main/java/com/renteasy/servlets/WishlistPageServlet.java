package com.renteasy.servlets;

import java.io.IOException;
import java.sql.ResultSet;

import com.renteasy.dao.WishlistDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/WishlistPageServlet")
public class WishlistPageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            int userId = Integer.parseInt(
                session.getAttribute("userId").toString()
            );

            ResultSet wishlist =
                wishlistDAO.getWishlistProducts(userId);

            request.setAttribute("wishlist", wishlist);

            request.getRequestDispatcher("wishlist.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}