-- ============================================================
-- Team-Year Efficiency Aggregate
--
-- Design Notes:
-- 1. Batting is aggregated to team-year before joining to avoid
--    double counting across players and stints.
-- 2. Salaries are aggregated separately to team-year and LEFT JOINed
--    to preserve teams without salary data.
-- 3. Explicit casting prevents integer division issues.
-- 4. Deterministic GROUP BY ensures idempotent reruns.
-- 5. Designed for partitioning by yearID in a warehouse.
-- ============================================================

WITH batting_agg AS (
    SELECT
        teamID,
        yearID,
        SUM(AB) AS AB,
        SUM(H) AS H,
        SUM(HR) AS HR
    FROM Batting
    GROUP BY teamID, yearID
),

salary_agg AS (
    SELECT
        teamID,
        yearID,
        SUM(salary) AS total_payroll
    FROM Salaries
    GROUP BY teamID, yearID
)

SELECT
    b.teamID,
    b.yearID,
    s.total_payroll,
    b.AB,
    b.HR,

    CASE 
        WHEN b.AB > 0 
        THEN CAST(b.H AS DOUBLE) / b.AB
        ELSE 0
    END AS BA,

    CASE 
        WHEN b.AB > 0 
        THEN CAST(b.HR AS DOUBLE) / b.AB
        ELSE 0
    END AS SLG,

    CASE 
        WHEN s.total_payroll > 0 
        THEN b.HR / (s.total_payroll / 1000000.0)
        ELSE NULL
    END AS HR_per_Million

FROM batting_agg b
LEFT JOIN salary_agg s
    ON b.teamID = s.teamID
   AND b.yearID = s.yearID

ORDER BY b.yearID, b.teamID;