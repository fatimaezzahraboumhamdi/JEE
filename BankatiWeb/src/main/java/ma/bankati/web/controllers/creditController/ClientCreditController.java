
package ma.bankati.web.controllers.creditController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.users.User;
import ma.bankati.service.creditService.ICreditService;

/**
 * Contrôleur pour les clients leur permettant de gérer leurs demandes de crédit
 */
@WebServlet(urlPatterns = {"/client/credits/*"}, loadOnStartup = 5)
public class ClientCreditController extends HttpServlet {

    private ICreditService creditService;

    @Override
    public void init() throws ServletException {
        System.out.println("ClientCreditController créé et initialisé");
        creditService = (ICreditService) getServletContext().getAttribute("creditService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        // Récupération de l'utilisateur connecté
        User user = (User) req.getSession().getAttribute("connectedUser");

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // Liste des demandes de crédit du client
            showClientCredits(req, resp, user);
        } else if (pathInfo.equals("/new")) {
            // Formulaire de nouvelle demande
            newCreditForm(req, resp);
        } else if (pathInfo.equals("/delete")) {
            // Suppression d'une demande
            deleteCreditRequest(req, resp, user);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        User user = (User) req.getSession().getAttribute("connectedUser");

        if (pathInfo.equals("/save")) {
            // Création d'une nouvelle demande
            saveCreditRequest(req, resp, user);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showClientCredits(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<CreditRequest> credits = creditService.getCreditRequestsByClient(user.getId());
        req.setAttribute("credits", credits);
        req.getRequestDispatcher("/public/credits/list.jsp").forward(req, resp);
    }

    private void newCreditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/public/credits/creditForm.jsp").forward(req, resp);
    }

    private void saveCreditRequest(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        try {
            Double amount = Double.parseDouble(req.getParameter("amount"));
            Integer duration = Integer.parseInt(req.getParameter("duration"));
            String description = req.getParameter("description");

            CreditRequest creditRequest = new CreditRequest();
            creditRequest.setClientId(user.getId());
            creditRequest.setAmount(amount);
            creditRequest.setDuration(duration);
            creditRequest.setDescription(description);

            creditService.createCreditRequest(creditRequest);

            resp.sendRedirect(req.getContextPath() + "/client/credits/list");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Veuillez vérifier les valeurs saisies.");
            req.getRequestDispatcher("/public/credits/creditForm.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Une erreur est survenue lors de la création de la demande.");
            req.getRequestDispatcher("/public/credits/creditForm.jsp").forward(req, resp);
        }
    }

    private void deleteCreditRequest(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, ServletException {
        try {
            Long creditId = Long.parseLong(req.getParameter("id"));

            // Vérifier que la demande appartient bien au client
            CreditRequest credit = creditService.getCreditRequestById(creditId);
            if (credit != null && credit.getClientId().equals(user.getId())) {
                boolean deleted = creditService.deleteCreditRequest(creditId);

                if (deleted) {
                    req.getSession().setAttribute("successMessage", "Demande supprimée avec succès");
                } else {
                    req.getSession().setAttribute("errorMessage", "Impossible de supprimer une demande déjà traitée");
                }
            } else {
                req.getSession().setAttribute("errorMessage", "Demande introuvable ou accès non autorisé");
            }

            resp.sendRedirect(req.getContextPath() + "/client/credits/list");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "Identifiant de demande invalide");
            resp.sendRedirect(req.getContextPath() + "/client/credits/list");
        }
    }

    @Override
    public void destroy() {
        System.out.println("ClientCreditController détruit");
    }
}
