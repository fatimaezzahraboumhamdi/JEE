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
  <title>Détails de la Demande</title>
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
  <div class="d-flex justify-content-between align-items-center mb-4">
    <a href="${pageContext.request.contextPath}/admin/credits/list" class="btn btn-outline-secondary">
      <i class="bi bi-arrow-left me-1"></i> Retour à la liste
    </a>
    <h4 class="text-primary mb-0">Détails de la Demande de Crédit #${creditRequest.id}</h4>
    <div>
      <c:choose>
        <c:when test="${creditRequest.status eq 'PENDING'}">
          <span class="badge bg-warning text-dark">En attente</span>
        </c:when>
        <c:when test="${creditRequest.status eq 'APPROVED'}">
          <span class="badge bg-success">Approuvée</span>
        </c:when>
        <c:when test="${creditRequest.status eq 'REJECTED'}">
          <span class="badge bg-danger">Refusée</span>
        </c:when>
      </c:choose>
    </div>
  </div>

  <!-- Informations de la demande -->
  <div class="card mb-4">
    <div class="card-header bg-light">
      <h5 class="card-title mb-0">Informations générales</h5>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
          <ul class="list-group list-group-flush">
            <li class="list-group-item d-flex justify-content-between">
              <span class="fw-bold">ID Client:</span>
              <span>${creditRequest.clientId}</span>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span class="fw-bold">Montant demandé:</span>
              <span class="text-success fw-bold">
                                <fmt:formatNumber value="${creditRequest.amount}" type="currency" currencySymbol="DH "/>
                            </span>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span class="fw-bold">Durée:</span>
              <span>${creditRequest.duration} mois</span>
            </li>
          </ul>
        </div>
        <div class="col-md-6">
          <ul class="list-group list-group-flush">
            <li class="list-group-item d-flex justify-content-between">
              <span class="fw-bold">Date de demande:</span>
              <span>
                                <fmt:parseDate value="${creditRequest.requestDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                <fmt:formatDate value="${parsedDate}" type="date" pattern="dd/MM/yyyy" />
                            </span>
            </li>
            <c:if test="${creditRequest.processedDate != null}">
              <li class="list-group-item d-flex justify-content-between">
                <span class="fw-bold">Date de traitement:</span>
                <span>
                                    <fmt:parseDate value="${creditRequest.processedDate}" pattern="yyyy-MM-dd" var="parsedProcessDate" type="date" />
                                    <fmt:formatDate value="${parsedProcessDate}" type="date" pattern="dd/MM/yyyy" />
                                </span>
              </li>
            </c:if>
            <li class="list-group-item d-flex justify-content-between">
              <span class="fw-bold">Statut:</span>
              <c:choose>
                <c:when test="${creditRequest.status eq 'PENDING'}">
                  <span class="badge bg-warning text-dark">En attente</span>
                </c:when>
                <c:when test="${creditRequest.status eq 'APPROVED'}">
                  <span class="badge bg-success">Approuvée</span>
                </c:when>
                <c:when test="${creditRequest.status eq 'REJECTED'}">
                  <span class="badge bg-danger">Refusée</span>
                </c:when>
              </c:choose>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <!-- Description de la demande -->
  <div class="card mb-4">
    <div class="card-header bg-light">
      <h5 class="card-title mb-0">Description de la demande</h5>
    </div>
    <div class="card-body">
      <p class="card-text">
        ${empty creditRequest.description ? 'Aucune description fournie.' : creditRequest.description}
      </p>
    </div>
  </div>

  <!-- Actions (si la demande est en attente) -->
  <c:if test="${creditRequest.status eq 'PENDING'}">
    <div class="card mb-4 border-warning">
      <div class="card-header bg-warning bg-opacity-25">
        <h5 class="card-title mb-0">Traitement de la demande</h5>
      </div>
      <div class="card-body">
        <p class="card-text">
          Cette demande est en attente de traitement. Veuillez choisir d'approuver ou de refuser cette demande.
        </p>
        <div class="d-flex justify-content-center gap-3 mt-4">
          <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#approveModal">
            <i class="bi bi-check-lg me-1"></i> Approuver la demande
          </button>
          <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
            <i class="bi bi-x-lg me-1"></i> Refuser la demande
          </button>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Modal d'approbation -->
  <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/admin/credits/process" method="post">
          <input type="hidden" name="id" value="${creditRequest.id}">
          <input type="hidden" name="decision" value="approve">

          <div class="modal-header bg-light">
            <h5 class="modal-title" id="approveModalLabel">Approuver la demande #${creditRequest.id}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Vous êtes sur le point d'approuver la demande de crédit #${creditRequest.id} pour un montant de
              <strong><fmt:formatNumber value="${creditRequest.amount}" type="currency" currencySymbol="DH "/></strong>
              sur <strong>${creditRequest.duration} mois</strong>.
            </p>
            <div class="mb-3">
              <label for="approveReason" class="form-label">Commentaire (optionnel)</label>
              <textarea class="form-control" id="approveReason" name="reason" rows="3"></textarea>
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
  <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/admin/credits/process" method="post">
          <input type="hidden" name="id" value="${creditRequest.id}">
          <input type="hidden" name="decision" value="reject">

          <div class="modal-header bg-light">
            <h5 class="modal-title" id="rejectModalLabel">Refuser la demande #${creditRequest.id}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Vous êtes sur le point de refuser la demande de crédit #${creditRequest.id} pour un montant de
              <strong><fmt:formatNumber value="${creditRequest.amount}" type="currency" currencySymbol="DH "/></strong>
              sur <strong>${creditRequest.duration} mois</strong>.
            </p>
            <div class="mb-3">
              <label for="rejectReason" class="form-label">Motif du refus</label>
              <textarea class="form-control" id="rejectReason" name="reason" rows="3" required></textarea>
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
</div>

<!-- ✅ FOOTER FIXÉ EN BAS -->
<nav class="navbar footer-navbar fixed-bottom bg-white shadow-sm">
  <div class="container d-flex justify-content-between align-items-center w-100">
    <span class="text-muted small"><b class="blue"><i class="bi bi-house-door me-1"></i> Bankati 2025 </b>– © Tous droits réservés</span>
  </div>
</nav>

</body>
</html>