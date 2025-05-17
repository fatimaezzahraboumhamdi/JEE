<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String ctx = request.getContextPath();
%>

<html>
<head>
    <title>Demande de Crédit - Bankati</title>
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/bootstrap-icons.css">
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">
    <style>
        body {
            background-color: #7b6cf6;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background-color: white !important;
        }
        .content-card {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            margin: 50px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 800px;
        }
        .form-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #e9ecef;
        }
        .form-section-title {
            color: #0d6efd;
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #7b6cf6;
            box-shadow: 0 0 0 0.25rem rgba(123, 108, 246, 0.25);
        }
        .form-text {
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        .btn-submit {
            background-color: #0d6efd;
            color: white;
            border-radius: 25px;
            padding: 12px 40px;
            font-weight: bold;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
        }
        .btn-cancel {
            background-color: white;
            color: #dc3545;
            border: 2px solid #dc3545;
            border-radius: 25px;
            padding: 12px 40px;
            font-weight: bold;
            margin-left: 10px;
            transition: all 0.3s ease;
        }
        .btn-cancel:hover {
            background-color: #dc3545;
            color: white;
            transform: translateY(-2px);
        }
        .alert {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            border: none;
        }
        .form-floating > label {
            padding: 1rem;
        }
        .progress {
            height: 8px;
            margin-bottom: 30px;
        }
        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        .step {
            text-align: center;
            color: #6c757d;
            position: relative;
            flex: 1;
        }
        .step.active {
            color: #0d6efd;
            font-weight: bold;
        }
        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-weight: bold;
        }
        .step.active .step-number {
            background-color: #0d6efd;
            color: white;
        }
    </style>
</head>
<body>

<!-- ✅ NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${ctx}/home">
            <img src="${ctx}/assets/img/logoBlue.png" alt="Logo" width="40" height="40" class="me-2">
            <strong class="text-primary">Bankati</strong>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
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
<div class="container flex-grow-1">
    <div class="content-card">
        <h3 class="text-primary text-center mb-4">
            <i class="bi bi-cash-coin me-2"></i>
            Nouvelle Demande de Crédit
        </h3>

        <!-- Indicateur de progression -->
        <div class="step-indicator">
            <div class="step active">
                <div class="step-number">1</div>
                <div>Informations</div>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <div>Vérification</div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div>Confirmation</div>
            </div>
        </div>
        <div class="progress">
            <div class="progress-bar bg-primary" style="width: 33%"></div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i>
                ${errorMessage}
            </div>
        </c:if>

        <form action="${ctx}/client/credit/save" method="post" class="needs-validation" novalidate>
            <!-- Section Montant -->
            <div class="form-section">
                <div class="form-section-title">
                    <i class="bi bi-currency-dollar me-2"></i>
                    Montant du Crédit
                </div>
                <div class="form-floating mb-3">
                    <input type="number" 
                           name="amount" 
                           class="form-control form-control-lg" 
                           id="amount"
                           step="0.01" 
                           required 
                           min="1000"
                           placeholder="Montant">
                    <label for="amount">Montant demandé (DH)</label>
                    <div class="form-text">
                        <i class="bi bi-info-circle me-1"></i>
                        Minimum: 1000 DH
                    </div>
                </div>
            </div>

            <!-- Section Durée -->
            <div class="form-section">
                <div class="form-section-title">
                    <i class="bi bi-calendar-month me-2"></i>
                    Durée du Crédit
                </div>
                <div class="form-floating mb-3">
                    <input type="number" 
                           name="duration" 
                           class="form-control form-control-lg" 
                           id="duration"
                           required 
                           min="6" 
                           max="240"
                           placeholder="Durée">
                    <label for="duration">Durée (en mois)</label>
                    <div class="form-text">
                        <i class="bi bi-info-circle me-1"></i>
                        Entre 6 et 240 mois
                    </div>
                </div>
            </div>

            <!-- Section Description -->
            <div class="form-section">
                <div class="form-section-title">
                    <i class="bi bi-pencil-square me-2"></i>
                    Description du Projet
                </div>
                <div class="form-floating mb-3">
                    <textarea name="description" 
                              class="form-control" 
                              id="description"
                              style="height: 100px"
                              placeholder="Description"></textarea>
                    <label for="description">Décrivez brièvement l'objectif de votre demande</label>
                    <div class="form-text">
                        <i class="bi bi-info-circle me-1"></i>
                        Cette description nous aidera à mieux comprendre votre projet (optionnel)
                    </div>
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-arrow-right me-2"></i>
                    Continuer
                </button>
                <a href="${ctx}/home" class="btn btn-cancel">
                    <i class="bi bi-x-circle me-2"></i>
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>

<!-- ✅ FOOTER -->
<footer class="bg-white shadow-sm mt-auto">
    <div class="container text-center py-3">
        <small class="text-muted"> Bankati 2025 – Tous droits réservés</small>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Validation des formulaires Bootstrap
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html>
</div>

</body>
</html>
