DECLARE @MatchID int=13

SELECT *
FROM ( SELECT *
       FROM (SELECT Name=' Par', Gender=' ', GolfRoundID=0, PlayerID=0, IsVarsity=0, MatchPosition=0, Score=Par, HoleNumber=CAST(HoleNumber AS nvarchar)
             FROM Matches M
              INNER JOIN GolfCourseHoles H ON H.GolfCourseID=M.GolfCourseID
             WHERE MatchID=@MatchID) H 
             PIVOT (MAX(Score) FOR HoleNumber
             IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], Out, [In], Total)) V1
      UNION
       SELECT Name=SchoolAbbr+', '+PlayerName+CASE WHEN IsVarsity=1 THEN ' (V' ELSE ' (JV' END+CAST(MatchPosition AS nvarchar)+')', Gender, H.*
       FROM (SELECT *
             FROM (SELECT MR.GolfRoundID, PlayerID, IsVarsity, MatchPosition, RH.Score, HoleNumber=CAST(HoleNumber AS nvarchar)
                   FROM MatchGolfRounds MR
                    INNER JOIN GolfRounds R ON R.GolfRoundID=MR.GolfRoundID
                    INNER JOIN GolfRoundHoles RH ON RH.GolfRoundID=R.GolfRoundID
                    INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=RH.GolfCourseHoleID
                   WHERE MR.MatchID=@MatchID) S
                   PIVOT(MAX(Score) FOR HoleNumber
                   IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], Out, [In], Total)) V2
            ) H
        INNER JOIN Players P ON P.PlayerID=H.PlayerID
        INNER JOIN Schools S ON S.SchoolID=P.SchoolID
     ) U
ORDER BY MatchPosition


	 
