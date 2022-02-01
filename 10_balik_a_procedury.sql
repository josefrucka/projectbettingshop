create or replace PACKAGE betting_shop_mgmt AS
   PROCEDURE registrace_sazkare(email VARCHAR2, first_name VARCHAR2, last_name VARCHAR2, admin CHAR, birthdate DATE, amount NUMBER, descr VARCHAR2, pass VARCHAR2);
   PROCEDURE novy_zapas(team1 VARCHAR2, team2 VARCHAR2, played_at DATE, descr VARCHAR2, res VARCHAR2, rate_win_team1 NUMBER, rate_win_team2 NUMBER, descrbet_team1 VARCHAR2, descrbet_team2 VARCHAR2);
END betting_shop_mgmt;
/

create or replace PACKAGE BODY betting_shop_mgmt AS
   PROCEDURE registrace_sazkare(email VARCHAR2, first_name VARCHAR2, last_name VARCHAR2, admin CHAR, birthdate DATE, amount NUMBER, descr VARCHAR2, pass VARCHAR2)
   AS
   BEGIN
   INSERT INTO "User"("ID", "FIRST_NAME", "LAST_NAME", "EMAIL", "ADMIN", "BIRTHDATE", "PASSWORD") VALUES ("SEQ_User_ID".nextval , first_name, last_name, email, admin, birthdate, pass);
   INSERT INTO "UserAccount"("ID", "AMOUNT", "DESCRIPTION", "USER_ID") VALUES ("SEQ_UserAccount_ID".nextval, amount, descr, "SEQ_User_ID".currval);
   END registrace_sazkare;

   PROCEDURE novy_zapas(team1 VARCHAR2, team2 VARCHAR2, played_at DATE, descr VARCHAR2, res VARCHAR2, rate_win_team1 NUMBER, rate_win_team2 NUMBER, descrbet_team1 VARCHAR2, descrbet_team2 VARCHAR2)
   AS
    id_team_1 NUMBER(8);
    id_team_2 NUMBER(8);

   BEGIN
   SELECT "ID" INTO id_team_1 from "Team" where "NAME" = team1 and rownum=1;
   SELECT "ID" INTO id_team_2 from "Team" where "NAME" = team2 and rownum=1;

    INSERT INTO "Match"("ID","TEAM1", "TEAM2", "PLAYED_AT", "DESCRIPTION", "RESULT") VALUES ("SEQ_Match_ID".nextval,id_team_1, id_team_2, played_at, descr, res);
    INSERT INTO "Bet"("ID", "RATE", "START_DATE", "END_DATE","DESCRIPTION","MATCH_ID")
            VALUES ("SEQ_Bet_ID".nextval, rate_win_team1, sysdate, played_at - 1, descrbet_team1,"SEQ_Match_ID".currval);
    INSERT INTO "Bet"("ID", "RATE", "START_DATE", "END_DATE","DESCRIPTION","MATCH_ID")
            VALUES ("SEQ_Bet_ID".nextval, rate_win_team2, sysdate, played_at - 1, descrbet_team2,"SEQ_Match_ID".currval);
   END novy_zapas;
END betting_shop_mgmt;
/