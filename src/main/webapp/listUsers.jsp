<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.example.pahanaedu.model.User" %>

<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui,-apple-system,Roboto,sans-serif; background:#f8fafc; color:#0f172a; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; }
        main { padding:24px; max-width:1100px; margin:auto; }
        .toolbar { display:flex; gap:10px; align-items:center; margin-bottom:16px; }
        .toolbar input[type=text] { flex:1; padding:10px 12px; border:1px solid #dfe3ea; border-radius:10px; }
        .btn { background:#2563eb; color:#fff; border:0; padding:10px 14px; border-radius:10px; cursor:pointer; text-decoration:none; display:inline-block; }
        .btn.gray { background:#64748b; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 8px 20px rgba(0,0,0,.05); }
        th, td { padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; font-size:14px; }
        th { background:#f1f5f9; color:#334155; }
        tr:last-child td { border-bottom:0; }
        .pill { display:inline-block; padding:6px 10px; border-radius:999px; font-size:12px; background:#e2e8f0; color:#0f172a; }
        .pill.green { background:#dcfce7; color:#166534; }
        .pill.red { background:#fee2e2; color:#991b1b; }
        .msg { margin:12px 0; padding:10px 12px; border-radius:10px; }
        .success { background:#dcfce7; color:#166534; }
        .error { background:#fee2e2; color:#991b1b; }
        .actions { display:flex; gap:8px; }
        .pagination { display:flex; gap:8px; justify-content:flex-end; margin-top:12px; }
        .pagination a, .pagination span { padding:8px 12px; border-radius:8px; background:#e2e8f0; text-decoration:none; color:#0f172a; }
        .pagination .active { background:#2563eb; color:#fff; }
    </style>
</head>
<body>
<header>
    <div>👤 Users</div>
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
    <c:if test="${param.msg == 'added'}"><div class="msg success">User added successfully.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="msg success">User updated successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="msg success">User deleted successfully.</div></c:if>
    <c:if test="${not empty error}"><div class="msg error">${error}</div></c:if>

    <form class="toolbar" method="get" action="${pageContext.request.contextPath}/users">
        <input type="hidden" name="action" value="list"/>
        <input type="text" name="q" value="${q}" placeholder="Search by username, full name or role..."/>
        <button class="btn" type="submit">Search</button>
        <a class="btn gray" href="${pageContext.request.contextPath}/users?action=list">Clear</a>
        <a class="btn" href="${pageContext.request.contextPath}/users?action=new">➕ Add User</a>
    </form>

    <table>
        <thead>
        <tr>
            <th>Username</th>
            <th>Full Name</th>
            <th>Role</th>
            <th>Status</th>
            <th style="width:160px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.username}</td>
                <td>${u.fullName}</td>
                <td><span class="pill">${u.role}</span></td>
                <td>
                    <c:choose>
                        <c:when test="${u.active}"><span class="pill green">Active</span></c:when>
                        <c:otherwise><span class="pill red">Inactive</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <div class="actions">
                        <a class="btn" href="${pageContext.request.contextPath}/users?action=edit&username=${u.username}">Edit</a>
                        <form method="post" action="${pageContext.request.contextPath}/users" onsubmit="return confirm('Delete this user?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="username" value="${u.username}"/>
                            <button class="btn gray" type="submit">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty users}">
            <tr><td colspan="5" style="text-align:center; padding:20px;">No users found.</td></tr>
        </c:if>
        </tbody>
    </table>

    <div class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${i == page}"><span class="active">${i}</span></c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/users?action=list&page=${i}&size=${size}&q=${q}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</main>
</body>
</html>
