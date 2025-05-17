<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    var ctx = request.getContextPath();
    var connectedUser = (ma.bankati.model.users.User) session.getAttribute("connectedUser");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Demandes de Crédit</title>
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<!-- ✅ NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="${ctx}/home">
            <img src="${ctx}/assets/img/logoBlue.png" alt="Logo" width="40" height="40" class="me-2">
            <strong class="text-primary">Bankati</strong>
        </a>
        <div class="dropdown ms-auto">
            <button class="btn btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle text-success me-1"></i> ADMIN : ${connectedUser.firstName} ${connectedUser.lastName}
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item text-danger" href="${ctx}/logout"><i class="bi bi-box-arrow-right me-1"></i>Déconnexion</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- ✅ CONTENU PRINCIPAL -->
<div class="container mt-5">
    <h4 class="text-center text-primary mb-4">Liste des Demandes de Crédit</h4>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>

    <table class="table table-bordered table-hover text-center bg-white shadow-sm">
        <thead class="table-primary">
        <tr>
            <th>ID</th>
            <th>Client</th>
            <th>Montant</th>
            <th>Durée</th>
            <th>État</th>
            <th>Date Demande</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${credits}" var="credit">
            <tr>
                <td>${credit.id}</td>
                <td>${credit.clientId}</td>
                <td>${credit.amount} Dh</td>
                <td>${credit.duration} mois</td>
                <td>
                    <span class="badge
                        ${credit.status == 'PENDING' ? 'bg-warning' :
                          credit.status == 'APPROVED' ? 'bg-success' : 'bg-danger'}">
                            ${credit.status}
                    </span>
                </td>
                <td>${credit.requestDate}</td>
                <td>
                    <a href="${ctx}/admin/credits/details?id=${credit.id}" class="btn btn-outline-primary btn-sm mb-1">
                        <i class="bi bi-info-circle"></i> Détails
                    </a>
                    <c:if test="${credit.status == 'PENDING'}">
                        <form action="${ctx}/admin/credits/process" method="post" class="d-inline">
                            <input type="hidden" name="id" value="${credit.id}"/>
                            <input type="hidden" name="decision" value="approve"/>
                            <button type="submit" class="btn btn-outline-success btn-sm mb-1">
                                <i class="bi bi-check-circle"></i> Approuver
                            </button>
                        </form>
                        <form action="${ctx}/admin/credits/process" method="post" class="d-inline">
                            <input type="hidden" name="id" value="${credit.id}"/>
                            <input type="hidden" name="decision" value="reject"/>
                            <button type="submit" class="btn btn-outline-danger btn-sm mb-1">
                                <i class="bi bi-x-circle"></i> Rejeter
                            </button>
                        </form>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- ✅ FOOTER -->
<footer class="footer mt-auto py-3 bg-white fixed-bottom shadow-sm">
    <div class="container text-center">
        <span class="text-muted small">© Bankati 2025 – Tous droits réservés</span>
    </div>
</footer>

</body>
</html>
