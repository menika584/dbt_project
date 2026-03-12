# 📚 DBT Complete Beginner Learning Roadmap

> **Who is this for?** Someone who has never used DBT before and wants to go from zero to confidently building models.  
> **How to use this doc?** Follow the roadmap top to bottom. Each stage has theory, a diagram/flow, and links to the matching practical in `dbt_beginner_guide.md`.

---

## 🗺️ The Big Picture — Your Learning Journey

```
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                              DBT BEGINNER ROADMAP                                        │
│                                                                                          │
│  STAGE 0         STAGE 1         STAGE 2         STAGE 3         STAGE 4    STAGE 5     │
│  ─────────       ─────────       ─────────       ─────────       ─────────  ─────────   │
│  Data            What is         Setup &         Core DBT        Build      Test &      │
│  Modeling        DBT?            Connect         Concepts        Models     Document    │
│  (Star Schema,   (Theory)        (Install)       (source,ref,    (base,dim  (Quality)   │
│  fact, dim)                                      materialize,    fact)                  │
│                                                  4-layer arch)                          │
│                                                                                          │
│  🕐 45 min       🕐 30 min        🕐 45 min       🕐 1.5 hours    🕐 3 hours  🕐 1 hour  │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

**Total estimated time to complete all 6 stages: ~7 hours**

---

## 📋 What You Will Learn (Topics Covered)

| # | Topic | Stage |
|---|-------|-------|
| 1 | Star Schema — what it is and why it's used | Stage 0 |
| 2 | Fact tables vs Dimension tables | Stage 0 |
| 3 | Grain — what it means and why it matters | Stage 0 |
| 4 | Slowly Changing Dimensions (SCD) intro | Stage 0 |
| 5 | What is DBT and why use it | Stage 1 |
| 6 | How DBT fits in the data stack | Stage 1 |
| 7 | Install DBT + setup PostgreSQL | Stage 2 |
| 8 | DBT project structure | Stage 2 |
| 9 | Profiles and connections | Stage 2 |
| 10 | What is a Source (`source()`) | Stage 3 |
| 11 | What is a Ref (`ref()`) | Stage 3 |
| 12 | Materializations (view, table) | Stage 3 |
| 13 | The 4-layer model architecture | Stage 3 |
| 14 | Naming conventions: `base_`, `stg_`, `dim_`, `fact_` | Stage 3 |
| 15 | Base models | Stage 4 |
| 16 | Staging models | Stage 4 |
| 17 | Dimension models (`dim_`) | Stage 4 |
| 18 | Fact models (`fact_`) | Stage 4 |
| 19 | Reusing existing models | Stage 4 |
| 20 | DBT Tests (built-in) | Stage 5 |
| 21 | DBT Documentation | Stage 5 |
| 22 | DBT CLI commands cheat sheet | Stage 5 |

---

---

# ⭐ STAGE 0 — Data Modeling: Star Schema & Naming Conventions

> **Read this before touching DBT at all.** DBT is just a tool — but the *way* you organise your tables is a separate skill called **data modeling**. Understanding this first makes everything else click into place.

---

## 0.1 What is Data Modeling?

Data modeling is deciding **how to structure your tables** in a data warehouse so that they are:
- Easy and fast to query
- Easy for business users to understand
- Consistent and reusable across reports

The most widely used technique in data warehousing is the **Star Schema**.

---

## 0.2 Star Schema — The Most Widely Used Pattern

A **Star Schema** organises tables into two types: **Facts** and **Dimensions**.  
When you draw it on a whiteboard it looks like a star — hence the name.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            STAR SCHEMA                                          │
│                                                                                 │
│                        ┌──────────────────┐                                    │
│                        │   dim_customers  │                                    │
│                        │ ─────────────── │                                    │
│                        │ customer_id (PK) │                                    │
│                        │ full_name        │                                    │
│                        │ email            │                                    │
│                        │ city             │                                    │
│                        └────────┬─────────┘                                    │
│                                 │                                               │
│  ┌──────────────────┐           │           ┌──────────────────┐               │
│  │   dim_products   │           │           │    dim_dates     │               │
│  │ ─────────────── │           │           │ ─────────────── │               │
│  │ product_id  (PK) │           │           │ date_id     (PK) │               │
│  │ product_name     │           │           │ full_date        │               │
│  │ category         │           │           │ year             │               │
│  │ list_price       │           │           │ month            │               │
│  └────────┬─────────┘           │           │ quarter          │               │
│           │                     │           └────────┬─────────┘               │
│           │            ┌────────▼──────────────┐     │                         │
│           └───────────▶│     fact_orders        │◀────┘                        │
│                        │ ─────────────────────  │                              │
│                        │ order_id      (PK)      │                              │
│                        │ customer_id   (FK) ─────┘→ dim_customers              │
│                        │ product_id    (FK) ─────┘→ dim_products               │
│                        │ date_id       (FK) ─────┘→ dim_dates                  │
│                        │ payment_id    (FK)          │                          │
│                        │ quantity      (METRIC)      │                          │
│                        │ amount        (METRIC)      │                          │
│                        │ payment_status(METRIC)      │                          │
│                        └─────────────────────────────┘                         │
│                                                                                 │
│   Center of the star = FACT TABLE (events, transactions, measurements)          │
│   Points of the star = DIMENSION TABLES (who, what, when, where)               │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 0.3 Fact Tables vs Dimension Tables

```
┌──────────────────────────────────┬──────────────────────────────────────────────┐
│         FACT TABLE               │           DIMENSION TABLE                    │
│         fact_*                   │           dim_*                              │
├──────────────────────────────────┼──────────────────────────────────────────────┤
│ Stores EVENTS or TRANSACTIONS    │ Stores DESCRIPTIVE information               │
│ e.g. "an order was placed"       │ e.g. "details about a customer"              │
│ e.g. "a payment was made"        │ e.g. "details about a product"               │
├──────────────────────────────────┼──────────────────────────────────────────────┤
│ Rows = individual events         │ Rows = unique entities                        │
│ (can be millions of rows)        │ (customers, products, dates)                 │
├──────────────────────────────────┼──────────────────────────────────────────────┤
│ Contains METRICS (numbers        │ Contains ATTRIBUTES (descriptive text        │
│ you want to SUM or COUNT)        │ you want to GROUP BY or FILTER on)           │
│ e.g. amount, quantity            │ e.g. category, city, customer_name           │
├──────────────────────────────────┼──────────────────────────────────────────────┤
│ Contains FOREIGN KEYS            │ Contains a PRIMARY KEY                        │
│ linking to dimension tables      │ that fact tables point to                    │
├──────────────────────────────────┼──────────────────────────────────────────────┤
│ Grows very fast (new row         │ Grows slowly (new customer or                │
│ for every transaction)           │ product added occasionally)                  │
└──────────────────────────────────┴──────────────────────────────────────────────┘
```

### Real-world example using our sample data:

| Table | Type | Why |
|-------|------|-----|
| `fact_orders` | Fact | Every row = one order event. Has amount (metric) + FKs to dims |
| `fact_payments` | Fact | Every row = one payment. Has amount (metric) + FK to orders |
| `dim_customers` | Dimension | Describes who the customer is. Grows slowly. |
| `dim_products` | Dimension | Describes what the product is. Grows slowly. |
| `dim_dates` | Dimension | Calendar table. Describes when an event happened. |

---

## 0.4 What is "Grain"?

> **Grain = what does ONE row in this table represent?**

This is the single most important question to ask when building any model.

| Table | Grain (one row = ?) |
|-------|-------------------|
| `fact_orders` | One order |
| `fact_order_items` | One line item within one order |
| `fact_payments` | One payment transaction |
| `dim_customers` | One customer |
| `dim_products` | One product |

> ⚠️ **Always define the grain before writing a single line of SQL.** If you mix grains in one table (e.g. both order-level and item-level rows), your aggregations will be wrong.

---

## 0.5 The 4-Layer Naming Convention in DBT

This is the standard naming system used in **real production DBT projects**. Every model name tells you exactly what layer it is at and what it does.

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                    4-LAYER NAMING CONVENTION                                        │
│                                                                                     │
│   PREFIX      LAYER         PURPOSE                          EXAMPLE               │
│   ──────      ─────         ───────                          ───────               │
│                                                                                     │
│   base_*   →  Base          Raw table, minimal cleanup.      base_orders           │
│               layer         No joins. No business logic.     base_customers        │
│                             Just select + rename + cast.                           │
│                             Materialized as: VIEW                                  │
│                                                                                     │
│   stg_*    →  Staging       Light transformations on top     stg_orders            │
│               layer         of base. Adds simple             stg_customers         │
│                             calculations, deduplication.                           │
│                             Materialized as: VIEW                                  │
│                                                                                     │
│   dim_*    →  Dimension     Business entity. Who/what/when.  dim_customers         │
│               (final)       One row per entity. No metrics.  dim_products          │
│                             Slowly changing or static.       dim_dates             │
│                             Materialized as: TABLE                                 │
│                                                                                     │
│   fact_*   →  Fact          Business event/transaction.      fact_orders           │
│               (final)       Has metrics + FK to dims.        fact_payments         │
│                             One row per event.               fact_order_items      │
│                             Materialized as: TABLE                                 │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

> 💡 **The `base_` layer** is used in many real-world projects when the raw source tables need minimal standardisation before staging can use them. Some teams call this layer `raw_` or just fold it into `stg_`. Using `base_` is considered best practice for separating "source-fidelity" from "business transformations".

---

## 0.6 Full Flow: Raw → Base → Staging → Dim/Fact

```
┌───────────────────────────────────────────────────────────────────────────────────┐
│                                                                                   │
│   raw.orders ──▶ base_orders ──▶ stg_orders ──────────────────────▶ fact_orders  │
│                                                                  ↗               │
│   raw.customers ▶ base_customers ▶ stg_customers ▶ dim_customers ─               │
│                                                                  ↘               │
│   raw.products ─▶ base_products ──▶ stg_products ──▶ dim_products ▶ fact_orders  │
│                                                                                   │
│   raw.payments ─▶ base_payments ──▶ stg_payments ─────────────────▶ fact_payments│
│                                                                                   │
│   raw.order_items ▶ base_order_items ▶ stg_order_items ───────────▶ fact_order_items
│                                                                                   │
└───────────────────────────────────────────────────────────────────────────────────┘

  Layer        Built as    Rule
  ──────────   ─────────   ────────────────────────────────────────────────────────
  base_*       VIEW        1-to-1 with raw. Only SELECT, rename, cast. No logic.
  stg_*        VIEW        Builds on base. Deduplication, enrichment, light transforms.
  dim_*        TABLE       Final dimension. One row per entity. No metrics.
  fact_*       TABLE       Final fact. One row per event. Metrics + FKs only.
