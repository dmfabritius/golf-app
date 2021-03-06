USE [GolfDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_InfoPerHoleByPlayer]    Script Date: 3/21/2017 11:53:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		David Fabritius
-- Create date: 3/17/2017
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_InfoPerHoleByPlayer] 
	@PlayerID int = 7,
	@IsPractice int = 1,
	@IsNineHoles int = 1,
	@Info nvarchar(MAX) = 'Fairways'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT U.*, Out=0, [In]=0, Total=0 FROM (
  SELECT * FROM (SELECT Info='Scores', GR.GolfRoundID, DatePlayed, HoleNumber, GRH.Score
                FROM GolfRounds GR
                 INNER JOIN GolfRoundHoles GRH ON GRH.GolfRoundID=GR.GolfRoundID
                 INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=GRH.GolfCourseHoleID
                WHERE PlayerID=@PlayerID
                 AND (@IsPractice=1 AND GR.GolfRoundTypeID<>3 OR @IsPractice=0 AND GR.GolfRoundTypeID=3)
                 AND (@IsNineHoles=1 AND GR.HolesPlayedID<>3 OR @IsNineHoles=0 AND GR.HolesPlayedID=3)) H 
   PIVOT(MAX(Score) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT Info='Points', GR.GolfRoundID, DatePlayed, HoleNumber, GRH.Points
                FROM GolfRounds GR
                 INNER JOIN GolfRoundHoles GRH ON GRH.GolfRoundID=GR.GolfRoundID
                 INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=GRH.GolfCourseHoleID
                WHERE PlayerID=@PlayerID
                 AND (@IsPractice=1 AND GR.GolfRoundTypeID<>3 OR @IsPractice=0 AND GR.GolfRoundTypeID=3)
                 AND (@IsNineHoles=1 AND GR.HolesPlayedID<>3 OR @IsNineHoles=0 AND GR.HolesPlayedID=3)) H 
   PIVOT(MAX(Points) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT Info='Putts', GR.GolfRoundID, DatePlayed, HoleNumber, GRH.Putts
                FROM GolfRounds GR
                 INNER JOIN GolfRoundHoles GRH ON GRH.GolfRoundID=GR.GolfRoundID
                 INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=GRH.GolfCourseHoleID
                WHERE PlayerID=@PlayerID
                 AND (@IsPractice=1 AND GR.GolfRoundTypeID<>3 OR @IsPractice=0 AND GR.GolfRoundTypeID=3)
                 AND (@IsNineHoles=1 AND GR.HolesPlayedID<>3 OR @IsNineHoles=0 AND GR.HolesPlayedID=3)) H 
   PIVOT(MAX(Putts) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT Info='Fairways', GR.GolfRoundID, DatePlayed, HoleNumber, Fairways=CAST(GRH.IsFairway AS int)
                FROM GolfRounds GR
                 INNER JOIN GolfRoundHoles GRH ON GRH.GolfRoundID=GR.GolfRoundID
                 INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=GRH.GolfCourseHoleID
                WHERE PlayerID=@PlayerID
                 AND (@IsPractice=1 AND GR.GolfRoundTypeID<>3 OR @IsPractice=0 AND GR.GolfRoundTypeID=3)
                 AND (@IsNineHoles=1 AND GR.HolesPlayedID<>3 OR @IsNineHoles=0 AND GR.HolesPlayedID=3)) H 
   PIVOT(MAX(Fairways) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 UNION
  SELECT * FROM (SELECT Info='Greens', GR.GolfRoundID, DatePlayed, HoleNumber, Greens=CAST(GRH.IsGreen AS int)
                FROM GolfRounds GR
                 INNER JOIN GolfRoundHoles GRH ON GRH.GolfRoundID=GR.GolfRoundID
                 INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=GRH.GolfCourseHoleID
                WHERE PlayerID=@PlayerID
                 AND (@IsPractice=1 AND GR.GolfRoundTypeID<>3 OR @IsPractice=0 AND GR.GolfRoundTypeID=3)
                 AND (@IsNineHoles=1 AND GR.HolesPlayedID<>3 OR @IsNineHoles=0 AND GR.HolesPlayedID=3)) H 
   PIVOT(MAX(Greens) FOR HoleNumber IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18])) P
 ) U
WHERE U.Info=@Info
ORDER BY DatePlayed

END
