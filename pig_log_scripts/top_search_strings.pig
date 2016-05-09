/**
 * Find top search strigns entered by visitors to our search page. 
 * 
 * Note: In my case search string appended in query string as s=search_string.
 * Kindly replace with your query string parameter name. 
 * 
 */

cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, url: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

DEFINE UrlDecode InvokeForString('java.net.URLDecoder.decode', 'String String'); 
filtered_logs = FILTER cleanned_logs BY (url matches '.*s=.*');
formatted_logs = FOREACH filtered_logs GENERATE REGEX_EXTRACT(url,'.*s=(.*)&',1) AS search_string;
decoded_strings = FOREACH formatted_logs GENERATE UrlDecode(search_string,'UTF-8') as decoded;
groupped = GROUP decoded_strings by $0;
top_search_strings = FOREACH groupped GENERATE group,COUNT(decoded_strings.decoded) AS counter;
ordered_strings = ORDER top_search_strings BY counter DESC;  
STORE ordered_strings INTO '/pigresults/search_strings_result';
