package com.renteasy.servlets;

import java.io.IOException;

import com.renteasy.dao.OwnerPayoutDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReleaseOwnerPaymentServlet")
public class ReleaseOwnerPaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =====================================================
    // RELEASE OWNER PAYMENT
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

            int payoutId = Integer.parseInt(
                    request.getParameter("payoutId"));

            String reference =
                    request.getParameter("transactionReference");

            String remarks =
                    request.getParameter("remarks");

            // =====================================================
            // GET ADMIN ID
            // =====================================================

            int adminId = Integer.parseInt(
                    session.getAttribute("userId").toString());

            // =====================================================
            // RELEASE PAYMENT
            // =====================================================

            OwnerPayoutDAO dao = new OwnerPayoutDAO();

            boolean success =
                    dao.releaseOwnerPayment(
                            payoutId,
                            adminId,
                            reference,
                            remarks
                    );

            // =====================================================
            // RESPONSE
            // =====================================================

            if (success) {

                session.setAttribute(
                        "success",
                        "Owner payout released successfully."
                );

            } else {

                session.setAttribute(
                        "error",
                        "Unable to release owner payout."
                );

            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "error",
                    "Something went wrong while releasing payment."
            );

        }

        response.sendRedirect("AdminPaymentsServlet");

    }

}