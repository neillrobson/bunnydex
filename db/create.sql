CREATE TABLE cards(id INTEGER PRIMARY KEY, card_id TEXT, title TEXT);

INSERT INTO cards (card_id, title) SELECT
    json_extract(value, '$.id'),
    json_extract(value, '$.title')
FROM json_each(readfile('01_deck_blue.json'));
