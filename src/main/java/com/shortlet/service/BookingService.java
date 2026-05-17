package com.shortlet.service;

import com.shortlet.model.Booking;
import com.shortlet.model.Property;
import com.shortlet.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BookingService {
    public List<Booking> findByUser(long userId) throws SQLException {
        return queryBookings("""
                SELECT b.id, b.user_id, u.name AS user_name, u.email AS user_email, u.password_hash,
                       p.title AS apartment_title, p.city, p.nightly_rate,
                       b.check_in, b.check_out, b.nights, b.total_amount, b.payment_method, b.payment_status,
                       b.status, b.created_at
                FROM bookings b
                JOIN users u ON u.id = b.user_id
                JOIN properties p ON p.id = b.property_id
                WHERE b.user_id = ?
                ORDER BY b.check_in
                """, userId);
    }

    public List<Booking> findAllWithUsers() throws SQLException {
        return queryBookings("""
                SELECT b.id, u.id AS user_id, u.name AS user_name, u.email AS user_email, u.password_hash,
                       p.title AS apartment_title, p.city, p.nightly_rate,
                       b.check_in, b.check_out, b.nights, b.total_amount, b.payment_method, b.payment_status,
                       COALESCE(b.status, 'NO_BOOKING') AS status, b.created_at
                FROM users u
                LEFT JOIN bookings b ON b.user_id = u.id
                LEFT JOIN properties p ON p.id = b.property_id
                ORDER BY u.id, b.created_at DESC
                """);
    }

    public List<Property> searchProperties(String city) throws SQLException {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE (? IS NULL OR LOWER(city) LIKE ?) ORDER BY nightly_rate";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String filter = city == null || city.isBlank() ? null : "%" + city.toLowerCase() + "%";
            statement.setString(1, filter);
            statement.setString(2, filter);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Property property = new Property();
                    property.setId(rs.getLong("id"));
                    property.setTitle(rs.getString("title"));
                    property.setCity(rs.getString("city"));
                    property.setAddress(rs.getString("address"));
                    property.setNightlyRate(rs.getBigDecimal("nightly_rate"));
                    property.setImageUrl(rs.getString("image_url"));
                    property.setSourceUrl(rs.getString("source_url"));
                    properties.add(property);
                }
            }
        }
        return properties;
    }

    public Optional<Property> findPropertyById(long propertyId) throws SQLException {
        String sql = "SELECT * FROM properties WHERE id = ?";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, propertyId);
            try (ResultSet rs = statement.executeQuery()) {
                if (!rs.next()) {
                    return Optional.empty();
                }
                Property property = new Property();
                property.setId(rs.getLong("id"));
                property.setTitle(rs.getString("title"));
                property.setCity(rs.getString("city"));
                property.setAddress(rs.getString("address"));
                property.setNightlyRate(rs.getBigDecimal("nightly_rate"));
                property.setImageUrl(rs.getString("image_url"));
                property.setSourceUrl(rs.getString("source_url"));
                return Optional.of(property);
            }
        }
    }

    public Booking createBooking(long userId, long propertyId, LocalDate checkIn, LocalDate checkOut, String paymentMethod) throws SQLException {
        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("Check-out date must be after check-in date.");
        }
        Property property = findPropertyById(propertyId)
                .orElseThrow(() -> new IllegalArgumentException("Selected apartment was not found."));
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        BigDecimal total = property.getNightlyRate().multiply(BigDecimal.valueOf(nights));
        String normalizedPaymentMethod = normalizePaymentMethod(paymentMethod);
        String status = "PAY_ON_ARRIVAL".equals(normalizedPaymentMethod) ? "RESERVED" : "CONFIRMED";
        String paymentStatus = "PAY_ON_ARRIVAL".equals(normalizedPaymentMethod) ? "PENDING" : "PAYMENT_METHOD_SELECTED";

        String sql = """
                INSERT INTO bookings(user_id, property_id, check_in, check_out, nights, total_amount, payment_method, payment_status, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, userId);
            statement.setLong(2, propertyId);
            statement.setDate(3, java.sql.Date.valueOf(checkIn));
            statement.setDate(4, java.sql.Date.valueOf(checkOut));
            statement.setLong(5, nights);
            statement.setBigDecimal(6, total);
            statement.setString(7, normalizedPaymentMethod);
            statement.setString(8, paymentStatus);
            statement.setString(9, status);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                keys.next();
                long bookingId = keys.getLong(1);
                return queryBookings("""
                        SELECT b.id, b.user_id, u.name AS user_name, u.email AS user_email, u.password_hash,
                               p.title AS apartment_title, p.city, p.nightly_rate,
                               b.check_in, b.check_out, b.nights, b.total_amount, b.payment_method, b.payment_status,
                               b.status, b.created_at
                        FROM bookings b
                        JOIN users u ON u.id = b.user_id
                        JOIN properties p ON p.id = b.property_id
                        WHERE b.id = ?
                        """, bookingId).get(0);
            }
        }
    }

    private String normalizePaymentMethod(String paymentMethod) {
        if (paymentMethod == null) {
            return "PAY_ON_ARRIVAL";
        }
        return switch (paymentMethod) {
            case "CARD", "BANK_TRANSFER", "USSD", "PAY_ON_ARRIVAL" -> paymentMethod;
            default -> "PAY_ON_ARRIVAL";
        };
    }

    private List<Booking> queryBookings(String sql, Object... params) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                statement.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getLong("id"));
                    booking.setUserId(rs.getLong("user_id"));
                    booking.setUserName(rs.getString("user_name"));
                    booking.setUserEmail(rs.getString("user_email"));
                    booking.setPasswordHash(rs.getString("password_hash"));
                    booking.setApartmentTitle(rs.getString("apartment_title"));
                    booking.setCity(rs.getString("city"));
                    booking.setNightlyRate(rs.getBigDecimal("nightly_rate"));
                    booking.setCheckIn(rs.getDate("check_in") == null ? null : rs.getDate("check_in").toLocalDate());
                    booking.setCheckOut(rs.getDate("check_out") == null ? null : rs.getDate("check_out").toLocalDate());
                    booking.setNights(rs.getLong("nights"));
                    booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                    booking.setPaymentMethod(rs.getString("payment_method"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setStatus(rs.getString("status"));
                    booking.setCreatedAt(rs.getTimestamp("created_at") == null ? null : rs.getTimestamp("created_at").toLocalDateTime());
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
}
