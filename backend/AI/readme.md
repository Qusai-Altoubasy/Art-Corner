# AI-Assisted Reporting – Prompt Documentation

## Overview
This module documents the prompt engineering approach used in the ArtCorner ERP system
to enable AI-assisted analytical reporting in a safe, deterministic, and auditable way.

The AI component is designed to act strictly as an **interpreter**, converting business
questions into structured analytics requests, without directly accessing the database
or generating SQL.

---

## Design Principles
- Deterministic outputs (same input → same JSON)
- No SQL generation by the AI
- No direct database access
- Analytics executed only on pre-aggregated tables
- Safe and auditable AI behavior

---

## Supported Data Sources
The AI is restricted to the following analytical tables:
- `analytics_customer_6m`
- `analytics_product_6m`
- `analytics_inventory_risk_6m`

---

## Prompt Responsibility
The prompt converts a natural language business question into a structured JSON object
that describes:
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

## Prompt File
The full deterministic prompt is documented in: prompt.md
