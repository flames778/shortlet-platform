<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>User Dashboard - Shortlet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f7f8fb; }
        .brand-mark { width: 34px; height: 34px; border-radius: 9px; background: #16c79a; display: inline-grid; place-items: center; color: #041221; font-weight: 800; }
        .page-band { background: #071827; color: white; }
        .property-img { height: 180px; object-fit: cover; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="/dashboard"><span class="brand-mark">S</span> Shortlet</a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <span class="text-white-50 d-none d-md-inline">${sessionScope.user.name}</span>
            <a href="/logout" class="btn btn-outline-light btn-sm">Logout</a>
        </div>
    </div>
</nav>

<section class="page-band py-5">
    <div class="container">
        <p class="text-success fw-semibold mb-1">Your stay command center</p>
        <h1 class="fw-bold mb-2">Hello, ${sessionScope.user.name}</h1>
        <p class="lead mb-0">Track upcoming bookings and discover apartments for your next city stop.</p>
    </div>
</section>

<main class="container py-5">
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 fw-bold mb-0">My bookings</h2>
                <span class="badge text-bg-success">${bookings.size()} total</span>
            </div>
            <div class="table-responsive bg-white shadow-sm rounded">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Apartment</th>
                        <th>City</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="booking" items="${bookings}">
                        <tr>
                            <td class="fw-semibold">${booking.apartmentTitle}</td>
                            <td>${booking.city}</td>
                            <td>${booking.checkIn}</td>
                            <td>${booking.checkOut}</td>
                            <td><span class="badge text-bg-${booking.status == 'CONFIRMED' ? 'success' : 'warning'}">${booking.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bookings}">
                        <tr><td colspan="5" class="text-center text-secondary py-4">No bookings yet.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-lg-5">
            <h2 class="h4 fw-bold mb-3">Search properties</h2>
            <form class="d-flex gap-2 mb-3" action="/dashboard" method="get">
                <input class="form-control" type="search" name="city" value="${city}" placeholder="Try Lagos, Abuja, Ibadan">
                <button class="btn btn-dark" type="submit">Search</button>
            </form>
            <div class="row g-3">
                <c:forEach var="property" items="${properties}">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm">
                            <img class="card-img-top property-img" src="${property.imageUrl}" alt="${property.title}">
                            <div class="card-body">
                                <div class="d-flex justify-content-between gap-3">
                                    <div>
                                        <h3 class="h5 fw-bold">${property.title}</h3>
                                        <p class="text-secondary mb-0">${property.address}</p>
                                    </div>
                                    <div class="text-end fw-bold">$${property.nightlyRate}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</main>

<footer class="py-4 bg-white border-top">
    <div class="container text-secondary small">Shortlet &copy; 2026</div>
</footer>
</body>
</html>
