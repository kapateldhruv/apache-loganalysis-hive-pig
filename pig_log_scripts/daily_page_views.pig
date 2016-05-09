/**
 * Shows daily page views 
 *
 * 
 */

cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, url: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

formatted_logs = FOREACH cleanned_logs GENERATE ToDate(SUBSTRING(time,1,12),'dd/MMM/yyyy') AS date,url;
ordered_by_date = ORDER formatted_logs BY date ASC;
groupped = GROUP ordered_by_date BY date;
count_views = FOREACH groupped GENERATE ToString(group,'dd/MMM/yyyy') AS string_date,COUNT(ordered_by_date.url) AS daily_views; 
STORE count_views INTO '/pigresults/daily_page_views';
