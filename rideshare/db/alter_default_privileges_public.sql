--
-- tables, sequences, functions, types, schemas
--
\c rideshare_development

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  REVOKE ALL PRIVILEGES
  ON TABLES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  REVOKE ALL PRIVILEGES
  ON SEQUENCES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  REVOKE ALL PRIVILEGES
  ON FUNCTIONS
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  REVOKE ALL PRIVILEGES
  ON TYPES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  REVOKE ALL PRIVILEGES
  ON SCHEMAS
  FROM PUBLIC;
