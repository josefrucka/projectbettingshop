SPOOL 17_analyticke_dotazy_output.txt

SET AUTOTRACE ON;
SET pagesize 50000;
SET heading ON;

prompt ================================
prompt = Dotaz, který zobrazí průměrnou vsazenou částku za rok 2020 a porovnání s průměrnou vsazenou částkou za rok 2021
prompt ================================
SELECT x.USER_ID, x.FIRST_NAME, x.LAST_NAME, x.AVERAGE_BET_AMOUNT_2020, y.AVERAGE_BET_AMOUNT_2021 FROM (
    SELECT U.ID as USER_ID, U.FIRST_NAME as FIRST_NAME, U.LAST_NAME as LAST_NAME, ROUND(AVG(UB.BET_AMOUNT), 2) as AVERAGE_BET_AMOUNT_2020
    FROM DW_USER_BET_DETAIL UBD
    JOIN DW_USER U ON UBD.USER_ID = U.ID
    JOIN DW_USER_BET UB ON UBD.USER_BET_ID = UB.ID
    WHERE UB.CREATED_AT >= TO_DATE('01/01/2020') AND UB.CREATED_AT <= TO_DATE('31/12/2020')
    GROUP BY U.ID, U.FIRST_NAME, U.LAST_NAME
) x JOIN (
    SELECT U.ID as USER_ID, U.FIRST_NAME as FIRST_NAME, U.LAST_NAME as LAST_NAME, ROUND(AVG(UB.BET_AMOUNT), 2) as AVERAGE_BET_AMOUNT_2021
    FROM DW_USER_BET_DETAIL UBD
    JOIN DW_USER U ON UBD.USER_ID = U.ID
    JOIN DW_USER_BET UB ON UBD.USER_BET_ID = UB.ID
    WHERE UB.CREATED_AT >= TO_DATE('01/01/2021') AND UB.CREATED_AT <= TO_DATE('31/12/2021')
    GROUP BY U.ID, U.FIRST_NAME, U.LAST_NAME
) y ON x.USER_ID =  y.USER_ID;
prompt

prompt ================================
prompt = Dotaz, který zobrazí uživatele podle celkově vsazené částky a počtu sázek na zápasy odehrané v roce 2020
prompt ================================
SELECT U.ID, U.FIRST_NAME, U.LAST_NAME, SUM(UB.BET_AMOUNT) as TOTAL_BET_AMOUNT, count(UB.ID) as TOTAL_BETS
FROM DW_USER_BET_DETAIL UBD
JOIN DW_USER U ON UBD.USER_ID = U.ID
JOIN DW_USER_BET UB ON UBD.USER_BET_ID = UB.ID
JOIN DW_MATCH M ON UBD.MATCH_ID = M.ID
WHERE M.PLAYED_AT >= TO_DATE('01/01/2020') AND M.PLAYED_AT <= TO_DATE('31/12/2020')
GROUP BY U.ID, U.FIRST_NAME, U.LAST_NAME
ORDER BY TOTAL_BET_AMOUNT DESC, TOTAL_BETS DESC;
prompt


SPOOL OFF