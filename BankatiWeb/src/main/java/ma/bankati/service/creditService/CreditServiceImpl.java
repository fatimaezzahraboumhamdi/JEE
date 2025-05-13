package ma.bankati.service.creditService;

import java.util.List;
import ma.bankati.dao.creditDao.ICreditDao;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.credit.CreditRequest.CreditStatus;
import ma.bankati.model.users.User;

public class CreditServiceImpl implements ICreditService {

    private final ICreditDao creditDao;

    public CreditServiceImpl(ICreditDao creditDao) {
        this.creditDao = creditDao;
    }

    @Override
    public CreditRequest createCreditRequest(CreditRequest creditRequest) {
        // Définir l'état initial
        creditRequest.setStatus(CreditStatus.PENDING);
        return creditDao.save(creditRequest);
    }

    @Override
    public CreditRequest saveRequest(CreditRequest creditRequest) {
        // Alias pour createCreditRequest pour maintenir la compatibilité
        return createCreditRequest(creditRequest);
    }

    @Override
    public List<CreditRequest> getAllCreditRequests() {
        return creditDao.findAll();
    }

    @Override
    public List<CreditRequest> findAll() {
        // Alias pour getAllCreditRequests
        return getAllCreditRequests();
    }

    @Override
    public List<CreditRequest> getCreditRequestsByClient(Long clientId) {
        return creditDao.findByClientId(clientId);
    }

    @Override
    public List<CreditRequest> findByClientId(Long clientId) {
        // Alias pour getCreditRequestsByClient
        return getCreditRequestsByClient(clientId);
    }

    @Override
    public List<CreditRequest> getCreditRequestsByClient(User client) {
        return getCreditRequestsByClient(client.getId());
    }

    @Override
    public CreditRequest getCreditRequestById(Long creditId) {
        return creditDao.findById(creditId);
    }

    @Override
    public CreditRequest findById(Long creditId) {
        // Alias pour getCreditRequestById
        return getCreditRequestById(creditId);
    }

    @Override
    public List<CreditRequest> findByStatus(CreditStatus status) {
        return creditDao.findByStatus(status);
    }

    @Override
    public List<CreditRequest> getCreditRequestsByStatus(CreditStatus status) {
        // Alias pour findByStatus
        return findByStatus(status);
    }

    @Override
    public void approveCreditRequest(Long creditId) {
        creditDao.updateStatus(creditId, CreditStatus.APPROVED);
    }

    @Override
    public void approveCreditRequest(Long creditId, String reason) {
        // Pour l'instant, on ignore la raison et on appelle la méthode principale
        // Dans une implémentation future, on pourrait stocker cette raison
        approveCreditRequest(creditId);
    }

    @Override
    public void rejectCreditRequest(Long creditId) {
        creditDao.updateStatus(creditId, CreditStatus.REJECTED);
    }

    @Override
    public void rejectCreditRequest(Long creditId, String reason) {
        // Pour l'instant, on ignore la raison et on appelle la méthode principale
        // Dans une implémentation future, on pourrait stocker cette raison
        rejectCreditRequest(creditId);
    }

    @Override
    public boolean deleteCreditRequest(Long creditId) {
        if (canDeleteCreditRequest(creditId)) {
            creditDao.deleteById(creditId);
            return true;
        }
        return false;
    }

    @Override
    public boolean canDeleteCreditRequest(Long creditId) {
        CreditRequest request = creditDao.findById(creditId);
        // On ne peut supprimer que les demandes en attente
        return request != null && request.getStatus() == CreditStatus.PENDING;
    }
}