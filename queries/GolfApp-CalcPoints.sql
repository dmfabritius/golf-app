SELECT
 R.GolfRoundID, R.GolfRoundTypeID, R.GolfCourseID, RH.GolfCourseHoleID, CH.HoleNumber, CH.Par, RH.Score,
 CalcPoints=CASE WHEN RH.Score=0
                 THEN 0 
			  ELSE CASE WHEN Gender='M' THEN 0 ELSE 1 END + 
			       CASE WHEN CH.Par - RH.Score + 2 < 0
				       THEN 0 
				       ELSE CASE WHEN CH.Par - RH.Score + 2 > 5
				                 THEN 5 
						       ELSE CH.Par - RH.Score + 2 +
							       CASE WHEN CH.Par=3 AND RH.Score=1 THEN 1 ELSE 0 END
				            END
				  END
		  END,
 DatePlayed, PlayerName, SchoolName, GolfCourseName
FROM GolfRoundHoles RH
 INNER JOIN GolfCourseHoles CH ON CH.GolfCourseHoleID=RH.GolfCourseHoleID
 INNER JOIN GolfRounds R ON R.GolfRoundID=RH.GolfRoundID
 INNER JOIN Players P ON P.PlayerID=R.PlayerID
 INNER JOIN Schools S ON S.SchoolID=P.SchoolID
 INNER JOIN GolfCourses C ON C.GolfCourseID=R.GolfCourseID
WHERE R.GolfRoundID=43