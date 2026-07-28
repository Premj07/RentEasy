package com.renteasy.servlets;

import java.io.IOException;

import com.renteasy.utils.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/testEmail")
public class TestEmailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            EmailUtility.sendSignupOTP(
                "premjadhao31@gmail.com",
                "123456"
            );

            response.getWriter().println("Email Sent Successfully!");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}