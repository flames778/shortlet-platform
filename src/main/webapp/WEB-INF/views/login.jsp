<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200">
    <title>Login - Shortlet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-width: 1200px;
            min-height: 100vh;
            background: linear-gradient(120deg, rgba(5, 21, 38, .92), rgba(8, 127, 99, .62)),
            url('https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=1800&q=80') center/cover;
        }
        .auth-card { max-width: 480px; border: 0; border-radius: 8px; }
        .brand-mark { width: 40px; height: 40px; border-radius: 10px; background: #16c79a; display: inline-grid; place-items: center; color: #041221; font-weight: 800; }
    </style>
</head>
<body class="d-flex align-items-center">
<main class="container py-5">
    <div class="mx-auto card auth-card shadow-lg">
        <div class="card-body p-4 p-md-5">
            <a href="/" class="d-inline-flex align-items-center gap-2 text-decoration-none text-dark fw-bold mb-4">
                <span class="brand-mark">S</span> Shortlet
            </a>
            <h1 class="h3 fw-bold">Welcome back</h1>
            <p class="text-secondary mb-4">Sign in or create an account to manage short stays.</p>

            <% if (request.getAttribute("error") != null || request.getParameter("error") != null) { %>
            <div class="alert alert-danger">Unable to complete that request. Please check your details and try again.</div>
            <% } %>

            <form method="post" action="/login" class="mb-3">
                <input type="hidden" name="action" value="login">
                <div class="mb-3">
                    <label class="form-label" for="loginEmail">Email</label>
                    <input class="form-control form-control-lg" id="loginEmail" name="email" type="email" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="loginPassword">Password</label>
                    <input class="form-control form-control-lg" id="loginPassword" name="password" type="password" required>
                </div>
                <button class="btn btn-success btn-lg w-100" type="submit">Login</button>
            </form>

            <div class="d-flex align-items-center gap-3 my-4">
                <hr class="flex-grow-1"><span class="text-secondary small">or</span><hr class="flex-grow-1">
            </div>

            <a class="btn btn-outline-dark btn-lg w-100 <%= Boolean.TRUE.equals(request.getAttribute("googleReady")) ? "" : "disabled" %>"
               href="/login?provider=google">Continue with Google</a>
            <% if (!Boolean.TRUE.equals(request.getAttribute("googleReady"))) { %>
            <p class="small text-secondary mt-2 mb-0">Set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET to enable Google login.</p>
            <% } %>

            <hr class="my-4">
            <h2 class="h5 fw-bold">Create account</h2>
            <form method="post" action="/login">
                <input type="hidden" name="action" value="register">
                <div class="row g-2">
                    <div class="col-12">
                        <input class="form-control" name="name" type="text" placeholder="Full name" required>
                    </div>
                    <div class="col-12">
                        <input class="form-control" name="email" type="email" placeholder="Email" required>
                    </div>
                    <div class="col-12">
                        <input class="form-control" name="password" type="password" placeholder="Password" minlength="6" required>
                    </div>
                </div>
                <button class="btn btn-dark w-100 mt-3" type="submit">Register</button>
            </form>

            <p class="text-secondary small mt-4 mb-0">Demo admin: admin@shortlet.com / admin123</p>
        </div>
    </div>
</main>
</body>
</html>
