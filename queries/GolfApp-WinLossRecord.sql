DECLARE @LeagueID int = 21

SELECT *, Pct=Wins*10000/(Wins+Losses)

FROM (SELECT
  SchoolName,TeamType,
  Wins=SUM(CASE WHEN Win <> -1 THEN Win ELSE 0 END),
  Losses=COUNT(*)-SUM(CASE WHEN Win <> -1 THEN Win ELSE 1 END),
  PointTies=SUM(Tie)

 FROM (SELECT
  SchoolName,TeamType,
  Win=CASE WHEN HomePoints=AwayPoints
            -- tied on points
            THEN CASE WHEN HomeUnplayedHoles=AwayUnplayedHoles
                      -- tied on the team's total number of unplayed holes
                      THEN CASE WHEN HomePlayersWithUnplayedHoles=AwayPlayersWithUnplayedHoles
                                -- tied on the number of players with unplayed holes
                                THEN CASE WHEN HomeScore=AwayScore
                                          -- tied on score
                                          THEN -1 -- no tie-breaking options left
                                          -- not a tie on score
                                          ELSE CASE WHEN (S.SchoolID=HomeSchoolID AND HomeScore<AwayScore) OR 
                                                         (S.SchoolID=AwaySchoolID AND AwayScore<HomeScore)
                                                    THEN 1 -- team with the lowest score wins
                                                    ELSE 0 -- loss
                                               END
                                     END
                                -- not a tie on the number of players with unplayed holes
                                ELSE CASE WHEN (S.SchoolID=HomeSchoolID AND HomePlayersWithUnplayedHoles>AwayPlayersWithUnplayedHoles) OR
                                               (S.SchoolID=AwaySchoolID AND AwayPlayersWithUnplayedHoles>HomePlayersWithUnplayedHoles)
                                          THEN 1 -- win
                                          ELSE 0 -- loss
                                     END
                           END
                      -- not a tie on the team's total number of unplayed holes
                      ELSE CASE WHEN (S.SchoolID=HomeSchoolID AND HomeUnplayedHoles>AwayUnplayedHoles) OR
                                     (S.SchoolID=AwaySchoolID AND AwayUnplayedHoles>HomeUnplayedHoles)
                                THEN 1 -- win
                                ELSE 0 -- loss
                           END
                 END
            -- not a tie on points
            ELSE CASE WHEN (S.SchoolID=HomeSchoolID AND HomePoints>AwayPoints) OR 
                           (S.SchoolID=AwaySchoolID AND AwayPoints>HomePoints)
                      THEN 1 -- team with the most points wins
                      ELSE 0 -- loss
                 END
       END,
  Tie=CASE WHEN HomePoints=AwayPoints THEN 1 ELSE 0 END
  FROM (SELECT * FROM Schools WHERE LeagueID=@LeagueID) S
   INNER JOIN (SELECT
     M.MatchID, HomeSchoolID, AwaySchoolID,
     TeamType=CASE WHEN MatchGender='M' THEN 'Boys' ELSE 'Girls' END,
     HomeScore=SUM(CASE WHEN P.SchoolID=M.HomeSchoolID THEN GR.Score ELSE 0 END),
     HomePoints=SUM(CASE WHEN P.SchoolID=M.HomeSchoolID THEN GR.Points ELSE 0 END),
     HomeUnplayedHoles=SUM(CASE WHEN P.SchoolID=M.HomeSchoolID THEN GR.UnplayedHoles ELSE 0 END),
     HomePlayersWithUnplayedHoles=SUM(CASE WHEN P.SchoolID=M.HomeSchoolID AND GR.UnplayedHoles <> 0 THEN 1 ELSE 0 END),
     AwayScore=SUM(CASE WHEN P.SchoolID=M.AwaySchoolID THEN GR.Score ELSE 0 END),
     AwayPoints=SUM(CASE WHEN P.SchoolID=M.AwaySchoolID THEN GR.Points ELSE 0 END),
     AwayUnplayedHoles=SUM(CASE WHEN P.SchoolID=M.AwaySchoolID THEN GR.UnplayedHoles ELSE 0 END),
     AwayPlayersWithUnplayedHoles=SUM(CASE WHEN P.SchoolID=M.AwaySchoolID AND GR.UnplayedHoles <> 0 THEN 1 ELSE 0 END)
     FROM Matches M
      INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID
      INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID AND GR.IsVarsity=1
      INNER JOIN Players P ON GR.PlayerID=P.PlayerID
     GROUP BY M.MatchID, MatchGender, HomeSchoolID, AwaySchoolID) M ON S.SchoolID=M.HomeSchoolID OR S.SchoolID=M.AwaySchoolID
   WHERE M.HomePoints <> 0 OR M.AwayPoints <> 0) SQ1

 GROUP BY TeamType, SchoolName) SQ2

ORDER BY TeamType, Wins*10000/(Wins+Losses) DESC, SchoolName

