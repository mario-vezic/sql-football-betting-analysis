-- ===================================================== 
-- PHASE 4: Market Integration & Bookmaker Analysis 
-- ===================================================== 
--
-- -- Objective: 
-- Integrate the three betting markets (Home Win, Draw and 
-- Away Win) into a unified betting dataset, calculate 
-- bookmaker margins, compare generated odds with market odds, 
-- and analyse pricing differences across bookmakers. 
--
-- -- Main Tasks: 
-- • Create unified betting market 
-- • Filter active betting markets 
-- • Calculate bookmaker margins 
-- • Compare generated and market odds 
-- • Rank bookmaker disagreements 
--
-- -- =====================================================

SELECT match, season, 'HOME_WIN' AS bet_type, my_odds
FROM raw_bet_1
UNION ALL
SELECT match, season, 'DRAW' AS bet_type, my_odds
FROM raw_bet_x
UNION ALL
SELECT match, season, 'AWAY_WIN' AS bet_type, my_odds
FROM raw_bet_2;

CREATE VIEW unified_betting_market AS
SELECT match, season, matchday,
       'HOME_WIN' AS bet_type,
       my_odds,
       odds_1xbet,
       odds_williamhill
FROM raw_bet_1
UNION ALL
SELECT match, season, matchday,
       'DRAW' AS bet_type,
       my_odds,
       odds_1xbet,
       odds_williamhill
FROM raw_bet_x
UNION ALL
SELECT match, season, matchday,
       'AWAY_WIN' AS bet_type,
       my_odds,
       odds_1xbet,
       odds_williamhill
FROM raw_bet_2;

CREATE VIEW active_betting_market AS
SELECT *
FROM unified_betting_market
WHERE odds_1xbet IS NOT NULL
AND odds_williamhill IS NOT NULL;

SELECT *
FROM active_betting_market;

------------------------------------------------------------------------------------------

SELECT
    season,
	matchday,
    match,
    MAX(
		CASE 
        	WHEN bet_type = 'HOME_WIN' THEN odds_1xbet
    	END) AS home_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'DRAW' THEN odds_1xbet
    	END) AS draw_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'AWAY_WIN' THEN odds_1xbet
    	END) AS away_odds,
    ROUND(
        (
         1.0 / MAX(CASE WHEN bet_type = 'HOME_WIN' THEN odds_1xbet END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'DRAW' THEN odds_1xbet END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'AWAY_WIN' THEN odds_1xbet END)
        ) - 1, 4) AS bookmaker_margin
FROM active_betting_market
GROUP BY season, matchday, match
ORDER BY bookmaker_margin DESC;

SELECT
    season,
	matchday,
    match,
    MAX(
		CASE 
        	WHEN bet_type = 'HOME_WIN' THEN odds_williamhill
    	END) AS home_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'DRAW' THEN odds_williamhill
    	END) AS draw_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'AWAY_WIN' THEN odds_williamhill
    	END) AS away_odds,
    ROUND(
        (
         1.0 / MAX(CASE WHEN bet_type = 'HOME_WIN' THEN odds_williamhill END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'DRAW' THEN odds_williamhill END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'AWAY_WIN' THEN odds_williamhill END)
        ) - 1, 4) AS bookmaker_margin
FROM active_betting_market
GROUP BY season, matchday, match
ORDER BY bookmaker_margin DESC;

SELECT 
    ROUND(AVG(bookmaker_margin), 4)
FROM (
    SELECT
    	season,
		matchday,
    	match,
    MAX(
		CASE 
        	WHEN bet_type = 'HOME_WIN' THEN odds_1xbet
    	END) AS home_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'DRAW' THEN odds_1xbet
    	END) AS draw_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'AWAY_WIN' THEN odds_1xbet
    	END) AS away_odds,
    ROUND(
        (
         1.0 / MAX(CASE WHEN bet_type = 'HOME_WIN' THEN odds_1xbet END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'DRAW' THEN odds_1xbet END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'AWAY_WIN' THEN odds_1xbet END)
        ) - 1, 4) AS bookmaker_margin
	FROM active_betting_market
	GROUP BY season, matchday, match
	ORDER BY bookmaker_margin DESC
) sub;

