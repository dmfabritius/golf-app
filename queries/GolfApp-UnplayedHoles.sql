--select gr.GolfRoundID, Unplayed=
update gr set UnplayedHoles=
case when HolesPlayedID <> 3 then RoundUnplayedHoles-9 else RoundUnplayedHoles end
from GolfRounds GR inner join (
      select gr.GolfRoundID, 
      RoundUnplayedHoles=sum(CASE WHEN rh.score = 0 then 1 else 0 end)
      from GolfRoundHoles RH
        inner join GolfRounds GR on GR.GolfRoundID=RH.GolfRoundID
      group by gr.GolfRoundID) T on GR.GolfRoundID=T.GolfRoundID