CREATE TABLE "USER"(
    ACCOUNT SMALLINT GENERATED ALWAYS AS IDENTITY (INCREMENT BY 1 MINVALUE 1000 MAXVALUE 9999 START WITH 1001 NO CYCLE),
    CPF NUMERIC(11, 0) NOT NULL,
    FULL_NAME VARCHAR(128) NOT NULL,
    BIRTH_DATE DATE NOT NULL,
    PHONE_NUMBER VARCHAR(15) NOT NULL,
    EMAIL VARCHAR(64) NOT NULL,
    LOGIN_PASSWORD CHAR(60) NOT NULL,
    CARD_PASSWORD CHAR(60) NOT NULL, -- Check for 6 numeric digits on backend.
    CONSTRAINT PK_USER_0 PRIMARY KEY (ACCOUNT),
    CONSTRAINT UK_USER_0 UNIQUE (CPF, EMAIL)
);

CREATE TABLE ACCOUNT(
    "NUMBER" SMALLINT,
    "TYPE" NUMERIC(1, 0),
    BALANCE MONEY NOT NULL DEFAULT 0,
    IS_ACTIVE BOOLEAN DEFAULT TRUE,
    CONSTRAINT PK_ACCOUNT_0 PRIMARY KEY ("NUMBER", "TYPE"),
    CONSTRAINT FK_ACCOUNT_O FOREIGN KEY ("NUMBER")
        REFERENCES "USER" (ACCOUNT)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    CONSTRAINT CK_ACCOUNT_0 CHECK ("TYPE" in (0, 1, 2)) -- Corrente (0), Poupanca (1), Salário (2)
);

CREATE TABLE "TRANSACTION"(
    SENDER_ACCOUNT SMALLINT,
    "TIMESTAMP" TIMESTAMP,
    SENDER_ACCOUNT_TYPE NUMERIC(1, 0), -- Corrente (0), Poupanca (1), Salário (2)
    RECIPIENT_ACCOUNT SMALLINT,
    RECIPIENT_ACCOUNT_TYPE NUMERIC(1, 0), -- Corrente (0), Poupanca (1), Salário (2)
    "TYPE" NUMERIC(1, 0) NOT NULL, -- Depósito, Retirada, Transferência
    AMOUNT MONEY NOT NULL,
    CONSTRAINT PK_TRANSACTION_0 PRIMARY KEY (SENDER_ACCOUNT, "TIMESTAMP"),
    CONSTRAINT FK_TRANSACTION_O FOREIGN KEY (SENDER_ACCOUNT, SENDER_ACCOUNT_TYPE)
        REFERENCES ACCOUNT ("NUMBER", "TYPE")
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    CONSTRAINT FK_TRANSACTION_1 FOREIGN KEY (RECIPIENT_ACCOUNT, RECIPIENT_ACCOUNT_TYPE)
        REFERENCES ACCOUNT ("NUMBER", "TYPE")
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    CONSTRAINT CK_TRANSACTION_0 CHECK (("TYPE" = 1 AND RECIPIENT_ACCOUNT IS NULL AND RECIPIENT_ACCOUNT_TYPE IS NULL)
        OR ("TYPE" <> 1 AND RECIPIENT_ACCOUNT IS NOT NULL AND RECIPIENT_ACCOUNT_TYPE IS NOT NULL))
);

CREATE OR REPLACE FUNCTION public.insert_first_account()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
begin
	-- inserir conta para o usuário
	INSERT INTO "account" VALUES (new.account, 0, DEFAULT, DEFAULT);
    return new;
end
$BODY$;

CREATE TRIGGER tr_user_ad AFTER INSERT
	ON "user"
	FOR EACH ROW
	EXECUTE FUNCTION insert_first_account();

