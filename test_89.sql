-- postgresql

-- test 8
SELECT u.*
FROM users u LEFT JOIN cards c ON u.user_id = c.user_id
WHERE c.user_id IS NULL;

-- test 9
SELECT u.* FROM users u JOIN 
    (SELECT user_id, count(*) FROM cards GROUP BY 1 HAVING count(*) > 1) c
ON u.user_id = c.user_id;
