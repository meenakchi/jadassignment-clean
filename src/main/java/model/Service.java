package model;

import java.math.BigDecimal;

/**
 * Service entity class representing the service table
 * Maps to database table: service
 */
public class Service {
    private int serviceId;
    private int categoryId;
    private String serviceName;
    private String description;
    private BigDecimal price;
    private int duration; // in minutes
    private String imageUrl;
    private boolean isActive;
    private String categoryName; // For join queries

    // Default constructor
    public Service() {
    }

    // Constructor for basic service
    public Service(int serviceId, String serviceName, BigDecimal price, int duration) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.duration = duration;
    }

    // Full constructor
    public Service(int serviceId, int categoryId, String serviceName, String description,
                   BigDecimal price, int duration, String imageUrl, boolean isActive) {
        this.serviceId = serviceId;
        this.categoryId = categoryId;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", categoryId=" + categoryId +
                ", serviceName='" + serviceName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", duration=" + duration +
                ", imageUrl='" + imageUrl + '\'' +
                ", isActive=" + isActive +
                ", categoryName='" + categoryName + '\'' +
                '}';
    }
}