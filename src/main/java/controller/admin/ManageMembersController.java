package controller.admin;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageMembersController")
public class ManageMembersController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int memberId = Integer.parseInt(request.getParameter("id"));
                boolean success = memberDAO.deleteMember(memberId);
                
                if (success) {
                    session.setAttribute("message", "Member deleted successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to delete member");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/ManageMembersController");
                return;
            }
            
            // ADD THIS: Edit form
            else if ("edit".equals(action)) {
                int memberId = Integer.parseInt(request.getParameter("id"));
                Member member = memberDAO.getMemberById(memberId);
                
                request.setAttribute("member", member);
                request.setAttribute("editMode", true);
                request.getRequestDispatcher("/views/admin/editMember.jsp").forward(request, response);
                return;
            }
            
            // ADD THIS: Create form
            else if ("create".equals(action)) {
                request.getRequestDispatcher("/views/admin/createMember.jsp").forward(request, response);
                return;
            }

            // Default: List all members
            List<Member> members = memberDAO.getAllMembers();
            request.setAttribute("members", members);

            request.getRequestDispatcher("/manageMembers.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/manageMembers.jsp").forward(request, response);
        }
    }
    
    // ADD THIS: Handle Create and Update
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                // CREATE new member
                Member member = new Member();
                member.setUsername(request.getParameter("username"));
                member.setPassword(request.getParameter("password"));
                member.setEmail(request.getParameter("email"));
                member.setFullName(request.getParameter("full_name"));
                member.setPhone(request.getParameter("phone"));
                member.setAddress(request.getParameter("address"));
                
                String dob = request.getParameter("date_of_birth");
                if (dob != null && !dob.isEmpty()) {
                    member.setDateOfBirth(Date.valueOf(dob));
                }

                boolean success = memberDAO.registerMember(member);
                
                if (success) {
                    session.setAttribute("message", "Member created successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to create member");
                    session.setAttribute("messageType", "error");
                }
                
            } else if ("update".equals(action)) {
                // UPDATE existing member
                int memberId = Integer.parseInt(request.getParameter("member_id"));
                Member member = memberDAO.getMemberById(memberId);
                
                if (member != null) {
                    member.setFullName(request.getParameter("full_name"));
                    member.setEmail(request.getParameter("email"));
                    member.setPhone(request.getParameter("phone"));
                    member.setAddress(request.getParameter("address"));
                    
                    String dob = request.getParameter("date_of_birth");
                    if (dob != null && !dob.isEmpty()) {
                        member.setDateOfBirth(Date.valueOf(dob));
                    }

                    boolean success = memberDAO.updateMember(member);
                    
                    if (success) {
                        session.setAttribute("message", "Member updated successfully!");
                        session.setAttribute("messageType", "success");
                    } else {
                        session.setAttribute("message", "Failed to update member");
                        session.setAttribute("messageType", "error");
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/ManageMembersController");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageMembersController");
        }
    }
}