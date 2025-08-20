package com.example.pahanaedu.contoller;


import com.example.pahanaedu.dao.BillDAO;
import com.example.pahanaedu.dao.CustomerDAO;
import com.example.pahanaedu.model.Bill;
import com.example.pahanaedu.model.Customer;
import com.example.pahanaedu.model.User;
import com.example.pahanaedu.service.BillingService;
import com.example.pahanaedu.service.BillingService.Result;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name="BillingServlet", urlPatterns={"/billing"})
public class BillingServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final BillDAO billDAO = new BillDAO();
    private final BillingService billingService = new BillingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User authUser = (User) req.getSession().getAttribute("authUser");
        if (authUser == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        // Optional: pre-fill by accountNo via querystring
        String accountNo = trim(req.getParameter("accountNo"));
        if (!accountNo.isEmpty()) {
            Customer c = customerDAO.findByAccountNo(accountNo);
            if (c == null) req.setAttribute("error", "Account not found: " + accountNo);
            req.setAttribute("customer", c);
        }
        req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User authUser = (User) req.getSession().getAttribute("authUser");
        if (authUser == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        String action = trim(req.getParameter("action"));

        if ("calculate".equalsIgnoreCase(action)) {
            String accountNo = trim(req.getParameter("accountNo"));
            String unitsStr  = trim(req.getParameter("units"));
            if (accountNo.isEmpty() || unitsStr.isEmpty()) {
                req.setAttribute("error", "Account number and units are required.");
                req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
                return;
            }
            Customer c = customerDAO.findByAccountNo(accountNo);
            if (c == null) {
                req.setAttribute("error", "Account not found: " + accountNo);
                req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
                return;
            }
            int units;
            try { units = Integer.parseInt(unitsStr); if (units < 0) throw new NumberFormatException(); }
            catch (NumberFormatException ex) {
                req.setAttribute("error", "Units must be a non-negative integer.");
                req.setAttribute("customer", c);
                req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
                return;
            }

            Result calc = billingService.calculate(units);
            req.setAttribute("customer", c);
            req.setAttribute("calc", calc);
            req.setAttribute("units", units);
            req.getRequestDispatcher("/WEB-INF/views/billPreview.jsp").forward(req, resp);
            return;
        }

        if ("confirm".equalsIgnoreCase(action)) {
            String accountNo = trim(req.getParameter("accountNo"));
            int units = Integer.parseInt(req.getParameter("units"));
            double subtotal = Double.parseDouble(req.getParameter("subtotal"));
            double tax = Double.parseDouble(req.getParameter("tax"));
            double total = Double.parseDouble(req.getParameter("total"));
            String rateModel = req.getParameter("rateModel");

            Bill b = new Bill();
            b.setAccountNo(accountNo);
            b.setUnits(units);
            b.setSubtotal(subtotal);
            b.setTaxAmount(tax);
            b.setTotalAmount(total);
            b.setRateModel(rateModel);

            long id = billDAO.insert(b);
            if (id <= 0) {
                req.setAttribute("error", "Failed to save bill. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
                return;
            }
            // Show printable bill using the same preview view
            req.setAttribute("savedBillId", id);
            req.setAttribute("customer", customerDAO.findByAccountNo(accountNo));
            req.setAttribute("units", units);

            BillingService.Result calc = new BillingService().calculate(units);
            req.setAttribute("calc", calc);
            req.getRequestDispatcher("/WEB-INF/views/billPreview.jsp").forward(req, resp);
            return;
        }

        // default
        req.getRequestDispatcher("/WEB-INF/views/billing.jsp").forward(req, resp);
    }

    private static String trim(String s) { return (s == null) ? "" : s.trim(); }
}

