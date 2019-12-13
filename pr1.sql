CREATE TABLE licenses (
    id serial PRIMARY KEY,
	code varchar UNIQUE,
	exp_date timestamptz NOT NULL
);
-- 2, 'SOME-CODE-333-AFDK', '2020-01-00 10:00:00+000'

ALTER TABLE licenses ALTER COLUMN exp_date
SET DEFAULT now() + '1 year'::interval; --best way to calc?

--Auto-generate code if needed
CREATE OR REPLACE FUNCTION insert_licenses_code()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.code IS NULL THEN
        -- check that SMTH-id isn't exist
        -- or we should add business rule to
        -- name licenses codes differ from 'SMTH-[number]'
        NEW.code := 'SMTH-' || NEW.id;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER tr_insert_licenses_code
    BEFORE INSERT
    ON licenses
    FOR EACH ROW
    EXECUTE PROCEDURE insert_licenses_code();




CREATE TABLE limits (
	id serial PRIMARY KEY,
	the_group varchar NOT NULL,
	sublimit varchar NOT NULL,
	values varchar[] NOT NULL -- varchar or int?
);
-- 3, 'Time', xDRs, Array['1M', '5M', '10M']

INSERT INTO limits (id, the_group, sublimit, values) VALUES 
(1, 'Clients', 'Active Clients', Array['1T', '5T', '10T']),
(2, 'Clients', 'Accounts', Array['1T', '5T', '10T']),
(3, 'Events', 'Orig Volume', Array['10M', '20M']),
(4, 'Events', 'xDRs', Array['1M', '5M', '10M']),
(5, 'Data', 'Orig Volume', Array['10M', '20M']),
(6, 'Data', 'xDRs', Array['1M', '5M', '10M']),
(7, 'Time', 'Orig Volume', Array['10M', '20M']),
(8, 'Time', 'Volume', Array['25M', '50M']),
(9, 'Time', 'xDRs', Array['1M', '5M', '10M']);

-- Select sublimits with values for UI
SELECT sublimit, values FROM limits WHERE the_group = 'Smth';




CREATE TABLE license_limits (
    --should we add id and make it PK?
    licenses_id int,
    limits_id int,
    value varchar NOT NULL, -- varchar or int?
    PRIMARY KEY (licenses_id, limits_id)
);
-- 2, 3, '1M'
--Should we add constraint to check if ll.value in related (ll.limits_id = l.id) l.values?

ALTER TABLE license_limits
ADD CONSTRAINT FK_License_LicenseLimit -- name?
FOREIGN KEY (licenses_id) REFERENCES licenses (id)
ON DELETE CASCADE,
ADD CONSTRAINT FK_Limit_LicenseLimit -- name?
FOREIGN KEY (limits_id) REFERENCES limits (id)
ON DELETE CASCADE;




CREATE TABLE customers (
	id serial PRIMARY KEY,
	name varchar NOT NULL,
	parent_customers_id int,
    licenses_id int --add NOT NULL if company can't exists without a license
);
-- 2, 'Smth Mobile', NULL, 2

ALTER TABLE customers
ADD CONSTRAINT FK_ParentCustomer_Customer -- name?
FOREIGN KEY (parent_customers_id) REFERENCES customers (id)
ON DELETE SET NULL,
ADD CONSTRAINT FK_LicenseCustomer -- name?
FOREIGN KEY (licenses_id) REFERENCES licenses (id)
ON DELETE RESTRICT;




CREATE TABLE contact_persons (
	id serial PRIMARY KEY,
	full_name varchar NOT NULL,
	email varchar NOT NULL,
	phone varchar,
    companies_id int NOT NULL,
	job_title varchar NOT NULL
);
-- 'John Doe', 'john.doe@example.com', '(443)355-2222', 2, 'Sales Manager'

ALTER TABLE contact_persons
ADD CONSTRAINT FK_Company_ContactPersons -- name?
FOREIGN KEY (companies_id) REFERENCES customers (id)
ON DELETE CASCADE;




-- DENORMALISATION

-- We often need to know how many other customers one has referred
ALTER TABLE customers
ADD COLUMN refers_count int DEFAULT 0;

CREATE OR REPLACE FUNCTION update_refers_count()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.parent_customers_id IS NOT NULL THEN
        UPDATE
            customers
        SET
            refers_count = refers_count + 1
        WHERE
            id = NEW.parent_customers_id
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER tr_update_refers_count
    BEFORE INSERT
    ON customers
    FOR EACH ROW
    EXECUTE PROCEDURE update_refers_count();





-- License limits are accessed very often from different places
ALTER TABLE licenses
ADD COLUMN limit_active_clients varchar,
ADD COLUMN limit_accounts varchar,
ADD COLUMN limit_events_orig_volume varchar,
ADD COLUMN limit_events_xDRs varchar,
ADD COLUMN limit_data_orig_volume varchar,
ADD COLUMN limit_data_xDRs varchar,
ADD COLUMN limit_time_orig_volume varchar,
ADD COLUMN limit_time_volume varchar,
ADD COLUMN limit_time_xDRs varchar;


CREATE OR REPLACE FUNCTION update_license_limits()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.parent_customers_id IS NOT NULL THEN
        UPDATE licenses SET limit_active_clients = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 1;
        UPDATE licenses SET limit_accounts = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 2;
        UPDATE licenses SET limit_events_orig_volume = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 3;
        UPDATE licenses SET limit_events_xDRs = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 4;
        UPDATE licenses SET limit_data_orig_volume = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 5;
        UPDATE licenses SET limit_data_xDRs = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 6;
        UPDATE licenses SET limit_time_orig_volume = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 7;
        UPDATE licenses SET limit_time_volume = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 8;
        UPDATE licenses SET limit_time_xDRs = NEW.value WHERE id = NEW.limits_id AND NEW.limits_id = 9;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER tr_insert_license_limits
    BEFORE INSERT
    ON license_limits
    FOR EACH ROW
    EXECUTE PROCEDURE update_license_limits();

CREATE TRIGGER tr_update_license_limits
    BEFORE UPDATE
    ON license_limits
    FOR EACH ROW
    EXECUTE PROCEDURE update_license_limits();











-- CASE NEW.limits_id
-- WHEN 1 THEN UPDATE licenses SET limit_active_clients = NEW.value WHERE id = NEW.limits_id
-- WHEN 2 THEN UPDATE licenses SET limit_accounts = NEW.value WHERE id = NEW.limits_id
-- WHEN 3 THEN UPDATE licenses SET limit_events_orig_volume = NEW.value WHERE id = NEW.limits_id
-- WHEN 4 THEN UPDATE licenses SET limit_events_xDRs = NEW.value WHERE id = NEW.limits_id
-- WHEN 5 THEN UPDATE licenses SET limit_data_orig_volume = NEW.value WHERE id = NEW.limits_id
-- WHEN 6 THEN UPDATE licenses SET limit_data_xDRs = NEW.value WHERE id = NEW.limits_id
-- WHEN 7 THEN UPDATE licenses SET limit_time_orig_volume = NEW.value WHERE id = NEW.limits_id
-- WHEN 8 THEN UPDATE licenses SET limit_time_volume = NEW.value WHERE id = NEW.limits_id
-- WHEN 9 THEN UPDATE licenses SET limit_time_xDRs = NEW.value WHERE id = NEW.limits_id
-- END;