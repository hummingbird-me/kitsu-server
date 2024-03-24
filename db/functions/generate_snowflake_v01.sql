-- Function: snowflake_generator(timestamp, integer)
-- Purpose: Generate a snowflake id
CREATE OR REPLACE FUNCTION generate_snowflake(
	ts timestamp(3) without time zone DEFAULT clock_timestamp(),
	id integer DEFAULT nextval('snowflake_id_seq')
)
RETURNS bigint
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    -- Epoch slightly before the founding of hummingbird.me
    epoch_ts bigint := EXTRACT(EPOCH FROM timestamp '2013-01-01') * 1000;
    -- Maximum for 22 bits unsigned
    max_seq_id bigint := (2 ^ 23) - 1;
    now_ts bigint;
    seq_id bigint;
    result bigint := 0;
BEGIN
    -- We just use a big-ass sequence for now, since we're using one shared generator
    SELECT id::bigint % max_seq_id INTO seq_id;

    SELECT FLOOR(EXTRACT(EPOCH FROM ts) * 1000) INTO now_ts;
    result := (now_ts - epoch_ts) << 22;
    result := result | seq_id;
	return result;
END;
$BODY$;
