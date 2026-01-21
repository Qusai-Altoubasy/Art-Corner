-- View: public.inventory_risk_6m

-- DROP VIEW public.inventory_risk_6m;

CREATE OR REPLACE VIEW public.inventory_risk_6m
 AS
 WITH sales_6m AS (
         SELECT si.product_id,
            si.quantity AS qty_sold,
            s.date::date AS day
           FROM sale_items si
             JOIN sales s ON s.id = si.sale_id
          WHERE s.date >= (now() - '6 mons'::interval)
        ), daily AS (
         SELECT sales_6m.product_id,
            sales_6m.day,
            sum(sales_6m.qty_sold) AS sold_qty_day
           FROM sales_6m
          GROUP BY sales_6m.product_id, sales_6m.day
        ), avg_daily AS (
         SELECT daily.product_id,
            avg(daily.sold_qty_day) AS avg_daily_sold
           FROM daily
          GROUP BY daily.product_id
        )
 SELECT p.id,
    p.name,
    p.quantity AS current_quantity,
    COALESCE(a.avg_daily_sold, 0::numeric) AS avg_daily_sold,
        CASE
            WHEN COALESCE(a.avg_daily_sold, 0::numeric) = 0::numeric THEN NULL::numeric
            ELSE p.quantity::numeric / a.avg_daily_sold
        END AS days_of_stock_left,
        CASE
            WHEN COALESCE(a.avg_daily_sold, 0::numeric) = 0::numeric THEN 'NO_DATA'::text
            WHEN (p.quantity::numeric / a.avg_daily_sold) < 7::numeric THEN 'CRITICAL'::text
            WHEN (p.quantity::numeric / a.avg_daily_sold) < 14::numeric THEN 'LOW'::text
            ELSE 'OK'::text
        END AS risk_level
   FROM products p
     LEFT JOIN avg_daily a ON a.product_id = p.id;

ALTER TABLE public.inventory_risk_6m
    OWNER TO qusai;

