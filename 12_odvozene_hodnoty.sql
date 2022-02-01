-- Pro tabulku Bet se bude vypočítávat průměrná vsazená částka všech uživatelů na danou sázku
ALTER TABLE "Bet" ADD (AVERAGE_BET_AMOUNT NUMBER(8, 2) DEFAULT 0);

-- Procedura pro aktualizaci průměrné vsazené částky všech uživatelů
CREATE PROCEDURE UPDATE_AVERAGE_BET_VALUE(b_id IN NUMBER) AS
BEGIN
    UPDATE "Bet" B
    SET AVERAGE_BET_AMOUNT = (select ROUND(avg(BET_AMOUNT),2) from "UserBet" UB where UB.BET_ID = b_id)
    WHERE B.ID = b_id;
END;
/

-- Trigger, který se spustí při vložení/aktualizaci uživatelské sázky
CREATE OR REPLACE TRIGGER TRG_UPDATE_BET_AVERAGE_AMOUNT
FOR INSERT OR UPDATE ON "UserBet"
COMPOUND TRIGGER

TYPE user_bet_t IS TABLE OF "UserBet"."BET_ID"%type INDEX BY binary_integer;
user_bets user_bet_t;

AFTER EACH ROW IS
BEGIN
    user_bets(user_bets.COUNT + 1) := :new.bet_id;
END AFTER EACH ROW;

AFTER STATEMENT IS
BEGIN
    FOR indx IN 1 .. user_bets.COUNT
     LOOP
            UPDATE_AVERAGE_BET_VALUE(user_bets(indx));
    END LOOP;
END AFTER STATEMENT;

END;
/

-- Otestování - průměrná hodnota pro Bet s ID = 1 je 58649,23, po přidání 2 uživatelských sázek se změní na 36824,62
insert into "UserBet" (BET_AMOUNT, CREATED_AT, USER_ID, BET_ID) values (20000, TO_DATE('08/06/2021','dd/mm/yyyy'), 339, 1);
insert into "UserBet" (BET_AMOUNT, CREATED_AT, USER_ID, BET_ID) values (10000, TO_DATE('08/06/2021','dd/mm/yyyy'), 339, 1);
