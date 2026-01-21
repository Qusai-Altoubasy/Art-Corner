-- View: public.monthly_sales

-- DROP VIEW public.monthly_sales;

CREATE OR REPLACE VIEW public.monthly_sales
 AS
 SELECT s.id AS sale_id,
    s.date AS sale_date,
    s.customer_id,
    si.product_id,
    si.quantity,
    si.price AS revenue,
    si.purchase_price AS cost,
    si.price - si.purchase_price AS profit,
    si.status
   FROM sales s
     JOIN sale_items si ON si.sale_id = s.id
  WHERE s.date >= (date_trunc('month'::text, now()) - '6 mons'::interval) AND s.date < date_trunc('month'::text, now());

ALTER TABLE public.monthly_sales
    OWNER TO qusai;

