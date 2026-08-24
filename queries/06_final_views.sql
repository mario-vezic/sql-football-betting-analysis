-- ===================================================== 
-- PHASE 6: Reporting Views 
-- ===================================================== 
--
-- -- Objective: 
-- Create reusable SQL views that summarize the final betting 
-- analysis, combine key performance metrics, and prepare the 
-- dataset for reporting, visualization, and profitability 
-- analysis in Tableau. 
--
-- -- Main Tasks: 
-- • Create analytical SQL views 
-- • Calculate normalized probabilities 
-- • Compute betting edge 
-- • Calculate simulated betting profit 
-- • Prepare reporting-ready datasets 
--
-- -- =====================================================

CREATE VIEW betting_returns AS
SELECT
    abm.match,
    abm.matchday,
    abm.bet_type,
    rb1.outcome,
    abm.my_odds,
    abm.odds_1xbet,
    (1 / abm.odds_1xbet) / ((1 / abm.odds_1xbet) + (1 / abm.odds_williamhill)) AS normalized_probability,
    (1 / abm.my_odds) - (1 / abm.odds_1xbet) AS edge,
    CASE
        WHEN ((1 / abm.my_odds) - (1 / abm.odds_1xbet)) > 0.03 AND rb1.outcome = 0
        THEN abm.odds_1xbet - 1
        WHEN ((1 / abm.my_odds) - (1 / abm.odds_1xbet)) > 0.03 AND rb1.outcome = 1
        THEN -1
        ELSE 0
    END AS profit
FROM active_betting_market abm
INNER JOIN raw_bet_1 rb1
ON abm.match = rb1.match
AND abm.matchday = rb1.matchday
WHERE abm.bet_type = 'HOME_WIN';

------------------------------------------------------------------------------------------

CREATE VIEW final_betting_analysis AS
SELECT 
	rb1.match,
    rb1.matchday,
    rb1.home_team,
    rb1.away_team,
    abm.bet_type,
    abm.my_odds,
    abm.odds_1xbet,
    abm.odds_williamhill,
    ROUND(1 / abm.my_odds, 3) AS my_probability,
    ROUND(1 / abm.odds_1xbet, 3) AS market_probability,
    ROUND(ABS(abm.my_odds - abm.odds_1xbet), 3) AS odds_disagreement,
        CASE
            WHEN abm.odds_1xbet <= 1.80 THEN 'Favorite'
            WHEN abm.odds_1xbet >= 1.81 AND abm.odds_1xbet <= 3.50 THEN 'Balanced'
            ELSE 'Underdog'
        END AS market_category
FROM raw_bet_1 rb1
INNER JOIN active_betting_market abm 
ON rb1.match = abm.match 
AND rb1.matchday = abm.matchday;

------------------------------------------------------------------------------------------

CREATE VIEW final_betting_analysis_ordered AS
SELECT 
	match,
    matchday,
    home_team,
    away_team,
    bet_type,
    my_odds,
    odds_1xbet,
    odds_williamhill,
    my_probability,
    market_probability,
    odds_disagreement,
    market_category
FROM final_betting_analysis
ORDER BY matchday, match, bet_type;
