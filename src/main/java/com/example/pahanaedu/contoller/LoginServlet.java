package com.example.pahanaedu.contoller;

import com.example.pahanaedu.dao.UserDAO;
import com.example.pahanaedu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic validation (you can expand server-side + client-side)
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password);
        if (user == null) {
            req.setAttribute("error", "Invalid credentials or inactive account.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        // Create session
        HttpSession session = req.getSession(true);
        session.setAttribute("authUser", user);

        // Optional: set a short-lived cookie (HttpOnly) for UI niceties
        Cookie nameCookie = new Cookie("fullName", user.getFullName());
        nameCookie.setHttpOnly(true);
        nameCookie.setPath(req.getContextPath());
        nameCookie.setMaxAge(60 * 30);
        resp.addCookie(nameCookie);

        // Redirect to dashboard/home
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
