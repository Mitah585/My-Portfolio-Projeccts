-- Analysis for insights
-- RIDE DURATION ANALYSIS

SELECT 
  member_casual,
  AVG(trip_duration_minutes::NUMERIC) AS avg_duration,
  MIN(trip_duration_minutes::NUMERIC) AS min_duration,
  MAX(trip_duration_minutes::NUMERIC) AS max_duration,
  COUNT(*) AS trip_count
FROM trip_data
GROUP BY member_casual
ORDER BY member_casual

-- USAGE TRENDS BY DAY OF THE WEEK

SELECT 
  member_casual,
  day_name,
  COUNT(*) AS ride_count,
  AVG(trip_duration_minutes::NUMERIC) AS avg_duration
FROM trip_data
GROUP BY member_casual, day_name
ORDER BY member_casual, 
  CASE 
    WHEN day_name = 'Sunday' THEN 1
    WHEN day_name = 'Monday' THEN 2
    WHEN day_name = 'Tuesday' THEN 3
    WHEN day_name = 'Wednesday' THEN 4
    WHEN day_name = 'Thursday' THEN 5
    WHEN day_name = 'Friday' THEN 6
    WHEN day_name = 'Saturday' THEN 7
  END;

-- PEAK USAGE TIMES

SELECT 
  member_casual,
  start_hour,
  COUNT(*) AS ride_count
FROM trip_data
GROUP BY member_casual, start_hour
ORDER BY member_casual, start_hour;

-- DAY VS. TIME OF DAY

SELECT 
  member_casual,
  day_name,
  start_hour,
  COUNT(*) AS ride_count
FROM trip_data
GROUP BY member_casual, day_name, start_hour
ORDER BY member_casual, day_name, start_hour;

-- USAGE PER MONTH OF YEAR

SELECT 
  member_casual,
  month_name,
  COUNT(*) AS ride_count
FROM trip_data
GROUP BY member_casual, month_name
ORDER BY member_casual, 
  CASE 
    WHEN month_name = 'April' THEN 1
    WHEN month_name = 'May' THEN 2
    WHEN month_name = 'June' THEN 3
    WHEN month_name = 'July' THEN 4
    WHEN month_name = 'August' THEN 5
    WHEN month_name = 'September' THEN 6
    WHEN month_name = 'October' THEN 7
    WHEN month_name = 'November' THEN 8
    WHEN month_name = 'December' THEN 9
    WHEN month_name = 'January' THEN 10
    WHEN month_name = 'February' THEN 11
    WHEN month_name = 'March' THEN 12
  END;

-- BIKE TYPE PREFERENCE

SELECT 
  member_casual,
  rideable_type,
  COUNT(*) AS ride_count
FROM trip_data
GROUP BY member_casual, rideable_type
ORDER BY member_casual, ride_count DESC;

-- POPULAR RIDES LOCATIONS

SELECT 
  member_casual,
  'Start' AS location_type,
  start_lat AS latitude,
  start_lng AS longitude,
  COUNT(*) AS location_count
FROM trip_data
GROUP BY member_casual, start_lat, start_lng

UNION ALL

SELECT 
  member_casual,
  'End' AS location_type,
  end_lat AS latitude,
  end_lng AS longitude,
  COUNT(*) AS location_count
FROM trip_data
GROUP BY member_casual, end_lat, end_lng

ORDER BY location_count DESC
LIMIT 10;