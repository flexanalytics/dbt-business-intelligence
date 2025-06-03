import pandas as pd

input_path = '/Users/michaelwork/dev/flex/internal/dbt-business-intelligence/seeds/sales_data_raw.csv'
output_path = input_path  # overwrite in place

df = pd.read_csv(input_path, dtype=str)  # preserve formatting
df['order_date'] = df['order_date'].str.replace("2022-", "2024-", regex=False)
df['order_date'] = df['order_date'].str.replace("2023-", "2025-", regex=False)
df.to_csv(output_path, index=False, lineterminator='\n')  # uniform line endings
