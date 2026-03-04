from pyspark.sql import SparkSession
from pyspark.sql.functions import col, current_timestamp
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType

spark = SparkSession.builder.appName("BaseballIngestion").getOrCreate()

RAW_BASE_PATH = "s3://platform-raw-dev/"
CURATED_BASE_PATH = "s3://platform-curated-dev/"

TABLES = [
    "Batting",
    "People",
    "Salaries",
    "Schools",
    "CollegePlaying"
]


def validate_required_columns(df, required_cols, table_name):
    missing = [c for c in required_cols if c not in df.columns]
    if missing:
        raise ValueError(f"{table_name}: Missing required columns: {missing}")


def basic_dq_checks(df, table_name):
    if "yearID" in df.columns:
        df = df.filter((col("yearID") > 1800) & (col("yearID") < 2100))

    if "teamID" in df.columns:
        df = df.filter(col("teamID").isNotNull())

    return df


def ingest_table(table_name):
    raw_path = f"{RAW_BASE_PATH}{table_name}.csv"
    curated_path = f"{CURATED_BASE_PATH}{table_name}"

    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv(raw_path)
    )

    validate_required_columns(df, ["yearID"], table_name) if "yearID" in df.columns else None

    df = basic_dq_checks(df, table_name)

    df = df.withColumn("ingested_at", current_timestamp())

    if table_name == "Batting":
        (
            df.write
            .format("delta")
            .mode("overwrite")
            .option("overwriteSchema", "true")
            .partitionBy("yearID")
            .save(curated_path)
        )
    else:
        (
            df.write
            .format("delta")
            .mode("overwrite")
            .option("overwriteSchema", "true")
            .save(curated_path)
        )


def main():
    for table in TABLES:
        ingest_table(table)

    print("Ingestion completed successfully.")


if __name__ == "__main__":
    main()