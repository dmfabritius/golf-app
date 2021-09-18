select CalcPoints=
--update RH SET Points=
case when RH.Score=0 
     then 0
     else case when Gender='M'
               -- points for boys
               then case when Par - RH.Score + 2 < 0 then 0
                         else case when Par - RH.Score + 2 > 5 then 5 else Par - RH.Score + 2 end
                    end
               -- points for girls
               else case when Par - RH.Score + 3 < 0 then 0
                         else case when Par - RH.Score + 3 > 6 then 6 else Par - RH.Score + 3 end
                    end
          end
end
,RH.*, CH.Par, P.Gender

from GolfRoundHoles RH
inner join GolfCourseHoles CH on CH.GolfCourseHoleID=RH.GolfCourseHoleID
inner join GolfRounds GR on GR.GolfRoundID=RH.GolfRoundID
inner join Players P on P.PlayerID=GR.PlayerID

where RH.GolfRoundID=153
;
--update GR SET Points=T.TotalPoints
--from GolfRounds GR inner join (
--      select gr.GolfRoundID, TotalPoints=sum(rh.Points)
--      from GolfRoundHoles RH
--        inner join GolfRounds GR on GR.GolfRoundID=RH.GolfRoundID
--      group by gr.GolfRoundID) T on GR.GolfRoundID=T.GolfRoundID