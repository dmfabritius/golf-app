using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class MatchScoreEntryDetailed : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // you have to be at least a school coach (basically anything except not logged in) to view this page
            if ((int)Session["SchoolID"] == -1) Server.Transfer("default.aspx");

            // Restrict access based on what user is logged in (see Login.aspx for more info)
            if (!IsPostBack) {
                sqlViewStateList.SelectParameters["StateID"].DefaultValue = Session["StateID"].ToString();
                ddStates.DataBind();
                pnlSelState.Visible = ((int)Session["StateID"] == 0);

                sqlViewDistrictList.SelectParameters["DistrictID"].DefaultValue = Session["DistrictID"].ToString();
                ddDistricts.DataBind();
                pnlSelDistrict.Visible = ((int)Session["DistrictID"] == 0);

                sqlViewLeagueList.SelectParameters["LeagueID"].DefaultValue = Session["LeagueID"].ToString();
                ddLeagues.DataBind();
                pnlSelLeague.Visible = ((int)Session["LeagueID"] == 0);

                ddYears.DataBind();

                sqlViewMatchList.SelectParameters["SchoolID"].DefaultValue = Session["SchoolID"].ToString();
                ddMatches.DataBind();

                // to allow both school coaches to edit scores for both teams, set SchoolID parameter to 0 instead of the Session variable
                //sqlViewPlayerList.SelectParameters["SchoolID"].DefaultValue = Session["SchoolID"].ToString();
                sqlViewPlayerList.SelectParameters["SchoolID"].DefaultValue = "0";
                ddPlayers.DataBind();
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            ddLeagues.DataBind();
            ddMatches.DataBind();
            ddPlayers.DataBind();
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddMatches.DataBind();
            ddPlayers.DataBind();
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            ddPlayers.DataBind();
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            ddPlayers.DataBind();
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        protected void ddMatches_DataBound(object sender, EventArgs e) {
            if (ddMatches.Items.Count == 0) {
                ListItem NoMatches = new ListItem("(No matches)", "0");
                ddMatches.Items.Add(NoMatches);
            }
        }

        protected void ddMatches_SelectedIndexChanged(object sender, EventArgs e) {
            ddPlayers.DataBind();
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        protected void ddPlayers_DataBound(object sender, EventArgs e) {
            if (ddPlayers.Items.Count == 0) {
                ListItem NoPlayers = new ListItem("(No players)", "0");
                ddPlayers.Items.Add(NoPlayers);
            }
        }

        protected void ddPlayers_SelectedIndexChanged(object sender, EventArgs e) {
            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }

        private string HolesPlayedID;
        protected void gvGolfRoundInfo_DataBinding(object sender, EventArgs e) {
            int MatchID, PlayerID;
            if (!Int32.TryParse(ddMatches.SelectedValue, out MatchID)) MatchID = 0;
            if (!Int32.TryParse(ddPlayers.SelectedValue, out PlayerID)) PlayerID = 0;

            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            string strSQL =
                "SELECT GR.GolfRoundID, GR.GolfCourseID, GolfCourseTeeID, GR.HolesPlayedID, Gender " +
                "FROM Matches M" +
                " INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID" +
                " INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID" +
                " INNER JOIN Players P ON P.PlayerID=GR.PlayerID AND P.PlayerID=@PlayerID " +
                "WHERE M.MatchID=@MatchID";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = MatchID;
            sqlCmd.Parameters.Add("@PlayerID", SqlDbType.Int).Value = PlayerID;
            SqlDataAdapter sqlAdpt = new SqlDataAdapter(sqlCmd);
            DataTable tblMatchRound = new DataTable();
            sqlAdpt.Fill(tblMatchRound);
            if (tblMatchRound.Rows.Count != 0) {
                sqlGolfRoundInfo.SelectParameters["GolfRoundID"].DefaultValue = tblMatchRound.Rows[0]["GolfRoundID"].ToString();
                sqlGolfRoundInfo.SelectParameters["GolfCourseID"].DefaultValue = tblMatchRound.Rows[0]["GolfCourseID"].ToString();
                sqlGolfRoundInfo.SelectParameters["GolfCourseTeeID"].DefaultValue = tblMatchRound.Rows[0]["GolfCourseTeeID"].ToString();
                sqlGolfRoundInfo.SelectParameters["Gender"].DefaultValue = tblMatchRound.Rows[0]["Gender"].ToString();
                // store the holes played so we can display only those details
                HolesPlayedID = tblMatchRound.Rows[0]["HolesPlayedID"].ToString();
                gvGolfRoundInfo.Visible = true;
            } else {
                gvGolfRoundInfo.Visible = false;
            }
        }

        private int[] par = new int[19];
        protected void gvGolfRoundInfo_RowDataBound(object sender, GridViewRowEventArgs e) {
            int intHolesPlayedID = 1;
            Int32.TryParse(HolesPlayedID, out intHolesPlayedID);
            // to calculate the score for the round, we will need to know which holes were played, so save that
            Session["HolesPlayedID"] = intHolesPlayedID;

            // only show the holes played
            for (int i = 1; i <= 9; i++) {
                e.Row.Cells[i].Visible = (intHolesPlayedID == 1 || intHolesPlayedID == 3);
                e.Row.Cells[i + 10].Visible = (intHolesPlayedID == 2 || intHolesPlayedID == 3);
            }
            e.Row.Cells[10].Visible = (intHolesPlayedID == 1);
            e.Row.Cells[20].Visible = (intHolesPlayedID == 2);
            e.Row.Cells[21].Visible = (intHolesPlayedID == 3);

            if (e.Row.RowType == DataControlRowType.DataRow) {
                int In = 0, Out = 0;
                for (int i = 1; i <= 18; i++) {
                    // save the par for each hole
                    if (DataBinder.Eval(e.Row.DataItem, "Info").ToString() == "Par") {
                        par[i] = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    }
                    // if the par is 3, then hide the Fairway checkbox
                    if (DataBinder.Eval(e.Row.DataItem, "Info").ToString() == "Fairway" && par[i] == 3) {
                        ((CheckBox)e.Row.FindControl("i" + i.ToString("00") + "Checkbox")).Enabled = false;
                    }

                    // calculate totals
                    if (i <= 9) {
                        Out += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    }
                    else {
                        In += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, (i).ToString()));
                    }
                }
                e.Row.Cells[10].Text = (Out != 0) ? Out.ToString("n0") : "";
                e.Row.Cells[20].Text = (In != 0) ? In.ToString("n0") : "";
                e.Row.Cells[21].Text = ((Out + In) != 0) ? (Out + In).ToString("n0") : "";
            }
        }

        private int TotalHVPoints = 0, TotalHJPoints = 0, TotalAVPoints = 0, TotalAJPoints = 0;
        private int TotalHVScore = 0, TotalHJScore = 0, TotalAVScore = 0, TotalAJScore = 0;
        private int WorstHVPoints = 999, WorstHJPoints = 999, WorstAVPoints = 999, WorstAJPoints = 999;
        private int WorstHVScore = 0, WorstHJScore = 0, WorstAVScore = 0, WorstAJScore = 0;
        private int HVCount = 0, HJCount = 0, AVCount = 0, AJCount = 0;
        protected void gvScoreSummary_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            const int HVPointsCellIndex = 3;
            const int AVPointsCellIndex = 6;
            const int HJPointsCellIndex = 9;
            const int AJPointsCellIndex = 12;
            const int HVScoreCellIndex = 2;
            const int AVScoreCellIndex = 5;
            const int HJScoreCellIndex = 8;
            const int AJScoreCellIndex = 11;

            int HVPoints = 0, HJPoints = 0, AVPoints = 0, AJPoints = 0;
            int HVScore = 0, HJScore = 0, AVScore = 0, AJScore = 0;
            if (e.Row.RowType == DataControlRowType.DataRow) {
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeVarsityPoints"].ToString(), out HVPoints);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeJVPoints"].ToString(), out HJPoints);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayVarsityPoints"].ToString(), out AVPoints);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayJVPoints"].ToString(), out AJPoints);
                TotalHVPoints += HVPoints;
                TotalHJPoints += HJPoints;
                TotalAVPoints += AVPoints;
                TotalAJPoints += AJPoints;
                if (HVPoints < WorstHVPoints) WorstHVPoints = HVPoints;
                if (HJPoints < WorstHJPoints) WorstHJPoints = HJPoints;
                if (AVPoints < WorstAVPoints) WorstAVPoints = AVPoints;
                if (AJPoints < WorstAJPoints) WorstAJPoints = AJPoints;
                if (HVPoints != 0) HVCount++;
                if (HJPoints != 0) HJCount++;
                if (AVPoints != 0) AVCount++;
                if (AJPoints != 0) AJCount++;
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeVarsityScore"].ToString(), out HVScore);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeJVScore"].ToString(), out HJScore);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayVarsityScore"].ToString(), out AVScore);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayJVScore"].ToString(), out AJScore);
                TotalHVScore += HVScore;
                TotalHJScore += HJScore;
                TotalAVScore += AVScore;
                TotalAJScore += AJScore;
                if (HVScore > WorstHVScore) WorstHVScore = HVScore;
                if (HJScore > WorstHJScore) WorstHJScore = HJScore;
                if (AVScore > WorstAVScore) WorstAVScore = AVScore;
                if (AJScore > WorstAJScore) WorstAJScore = AJScore;
            }
            else if (e.Row.RowType == DataControlRowType.Footer) {
                string HVPointsStr = (TotalHVPoints != 0) ? TotalHVPoints.ToString() : "";
                string AVPointsStr = (TotalAVPoints != 0) ? TotalAVPoints.ToString() : "";
                string HJPointsStr = (TotalHJPoints != 0) ? TotalHJPoints.ToString() : "";
                string AJPointsStr = (TotalAJPoints != 0) ? TotalAJPoints.ToString() : "";
                string HVScoreStr = (TotalHVScore != 0) ? TotalHVScore.ToString() : "";
                string AVScoreStr = (TotalAVScore != 0) ? TotalAVScore.ToString() : "";
                string HJScoreStr = (TotalHJScore != 0) ? TotalHJScore.ToString() : "";
                string AJScoreStr = (TotalAJScore != 0) ? TotalAJScore.ToString() : "";

                e.Row.Cells[0].Text = "Totals:<br>Best 5:";
                if (HVCount > 5) {
                    TotalHVScore -= WorstHVScore;
                    TotalHVPoints -= WorstHVPoints;
                }
                if (HJCount > 5) {
                    TotalHJScore -= WorstHJScore;
                    TotalHJPoints -= WorstHJPoints;
                }
                if (AVCount > 5) {
                    TotalAVScore -= WorstAVScore;
                    TotalAVPoints -= WorstAVPoints;
                }
                if (AJCount > 5) {
                    TotalAJScore -= WorstAJScore;
                    TotalAJPoints -= WorstAJPoints;
                }

                HVPointsStr += (TotalHVPoints != 0) ? "<br>" + TotalHVPoints.ToString() : "";
                AVPointsStr += (TotalAVPoints != 0) ? "<br>" + TotalAVPoints.ToString() : "";
                HJPointsStr += (TotalHJPoints != 0) ? "<br>" + TotalHJPoints.ToString() : "";
                AJPointsStr += (TotalAJPoints != 0) ? "<br>" + TotalAJPoints.ToString() : "";
                HVScoreStr += (TotalHVScore != 0) ? "<br>" + TotalHVScore.ToString() : "";
                AVScoreStr += (TotalAVScore != 0) ? "<br>" + TotalAVScore.ToString() : "";
                HJScoreStr += (TotalHJScore != 0) ? "<br>" + TotalHJScore.ToString() : "";
                AJScoreStr += (TotalAJScore != 0) ? "<br>" + TotalAJScore.ToString() : "";

                e.Row.Cells[HVPointsCellIndex].Text = HVPointsStr;
                e.Row.Cells[AVPointsCellIndex].Text = AVPointsStr;
                e.Row.Cells[HJPointsCellIndex].Text = HJPointsStr;
                e.Row.Cells[AJPointsCellIndex].Text = AJPointsStr;
                e.Row.Cells[HVScoreCellIndex].Text = HVScoreStr;
                e.Row.Cells[AVScoreCellIndex].Text = AVScoreStr;
                e.Row.Cells[HJScoreCellIndex].Text = HJScoreStr;
                e.Row.Cells[AJScoreCellIndex].Text = AJScoreStr;
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e) {
            const int ParRowIndex = 2;
            const int ScoreRowIndex = 4;
            const int PuttsRowIndex = 5;
            const int IsFairwayRowIndex = 6;
            const int IsGreenRowIndex = 7;
            const int LabelControlIndex = 1;
            const int TextBoxControlIndex = 3;
            const int CheckBoxControlIndex = 5;

            int HoleCellIndex;
            int score, putts, fairway, green, par, points, basis;
            int TotalScore = 0, TotalPoints = 0, TotalPutts = 0, TotalFairways = 0, TotalGreens = 0, TotalUnplayedHoles = 0;
            bool bolZeroScore = false;

            int intHolesPlayedID = 1;
            Int32.TryParse(Session["HolesPlayedID"].ToString(), out intHolesPlayedID);

            // load the info needed for this match player
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            string strSQL =
                "SELECT GR.GolfRoundID, Gender " +
                "FROM Matches M" +
                " INNER JOIN MatchGolfRounds MR ON MR.MatchID = M.MatchID" +
                " INNER JOIN GolfRounds GR ON GR.GolfRoundID = MR.GolfRoundID" +
                " INNER JOIN Players P ON P.PlayerID = GR.PlayerID AND P.PlayerID=@PlayerID " +
                "WHERE M.MatchID=@MatchID";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;
            sqlCmd.Parameters.Add("@PlayerID", SqlDbType.Int).Value = ddPlayers.SelectedValue;
            SqlDataAdapter sqlAdpt = new SqlDataAdapter(sqlCmd);
            DataTable tblMatchRound = new DataTable();
            sqlAdpt.Fill(tblMatchRound);

            // set up the query for updating each hole
            strSQL =
                "UPDATE RH SET Score=@Score, Points=@Points, Putts=@Putts, IsFairway=@IsFairway, IsGreen=@IsGreen " +
                "FROM GolfRoundHoles RH INNER JOIN GolfCourseHoles CH ON CH.GolfCourseHoleID=RH.GolfCourseHoleID " +
                "WHERE GolfRoundID=@GolfRoundID AND HoleNumber=@HoleNumber";
            sqlCmd.CommandText = strSQL;
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = tblMatchRound.Rows[0]["GolfRoundID"].ToString();
            sqlCmd.Parameters.Add("@HoleNumber", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Score", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Points", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Putts", SqlDbType.Int);
            sqlCmd.Parameters.Add("@IsFairway", SqlDbType.Int);
            sqlCmd.Parameters.Add("@IsGreen", SqlDbType.Int);

            // loop thru all the holes and update round info, including calculating points
            for (int i = 1; i <= 18; i++) {
                HoleCellIndex = (i < 10) ? i : i + 1; // the back 9 hole cells are offset by one because of the Out subtotal column
                sqlCmd.Parameters["@HoleNumber"].Value = i.ToString();

                //score
                if (!Int32.TryParse(((TextBox)gvGolfRoundInfo.Rows[ScoreRowIndex].Cells[HoleCellIndex].Controls[TextBoxControlIndex]).Text, out score)) score = 0;
                sqlCmd.Parameters["@Score"].Value = score.ToString();
                TotalScore += score;

                //points
                if (score == 0) {
                    // if the score for any hole played is zero, then set flag so the score for the entire round is set to zero
                    // also count up each unplayed hole
                    if ((intHolesPlayedID == 1 && i <= 9) || (intHolesPlayedID == 2 && i > 9) || (intHolesPlayedID == 3)) {
                        TotalUnplayedHoles++;
                        bolZeroScore = true;
                    }
                    points = 0; //no points if you didn't play the hole
                }
                else {
                    par = Int32.Parse(((Label)gvGolfRoundInfo.Rows[ParRowIndex].Cells[HoleCellIndex].Controls[LabelControlIndex]).Text);
                    basis = (tblMatchRound.Rows[0]["Gender"].ToString() == "F") ? 3 : 2; // ladies get an extra point
                    points = par - score + basis;               // convert a raw score to points
                    if (par == 3 && score == 1) points++;       // bonus point if you get a hole-in-one on a par 3
                    if (points < 0) points = 0;                 // can't score less than 0 points
                    if (points > basis + 3) points = basis + 3; // can't score more than the max (5 for boys and 6 for girls)
                }
                sqlCmd.Parameters["@Points"].Value = points.ToString();
                TotalPoints += points;

                //putts
                if (!Int32.TryParse(((TextBox)gvGolfRoundInfo.Rows[PuttsRowIndex].Cells[HoleCellIndex].Controls[TextBoxControlIndex]).Text, out putts)) putts = 0;
                sqlCmd.Parameters["@Putts"].Value = putts.ToString();
                TotalPutts += putts;

                //fairway
                fairway = (((CheckBox)gvGolfRoundInfo.Rows[IsFairwayRowIndex].Cells[HoleCellIndex].Controls[CheckBoxControlIndex]).Checked) ? 1 : 0;
                sqlCmd.Parameters["@IsFairway"].Value = fairway.ToString();
                TotalFairways += fairway;

                //green
                green = (((CheckBox)gvGolfRoundInfo.Rows[IsGreenRowIndex].Cells[HoleCellIndex].Controls[CheckBoxControlIndex]).Checked) ? 1 : 0;
                sqlCmd.Parameters["@IsGreen"].Value = green.ToString();
                TotalGreens += green;

                // update golf round hole details
                sqlCmd.ExecuteNonQuery();
            }

            if (bolZeroScore) {
                TotalScore = 0;
                //TotalPoints = 0;
            }

            // update totals in parent golf round table
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = tblMatchRound.Rows[0]["GolfRoundID"].ToString();
            sqlCmd.Parameters.Add("@Score", SqlDbType.Int).Value = TotalScore.ToString();
            sqlCmd.Parameters.Add("@Points", SqlDbType.Int).Value = TotalPoints.ToString();
            sqlCmd.Parameters.Add("@Putts", SqlDbType.Int).Value = TotalPutts.ToString();
            sqlCmd.Parameters.Add("@Fairways", SqlDbType.Int).Value = TotalFairways.ToString();
            sqlCmd.Parameters.Add("@Greens", SqlDbType.Int).Value = TotalGreens.ToString();
            sqlCmd.Parameters.Add("@UnplayedHoles", SqlDbType.Int).Value = TotalUnplayedHoles.ToString();
            sqlCmd.CommandText =
                "UPDATE GolfRounds SET" +
                " Score=@Score, Points=@Points, Putts=@Putts, Fairways=@Fairways, Greens=@Greens, UnplayedHoles=@UnplayedHoles " +
                "WHERE GolfRoundID=@GolfRoundID";
            sqlCmd.ExecuteNonQuery();

            // update totals for the match
            //sqlCmd.Parameters.Clear();
            //sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;
            //sqlCmd.CommandText =
            //    "UPDATE M SET HomeSchoolPoints = HomePoints, AwaySchoolPoints = AwayPoints " +
            //    "FROM Matches M" +
            //    " INNER JOIN (SELECT M.MatchID, " +
            //    "                    HomePoints = SUM(CASE WHEN P.SchoolID = M.HomeSchoolID THEN GR.Points ELSE 0 END)," +
            //    "                    AwayPoints = SUM(CASE WHEN P.SchoolID = M.AwaySchoolID THEN GR.Points ELSE 0 END)" +
            //    "             FROM Matches M" +
            //    "              INNER JOIN MatchGolfRounds MR ON MR.MatchID = M.MatchID" +
            //    "              INNER JOIN GolfRounds GR ON GR.GolfRoundID = MR.GolfRoundID AND GR.IsVarsity = 1" +
            //    "              INNER JOIN Players P ON GR.PlayerID = P.PlayerID" +
            //    "            GROUP BY M.MatchID" +
            //    "            HAVING M.MatchID = @MatchID AND(SUM(CASE WHEN P.SchoolID = M.HomeSchoolID THEN GR.Points ELSE 0 END) <> 0" +
            //    "                   OR SUM(CASE WHEN P.SchoolID = M.AwaySchoolID THEN GR.Points ELSE 0 END) <> 0)) T ON M.MatchID = T.MatchID";
            //sqlCmd.ExecuteNonQuery();

            sqlConn.Close();

            gvGolfRoundInfo.DataBind();
            gvScoreSummary.DataBind();
        }
    }
}