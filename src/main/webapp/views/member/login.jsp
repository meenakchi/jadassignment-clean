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
        border-color: var(--primary-blue);
        outline: none;
        box-shadow: 0 0 4px rgba(74,144,226,0.3);
    }
    .btn-login-submit {
        width: 100%;
        background-color: var(--primary-blue);
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
        background-color: var(--primary-blue-dark);
    }
    .login-message {
        text-align: center;
        color: red;
        margin-top: 10px;
        font-size: 0.95rem;
    }
    .success-message {
        text-align: center;
        color: green;
        margin-top: 10px;
        font-size: 0.95rem;
    }
    .register-text {
        text-align: center;
        margin-top: 20px;
        font-size: 0.95rem;
    }
    .register-text a {
        color: var(--primary-blue);
        text-decoration: none;
        font-weight: 600;
    }
    .register-text a:hover {
        text-decoration: underline;
    }
</style>

<div class="login-wrapper">
    <h2 class="login-title">Member Login</h2>

    <form method="post" action="${pageContext.request.contextPath}/MemberLoginController">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit" class="btn-login-submit">Login</button>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="login-message"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <p class="success-message"><%= request.getAttribute("successMessage") %></p>
        <% } %>
    </form>

    <p class="register-text">
        Not registered?
        <a href="${pageContext.request.contextPath}/MemberRegisterController">Create an account</a>
    </p>
</div>

<%@ include file="/includes/footer.jsp" %>
