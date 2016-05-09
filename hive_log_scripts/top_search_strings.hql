
 -- Find top search strigns entered by visitors to our search page. 
 -- 
 -- Note: In my case search string appended in query string as s=search_string.
 -- Kindly replace with your query string parameter name. 


INSERT OVERWRITE DIRECTORY '/hiveresults/top_search_strings' 
SELECT search_string,COUNT(search_string) AS counter FROM
(
SELECT reflect("java.net.URLDecoder", "decode",regexp_extract(url,'.*s=(.*)&',1)) AS search_string FROM log_analysis.cleanned_logs WHERE url LIKE '%s=%'
)x
GROUP BY search_string
ORDER BY counter DESC
;
