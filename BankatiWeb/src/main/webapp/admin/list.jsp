<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    var ctx = request.getContextPath();
    var connectedUser = (ma.bankati.model.users.User) session.getAttribute("connectedUser");
    var appName = (String) application.getAttribute("AppName");
%>

<html>
<head>
    <title>Gestion des Crédits</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="Optima bgBlue">

<!-- ✅ NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <!-- Logo & Brand -->
        <a class="navbar-brand d-flex align-items-center" href="<%= ctx %>/home">
            <img src="<%= ctx %>/assets/img/logoBlue.png" alt="Logo" width="40" height="40" class="d-inline-block align-text-top me-2">
            <strong class="blue ml-1"><%= appName %></strong>
        </a>

        <!-- Menu de navigation -->
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link text-primary fw-bold" href="<%= ctx %>/home">
                        <i class="bi bi-house-door me-1"></i> Accueil
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-primary fw-bold" href="<%= ctx %>/users">
                        <i class="bi bi-people-fill me-1"></i> Utilisateurs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-primary fw-bold active" href="<%= ctx %>/admin/credits/list">
                        <i class="bi bi-cash-coin me-1"></i> Crédits
                    </a>
                </li>
            </ul>
        </div>

        <!-- Infos session avec sous-menu -->
        <div class="dropdown d-flex align-items-center">
            <a class="btn btn-sm btn-light border dropdown-toggle text-success fw-bold"
               href="#" role="button" id="dropdownSessionMenu" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle me-1"></i> <b><%= connectedUser.getRole() %></b> : <i><%= connectedUser.getFirstName() + " " + connectedUser.getLastName() %></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownSessionMenu">
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item text-danger logout-btn fw-bold" href="<%= ctx %>/logout">
                        <i class="bi bi-box-arrow-right me-1"></i> <b>Déconnexion</b>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ✅ CONTENU PRINCIPAL -->
<div class="container w-75 mt-5 mb-5 bg-white p-4 rounded-3 shadow-sm border border-light">
    <h4 class="text-center text-primary mb-4">Gestion des Demandes de Crédit</h4>

    <!-- Notifications -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fermer"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fermer"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Onglets de navigation -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${empty statusFilter ? 'active' : ''}" href="<%= ctx %>/admin/credits/list">
                <i class="bi bi-list-ul me-1"></i> Toutes les demandes
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${statusFilter eq 'pending' ? 'active' : ''}" href="<%= ctx %>/admin/credits/pending">
                <i class="bi bi-hourglass-split me-1"></i> En attente
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<%= ctx %>/admin/credits/list?status=APPROVED">
                <i class="bi bi-check-circle me-1"></i> Approuvées
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<%= ctx %>/admin/credits/list?status=REJECTED">
                <i class="bi bi-x-circle me-1"></i> Refusées
            </a>
        </li>
    </ul>

    <!-- Tableau des demandes -->
    <table class="table table-hover table-bordered text-center">
        <thead class="table-light blue">
        <tr>
            <th class="text-center">ID</th>
            <th class="text-center">Client ID</th>
            <th class="text-center">Montant</th>
            <th class="text-center">Durée</th>
            <th class="text-center">Date de demande</th>
            <th class="text-center">Statut</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody class="bold">
        <c:choose>
            <c:when test="${not empty credits}">
                <c:forEach items="${credits}" var="credit">
                    <tr>
                        <td>${credit.id}</td>
                        <td>${credit.clientId}</td>
                        <td><fmt:formatNumber value="${credit.amount}" type="currency" currencySymbol="DH "/></td>
                        <td>${credit.duration} mois</td>
                        <td>
                            <fmt:parseDate value="${credit.requestDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                            <fmt:formatDate value="${parsedDate}" type="date" pattern="dd/MM/yyyy" />
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${credit.status eq 'PENDING'}">
                                    <span class="badge bg-warning text-dark">En attente</span>
                                </c:when>
                                <c:when test="${credit.status eq 'APPROVED'}">
                                    <span class="badge bg-success">Approuvée</span>
                                </c:when>
                                <c:when test="${credit.status eq 'REJECTED'}">
                                    <span class="badge bg-danger">Refusée</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/credits/details?id=${credit.id}" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-eye-fill"></i> Détails
                            </a>
                            <c:if test="${credit.status eq 'PENDING'}">
                                <button type="button" class="btn btn-outline-success btn-sm" data-bs-toggle="modal" data-bs-target="#approveModal${credit.id}">
                                    <i class="bi bi-check-lg"></i> Approuver
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${credit.id}">
                                    <i class="bi bi-x-lg"></i> Refuser
                                </button>
                            </c:if>
                        </td>
                    </tr>

                    <!-- Modal d'approbation -->
                    <div class="modal fade" id="approveModal${credit.id}" tabindex="-1" aria-labelledby="approveModalLabel${credit.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/admin/credits/process" method="post">
                                    <input type="hidden" name="id" value="${credit.id}">
                                    <input type="hidden" name="decision" value="approve">

                                    <div class="modal-header bg-light">
                                        <h5 class="modal-title" id="approveModalLabel${credit.id}">Approuver la demande #${credit.id}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Vous êtes sur le point d'approuver la demande de crédit #${credit.id} pour un montant de
                                            <strong><fmt:formatNumber value="${credit.amount}" type="currency" currencySymbol="DH "/></strong>
                                            sur <strong>${credit.duration} mois</strong>.
                                        </p>
                                        <div class="mb-3">
                                            <label for="approveReason${credit.id}" class="form-label">Commentaire (optionnel)</label>
                                            <textarea class="form-control" id="approveReason${credit.id}" name="reason" rows="3"></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                        <button type="submit" class="btn btn-success">
                                            <i class="bi bi-check-lg me-1"></i> Confirmer l'approbation
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal de refus -->
                    <div class="modal fade" id="rejectModal${credit.id}" tabindex="-1" aria-labelledby="rejectModalLabel${credit.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="${pageContext.request.contextPath}/admin/credits/process" method="post">
                                    <input type="hidden" name="id" value="${credit.id}">
                                    <input type="hidden" name="decision" value="reject">

                                    <div class="modal-header bg-light">
                                        <h5 class="modal-title" id="rejectModalLabel${credit.id}">Refuser la demande #${credit.id}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Vous êtes sur le point de refuser la demande de crédit #${credit.id} pour un montant de
                                            <strong><fmt:formatNumber value="${credit.amount}" type="currency" currencySymbol="DH "/></strong>
                                            sur <strong>${credit.duration} mois</strong>.
                                        </p>
                                        <div class="mb-3">
                                            <label for="rejectReason${credit.id}" class="form-label">Motif du refus</label>
                                            <textarea class="form-control" id="rejectReason${credit.id}" name="reason" rows="3" required></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                        <button type="submit" class="btn btn-danger">
                                            <i class="bi bi-x-lg me-1"></i> Confirmer le refus
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7" class="text-center py-4">
                        <i class="bi bi-inbox text-muted" style="font-size: 2rem;"></i>
                        <p class="text-muted mt-2">Aucune demande de crédit trouvée</p>
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<!-- ✅ FOOTER FIXÉ EN BAS -->
<nav class="navbar footer-navbar fixed-bottom bg-white shadow-sm">
    <div class="container d-flex justify-content-between align-items-center w-100">
        <span class="text-muted small"><b class="blue"><i class="bi bi-house-door me-1"></i> Bankati 2025 </b>– © Tous droits réservés</span>
    </div>
</nav>

</body>
</html>