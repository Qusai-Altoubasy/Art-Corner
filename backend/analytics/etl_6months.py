import os
import pandas as pd
from sqlalchemy import create_engine

DB_URL = os.getenv("DB_URL")
if not DB_URL:
    raise RuntimeError("DB_URL is not set.")

engine = create_engine(DB_URL)

def run():
    df = pd.read_sql("SELECT * FROM monthly_sales", engine)

    if df.empty:
        print("No data found in monthly_sales view.")
        return

    customer = (df.groupby("customer_id", as_index=False)
                  .agg(
                      revenue=("revenue", "sum"),
                      cost=("cost", "sum"),
                      profit=("profit", "sum"),
                      items=("quantity", "sum"),
                      orders=("sale_id", "nunique"),
                  ))
    customer["profit_margin"] = (customer["profit"] / customer["revenue"]).fillna(0)

    product = (df.groupby("product_id", as_index=False)
                 .agg(
                     revenue=("revenue", "sum"),
                     cost=("cost", "sum"),
                     profit=("profit", "sum"),
                     qty=("quantity", "sum"),
                     orders=("sale_id", "nunique"),
                 ))
    product["profit_margin"] = (product["profit"] / product["revenue"]).fillna(0)

    customer.to_sql("analytics_customer_6m", engine, if_exists="replace", index=False)
    product.to_sql("analytics_product_6m", engine, if_exists="replace", index=False)

if __name__ == "__main__":
    run()
