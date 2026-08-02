-- ===================================================== 
-- PHASE 2: Probability & Value Betting Analysis 
-- ===================================================== 
--
-- -- Objective: 
-- Convert decimal odds into implied probabilities, compare 
-- machine learning generated probabilities with bookmaker 
-- probabilities, identify potential value betting opportunities, 
-- and evaluate profitability under different edge thresholds 
-- for both 1XBet and William Hill. 
--
-- -- Main Tasks: 
-- • Calculate implied probabilities 
-- • Compare model odds with bookmaker odds 
-- • Identify value bets 
-- • Calculate betting edge 
-- • Simulate betting profitability 
--
-- -- =====================================================

SELECT
	my_odds, odds_1xbet, odds_williamhill,
	ROUND(1.0 / my_odds, 4) AS my_probability,
	ROUND(1.0 / odds_1xbet, 4) AS prob_1xbet,
	ROUND(1.0 / odds_williamhill, 4) AS prob_williamhill
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT
	match,
	ROUND(1.0 / odds_1xbet, 4) AS prob_1xbet,
	ROUND(1.0 / odds_williamhill, 4) AS prob_williamhill,
	ROUND(1.0 / odds_1xbet + 1.0 / odds_williamhill, 4) AS partial_margin
FROM raw_bet_1
WHERE odds_1xbet IS NOT NULL;

-----------------------------------------------------------------------------------------

SELECT
	match,
	my_odds,
	odds_1xbet,
	ROUND(1.0 / my_odds, 4) AS my_prob,
	ROUND(1.0 / odds_1xbet, 4) AS prob_1xbet,
	CASE
		WHEN (1.0 / my_odds) > (1.0 / odds_1xbet) THEN 'VALUE'
		ELSE 'NO VALUE'
	END AS value_flag
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT *
FROM(
	SELECT
		match,
		my_odds,
		odds_1xbet,
		(1.0 / my_odds) AS my_prob,
		(1.0 / odds_1xbet) AS prob_1xbet,
		CASE
			WHEN (1.0 / my_odds) > (1.0 / odds_1xbet) THEN 1
			ELSE 0
		END AS value_bet
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE value_bet = 1;

SELECT 
    match,
    outcome,
    my_odds,  
    CASE 
        WHEN outcome = 0 THEN my_odds - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN my_odds - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT 
    match,
    outcome,
    odds_1xbet,
    CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT 
    match,
    outcome,
    odds_1xbet,
    CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND (1.0 / my_odds) > (1.0 / odds_1xbet);

SELECT 
    match,
    outcome,
    odds_1xbet,
    (1.0 / my_odds) AS my_prob,
    (1.0 / odds_1xbet) AS bookmaker_prob,
    (1.0 / my_odds) - (1.0 / odds_1xbet) AS edge,
    CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND (1.0 / my_odds) - (1.0 / odds_1xbet) > 0.05;

SELECT 
    match,
    outcome,
    odds_1xbet,
    ROUND((1.0 / my_odds) * 1.05, 4) AS true_my_prob,
    ROUND(1.0 / odds_1xbet, 4) AS bookmaker_prob,
    ROUND((1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet), 4) AS edge,
    CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_1xbet - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND ((1.0 / my_odds) * 1.05 - (1.0 / odds_1xbet)) > 0.05;

-----------------------------------------------------------------------------------------

SELECT
	match,
	my_odds,
	odds_williamhill,
	ROUND(1.0 / my_odds, 4) AS my_prob,
	ROUND(1.0 / odds_williamhill, 4) AS prob_williamhill,
	CASE
		WHEN (1.0 / my_odds) > (1.0 / odds_williamhill) THEN 'VALUE'
		ELSE 'NO VALUE'
	END AS value_flag
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT *
FROM(
	SELECT
		match,
		my_odds,
		odds_williamhill,
		(1.0 / my_odds) AS my_prob,
		(1.0 / odds_williamhill) AS prob_williamhill,
		CASE
			WHEN (1.0 / my_odds) > (1.0 / odds_williamhill) THEN 1
			ELSE 0
		END AS value_bet
	FROM raw_bet_1
	WHERE my_odds IS NOT NULL
) sub
WHERE value_bet = 1;

SELECT 
    match,
    outcome,
    odds_williamhill,
    CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL;

SELECT 
    match,
    outcome,
    odds_williamhill,
    CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND (1.0 / my_odds) > (1.0 / odds_williamhill);

SELECT 
    match,
    outcome,
    odds_williamhill,
    (1.0 / my_odds) AS my_prob,
    (1.0 / odds_williamhill) AS bookmaker_prob,
    (1.0 / my_odds) - (1.0 / odds_williamhill) AS edge,
    CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND (1.0 / my_odds) - (1.0 / odds_williamhill) > 0.05;

SELECT 
    match,
    outcome,
    odds_williamhill,
    ROUND((1.0 / my_odds) * 1.05, 4) AS true_my_prob,
    ROUND(1.0 / odds_williamhill, 4) AS bookmaker_prob,
    ROUND((1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill), 4) AS edge,
    CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END AS profit,
	SUM(CASE 
        WHEN outcome = 0 THEN odds_williamhill - 1
        ELSE -1
    END) OVER () AS total_profit
FROM raw_bet_1
WHERE my_odds IS NOT NULL
AND ((1.0 / my_odds) * 1.05 - (1.0 / odds_williamhill)) > 0.05;
