package ma.bankati.web.controllers.creditController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.credit.CreditRequest.CreditStatus;
import ma.bankati.model.users.ERole;
import ma.bankati.model.users.User;
import ma.bankati.service.creditService.ICreditService;

@WebServlet(urlPatterns = "/admin/credits/*", loadOnStartup = 6)
public class AdminCreditController extends HttpServlet {

    private ICreditService creditService;

    @Override
    public void init() throws ServletException {
        System.out.println("AdminCreditController créé et initialisé");
        creditService = (ICreditService) getServletContext().getAttribute("creditService");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User connectedUser = (User) request.getSession().getAttribute("connectedUser");
        if (connectedUser == null || !ERole.ADMIN.equals(connectedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            showAllCredits(request, response);
        } else if (pathInfo.equals("/details")) {
            showCreditDetails(request, response);
        } else if (pathInfo.equals("/pending")) {
            showPendingCredits(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/credits/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User connectedUser = (User) request.getSession().getAttribute("connectedUser");
        if (connectedUser == null || !ERole.ADMIN.equals(connectedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo.equals("/process")) {
            processCreditRequest(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/credits/list");
        }
    }

    private void showAllCredits(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CreditRequest> credits = creditService.findAll();
        request.setAttribute("credits", credits);

        request.getRequestDispatcher("/admin/credits/list.jsp").forward(request, response);
    }

    private void showPendingCredits(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Utilisez findByStatus au lieu de getCreditRequestsByStatus pour éviter le problème
        List<CreditRequest> pendingCredits = creditService.findByStatus(CreditStatus.PENDING);
        request.setAttribute("credits", pendingCredits);
        request.setAttribute("statusFilter", "pending");
        request.getRequestDispatcher("/admin/credits/list.jsp").forward(request, response);
    }

    private void showCreditDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            CreditRequest creditRequest = creditService.findById(id);

            if (creditRequest != null) {
                request.setAttribute("creditRequest", creditRequest);
                request.getRequestDispatcher("/admin/credits/details.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/credits/list");
    }

    private void processCreditRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String decision = request.getParameter("decision");
        String reason = request.getParameter("reason");

        if (idStr != null && !idStr.isEmpty() && decision != null) {
            try {
                Long id = Long.parseLong(idStr);
                CreditRequest creditRequest = creditService.findById(id);

                if (creditRequest != null && creditRequest.getStatus() == CreditStatus.PENDING) {
                    // Mise à jour du statut
                    if ("approve".equals(decision)) {
                        creditService.approveCreditRequest(id, reason);
                    } else if ("reject".equals(decision)) {
                        creditService.rejectCreditRequest(id, reason);
                    }

                    request.getSession().setAttribute("successMessage",
                            "La demande de crédit #" + id + " a été traitée avec succès.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID de demande invalide.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/credits/list");
    }

    @Override
    public void destroy() {
        System.out.println("AdminCreditController détruit");
    }
}