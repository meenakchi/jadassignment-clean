package model;

import java.math.BigDecimal;

/**
 * CartItem entity class representing items in shopping cart
 */
public class CartItem {
    private int cartId;
    private int memberId;
    private int serviceId;
    private int quantity;
    
    // Extended fields from JOIN queries
    private String serviceName;
    private BigDecimal servicePrice;
    private String imageUrl;
    private int duration;

    public CartItem() {}

    public CartItem(int cartId, int memberId, int serviceId, int quantity) {
        this.cartId = cartId;
        this.memberId = memberId;
        this.serviceId = serviceId;
        this.quantity = quantity;
    }

    // Calculated field
    public BigDecimal getSubtotal() {
        if (servicePrice != null) {
            return servicePrice.multiply(new BigDecimal(quantity));
        }
        return BigDecimal.ZERO;
    }

    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
}