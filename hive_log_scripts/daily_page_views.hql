
-- Shows daily page views 


INSERT OVERWRITE DIRECTORY '/hiveresults/daily_page_views' 
SELECT real_date,COUNT(url) AS page_views FROM 
(
SELECT TO_DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(SUBSTR(time,2,11), 'dd/MMM/yyyy'))) AS real_date,url FROM log_analysis.cleanned_logs order BY real_date ASC
)x
GROUP BY real_date;
