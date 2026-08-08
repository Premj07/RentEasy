package com.renteasy.servlets;

import java.io.IOException;
import java.util.List;

import com.renteasy.dao.BankDetailsDAO;
import com.renteasy.dao.OwnerPayoutDAO;

import com.renteasy.model.BankDetails;
import com.renteasy.model.OwnerPayout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/OwnerPaymentsServlet")
public class OwnerPaymentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OwnerPayoutDAO payoutDAO;
    private BankDetailsDAO bankDetailsDAO;

    @Override
    public void init() throws ServletException {

        payoutDAO = new OwnerPayoutDAO();
        bankDetailsDAO = new BankDetailsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // =====================================================
        // LOGIN SECURITY CHECK
        // =====================================================

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            // =====================================================
            // GET LOGGED-IN OWNER ID
            // =====================================================

            int ownerId = Integer.parseInt(
                    session.getAttribute("userId").toString()
            );

            System.out.println("================================");
            System.out.println("OWNER PAYMENTS PAGE");
            System.out.println("Logged Owner ID = " + ownerId);
            System.out.println("================================");


            // =====================================================
            // LOAD OWNER PAYOUT HISTORY
            // =====================================================

            List<OwnerPayout> payoutList =
                    payoutDAO.getOwnerPayoutHistory(ownerId);

            System.out.println(
                    "Payout records found = " + payoutList.size()
            );


            // =====================================================
            // LOAD OWNER BANK DETAILS
            // =====================================================

            BankDetails bankDetails =
                    bankDetailsDAO.getBankDetailsByUserId(ownerId);

            if (bankDetails != null) {

                System.out.println(
                        "Bank details found for Owner ID = "
                        + ownerId
                );

            } else {

                System.out.println(
                        "No bank details found for Owner ID = "
                        + ownerId
                );
            }


            // =====================================================
            // SEND DATA TO JSP
            // =====================================================

            request.setAttribute(
                    "payoutList",
                    payoutList
            );

            request.setAttribute(
                    "bankDetails",
                    bankDetails
            );


            // =====================================================
            // OPEN OWNER PAYMENTS PAGE
            // =====================================================

            request.getRequestDispatcher("ownerpayments.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            System.out.println(
                    "ERROR LOADING OWNER PAYMENTS"
            );

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load owner payment information."
            );

            request.getRequestDispatcher("ownerpayments.jsp")
                   .forward(request, response);
        }
    }
}