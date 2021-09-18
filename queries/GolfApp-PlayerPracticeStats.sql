DECLARE @StateID INT = 0
DECLARE @DistrictID INT = 0
DECLARE @LeagueID INT = 0
DECLARE @SchoolID INT = 0

SELECT
 GR.PlayerID, PlayerName, SchoolName, LeagueName, DistrictName, StateName,
 NumPlayed=COUNT(Score), Score=AVG(CAST(Score AS decimal)), 
 Points=AVG(CAST(Points AS decimal)), Putts=AVG(CAST(Putts AS decimal)), 
 Fairways=AVG(CAST(Fairways AS decimal)), Greens=AVG(CAST(Greens AS decimal))

FROM (SELECT * FROM GolfRounds WHERE GolfRoundTypeID<>3 AND HolesPlayedID<>3) GR
  INNER JOIN Players P ON P.PlayerID=GR.PlayerID
  INNER JOIN (SELECT * FROM Schools WHERE @SchoolID=0 OR SchoolID=@SchoolID) S ON S.SchoolID=P.SchoolID
  INNER JOIN (SELECT * FROM Leagues WHERE @LeagueID=0 OR LeagueID=@LeagueID) L ON L.LeagueID=S.LeagueID
  INNER JOIN (SELECT * FROM Districts WHERE @DistrictID=0 OR DistrictID=@DistrictID) D ON D.DistrictID=L.DistrictID
  INNER JOIN (SELECT * FROM States WHERE @StateID=0 OR StateID=@StateID) T ON T.StateID=D.StateID

GROUP BY GR.PlayerID, PlayerName, SchoolName, LeagueName, DistrictName, StateName

HAVING AVG(CAST(Points AS decimal))<>0 

ORDER BY AVG(CAST(Score AS decimal)), PlayerName