package com.shortlet.servlet;

import com.shortlet.model.Booking;
import com.shortlet.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ExportExcelServlet extends HttpServlet {
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            List<Booking> bookings = bookingService.findAllWithUsers();
            Sheet sheet = workbook.createSheet("Bookings");
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            String[] headers = {"ID", "Name", "Email", "Check-in", "Check-out", "Apartment Title", "Status"};
            Row header = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                header.createCell(i).setCellValue(headers[i]);
                header.getCell(i).setCellStyle(headerStyle);
            }

            for (int i = 0; i < bookings.size(); i++) {
                Booking booking = bookings.get(i);
                Row row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(booking.getId());
                row.createCell(1).setCellValue(booking.getUserName());
                row.createCell(2).setCellValue(booking.getUserEmail());
                row.createCell(3).setCellValue(booking.getCheckIn().toString());
                row.createCell(4).setCellValue(booking.getCheckOut().toString());
                row.createCell(5).setCellValue(booking.getApartmentTitle());
                row.createCell(6).setCellValue(booking.getStatus());
            }
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"shortlet-bookings.xlsx\"");
            workbook.write(response.getOutputStream());
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
