import os
import pandas as pd
from sqlalchemy import create_engine

DB_URL = os.getenv("DB_URL")
if not DB_URL:
    raise RuntimeError("DB_URL is not set.")

engine = create_engine(DB_URL)

def run():
    df = pd.read_sql("SELECT * FROM inventory_risk_6m", engine)

    if df.empty:
        raise RuntimeError("No data found in inventory_risk_6m view.")

    df = df.sort_values(by=["days_of_stock_left"], na_position="last")
    df.to_sql("analytics_inventory_risk_6m", engine, if_exists="replace", index=False)


if __name__ == "__main__":
    run()
