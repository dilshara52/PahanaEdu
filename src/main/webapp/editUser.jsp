<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.pahanaedu.model.User" %>

<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    User editUser = (User) request.getAttribute("user"); // set by servlet
    if (editUser == null) { response.sendRedirect(request.getContextPath() + "/users?action=list"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Edit User</title>
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
        input[type=text], input[type=password], select { width:100%; padding:12px 14px; border:1px solid #dfe3ea; border-radius:10px; }
        .row { display:grid; grid-template-columns: 1fr 1fr; gap:16px; }
        .msg { margin-bottom:12px; padding:10px 12px; border-radius:10px; }
        .error { background:#fee2e2; color:#991b1b; }
        .actions { display:flex; gap:10px; margin-top:18px; }
        .btn { background:#2563eb; color:#fff; border:0; padding:12px 16px; border-radius:10px; cursor:pointer; text-decoration:none; }
        .btn.gray { background:#64748b; }
        .inline { display:flex; align-items:center; gap:10px; margin-top:8px; }
        .hint { color:#64748b; font-size:12px; margin-top:6px; }
    </style>
</head>
<body>
<header>
    <div>✏️ Edit User</div>
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
    <form method="post" action="${pageContext.request.contextPath}/users">
        <input type="hidden" name="action" value="update" />
        <h2>Update Details</h2>

        <c:if test="${not empty error}"><div class="msg error">${error}</div></c:if>

        <label>Username (read-only)</label>
        <input type="text" name="username" value="${user.username}" readonly />

        <label>Full Name</label>
        <input type="text" name="fullName" value="${user.fullName}" required />

        <div class="row">
            <div>
                <label>New Password (optional)</label>
                <input type="password" name="password" minlength="6" />
                <div class="hint">Leave blank to keep the current password.</div>
            </div>
            <div>
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" minlength="6" />
            </div>
        </div>

        <div class="row">
            <div>
                <label>Role</label>
                <select name="role" required>
                    <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>STAFF</option>
                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                </select>
            </div>
            <div class="inline">
                <input type="checkbox" id="active" name="active" ${user.active ? 'checked' : ''} />
                <label for="active">Active</label>
            </div>
        </div>

        <div class="actions">
            <button class="btn" type="submit">Save Changes</button>
            <a class="btn gray" href="${pageContext.request.contextPath}/users?action=list">Cancel</a>
        </div>
    </form>
</main>
</body>
</html>
