## ArtCorner – Full-Stack ERP System

# 1. Overview
ArtCorner is a full-stack ERP system built for small to medium retail businesses.
It manages inventory, sales, purchases, customers, and financial transactions, with a strong emphasis on data integrity, clean architecture, and scalability.

The project was initially implemented using Firebase (direct client access) and is currently being migrated to a Spring Boot backend to centralize business logic and improve maintainability.

# 2. Architecture
* Backend: Spring Boot (RESTful API).
* Database: PostgreSQL.
* Frontend: Flutter (Desktop & Mobile).

# 3. Key Features
* Inventory and stock management.
* Sales and purchase processing.
* Customer debt tracking and payments.
* Transaction-safe operations using @Transactional.
* Sale item status tracking.

# 4. Technical Highlights
* Multi-tier architecture (Controller, Service, Repository, DTO layers).
* SOLID principles and clean code practices.
* DTO pattern to decouple persistence and API layers.
* Relational database design optimized for reporting.
* RESTful API design with clear separation of concerns.

# 5. Tech Stack
* Backend: Java, Spring Boot, Spring Data JPA
* Frontend: Flutter
* Database: PostgreSQL
* Cloud & Tools: Firebase Firestore (legacy), Git/GitHub, Postman.

# 6. Migration Note
This repository includes both:
- A legacy Firebase-based implementation (direct client access).
- A new Spring Boot backend that centralizes business logic and replaces Firebase logic.

# Author
Qusai Altoubasy,
Computer Engineering – Jordan University of Science and Technology (JUST),
Expected Graduation: July 2026
