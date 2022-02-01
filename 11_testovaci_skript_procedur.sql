SPOOL 11_testovaci_skript_output.txt

SET pagesize 50000;
SET heading ON;

prompt ================================
prompt = Procedura registrace_sazkare
prompt ================================
BEGIN
    betting_shop_mgmt.registrace_sazkare('dummymail@gmail.com', 'Testovaci' , 'Uzivatel' , '0', TO_DATE('13/05/1996','dd/mm/yyyy'), 9999, 'Nový účet pro dummyho', 'heslo1234');
END;
/
prompt

prompt ================================
prompt = Ověření, že byl sázkař vytvořen společně s jeho účtem
prompt ================================
SELECT * FROM "User"
join "UserAccount" on "User"."ID" = "UserAccount"."USER_ID"
where "User"."FIRST_NAME" = 'Testovaci';
prompt

prompt ================================
prompt = Procedura novy_zapas
prompt ================================
BEGIN 
    betting_shop_mgmt.novy_zapas('Aivee', 'Blogpad', to_date('24/12/2021', 'dd/mm/yyyy'), 'Testovaci zapas', 'UNKNOWN', to_number('1,20') , to_number('12,30'), 'Sazky pro Aivee', 'Sazky pro Blogpad');
END;
/
prompt

prompt ================================
prompt = Ověření, že se vytvořil zápas společně s 2 sázkami
prompt ================================
SELECT M.ID, M.DESCRIPTION, T1.NAME, T2.NAME FROM "Match" M
LEFT JOIN "Team" T1 on T1."ID" = M."TEAM1"
LEFT JOIN "Team" T2 on T2."ID" = M."TEAM2"
where "M"."DESCRIPTION" = 'Testovaci zapas' AND rownum = 1;

SELECT * FROM "Bet" WHERE END_DATE = TO_DATE('23/12/2021', 'dd/mm/yyyy');
prompt

SPOOL OFF