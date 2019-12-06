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
	values varchar[] NOT NULL -- varchar or bigint?
);
-- 3, 'Time', xDRs, Array['1M', '5M', '10M']

INSERT INTO limits (the_group, sublimit, values) VALUES 
('Clients', 'Active Clients', Array['1T', '5T', '10T']),
('Clients', 'Accounts', Array['1T', '5T', '10T']),
('Events', 'Orig Volume', Array['10M', '20M']),
('Events', 'xDRs', Array['1M', '5M', '10M']),
('Data', 'Orig Volume', Array['10M', '20M']),
('Data', 'xDRs', Array['1M', '5M', '10M']),
('Time', 'Orig Volume', Array['10M', '20M']),
('Time', 'Volume', Array['25M', '50M']),
('Time', 'xDRs', Array['1M', '5M', '10M']);




CREATE TABLE license_limits (
    --should we add id and make it PK?
    licenses_id int,
    limits_id int,
    value varchar NOT NULL, -- varchar or bigint?
    PRIMARY KEY (licenses_id, limits_id)
);
-- 2, 3, '1M'

ALTER TABLE license_limits
ADD CONSTRAINT FK_License_LicenseLimit -- name?
FOREIGN KEY (licenses_id) REFERENCES licenses (id)
ON DELETE CASCADE;

ALTER TABLE license_limits
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
ON DELETE SET NULL;

ALTER TABLE customers
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
-- Select sublimits with values for UI
SELECT sublimit, values FROM limits WHERE the_group = 'Smth';