SELECT 
    ROUND(AVG(bookmaker_margin), 4)
FROM (
    SELECT
    	season,
		matchday,
    	match,
    MAX(
		CASE 
        	WHEN bet_type = 'HOME_WIN' THEN odds_williamhill
    	END) AS home_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'DRAW' THEN odds_williamhill
    	END) AS draw_odds,
    MAX(
		CASE 
        	WHEN bet_type = 'AWAY_WIN' THEN odds_williamhill
    	END) AS away_odds,
    ROUND(
        (
         1.0 / MAX(CASE WHEN bet_type = 'HOME_WIN' THEN odds_williamhill END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'DRAW' THEN odds_williamhill END)
         +
         1.0 / MAX(CASE WHEN bet_type = 'AWAY_WIN' THEN odds_williamhill END)
        ) - 1, 4) AS bookmaker_margin
	FROM active_betting_market
	GROUP BY season, matchday, match
	ORDER BY bookmaker_margin DESC
) sub;

-----------------------------------------------------------------------------------------

SELECT
    match,
    season,
    matchday,
    bet_type,
    my_odds,
    odds_1xbet,
    odds_williamhill,
    ABS(my_odds - odds_1xbet) AS diff_vs_1xbet,
    ABS(my_odds - odds_williamhill) AS diff_vs_williamhill
FROM active_betting_market
ORDER BY diff_vs_1xbet DESC;

SELECT
    match,
    season,
    matchday,
    bet_type,
    my_odds,
    odds_1xbet,
    ABS(my_odds - odds_1xbet) AS difference
FROM active_betting_market
ORDER BY difference DESC
LIMIT 10;

SELECT
    match,
    season,
    matchday,
    bet_type,
    my_odds,
    odds_williamhill,
    ABS(my_odds - odds_williamhill) AS difference
FROM active_betting_market
ORDER BY difference DESC
LIMIT 10;

SELECT
    match,
    matchday,
    bet_type,
    my_odds,
    odds_1xbet,
    ABS(my_odds - odds_1xbet) AS difference,
    RANK() OVER (
        ORDER BY ABS(my_odds - odds_1xbet) DESC
    ) AS disagreement_rank
FROM active_betting_market;

SELECT
    match,
    matchday,
    bet_type,
    my_odds,
    odds_williamhill,
    ABS(my_odds - odds_williamhill) AS difference,
    RANK() OVER (
        ORDER BY ABS(my_odds - odds_williamhill) DESC
    ) AS disagreement_rank
FROM active_betting_market;

SELECT
    match,
    matchday,
    bet_type,
    ABS(my_odds - odds_1xbet) AS difference,
    RANK() OVER (
        ORDER BY ABS(my_odds - odds_1xbet) DESC
    ) AS rank_value,
    DENSE_RANK() OVER (
        ORDER BY ABS(my_odds - odds_1xbet) DESC
    ) AS dense_rank_value
FROM active_betting_market;

SELECT
    match,
    matchday,
    bet_type,
    ABS(my_odds - odds_williamhill) AS difference,
    RANK() OVER (
        ORDER BY ABS(my_odds - odds_williamhill) DESC
    ) AS rank_value,
    DENSE_RANK() OVER (
        ORDER BY ABS(my_odds - odds_williamhill) DESC
    ) AS dense_rank_value
FROM active_betting_market;

SELECT
    matchday,
    match,
    bet_type,
    ABS(my_odds - odds_1xbet) AS difference,
    ROW_NUMBER() OVER (
        PARTITION BY matchday
        ORDER BY ABS(my_odds - odds_1xbet) DESC
    ) AS rn
FROM active_betting_market;

SELECT
    matchday,
    match,
    bet_type,
    ABS(my_odds - odds_williamhill) AS difference,
    ROW_NUMBER() OVER (
        PARTITION BY matchday
        ORDER BY ABS(my_odds - odds_williamhill) DESC
    ) AS rn
FROM active_betting_market;