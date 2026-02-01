<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/includes/header.jsp" %>

<style>
    .login-wrapper {
        max-width: 450px;
        margin: 80px auto;
        background: white;
        padding: 35px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    .login-title {
        text-align: center;
        font-size: 2rem;
        margin-bottom: 25px;
        color: var(--text-dark);
        font-weight: 300;
    }
    .admin-badge {
        text-align: center;
        background-color: #e74c3c;
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        display: inline-block;
        font-size: 0.85rem;
        font-weight: 600;
        margin-bottom: 20px;
    }
    .badge-container {
        text-align: center;
        margin-bottom: 10px;
    }
    .login-wrapper label {
        font-weight: 500;
        margin-bottom: 6px;
        display: block;
        color: var(--text-dark);
    }
    .login-wrapper input {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        margin-bottom: 18px;
        font-size: 1rem;
        transition: 0.3s;
    }
    .login-wrapper input:focus {
        border-color: #e74c3c;
        outline: none;
        box-shadow: 0 0 4px rgba(231,76,60,0.3);
    }
    .btn-login-submit {
        width: 100%;
        background-color: #e74c3c;
        color: white;
        padding: 14px;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .btn-login-submit:hover {
        background-color: #c0392b;
    }
    .login-message {
        text-align: center;
        color: red;
        margin-top: 10px;
        font-size: 0.95rem;
    }
    .back-link {
        text-align: center;
        margin-top: 20px;
        font-size: 0.95rem;
    }
    .back-link a {
        color: #e74c3c;
        text-decoration: none;
        font-weight: 600;
    }
    .back-link a:hover {
        text-decoration: underline;
    }
</style>

<div class="login-wrapper">
    <h2 class="login-title">Administrator Login</h2>

    <div class="badge-container">
        <span class="admin-badge">ADMIN ACCESS</span>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/AdminLoginController">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit" class="btn-login-submit">Login</button>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="login-message"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
    </form>

    <p class="back-link">
        <a href="${pageContext.request.contextPath}/index.jsp">← Back to Home</a>
    </p>
</div>

<%@ include file="/includes/footer.jsp" %>

