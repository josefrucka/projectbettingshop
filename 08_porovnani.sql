SPOOL 08_porovnani.txt

SET AUTOTRACE ON;
SET pagesize 50000;
SET heading ON;

prompt ================================
prompt = 3. Počet týmů v jednotlivých kategoriích podle ratingu - cost celkem 26 - efektivnější dotaz
prompt ================================
select
(case when RATING >= 0 and RATING <= 0.5    then '0 - 0.5'
           when RATING > 0.5 and RATING <= 1.0   then '0.5+ - 1.0'
           when RATING > 1.0 and RATING <= 5  then '1.0+ - 5.0'
           else 'over 5'
end) As RATING_RANGE,
count(*) as TEAM_TOTAL_COUNT,
ROUND(AVG(RATING),2) as RATING_AVERAGE
from "Team"
group by
(case when RATING >= 0 and RATING <= 0.5    then '0 - 0.5'
           when RATING > 0.5 and RATING <= 1.0   then '0.5+ - 1.0'
           when RATING > 1.0 and RATING <= 5  then '1.0+ - 5.0'
           else 'over 5'
end) ORDER BY RATING_AVERAGE ASC;
prompt

prompt ================================
prompt = 3. Počet týmů v jednotlivých kategoriích podle ratingu - alternativní - cost celkem 80
prompt ================================
SELECT '0 - 0.5' AS RATING_RANGE, COUNT(*) as TEAM_TOTAL_COUNT, ROUND(AVG(RATING),2) as RATING_AVERAGE  FROM "Team" WHERE RATING >= 0 AND RATING <= 0.5
UNION
SELECT '0.5+ - 1.0', COUNT(*) as TEAM_TOTAL_COUNT, ROUND(AVG(RATING),2) as RATING_AVERAGE  FROM "Team" WHERE RATING > 0.5 AND RATING <= 1.0
UNION
SELECT '1.0+ - 5.0', COUNT(*) as TEAM_TOTAL_COUNT, ROUND(AVG(RATING),2) as RATING_AVERAGE  FROM "Team" WHERE RATING > 1.0 AND RATING <= 5.0
UNION
SELECT 'over 5', COUNT(*) as TEAM_TOTAL_COUNT, ROUND(AVG(RATING),2) as RATING_AVERAGE  FROM "Team" WHERE RATING > 5.0;

prompt ================================
prompt = 4. 10 odehraných zápasů, které mají nejvíce uživatelských sázek - cost celkem 177
prompt ================================
SELECT M.ID, T1.NAME as TEAM1, T2.NAME as TEAM2, COUNT(UB.ID) as NUM_OF_USER_BETS FROM "Match" M
LEFT JOIN "Bet" B ON M.ID = B.MATCH_ID
LEFT JOIN "UserBet" UB ON B.ID = UB.BET_ID
LEFT JOIN "Team" T1 ON M.TEAM1 = T1.ID
LEFT JOIN "Team" T2 ON M.TEAM2 = T2.ID
WHERE M.PLAYED_AT < SYSDATE
GROUP BY M.ID, T1.NAME, T2.NAME ORDER BY NUM_OF_USER_BETS DESC, M.ID DESC
FETCH FIRST 10 ROWS ONLY;
prompt;

prompt ================================
prompt = 4. 10 odehraných zápasů, které mají nejvíce uživatelských sázek - alternativní - cost celkem 159 - efektivnější
prompt ================================
SELECT M.ID,
(SELECT NAME FROM "Team" T WHERE T.ID = M.TEAM1) as TEAM1,
 (SELECT NAME FROM "Team" T WHERE T.ID = M.TEAM2) as TEAM2,
  COUNT(UB.ID) as NUM_OF_USER_BETS
FROM "Match" M
LEFT JOIN "Bet" B ON M.ID = B.MATCH_ID
LEFT JOIN "UserBet" UB ON B.ID = UB.BET_ID
WHERE M.PLAYED_AT < SYSDATE
GROUP BY M.ID, TEAM1, TEAM2 ORDER BY NUM_OF_USER_BETS DESC, M.ID DESC
FETCH FIRST 10 ROWS ONLY;
prompt;

SPOOL OFF;