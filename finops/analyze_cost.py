import pandas as pd

df = pd.read_csv("data/aws_costs.csv")

print(df.groupby("service")["amount"].sum().sort_values(ascending=False))
print("Tag coverage:", df["tags"].notna().mean())