package ma.bankati.dao.creditDao;

import java.util.List;
import ma.bankati.dao.userDao.CrudDao;
import ma.bankati.model.credit.CreditRequest;

public interface ICreditDao extends CrudDao<CreditRequest, Long> {

    List<CreditRequest> findByClientId(Long clientId);

    List<CreditRequest> findByStatus(CreditRequest.CreditStatus status);

    void updateStatus(Long creditId, CreditRequest.CreditStatus newStatus);
}