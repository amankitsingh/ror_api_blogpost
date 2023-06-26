CREATE USER index_development WITH PASSWORD 'letmein';
ALTER USER index_development WITH SUPERUSER;
CREATE DATABASE index_development OWNER index_development;
