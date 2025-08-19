<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pahana Edu | Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; background:#f6f7fb; margin:0; }
        .wrap { max-width:420px; margin:10vh auto; background:#fff; padding:32px; border-radius:16px; box-shadow:0 10px 30px rgba(0,0,0,.08); }
        h1 { margin:0 0 20px; font-size:22px; }
        label { display:block; margin:12px 0 6px; font-weight:600; }
        input[type=text], input[type=password] {
            width:100%; padding:12px 14px; border:1px solid #dfe3ea; border-radius:10px; outline:none;
        }
        button { width:100%; margin-top:18px; padding:12px; border:0; border-radius:10px; font-weight:700; cursor:pointer; background:#2563eb; color:#fff; }
        .error { background:#fee2e2; color:#991b1b; padding:10px 12px; border-radius:8px; margin-bottom:12px; }
        .hint { color:#64748b; font-size:12px; margin-top:10px; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>Sign in</h1>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <label for="username">Username</label>
        <input id="username" name="username" type="text" required autofocus />

        <label for="password">Password</label>
        <input id="password" name="password" type="password" required />

        <button type="submit">Login</button>
        <div class="hint">Forgot password? Contact your administrator.</div>
    </form>
</div>

<!-- JSTL taglib (if using JSTL) -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</body>
</html>
