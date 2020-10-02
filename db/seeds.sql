#BEGIN;

-- 1
DROP INDEX index_phone_numbers_on_full_number;

-- 2
INSERT INTO phone_numbers(full_number)
SELECT DISTINCT CONCAT(
  (ARRAY['67', '68', '96', '97', '98', '50', '66', '95', '99', '63', '93', '73', '91', '92', '94'])[generate_series], LPAD(GENERATE_SERIES(0, 9999999)::text, 7, '0'))
FROM GENERATE_SERIES(1,15)
;

-- 3
CREATE UNIQUE INDEX index_phone_numbers_on_full_number ON phone_numbers(full_number);

-- 4
DROP INDEX index_users_on_phone_number_id;

-- 5
INSERT INTO users(phone_number_id, created_at, updated_at)
SELECT phone_number_id, NOW(), NOW() FROM (
  SELECT DISTINCT ON(phone_number_id) (RANDOM() * 100000000 + 1)::int AS phone_number_id FROM GENERATE_SERIES(1, 1000000)
) AS res;

-- 6
CREATE UNIQUE INDEX index_users_on_phone_number_id ON users(phone_number_id);

-- 7
DROP INDEX index_user_contacts_on_phone_number_id_and_user_id;
DROP INDEX index_user_contacts_on_user_id;

-- 8
INSERT INTO user_contacts(user_id, phone_number_id, name)
SELECT user_id, phone_number_id, '' AS name FROM (
  SELECT DISTINCT ON(user_id, phone_number_id)
         (RANDOM() * 800000 + 1)::int AS user_id,
         (RANDOM() * 10000000 + 1)::int AS phone_number_id,
         GENERATE_SERIES((RANDOM() * 50)::int, (RANDOM() * 500)::int)
  FROM GENERATE_SERIES(1, 100000)
) AS res;

-- 9
CREATE UNIQUE INDEX index_user_contacts_on_phone_number_id_and_user_id ON user_contacts(phone_number_id, user_id);
CREATE INDEX index_user_contacts_on_user_id ON user_contacts(user_id);

-- COMMIT;
