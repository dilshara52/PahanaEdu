package com.example.pahanaedu.contoller;



import com.example.pahanaedu.dao.CustomerDAO;
import com.example.pahanaedu.model.Customer;
import com.example.pahanaedu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "AccountDetailsServlet", urlPatterns = {"/account-details"})
public class AccountDetailsServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // auth
        HttpSession session = req.getSession(false);
        User authUser = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (authUser == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        // if accountNo present -> lookup immediately
        String accountNo = trim(req.getParameter("accountNo"));
        if (!accountNo.isEmpty()) {
            Customer c = customerDAO.findByAccountNo(accountNo);
            if (c == null) req.setAttribute("error", "No account found for number: " + accountNo);
            req.setAttribute("customer", c);
        }

        req.getRequestDispatcher("/WEB-INF/views/accountDetails.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // auth
        HttpSession session = req.getSession(false);
        User authUser = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (authUser == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String accountNo = trim(req.getParameter("accountNo"));
        if (accountNo.isEmpty()) {
            req.setAttribute("error", "Please enter an account number.");
            req.getRequestDispatcher("/WEB-INF/views/accountDetails.jsp").forward(req, resp);
            return;
        }

        Customer c = customerDAO.findByAccountNo(accountNo);
        if (c == null) {
            req.setAttribute("error", "No account found for number: " + accountNo);
        }
        req.setAttribute("customer", c);
        req.getRequestDispatcher("/WEB-INF/views/accountDetails.jsp").forward(req, resp);
    }

    private static String trim(String s) { return (s == null) ? "" : s.trim(); }
}

