-- Předpokládá vložení testovacích dat z 07_testovaci_data.sql

-- UserAccount: Atribut AMOUNT nesmí být menší než 0.
UPDATE "UserAccount" SET AMOUNT = -500 WHERE ID = 1;

-- UserBet: Atribut BET_AMOUNT musí být kladné číslo
INSERT INTO "UserBet" (BET_AMOUNT, CREATED_AT, BET_ID, USER_ID) VALUES (-200, TO_DATE('8/11/2020', 'MM/DD/YYYY'), 1, 1);
INSERT INTO "UserBet" (BET_AMOUNT, CREATED_AT, BET_ID, USER_ID) VALUES (0, TO_DATE('8/11/2020', 'MM/DD/YYYY'), 1, 1);

-- Bet: Atribut START_DATE <= END_DATE
INSERT INTO "Bet" (START_DATE, END_DATE, DESCRIPTION, RATE, MATCH_ID) VALUES (TO_DATE('5/18/2021', 'MM/DD/YYYY'), TO_DATE('5/17/2021', 'MM/DD/YYYY'), 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 27.8, 1);

-- Bet: Atribut RATE > 1
INSERT INTO "Bet" (START_DATE, END_DATE, DESCRIPTION, RATE, MATCH_ID) VALUES (TO_DATE('5/18/2021', 'MM/DD/YYYY'), TO_DATE('5/17/2021', 'MM/DD/YYYY'), 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 1, 1);
INSERT INTO "Bet" (START_DATE, END_DATE, DESCRIPTION, RATE, MATCH_ID) VALUES (TO_DATE('5/18/2021', 'MM/DD/YYYY'), TO_DATE('5/17/2021', 'MM/DD/YYYY'), 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', -2, 1);

-- Match: Atribut TEAM1 <> TEAM2
INSERT INTO "Match" (TEAM1, TEAM2, PLAYED_AT, DESCRIPTION, RESULT) VALUES (4, 4, TO_DATE('3/12/2021', 'mm/dd/yyyy'), 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', 'WIN');

-- Match: Atribut RESULT se rovná UNKNOWN, WIN nebo LOSS
INSERT INTO "Match" (TEAM1, TEAM2, PLAYED_AT, DESCRIPTION, RESULT) VALUES (4, 4, TO_DATE('3/12/2021', 'mm/dd/yyyy'), 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', 'HELLO');

-- Team: Atributy WINS a LOSSES jsou nezáporné
INSERT INTO "Team" (NAME, WINS, LOSSES, RATING) VALUES ('Bitwolf', -1, 27, 0.2);
INSERT INTO "Team" (NAME, WINS, LOSSES, RATING) VALUES ('Bitwolf', 94, -1, 0.2);

-- Uživatel při registraci dosáhl věku 18 let
INSERT INTO "User" (FIRST_NAME, LAST_NAME, EMAIL, PASSWORD, BIRTHDATE, ADMIN) VALUES ('Arabela', 'Lopes', 'alopes0@cyberchimps.com', 'NyOQLQ37OKlW', TO_DATE('5/14/2005', 'MM/DD/YYYY'), 0);

-- Koncové datum sázky musí být před datumem konání zápasu
INSERT INTO "Bet" (START_DATE, END_DATE, DESCRIPTION, RATE, MATCH_ID) VALUES (TO_DATE('5/17/2019', 'MM/DD/YYYY'), TO_DATE('9/1/2020', 'MM/DD/YYYY'), 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 27.8, 1);
INSERT INTO "Bet" (START_DATE, END_DATE, DESCRIPTION, RATE, MATCH_ID) VALUES (TO_DATE('5/17/2019', 'MM/DD/YYYY'), TO_DATE('8/29/2020', 'MM/DD/YYYY'), 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 27.8, 1);