WITH t1 AS (SELECT _name AS name, STRPOS (_name, '.') strpos_point, LENGTH (_name) length, LENGTH (_name) - STRPOS (_name, '.') AS x
            FROM ethereumnameservice."DefaultReverseResolver_call_setName"),
     t2 AS (SELECT t1.name,
        LEFT (t1.name, t1.strpos_point-1) AS name1,
        RIGHT (t1.name, t1.x) AS rest,
        CASE WHEN t1.x = 3 THEN 'domain' ELSE 'subdomain' END AS domain_type,
        LENGTH (LEFT (t1.name, t1.strpos_point-1)) AS name_length
        FROM t1
        WHERE t1.name LIKE '%.eth')
SELECT '3' as num_chars, SUM (CASE WHEN t2.name_length = 3 THEN 1 ELSE 0 END) as num FROM t2 WHERE domain_type LIKE 'domain'
UNION
SELECT '4' as num_chars, SUM (CASE WHEN t2.name_length = 4 THEN 1 ELSE 0 END) as num FROM t2 WHERE domain_type LIKE 'domain'
UNION
SELECT '5' as num_chars, SUM (CASE WHEN t2.name_length = 5 THEN 1 ELSE 0 END) as num FROM t2 WHERE domain_type LIKE 'domain'
UNION
SELECT '6' as num_chars, SUM (CASE WHEN t2.name_length = 6 THEN 1 ELSE 0 END) AS num FROM t2 WHERE domain_type LIKE'domain'
UNION
SELECT '7+' as num_chars, SUM (CASE WHEN t2.name_length > 6 THEN 1 ELSE 0 END) AS num FROM t2 WHERE domain_type LIKE'domain'
