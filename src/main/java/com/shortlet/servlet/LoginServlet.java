package com.shortlet.servlet;

import com.shortlet.model.User;
import com.shortlet.service.UserService;
import com.shortlet.util.AppConfig;
import com.shortlet.util.ServletUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Base64;
import java.util.Optional;

public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final SecureRandom random = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("google".equals(request.getParameter("provider"))) {
            startGoogleOAuth(request, response);
            return;
        }
        request.setAttribute("googleReady", isGoogleConfigured());
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = value(request.getParameter("email"));
        String password = value(request.getParameter("password"));
        String name = value(request.getParameter("name"));
        try {
            User user;
            if ("register".equals(action)) {
                if (name.isBlank() || email.isBlank() || password.length() < 6) {
                    request.setAttribute("error", "Enter your name, email, and a password with at least 6 characters.");
                    doGet(request, response);
                    return;
                }
                if (userService.findByEmail(email).isPresent()) {
                    request.setAttribute("error", "An account already exists for that email.");
                    doGet(request, response);
                    return;
                }
                user = userService.register(name, email, password);
            } else {
                Optional<User> authenticated = userService.authenticate(email, password);
                if (authenticated.isEmpty()) {
                    request.setAttribute("error", "Invalid email or password.");
                    doGet(request, response);
                    return;
                }
                user = authenticated.get();
            }
            ServletUtil.login(request, user);
            response.sendRedirect("ADMIN".equals(user.getRole()) ? "/admin" : "/dashboard");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void startGoogleOAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isGoogleConfigured()) {
            response.sendRedirect("/login?error=google_not_configured");
            return;
        }
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        String state = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        request.getSession(true).setAttribute("oauth_state", state);

        String url = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + enc(AppConfig.get("google.clientId"))
                + "&redirect_uri=" + enc(AppConfig.get("google.redirectUri"))
                + "&response_type=code"
                + "&scope=" + enc("openid email profile")
                + "&state=" + enc(state)
                + "&prompt=select_account";
        response.sendRedirect(url);
    }

    private boolean isGoogleConfigured() {
        return AppConfig.get("google.clientId", "").startsWith("replace-with-") == false
                && AppConfig.get("google.clientSecret", "").startsWith("replace-with-") == false;
    }

    private String enc(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }
}
