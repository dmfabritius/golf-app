declare @MatchID int=94

--R=ROW_NUMBER() OVER(ORDER BY MatchPosition)

SELECT *
FROM (VALUES(1), (2), (3), (4), (5), (6)) Slots(Position)
 CROSS APPLY (SELECT HomeSchoolID, AwaySchoolID FROM Matches WHERE MatchID=@MatchID) M
 
 LEFT JOIN (SELECT R=ISNULL(MatchPosition,7), HomeVarsityPlayer=PlayerName, HomeVarsityRoundID=MR.GolfRoundID
            FROM Matches M
             INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, MatchPosition
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV 
              ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID) HomeVarsity
  ON HomeVarsity.R=Slots.Position

 LEFT JOIN (SELECT R=ISNULL(MatchPosition,7), HomeJVPlayer=PlayerName, HomeJVRoundID=MR.GolfRoundID
            FROM Matches M
             INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, MatchPosition
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HJV
              ON HJV.GolfRoundID=MR.GolfRoundID AND HJV.SchoolID=M.HomeSchoolID) HomeJV
  ON HomeJV.R=Slots.Position

 LEFT JOIN (SELECT R=ISNULL(MatchPosition,7), AwayVarsityPlayer=PlayerName, AwayVarsityRoundID=MR.GolfRoundID
            FROM Matches M
             INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, MatchPosition
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) AV
              ON AV.GolfRoundID=MR.GolfRoundID AND AV.SchoolID=M.AwaySchoolID) AwayVarsity
  ON AwayVarsity.R=Slots.Position

 LEFT JOIN (SELECT R=ISNULL(MatchPosition,7), AwayJVPlayer=PlayerName, AwayJVRoundID=MR.GolfRoundID
            FROM Matches M
             INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, MatchPosition
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) AJV
              ON AJV.GolfRoundID=MR.GolfRoundID AND AJV.SchoolID=M.AwaySchoolID) AwayJV
  ON AwayJV.R=Slots.Position