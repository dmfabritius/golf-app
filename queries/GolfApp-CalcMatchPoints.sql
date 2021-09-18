declare @MatchID int = 44

UPDATE M
  SET HomeSchoolPoints=HomePoints, AwaySchoolPoints=AwayPoints
FROM Matches M
 INNER JOIN(SELECT M.MatchID, HomePoints=SUM(CASE WHEN P.SchoolID=M.HomeSchoolID THEN GR.Points ELSE 0 END), AwayPoints=SUM(CASE WHEN P.SchoolID=M.AwaySchoolID THEN GR.Points ELSE 0 END)
            FROM Matches M
             INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID
             INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID AND GR.IsVarsity=1
             INNER JOIN Players P ON GR.PlayerID=P.PlayerID
            GROUP BY M.MatchID
            HAVING M.MatchID=@MatchID) T ON M.MatchID=T.MatchID
