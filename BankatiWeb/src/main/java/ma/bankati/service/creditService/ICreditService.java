package ma.bankati.service.creditService;

import java.util.List;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.credit.CreditRequest.CreditStatus;
import ma.bankati.model.users.User;

public interface ICreditService {

    /**
     * Crée une nouvelle demande de crédit pour un client
     */
    CreditRequest createCreditRequest(CreditRequest creditRequest);

    /**
     * Enregistre une demande de crédit
     */
    CreditRequest saveRequest(CreditRequest creditRequest);

    /**
     * Récupère toutes les demandes de crédit
     */
    List<CreditRequest> getAllCreditRequests();

    /**
     * Récupère toutes les demandes de crédit (alias de getAllCreditRequests)
     */
    List<CreditRequest> findAll();

    /**
     * Récupère toutes les demandes de crédit d'un client
     */
    List<CreditRequest> getCreditRequestsByClient(Long clientId);

    /**
     * Récupère toutes les demandes de crédit d'un client (alias de getCreditRequestsByClient)
     */
    List<CreditRequest> findByClientId(Long clientId);

    /**
     * Récupère toutes les demandes de crédit d'un client
     */
    List<CreditRequest> getCreditRequestsByClient(User client);

    /**
     * Récupère une demande de crédit par son ID
     */
    CreditRequest getCreditRequestById(Long creditId);

    /**
     * Récupère une demande de crédit par son ID (alias de getCreditRequestById)
     */
    CreditRequest findById(Long creditId);

    /**
     * Récupère toutes les demandes de crédit avec un statut donné
     */
    List<CreditRequest> findByStatus(CreditStatus status);

    /**
     * Récupère toutes les demandes de crédit avec un statut donné
     */
    List<CreditRequest> getCreditRequestsByStatus(CreditStatus status);

    /**
     * Approuve une demande de crédit
     */
    void approveCreditRequest(Long creditId);

    /**
     * Approuve une demande de crédit avec une raison
     */
    void approveCreditRequest(Long creditId, String reason);

    /**
     * Rejette une demande de crédit
     */
    void rejectCreditRequest(Long creditId);

    /**
     * Rejette une demande de crédit avec une raison
     */
    void rejectCreditRequest(Long creditId, String reason);

    /**
     * Supprime une demande de crédit (seulement si elle est en attente)
     */
    boolean deleteCreditRequest(Long creditId);

    /**
     * Vérifie si une demande de crédit peut être supprimée
     */
    boolean canDeleteCreditRequest(Long creditId);
}