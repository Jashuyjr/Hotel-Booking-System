package com.hotel.servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to the contact.jsp view
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Here you would typically handle saving the message to a database
        request.setAttribute("successMessage", "Thank you! Your message has been received.");
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }
}