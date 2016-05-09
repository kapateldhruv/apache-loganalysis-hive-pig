
 -- Find top referrers of website. 


INSERT OVERWRITE DIRECTORY '/hiveresults/top_url' 
SELECT referer_host,COUNT(referer_host) AS counter FROM
(
SELECT COALESCE(split(split(referer,'"')[1],'/')[2],'-')  AS referer_host FROM log_analysis.cleanned_logs
)x
GROUP BY referer_host
ORDER BY  counter DESC
;
