DECLARE @GolfCourseID int=1

SELECT H.*, Out=0, [In]=0, Total=0 FROM (
  SELECT * FROM (SELECT Par, Info=' Par', HoleNumber FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
   PIVOT(MAX(Par) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT HandicapMen, Info='Men''s', HoleNumber FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
   PIVOT(MAX(HandicapMen) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT HandicapWomen, Info='Women''s', HoleNumber FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
   PIVOT(MAX(HandicapWomen) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 ) H