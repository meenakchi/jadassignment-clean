package model;

import java.math.BigDecimal;

/**
 * BookingDetails entity class representing booking_details table
 */
public class BookingDetail {
    private int bookingDetailId;
    private int bookingId;
    private int serviceId;
    private int quantity;
    private BigDecimal subtotal;
    
    // Extended fields
    private String serviceName;
    private BigDecimal servicePrice;

    public BookingDetail() {}

    public BookingDetail(int bookingId, int serviceId, int quantity, BigDecimal subtotal) {
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    // Getters and Setters
    public int getBookingDetailId() { return bookingDetailId; }
    public void setBookingDetailId(int bookingDetailId) { this.bookingDetailId = bookingDetailId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }
}