<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | PC TIS</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://www.google.com/recaptcha/api.js?render=6LdBJaYrAAAAAF82Cs7qFC4-6rUBXW4bdRSMT5cX"></script>
    <style>
        body {
            font-family: 'Sarabun', sans-serif;
            background-color: #f0f2f5;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            padding: 2rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background-color: #ffffff;
            border-radius: 12px;
            border-top: 5px solid #0d6efd;
        }
        .login-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .login-header i {
            font-size: 3rem;
            color: #0d6efd;
        }
        .login-header h2 {
            margin-top: 1rem;
            font-weight: 700;
        }
        .form-floating > .form-control:focus ~ label {
            color: #0d6efd;
        }
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            font-weight: 700;
            padding: 0.75rem;
        }
        .recaptcha-notice {
            font-size: 0.75rem;
            color: #6c757d;
            text-align: center;
            margin-top: 1.5rem;
        }
        #error-message {
            display: none;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="login-header">
            <i class="fas fa-users-cog"></i>
            <h2>PC | TIS</h2>
            <p class="text-muted">ระบบสารสนเทศครูผู้สอน</p>
        </div>
        
        <form id="loginForm">
            <div class="alert alert-danger" id="error-message" role="alert"></div>
            
            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="username" placeholder="Username" required>
                <label for="username"><i class="fas fa-user me-2"></i>ชื่อผู้ใช้</label>
            </div>
            <div class="form-floating mb-4">
                <input type="password" class="form-control" id="password" placeholder="Password" required>
                <label for="password"><i class="fas fa-lock me-2"></i>รหัสผ่าน</label>
            </div>
            
            <button type="submit" class="btn btn-primary w-100" id="loginButton">
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true" style="display: none;"></span>
                เข้าสู่ระบบ
            </button>
        </form>
        
        <div class="recaptcha-notice">
            This site is protected by reCAPTCHA and the Google
            <a href="https://policies.google.com/privacy">Privacy Policy</a> and
            <a href="https://policies.google.com/terms">Terms of Service</a> apply.
        </div>
    </div>

    <script>
        const loginForm = document.getElementById('loginForm');
        const loginButton = document.getElementById('loginButton');
        const spinner = loginButton.querySelector('.spinner-border');
        const errorMessage = document.getElementById('error-message');

        // WEB APP URL HAS BEEN SET
        const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbxsdC_XxGngusNLvzXybEcCvyyVQ8cubKYvOhqwx4YHMdEOCDkAwgMIhDn-9jnYeJHjLw/exec';
        // SITE KEY HAS BEEN SET
        const RECAPTCHA_SITE_KEY = '6LdBJaYrAAAAAF82Cs7qFC4-6rUBXW4bdRSMT5cX';

        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            setLoading(true);

            grecaptcha.ready(function() {
                grecaptcha.execute(RECAPTCHA_SITE_KEY, {action: 'login'}).then(function(token) {
                    
                    const username = document.getElementById('username').value;
                    const password = document.getElementById('password').value;

                    const payload = {
                        action: 'login',
                        user: username,
                        pass: password,
                        token: token
                    };

                    fetch(SCRIPT_URL, {
                        method: 'POST',
                        body: JSON.stringify(payload),
                        headers: { 'Content-Type': 'application/json' }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            // Store user data in sessionStorage for this session only
                            sessionStorage.setItem('loggedInUser', JSON.stringify(data.user));
                            window.location.href = 'HTML - v6.html'; // Redirect to the main app
                        } else {
                            showError(data.message || 'An unknown error occurred.');
                            setLoading(false);
                        }
                    })
                    .catch(error => {
                        showError('Could not connect to the server. Please try again.');
                        setLoading(false);
                    });
                });
            });
        });

        function setLoading(isLoading) {
            if (isLoading) {
                loginButton.disabled = true;
                spinner.style.display = 'inline-block';
            } else {
                loginButton.disabled = false;
                spinner.style.display = 'none';
            }
        }

        function showError(message) {
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
        }
    </script>
</body>
</html>
