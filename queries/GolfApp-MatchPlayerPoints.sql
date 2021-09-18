declare @MatchID int = 6

SELECT * FROM (VALUES (1), (2), (3), (4), (5), (6)) Slots (Position)
 LEFT JOIN (SELECT V1=ROW_NUMBER() OVER (ORDER BY Points DESC), HomeVarsityPlayer=PlayerName, HomeVarsityScore=Score, HomeVarsityPoints=Points
	       FROM Matches M
            INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
            INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, Score, Points
                        FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                        WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
		 ) HomeVarsity ON HomeVarsity.V1=Slots.Position
 LEFT JOIN (SELECT J1=ROW_NUMBER() OVER (ORDER BY Points DESC), HomeJVPlayer=PlayerName, HomeJVScore=Score, HomeJVPoints=Points
	       FROM Matches M
		   INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, Score, Points
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.HomeSchoolID
		  ) HomeJV ON HomeJV.J1=Slots.Position
LEFT JOIN (SELECT V2=ROW_NUMBER() OVER (ORDER BY Points DESC), AwayVarsityPlayer=PlayerName, AwayVarsityScore=Score, AwayVarsityPoints=Points
	      FROM Matches M
		  INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
            INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, Score, Points
                        FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                        WHERE GolfRoundTypeID=3 AND IsVarsity=1) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
		 ) AwayVarsity ON AwayVarsity.V2=Slots.Position
 LEFT JOIN (SELECT J2=ROW_NUMBER() OVER (ORDER BY Points DESC), AwayJVPlayer=PlayerName, AwayJVScore=Score, AwayJVPoints=Points
	       FROM Matches M
		   INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID AND M.MatchID=@MatchID
             INNER JOIN (SELECT GolfRoundID, P.PlayerName, P.SchoolID, Score, Points
                         FROM GolfRounds GR INNER JOIN Players P ON P.PlayerID=GR.PlayerID
                         WHERE GolfRoundTypeID=3 AND IsVarsity=0) HV ON HV.GolfRoundID=MR.GolfRoundID AND HV.SchoolID=M.AwaySchoolID
		 ) AwayJV ON AwayJV.J2=Slots.Position
