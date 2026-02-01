package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Booking entity class representing bookings table
 */
public class Booking {
    private int bookingId;
    private int memberId;
    private Date bookingDate;
    private Time bookingTime;
    private BigDecimal totalAmount;
    private String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
    private String specialRequests;
    private Timestamp createdAt;
    
    // Extended fields
    private String memberName;
    private String memberEmail;

    public Booking() {}

    public Booking(int memberId, Date bookingDate, Time bookingTime, 
                   BigDecimal totalAmount, String status) {
        this.memberId = memberId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public Time getBookingTime() { return bookingTime; }
    public void setBookingTime(Time bookingTime) { this.bookingTime = bookingTime; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSpecialRequests() { return specialRequests; }
    public void setSpecialRequests(String specialRequests) { this.specialRequests = specialRequests; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getMemberEmail() { return memberEmail; }
    public void setMemberEmail(String memberEmail) { this.memberEmail = memberEmail; }
}
