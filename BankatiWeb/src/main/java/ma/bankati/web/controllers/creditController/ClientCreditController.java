package ma.bankati.web.controllers.creditController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.credit.CreditRequest.CreditStatus;
import ma.bankati.model.users.User;
import ma.bankati.service.creditService.ICreditService;

@WebServlet(urlPatterns = "/client/credit/*", loadOnStartup = 5)
public class ClientCreditController extends HttpServlet {

    private ICreditService creditService;

    @Override
    public void init() throws ServletException {
        System.out.println("ClientCreditController créé et initialisé");
        creditService = (ICreditService) getServletContext().getAttribute("creditService");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User connectedUser = (User) request.getSession().getAttribute("connectedUser");
        if (connectedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            showClientCredits(request, response, connectedUser);
        } else if (pathInfo.equals("/new")) {
            showNewCreditForm(request, response);
        } else if (pathInfo.equals("/details")) {
            showCreditDetails(request, response, connectedUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/client/credit/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User connectedUser = (User) request.getSession().getAttribute("connectedUser");
        if (connectedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo.equals("/save")) {
            saveNewCreditRequest(request, response, connectedUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/client/credit/list");
        }
    }

    private void showClientCredits(HttpServletRequest request, HttpServletResponse response, User connectedUser)
            throws ServletException, IOException {
        var creditRequests = creditService.getCreditRequestsByClient(connectedUser.getId());
        request.setAttribute("creditRequests", creditRequests);
        request.getRequestDispatcher("/public/credits/list.jsp").forward(request, response);
    }

    private void showNewCreditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/public/credits/form.jsp").forward(request, response);
    }

    private void showCreditDetails(HttpServletRequest request, HttpServletResponse response, User connectedUser)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            CreditRequest creditRequest = creditService.getCreditRequestById(id);

            // Vérifier si la demande appartient bien à l'utilisateur connecté
            if (creditRequest != null && creditRequest.getClientId().equals(connectedUser.getId())) {
                request.setAttribute("creditRequest", creditRequest);
                request.getRequestDispatcher("/public/credits/details.jsp").forward(request, response);
                return;
            }
        }
        // Redirection si la demande n'existe pas ou n'appartient pas à l'utilisateur
        response.sendRedirect(request.getContextPath() + "/client/credit/list");
    }

    private void saveNewCreditRequest(HttpServletRequest request, HttpServletResponse response, User connectedUser)
            throws ServletException, IOException {
        try {
            Double amount = Double.parseDouble(request.getParameter("amount"));
            Integer duration = Integer.parseInt(request.getParameter("duration"));
            String description = request.getParameter("description");

            // Créer la demande de crédit
            CreditRequest newCredit = CreditRequest.builder()
                    .clientId(connectedUser.getId())
                    .amount(amount)
                    .duration(duration)
                    .description(description)
                    .requestDate(LocalDate.now())
                    .status(CreditStatus.PENDING)
                    .build();

            // Enregistrer la demande
            creditService.createCreditRequest(newCredit);

            // Message de succès et redirection
            request.getSession().setAttribute("successMessage", "Votre demande de crédit a été soumise avec succès.");
            response.sendRedirect(request.getContextPath() + "/client/credit/list");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Veuillez saisir des valeurs numériques valides.");
            request.getRequestDispatcher("/public/credits/form.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        System.out.println("ClientCreditController détruit");
    }
}