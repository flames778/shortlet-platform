<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Shortlet - Stay where the city happens</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f7f8fb; color: #152033; }
        .hero {
            min-height: 86vh;
            background: linear-gradient(90deg, rgba(4, 18, 33, .84), rgba(4, 18, 33, .38)),
            url('https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1800&q=80') center/cover;
        }
        .brand-mark { width: 38px; height: 38px; border-radius: 10px; background: #16c79a; display: inline-grid; place-items: center; color: #041221; font-weight: 800; }
        .feature-icon { width: 44px; height: 44px; border-radius: 12px; background: #e9fff8; display: inline-grid; place-items: center; color: #087f63; font-weight: 800; }
        .property-card img { height: 220px; object-fit: cover; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark position-absolute w-100 z-3">
    <div class="container py-2">
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="/">
            <span class="brand-mark">S</span> Shortlet
        </a>
        <div class="ms-auto d-flex gap-2">
            <a href="/login" class="btn btn-outline-light">Login</a>
            <a href="/login" class="btn btn-success">Get started</a>
        </div>
    </div>
</nav>

<header class="hero d-flex align-items-center text-white">
    <div class="container py-5">
        <div class="col-lg-7">
            <span class="badge rounded-pill text-bg-success mb-3">Short stays, serious comfort</span>
            <h1 class="display-3 fw-bold mb-4">Shortlet</h1>
            <p class="lead fs-3 mb-4">Book stylish temporary apartments across the city, or list your property for trusted guests.</p>
            <div class="d-flex flex-wrap gap-3">
                <a href="/login" class="btn btn-success btn-lg px-4">Find a stay</a>
                <a href="#properties" class="btn btn-outline-light btn-lg px-4">Explore homes</a>
            </div>
        </div>
    </div>
</header>

<main>
    <section class="py-5 bg-white">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-icon mb-3">1</div>
                    <h3 class="h5 fw-bold">Search by city</h3>
                    <p class="text-secondary mb-0">Discover apartments for work trips, weekends, relocation windows, and everything in between.</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon mb-3">2</div>
                    <h3 class="h5 fw-bold">Book confidently</h3>
                    <p class="text-secondary mb-0">Every booking is tracked in your dashboard with check-in, check-out, and status details.</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon mb-3">3</div>
                    <h3 class="h5 fw-bold">Manage smoothly</h3>
                    <p class="text-secondary mb-0">Admins get a protected dashboard, user overview, booking table, and Excel exports.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="properties" class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <p class="text-success fw-semibold mb-1">Featured stays</p>
                    <h2 class="fw-bold mb-0">City apartments with a pulse</h2>
                </div>
                <a href="/login" class="btn btn-dark">View dashboard</a>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card property-card border-0 shadow-sm h-100">
                        <img src="https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=900&q=80" class="card-img-top" alt="Marina Apartment">
                        <div class="card-body">
                            <h3 class="h5 fw-bold">Marina Apartment</h3>
                            <p class="text-secondary mb-0">Lekki Phase 1, Lagos</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card property-card border-0 shadow-sm h-100">
                        <img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=900&q=80" class="card-img-top" alt="Garden Loft">
                        <div class="card-body">
                            <h3 class="h5 fw-bold">Garden Loft</h3>
                            <p class="text-secondary mb-0">Maitama, Abuja</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card property-card border-0 shadow-sm h-100">
                        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=900&q=80" class="card-img-top" alt="Quiet City Suite">
                        <div class="card-body">
                            <h3 class="h5 fw-bold">Quiet City Suite</h3>
                            <p class="text-secondary mb-0">Bodija, Ibadan</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<footer class="py-4 bg-dark text-white-50">
    <div class="container d-flex flex-wrap justify-content-between gap-2">
        <span>&copy; 2026 Shortlet</span>
        <span>Temporary accommodation, made calm.</span>
    </div>
</footer>
</body>
</html>
