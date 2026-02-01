<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/includes/header.jsp" %>

<style>
    .register-wrapper {
        max-width: 550px;
        margin: 60px auto;
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    .register-title {
        text-align: center;
        font-size: 2rem;
        margin-bottom: 30px;
        color: #2c3e50;
    }
    .form-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 20px;
    }
    .form-group {
        display: flex;
        flex-direction: column;
    }
    .form-group label {
        font-weight: 600;
        margin-bottom: 8px;
        color: #2c3e50;
    }
    .form-group input {
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 1rem;
        transition: 0.3s;
    }
    .form-group input:focus {
        border-color: #3498db;
        outline: none;
        box-shadow: 0 0 4px rgba(52,152,219,0.3);
    }
    .required {
        color: #e74c3c;
    }
    .btn-register {
        width: 100%;
        background-color: #27ae60;
        color: white;
        padding: 15px;
        border: none;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s;
        margin-top: 10px;
    }
    .btn-register:hover {
        background-color: #229954;
    }
    .error-message {
        background-color: #f8d7da;
        color: #721c24;
        padding: 12px;
        border-radius: 5px;
        margin-bottom: 20px;
        text-align: center;
    }
    .login-link {
        text-align: center;
        margin-top: 20px;
        font-size: 0.95rem;
    }
    .login-link a {
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
    }
    .login-link a:hover {
        text-decoration: underline;
    }
    .password-requirements {
        font-size: 0.85rem;
        color: #7f8c8d;
        margin-top: 5px;
    }
</style>

<div class="register-wrapper">
    <h2 class="register-title">Create Account</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/MemberRegisterController">
        <div class="form-grid">
            <div class="form-group">
                <label>Full Name <span class="required">*</span></label>
                <input type="text" name="fullName" required placeholder="John Doe">
            </div>

            <div class="form-group">
                <label>Email Address <span class="required">*</span></label>
                <input type="email" name="email" required placeholder="john@example.com">
            </div>

            <div class="form-group">
                <label>Username <span class="required">*</span></label>
                <input type="text" name="username" required placeholder="johndoe" 
                       pattern="[a-zA-Z0-9_]{3,20}" 
                       title="3-20 characters, letters, numbers and underscore only">
            </div>

            <div class="form-group">
                <label>Password <span class="required">*</span></label>
                <input type="password" name="password" required 
                       minlength="6" placeholder="Enter password">
                <div class="password-requirements">
                    Minimum 6 characters
                </div>
            </div>

            <div class="form-group">
                <label>Confirm Password <span class="required">*</span></label>
                <input type="password" name="confirmPassword" required 
                       minlength="6" placeholder="Confirm password">
            </div>
        </div>

        <button type="submit" class="btn-register">Register</button>

        <p class="login-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/MemberLoginController">Login here</a>
        </p>
    </form>
</div>

<script>
document.querySelector('form').addEventListener('submit', function(e) {
    const password = document.querySelector('input[name="password"]').value;
    const confirm = document.querySelector('input[name="confirmPassword"]').value;
    
    if (password !== confirm) {
        e.preventDefault();
        alert('Passwords do not match!');
    }
});
</script>

<%@ include file="/includes/footer.jsp" %>