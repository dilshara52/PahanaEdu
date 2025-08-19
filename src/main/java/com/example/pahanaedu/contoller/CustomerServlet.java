package com.example.pahanaedu.contoller;


import com.example.pahanaedu.dao.CustomerDAO;
import com.example.pahanaedu.model.Customer;
import com.example.pahanaedu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Auth guard (keeps consistent with your AuthFilter)
        HttpSession session = req.getSession(false);
        User authUser = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null || action.equals("new") || action.equals("add")) {
            // Show the Add Customer page
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        // For now, default to add page; you can expand for list/edit/delete later.
        req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Auth guard
        HttpSession session = req.getSession(false);
        User authUser = (session != null) ? (User) session.getAttribute("authUser") : null;
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            handleAdd(req, resp);
            return;
        }

        // Unknown action -> back to form
        req.setAttribute("error", "Unsupported action.");
        req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accountNo = safe(req.getParameter("accountNo"));
        String name      = safe(req.getParameter("name"));
        String address   = safe(req.getParameter("address"));
        String phone     = safe(req.getParameter("phone"));
        String unitsStr  = safe(req.getParameter("units"));

        // Basic server-side validation
        if (accountNo.isEmpty() || name.isEmpty() || address.isEmpty() || phone.isEmpty() || unitsStr.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        if (!phone.matches("\\d{10}")) {
            req.setAttribute("error", "Telephone must be a 10-digit number (e.g., 0771234567).");
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        int units;
        try {
            units = Integer.parseInt(unitsStr);
            if (units < 0) throw new NumberFormatException("negative");
        } catch (NumberFormatException ex) {
            req.setAttribute("error", "Units must be a non-negative integer.");
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        // Duplicate check
        if (customerDAO.existsByAccountNo(accountNo)) {
            req.setAttribute("error", "Account number already exists. Please use a unique account number.");
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        Customer c = new Customer(accountNo, name, address, phone, units);
        boolean ok = customerDAO.insert(c);

        if (!ok) {
            req.setAttribute("error", "Failed to save the customer. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
            return;
        }

        // Success: set a flash-ish message and clear the form
        req.setAttribute("success", "Customer has been added successfully.");
        // You can also redirect to avoid resubmits:
        // resp.sendRedirect(req.getContextPath() + "/customers?action=new&success=1");
        req.getRequestDispatcher("/WEB-INF/views/addCustomer.jsp").forward(req, resp);
    }

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }
}

