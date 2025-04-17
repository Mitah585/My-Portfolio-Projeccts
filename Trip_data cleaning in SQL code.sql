-- Cleaning Data

--CHECK FOR DUPLICATES
SELECT ride_id, COUNT(*) 
FROM trip_data 
GROUP BY ride_id 
HAVING COUNT(*) > 1;
	-- 171 FOUND

-- DELETE DUPLICATES
DELETE FROM trip_data
WHERE ride_id IN (
  SELECT ride_id
  FROM (
    SELECT ride_id, ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY ride_id) AS row_num
    FROM trip_data
  ) subquery
  WHERE row_num > 1
);

-- CHECK FOR MISSING VALUES
SELECT 
  'ride_id' AS column_name, COUNT(*) AS missing_count
FROM trip_data
WHERE ride_id IS NULL
UNION ALL
SELECT 
  'started_date' AS column_name, COUNT(*) AS missing_count
FROM trip_data
WHERE started_date IS NULL
UNION ALL
SELECT 
  'ended_date' AS column_name, COUNT(*) AS missing_count
FROM trip_data
WHERE ended_date IS NULL
UNION ALL
SELECT 
  'trip_duration_minutes' AS column_name, COUNT(*) AS missing_count
FROM trip_data
WHERE trip_duration_minutes IS NULL;

-- CHECK FOR INVALID RANGES

SELECT *
FROM trip_data
WHERE trip_duration_minutes::NUMERIC < 0 -- Negative durations are invalid
  OR started_date > ended_date; -- Ensure start date is before end date

  --THREE FOUND AND THE START_AT AND ENDED_AT VALUES WERE JUST ENTERED SWAPPED WHICH CAUSED THE REST OF THE DEPENDENT CALCULATIONS TO BE INACCURATE

-- Fix invalid values
	
SELECT *
FROM trip_data
WHERE started_date > ended_date;
	--UPDATE DATE
UPDATE trip_data
SET started_date = ended_date,
    ended_date = started_date
WHERE started_date > ended_date;
	-- UPDATE TIME
UPDATE trip_data
SET started_time = ended_time,
    ended_time = started_time
WHERE started_date = ended_date AND started_time > ended_time;

-- RECALCULATE TRIP_DURATION_MINUTES 

UPDATE trip_data
SET trip_duration_minutes = CASE
    WHEN ended_date > started_date THEN 
        ROUND(EXTRACT(EPOCH FROM (ended_time - started_time + INTERVAL '1 day')) / 60)
    ELSE 
        ROUND(EXTRACT(EPOCH FROM (ended_time - started_time)) / 60)
END
WHERE ended_date >= started_date;

	-- recalculate start_hour
UPDATE trip_data
SET start_hour = EXTRACT(HOUR FROM started_time)
	-- reformat start_hour
UPDATE trip_data
SET start_hour = TO_CHAR(started_time, 'HH12AM');

	-- RECALCULATE DURATION BUCKETS
UPDATE trip_data
SET duration_buckets = CASE
    WHEN trip_duration_minutes::NUMERIC <= 10 THEN 'Under 10'
    WHEN trip_duration_minutes::NUMERIC <= 20 THEN '10 to 20'
    WHEN trip_duration_minutes::NUMERIC <= 30 THEN '20 to 30'
    WHEN trip_duration_minutes::NUMERIC <= 40 THEN '30 to 40'
    WHEN trip_duration_minutes::NUMERIC <= 50 THEN '40 to 50'
    WHEN trip_duration_minutes::NUMERIC <= 60 THEN '50 to 60'
    ELSE 'Above 60'
END;

-- CHECK DATA FORMATS AND TYPES
SELECT *
FROM trip_data
WHERE start_lat::NUMERIC IS NULL 
   OR start_lng::NUMERIC IS NULL 
   OR end_lat::NUMERIC IS NULL 
   OR end_lng::NUMERIC IS NULL;

-- SPOT CHECK USING RANDOM SAMPLING
SELECT *
FROM trip_data
ORDER BY RANDOM()
LIMIT 100;
