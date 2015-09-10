 --!require required
ON schema_migrations AFTER INSERT,UPDATE
AS
BEGIN
  SELECT 2 as id
END