```

---

## 0.7 Slowly Changing Dimensions (SCD) — Quick Intro

A **Slowly Changing Dimension (SCD)** is a dimension table where the attribute values can change over time.

```
Example: A customer changes their city from "London" to "New York"

  SCD Type 1 — Overwrite (simplest)
  ─────────────────────────────────
  Just update the row. No history kept.
  customer_id=1, city="New York"    ← previous value "London" is gone

  SCD Type 2 — Keep history (most common)
  ─────────────────────────────────────────
  Add a new row with the new value. Mark the old row as expired.
  customer_id=1, city="London",   valid_from=2023-01-01, valid_to=2024-06-01, is_current=false
  customer_id=1, city="New York", valid_from=2024-06-01, valid_to=null,       is_current=true
```

> DBT handles SCD Type 2 using **Snapshots** — covered in the "Next Steps" section.

---

---

# 🟢 STAGE 1 — What is DBT and Why Use It?

## 1.1 What Problem Does DBT Solve?

Before DBT existed, data engineers and analysts had to write raw SQL scripts manually and run them in a specific order. There was no automatic dependency tracking, no testing, and no documentation.

**DBT solves this by letting you:**
- Write SQL `SELECT` statements (models) and DBT handles the `CREATE TABLE / VIEW` part
- Automatically figure out the order to run things (dependency graph)
- Test your data quality with simple YAML config
- Auto-generate documentation from your SQL files

> 💡 **Simple analogy:** Think of DBT like a "build tool for SQL." Just like how a programming language has a compiler, DBT "compiles" your SQL models, figures out the right order, and runs them against your database.

---

## 1.2 Where Does DBT Sit in the Data Stack?

```
┌──────────────────────────────────────────────────────────────────────┐
│                    MODERN DATA STACK                                 │
│                                                                      │
│   ┌─────────────┐    ┌─────────────┐    ┌──────────┐   ┌─────────┐ │
│   │   SOURCE    │    │   INGEST    │    │TRANSFORM │   │ SERVE   │ │
│   │  SYSTEMS    │───▶│  (Fivetran  │───▶│  (DBT)   │──▶│(Tableau,│ │
│   │ (App DB,    │    │   Airbyte,  │    │          │   │ Looker, │ │
│   │  APIs,      │    │   Stitch)   │    │  ← YOU   │   │ Metabase│ │
│   │  CSV files) │    └─────────────┘    │  ARE HERE│   └─────────┘ │
│   └─────────────┘                       └──────────┘               │
│                                              │                      │
│                               ┌──────────────▼──────────────┐      │
│                               │       DATA WAREHOUSE         │      │
│                               │  (PostgreSQL, Snowflake,     │      │
│                               │   BigQuery, Redshift)        │      │
│                               └─────────────────────────────┘      │
└──────────────────────────────────────────────────────────────────────┘
```

**DBT only does the T in ELT (Extract → Load → Transform).**  
It assumes data is already loaded into your database. It then transforms it into clean, business-ready tables.

---

## 1.3 What DBT Does vs What It Does NOT Do

| DBT **does** | DBT does **NOT** do |
|-------------|-------------------|
| Transform data already in your DB | Extract data from source systems |
| Run SQL SELECT models | Load raw data into your DB |
| Track dependencies between models | Replace a database |
| Test data quality | Write Python/Spark transformations (in Core) |
| Generate documentation | Orchestrate pipelines (use Airflow for that) |
| Version control your SQL | |

---

## 1.4 DBT Core vs DBT Cloud

| | DBT Core | DBT Cloud |
|---|----------|-----------|
| What it is | Open-source CLI tool | Managed web platform |
| Cost | Free | Paid (has free tier) |
| How you run it | Terminal commands | Web UI + scheduler |
| Good for | Learning, local dev | Teams, production |

> **For this guide, we use DBT Core (free, runs in your terminal).**

---

---

# 🟡 STAGE 2 — Setup & Connect

## 2.1 How DBT Connects to Your Database

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   ~/.dbt/profiles.yml                                   │
│   ┌─────────────────────────────────┐                   │
│   │  my_project:                    │                   │
│   │    target: dev                  │──────────────┐    │
│   │    outputs:                     │              │    │
│   │      dev:                       │              │    │
│   │        type: postgres           │              ▼    │
│   │        host: localhost          │   ┌──────────────┐│
│   │        dbname: my_dbt_db    ────┼──▶│  PostgreSQL  ││
│   │        user: dbt_user           │   │  Database    ││
│   │        password: ****           │   └──────────────┘│
│   └─────────────────────────────────┘                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

- `profiles.yml` lives in your **home directory** (`~/.dbt/`), NOT inside your project.  
  This keeps passwords out of your code repository.
- One `profiles.yml` can hold connections to **many** databases (dev, staging, prod).
- The `target: dev` line tells DBT which connection to use by default.

---

## 2.2 DBT Project Structure Explained

```
my_dbt_project/
│
├── dbt_project.yml          ← 🧠 Brain of the project
│                               (project name, model folders, materializations)
│
├── models/                  ← 📝 All your SQL transformation files live here
│   ├── base/                ← Layer 1: Minimal cleanup of raw (base_*)
│   ├── staging/             ← Layer 2: Light transforms on base (stg_*)
│   ├── dimensions/          ← Layer 3: Business entities (dim_*)
│   └── facts/               ← Layer 4: Business events/transactions (fact_*)
│
├── tests/                   ← ✅ Custom SQL tests
│
├── macros/                  ← 🔧 Reusable SQL snippets (like functions)
│
├── snapshots/               ← 📸 Track historical changes (SCD Type 2)
│
├── seeds/                   ← 📂 Small CSV files to load as tables
│
└── target/                  ← 🤖 Auto-generated compiled SQL (don't edit this)
```

---

## 2.3 The `dbt_project.yml` File — Key Sections

```yaml
name: 'my_dbt_project'
version: '1.0.0'
config-version: 2

profile: 'my_dbt_project'    # ← which profile to use from ~/.dbt/profiles.yml

models:
  my_dbt_project:
    base:
      materialized: view     # base models = views (lightweight)
    staging:
      materialized: view     # staging models = views
    dimensions:
      materialized: table    # dim_* = physical tables (analysts query these)
    facts:
      materialized: table    # fact_* = physical tables (analysts query these)
```

> 💡 You can override the materialization for any individual model by adding `{{ config(materialized='table') }}` at the top of the SQL file.

---

---

# 🟠 STAGE 3 — Core DBT Concepts

## 3.1 The Two Magic Functions: `source()` and `ref()`

These are the two most important things in DBT. Everything else builds on top of them.

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   source('schema_name', 'table_name')                              │
│   ─────────────────────────────────────────────────────────────    │
│   Use this when reading from a RAW table in your database.          │
│   The table was NOT created by DBT.                                 │
│                                                                     │
│   Example:  {{ source('raw', 'customers') }}                        │
│             ↑ tells dbt to look in the "raw" schema                 │
│             for a table called "customers"                          │
│                                                                     │
│   ref('model_name')                                                 │
│   ─────────────────────────────────────────────────────────────    │
│   Use this when reading from ANOTHER DBT MODEL.                     │
│   The model WAS created by DBT.                                     │
│                                                                     │
│   Example:  {{ ref('stg_customers') }}                              │
│             ↑ tells dbt to use the model called "stg_customers"     │
│             which is defined in models/staging/stg_customers.sql    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Why does this matter?

When you use `ref()`, DBT:
1. **Knows the dependency** — it builds `stg_customers` before anything that `ref()`s it
2. **Automatically resolves the full table path** — you don't hardcode schema names
3. **Builds the DAG** (the execution graph) for you

---

## 3.2 What is a DAG?

**DAG = Directed Acyclic Graph** — a fancy term for a dependency chain with no loops.

In DBT, every `ref()` you write creates an arrow in the DAG.

```
Example DAG using the 4-layer star schema pattern:

raw.customers  ──▶ base_customers ──▶ stg_customers ──▶ dim_customers ──┐
                                                                         │
raw.orders     ──▶ base_orders    ──▶ stg_orders    ──────────────────  ├──▶ fact_orders
                                                                         │
raw.products   ──▶ base_products  ──▶ stg_products ──▶ dim_products ───┘

raw.payments   ──▶ base_payments  ──▶ stg_payments ──────────────────▶ fact_payments
```

DBT reads this graph and automatically runs models **in the correct order**.  
You never have to say "run this before that" — DBT figures it out.

---

## 3.3 Materializations — View vs Table

```
┌────────────────────────────────────────────────────────────────────────┐
│                   MATERIALIZATION TYPES                                │
│                                                                        │
│  VIEW                              TABLE                               │
│  ────────────────────────          ────────────────────────            │
│  • Saves only the SQL query        • Actually runs the SQL and         │
│  • No data stored on disk            stores ALL the result rows        │
│  • Runs fresh every time           • Data is "frozen" at run time      │
│    it's queried                    • Faster to query (no re-run)       │
│  • Lightweight, cheap              • Uses more storage                 │
│  • Good for: base, staging         • Good for: dim_* and fact_*        │
│    models                            tables that analysts query        │
│                                                                        │
│  Think of VIEW like a              Think of TABLE like a               │
│  "saved recipe"                    "cooked meal in the fridge"         │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘

  Also available:
  ┌──────────────┬─────────────────────────────────────────────────────┐
  │ incremental  │ Only processes NEW/changed rows (efficient for big   │
  │              │ fact tables). Advanced topic — learn after basics.   │
  ├──────────────┼─────────────────────────────────────────────────────┤
  │ ephemeral    │ Not written to DB at all. Just injected as a CTE     │
  │              │ into the model that refs it. Very lightweight.       │
  └──────────────┴─────────────────────────────────────────────────────┘
```

---

## 3.4 The 4-Layer Architecture — The Standard in Real DBT Projects

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                     4-LAYER DBT ARCHITECTURE (STAR SCHEMA)                   │
│                                                                              │
│   ┌────────────────────┐                                                     │
│   │    RAW LAYER        │  Already in your DB. DBT does NOT touch this.      │
│   │   raw.customers     │  Created by ingestion tools (Fivetran, Airbyte).   │
│   │   raw.orders        │  Messy column names, mixed types, duplicates.      │
│   └─────────┬───────────┘                                                    │
│             │  source()                                                      │
│             ▼                                                                │
│   ┌────────────────────┐                                                     │
│   │    BASE LAYER       │  Prefix: base_*   Materialized as: VIEW            │
│   │   base_customers    │  1-to-1 with raw. Only: SELECT, rename, CAST.      │
│   │   base_orders       │  No joins. No business logic. Source-faithful.     │
│   └─────────┬───────────┘                                                    │
│             │  ref()                                                         │
│             ▼                                                                │
│   ┌────────────────────┐                                                     │
│   │   STAGING LAYER     │  Prefix: stg_*    Materialized as: VIEW            │
│   │   stg_customers     │  Builds on base_. Deduplication, enrichment,       │
│   │   stg_orders        │  light business rules, surrogate keys.             │
│   └─────────┬───────────┘                                                    │
│             │  ref()                                                         │
│             ▼                                                                │
│   ┌──────────────────────────────────────────────────────────┐              │
│   │              FINAL LAYER — STAR SCHEMA                    │              │
│   │                                                           │              │
│   │   DIMENSION TABLES (dim_*)     FACT TABLES (fact_*)       │              │
│   │   Materialized as: TABLE       Materialized as: TABLE      │              │
│   │                                                           │              │
│   │   dim_customers  ──────────────▶ fact_orders              │              │
│   │   dim_products   ──────────────▶ fact_orders              │              │
│   │   dim_dates      ──────────────▶ fact_orders              │              │
│   │                                  fact_payments            │              │
│   │                                  fact_order_items         │              │
│   └──────────────────────────────────────────────────────────┘              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Layer responsibilities at a glance:

| Layer | Prefix | What it does | Built as | Who uses it |
|-------|--------|-------------|----------|-------------|
| Raw | *(none)* | Source data as-is | Already in DB | Nobody queries directly |
| Base | `base_` | Rename + cast only. 1-to-1 with raw. | VIEW | Only stg_ models |
| Staging | `stg_` | Dedup, enrich, surrogate keys | VIEW | Only dim_ / fact_ models |
| Dimension | `dim_` | Descriptive entities. One row per entity | TABLE | Analysts + fact tables |
| Fact | `fact_` | Events/transactions. Metrics + foreign keys | TABLE | Analysts + BI tools |

---

## 3.5 How a DBT Model File Works

Every `.sql` file in your `models/` folder is a DBT model. The file structure is always the same:

```sql
-- Optional: override materialization for just this model
{{ config(materialized='table') }}

-- The model body is just a SELECT statement
-- DBT wraps it in CREATE VIEW / CREATE TABLE automatically

WITH base AS (
    SELECT *
    FROM {{ source('raw', 'orders') }}   -- read from raw table
),

customers AS (
    SELECT *
    FROM {{ ref('stg_customers') }}       -- read from another dbt model
)

SELECT
    customers.customer_id,
    base.order_id,
    base.amount
FROM base
JOIN customers ON base.customer_id = customers.customer_id
```

> 💡 The `WITH ... AS (...)` pattern is called a **CTE (Common Table Expression)**. It's just a way to break your SQL into named steps so it's easier to read. DBT models are typically written entirely as CTEs.

---

## 3.6 Sources YAML — Registering Raw Tables

Before you can use `source()` in a model, you must register the table in a `sources.yml` file:

```yaml
# models/base/sources.yml

version: 2

sources:
  - name: raw              # ← The name you use in source('raw', ...)
    schema: raw            # ← The actual schema name in your database
    tables:
      - name: customers    # ← Table name in the database
        description: "Raw customer data from the app"
      - name: orders
      - name: products
      - name: order_items
      - name: payments
```

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  sources.yml says:          SQL model uses:            │
│                                                        │
│  sources:                   {{ source('raw',           │
│    - name: raw          ──▶           'customers') }}  │
│      schema: raw            ↑                          │
│      tables:                └── These must match       │
│        - name: customers        what's in sources.yml  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

---

# 🔵 STAGE 4 — Building Models (4-Layer Star Schema Pattern)

## 4.1 Base Models (`base_*`) — The "Source Faithful" Layer

**Purpose:** Read exactly one raw table, rename columns, fix data types. Nothing else.  
**Rule:** No joins. No business logic. No aggregations. Just clean column names and correct types.

```
raw.customers                         base_customers
─────────────────────                 ─────────────────────
id          (INT)     ──rename──▶     customer_id   (INT)
first_name  (TEXT)    ──keep────▶     first_name    (TEXT)
last_name   (TEXT)    ──keep────▶     last_name     (TEXT)
email       (TEXT)    ──keep────▶     email         (TEXT)
created_at  (TEXT)    ──cast────▶     created_at    (TIMESTAMP)  ← type fixed
```

**Example — `models/base/base_customers.sql`:**
```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'customers') }}
)
SELECT
    id              AS customer_id,
    first_name,
    last_name,
    email,
    CAST(created_at AS TIMESTAMP) AS created_at
