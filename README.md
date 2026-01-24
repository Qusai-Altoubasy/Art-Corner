## ArtCorner – AI & Data-Driven ERP System

## 1. Overview
ArtCorner is a full-stack ERP system built for small to medium retail businesses.
It manages inventory, sales, purchases, customers, and financial transactions, with a strong emphasis on data integrity, clean architecture, and scalability.

The project was initially implemented using Firebase (direct client access) and is currently being migrated to a Spring Boot backend to centralize business logic and improve maintainability.

**Current focus:** Building a backend-oriented analytics architecture with AI-assisted reporting, where AI is used safely as an interpreter—not a decision maker.

---

## 2. Architecture
- **Backend:** Spring Boot (RESTful API).
- **AI Service:** Python + FastAPI (LLM integration).
- **Database:** PostgreSQL.
- **Frontend:** Flutter (Desktop & Mobile).

### AI Service Design

The AI service is implemented as a **separate microservice**, intentionally decoupled from the core backend to ensure:
- Clear responsibility boundaries.
- Safer AI usage.
- Easier scaling and deployment.

---

## 3. Key Features
- Inventory and stock management.
- Sales and purchase processing.
- Customer debt tracking and payments.
- Transaction-safe operations using `@Transactional`.
- Sale item status tracking.
- Analytical data pipelines (ETL-based).
- AI-assisted analytical reporting (in progress).

---

## 4. Technical Highlights
- Multi-tier architecture (Controller, Service, Repository, DTO layers).
- SOLID principles and clean code practices.
- DTO pattern to decouple persistence and API layers.
- Relational database design optimized for transactional and analytical queries.
- SQL-based analytical views for business reporting.
- Python-based ETL pipelines using Pandas for data aggregation and transformation.
- AI & Prompt Engineering foundations for generating structured insights from historical sales data.

---

## 5. Analytics & Data Engineering

### ArtCorner separates transactional data from analytical data.

Analytics Approach:
- SQL views and aggregated tables (6-month windows).
- Python-based ETL pipelines using Pandas.
- No analytics executed directly on transactional tables.

Example analytics tables:
- analytics_customer_6m
- analytics_product_6m
- analytics_inventory_risk_6m

---

## 6. AI-Assisted Reporting (In Progress)
ArtCorner includes an AI-assisted analytics layer that enables business users to ask questions in natural language.
### Key Design Decision : 
The AI acts strictly as a deterministic interpreter.
It:
- Converts business questions → structured JSON.
- Never generates SQL.
- Never accesses the database directly.
All analytics execution remains fully controlled by the backend.

AI Flow:
- User asks a business question.
- AI converts the question into a predefined JSON structure.
- Backend validates the JSON.
- Backend executes analytics on pre-aggregated tables.
- Results are returned safely.

---

## 7. AI Prompt Engineering
The AI behavior is governed by a strict deterministic prompt.

Design Principles:
- Same input → same output.
- Predefined metrics only.
- No free-form reasoning.
- No SQL generation.
- Fully auditable outputs.

Supported Metrics:
- Top profitable customer.
- Top selling products.
- Products restock priority.
- Products with lowest profit margin.
- Customers with decreasing purchases.

Each question maps exactly to one predefined JSON schema.

📄 Full prompt specification: prompt.md

---

## 8. Tech Stack
- **Backend:** Java, Spring Boot, Spring Data JPA.
- **AI Service:** Python, FastAPI, Gemini LLM.
- **Database & Analytics:** PostgreSQL, SQL Views, Python, Pandas.
- **Frontend:** Flutter.
- **Cloud & Tools:** Firebase Firestore (legacy), Git/GitHub, Postman, Docker(planned), AWS(planned).

---

## 9. Migration Note
This repository includes:
- A legacy Firebase-based implementation (direct client access).
- A new Spring Boot backend that centralizes business logic.
- A separate AI service designed for safe analytics interpretation.

---

## Author
**Qusai Altoubasy** 
Computer Engineering – Jordan University of Science and Technology (JUST) 
Expected Graduation: July 2026

