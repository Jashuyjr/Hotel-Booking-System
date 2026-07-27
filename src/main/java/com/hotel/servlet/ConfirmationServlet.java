package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.model.Booking;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ConfirmationServlet.java
 * ============================================================
 * Handles GET /confirmation?bookingId=X
 * Fetches booking details and forwards to confirmation.jsp
 * ============================================================
 */
@WebServlet("/confirmation")
public class ConfirmationServlet extends HttpServlet {

    private static final long serialVersionUID = 3L;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
    }

    /**
     * doGet() — Serves the Booking Confirmation Page
     * Reads bookingId from query string, fetches booking (with joined room data),
     * and forwards to confirmation.jsp for display.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");

        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking == null) {
                request.setAttribute("errorMessage", "Booking not found.");
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/error.jsp");
                rd.forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/confirmation.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }

    @Override
    public void destroy() {
        bookingDAO = null;
        super.destroy();
    }
}
