package com.renteasy.servlets;

import com.renteasy.dao.RecommendationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.ResultSet;

@WebServlet("/RecommendationServlet")
public class RecommendationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        RecommendationDAO dao = new RecommendationDAO();

        ResultSet rs = dao.getRecommendedProducts(userId);

        request.setAttribute("recommendedProducts", rs);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);

    }
}