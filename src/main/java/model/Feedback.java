package model;

import java.sql.Timestamp;

/**
 * Feedback entity class representing feedback table
 */
public class Feedback {
    private int feedbackId;
    private int memberId;
    private int bookingId;
    private int serviceId;
    private int rating; // 1-5
    private String comments;
    private Timestamp createdAt;
    
    // Extended fields
    private String memberName;
    private String serviceName;

    public Feedback() {}

    public Feedback(int memberId, int serviceId, int rating, String comments) {
        this.memberId = memberId;
        this.serviceId = serviceId;
        this.rating = rating;
        this.comments = comments;
    }

    // Getters and Setters
    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
}