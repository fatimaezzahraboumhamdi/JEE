package ma.bankati.model.credit;


import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @AllArgsConstructor @NoArgsConstructor @Builder
public class CreditRequest {

    private Long id;
    private Long clientId;
    private Double amount;
    private Integer duration; // en mois
    private String description;
    private LocalDate requestDate;
    private CreditStatus status;
    private LocalDate processedDate;

    public enum CreditStatus {
        PENDING,
        APPROVED,
        REJECTED
    }

    @Override
    public String toString() {
        return "Demande #" + id + " - " + amount + " DH sur " + duration + " mois (" + status + ")";
    }
}