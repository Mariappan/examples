version = "1.0"

train {
  step process {
    image = "quay.io/basisai/workload-standard:v0.3.1"
    install = [
      "pip3 install --upgrade pip",
      "pip3 install -r requirements-gcp.txt",
    ]
    script = [
      {
        spark-submit {
          script = "preprocess.py"
          conf = {
            "spark.kubernetes.container.image"                      = "quay.io/basisai/workload-standard:v0.3.1"
            "spark.kubernetes.pyspark.pythonVersion"                = "3"
            "spark.driver.memory"                                   = "4g"
            "spark.driver.cores"                                    = "2"
            "spark.executor.instances"                              = "2"
            "spark.executor.memory"                                 = "4g"
            "spark.executor.cores"                                  = "2"
            "spark.memory.fraction"                                 = "0.5"
            "spark.sql.parquet.compression.codec"                   = "gzip"
            "spark.hadoop.fs.AbstractFileSystem.gs.impl"            = "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS"
            "spark.hadoop.google.cloud.auth.service.account.enable" = "true"
          }
        }
      }
    ]
    resources {
      cpu = "0.5"
      memory = "1G"
    }
  }

  parameters {
    RAW_SUBSCRIBERS_DATA = "gs://bedrock-sample/churn_data/subscribers.gz.parquet"
    RAW_CALLS_DATA       = "gs://bedrock-sample/churn_data/all_calls.gz.parquet"
    PROCESSED_DATA       = "gs://span-temp-production/churn_data/processed"
  }
}
