/**
 * Find top 10 pages of website. 
 *
 * 
 */

cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, uri: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

groupped = group cleanned_logs by uri;
top_urls = foreach groupped generate group,COUNT(cleanned_logs) as counter;
ordered_top_urls = ORDER top_urls BY counter DESC;
final = limit ordered_top_urls 10;
STORE final INTO '/pigresults/topurl';
