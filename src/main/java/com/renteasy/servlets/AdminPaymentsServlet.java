package com.renteasy.servlets;

import java.io.IOException;
import java.util.List;

import com.renteasy.dao.PaymentDAO;
import com.renteasy.model.PaymentReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminPaymentsServlet")
public class AdminPaymentsServlet extends HttpServlet {

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

        try {

            // Calculate Commission and Owner Share
            paymentDAO.updateCommissionAndOwnerAmount();

            // Load all payments
            List<PaymentReport> paymentList =
                    paymentDAO.getAllPayments();

            // Send data to JSP
            request.setAttribute("paymentList", paymentList);

            request.getRequestDispatcher("adminpayments.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load payment records."
            );

            request.getRequestDispatcher("adminpayments.jsp")
                   .forward(request, response);

        }

    }
}