package com.renteasy.servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/switchMode")
public class SwitchModeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");

        if ("owner".equals(mode)) {
            res.sendRedirect("ownerDashboard.jsp");
        } else {
            res.sendRedirect("dashboard.jsp");
        }
    }
}