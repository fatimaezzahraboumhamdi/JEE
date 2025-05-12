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
    public List<CreditRequest> getAllCreditRequests() {
        return creditDao.findAll();
    }

    @Override
    public List<CreditRequest> getCreditRequestsByClient(Long clientId) {
        return creditDao.findByClientId(clientId);
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
    public void approveCreditRequest(Long creditId) {
        creditDao.updateStatus(creditId, CreditStatus.APPROVED);
    }

    @Override
    public void rejectCreditRequest(Long creditId) {
        creditDao.updateStatus(creditId, CreditStatus.REJECTED);
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