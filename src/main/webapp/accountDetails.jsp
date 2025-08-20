<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.pahanaedu.model.User, com.example.pahanaedu.model.Customer" %>

<%
    User authUser = (User) session.getAttribute("authUser");
    if (authUser == null) { response.sendRedirect(request.getContextPath()+"/login"); return; }
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu | Account Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { margin:0; font-family:system-ui,-apple-system,Roboto,sans-serif; background:#f8fafc; color:#0f172a; }
        header { background:#2563eb; color:#fff; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; }
        nav { background:#1e40af; color:#fff; padding:12px; display:flex; gap:20px; }
        nav a { color:#fff; text-decoration:none; }
        main { padding:32px; max-width:900px; margin:auto; }
        .search { background:#fff; padding:24px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.05); display:flex; gap:12px; align-items:center; }
        .search input[type=text] { flex:1; padding:12px 14px; border:1px solid #dfe3ea; border-radius:10px; }
        .btn { background:#2563eb; color:#fff; border:0; padding:12px 16px; border-radius:10px; cursor:pointer; text-decoration:none; display:inline-block; }
        .btn.gray { background:#64748b; }
        .msg { margin:16px 0; padding:10px 12px; border-radius:10px; }
        .error { background:#fee2e2; color:#991b1b; }
        .card { background:#fff; padding:24px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,.05); margin-top:20px; }
        .grid { display:grid; grid-template-columns: 1fr 1fr; gap:16px; }
        .label { color:#475569; font-size:12px; text-transform:uppercase; letter-spacing:.03em; }
        .value { font-size:16px; font-weight:600; }
        .toolbar { display:flex; gap:10px; margin-top:16px; }
        @media (max-width: 640px) { .grid { grid-template-columns: 1fr; } }
        @media print {
            header, nav, .search, .toolbar { display:none; }
            body { background:#fff; }
            .card { box-shadow:none; }
        }
    </style>
    <script>
        function doPrint(){ window.print(); }
    </script>
</head>
<body>
<header>
    <div>📄 Account Details</div>
    <div>Logged in as <strong><%= authUser.getFullName() %></strong> | <a href="${pageContext.request.contextPath}/logout" style="color:#fff;">Logout</a></div>
</header>
<nav>
    <a href="${pageContext.request.contextPath}/dashboard">🏠 Dashboard</a>
    <a href="${pageContext.request.contextPath}/customers">👥 Customers</a>
    <a href="${pageContext.request.contextPath}/items">📦 Items</a>
    <a href="${pageContext.request.contextPath}/billing">🧾 Billing</a>
    <a href="${pageContext.request.contextPath}/users">👤 Users</a>
    <a href="${pageContext.request.contextPath}/account-details">📄 Account Details</a>
    <a href="${pageContext.request.contextPath}/help">❓ Help</a>
</nav>

<main>
    <!-- Search -->
    <form class="search" method="post" action="${pageContext.request.contextPath}/account-details">
        <input type="text" name="accountNo" value="${param.accountNo}" placeholder="Enter Account Number (e.g., AC1001)" required />
        <button class="btn" type="submit">Search</button>
        <a class="btn gray" href="${pageContext.request.contextPath}/account-details">Clear</a>
    </form>

    <c:if test="${not empty error}">
        <div class="msg error">${error}</div>
    </c:if>

    <!-- Details -->
    <c:if test="${customer != null}">
        <div class="card">
            <h2 style="margin:0 0 10px;">Customer Account</h2>
            <div class="grid">
                <div>
                    <div class="label">Account Number</div>
                    <div class="value">${customer.accountNo}</div>
                </div>
                <div>
                    <div class="label">Full Name</div>
                    <div class="value">${customer.name}</div>
                </div>
                <div>
                    <div class="label">Address</div>
                    <div class="value">${customer.address}</div>
                </div>
                <div>
                    <div class="label">Telephone</div>
                    <div class="value">${customer.phone}</div>
                </div>
                <div>
                    <div class="label">Units Consumed</div>
                    <div class="value">${customer.units}</div>
                </div>
                <div>
                    <div class="label">Created On</div>
                    <div class="value">
                        <!-- If you want created_at, add it to Customer model/DAO; otherwise hide/remove -->
                        (creation date stored in DB)
                    </div>
                </div>
            </div>

            <div class="toolbar">
                <a class="btn" href="${pageContext.request.contextPath}/customers?action=edit&accountNo=${customer.accountNo}">Edit Account</a>
                <button class="btn gray" type="button" onclick="doPrint()">Print</button>
            </div>
        </div>
    </c:if>
</main>
</body>
</html>
