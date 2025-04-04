# 🏎️ Formula 1 Ticket App 🎟️

Welcome to the **Formula 1 Ticket App**!  
This is a full-stack application where racing fans can explore events and purchase tickets for their favorite Formula 1 races.  
Built with ❤️ using **Spring Boot** for the backend and **Flutter** for the frontend — and secured with **Keycloak** 🔐

---

## 🚀 Features

✨ Browse upcoming Formula 1 events  
🛒 Buy tickets based on your favorite Grand Prix  
🔐 Secure login and role-based access using Keycloak  
📱 Beautiful, responsive UI with Flutter  
⚙️ Fast, reliable Spring Boot REST APIs

---

## 🧱 Tech Stack

### 🖥️ Backend – Spring Boot
- Java 17+
- Spring Web / Spring Data JPA
- Spring Security
- **Keycloak Integration** (OAuth2)

### 📱 Frontend – Flutter
- Flutter 3+
- API integration with secure token handling
- Provider / Riverpod for state management
- Material UI components

---

## 🔐 Authentication – Keycloak

This app uses **Keycloak** to manage user authentication and authorization.  
Users can log in with secure OAuth2 flow, and access is managed via roles (e.g., `user`, `admin`).

Keycloak handles:
- ✅ User login and registration
- 🧑‍⚖️ Role-based access
- 🔄 Token management (access/refresh tokens)

