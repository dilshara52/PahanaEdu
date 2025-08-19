<%--
  Created by IntelliJ IDEA.
  User: Pasindu
  Date: 19/08/2025
  Time: 17:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html><%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.pahanaedu.model.User" %>


<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui, -apple-system, Roboto, sans-serif; background:#f8fafc; color:#1e293b; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        header h1 { font-size:20px; margin:0; }
        header .user { font-size:14px; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; font-weight:500; }
        nav a:hover { text-decoration:underline; }
        main { padding:32px; }
        .grid { display:grid; grid-template-columns:repeat(auto-fit, minmax(220px, 1fr)); gap:20px; margin-top:20px; }
        .card { background:#fff; padding:24px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.05); text-align:center; transition:all .2s; }
        .card:hover { transform:translateY(-3px); box-shadow:0 10px 25px rgba(0,0,0,.08); }
        .card h2 { margin:10px 0; font-size:18px; color:#1e3a8a; }
        .card p { font-size:14px; color:#475569; }
        .logout { color:#fff; margin-left:20px; }
        footer { text-align:center; padding:20px; font-size:13px; color:#64748b; margin-top:30px; }
    </style>
</head>
<body>
<header>
    <h1>📚 Pahana Edu Dashboard</h1>
    <div class="user">
        Welcome, <strong><%= authUser.getFullName() %></strong>
        (<%= authUser.getRole() %>)
        | <a href="${pageContext.request.contextPath}/logout" class="logout">Logout</a>
    </div>
</header>

<nav>
    <a href="${pageContext.request.contextPath}/dashboard">🏠 Home</a>
    <a href="${pageContext.request.contextPath}/customers">👥 Customers</a>
    <a href="${pageContext.request.contextPath}/items">📦 Items</a>
    <a href="${pageContext.request.contextPath}/billing">🧾 Billing</a>
    <a href="${pageContext.request.contextPath}/help">❓ Help</a>
</nav>

<main>
    <h2>Quick Actions</h2>
    <div class="grid">
        <div class="card">
            <h2>👥 Manage Customers</h2>
            <p>Add, edit, or view customer accounts.</p>
        </div>
        <div class="card">
            <h2>📦 Manage Items</h2>
            <p>Maintain item details for billing.</p>
        </div>
        <div class="card">
            <h2>🧾 Generate Bill</h2>
            <p>Calculate and print customer bills.</p>
        </div>
        <div class="card">
            <h2>❓ Help</h2>
            <p>System usage guidelines for staff.</p>
        </div>
    </div>
</main>

<footer>
    &copy; 2025 Pahana Edu | Developed for CIS6003 Advanced Programming Assignment
</footer>
</body>
</html>

