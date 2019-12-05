CREATE TYPE limit_group AS ENUM ('Clients', 'Time', 'Events');

CREATE TABLE license (
	code int PRIMARY KEY,
	exp_date date
);

CREATE TABLE the_limit (
	id serial PRIMARY KEY,
	the_group limit_group,
	criterium varchar(63),
	value varchar(63)
);

CREATE TABLE limits_license (
	license_code int,
	limit_id int,
	PRIMARY KEY (license_code, limit_id),
	FOREIGN KEY (license_code) REFERENCES license (code),
	FOREIGN KEY (limit_id) REFERENCES the_limit (id)	
);

CREATE TABLE sublimit (
	parent_limit_id int,
	criterium varchar(63),
	value varchar(63),
	PRIMARY KEY (parent_limit_id, criterium),
    FOREIGN KEY (parent_limit_id) REFERENCES the_limit(id),
	CONSTRAINT ck_allowed CHECK (criterium = 'xDRs' AND value IN ('1M', '5M', '10M')
								OR criterium = 'Orig Volume' AND value in ('10M min', '20M min')
								OR criterium NOT IN ('xDRs', 'Orig Volume'))
);




CREATE TABLE person (
	id serial PRIMARY KEY,
	full_name varchar(63),
	email varchar(63),
	phone varchar(15),
	job_title varchar(31)
);

CREATE TABLE customer (
	id serial PRIMARY KEY,
	name varchar(31),
	refered_customer_id int,
	FOREIGN KEY (refered_customer_id) REFERENCES customer(id)
);

CREATE TABLE contact (
	customer_id int,
	person_id int,
	PRIMARY KEY (customer_id, person_id),
	FOREIGN KEY (customer_id) REFERENCES customer(id),
	FOREIGN KEY (person_id) REFERENCES person(id)
);




--License limits are accessed very often from different places
ALTER TABLE license
ADD COLUMN clients_limit_criterium varchar(63),
ADD COLUMN clients_limit_value varchar(63),
ADD COLUMN events_limit_criterium varchar(63),
ADD COLUMN events_limit_value varchar(63),
ADD COLUMN time_limit_criterium varchar(63),
ADD COLUMN time_limit_value varchar(63);

--We often need to know how many other customers one has referred
ALTER TABLE customer
ADD COLUMN refers_count int;
