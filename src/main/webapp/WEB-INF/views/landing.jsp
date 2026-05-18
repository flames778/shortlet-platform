<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200">
    <title>Shortlet - Stay where the city happens</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
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
        .partner-logo { height: 32px; filter: grayscale(100%); opacity: 0.5; }
        .team-photo { width: 110px; height: 110px; object-fit: cover; }
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
        <div class="col-lg-8">
            <span class="badge rounded-pill text-bg-success mb-3">Short stays, serious comfort</span>
            <h1 class="display-3 fw-bold mb-4">Shortlet</h1>
            <p class="lead fs-3 mb-4">Book stylish temporary apartments across the city, or list your property for trusted guests.</p>
            
            <!-- Immediate Search Bar -->
            <div class="card bg-white p-3 shadow-lg">
                <form action="/search" method="get" class="row g-2 align-items-center">
                    <div class="col-md-4 text-dark">
                        <label class="small fw-bold mb-1">City</label>
                        <input type="text" name="city" class="form-control" placeholder="Lagos, Abuja, Ibadan..." required>
                    </div>
                    <div class="col-md-3 text-dark">
                        <label class="small fw-bold mb-1">Check-in</label>
                        <input type="date" name="checkin" class="form-control">
                    </div>
                    <div class="col-md-3 text-dark">
                        <label class="small fw-bold mb-1">Guests</label>
                        <select name="guests" class="form-select">
                            <option value="1">1 Guest</option>
                            <option value="2">2 Guests</option>
                            <option value="3">3 Guests</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="d-none d-md-block mb-1">&nbsp;</label>
                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Search</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</header>

