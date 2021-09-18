declare @MatchID int = 4

SELECT * FROM (VALUES (1), (2), (3), (4), (6), (6)) Slots (Position)
 LEFT JOIN (SELECT R=ROW_NUMBER() OVER (ORDER BY M.MatchID),
			 HomeVarsityPlayer=HV.PlayerName, HomeVarsityRoundID=HV.GolfRoundID,
			 HomeJVPlayer=HJV.PlayerName, HomeJVRoundID=HJV.GolfRoundID,
			 AwayVarsityPlayer=AV.PlayerName, AwayVarsityRoundID=AV.GolfRoundID,
			 AwayJVPlayer=AJV.PlayerName, AwayJVRoundID=AJV.GolfRoundID
	        FROM Matches M
			 INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID
             LEFT JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
             LEFT JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HJV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
             LEFT JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=1) AV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
             LEFT JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) AJV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
	        WHERE M.MatchID=@MatchID
		   ) S ON S.R=Slots.Position
