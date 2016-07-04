DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id     serial PRIMARY KEY,
    login       varchar(20) NOT NULL UNIQUE,
    password    varchar(20)
);

CREATE TABLE cards (
    card_id     serial PRIMARY KEY,
    user_id     int NOT NULL REFERENCES users(user_id),
    name        varchar(20),
    surname     varchar(20)
);
CREATE INDEX user_id_idx ON cards(user_id);


INSERT INTO users (login) SELECT 'user_' || l::varchar FROM generate_series(1, 100000) l;
INSERT INTO cards (user_id, name) SELECT u.user_id, u.login || ' name' 
    FROM users u WHERE user_id > 20;
INSERT INTO cards (user_id, name) SELECT u.user_id, u.login || ' double' 
    FROM users u WHERE user_id >= 20 and user_id <= 30;




