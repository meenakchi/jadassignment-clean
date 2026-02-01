package controller.member;

import dao.FeedbackDAO;
import dao.BookingDAO;
import model.Feedback;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/SubmitFeedbackController")
public class SubmitFeedbackController extends HttpServlet {
    private FeedbackDAO feedbackDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        String bookingIdParam = request.getParameter("booking_id");
        
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            // Verify booking belongs to member and is completed
            int memberId = (Integer) session.getAttribute("member_id");
            if (booking != null && booking.getMemberId() == memberId 
                && "COMPLETED".equals(booking.getStatus())) {
                
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/views/member/submitFeedback.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        int memberId = (Integer) session.getAttribute("member_id");
        
        try {
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            int serviceId = Integer.parseInt(request.getParameter("service_id"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            Feedback feedback = new Feedback();
            feedback.setMemberId(memberId);
            feedback.setBookingId(bookingId);
            feedback.setServiceId(serviceId);
            feedback.setRating(rating);
            feedback.setComments(comments);

            boolean success = feedbackDAO.addFeedback(feedback);

            if (success) {
                session.setAttribute("message", "Thank you for your feedback!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to submit feedback");
                session.setAttribute("messageType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/BookingHistoryController");

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
        }
    }
}