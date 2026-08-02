-- ===================================================== 
-- PHASE 5: Advanced SQL Analytics 
-- ===================================================== 
--
-- -- Objective: 
-- Apply advanced SQL analytical techniques, including window 
-- functions, ranking functions, common table expressions 
-- (CTEs), and temporal analysis to investigate betting odds 
-- behaviour and demonstrate advanced SQL querying skills. 
--
-- -- Main Tasks: 
-- • Analyse odds movement 
-- • Track historical odds changes 
-- • Apply ranking functions 
-- • Use LAG() and LEAD() 
-- • Implement Common Table Expressions (CTEs) 
--
-- -- =====================================================

SELECT
    abm.match,
    abm.matchday,
    abm.bet_type,
    rb1.home_team,
    rb1.away_team,
    abm.odds_1xbet,
    LAG(abm.odds_1xbet) OVER (
        PARTITION BY abm.bet_type
        ORDER BY abm.matchday
    ) AS previous_odds,
    abm.odds_1xbet - LAG(abm.odds_1xbet) OVER (
        PARTITION BY abm.bet_type
        ORDER BY abm.matchday
    ) AS odds_change
FROM active_betting_market abm
INNER JOIN raw_bet_1 rb1
ON abm.match = rb1.match
AND abm.matchday = rb1.matchday
ORDER BY abm.matchday;

WITH odds_tracking AS (
    SELECT
        abm.match,
        abm.matchday,
        abm.bet_type,
        rb1.home_team,
        rb1.away_team,
        abm.odds_1xbet,
        LAG(abm.odds_1xbet) OVER (
            PARTITION BY abm.bet_type
            ORDER BY abm.matchday
        ) AS previous_odds
    FROM active_betting_market abm
    INNER JOIN raw_bet_1 rb1
    ON abm.match = rb1.match
    AND abm.matchday = rb1.matchday
	)
SELECT *,
       ABS(odds_1xbet - previous_odds) AS movement_size
FROM odds_tracking
WHERE previous_odds IS NOT NULL
ORDER BY movement_size DESC;

SELECT
    rb1.home_team,
    AVG(abm.odds_1xbet) AS avg_home_odds,
    RANK() OVER (
        ORDER BY AVG(abm.odds_1xbet) DESC
    ) AS odds_rank
FROM active_betting_market abm
INNER JOIN raw_bet_1 rb1
ON abm.match = rb1.match
AND abm.matchday = rb1.matchday
WHERE abm.bet_type = 'HOME_WIN'
GROUP BY rb1.home_team;

SELECT
    match,
    matchday,
    bet_type,
    odds_1xbet,
    LEAD(odds_1xbet) OVER (
        PARTITION BY bet_type
        ORDER BY matchday
    ) AS next_odds
FROM active_betting_market;