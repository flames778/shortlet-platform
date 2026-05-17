<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200">
    <title>User Dashboard - Shortlet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f7f8fb; min-width: 1200px; color: #152033; }
        .brand-mark { width: 34px; height: 34px; border-radius: 9px; background: #16c79a; display: inline-grid; place-items: center; color: #041221; font-weight: 800; }
        .page-band { background: #071827; color: white; }
        .property-card { overflow: hidden; border-radius: 12px; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .property-card:hover { transform: translateY(-4px); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08) !important; }
        .property-img { height: 190px; object-fit: cover; }
        .booking-form { background: #f8f9fa; border-radius: 8px; }
        .btn-success { background: #16c79a; border-color: #16c79a; color: #041221; font-weight: 600; }
        .btn-success:hover { background: #13b58c; border-color: #13b58c; color: #041221; }
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
    <c:if test="${param.booked == 'true'}">
        <div class="alert alert-success shadow-sm">Apartment booked successfully. Your payment method has been recorded.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger shadow-sm">${error}</div>
    </c:if>
    <div class="row g-4">
        <!-- Search Properties Section (Left, wider column) -->
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 fw-bold mb-0">Search properties</h2>
                <form class="d-flex gap-2 mb-0" action="/dashboard" method="get" style="max-width: 400px; width: 100%;">
                    <input class="form-control" type="search" name="city" value="${city}" placeholder="Try Lagos, Abuja, Ibadan, Kano">
                    <button class="btn btn-dark" type="submit">Search</button>
                </form>
            </div>
            <div class="row g-3">
                <c:forEach var="property" items="${properties}">
                    <div class="col-md-6">
                        <div class="card property-card border-0 shadow-sm h-100">
                            <img class="card-img-top property-img" src="${property.imageUrl}" alt="${property.title}">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start gap-2 mb-2">
                                        <h3 class="h5 fw-bold mb-0">${property.title}</h3>
                                        <div class="text-end fw-bold text-success">&#8358;${property.nightlyRate}<span class="d-block text-secondary fw-normal small">/ night</span></div>
                                    </div>
                                    <p class="text-secondary small mb-3">${property.address}</p>
                                </div>
                                <div>
                                    <button class="btn btn-success w-100 fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#bookingForm-${property.id}" aria-expanded="false" aria-controls="bookingForm-${property.id}">
                                        Book apartment
                                    </button>
                                    
                                    <div class="collapse" id="bookingForm-${property.id}">
                                        <form class="booking-form p-3 mt-3 border bg-light" method="post" action="/dashboard">
                                            <input type="hidden" name="propertyId" value="${property.id}">
                                            <div class="row g-2">
                                                <div class="col-sm-6">
                                                    <label class="form-label small fw-semibold">Check-in</label>
                                                    <input class="form-control" type="date" name="checkIn" required>
                                                </div>
                                                <div class="col-sm-6">
                                                    <label class="form-label small fw-semibold">Check-out</label>
                                                    <input class="form-control" type="date" name="checkOut" required>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label small fw-semibold">Payment method</label>
                                                    <select class="form-select" name="paymentMethod" required>
                                                        <option value="CARD">Card</option>
                                                        <option value="BANK_TRANSFER">Bank transfer</option>
                                                        <option value="USSD">USSD</option>
                                                        <option value="PAY_ON_ARRIVAL">Pay on arrival</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <button class="btn btn-dark w-100 mt-3" type="submit">Confirm Booking</button>
                                            <c:if test="${not empty property.sourceUrl}">
                                                <a class="small d-inline-block mt-2 text-secondary" href="${property.sourceUrl}" target="_blank" rel="noopener">Listing reference</a>
                                            </c:if>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty properties}">
                    <div class="col-12">
                        <div class="text-center text-secondary py-5 bg-white rounded shadow-sm">
                            <p class="mb-0">No properties found matching "${city}".</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- My Bookings Section (Right, sidebar column) -->
        <div class="col-lg-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 fw-bold mb-0">My bookings</h2>
                <span class="badge bg-success rounded-pill px-3">${bookings.size()} total</span>
            </div>
            
            <div class="d-flex flex-column gap-3">
                <c:forEach var="booking" items="${bookings}">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2 gap-2">
                                <h3 class="h6 fw-bold mb-0 text-truncate" style="max-width: 180px;">${booking.apartmentTitle}</h3>
                                <span class="badge text-bg-${booking.status == 'CONFIRMED' ? 'success' : 'warning'}">${booking.status}</span>
                            </div>
                            <p class="text-secondary small mb-3">${booking.city}</p>
                            
                            <div class="row g-2 border-top pt-2 text-secondary small">
                                <div class="col-6">
                                    <span class="d-block fw-semibold text-dark">Check-in</span>
                                    ${booking.checkIn}
                                </div>
                                <div class="col-6">
                                    <span class="d-block fw-semibold text-dark">Check-out</span>
                                    ${booking.checkOut}
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                                <span class="text-secondary small font-monospace">${booking.paymentMethod}</span>
                                <span class="fw-bold text-success">&#8358;${booking.totalAmount}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty bookings}">
                    <div class="text-center text-secondary py-5 bg-white rounded shadow-sm">
                        <p class="mb-0 small fw-semibold">No bookings yet.</p>
                        <p class="mb-0 text-muted small">Choose an apartment to get started!</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<footer class="py-4 bg-white border-top">
    <div class="container text-secondary small">Shortlet &copy; 2026</div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
