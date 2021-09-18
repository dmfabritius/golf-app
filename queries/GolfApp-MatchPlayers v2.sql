declare @MatchID int = 6

SELECT * FROM (VALUES (1), (2), (3), (4), (5), (6)) Slots (Position)
 LEFT JOIN (SELECT R=ROW_NUMBER() OVER (ORDER BY PlayerName), HomeVarsityPlayer=PlayerName, HomeVarsityRoundID=MR.GolfRoundID
	        FROM Matches M
			 INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
		   ) HomeVarsity ON HomeVarsity.R=Slots.Position
 LEFT JOIN (SELECT R=ROW_NUMBER() OVER (ORDER BY PlayerName), HomeJVPlayer=PlayerName, HomeJVRoundID=MR.GolfRoundID
	        FROM Matches M
			 INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
		   ) HomeJV ON HomeJV.R=Slots.Position
LEFT JOIN (SELECT R=ROW_NUMBER() OVER (ORDER BY PlayerName), AwayVarsityPlayer=PlayerName, AwayVarsityRoundID=MR.GolfRoundID
	        FROM Matches M
			 INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
           INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
		   ) AwayVarsity ON AwayVarsity.R=Slots.Position
 LEFT JOIN (SELECT R=ROW_NUMBER() OVER (ORDER BY PlayerName), AwayJVPlayer=PlayerName, AwayJVRoundID=MR.GolfRoundID
	        FROM Matches M
			 INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
		   ) AwayJV ON AwayJV.R=Slots.Position
