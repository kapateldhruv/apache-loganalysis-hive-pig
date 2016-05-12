
 -- Find page views by browser
 -- https://github.com/kapateldhruv/hiveuaparser

CREATE TEMPORARY FUNCTION useragentparser AS 'kapatel.dhruv.hiveuaparser.HiveuaparserUDF';

INSERT OVERWRITE DIRECTORY '/hiveresults/top_browsers' 
SELECT agent_family,count(*) AS counter FROM (
SELECT useragentparser(agent,"USERAGENT_FAMILY") AS agent_family FROM log_analysis.cleanned_logs 
)x
GROUP BY agent_family
ORDER BY counter DESC
;
