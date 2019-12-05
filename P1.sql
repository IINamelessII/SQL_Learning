CREATE TYPE limit_group AS ENUM ('Clients', 'Time', 'Events');

CREATE TABLE the_limit (
    id serial PRIMARY KEY,
    parent_limit_id int,
    the_group limit_group,
    criterium varchar,
    value varchar,
    FOREIGN KEY (parent_limit_id) REFERENCES the_limit (id)
);

CREATE TABLE license (
    code varchar PRIMARY KEY,
    exp_date
);

CREATE TABLE limits_license (
    license_code varchar,
    limit_id,
    PRIMARY KEY (license_code, limit_id),
    FOREIGN KEY (license_code) REFERENCES license (code),
    FOREIGN KEY (limit_id) REFERENCES the_limit (id)
);

