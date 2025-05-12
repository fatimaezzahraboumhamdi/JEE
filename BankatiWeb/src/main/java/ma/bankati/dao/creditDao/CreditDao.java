package ma.bankati.dao.creditDao;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import ma.bankati.model.credit.CreditRequest;
import ma.bankati.model.credit.CreditRequest.CreditStatus;

public class CreditDao implements ICreditDao {

    private Path path;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy/MM/dd");

    public CreditDao() {
        try {
            this.path = Paths
                    .get(
                            getClass()
                                    .getClassLoader()
                                    .getResource("FileBase/credits.txt")
                                    .toURI()
                    );
            // Créer le fichier s'il n'existe pas
            if (!Files.exists(path)) {
                Files.createFile(path);
                // Ajouter l'en-tête
                Files.writeString(path, "ID-ClientID-Amount-Duration-Description-RequestDate-Status-ProcessedDate" + System.lineSeparator());
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de l'initialisation du DAO crédit: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private CreditRequest map(String fileLine) {
        String[] fields = fileLine.split("-");
        Long id = Long.parseLong(fields[0]);
        Long clientId = Long.parseLong(fields[1]);
        Double amount = Double.parseDouble(fields[2]);
        Integer duration = Integer.parseInt(fields[3]);
        String description = fields[4].equals("null") ? null : fields[4];
        LocalDate requestDate = fields[5].equals("null") ? null :
                LocalDate.parse(fields[5], DATE_FORMATTER);
        CreditStatus status = fields[6].equals("null") ? null :
                CreditStatus.valueOf(fields[6]);
        LocalDate processedDate = fields[7].equals("null") ? null :
                LocalDate.parse(fields[7], DATE_FORMATTER);

        return new CreditRequest(id, clientId, amount, duration, description, requestDate, status, processedDate);
    }

    private String mapToFileLine(CreditRequest credit) {
        String description = credit.getDescription() == null || credit.getDescription().trim().isEmpty() ?
                "null" : credit.getDescription();
        String requestDate = credit.getRequestDate() == null ?
                "null" : credit.getRequestDate().format(DATE_FORMATTER);
        String status = credit.getStatus() == null ? "null" : credit.getStatus().toString();
        String processedDate = credit.getProcessedDate() == null ?
                "null" : credit.getProcessedDate().format(DATE_FORMATTER);

        return credit.getId() + "-" +
                credit.getClientId() + "-" +
                credit.getAmount() + "-" +
                credit.getDuration() + "-" +
                description + "-" +
                requestDate + "-" +
                status + "-" +
                processedDate +
                System.lineSeparator();
    }

    private long newMaxId() {
        return findAll().stream().mapToLong(CreditRequest::getId).max().orElse(0) + 1;
    }

    @Override
    public CreditRequest findById(Long identity) {
        return findAll().stream()
                .filter(credit -> credit.getId().equals(identity))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<CreditRequest> findAll() {
        try {
            if (!Files.exists(path)) {
                return new ArrayList<>();
            }

            return Files.readAllLines(path)
                    .stream()
                    .skip(1) // Skip header
                    .map(this::map)
                    .collect(Collectors.toList());
        } catch (IOException e) {
            System.err.println("Erreur lors de la lecture des demandes de crédit: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    @Override
    public CreditRequest save(CreditRequest newElement) {
        try {
            newElement.setId(newMaxId());
            if (newElement.getRequestDate() == null) {
                newElement.setRequestDate(LocalDate.now());
            }
            if (newElement.getStatus() == null) {
                newElement.setStatus(CreditStatus.PENDING);
            }

            Files.writeString(path, mapToFileLine(newElement), StandardOpenOption.APPEND);
            return newElement;
        } catch (IOException e) {
            System.err.println("Erreur lors de l'enregistrement d'une demande de crédit: " + e.getMessage());
            return null;
        }
    }

    @Override
    public void delete(CreditRequest element) {
        deleteById(element.getId());
    }

    @Override
    public void deleteById(Long identity) {
        List<CreditRequest> updatedList = findAll().stream()
                .filter(credit -> !credit.getId().equals(identity))
                .collect(Collectors.toList());

        rewriteFile(updatedList);
    }

    @Override
    public void update(CreditRequest newValuesElement) {
        List<CreditRequest> updatedList = findAll().stream()
                .map(credit -> credit.getId().equals(newValuesElement.getId()) ? newValuesElement : credit)
                .collect(Collectors.toList());

        rewriteFile(updatedList);
    }

    @Override
    public List<CreditRequest> findByClientId(Long clientId) {
        return findAll().stream()
                .filter(credit -> credit.getClientId().equals(clientId))
                .collect(Collectors.toList());
    }

    @Override
    public List<CreditRequest> findByStatus(CreditStatus status) {
        return findAll().stream()
                .filter(credit -> status.equals(credit.getStatus()))
                .collect(Collectors.toList());
    }

    @Override
    public void updateStatus(Long creditId, CreditStatus newStatus) {
        CreditRequest credit = findById(creditId);
        if (credit != null) {
            credit.setStatus(newStatus);
            credit.setProcessedDate(LocalDate.now());
            update(credit);
        }
    }

    private void rewriteFile(List<CreditRequest> credits) {
        try {
            List<String> lines = new ArrayList<>();
            lines.add("ID-ClientID-Amount-Duration-Description-RequestDate-Status-ProcessedDate");

            for (CreditRequest credit : credits) {
                lines.add(mapToFileLine(credit).trim());
            }

            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Erreur lors de la réécriture du fichier de crédits: " + e.getMessage());
        }
    }
}