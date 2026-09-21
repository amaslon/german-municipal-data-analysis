-- Municipal Population Analysis
-- Baden-Württemberg, 2022–2024
-- Data source: Statistisches Landesamt Baden-Württemberg


-- 1. Ten largest municipalities in 2024

SELECT
    municipality,
    population,
    population_density
FROM municipal_data
WHERE date = '2024-12-31'
ORDER BY population DESC
LIMIT 10;


-- 2. Population change between 2022 and 2024

WITH population_by_year AS (
    SELECT
        municipality_code,
        municipality,
        MAX(
            CASE
                WHEN date = '2022-12-31'
                THEN population
            END
        ) AS population_2022,
        MAX(
            CASE
                WHEN date = '2024-12-31'
                THEN population
            END
        ) AS population_2024
    FROM municipal_data
    GROUP BY
        municipality_code,
        municipality
)

SELECT
    municipality,
    population_2022,
    population_2024,
    population_2024 - population_2022
        AS population_change,
    ROUND(
        100.0
        * (population_2024 - population_2022)
        / NULLIF(population_2022, 0),
        2
    ) AS population_change_pct
FROM population_by_year
ORDER BY population_change DESC;


-- 3. State-level population summary

SELECT
    date,
    SUM(population) AS total_population,
    COUNT(DISTINCT municipality_code)
        AS number_of_municipalities
FROM municipal_data
GROUP BY date
ORDER BY date;


-- 4. Municipalities with population decline

WITH population_by_year AS (
    SELECT
        municipality_code,
        municipality,
        MAX(
            CASE
                WHEN date = '2022-12-31'
                THEN population
            END
        ) AS population_2022,
        MAX(
            CASE
                WHEN date = '2024-12-31'
                THEN population
            END
        ) AS population_2024
    FROM municipal_data
    GROUP BY
        municipality_code,
        municipality
)

SELECT
    municipality,
    population_2022,
    population_2024,
    population_2024 - population_2022
        AS population_change
FROM population_by_year
WHERE population_2024 < population_2022
ORDER BY population_change ASC;


-- 5. Population development in Ulm

SELECT
    municipality,
    date,
    population,
    population_density
FROM municipal_data
WHERE municipality = 'Ulm, Universitätsstadt'
ORDER BY date;