package com.shortlet.servlet;

import com.shortlet.model.User;
import com.shortlet.service.BookingService;
import com.shortlet.util.ServletUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class UserDashboardServlet extends HttpServlet {
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = ServletUtil.currentUser(request);
        String city = request.getParameter("city");
        try {
            request.setAttribute("bookings", bookingService.findByUser(user.getId()));
            request.setAttribute("properties", bookingService.searchProperties(city));
            request.setAttribute("city", city == null ? "" : city);
            request.getRequestDispatcher("/WEB-INF/views/user-dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
