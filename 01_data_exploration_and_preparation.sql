-- =====================================================
-- PHASE 1: Data Preparation & Exploration 
-- ===================================================== 
--
-- -- Objective: 
-- Explore the imported betting datasets, verify data quality, 
-- identify missing values and inconsistencies, perform basic 
-- exploratory analysis, and apply the necessary data corrections 
-- before beginning the betting market analysis. 
--
-- -- Main Tasks: 
-- • Verify dataset completeness 
-- • Explore match and season distributions 
-- • Inspect betting odds availability 
-- • Correct identified data inconsistencies 
-- • Prepare supporting tables for further analysis 
--
-- =====================================================

SELECT COUNT(*) 
FROM raw_bet_1;

SELECT *
FROM raw_bet_1
LIMIT 10;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(my_odds) AS non_null_my_odds,
	ROUND(100.0 * COUNT(my_odds) / COUNT(*), 2) AS odds_percentage
FROM raw_bet_1;

SELECT 
    outcome,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM raw_bet_1
GROUP BY outcome;

SELECT
	season,
	COUNT(*) AS matches
FROM raw_bet_1
GROUP BY season
ORDER BY season;

SELECT
	home_team,
	COUNT(*) AS home_matches
FROM raw_bet_1
GROUP BY home_team
ORDER BY home_matches DESC
LIMIT 10;

SELECT *
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT *
FROM raw_bet_1
WHERE my_odds > 3
ORDER BY my_odds DESC;

SELECT
	outcome,
	AVG(my_odds) AS avg_my_odds,
	AVG(odds_1xbet) AS avg_1xbet_odds
FROM raw_bet_1
WHERE my_odds IS NOT NULL
GROUP BY outcome;

UPDATE raw_bet_1
SET season='2022/23'
WHERE id BETWEEN 3235 AND 3240;

SELECT id, season, matchday, match_date, match
FROM raw_bet_1
WHERE id BETWEEN 3235 AND 3240;

------------------------------------------------------------------------------------------

CREATE TABLE raw_bet_x
(LIKE raw_bet_1 INCLUDING DEFAULTS INCLUDING CONSTRAINTS);

CREATE TABLE raw_bet_2
(LIKE raw_bet_1 INCLUDING DEFAULTS INCLUDING CONSTRAINTS);