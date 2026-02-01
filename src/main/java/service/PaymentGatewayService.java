package service;

import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import model.Booking;
import java.math.BigDecimal;

public class PaymentGatewayService {
    
    public String createStripeSession(Booking booking) throws Exception {
        System.out.println("╔════════════════════════════════════╗");
        System.out.println("║   CREATING STRIPE SESSION          ║");
        System.out.println("╚════════════════════════════════════╝");
        
        // Use test key from environment variable
        Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");
        
        // If env variable not set, use test key directly (for development)
        if (Stripe.apiKey == null || Stripe.apiKey.isEmpty()) {
        } else {
            System.out.println("✓ Using environment variable STRIPE_SECRET_KEY");
        }
        
        long amountInCents = booking.getTotalAmount().multiply(new BigDecimal(100)).longValue();
        System.out.println("✓ Amount in cents: " + amountInCents);
        
        String successUrl = "http://localhost:8080/jadassignment/PaymentSuccessController?session_id={CHECKOUT_SESSION_ID}&booking_id=" + booking.getBookingId();
        String cancelUrl = "http://localhost:8080/jadassignment/payment/cancel?booking_id=" + booking.getBookingId();
        
        System.out.println("✓ Success URL: " + successUrl);
        System.out.println("✓ Cancel URL: " + cancelUrl);
        
        SessionCreateParams params = SessionCreateParams.builder()
            .addPaymentMethodType(SessionCreateParams.PaymentMethodType.CARD)
            .setMode(SessionCreateParams.Mode.PAYMENT)
            .setSuccessUrl(successUrl)
            .setCancelUrl(cancelUrl)
            .addLineItem(
                SessionCreateParams.LineItem.builder()
                    .setQuantity(1L)
                    .setPriceData(
                        SessionCreateParams.LineItem.PriceData.builder()
                            .setCurrency("sgd")
                            .setUnitAmount(amountInCents)
                            .setProductData(
                                SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                    .setName("Silver Care Services - Booking #" + booking.getBookingId())
                                    .setDescription("Elderly care service booking")
                                    .build())
                            .build())
                    .build())
            .build();
        
        System.out.println("➤ Creating Stripe session...");
        Session session = Session.create(params);
        
        String checkoutUrl = session.getUrl();
        System.out.println("✓ Session created successfully!");
        System.out.println("✓ Checkout URL: " + checkoutUrl);
        System.out.println("════════════════════════════════════\n");
        
        return checkoutUrl;
    }
}