package com.hotel.servlet;

import com.hotel.dao.BookingDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.model.Booking;
import com.hotel.model.Room;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * BookingServlet.java - Controller (Servlet)
 * ============================================================
 * SYLLABUS TOPIC: Servlets — doGet() & doPost(), Request/Response
 *
 * This servlet handles TWO responsibilities:
 *
 *  GET  /book?roomId=X  → Load booking form (book.jsp)
 *                          with selected room data pre-filled
 *
 *  POST /book           → Process form submission, persist via
 *                          BookingDAO, redirect to confirmation
 *
 * (See RoomSearchServlet.java for full Servlet Life Cycle docs)
 *
 * URL Mapping: /book
 * ============================================================
 */
@WebServlet("/book")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 2L;

    private RoomDAO    roomDAO;
    private BookingDAO bookingDAO;

    /** Life Cycle — init(): runs once on servlet startup */
    @Override
    public void init() throws ServletException {
        super.init();
        roomDAO    = new RoomDAO();
        bookingDAO = new BookingDAO();
        System.out.println("[BookingServlet] Initialized.");
    }

    /**
     * doGet() — Serves the Booking Form
     *
     * Called when user clicks "Book Now" on a room card.
     * Reads the roomId from the query string, fetches Room data,
     * places it on the request, and forwards to book.jsp.
     *
     * Example URL: GET /book?roomId=3
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdParam = request.getParameter("roomId");

        // Input validation
        if (roomIdParam == null || roomIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdParam);
            Room room = roomDAO.getRoomById(roomId);

            if (room == null || !room.isAvailable()) {
                // Room not found or already booked
                request.setAttribute("errorMessage", "Sorry, this room is no longer available.");
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/error.jsp");
                rd.forward(request, response);
                return;
            }

            // Set room data on request scope → available as ${room} in JSP
            request.setAttribute("room", room);

            // Set today's date as default check-in for the date picker
            request.setAttribute("todayDate", LocalDate.now().toString());

            // Forward to the booking form VIEW
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/book.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }

    /**
     * doPost() — Processes the Booking Form Submission
     *
     * Called when AngularJS POSTs the booking form data.
     * Flow:
     *   1. Read and validate all form parameters
     *   2. Calculate total nights and price
     *   3. Create Booking object and persist via BookingDAO
     *   4. On success → redirect to confirmation page
     *   5. On failure → forward back to form with error message
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Step 1: Read form parameters ─────────────────────────────────────
        request.setCharacterEncoding("UTF-8");

        String roomIdParam    = request.getParameter("roomId");
        String guestName      = request.getParameter("guestName");
        String guestEmail     = request.getParameter("guestEmail");
        String guestPhone     = request.getParameter("guestPhone");
        String checkInStr     = request.getParameter("checkInDate");
        String checkOutStr    = request.getParameter("checkOutDate");
        String specialReqs    = request.getParameter("specialRequests");

        // ── Step 2: Basic server-side validation ──────────────────────────────
        if (roomIdParam == null || guestName == null || guestEmail == null ||
            checkInStr == null  || checkOutStr == null ||
            guestName.trim().isEmpty() || guestEmail.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All required fields must be filled.");
            doGet(request, response); // Re-display the form
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdParam);
            Room room = roomDAO.getRoomById(roomId);

            if (room == null) {
                request.setAttribute("errorMessage", "Invalid room selection.");
                doGet(request, response);
                return;
            }

            // ── Step 3: Parse dates and calculate totals ──────────────────────
            LocalDate checkIn  = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);

            if (!checkOut.isAfter(checkIn)) {
                request.setAttribute("errorMessage", "Check-out date must be after check-in date.");
                request.setAttribute("room", room);
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/book.jsp");
                rd.forward(request, response);
                return;
            }

            long totalNights = ChronoUnit.DAYS.between(checkIn, checkOut);
            double totalPrice = totalNights * room.getPricePerNight();

            // ── Step 4: Build Booking object ──────────────────────────────────
            Booking booking = new Booking();
            booking.setUserId(1);                          // Default guest user (demo)
            booking.setRoomId(roomId);
            booking.setCheckInDate(Date.valueOf(checkIn));
            booking.setCheckOutDate(Date.valueOf(checkOut));
            booking.setTotalNights((int) totalNights);
            booking.setTotalPrice(totalPrice);
            booking.setGuestName(guestName.trim());
            booking.setGuestEmail(guestEmail.trim());
            booking.setGuestPhone(guestPhone != null ? guestPhone.trim() : "");
            booking.setSpecialRequests(specialReqs != null ? specialReqs.trim() : "");

            // ── Step 5: Persist via DAO (JDBC INSERT + room update) ───────────
            int bookingId = bookingDAO.createBooking(booking);

            if (bookingId > 0) {
                // PRG Pattern: Post/Redirect/Get prevents duplicate submission on refresh
                response.sendRedirect(
                    request.getContextPath() + "/confirmation?bookingId=" + bookingId
                );
            } else {
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.setAttribute("room", room);
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/book.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("[BookingServlet] Error processing booking: " + e.getMessage());
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/error.jsp");
            rd.forward(request, response);
        }
    }

    /** Life Cycle — destroy(): called once when servlet is unloaded */
    @Override
    public void destroy() {
        System.out.println("[BookingServlet] Destroyed.");
        roomDAO    = null;
        bookingDAO = null;
        super.destroy();
    }
}
