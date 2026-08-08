package com.renteasy.servlets;

import java.io.IOException;

import com.renteasy.dao.PaymentDAO;
import com.renteasy.model.PaymentReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OwnerPaymentReleaseServlet")
public class OwnerPaymentReleaseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {

        paymentDAO = new PaymentDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
    	
    	 HttpSession session = request.getSession(false);
 
    	 if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {

    		    response.sendRedirect("index.jsp");
    		    return;
    		}


        try {

            // =====================================================
            // GET PAYMENT ID
            // =====================================================

            int paymentId =
                    Integer.parseInt(request.getParameter("paymentId"));

            // =====================================================
            // LOAD PAYMENT DETAILS
            // =====================================================

            PaymentReport payment =
                    paymentDAO.getPaymentById(paymentId);

            if (payment == null) {

                session.setAttribute(
                        "error",
                        "Payment record not found.");

                response.sendRedirect("AdminPaymentsServlet");
                return;

            }

            // =====================================================
            // SEND DATA TO JSP
            // =====================================================

            request.setAttribute("payment", payment);

            request.getRequestDispatcher("ownerPaymentRelease.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "error",
                    "Unable to load payment details.");

            response.sendRedirect("AdminPaymentsServlet");

        }

    }

}