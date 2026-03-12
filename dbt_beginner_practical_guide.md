# 🚀 DBT Beginner Guide – Connect to Local PostgreSQL & Build Your First Model

> **Goal:** Set up a basic DBT project from scratch, connect it to a local PostgreSQL database, and build DBT models from raw tables.  
> Two complete worked examples are included at the end — start to finish.

---

## 📋 Prerequisites

Before you begin, make sure you have the following installed:

| Tool | Version | Install Command |
|------|---------|-----------------|
| Python | 3.8+ | [python.org](https://www.python.org/downloads/) |
| pip | latest | comes with Python |
| PostgreSQL | 13+ | [postgresql.org](https://www.postgresql.org/download/) |
| Git | any | [git-scm.com](https://git-scm.com/) |

---

## 🛠️ Step 1 – Install DBT

Open your terminal and run:

```bash
# Create a virtual environment (recommended)
python3 -m venv dbt-env
source dbt-env/bin/activate       # Mac/Linux
# dbt-env\Scripts\activate        # Windows

# Install dbt with the PostgreSQL adapter
pip install dbt-postgres
```

Verify the installation:

```bash
dbt --version
```

You should see something like:
```
Core:
  - installed: 1.7.x
  - latest:    1.7.x

Plugins:
  - postgres: 1.7.x
```

---

## 🗄️ Step 2 – Set Up Local PostgreSQL

### 2.1 Start PostgreSQL and create a database

```bash
# Start postgres (Mac with Homebrew)
brew services start postgresql

# Open the postgres shell
psql postgres
```

Inside the psql shell, run:

```sql
-- Create a dedicated database
CREATE DATABASE my_dbt_db;

-- Create a user for dbt
CREATE USER dbt_user WITH PASSWORD 'dbt_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE my_dbt_db TO dbt_user;

-- Exit
\q
```

### 2.2 Create raw source tables with sample data

> 💡 **What is "raw"?** Raw tables are the original tables that come straight from your source system (e.g. an app database or a CSV import). DBT does **not** create these — you own them. DBT only reads from them.

```bash
psql -U dbt_user -d my_dbt_db
```

```sql
-- Create a raw schema to hold source data
CREATE SCHEMA raw;

-- ── Table 1: Customers ──────────────────────────────────────────
CREATE TABLE raw.customers (
    id          SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100),
    created_at  TIMESTAMP DEFAULT NOW()
);

-- ── Table 2: Orders ─────────────────────────────────────────────
CREATE TABLE raw.orders (
    id              SERIAL PRIMARY KEY,
    customer_id     INT REFERENCES raw.customers(id),
    order_date      DATE,
    amount          NUMERIC(10, 2),
    status          VARCHAR(20)
);

-- ── Table 3: Products ───────────────────────────────────────────
CREATE TABLE raw.products (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    category    VARCHAR(50),
    price       NUMERIC(10, 2)
);

-- ── Table 4: Order Items ─────────────────────────────────────────
CREATE TABLE raw.order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INT REFERENCES raw.orders(id),
    product_id  INT REFERENCES raw.products(id),
    quantity    INT,
    unit_price  NUMERIC(10, 2)
);

-- ── Table 5: Payments ────────────────────────────────────────────
CREATE TABLE raw.payments (
    id              SERIAL PRIMARY KEY,
    order_id        INT REFERENCES raw.orders(id),
    payment_date    DATE,
    payment_method  VARCHAR(30),
    amount          NUMERIC(10, 2)
);

-- ── Sample Data ──────────────────────────────────────────────────
INSERT INTO raw.customers (first_name, last_name, email) VALUES
    ('Alice', 'Smith',    'alice@example.com'),
    ('Bob',   'Jones',    'bob@example.com'),
    ('Carol', 'Williams', 'carol@example.com'),
    ('David', 'Brown',    'david@example.com'),
    ('Eva',   'Taylor',   'eva@example.com');

INSERT INTO raw.products (name, category, price) VALUES
    ('Laptop',     'Electronics', 999.99),
    ('Headphones', 'Electronics', 149.99),
    ('Desk Chair', 'Furniture',   299.00),
    ('Notebook',   'Stationery',   4.99),
    ('Coffee Mug', 'Kitchen',      12.50);

INSERT INTO raw.orders (customer_id, order_date, amount, status) VALUES
    (1, '2024-01-10', 1149.98, 'completed'),
    (1, '2024-02-15',  149.99, 'pending'),
    (2, '2024-01-20',  299.00, 'completed'),
    (3, '2024-03-05',    4.99, 'cancelled'),
    (4, '2024-03-15',   12.50, 'completed');

INSERT INTO raw.order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 999.99),
    (1, 2, 1, 149.99),
    (2, 2, 1, 149.99),
    (3, 3, 1, 299.00),
    (4, 4, 1,   4.99),
    (5, 5, 1,  12.50);

INSERT INTO raw.payments (order_id, payment_date, payment_method, amount) VALUES
    (1, '2024-01-10', 'credit_card', 1149.98),
    (3, '2024-01-20', 'paypal',       299.00),
    (5, '2024-03-15', 'debit_card',    12.50);

\q
```

#### 📊 What the raw data looks like

**raw.customers**

| id | first_name | last_name | email |
|----|-----------|-----------|-------|
| 1 | Alice | Smith | alice@example.com |
| 2 | Bob | Jones | bob@example.com |
| 3 | Carol | Williams | carol@example.com |
| 4 | David | Brown | david@example.com |
| 5 | Eva | Taylor | eva@example.com |

**raw.orders**

| id | customer_id | order_date | amount | status |
|----|------------|-----------|--------|--------|
| 1 | 1 | 2024-01-10 | 1149.98 | completed |
| 2 | 1 | 2024-02-15 | 149.99 | pending |
| 3 | 2 | 2024-01-20 | 299.00 | completed |
| 4 | 3 | 2024-03-05 | 4.99 | cancelled |
| 5 | 4 | 2024-03-15 | 12.50 | completed |

**raw.products**

| id | name | category | price |
|----|------|----------|-------|
| 1 | Laptop | Electronics | 999.99 |
| 2 | Headphones | Electronics | 149.99 |
| 3 | Desk Chair | Furniture | 299.00 |
| 4 | Notebook | Stationery | 4.99 |
| 5 | Coffee Mug | Kitchen | 12.50 |

**raw.order_items**

| id | order_id | product_id | quantity | unit_price |
|----|---------|-----------|---------|-----------|
| 1 | 1 | 1 | 1 | 999.99 |
| 2 | 1 | 2 | 1 | 149.99 |
| 3 | 2 | 2 | 1 | 149.99 |
| 4 | 3 | 3 | 1 | 299.00 |
| 5 | 4 | 4 | 1 | 4.99 |
| 6 | 5 | 5 | 1 | 12.50 |

**raw.payments**

| id | order_id | payment_date | payment_method | amount |
|----|---------|-------------|---------------|--------|
| 1 | 1 | 2024-01-10 | credit_card | 1149.98 |
| 2 | 3 | 2024-01-20 | paypal | 299.00 |
| 3 | 5 | 2024-03-15 | debit_card | 12.50 |

---

## 📁 Step 3 – Initialize a New DBT Project

```bash
# Navigate to your projects folder
cd ~/projects

# Initialize a new dbt project
dbt init my_dbt_project
```

When prompted:
- **Profile name:** `my_dbt_project`
- **Database:** choose `postgres` (option 1)

This creates the following folder structure:

```
my_dbt_project/
├── dbt_project.yml        ← project configuration
├── profiles.yml           ← connection settings (auto-created in ~/.dbt/)
├── models/
│   └── example/           ← sample models (can delete later)
├── tests/
├── macros/
├── snapshots/
└── README.md
```

---

## 🔌 Step 4 – Configure the Connection Profile

DBT stores connection profiles in `~/.dbt/profiles.yml`.

Open the file:

```bash
nano ~/.dbt/profiles.yml
```

Replace the contents with:

```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: dbt_user
      password: dbt_password
      dbname: my_dbt_db
      schema: dbt_dev          # dbt will create this schema and write models here
      threads: 4
```

> 💡 **Tip:** `schema: dbt_dev` is where dbt will write the output tables/views. It will be created automatically.

Test the connection:

```bash
cd my_dbt_project
dbt debug
```

Expected output:
```
All checks passed!
```

---

## 🏗️ Step 5 – Configure the DBT Project File

Open `dbt_project.yml` in the project root and update it:

```yaml
name: 'my_dbt_project'
version: '1.0.0'
config-version: 2

profile: 'my_dbt_project'   # must match the name in ~/.dbt/profiles.yml

model-paths: ["models"]
test-paths: ["tests"]
macro-paths: ["macros"]

target-path: "target"
clean-targets:
  - "target"

models:
  my_dbt_project:
    staging:
      schema: dbt_dev
      materialized: view       # build as SQL views
    intermediate:
      schema: dbt_dev
      materialized: view       # intermediate models are also views
    marts:
      schema: dbt_dev
      materialized: table      # build as physical tables
```

---

## 🧱 Step 6 – Define Source Tables

Create a sources YAML file so dbt knows about your raw tables:

```bash
mkdir -p models/staging
touch models/staging/sources.yml
```

Add to `models/staging/sources.yml`:

```yaml
version: 2

sources:
  - name: raw
    schema: raw
    tables:
      - name: customers
      - name: orders
      - name: products
      - name: order_items
      - name: payments
```

---

## 🎯 The Two Examples

Before diving in, here is a quick picture of the **three layers** DBT uses:

```
raw.*          →    staging (stg_*)    →   [intermediate (int_*)]   →   marts (final tables)
(your DB)           (clean + rename)        (combine stg models)         (business answers)
```

| Layer | Folder | Built as | Purpose |
|-------|--------|----------|---------|
| Raw | (already in DB) | — | Original data, untouched |
| Staging | `models/staging/` | View | Clean column names, fix types |
| Intermediate | `models/intermediate/` | View | Join or combine staging models |
| Mart | `models/marts/` | Table | Final answer for business users |

---

## ✅ Example 1 – Source → Staging → Final Mart (Simple, 2-layer)

### 🤔 What is this example doing?

> We want to answer: *"How many orders did each customer place, and how much did they spend?"*
>
> **Flow:**  
> `raw.customers` + `raw.orders`  →  `stg_customers` + `stg_orders`  →  `mart_customer_orders`
>
> - **Staging models** just clean up the raw data (rename columns, fix casing). Think of them as a tidy copy of the raw table.
> - **The mart model** joins both staging models together and calculates the summary. This is what a business user would query.

### Step E1-1: Create staging models

**`models/staging/stg_customers.sql`**

> This model reads the raw customers table and renames/cleans columns.  
> It becomes a **view** in your database called `dbt_dev.stg_customers`.

```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'customers') }}
    -- ☝️ source() tells dbt: read from the raw schema, customers table
)

SELECT
    id              AS customer_id,   -- rename id → customer_id (clearer)
    first_name,
    last_name,
    first_name || ' ' || last_name  AS full_name,  -- combine into one column
    LOWER(email)    AS email,          -- make email lowercase
    created_at
FROM source
```

**`models/staging/stg_orders.sql`**

> Reads raw orders and cleans them up.

```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'orders') }}
)

SELECT
    id              AS order_id,
    customer_id,
    order_date,
    amount,
    UPPER(status)   AS status         -- make status uppercase (e.g. COMPLETED)
FROM source
```

### Step E1-2: Create the final mart model

```bash
mkdir -p models/marts
```

**`models/marts/mart_customer_orders.sql`**

> This model uses `ref()` to point at the staging models built above.  
> `ref('stg_customers')` means: *use the dbt model named stg_customers*.  
> DBT automatically knows to build the staging models **first**, then this one.

```sql
WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
    -- ☝️ ref() tells dbt: use the stg_customers model as input
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_summary AS (
    -- Count and sum orders per customer
    SELECT
        customer_id,
        COUNT(order_id)     AS total_orders,
        SUM(amount)         AS total_spent,
        MIN(order_date)     AS first_order_date,
        MAX(order_date)     AS latest_order_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    COALESCE(o.total_orders, 0)  AS total_orders,
    COALESCE(o.total_spent, 0)   AS total_spent,
    o.first_order_date,
    o.latest_order_date
FROM customers c
LEFT JOIN order_summary o ON c.customer_id = o.customer_id
```

### Step E1-3: Run it

```bash
dbt run --select stg_customers stg_orders mart_customer_orders
```

### 📊 What the output looks like (`dbt_dev.mart_customer_orders`)

| customer_id | full_name | email | total_orders | total_spent | first_order_date | latest_order_date |
|-------------|-----------|-------|-------------|------------|-----------------|------------------|
| 1 | Alice Smith | alice@example.com | 2 | 1299.97 | 2024-01-10 | 2024-02-15 |
| 2 | Bob Jones | bob@example.com | 1 | 299.00 | 2024-01-20 | 2024-01-20 |
| 3 | Carol Williams | carol@example.com | 1 | 4.99 | 2024-03-05 | 2024-03-05 |
| 4 | David Brown | david@example.com | 1 | 12.50 | 2024-03-15 | 2024-03-15 |
| 5 | Eva Taylor | eva@example.com | 0 | 0.00 | — | — |

### 🗺️ Lineage (how dbt sees the chain)

```
raw.customers ──→ stg_customers ──┐
                                   ├──→ mart_customer_orders  ✅
raw.orders ────→ stg_orders ──────┘
```

---

## ✅ Example 2 – Source → Staging → Intermediate → Final Mart (3-layer)

### 🤔 What is this example doing?

> We want to answer: *"For each order, what products were bought, and has it been paid?"*  
> This needs data from 4 raw tables: orders, order_items, products, and payments.
>
> **Flow:**  
> `raw.orders` + `raw.order_items` + `raw.products` + `raw.payments`  
>   →  `stg_orders` + `stg_order_items` + `stg_products` + `stg_payments`  
>   →  **`int_order_details`** *(intermediate — joins order_items with products)*  
>   →  `mart_order_summary` *(final)*
>
> - **Why an intermediate model?**  
>   Sometimes the join logic is complex enough that you don't want to stuff it all into the final mart. You create an intermediate model to do part of the work first — making the final model much simpler and easier to read.  
>   An intermediate model is just a "stepping stone" — it exists in dbt but is typically a view, not a table business users query directly.

### Step E2-1: Add more staging models

**`models/staging/stg_products.sql`**

```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'products') }}
)

SELECT
    id          AS product_id,
    name        AS product_name,
    category,
    price       AS list_price
FROM source
```

**`models/staging/stg_order_items.sql`**

```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'order_items') }}
)

SELECT
    id          AS order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price   AS line_total   -- calculate line total
FROM source
```

**`models/staging/stg_payments.sql`**

```sql
WITH source AS (
    SELECT * FROM {{ source('raw', 'payments') }}
)

SELECT
    id              AS payment_id,
    order_id,
    payment_date,
    payment_method,
    amount          AS payment_amount
FROM source
```

### Step E2-2: Create the intermediate model

```bash
mkdir -p models/intermediate
```

**`models/intermediate/int_order_details.sql`**

> **What this does:** It joins `stg_order_items` with `stg_products` so we get one row per order-item with the product name and category already attached.  
> This is the "stepping stone." The final mart will use this — it doesn't need to worry about the join logic anymore.

```sql
-- Intermediate model: enrich order items with product info
-- Why? So the final mart doesn't need to do this join itself.

WITH order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
    -- ☝️ ref() the staging model, not the raw table
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
)

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.quantity,
    oi.unit_price,
    oi.line_total,
    p.product_id,
    p.product_name,
    p.category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
```

### Step E2-3: Create the final mart model

**`models/marts/mart_order_summary.sql`**

> **What this does:** It takes the intermediate model (already has product info per order-item) and combines it with orders and payments to produce a full order summary.  
> Notice how clean this is — the tricky join work was done in `int_order_details`.

```sql
-- Final mart: full order summary with products and payment status
-- Uses the intermediate model + stg_orders + stg_payments

WITH order_details AS (
    SELECT * FROM {{ ref('int_order_details') }}
    -- ☝️ ref() the INTERMEDIATE model — not raw, not staging
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

-- Roll up items per order (one order can have many items)
items_per_order AS (
    SELECT
        order_id,
        COUNT(order_item_id)                AS total_items,
        SUM(line_total)                     AS items_total,
        STRING_AGG(product_name, ', ')      AS products_bought
    FROM order_details
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status                            AS order_status,
    i.total_items,
    i.items_total,
    i.products_bought,
    p.payment_method,
    p.payment_amount,
    CASE
        WHEN p.payment_id IS NOT NULL THEN 'Paid'
        ELSE 'Unpaid'
    END                                 AS payment_status
FROM orders o
LEFT JOIN items_per_order i  ON o.order_id = i.order_id
LEFT JOIN payments p         ON o.order_id = p.order_id
```

### Step E2-4: Run it

```bash
dbt run --select stg_products stg_order_items stg_payments int_order_details mart_order_summary
```

Or simply run everything at once:

```bash
dbt run
```

### 📊 What the output looks like (`dbt_dev.mart_order_summary`)

| order_id | customer_id | order_date | order_status | total_items | items_total | products_bought | payment_method | payment_amount | payment_status |
|---------|------------|-----------|-------------|------------|------------|----------------|---------------|---------------|---------------|
| 1 | 1 | 2024-01-10 | COMPLETED | 2 | 1149.98 | Laptop, Headphones | credit_card | 1149.98 | Paid |
| 2 | 1 | 2024-02-15 | PENDING | 1 | 149.99 | Headphones | — | — | Unpaid |
| 3 | 2 | 2024-01-20 | COMPLETED | 1 | 299.00 | Desk Chair | paypal | 299.00 | Paid |
| 4 | 3 | 2024-03-05 | CANCELLED | 1 | 4.99 | Notebook | — | — | Unpaid |
| 5 | 4 | 2024-03-15 | COMPLETED | 1 | 12.50 | Coffee Mug | debit_card | 12.50 | Paid |

### 🗺️ Lineage (how dbt sees the chain)

```
raw.order_items ──→ stg_order_items ──┐
                                        ├──→ int_order_details ──┐
raw.products ─────→ stg_products ─────┘                          │
                                                                   ├──→ mart_order_summary  ✅
raw.orders ───────→ stg_orders ──────────────────────────────────┤
                                                                   │
raw.payments ─────→ stg_payments ────────────────────────────────┘
```

---

## ✅ Example 3 – Reusing an Existing Model + a Raw Table to Build Something New

### 🤔 What is this example doing?

> We want to answer: *"Which product categories are generating the most revenue, and which customers are buying from each category?"*
>
> **The key learning here:** Instead of starting from scratch with raw tables, we simply **re-use two models that already exist** from the previous examples — `mart_customer_orders` (Example 1) and `mart_order_summary` (Example 2) — and bring in **one raw table** (`raw.products`) for the category info.
>
> **Flow:**
> ```
> raw.products  (raw table, new)
>       +
> mart_customer_orders  (already built in Example 1)   ──→  mart_category_revenue  ✅
>       +
> mart_order_summary    (already built in Example 2)
> ```
>
> - **You don't need to re-join everything from scratch.** DBT lets you `ref()` any model — including your final mart models — and build on top of them.
> - This is the real power of DBT: **models are building blocks**. Build once, reuse many times.

### Step E3-1: No new staging or intermediate models needed!

> We already have everything we need from Examples 1 and 2. We just write the new mart model directly.

### Step E3-2: Create the new mart model

**`models/marts/mart_category_revenue.sql`**

> **What this does, line by line:**
> - Reads `mart_order_summary` (from Example 2) to get products bought per order and their totals.
> - Reads `raw.products` directly via `source()` to get the category for each product.
> - Reads `mart_customer_orders` (from Example 1) to attach customer name to each order.
> - Groups everything by product category and produces a revenue + customer summary per category.

```sql
-- Example 3: Build a new model by referencing existing models + one raw table
-- Question: Which product category earns the most? Who buys from each category?

WITH order_summary AS (
    -- ✅ ref() an already-built mart model from Example 2
    SELECT * FROM {{ ref('mart_order_summary') }}
),

customer_orders AS (
    -- ✅ ref() an already-built mart model from Example 1
    SELECT * FROM {{ ref('mart_customer_orders') }}
),

products AS (
    -- ✅ source() a raw table directly — we just need the category column
    SELECT * FROM {{ source('raw', 'products') }}
),

-- Step 1: Join order_summary with products to tag each order with a category
orders_with_category AS (
    SELECT
        os.order_id,
        os.customer_id,
        os.order_date,
        os.order_status,
        os.items_total,
        os.payment_status,
        p.category
    FROM order_summary os
    -- Use LIKE to match product names back to the products table
    -- (order_summary already has products_bought as a text column)
    LEFT JOIN products p
        ON os.products_bought LIKE '%' || p.name || '%'
),

-- Step 2: Group by category to calculate revenue totals
category_summary AS (
    SELECT
        category,
        COUNT(DISTINCT order_id)        AS total_orders,
        SUM(items_total)                AS total_revenue,
        COUNT(DISTINCT customer_id)     AS unique_customers
    FROM orders_with_category
    WHERE order_status = 'COMPLETED'      -- only count completed orders
    GROUP BY category
)

-- Step 3: Final select — attach the top customer name per category
SELECT
    cs.category,
    cs.total_orders,
    cs.total_revenue,
    cs.unique_customers,
    -- Pull in a sample customer name from customer_orders model (Example 1)
    (
        SELECT co.full_name
        FROM customer_orders co
        WHERE co.customer_id = (
            SELECT owc.customer_id
            FROM orders_with_category owc
            WHERE owc.category = cs.category
              AND owc.order_status = 'COMPLETED'
            ORDER BY owc.items_total DESC
            LIMIT 1
        )
    )                                   AS top_customer_name
FROM category_summary cs
ORDER BY cs.total_revenue DESC
```

### Step E3-3: Run it

```bash
# Run only the new model — dbt will automatically build its dependencies first
dbt run --select mart_category_revenue
```

> 💡 **Notice:** You only select the new model. DBT figures out on its own that it needs `mart_order_summary`, `mart_customer_orders`, and `raw.products` first, because of the `ref()` and `source()` calls. You don't have to list them manually.

### 📊 What the output looks like (`dbt_dev.mart_category_revenue`)

| category | total_orders | total_revenue | unique_customers | top_customer_name |
|----------|-------------|--------------|-----------------|------------------|
| Electronics | 2 | 1448.98 | 2 | Alice Smith |
| Furniture | 1 | 299.00 | 1 | Bob Jones |
| Kitchen | 1 | 12.50 | 1 | David Brown |
| Stationery | 0 | 0.00 | 0 | — |

### 🗺️ Lineage (how dbt sees the chain)

```
                         (Example 1 models)
raw.customers ──→ stg_customers ──┐
                                   ├──→ mart_customer_orders ──────────────────┐
raw.orders ────→ stg_orders ──────┘                                            │
                                                                                │
                         (Example 2 models)                                    ├──→ mart_category_revenue  ✅
raw.order_items ──→ stg_order_items ──┐                                        │
                                       ├──→ int_order_details ──┐              │
raw.products ─────→ stg_products ─────┘                         ├──→ mart_order_summary ──┤
raw.orders ───────→ stg_orders ─────────────────────────────────┤              │
raw.payments ─────→ stg_payments ───────────────────────────────┘              │
                                                                                │
raw.products ──────────────────────────────────────────────────────────────────┘
(used directly via source())
```

> 💡 **Key takeaway from Example 3:**
> - `ref('mart_customer_orders')` — points at a **mart** model, not just staging. Any model can be a building block.
> - `ref('mart_order_summary')` — same idea. Reuse the work already done.
> - `source('raw', 'products')` — you can always mix `source()` and `ref()` in the same model.
> - DBT builds the **entire dependency chain automatically**, in the right order, every time.

---

## ▶️ Run DBT Commands

Navigate to your project folder:

```bash
cd my_dbt_project
```

| Command | What it does |
|---------|-------------|
| `dbt debug` | Test the database connection |
| `dbt compile` | Compile SQL without running |
| `dbt run` | Build **all** models in the database |
| `dbt test` | Run all data quality tests |
| `dbt run --select model_name` | Build one specific model |
| `dbt run --select model_name+` | Build a model and everything downstream of it |
| `dbt docs generate` | Generate documentation |
| `dbt docs serve` | Open docs in the browser |

### Expected output for `dbt run` (both examples together):

```
Running with dbt=1.7.x
Found 8 models, 2 sources

1 of 8 OK created view  dbt_dev.stg_customers .......  [CREATE VIEW in 0.12s]
2 of 8 OK created view  dbt_dev.stg_orders ...........  [CREATE VIEW in 0.11s]
3 of 8 OK created view  dbt_dev.stg_products ..........  [CREATE VIEW in 0.10s]
4 of 8 OK created view  dbt_dev.stg_order_items .......  [CREATE VIEW in 0.11s]
5 of 8 OK created view  dbt_dev.stg_payments ..........  [CREATE VIEW in 0.10s]
6 of 8 OK created view  dbt_dev.int_order_details ....  [CREATE VIEW in 0.13s]
7 of 8 OK created table dbt_dev.mart_customer_orders .  [SELECT 5 in 0.22s]
8 of 8 OK created table dbt_dev.mart_order_summary ...  [SELECT 5 in 0.25s]

PASS=8  WARN=0  ERROR=0  SKIP=0  TOTAL=8
```

---

## ✅ Verify the Output

```bash
psql -U dbt_user -d my_dbt_db
```

```sql
-- See all views and tables dbt created
\dt dbt_dev.*

-- Example 1 result
SELECT * FROM dbt_dev.mart_customer_orders;

-- Example 2 result
SELECT * FROM dbt_dev.mart_order_summary;
```

---

## 📖 Generate & Browse Documentation

```bash
dbt docs generate
dbt docs serve
```

Opens a browser at `http://localhost:8080` showing the full lineage graph, column descriptions, and test results.

---

## ✅ DBT Tests – Data Quality Checks

### 🤔 What are DBT Tests?

Tests are SQL queries that check if your data meets expectations. They run after your models are built and help you catch data quality issues early.

**Two types of tests:**

1. **Generic tests** — Built-in tests (unique, not_null, relationships, accepted_values)
2. **Singular tests** — Custom SQL tests you write yourself

---

### 📝 Step 1 – Add Generic Tests in `sources.yml`

Generic tests are defined in YAML and apply to specific columns.

Update **`models/staging/sources.yml`** to add tests:

```yaml
version: 2

sources:
  - name: raw
    schema: raw
    tables:
      - name: customers
        columns:
          - name: id
            tests:
              - unique          # ← each id must be unique
              - not_null        # ← id cannot be NULL
      - name: orders
        columns:
          - name: id
            tests:
              - unique
              - not_null
          - name: customer_id
            tests:
              - not_null
              - relationships:  # ← customer_id must exist in customers.id
                  to: source('raw', 'customers')
                  field: id
      - name: products
        columns:
          - name: id
            tests:
              - unique
              - not_null
      - name: order_items
        columns:
          - name: id
            tests:
              - unique
              - not_null
      - name: payments
        columns:
          - name: id
            tests:
              - unique
              - not_null
```

---

### 📝 Step 2 – Add Generic Tests to Models

Create a new YAML file for model tests:

```bash
touch models/staging/stg_models.yml
```

**`models/staging/stg_models.yml`**

```yaml
version: 2

models:
  # ── stg_customers tests ────────────────────────────────────
  - name: stg_customers
    description: Cleaned customers table
    columns:
      - name: customer_id
        description: Primary key for customers
        tests:
          - unique       # each customer should appear once
          - not_null
      - name: email
        description: Customer email address
        tests:
          - not_null
          - unique       # email should be unique (no duplicate emails)
      - name: full_name
        tests:
          - not_null

  # ── stg_orders tests ──────────────────────────────────────
  - name: stg_orders
    description: Cleaned orders table
    columns:
      - name: order_id
        description: Primary key for orders
        tests:
          - unique
          - not_null
      - name: customer_id
        description: Foreign key to customers
        tests:
          - not_null
          - relationships:
              to: ref('stg_customers')
              field: customer_id
      - name: status
        description: Order status
        tests:
          - not_null
          - accepted_values:  # ← status must be one of these values
              values: ['COMPLETED', 'PENDING', 'CANCELLED']
      - name: amount
        description: Order total amount
        tests:
          - not_null

  # ── stg_products tests ──────────────────────────────────────
  - name: stg_products
    description: Cleaned products table
    columns:
      - name: product_id
        description: Primary key for products
        tests:
          - unique
          - not_null
      - name: product_name
        tests:
          - not_null
      - name: list_price
        tests:
          - not_null

  # ── stg_order_items tests ──────────────────────────────────────
  - name: stg_order_items
    description: Cleaned order items table
    columns:
      - name: order_item_id
        tests:
          - unique
          - not_null
      - name: quantity
        tests:
          - not_null

  # ── stg_payments tests ──────────────────────────────────────
  - name: stg_payments
    description: Cleaned payments table
    columns:
      - name: payment_id
        tests:
          - unique
          - not_null

  # ── int_order_details tests ──────────────────────────────────────
  - name: int_order_details
    description: Order details with product information
    columns:
      - name: order_id
        tests:
          - not_null

  # ── mart_customer_orders tests ──────────────────────────────────────
  - name: mart_customer_orders
    description: Customer order summary
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
      - name: total_orders
        tests:
          - not_null

  # ── mart_order_summary tests ──────────────────────────────────────
  - name: mart_order_summary
    description: Full order summary with products and payment status
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
```

---

### 📝 Step 3 – Create Custom Singular Tests

Singular tests are custom SQL files in the `tests/` folder. Create:

```bash
touch tests/positive_amount.sql
touch tests/no_future_dates.sql
touch tests/order_items_match_orders.sql
```

**`tests/positive_amount.sql`**

> This test checks that all order amounts are positive (> 0).

```sql
-- Test: Order amounts should always be positive
SELECT *
FROM {{ ref('stg_orders') }}
WHERE amount <= 0
```

> 💡 **How singular tests work:**  
> If the query returns 0 rows, the test **passes** ✅  
> If it returns any rows, the test **fails** ❌ and dbt shows you the rows that failed.

**`tests/no_future_dates.sql`**

> Check that order dates are not in the future.

```sql
-- Test: Order dates should not be in the future
SELECT *
FROM {{ ref('stg_orders') }}
WHERE order_date > CURRENT_DATE
```

**`tests/order_items_match_orders.sql`**

> Check that every order_item belongs to an actual order.

```sql
-- Test: All order items must have a corresponding order
SELECT oi.*
FROM {{ ref('stg_order_items') }} oi
LEFT JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
```

---

### ▶️ Step 4 – Run the Tests

In your project folder:

```bash
cd my_dbt_project
```

#### Run all tests:

```bash
dbt test
```

#### Run tests for a specific model:

```bash
dbt test --select stg_customers
```

#### Run tests and show which ones fail:

```bash
dbt test --fail-fast
```

---

### 📊 Expected Output

When all tests pass, you'll see:

```
Running with dbt=1.7.x
Found 28 tests

 1 of 28 PASS test_unique_raw_customers_id ...................... [PASS]
 2 of 28 PASS test_not_null_raw_customers_id .................... [PASS]
 3 of 28 PASS test_unique_raw_orders_id ........................ [PASS]
 4 of 28 PASS test_not_null_raw_orders_id ...................... [PASS]
 5 of 28 PASS test_relationships_raw_orders_customer_id ........ [PASS]
 6 of 28 PASS test_unique_stg_customers_customer_id ............ [PASS]
 7 of 28 PASS test_not_null_stg_customers_customer_id .......... [PASS]
 8 of 28 PASS test_unique_stg_customers_email .................. [PASS]
 9 of 28 PASS test_not_null_stg_customers_email ................ [PASS]
10 of 28 PASS test_unique_stg_orders_order_id .................. [PASS]
11 of 28 PASS test_not_null_stg_orders_order_id ................ [PASS]
12 of 28 PASS test_not_null_stg_orders_customer_id ............. [PASS]
13 of 28 PASS test_relationships_stg_orders_customer_id ........ [PASS]
14 of 28 PASS test_not_null_stg_orders_status .................. [PASS]
15 of 28 PASS test_accepted_values_stg_orders_status ........... [PASS]
16 of 28 PASS test_not_null_stg_orders_amount .................. [PASS]
17 of 28 PASS test_unique_stg_products_product_id .............. [PASS]
18 of 28 PASS test_not_null_stg_products_product_id ............ [PASS]
19 of 28 PASS test_not_null_stg_products_product_name .......... [PASS]
20 of 28 PASS test_not_null_stg_products_list_price ............ [PASS]
21 of 28 PASS test_unique_stg_order_items_order_item_id ........ [PASS]
22 of 28 PASS test_not_null_stg_order_items_order_item_id ...... [PASS]
23 of 28 PASS test_not_null_stg_order_items_quantity ........... [PASS]
24 of 28 PASS test_positive_amount ............................... [PASS]
25 of 28 PASS test_no_future_dates ............................... [PASS]
26 of 28 PASS test_order_items_match_orders ..................... [PASS]
27 of 28 PASS test_unique_mart_customer_orders_customer_id ...... [PASS]
28 of 28 PASS test_not_null_mart_customer_orders_total_orders ... [PASS]

PASS=28  WARN=0  ERROR=0  SKIP=0  TOTAL=28
```

✅ **All tests passed!**

---

### 🎯 Understanding Each Test Type

| Test Type | What it checks | Example |
|-----------|----------------|---------|
| `unique` | Column has no duplicates | No two customers have the same id |
| `not_null` | Column has no NULL values | Every order must have a customer_id |
| `relationships` | Foreign key is valid | order.customer_id exists in customer.id |
| `accepted_values` | Column only has specific values | order.status is one of [COMPLETED, PENDING, CANCELLED] |
| Singular test | Custom SQL rule | Amounts are always positive |

---

### 🛠️ Combine Run + Test

Run your models AND test them in one command:

```bash
dbt run && dbt test
```

Or run a specific model and its tests:

```bash
dbt run --select stg_customers && dbt test --select stg_customers
```

---

### 📖 View Test Results in Documentation

After running tests, generate docs to see which tests passed:

```bash
dbt docs generate
dbt docs serve
```

The docs site shows test results and will highlight columns that have tests.

---

## 📂 Final Project Structure

```
my_dbt_project/
├── dbt_project.yml
├── models/
│   ├── staging/
│   │   ├── sources.yml              ← tells dbt about raw tables
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_products.sql
│   │   ├── stg_order_items.sql
│   │   └── stg_payments.sql
│   ├── intermediate/
│   │   └── int_order_details.sql    ← stepping stone model (Example 2)
│   └── marts/
│       ├── mart_customer_orders.sql ← Example 1 final output
│       └── mart_order_summary.sql   ← Example 2 final output
├── tests/
├── macros/
└── target/                          ← compiled SQL (auto-generated)
```

---

## 🔑 Key DBT Concepts at a Glance

| Concept | What it means in plain English |
|---------|-------------------------------|
| `source('raw', 'customers')` | "Read from the raw table called customers — it already exists in the DB" |
| `ref('stg_customers')` | "Use the dbt model called stg_customers as my input" |
| `materialized: view` | "Don't store data, just save the SQL query. Runs fresh every time." |
| `materialized: table` | "Actually create a physical table and store the results." |
| Staging model | A cleaned-up copy of one raw table. Always 1-to-1 with a raw table. |
| Intermediate model | A model that combines/joins staging models. A stepping stone. |
| Mart model | The final business-ready table. This is what analysts query. |

---

## 🐛 Common Issues & Fixes

| Error | Fix |
|-------|-----|
| `Connection refused` | Ensure PostgreSQL is running: `brew services start postgresql` |
| `Role does not exist` | Create the user in psql: `CREATE USER dbt_user WITH PASSWORD '...'` |
| `Schema does not exist` | dbt creates it automatically on first `dbt run` |
| `dbt: command not found` | Activate your virtual env: `source dbt-env/bin/activate` |
| `Compilation error: source not found` | Check `sources.yml` — the source name and schema must match |
| `ref() not found` | Make sure the model file exists and the name matches exactly |

---

> 🎉 **You're all set!**  
> - **Example 1** showed the simplest pattern: raw → staging → mart (2 layers).  
> - **Example 2** showed the intermediate pattern: raw → staging → intermediate → mart (3 layers).  
> Use the intermediate layer whenever a join or transformation is complex enough to deserve its own model.

