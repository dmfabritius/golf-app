SELECT
 GolfRoundID,
 BounceBacks=SUM(BounceBack),
 BounceBackPct=SUM(BounceBack) / 9.0
FROM (
 SELECT
  GolfRoundID,
  BounceBack=
   CASE WHEN LAG(GolfRoundID) OVER(ORDER BY GolfRoundID, GolfCourseHoleID) = GolfRoundID
              AND LAG(Score) OVER(ORDER BY GolfRoundID, GolfCourseHoleID) > LAG(Par) OVER(ORDER BY GolfRoundID, GolfCourseHoleID)
              AND Score < Par
              AND Score <> 0
        THEN 1
        ELSE 0
   END
 FROM (SELECT R.GolfRoundID, RH.GolfCourseHoleID, CH.Par, RH.Score
       FROM GolfRounds R
        INNER JOIN GolfRoundHoles RH ON RH.GolfRoundID=R.GolfRoundID
        INNER JOIN GolfCourseHoles CH ON CH.GolfCourseHoleID=RH.GolfCourseHoleID
       WHERE HolesPlayedID <> 3) T
 ) BB
GROUP BY GolfRoundID