FROM source
```

---

## 4.2 Staging Models (`stg_*`) — The "Business Ready" Layer

**Purpose:** Build on top of `base_*` models to add light business transformations.  
**Rule:** Read only from `base_*` models using `ref()`. Can join base models if needed.

**What to do in a staging model (beyond what base does):**
- ✅ Deduplication (remove duplicate rows from source)
- ✅ Combine first + last name into `full_name`
- ✅ Generate surrogate keys (a hashed unique ID when the natural key is unreliable)
- ✅ Standardise values (`UPPER(status)`, `LOWER(email)`)
- ✅ Light business rules (`CASE WHEN` for simple flags)
- ❌ Do NOT join unrelated tables
- ❌ Do NOT aggregate (no GROUP BY)

**Example — `models/staging/stg_customers.sql`:**
```sql
WITH base AS (
    SELECT * FROM {{ ref('base_customers') }}
)
SELECT
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name  AS full_name,
    LOWER(email)                     AS email,
    created_at
FROM base
```

---

## 4.3 Dimension Models (`dim_*`) — The "Who / What / When" Layer

**Purpose:** Build the dimension tables for the star schema.  
**Rule:** Read from `stg_*` models. One row per unique entity. No metrics.

```
dim_customers — one row per customer

  customer_id  │ full_name      │ email               │ created_at
  ─────────────┼────────────────┼─────────────────────┼─────────────
  1            │ Alice Smith    │ alice@example.com    │ 2024-01-01
  2            │ Bob Jones      │ bob@example.com      │ 2024-01-05
  3            │ Carol Williams │ carol@example.com    │ 2024-01-10
