package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    // Show the registration form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    // Process the form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        User user = new User();
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));

        if (userDAO.registerUser(user)) {
            // Success: Redirect back to rooms with a success flag
            response.sendRedirect(request.getContextPath() + "/rooms?status=success");
        } else {
            // Failure: Reload form with error message
            request.setAttribute("error", "Could not create account. Email may already exist.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}