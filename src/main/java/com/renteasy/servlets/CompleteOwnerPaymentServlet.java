package com.renteasy.servlets;

import java.io.IOException;

import com.renteasy.dao.OwnerPayoutDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CompleteOwnerPaymentServlet")
public class CompleteOwnerPaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =====================================================
    // COMPLETE OWNER PAYMENT RELEASE
    // =====================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // =====================================================
        // ADMIN LOGIN CHECK
        // =====================================================

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            // =====================================================
            // GET FORM DATA
            // =====================================================

            int paymentId = Integer.parseInt(
                    request.getParameter("paymentId"));

            int ownerId = Integer.parseInt(
                    request.getParameter("ownerId"));

            String transactionReference =
                    request.getParameter("transactionReference");

            String remarks =
                    request.getParameter("remarks");

         // =====================================================
         // GET ADMIN ID
         // =====================================================

         int adminId = 1;   // Temporary admin ID for testing

            // =====================================================
            // DAO
            // =====================================================

            OwnerPayoutDAO dao = new OwnerPayoutDAO();

            boolean success = dao.completeOwnerPayment(
                    paymentId,
                    ownerId,
                    adminId,
                    transactionReference,
                    remarks
            );

            if (success) {

                session.setAttribute(
                        "success",
                        "Owner payment released successfully.");

            } else {

                session.setAttribute(
                        "error",
                        "Unable to release owner payment.");

            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "error",
                    "Something went wrong while releasing payment.");

        }

        response.sendRedirect("AdminPaymentsServlet");

    }

}