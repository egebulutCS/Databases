SELECT CD_CD.releasedBy
FROM CD_CD
GROUP BY CD_CD.releasedBy
HAVING COUNT(CD_CD.releasedBy) IN (
SELECT MAX(mycount)
FROM (
SELECT COUNT(CD_CD.releasedBy) AS mycount 
FROM CD_CD 
GROUP BY CD_CD.releasedBy) AS counts)