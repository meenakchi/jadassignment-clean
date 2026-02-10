package controller.admin;

import dao.BookingDAO;
import dao.MemberDAO;
import dao.ServiceDAO;
import model.Member;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * ClientsByServiceController - Generate report of clients who booked specific services
 * Required: Listing of clients who booked certain care services
 */
@WebServlet("/ClientsByServiceController")
public class ClientsByServiceController extends HttpServlet {
    private BookingDAO bookingDAO;
    private MemberDAO memberDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        memberDAO = new MemberDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        try {
            String serviceIdParam = request.getParameter("service_id");
            
            // Get all services for dropdown
            List<Service> allServices = serviceDAO.getAllServices();
            request.setAttribute("allServices", allServices);
            
            if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
                int serviceId = Integer.parseInt(serviceIdParam);
                Service service = serviceDAO.getServiceById(serviceId);
                
                // Get members who booked this service
                List<Integer> memberIds = bookingDAO.getMembersByService(serviceId);
                List<Member> members = new ArrayList<>();
                
                for (Integer memberId : memberIds) {
                    Member member = memberDAO.getMemberById(memberId);
                    if (member != null) {
                        members.add(member);
                    }
                }
                
                request.setAttribute("service", service);
                request.setAttribute("members", members);
                request.setAttribute("selectedServiceId", serviceId);
            }
            
            request.getRequestDispatcher("/views/admin/clientsByServiceReport.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/clientsByServiceReport.jsp").forward(request, response);
        }
    }
}