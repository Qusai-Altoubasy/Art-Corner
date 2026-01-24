# AI-Assisted Reporting – AI Service Documentation

## Overview

This module documents the AI Service used in the ArtCorner ERP system to enable AI-assisted analytical reporting in a safe, deterministic, and auditable manner.

The AI service is implemented as an independent microservice and is designed to act strictly as an interpreter, converting natural language business questions into structured analytics requests.

### The AI service does not:
- Access the database
- Generate SQL
- Execute analytics logic
- Make business decisions

---

## Core Responsibility

### The sole responsibility of the AI service is to:

Convert a business question into a predefined, structured JSON analytics request that can be safely validated and executed by the backend.

---

## Design Principles
- Deterministic outputs (same input → same JSON)
- No SQL generation by the AI
- No direct database access
- No business logic
- Analytics are executed only on pre-aggregated analytical tables
- Fully auditable and predictable AI behavior

---

## Supported Data Sources

### The AI is restricted to the following analytical tables:

- `analytics_customer_6m`
- `analytics_product_6m`
- `analytics_inventory_risk_6m`
These tables are populated via ETL pipelines and never accessed directly by the AI.

---

## Prompt Responsibility

### The deterministic prompt converts a natural language question into a structured JSON.

### describing:
- Metric type
- Time period
- Dimensions
- Measures
- Ordering rules
- Source analytics table

This JSON is later validated and executed by the backend analytics engine.

---

## Supported Metrics
The current version supports the following predefined analytics:

1. **Top profitable customer**
2. **Top selling products**
3. **Products restock priority**
4. **Products with lowest profit margin**
5. **Customers with decreasing purchases**

Each business question maps exactly to one predefined JSON structure.

---

## API Contract (AI Service)

### Endpoint
POST /ai/analytics/query

---

## Prompt File
The full deterministic prompt is documented in: prompt.md

---

## Why This Design?

### This architecture ensures:

- Clear separation between AI and business logic
- Safe use of probabilistic models
- Full control over analytics execution
- Production-ready AI integration without data risk

---
