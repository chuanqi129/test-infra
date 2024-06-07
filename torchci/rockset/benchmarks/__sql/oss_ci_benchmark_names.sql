--- This query is used by HUD benchmarks dashboards to get the list of experiment names
SELECT DISTINCT
  o.filename,  
  o.name,  
  o.metric,
FROM
  benchmarks.oss_ci_benchmark o
  LEFT JOIN commons.workflow_run w ON o.workflow_id = w.id
WHERE
  o._event_time >= PARSE_DATETIME_ISO8601(: startTime)
  AND o._event_time < PARSE_DATETIME_ISO8601(: stopTime)
  AND (
    ARRAY_CONTAINS(
      SPLIT(: filenames, ','),
      o.filename
    )
    OR : filenames = ''
  )
  AND o.metric IS NOT NULL
  AND w.html_url LIKE CONCAT('%', : repo, '%')
ORDER BY
  o.filename,  
  o.name,
  o.metric