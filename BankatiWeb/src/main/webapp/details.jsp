<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String ctx = request.getContextPath();
%>

<html>
<head>
    <title>Détails de la Demande - Bankati</title>
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap-icons.css">
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">
    <style>
        body {
            background-color: #7b6cf6;
            font-family: Arial, sans-serif;
        }
        .navbar {
            background-color: white !important;
        }
        .content-card {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            margin-top: 50px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .btn-back {
            background-color: white;
            color: #0d6efd;
            border: 1px solid #0d6efd;
            border-radius: 20px;
            padding: 8px 30px;
            font-weight: bold;
        }
        .btn-back:hover {
            background-color: #0d6efd;
            color: white;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: bold;
        }
        .status-pending {
            background-color: #ffc107;
            color: #000;
        }
        .status-approved {
            background-color: #198754;
            color: white;
        }
        .status-rejected {
            background-color: #dc3545;
            color: white;
        }
        .detail-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .detail-card:hover {
            background-color: #f8f9fa;
            transform: translateY(-2px);
        }
        .detail-label {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .detail-value {
            color: #212529;
            font-size: 1.1rem;
            font-weight: bold;
        }
        .description-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<!-- ✅ NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="${ctx}/home">
            <img src="${ctx}/assets/img/logoBlue.png" alt="Logo" width="40" height="40" class="me-2">
            <strong class="text-primary">Bankati</strong>
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link text-primary fw-bold" href="${ctx}/home">
                        <i class="bi bi-house-door me-1"></i>Accueil
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-primary fw-bold" href="${ctx}/client/credit/list">
                        <i class="bi bi-list-check me-1"></i>Mes Demandes
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ✅ CONTENU PRINCIPAL -->
<div class="container">
    <div class="content-card">
        <h3 class="text-primary mb-4">
            <i class="bi bi-info-circle me-2"></i>
            Détails de la Demande #${creditRequest.id}
        </h3>

        <div class="row">
            <!-- Montant -->
            <div class="col-md-6 mb-3">
                <div class="detail-card">
                    <div class="detail-label">
                        <i class="bi bi-currency-dollar me-1"></i>
                        Montant demandé
                    </div>
                    <div class="detail-value">${creditRequest.amount} DH</div>
                </div>
            </div>

            <!-- Durée -->
            <div class="col-md-6 mb-3">
                <div class="detail-card">
                    <div class="detail-label">
                        <i class="bi bi-calendar-month me-1"></i>
                        Durée du crédit
                    </div>
                    <div class="detail-value">${creditRequest.duration} mois</div>
                </div>
            </div>

            <!-- Date -->
            <div class="col-md-6 mb-3">
                <div class="detail-card">
                    <div class="detail-label">
                        <i class="bi bi-clock me-1"></i>
                        Date de la demande
                    </div>
                    <div class="detail-value">
                        <fmt:formatDate value="${creditRequest.requestDate}" pattern="dd/MM/yyyy HH:mm" />
                    </div>
                </div>
            </div>

            <!-- Statut -->
            <div class="col-md-6 mb-3">
                <div class="detail-card">
                    <div class="detail-label">
                        <i class="bi bi-check-circle me-1"></i>
                        Statut actuel
                    </div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${creditRequest.status == 'PENDING'}">
                                <span class="status-badge status-pending">
                                    <i class="bi bi-clock-history me-1"></i>
                                    En attente
                                </span>
                            </c:when>
                            <c:when test="${creditRequest.status == 'APPROVED'}">
                                <span class="status-badge status-approved">
                                    <i class="bi bi-check-circle me-1"></i>
                                    Approuvé
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-rejected">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Refusé
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Description -->
        <c:if test="${not empty creditRequest.description}">
            <div class="description-box">
                <div class="detail-label mb-2">
                    <i class="bi bi-pencil-square me-1"></i>
                    Description de la demande
                </div>
                <p class="mb-0">${creditRequest.description}</p>
            </div>
        </c:if>

        <!-- Bouton de retour -->
        <div class="text-center mt-4">
            <a href="${ctx}/client/credit/list" class="btn btn-back">
                <i class="bi bi-arrow-left me-2"></i>
                Retour à la liste
            </a>
        </div>
    </div>
</div>

<!-- ✅ FOOTER -->
<footer class="bg-white shadow-sm fixed-bottom">
    <div class="container text-center py-2">
        <small class="text-muted"> Bankati 2025 – Tous droits réservés</small>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
