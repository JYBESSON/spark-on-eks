package com.jybesson

import org.apache.log4j.{Level, Logger}
import org.apache.spark.sql.SparkSession

class SparkOnEks {

    def main(args: Array[String]) = {

      Logger.getLogger("org").setLevel(Level.ERROR)
      Logger.getLogger("akka").setLevel(Level.ERROR)

      val spark =
        SparkSession.builder.
          appName("spark-on-eks").
          getOrCreate()

      //YOUR CODE HERE
      spark.sql("SELECT 1")

      spark.stop()

    }

}