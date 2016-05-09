
 -- Find top 10 pages of website. 


INSERT OVERWRITE DIRECTORY '/hiveresults/top_url' 
select url,count(*) as counter from log_analysis.cleanned_logs group by url order by counter DESC limit 10;

