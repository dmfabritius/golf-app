DECLARE @StateID int=1;
DECLARE @DistrictID int=3;
DECLARE @LeagueID int=18;
DECLARE @SchoolID int=0;

SELECT MatchDate, MatchTime, HomeSchoolName=HS.SchoolName, AwaySchoolName=WS.SchoolName, GolfCourseName

FROM Matches AS M
 INNER JOIN Schools AS HS ON M.HomeSchoolID=HS.SchoolID
 INNER JOIN Schools AS WS ON M.AwaySchoolID=WS.SchoolID
 INNER JOIN GolfCourses AS C ON M.GolfCourseID=C.GolfCourseID

WHERE(@StateID=0 OR StateID=@StateID)
 AND (@DistrictID=0 OR DistrictID=@DistrictID)
 AND (@LeagueID=0 OR M.LeagueID=@LeagueID)
 AND (@SchoolID=0 OR HomeSchoolID=@SchoolID OR AwaySchoolID=@SchoolID)

ORDER BY MatchDate, MatchTime;