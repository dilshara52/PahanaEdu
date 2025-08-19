<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.pahanaedu.model.User" %>

<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Add Item</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui,-apple-system,Roboto,sans-serif; background:#f8fafc; color:#1e293b; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; }
        main { padding:32px; max-width:700px; margin:auto; }
        form { background:#fff; padding:28px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.05); }
        h2 { margin:0 0 20px; font-size:22px; color:#1e3a8a; }
        label { display:block; margin:14px 0 6px; font-weight:600; }
        input[type=text], input[type=number], select { width:100%; padding:12px 14px; border:1px solid #dfe3ea; border-radius:10px; }
        .actions { display:flex; gap:10px; margin-top:18px; }
        .btn { background:#2563eb; color:#fff; border:0; padding:12px 16px; border-radius:10px; cursor:pointer; text-decoration:none; }
        .btn.gray { background:#64748b; }
        .msg { margin-bottom:12px; padding:10px 12px; border-radius:10px; }
        .error { background:#fee2e2; color:#991b1b; }
    </style>
</head>
<body>
<header>
    <div>➕ Add Item</div>
    <div>Logged in as <strong><%= authUser.getFullName() %></strong> | <a href="${pageContext.request.contextPath}/logout" style="color:#fff;">Logout</a></div>
</header>
<nav>
    <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/customers">👥 Customers</a>
    <a href="${pageContext.request.contextPath}/items">📦 Items</a>
    <a href="${pageContext.request.contextPath}/billing">🧾 Billing</a>
    <a href="${pageContext.request.contextPath}/users">👤 Users</a>
    <a href="${pageContext.request.contextPath}/help">❓ Help</a>
</nav>

<main>
    <form method="post" action="${pageContext.request.contextPath}/items">
        <input type="hidden" name="action" value="add" />
        <h2>New Item Details</h2>

        <c:if test="${not empty error}"><div class="msg error">${error}</div></c:if>

        <label for="itemCode">Item Code</label>
        <input id="itemCode" name="itemCode" type="text" required />

        <label for="itemName">Item Name</label>
        <input id="itemName" name="itemName" type="text" required />

        <label for="itemType">Item Type</label>
        <select id="itemType" name="itemType" required>
            <option value="BOOK">BOOK</option>
            <option value="STATIONERY">STATIONERY</option>
            <option value="OTHER">OTHER</option>
        </select>

        <label for="itemPrice">Item Price (LKR)</label>
        <input id="itemPrice" name="itemPrice" type="number" step="0.01" min="0" required />

        <div class="actions">
            <button class="btn" type="submit">Save Item</button>
            <a class="btn gray" href="${pageContext.request.contextPath}/items">Cancel</a>
        </div>
    </form>
</main>
</body>
</html>
