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
    (1 / abm.odds_1xbet) / ((1 / abm.odds_1xbet) + (1 / abm.odds_williamhill)
	) AS normalized_probability,
    (1 / abm.my_odds) - (1 / abm.odds_1xbet) AS edge,
    CASE
        WHEN
            ((1 / abm.my_odds)
             -
                (1 / abm.odds_1xbet)
            ) > 0.03

            AND rb1.outcome = 0

        THEN abm.odds_1xbet - 1

        WHEN
            ((1 / abm.my_odds) - (1 / abm.odds_1xbet)
) > 0.03
            AND rb1.outcome = 1
        THEN -1
        ELSE 0
    END AS profit
FROM active_betting_market abm
INNER JOIN raw_bet_1 rb1
ON abm.match = rb1.match
AND abm.matchday = rb1.matchday
WHERE abm.bet_type = 'HOME_WIN';
