/**
 * Find top referrers of website. 
 *
 * 
 */

cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, uri: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

remove_quotes = FOREACH cleanned_logs GENERATE STRSPLIT(referer,'"',4) as q;
plain_referer = FOREACH remove_quotes GENERATE q.$1 as r;
formatted_logs = FOREACH plain_referer GENERATE STRSPLIT(r,'/',4) AS test;
referer_hosts = FOREACH formatted_logs GENERATE (test.$2 is null?'-':test.$2);
groupped = GROUP referer_hosts by $0;
top_referer = FOREACH groupped GENERATE group,COUNT(referer_hosts) AS counter;
ordered_referer = ORDER top_referer BY counter DESC; 
STORE ordered_referer INTO '/pigresults/top_referrer';
