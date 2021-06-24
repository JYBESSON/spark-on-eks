name := "spark"

version := "v1.0"

scalaVersion := "2.12.10"

resolvers += "Typesafe Repository" at "https://repo.typesafe.com/typesafe/releases/"
resolvers += "Mulesoft" at "https://repository.mulesoft.org/nexus/content/repositories/public/"

// additional librairies
libraryDependencies ++= {
  Seq(
    "org.apache.spark" %% "spark-core" % "3.1.1" % "provided",
    "org.apache.spark" %% "spark-sql" % "3.1.1" % "provided",
    "org.apache.hadoop" % "hadoop-aws" % "3.2.0" % "provided",
    "org.apache.hadoop" % "hadoop-common" % "3.2.0" % "provided"
  )
}

assemblyShadeRules in assembly := Seq(
  ShadeRule.rename("org.apache.commons.beanutils.**" -> "shaded-commons.beanutils.@1").inLibrary("commons-beanutils" % "commons-beanutils-core" % "1.8.0"),
  ShadeRule.rename("org.apache.commons.collections.**" -> "shaded-commons.collections.@1").inLibrary("commons-beanutils" % "commons-beanutils-core" % "1.8.0"),
  ShadeRule.rename("org.apache.commons.collections.**" -> "shaded-commons2.collections.@1").inLibrary("commons-beanutils" % "commons-beanutils" % "1.7.0"),
)

// testing configuration for Spark-testing-base package
fork in Test := true
javaOptions ++= Seq("-Xms512M", "-Xmx4g", "-XX:MaxPermSize=4g", "-XX:+CMSClassUnloadingEnabled")