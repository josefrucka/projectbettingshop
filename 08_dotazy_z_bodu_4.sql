SPOOL 08_dotazy_z_bodu_4_output.txt

SET AUTOTRACE ON;
SET pagesize 50000;
SET heading ON;

prompt ================================
prompt = 1. Všichni uživatelé se svým stavem konta seřazení sestupně
prompt ================================
SELECT FIRST_NAME, LAST_NAME, AMOUNT FROM "User" LEFT JOIN "UserAccount" ON "UserAccount".USER_ID = "User".ID ORDER BY AMOUNT DESC;
prompt

prompt ================================
prompt = 2. Seřadit týmy podle počtu odehraných zápasů.
prompt ================================
SELECT C.TEAM_ID, C.TEAM_NAME, SUM(C.NUM_OF_MATCHES) as TOTAL FROM (
    SELECT T.ID as TEAM_ID, T.NAME as TEAM_NAME, COUNT(T.ID) as NUM_OF_MATCHES FROM "Team" T
    RIGHT JOIN "Match" M ON M.Team1 = T.ID
    WHERE M.PLAYED_AT < SYSDATE
    GROUP BY T.ID, T.NAME
    UNION
    SELECT T.ID as TEAM_ID, T.NAME as TEAM_NAME, COUNT(T.ID) as NUM_OF_MATCHES FROM "Team" T
    RIGHT JOIN "Match" M ON M.Team2 = T.ID
    WHERE M.PLAYED_AT < SYSDATE
    GROUP BY T.ID, T.NAME

) C
GROUP BY C.TEAM_ID, C.TEAM_NAME
ORDER BY TOTAL DESC;
prompt

prompt ================================
prompt = 3. Počet týmů v jednotlivých kategoriích podle ratingu
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
           when RATING > 1.0 and RATING <= 5  then '1.0+ - 4.0'
           else 'over 5'
end) ORDER BY RATING_AVERAGE ASC;
prompt

prompt ================================
prompt = 4. 10 odehraných zápasů, které mají nejvíce uživatelských sázek
prompt ================================
SELECT * FROM (SELECT M.ID, T1.NAME as TEAM1, T2.NAME as TEAM2, COUNT(UB.ID) as NUM_OF_USER_BETS FROM "Match" M
LEFT JOIN "Bet" B ON M.ID = B.MATCH_ID
LEFT JOIN "UserBet" UB ON B.ID = UB.BET_ID
LEFT JOIN "Team" T1 ON M.TEAM1 = T1.ID
LEFT JOIN "Team" T2 ON M.TEAM2 = T2.ID
WHERE M.PLAYED_AT < SYSDATE
GROUP BY M.ID, T1.NAME, T2.NAME ORDER BY NUM_OF_USER_BETS DESC
) WHERE rownum <= 10;
prompt;

prompt ================================
prompt = 5. Uživatelské sázky, seřazené podle velikosti výhry
prompt ================================
SELECT * FROM (
SELECT M.ID, T1.NAME as TEAM1, T2.NAME as TEAM2, COUNT(UB.ID) as NUM_OF_USER_BETS FROM "Match" M
LEFT JOIN "Bet" B ON M.ID = B.MATCH_ID
LEFT JOIN "UserBet" UB ON B.ID = UB.BET_ID
LEFT JOIN "Team" T1 ON M.TEAM1 = T1.ID
LEFT JOIN "Team" T2 ON M.TEAM2 = T2.ID
WHERE M.PLAYED_AT < SYSDATE
GROUP BY M.ID, T1.NAME, T2.NAME ORDER BY NUM_OF_USER_BETS DESC
) WHERE rownum <= 10;
prompt

SPOOL OFF;