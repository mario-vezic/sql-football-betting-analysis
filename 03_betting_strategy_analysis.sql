-- ===================================================== 
-- PHASE 3: Betting Strategy Evaluation 
-- ===================================================== 
--
-- -- Objective: 
-- Evaluate different betting strategies by ranking value bets 
-- according to their calculated edge and assessing the 
-- profitability of selective betting approaches using 
-- bookmaker odds. 
--
-- -- Main Tasks: 
-- • Rank betting opportunities 
-- • Identify highest-edge bets 
-- • Simulate Top-N betting strategies 
-- • Evaluate one-bet-per-matchday strategy 
-- • Compare strategy profitability 
--
-- -- =====================================================

SELECT
	match,
	season,
	matchday,
	(1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) AS edge,
	ROW_NUMBER() OVER (
		ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) DESC
	) AS rank_global
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT *
FROM (
	SELECT
		match,
		outcome,
		odds_1xbet,
		(1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) AS edge,
		ROW_NUMBER() OVER (
			ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) DESC
		) AS rn,
		CASE
			WHEN outcome = 0 THEN odds_1xbet - 1
			ELSE -1
		END AS profit
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE rn <= 25;

SELECT 
    COUNT(*) AS bets,
    SUM(profit) AS total_profit
FROM (
	SELECT *
	FROM (
		SELECT
			match,
			outcome,
			odds_1xbet,
			(1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) AS edge,
			ROW_NUMBER() OVER (
				ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) DESC
			) AS rn,
			CASE
				WHEN outcome = 0 THEN odds_1xbet - 1
				ELSE -1
			END AS profit
		FROM raw_bet_1
		WHERE my_odds IS NOT NULL
	) sub
	WHERE rn <= 25) sub;

SELECT *
FROM (
	SELECT
		match,
		outcome,
		odds_1xbet,
		(1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) AS edge,
		ROW_NUMBER() OVER (
			PARTITION BY matchday
			ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) DESC
		) AS rn,
		CASE
			WHEN outcome = 0 THEN odds_1xbet - 1
			ELSE -1
		END AS profit
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE rn <= 1;

SELECT 
    COUNT(*) AS bets,
    SUM(profit) AS total_profit
FROM (
	SELECT *
	FROM (
		SELECT
			match,
			outcome,
			odds_1xbet,
			(1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) AS edge,
			ROW_NUMBER() OVER (
				PARTITION BY matchday
				ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet) DESC
			) AS rn,
			CASE
				WHEN outcome = 0 THEN odds_1xbet - 1
				ELSE -1
			END AS profit
		FROM raw_bet_1
		WHERE my_odds IS NOT NULL
	) sub
	WHERE rn <= 1) sub;

-----------------------------------------------------------------------------------------

SELECT
	match,
	season,
	matchday,
	(1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) AS edge,
	ROW_NUMBER() OVER (
		ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) DESC
	) AS rank_global
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT *
FROM (
	SELECT
		match,
		outcome,
		odds_williamhill,
		(1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) AS edge,
		ROW_NUMBER() OVER (
			ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) DESC
		) AS rn,
		CASE
			WHEN outcome = 0 THEN odds_williamhill - 1
			ELSE -1
		END AS profit
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE rn <= 25;

SELECT 
    COUNT(*) AS bets,
    SUM(profit) AS total_profit
FROM (
	SELECT *
	FROM (
		SELECT
			match,
			outcome,
			odds_williamhill,
			(1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) AS edge,
			ROW_NUMBER() OVER (
				ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) DESC
			) AS rn,
			CASE
				WHEN outcome = 0 THEN odds_williamhill - 1
				ELSE -1
			END AS profit
		FROM raw_bet_1
		WHERE my_odds IS NOT NULL
	) sub
	WHERE rn <= 25) sub;

SELECT *
FROM (
	SELECT
		match,
		outcome,
		odds_williamhill,
		(1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) AS edge,
		ROW_NUMBER() OVER (
			PARTITION BY matchday
			ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) DESC
		) AS rn,
		CASE
			WHEN outcome = 0 THEN odds_williamhill - 1
			ELSE -1
		END AS profit
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE rn <= 1;

SELECT 
    COUNT(*) AS bets,
    SUM(profit) AS total_profit
FROM (
	SELECT *
	FROM (
		SELECT
			match,
			outcome,
			odds_williamhill,
			(1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) AS edge,
			ROW_NUMBER() OVER (
				PARTITION BY matchday
				ORDER BY (1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill) DESC
			) AS rn,
			CASE
				WHEN outcome = 0 THEN odds_williamhill - 1
				ELSE -1
			END AS profit
		FROM raw_bet_1
		WHERE my_odds IS NOT NULL
	) sub
	WHERE rn <= 1) sub;