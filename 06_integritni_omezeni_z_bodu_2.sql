-- UserAccount: Atribut AMOUNT nesmí být menší než 0.
ALTER TABLE "UserAccount" ADD CONSTRAINT user_account_check_amount CHECK (AMOUNT >= 0);

-- UserBet: Atribut BET_AMOUNT musí být kladné číslo
ALTER TABLE "UserBet" ADD CONSTRAINT user_bet_check_amount CHECK (BET_AMOUNT > 0);

-- Bet: Atribut START_DATE <= END_DATE
ALTER TABLE "Bet" ADD CONSTRAINT bet_check_dates CHECK (END_DATE >= START_DATE);

-- Bet: Atribut RATE > 1
ALTER TABLE "Bet" ADD CONSTRAINT bet_check_rate CHECK (RATE > 1);

-- Match: Atribut TEAM1 <> TEAM2
ALTER TABLE "Match" ADD CONSTRAINT match_check_teams CHECK (TEAM1 != TEAM2);

-- Match: Atribut RESULT se rovná UNKNOWN, WIN nebo LOSS
ALTER TABLE "Match" ADD CONSTRAINT match_check_result_value CHECK (RESULT in ('UNKNOWN', 'WIN', 'LOSS'));

-- Team: Atributy WINS a LOSSES jsou nezáporné
ALTER TABLE "Team" ADD CONSTRAINT team_check_wins CHECK (WINS >= 0);
ALTER TABLE "Team" ADD CONSTRAINT team_check_losses CHECK (LOSSES >= 0);

CREATE PROCEDURE IS_ADULT (birthdate IN DATE) AS
BEGIN
    IF months_between(current_date, birthdate) < 18 * 12 THEN
        raise_application_error( -20100, 'User must be over 18!' );
    END IF;
END;
/

-- Uživatel při registraci dosáhl věku 18 let
CREATE OR REPLACE TRIGGER TRG_USER_OVER_18
  BEFORE INSERT OR UPDATE ON "User" FOR EACH ROW
BEGIN
      IS_ADULT(:new.birthdate);
END;
/

CREATE PROCEDURE IS_BET_ENDING_DAY_BEFORE_MATCH(match_id IN NUMBER, bet_end_date IN DATE) AS match_date DATE;
BEGIN
    SELECT played_at INTO match_date from "Match" WHERE ID = match_id;

    IF match_date - bet_end_date <> 1 THEN
        raise_application_error( -20101, 'Bet must end 1 day before match play date' );
    END IF;
END;
/

-- Koncové datum sázky musí být přesně jeden den před datumem konání zápasu
CREATE OR REPLACE TRIGGER TRG_BET_ENDS_BEFORE_MATCH_PLAY_DATE
  BEFORE INSERT OR UPDATE ON "Bet" FOR EACH ROW
BEGIN
    IS_BET_ENDING_DAY_BEFORE_MATCH(:new.match_id, :new.end_date);
END;
/