<main>
    <!-- Trust Badges Section -->
    <div class="bg-white py-3 border-bottom shadow-sm">
        <div class="container d-flex justify-content-center gap-4 flex-wrap text-muted small fw-semibold">
            <span><i class="bi bi-check-circle-fill text-success"></i> 500+ happy guests</span>
            <span><i class="bi bi-star-fill text-warning"></i> 4.8 average rating</span>
            <span><i class="bi bi-shield-lock-fill text-primary"></i> Secure payments</span>
            <span><i class="bi bi-house-check-fill text-info"></i> Verified properties</span>
        </div>
    </div>

    <!-- Partners Section -->
    <section class="py-4 border-bottom">
        <div class="container text-center">
            <div class="d-flex justify-content-center align-items-center gap-4 gap-md-5 flex-wrap">
                <img src="/images/partners/jiji.jpg" alt="Jiji" class="partner-logo">
                <img src="/images/partners/airbnb.jpg" alt="Airbnb" class="partner-logo">
                <img src="/images/partners/google.jpg" alt="Google" class="partner-logo">
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5 bg-white">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-icon mb-3"><i class="bi bi-search"></i></div>
                    <h3 class="h5 fw-bold">Search by city</h3>
                    <p class="text-secondary mb-0">Discover apartments for work trips, weekends, relocation windows, and everything in between.</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon mb-3"><i class="bi bi-calendar-check"></i></div>
                    <h3 class="h5 fw-bold">Book confidently</h3>
                    <p class="text-secondary mb-0">Every booking is tracked in your dashboard with check-in, check-out, and status details.</p>
                </div>
                <div class="col-md-4">
                    <div class="feature-icon mb-3"><i class="bi bi-kanban"></i></div>
                    <h3 class="h5 fw-bold">Manage smoothly</h3>
                    <p class="text-secondary mb-0">Admins get a protected dashboard, user overview, booking table, and Excel exports.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Properties Section -->
    <section id="properties" class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <p class="text-success fw-semibold mb-1">Featured stays</p>
                    <h2 class="fw-bold mb-0">City apartments with a pulse</h2>
                </div>
                <a href="/login" class="btn btn-dark">View more</a>
            </div>
            <div class="row g-4">
                <c:forEach var="property" items="${featuredProperties}">
                    <div class="col-md-4">
                        <div class="card property-card border-0 shadow-sm h-100">
                            <img src="${property.imageUrl}" class="card-img-top" alt="${property.title}">
                            <div class="card-body">
                                <h3 class="h5 fw-bold mb-1">${property.title}</h3>
                                <p class="text-secondary small mb-2">${property.address}, ${property.city}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold">₦${property.nightlyRate} <span class="text-muted small fw-normal">/ night</span></span>
                                    <span class="text-warning small"><i class="bi bi-star-fill"></i> ${property.rating}</span>
                                </div>
                                <a href="property.jsp?id=${property.id}" class="btn btn-outline-success btn-sm w-100 mt-3">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="fw-bold text-center mb-5">What our guests say</h2>
            <div class="row g-4">
                <c:forEach var="t" items="${testimonials}">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm h-100 p-3">
                            <c:if test="${not empty t.propertyTitle}">
                                <div class="d-flex align-items-center gap-3 p-2 mb-3 rounded-3" style="background: rgba(22, 199, 154, 0.08); border: 1px solid rgba(22, 199, 154, 0.15);">
                                    <img src="${t.propertyImageUrl}" alt="${t.propertyTitle}" class="rounded-2" style="width: 64px; height: 64px; object-fit: cover;">
                                    <div style="min-width: 0;">
                                        <div class="text-success small fw-bold mb-0" style="font-size: 0.75rem;"><i class="bi bi-house-heart"></i> Stayed at</div>
                                        <div class="fw-bold text-dark text-truncate small mb-0" title="${t.propertyTitle}">${t.propertyTitle}</div>
                                    </div>
                                </div>
                            </c:if>
                            <div class="text-warning mb-2">
                                <c:forEach begin="1" end="${t.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                            </div>
                            <p class="fst-italic mb-3">"${t.quote}"</p>
                            <div class="d-flex align-items-center gap-2 mt-auto">
                                <div class="fw-bold">${t.guestName}</div>
                                <div class="text-muted small">&bull; ${t.location}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="py-5">
        <div class="container text-center">
            <h2 class="fw-bold mb-2">The Team Behind Shortlet</h2>
            <p class="text-secondary mb-5">Meet the creators dedicated to elevating your short-term stay experience.</p>
            <div class="row g-4 justify-content-center">
                <c:forEach var="member" items="${team}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card border-0 shadow-sm h-100 py-4 px-3">
                            <div class="card-body">
                                <img src="${member.imageUrl}" alt="${member.name}" class="rounded-circle mb-3 team-photo shadow-sm">
                                <h3 class="h5 fw-bold mb-1">${member.name}</h3>
                                <p class="text-success small fw-semibold mb-3">${member.role}</p>
                                <p class="text-secondary mb-0 small">${member.bio}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<footer class="py-4 bg-dark text-white-50">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <h5 class="text-white mb-3">Shortlet</h5>
                <p class="small">Premium temporary accommodation in Nigeria's pulse cities. Stylish stays for work, weekends, and relocation.</p>
            </div>
            <div class="col-md-2 offset-md-2">
                <h6 class="text-white mb-3">Support</h6>
                <ul class="list-unstyled small">
                    <li><a href="#" class="text-white-50 text-decoration-none">Help Center</a></li>
                    <li><a href="#" class="text-white-50 text-decoration-none">Safety</a></li>
                    <li><a href="#" class="text-white-50 text-decoration-none">Cancellation</a></li>
                </ul>
            </div>
            <div class="col-md-2">
                <h6 class="text-white mb-3">Legal</h6>
                <ul class="list-unstyled small">
                    <li><a href="#" class="text-white-50 text-decoration-none">Privacy</a></li>
                    <li><a href="#" class="text-white-50 text-decoration-none">Terms</a></li>
                </ul>
            </div>
            <div class="col-md-2">
                <h6 class="text-white mb-3">Connect</h6>
                <div class="d-flex gap-3 fs-5">
                    <i class="bi bi-facebook"></i>
                    <i class="bi bi-twitter-x"></i>
                    <i class="bi bi-instagram"></i>
                </div>
            </div>
        </div>
        <hr class="border-secondary">
        <div class="d-flex flex-wrap justify-content-between gap-2 small">
            <span>&copy; 2026 Shortlet. All rights reserved.</span>
            <span>Temporary accommodation, made calm.</span>
        </div>
    </div>
</footer>
</body>
</html>
