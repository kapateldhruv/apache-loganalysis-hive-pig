/*
* find page views by countries
* https://github.com/kapateldhruv/piggeoip
*
*/


cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, uri: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

REGISTER /home/dhruv/pig_loganalysis_udf_jars/piggeoip-0.0.1-SNAPSHOT.jar;
DEFINE geoip kapatel.dhruv.piggeoip.Geoip();

get_country = FOREACH cleanned_logs GENERATE geoip(host,'COUNTRY_CODE','/home/dhruv/hive_loganalysis_udf_jars/GeoLite2-City.mmdb') AS country_code;
groupped = GROUP get_country BY country_code;
get_counter = FOREACH groupped GENERATE group,COUNT(get_country.country_code) AS counter;
ordered_countries = ORDER get_counter BY counter DESC;
STORE ordered_countries INTO '/pigresults/geoip_pageview';