```

**Example — `models/dimensions/dim_customers.sql`:**
```sql
WITH stg AS (
    SELECT * FROM {{ ref('stg_customers') }}
)
SELECT
    customer_id,
    full_name,
    email,
    created_at
FROM stg
```

**Example — `models/dimensions/dim_products.sql`:**
```sql
WITH stg AS (
    SELECT * FROM {{ ref('stg_products') }}
)
SELECT
    product_id,
    product_name,
    category,
    list_price
FROM stg
```

---

## 4.4 Fact Models (`fact_*`) — The "Events / Transactions" Layer

**Purpose:** Build the fact table for the star schema.  
**Rule:** Read from `stg_*` or `dim_*` models. Contains metrics + foreign keys to dimensions.

```
fact_orders — one row per order

  order_id │ customer_id │ product_id │ order_date  │ quantity │ amount  │ status
  ─────────┼────────────┼───────────┼────────────┼─────────┼─────────┼──────────
  1        │ 1           │ 1          │ 2024-01-10 │ 1        │ 999.99  │ COMPLETED
  2        │ 1           │ 2          │ 2024-01-10 │ 1        │ 149.99  │ COMPLETED
  3        │ 2           │ 3          │ 2024-01-20 │ 1        │ 299.00  │ COMPLETED
```

**Example — `models/facts/fact_orders.sql`:**
```sql
{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
    -- ☝️ Always ref stg_ or dim_ — never raw or base directly
),

