<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="ma.bankati.model.data.MoneyData" pageEncoding="UTF-8" %>
<%@page import="ma.bankati.model.users.User" %>
<%@page import="ma.bankati.model.users.ERole" %>
<%
    var ctx = request.getContextPath();
    var result  = (MoneyData) request.getAttribute("result");
    var connectedUser = (User) session.getAttribute("connectedUser");
    var appName = (String) application.getAttribute("AppName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bankati - Administration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
        .action-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            height: 100%;
        }
        .btn-access {
            background-color: white;
            color: #0d6efd;
            border: 1px solid #0d6efd;
            border-radius: 20px;
            padding: 5px 20px;
        }
        .welcome-text {
            text-align: center;
            margin-bottom: 30px;
        }
        .balance-text {
            text-align: center;
            color: #0d6efd;
            margin-bottom: 30px;
        }
        .balance-amount {
            color: #dc3545;
        }
    </style>
</head>
<body class="Optima bgBlue">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
                <i class="bi bi-person text-white"></i>
            </div>
            <span class="fw-bold text-primary">Bankati</span>
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door"></i> Accueil
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/users">
                        <i class="bi bi-people"></i> Utilisateurs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/credits/list">
                        <i class="bi bi-cash-coin"></i> Gestion des Crédits
                    </a>
                </li>
            </ul>

            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle text-success"></i> ADMIN : ${connectedUser.firstName} ${connectedUser.lastName}
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Déconnexion</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container">
    <div class="content-card">
        <div class="welcome-text">
            <h4>Bienvenue à votre compte <span class="text-primary">Bankati</span></h4>
        </div>

        <div class="balance-text">
            <h5>Solde de votre compte : <span class="balance-amount">${result}</span></h5>
        </div>

        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="action-card">
                    <h5 class="text-primary mb-3">
                        <i class="bi bi-people me-2"></i> Gestion des utilisateurs
                    </h5>
                    <p>Gérer les utilisateurs du système</p>
                    <a href="${pageContext.request.contextPath}/users" class="btn btn-access">Accéder</a>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="action-card">
                    <h5 class="text-primary mb-3">
                        <i class="bi bi-cash-coin me-2"></i> Gestion des crédits
                    </h5>
                    <p>Gérer les demandes de crédit</p>
                    <a href="${pageContext.request.contextPath}/admin/credits/list" class="btn btn-access">Accéder</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
