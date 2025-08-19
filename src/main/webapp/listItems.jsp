<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.*, com.example.pahanaedu.model.User" %>
<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Items</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui,-apple-system,Roboto,sans-serif; background:#f8fafc; color:#0f172a; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; }
        main { padding:24px; max-width:1100px; margin:auto; }
        .toolbar { display:flex; gap:10px; align-items:center; margin-bottom:16px; }
        .btn { background:#2563eb; color:#fff; border:0; padding:10px 14px; border-radius:10px; cursor:pointer; text-decoration:none; display:inline-block; }
        .btn.gray { background:#64748b; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 8px 20px rgba(0,0,0,.05); }
        th, td { padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; font-size:14px; }
        th { background:#f1f5f9; color:#334155; }
        tr:last-child td { border-bottom:0; }
        .actions { display:flex; gap:8px; }
        .price { font-weight:700; }
        .msg { margin:12px 0; padding:10px 12px; border-radius:10px; }
        .success { background:#dcfce7; color:#166534; }
        .error { background:#fee2e2; color:#991b1b; }
    </style>
</head>
<body>
<header>
    <div>📦 Items</div>
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
    <c:if test="${param.msg == 'added'}"><div class="msg success">Item added successfully.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="msg success">Item updated successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="msg success">Item deleted successfully.</div></c:if>
    <c:if test="${param.msg == 'notfound'}"><div class="msg error">Item not found.</div></c:if>
    <c:if test="${not empty error}"><div class="msg error">${error}</div></c:if>

    <div class="toolbar">
        <a class="btn" href="${pageContext.request.contextPath}/items?action=new">➕ Add Item</a>
    </div>

    <table>
        <thead>
        <tr>
            <th>Item Code</th>
            <th>Item Name</th>
            <th>Type</th>
            <th>Price (LKR)</th>
            <th style="width:160px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="i" items="${items}">
            <tr>
                <td>${i.itemCode}</td>
                <td>${i.itemName}</td>
                <td>${i.itemType}</td>
                <td class="price">${i.itemPrice}</td>
                <td>
                    <div class="actions">
                        <a class="btn" href="${pageContext.request.contextPath}/items?action=edit&itemCode=${i.itemCode}">Edit</a>
                        <form method="post" action="${pageContext.request.contextPath}/items" onsubmit="return confirm('Delete this item?');" style="display:inline;">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="itemCode" value="${i.itemCode}"/>
                            <button class="btn gray" type="submit">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty items}">
            <tr><td colspan="5" style="text-align:center; padding:20px;">No items found.</td></tr>
        </c:if>
        </tbody>
    </table>
</main>
</body>
</html>
