/*
* find page views by browser.
* https://github.com/kapateldhruv/uaparserpig
*
*/


cleanned_logs = LOAD '/user/hive/warehouse/log_analysis.db/cleanned_logs' USING PigStorage('\u0001') AS (host: chararray,time: chararray,method: chararray, uri: chararray, protocol: chararray,
status: int, size: int, referer: chararray, agent: chararray);

REGISTER /home/dhruv/pig_loganalysis_udf_jars/uaparserpig-0.0.1-SNAPSHOT.jar;
DEFINE useragentparser kapatel.dhruv.uaparserpig.PiguaparserUDF();

get_browser = FOREACH cleanned_logs GENERATE useragentparser(agent,'USERAGENT_FAMILY') AS agent_family;
groupped = GROUP get_browser BY agent_family;
get_counter = FOREACH groupped GENERATE group,COUNT(get_browser.agent_family) AS counter;
ordered_browsers = ORDER get_counter BY counter DESC;
STORE ordered_browsers INTO '/pigresults/top_browsers';