customers AS (
    SELECT customer_id FROM {{ ref('dim_customers') }}
    -- ☝️ ref the dim_ table to validate the FK exists
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

SELECT
    o.order_id,
    o.customer_id,           -- FK → dim_customers
    oi.product_id,           -- FK → dim_products
    o.order_date,
    oi.quantity,
    oi.unit_price,
    oi.line_total             AS amount,
    o.status                  AS order_status
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
-- customer_id is kept as FK — analysts join to dim_customers themselves
```

---

## 4.5 How the Four Layers Connect — Complete Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  COMPLETE 4-LAYER FLOW for our sample data                                      │
│                                                                                 │
│  RAW              BASE              STAGING           FINAL (Star Schema)       │
│  ─────────────    ──────────────    ──────────────    ──────────────────────    │
│  raw.customers ─▶ base_customers ─▶ stg_customers ─▶ dim_customers             │
│                                                     ↘                           │
│  raw.orders    ─▶ base_orders    ─▶ stg_orders    ──────────────────▶ fact_orders
│                                                     ↗                           │
│  raw.products  ─▶ base_products  ─▶ stg_products ─▶ dim_products               │
│                                                                                 │
│  raw.order_items▶ base_order_items▶ stg_order_items ────────────────▶ fact_orders
│                                                                                 │
│  raw.payments  ─▶ base_payments  ─▶ stg_payments ──────────────────▶ fact_payments
│                                                                                 │
│  QUERY PATTERN (how an analyst would use this):                                 │
│  ─────────────────────────────────────────────                                  │
│  SELECT                                                                         │
│      dc.full_name,                   ← from dim_customers                      │
│      dp.product_name,                ← from dim_products                       │
│      SUM(fo.amount) AS revenue       ← metric from fact_orders                 │
│  FROM fact_orders fo                 ← start with the fact table               │
│  JOIN dim_customers dc ON fo.customer_id = dc.customer_id                      │
│  JOIN dim_products  dp ON fo.product_id  = dp.product_id                       │
│  GROUP BY dc.full_name, dp.product_name                                        │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

---

# 🟣 STAGE 5 — Testing & Documentation

## 5.1 DBT Tests — Built-in Data Quality Checks

DBT comes with 4 built-in tests you can apply to any column, just by adding YAML:

```
┌───────────────┬──────────────────────────────────────────────────────┐
│  Test         │  What it checks                                      │
├───────────────┼──────────────────────────────────────────────────────┤
│ unique        │ No two rows have the same value in this column        │
│ not_null      │ No row has a NULL value in this column                │
│ accepted_     │ Every value is in a list you specify                  │
│   values      │ e.g. status must be 'PENDING','COMPLETED','CANCELLED' │
│ relationships │ Every FK value exists in the referenced table         │
└───────────────┴──────────────────────────────────────────────────────┘
```

### How to write tests:

```yaml
# models/staging/schema.yml
version: 2

models:
  - name: stg_customers
    description: "Cleaned customer records"
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - unique
          - not_null

  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values: ['COMPLETED', 'PENDING', 'CANCELLED']
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_customers')   # ← FK must exist in dim_customers
              field: customer_id

  - name: fact_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: customer_id
        tests:
          - relationships:
              to: ref('dim_customers')
              field: customer_id
      - name: product_id
        tests:
          - relationships:
              to: ref('dim_products')
              field: product_id
```

### Run tests:

```bash
dbt test                          # run all tests
dbt test --select stg_customers   # test one model only
dbt test --select fact_orders     # test the fact table
```

---

## 5.2 DBT Documentation

DBT auto-generates a documentation website from your YAML descriptions + SQL files.

```
┌──────────────────────────────────────────────────────────────────────┐
│                   HOW DBT DOCS WORK                                  │
│                                                                      │
│   1. You add descriptions to models/columns in YAML files           │
│                                                                      │
│   2. dbt docs generate  ← reads all SQL + YAML, builds a site       │
│                                                                      │
│   3. dbt docs serve     ← opens browser at localhost:8080            │
│                                                                      │
│   The site shows:                                                    │
│   • A searchable list of all models                                  │
│   • Column names and descriptions for each model                    │
│   • The LINEAGE GRAPH (visual DAG showing model dependencies)        │
│   • Test results                                                     │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 5.3 DBT CLI — Full Cheat Sheet

```bash
# ── Connection ────────────────────────────────────────────────────────
dbt debug                         # test connection to your database

# ── Building models ───────────────────────────────────────────────────
dbt run                           # build ALL models
dbt run --select base_customers   # build ONE model
dbt run --select stg_customers+   # build model + all downstream models
dbt run --select +fact_orders     # build model + all UPSTREAM models
dbt run --select tag:staging      # build models with a specific tag

# ── Testing ───────────────────────────────────────────────────────────
dbt test                          # run ALL tests
dbt test --select fact_orders     # test one model

# ── Combined (build = run + test) ──────────────────────────────────────
dbt build                         # run + test everything at once
dbt build --select fact_orders    # run + test one model

# ── Inspection ────────────────────────────────────────────────────────
dbt compile                       # compile SQL without running it
dbt ls                            # list all models in the project

# ── Documentation ─────────────────────────────────────────────────────
dbt docs generate                 # generate the docs site
dbt docs serve                    # open docs in browser (localhost:8080)

# ── Cleanup ───────────────────────────────────────────────────────────
dbt clean                         # delete the /target folder
```

---

---

# 🏋️ PRACTICAL PLAN — Hands-On Practice Schedule

> Follow this plan in order. Each session builds on the previous one.  
> Every session maps to a section in `dbt_beginner_guide.md`.

---

## 🗓️ Session 1 — Setup (45 mins)
**Goal:** Get everything installed and connected. Don't write any models yet.

| Task | Reference |
|------|-----------|
| Install Python virtual env + dbt-postgres | Guide Step 1 |
| Start PostgreSQL, create database + user | Guide Step 2.1 |
| Run `dbt init my_dbt_project` | Guide Step 3 |
| Configure `~/.dbt/profiles.yml` | Guide Step 4 |
| Run `dbt debug` and see "All checks passed!" | Guide Step 4 |

✅ **Done when:** `dbt debug` shows no errors.

---

## 🗓️ Session 2 — Load Raw Data + Configure Project (30 mins)
**Goal:** Get sample data into PostgreSQL. Understand what "raw" means.

| Task | Reference |
|------|-----------|
| Create all 5 raw tables in PostgreSQL | Guide Step 2.2 |
| Insert sample data for all 5 tables | Guide Step 2.2 |
| Read through the 5 sample data tables in the guide | Guide Step 2.2 |
| Update `dbt_project.yml` with base/staging/dimensions/facts | Guide Step 5 |
| Create `models/base/sources.yml` | Guide Step 6 |

✅ **Done when:** All 5 raw tables have data and you can run `SELECT * FROM raw.customers`.

---

## 🗓️ Session 3 — Build the Base Layer (30 mins)
**Goal:** Understand the base layer. Write your first `base_*` models.

| Task | Reference |
|------|-----------|
| Read Stage 4.1 — what base models do | Roadmap Stage 4.1 |
| Create `base_customers.sql` | Roadmap Stage 4.1 example |
| Create `base_orders.sql` | Pattern from Stage 4.1 |
| Create `base_products.sql` | Pattern from Stage 4.1 |
| Run `dbt run --select base_customers base_orders base_products` | — |
| Verify views created: `SELECT * FROM dbt_dev.base_customers;` | — |

✅ **Done when:** All `base_*` views exist in `dbt_dev` schema.

---

## 🗓️ Session 4 — Build the Staging Layer + Example 1 (45 mins)
**Goal:** Build staging models on top of base. Build your first simple mart from Examples.

| Task | Reference |
|------|-----------|
| Read Stage 4.2 — what stg models do | Roadmap Stage 4.2 |
| Create `stg_customers.sql` (reads from `base_customers`) | Guide Example 1, E1-1 |
| Create `stg_orders.sql` (reads from `base_orders`) | Guide Example 1, E1-1 |
| Run `dbt run --select stg_customers stg_orders` | Guide Example 1, E1-3 |
| Build `mart_customer_orders.sql` as your first analysis table | Guide Example 1, E1-2 |
| Run full `dbt run`, query `mart_customer_orders` | Guide Step 9 |

✅ **Done when:** `mart_customer_orders` has 5 customer rows with spend totals.

---

## 🗓️ Session 5 — Build Dimension Tables (45 mins)
**Goal:** Build `dim_customers` and `dim_products` — the first real star schema tables.

| Task | Reference |
|------|-----------|
| Read Stage 4.3 — what dim_ tables are | Roadmap Stage 4.3 |
| Create `models/dimensions/dim_customers.sql` | Roadmap Stage 4.3 example |
| Create `models/dimensions/dim_products.sql` | Roadmap Stage 4.3 example |
| Run `dbt run --select dim_customers dim_products` | — |
| Query both tables and compare to the raw sample data | — |
| Notice: dim_ is a PHYSICAL TABLE, stg_ is a VIEW | — |

✅ **Done when:** `dim_customers` and `dim_products` exist as tables in `dbt_dev`.

---

## 🗓️ Session 6 — Build Fact Tables + Full Star Schema (60 mins)
**Goal:** Build `fact_orders` — the centre of the star. Run the full analyst query.

| Task | Reference |
|------|-----------|
| Read Stage 4.4 — what fact_ tables are | Roadmap Stage 4.4 |
| Create `models/facts/fact_orders.sql` | Roadmap Stage 4.4 example |
| Run `dbt run --select fact_orders` | — |
| Run the analyst star-schema JOIN query from Stage 4.5 | Roadmap Stage 4.5 |
| Build `fact_payments.sql` using same pattern | — |
| Run `dbt run` (all models) and verify everything builds cleanly | — |

✅ **Done when:** You can run the analyst query (JOIN fact + dim) and get correct revenue numbers.

---

## 🗓️ Session 7 — Example 2 & 3: Intermediate + Model Reuse (60 mins)
**Goal:** Practice the intermediate pattern and reusing existing models.

| Task | Reference |
|------|-----------|
| Create `int_order_details.sql` | Guide Example 2, E2-2 |
| Create `mart_order_summary.sql` | Guide Example 2, E2-3 |
| Create `mart_category_revenue.sql` (reuses existing models) | Guide Example 3, E3-2 |
| Run `dbt run` for all three | Guide Examples 2–3 |
| Compare outputs to expected result tables in guide | Guide Examples 2–3 |

✅ **Done when:** All three models build successfully and outputs match.

---

## 🗓️ Session 8 — Tests & Docs (45 mins)
**Goal:** Add data quality tests to your star schema and generate documentation.

| Task | Reference |
|------|-----------|
| Create `models/staging/schema.yml` with tests | Roadmap Stage 5.1 |
| Add `unique` + `not_null` to `stg_customers.customer_id` | Stage 5.1 |
| Add `accepted_values` to `stg_orders.status` | Stage 5.1 |
| Add `relationships` FK test from `fact_orders` → `dim_customers` | Stage 5.1 |
| Run `dbt test` — all should pass | Stage 5.1 |
| Run `dbt docs generate && dbt docs serve` | Guide Step 10 |
| In the browser, open the lineage graph and trace base → stg → dim → fact | Guide Step 10 |

✅ **Done when:** All tests pass and you can see the full 4-layer lineage in the browser.

---

## 🗓️ Session 9 — Experiment on Your Own (open-ended)
**Goal:** Reinforce everything by making changes yourself.

| Challenge | Hint |
|-----------|------|
| Add a `dim_dates` table | Create a `seeds/dim_dates.csv` with date, year, month, quarter columns and run `dbt seed` |
| Add `date_id` FK to `fact_orders` | Join `stg_orders.order_date` to `dim_dates.full_date` |
| Add a `fact_payments` table | Pattern same as `fact_orders`. FK to `stg_orders.order_id`. |
| Break a FK test intentionally | Insert an order with `customer_id=999` (doesn't exist) and run `dbt test` |
| Change `dim_customers` to incremental | Add `{{ config(materialized='incremental') }}` and an `is_incremental()` block |

---

---

# 📌 Quick Reference — Concept Summary Card

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         DBT CONCEPTS AT A GLANCE                            │
├──────────────────────┬───────────────────────────────────────────────────────┤
│ source('x','y')      │ Read raw table y from schema x. Table exists in DB.   │
│ ref('model_name')    │ Read another dbt model. dbt builds it first.          │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ materialized: view   │ Saves SQL only. Runs fresh every query. Lightweight.  │
│ materialized: table  │ Stores actual data. Fast to query. Uses storage.      │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ base_* model         │ 1-to-1 with one raw table. Rename + cast only.        │
│ stg_* model          │ Builds on base_. Dedup, enrich, light transforms.     │
│ dim_* model          │ Dimension table. Who/what/when. One row per entity.   │
│ fact_* model         │ Fact table. Events/transactions. Metrics + FK cols.   │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Star Schema          │ fact table in centre + dim tables around it.          │
│ Fact table           │ Stores events (orders, payments). Has metrics.        │
│ Dimension table      │ Stores entities (customers, products). Descriptive.   │
│ Grain                │ What does ONE row in this table represent?            │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ sources.yml          │ Registers raw tables so source() can find them.       │
│ schema.yml           │ Adds descriptions + tests to your models.             │
│ dbt_project.yml      │ Project config: model folders, materializations.      │
│ profiles.yml         │ DB connection (lives in ~/.dbt/, not in project).     │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ dbt run              │ Build all models.                                      │
│ dbt test             │ Run all tests.                                         │
│ dbt build            │ Run + test everything at once.                        │
│ dbt docs serve       │ Open documentation site in browser.                   │
└──────────────────────┴───────────────────────────────────────────────────────┘
```

---

## 🧭 Where to Go After This

Once you are comfortable with everything in this guide, here are the next topics to explore:

```
┌───────────────────────────────────────────────────────────────────────┐
│                     NEXT STEPS AFTER BASICS                           │
│                                                                       │
│  Beginner ──────────────────────────────────────────▶ Advanced       │
│                                                                       │
│  [✅ Done]                [Next]                   [Later]            │
│  source() / ref()          Incremental models       dbt Cloud         │
│  base / stg / dim / fact   Snapshots (SCD Type 2)   CI/CD pipelines   │
│  Star Schema               Seeds (CSV loading)      Packages          │
│  Built-in tests            Custom tests             Hooks             │
│  dbt docs                  Macros (Jinja)            Exposures         │
│                            Variables & Env vars     Multi-env setup   │
└───────────────────────────────────────────────────────────────────────┘
```

| Topic | What it does | When to learn it |
|-------|-------------|-----------------|
| **Incremental models** | Only process new rows, not the full fact table | When your fact tables get large (millions of rows) |
| **Snapshots (SCD Type 2)** | Track how dimension data changes over time | When you need history of `dim_customers` city/email changes |
| **Seeds** | Load small CSV files into your DB as tables (e.g. `dim_dates`) | Immediately useful — great for date dimensions |
| **Macros** | Write reusable SQL logic (like functions) | When you find yourself copying the same SQL everywhere |
| **Jinja** | Templating language used inside DBT models | When you want dynamic SQL (loops, conditionals) |
| **Custom tests** | Write your own SQL-based tests | When built-in tests aren't enough |
| **dbt Cloud** | Managed platform with scheduler and CI/CD | When you want to run dbt on a schedule in production |

---

> 📖 **Companion file:** All practical SQL code, setup steps, and worked examples live in **`dbt_beginner_guide.md`**.  
> Use that file to actually type the code. Use this file to understand *why* things work the way they do.

