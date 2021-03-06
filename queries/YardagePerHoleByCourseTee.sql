USE [GolfDb]
GO

/****** Object:  StoredProcedure [dbo].[sp_YardagePerHoleByCourseTee]    Script Date: 3/21/2017 1:00:48 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================-- Author:		David Fabritius-- Create date: 12/14/2016-- Description:	YardagePerHoleByCourseTee-- =============================================
ALTER PROCEDURE dbo.sp_YardagePerHoleByCourseTee 
-- Add the parameters for the stored procedure here
    @GolfCourseID int,
    @GolfCourseTeeID int=0
AS

BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
  SET NOCOUNT ON;

 SELECT * FROM (
  SELECT Y.GolfCourseTeeID, T.TeeName, HoleNumber=CAST(H.HoleNumber AS nvarchar(4)), Y.Yardage, T.IsActive
  FROM HoleYardages Y
   INNER JOIN GolfCourseTees T ON T.GolfCourseTeeID=Y.GolfCourseTeeID
   INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=Y.GolfCourseHoleID
  WHERE T.GolfCourseID=@GolfCourseID
   AND (ISNULL(@GolfCourseTeeID, 0)=0 OR T.GolfCourseTeeID=@GolfCourseTeeID)) Y 

 PIVOT(MAX(Yardage) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [Out], [In], [Total])) P

 ORDER BY [1] DESC

END
