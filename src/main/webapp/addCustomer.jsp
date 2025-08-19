<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Pahana Edu | Add Customer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui, -apple-system, Roboto, sans-serif; background:#f8fafc; color:#1e293b; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        header h1 { font-size:20px; margin:0; }
        header .user { font-size:14px; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; font-weight:500; }
        nav a:hover { text-decoration:underline; }
        main { padding:32px; max-width:700px; margin:auto; }
        form { background:#fff; padding:28px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.05); }
        h2 { margin:0 0 20px; font-size:22px; color:#1e3a8a; }
        label { display:block; margin:14px 0 6px; font-weight:600; }
        input[type=text], input[type=number], input[type=tel] {
            width:100%; padding:12px 14px; border:1px solid #dfe3ea; border-radius:10px; outline:none;
        }
        button { margin-top:20px; padding:12px 20px; border:0; border-radius:10px; font-weight:700; cursor:pointer; background:#2563eb; color:#fff; }
        button:hover { background:#1d4ed8; }
        .error { background:#fee2e2; color:#991b1b; padding:10px 12px; border-radius:8px; margin-bottom:12px; }
        .success { background:#dcfce7; color:#166534; padding:10px 12px; border-radius:8px; margin-bottom:12px; }
    </style>
</head>
<body>
<header>
    <h1>Pahana Edu | Add Customer</h1>
    <div class="user">
        Logged in as <strong><%= authUser.getFullName() %></strong> |
        <a href="${pageContext.request.contextPath}/logout" style="color:#fff;">Logout</a>
    </div>
</header>

<nav>
    <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/customers">👥 Customers</a>
    <a href="${pageContext.request.contextPath}/items">📦 Items</a>
    <a href="${pageContext.request.contextPath}/billing">🧾 Billing</a>
    <a href="${pageContext.request.contextPath}/help">❓ Help</a>
</nav>

<main>
    <form method="post" action="${pageContext.request.contextPath}/customers?action=add">
        <h2>➕ Add New Customer</h2>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>

        <label for="accountNo">Account Number</label>
        <input id="accountNo" name="accountNo" type="text" required />

        <label for="name">Full Name</label>
        <input id="name" name="name" type="text" required />

        <label for="address">Address</label>
        <input id="address" name="address" type="text" required />

        <label for="phone">Telephone</label>
        <input id="phone" name="phone" type="tel" pattern="[0-9]{10}" placeholder="0771234567" required />

        <label for="units">Units Consumed</label>
        <input id="units" name="units" type="number" min="0" required />

        <button type="submit">Save Customer</button>
    </form>
</main>
</body>
</html>
