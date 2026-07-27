package com.hotel.servlet;

import com.hotel.dao.RoomDAO;
import com.hotel.model.Room;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * RoomSearchServlet.java - Controller (Servlet)
 * ============================================================
 * SYLLABUS TOPIC: Servlets, MVC Architecture — CONTROLLER layer
 *
 * ┌─────────────────────────────────────────────────────────┐
 * │             SERVLET LIFE CYCLE (Key Concept)            │
 * ├─────────────────────────────────────────────────────────┤
 * │ 1. LOADING & INSTANTIATION                              │
 * │    - Container loads the class, creates ONE instance    │
 * │    - Only ONE instance serves ALL requests (Singleton)  │
 * │                                                         │
 * │ 2. INITIALIZATION → init(ServletConfig config)         │
 * │    - Called ONCE after instantiation                    │
 * │    - Used to read init params, set up resources         │
 * │                                                         │
 * │ 3. REQUEST HANDLING → service(req, res)                │
 * │    - Called for EVERY incoming request                  │
 * │    - Delegates to doGet() or doPost() based on method  │
 * │                                                         │
 * │ 4. DESTRUCTION → destroy()                             │
 * │    - Called ONCE before container removes the servlet   │
 * │    - Used to release resources (DB connections, etc.)   │
 * └─────────────────────────────────────────────────────────┘
 *
 * N-Tier Architecture Role:
 *   Client Tier  →  Web/App Tier (this Servlet)  →  Data Tier
 *   Browser           RoomSearchServlet              MySQL DB
 *
 * URL Mapping: /rooms  (via @WebServlet annotation)
 * ============================================================
 */
@WebServlet("/rooms")
public class RoomSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ── DAO instance (created once; DAOs are stateless so this is safe) ───────
    private RoomDAO roomDAO;

    /**
     * LIFE CYCLE PHASE 2: Initialization
     * Called once by the container when the servlet is first loaded.
     * We initialize the DAO here to avoid creating it on every request.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        roomDAO = new RoomDAO();
        System.out.println("[RoomSearchServlet] Initialized. DAO ready.");
    }

    /**
     * LIFE CYCLE PHASE 3a: Handles HTTP GET requests
     *
     * Triggered when user visits the home page or filters rooms.
     * Flow:
     *   1. Read optional filter param from query string (?type=Deluxe)
     *   2. Fetch matching Room list from DAO (JDBC query)
     *   3. Store list as a request attribute
     *   4. Forward to index.jsp (the VIEW) for rendering
     *
     * @param request  the incoming HTTP request
     * @param response the outgoing HTTP response
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read optional filter parameter from URL query string
        String typeFilter = request.getParameter("type");

        List<Room> rooms;

        if (typeFilter != null && !typeFilter.trim().isEmpty() && !typeFilter.equals("All")) {
            // Filtered query (e.g., /rooms?type=Deluxe)
            rooms = roomDAO.getRoomsByType(typeFilter);
            request.setAttribute("activeFilter", typeFilter);
        } else {
            // Default: fetch all available rooms
            rooms = roomDAO.getAllAvailableRooms();
            request.setAttribute("activeFilter", "All");
        }

        // Set room list as a request attribute → available as ${rooms} in JSP
        request.setAttribute("rooms", rooms);

        // Define available filter types for the JSP to render filter buttons
        request.setAttribute("roomTypes", new String[]{"All", "Standard", "Deluxe", "Suite", "Executive"});

        // Forward to the VIEW (index.jsp) — NOT a redirect; shares request scope
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/index.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * LIFE CYCLE PHASE 3b: Handles HTTP POST requests
     * (Not used for room search; redirects to GET to prevent form re-submission)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/rooms");
    }

    /**
     * LIFE CYCLE PHASE 4: Destruction
     * Called once when the servlet is being taken out of service.
     * Clean up any resources allocated in init().
     */
    @Override
    public void destroy() {
        System.out.println("[RoomSearchServlet] Destroyed. Releasing resources.");
        roomDAO = null;
        super.destroy();
    }
}
