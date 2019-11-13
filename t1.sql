-- CREATE TABLE t1_param (
-- 	param varchar(63) PRIMARY KEY,
-- 	threshold float NOT NULL
-- );

-- DROP TABLE t1_param;
-- CREATE TABLE t1_measuring (
-- 	id serial PRIMARY KEY,
-- 	param varchar(63) NOT NULL,
-- 	value float,
-- 	time timestamp,
-- 	FOREIGN KEY (param) REFERENCES t1_param (param)
-- );
-- INSERT INTO t1_param
-- VALUES
-- 	('p1', 10),
-- 	('p2', 10.5),
-- 	('p3', 11);
-- INSERT INTO t1_measuring (param, value, time)
-- VALUES
-- 	('p1', 8, '2019-11-13 10:00:00'),
-- 	('p1', 11, '2019-11-13 10:05:00'),
-- 	('p2', 10.2, '2019-11-13 10:00:00'),
-- 	('p2', 10.51, '2019-11-13 10:05:00'),
-- 	('p3', -33, '2019-11-13 10:00:00'),
-- 	('p3', 11, '2019-11-13 10:05:00');
SELECT
	param, date(time), value
FROM
	t1_measuring AS m
INNER JOIN t1_param AS p USING(param)
WHERE
	value > p.threshold;








