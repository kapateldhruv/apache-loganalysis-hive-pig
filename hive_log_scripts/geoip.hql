 -- page views from countries
 -- https://github.com/petrabarus/HiveUDFs


CREATE TEMPORARY FUNCTION geoip AS 'com.spuul.hive.GeoIP2';

INSERT OVERWRITE DIRECTORY '/hiveresults/geip_result' 
SELECT country_code,COUNT(*) AS counter FROM
(
SELECT 
geoip(host,'COUNTRY_CODE','/home/dhruv/hive_loganalysis_udf_jars/GeoLite2-City.mmdb') AS country_code FROM log_analysis.cleanned_logs
)x
GROUP BY country_code
ORDER BY counter DESC
;


