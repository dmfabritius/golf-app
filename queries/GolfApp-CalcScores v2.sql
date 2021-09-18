declare @GolfRoundID int = 153

--SELECT TotalScore=
UPDATE GR SET Score=
            CASE WHEN P.HolesPlayedID=1
                 THEN CASE WHEN [1]*[2]*[3]*[4]*[5]*[6]*[7]*[8]*[9]=0
                           THEN 0
                           ELSE [1]+[2]+[3]+[4]+[5]+[6]+[7]+[8]+[9]
                      END
                 ELSE CASE WHEN P.HolesPlayedID=2
                           THEN CASE WHEN [10]*[11]*[12]*[13]*[14]*[15]*[16]*[17]*[18]=0
                                     THEN 0
                                     ELSE [10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]
                                END
                           ELSE CASE WHEN [1]*[2]*[3]*[4]*[5]*[6]*[7]*[8]*[9]*[10]*[11]*[12]*[13]*[14]*[15]*[16]*[17]*[18]=0
                                     THEN 0
                                     ELSE [1]+[2]+[3]+[4]+[5]+[6]+[7]+[8]+[9]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]
                                END
                      END
            END
-- ,
-- P.* 


FROM GolfRounds GR INNER JOIN
    (SELECT RH.GolfRoundID, GR.GolfRoundTypeID, GR.HolesPlayedID, HoleNumber, RH.Score
      FROM GolfRoundHoles RH
        INNER JOIN GolfCourseHoles H ON RH.GolfCourseHoleID=H.GolfCourseHoleID
        INNER JOIN GolfRounds GR ON RH.GolfRoundID=GR.GolfRoundID
--                 WHERE RH.GolfRoundID=@GolfRoundID
     ) H
     PIVOT(MAX(Score) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
     ON GR.GolfRoundID=P.GolfRoundID

--ORDER BY GolfRoundID