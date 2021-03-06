USE [GolfDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_InfoPerHoleByRound]    Script Date: 3/21/2017 12:15:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		David Fabritius
-- Create date: 2/26/2017
-- Description:	golf round info
-- =============================================
ALTER PROCEDURE [dbo].[sp_InfoPerHoleByRound] 
	-- Add the parameters for the stored procedure here
	@GolfRoundID int = 7,
	@GolfCourseID int = 1,
	@GolfCourseTeeID int = 1,
	@Gender nvarchar(MAX) = 'F'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT U.*, Out=0, [In]=0, Total=0 FROM (
   SELECT * FROM (SELECT Sort=1, Info=TeeName, HoleNumber, Yardage
                  FROM HoleYardages Y
                   INNER JOIN GolfCourseTees T ON T.GolfCourseTeeID=Y.GolfCourseTeeID
                   INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=Y.GolfCourseHoleID
                  WHERE T.GolfCourseID=@GolfCourseID
                   AND (ISNULL(@GolfCourseTeeID, 0)=0 OR T.GolfCourseTeeID=@GolfCourseTeeID)) Y
    PIVOT(MAX(Yardage) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
   SELECT * FROM (SELECT Sort=2, Info='Men''s', HoleNumber, HandicapMen FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
    PIVOT(MAX(HandicapMen) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=3, Info='Women''s', HoleNumber, HandicapWomen FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
   PIVOT(MAX(HandicapWomen) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=4, Info='Par', HoleNumber, Par FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID) H
   PIVOT(MAX(Par) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=5, Info='Points', HoleNumber, Points
                 FROM GolfRoundHoles R INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=R.GolfCourseHoleID
                 WHERE GolfRoundID=@GolfRoundID) H
   PIVOT(MAX(Points) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=6, Info='Score', HoleNumber, Score
                 FROM GolfRoundHoles R INNER JOIN GolfCourseHoles H ON R.GolfCourseHoleID=H.GolfCourseHoleID
                 WHERE GolfRoundID=@GolfRoundID) H
   PIVOT(MAX(Score) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=7, Info='Putts', HoleNumber, Putts
                 FROM GolfRoundHoles R INNER JOIN GolfCourseHoles H ON R.GolfCourseHoleID=H.GolfCourseHoleID
                 WHERE GolfRoundID=@GolfRoundID) H
   PIVOT(MAX(Putts) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=8, Info='Fairway', HoleNumber, Fairways=CAST(IsFairway AS int)
                 FROM GolfRoundHoles R INNER JOIN GolfCourseHoles H ON R.GolfCourseHoleID=H.GolfCourseHoleID
                 WHERE GolfRoundID=@GolfRoundID) H
   PIVOT(MAX(Fairways) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 UNION
  SELECT * FROM (SELECT Sort=9, Info='Green', HoleNumber, Greens=CAST(IsGreen AS int)
                 FROM GolfRoundHoles R INNER JOIN GolfCourseHoles H ON R.GolfCourseHoleID=H.GolfCourseHoleID
                 WHERE GolfRoundID=@GolfRoundID) H
   PIVOT(MAX(Greens) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) AS P
 ) U
WHERE Info <> CASE WHEN @Gender='M' THEN 'Women''s' ELSE 'Men''s' END
ORDER BY Sort

END
