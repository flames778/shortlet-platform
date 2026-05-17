package com.shortlet.service;

import com.shortlet.model.Booking;
import com.shortlet.model.Property;
import com.shortlet.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    public List<Booking> findByUser(long userId) throws SQLException {
        return queryBookings("WHERE b.user_id = ? ORDER BY b.check_in", userId);
    }

    public List<Booking> findAllWithUsers() throws SQLException {
        return queryBookings("ORDER BY b.id");
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
                    properties.add(property);
                }
            }
        }
        return properties;
    }

    private List<Booking> queryBookings(String suffix, Object... params) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = """
                SELECT b.id, b.user_id, u.name AS user_name, u.email AS user_email, p.title AS apartment_title,
                       p.city, b.check_in, b.check_out, b.status
                FROM bookings b
                JOIN users u ON u.id = b.user_id
                JOIN properties p ON p.id = b.property_id
                """ + suffix;
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
                    booking.setApartmentTitle(rs.getString("apartment_title"));
                    booking.setCity(rs.getString("city"));
                    booking.setCheckIn(rs.getDate("check_in").toLocalDate());
                    booking.setCheckOut(rs.getDate("check_out").toLocalDate());
                    booking.setStatus(rs.getString("status"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
}
