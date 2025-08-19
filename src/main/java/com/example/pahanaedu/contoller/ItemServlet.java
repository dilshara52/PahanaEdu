package com.example.pahanaedu.contoller;


import com.example.pahanaedu.dao.ItemDAO;
import com.example.pahanaedu.model.Item;
import com.example.pahanaedu.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name="ItemServlet", urlPatterns={"/items"})
public class ItemServlet extends HttpServlet {
    private final ItemDAO itemDAO = new ItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User authUser = (User) req.getSession().getAttribute("authUser");
        if (authUser == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch(action) {
            case "new":
                req.getRequestDispatcher("/WEB-INF/views/addItem.jsp").forward(req, resp);
                break;
            case "edit": {
                String code = req.getParameter("itemCode");
                Item item = itemDAO.findByCode(code);
                if (item == null) {
                    resp.sendRedirect(req.getContextPath()+"/items?msg=notfound");
                    return;
                }
                req.setAttribute("item", item);
                req.getRequestDispatcher("/WEB-INF/views/editItem.jsp").forward(req, resp);
                break;
            }
            default:
                List<Item> items = itemDAO.findAll();
                req.setAttribute("items", items);
                req.getRequestDispatcher("/WEB-INF/views/listItems.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            String code = req.getParameter("itemCode");
            String name = req.getParameter("itemName");
            String type = req.getParameter("itemType");
            String priceStr = req.getParameter("itemPrice");

            try {
                double price = Double.parseDouble(priceStr);
                Item item = new Item(code, name, type, price);
                itemDAO.insert(item);
                resp.sendRedirect(req.getContextPath()+"/items?msg=added");
            } catch (Exception e) {
                req.setAttribute("error","Invalid input");
                req.getRequestDispatcher("/WEB-INF/views/addItem.jsp").forward(req, resp);
            }
        } else if ("update".equals(action)) {
            String code = req.getParameter("itemCode");
            String name = req.getParameter("itemName");
            String type = req.getParameter("itemType");
            String priceStr = req.getParameter("itemPrice");

            try {
                double price = Double.parseDouble(priceStr);
                Item item = new Item(code, name, type, price);
                itemDAO.update(item);
                resp.sendRedirect(req.getContextPath()+"/items?msg=updated");
            } catch (Exception e) {
                req.setAttribute("error","Invalid input");
                req.getRequestDispatcher("/WEB-INF/views/editItem.jsp").forward(req, resp);
            }
        } else if ("delete".equals(action)) {
            String code = req.getParameter("itemCode");
            itemDAO.delete(code);
            resp.sendRedirect(req.getContextPath()+"/items?msg=deleted");
        }
    }
}

