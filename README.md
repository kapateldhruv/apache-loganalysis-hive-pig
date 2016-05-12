# apache-loganalysis-hive-pig
hive and pig scripts to analyze apache weblogs

## Getting started
We had logs stored in default apache format. 
Before staring actual analysis we had performed cleaning and removed logs generated by crawlers, robots, multimedia files (images,fonts,videos), stylesheets and jquery files.

1. Create table in hive

```
CREATE TABLE cleanned_logs (
host STRING,
identity STRING,
user STRING,
time STRING,
method STRING,
url STRING,
protocol STRING,
status STRING,
size STRING,
referer STRING,
agent STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = '([^ ]*) ([^ ]*) ([^ ]*) (-|\\[[^\\]]*\\]) "(\\w*) (\\S*) (\\S*)" (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^ \"]*|\"[^\"]*\"))?',
  "output.format.string" = "%1$s %2$s %3$s %4$s %5$s %6$s %7$s %8$s %9$s %10$s %11$s"
)
STORED AS TEXTFILE;

```

2. Load data to hive table
```
LOAD DATA LOCAL INPATH "logs.txt" OVERWRITE INTO TABLE cleanned_logs;

```

You can use same table for the pig scripts as we did.

## How to run hits_browser and geoip scripts
These scripts required UDF. UDF link is mentioned in comments section of scripts. Create your own jar using steps given on udf readme.
+ For hive put UDF jars under `${HIVE_HOME}/auxlib/` so that you do not required to tun `ADD JAR` command everytime.
+ Modify pig scrpts and provice appropriate path of UDF jars.


