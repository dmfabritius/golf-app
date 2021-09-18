using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Matches : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // If not logged in, you can view anything; but if you are logged in, then what you can access and edit is restricted
            if ((int)Session["SchoolID"] == -1) return;

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
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            ddLeagues.DataBind();
            ddMatches.DataBind();
            fvMatchMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddMatches.DataBind();
            fvMatchMaint.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            fvMatchMaint.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            fvMatchMaint.DataBind();
        }

        protected void ddMatches_DataBound(object sender, EventArgs e) {
            if (ddMatches.Items.Count == 0) {
                ListItem NoMatches = new ListItem("(No matches)", "0");
                ddMatches.Items.Add(NoMatches);
            }
        }

        protected void ddMatches_SelectedIndexChanged(object sender, EventArgs e) {
            fvMatchMaint.DataBind();
        }

        protected void ddGolfCourses_SelectedIndexChanged(object sender, EventArgs e) {
            // rebind the associated tees for the new course
            sqlVarsityTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            sqlJVTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).DataBind();
            ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).DataBind();
        }

        protected void ddHomeSchools_SelectedIndexChanged(object sender, EventArgs e) {
            // populdate the course, tee, and holes played from the home school's defaults
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            conn.Open();
            SqlCommand sqlCmd = new SqlCommand(
                "SELECT GolfCourseID=ISNULL(DefaultGolfCourseID,1), GolfCourseTeeID=ISNULL(DefaultGolfCourseTeeID,1), HolesPlayedID=ISNULL(DefaultHolesPlayedID,1) " +
                "FROM Schools WHERE SchoolID=@SchoolID", conn);
            sqlCmd.Parameters.Add("@SchoolID", SqlDbType.Int).Value = ((DropDownList)sender).SelectedValue;
            SqlDataAdapter adapter = new SqlDataAdapter(sqlCmd);
            DataTable tblDefaults = new DataTable();
            adapter.Fill(tblDefaults);
            conn.Close();

            ((DropDownList)fvMatchMaint.FindControl("ddGolfCourses")).SelectedValue =
                sqlVarsityTeeList.SelectParameters["GolfCourseID"].DefaultValue =
                sqlJVTeeList.SelectParameters["GolfCourseID"].DefaultValue = tblDefaults.Rows[0]["GolfCourseID"].ToString();

            // rebind the associated tees for the new course and select the default tee
            ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).DataBind();
            ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).DataBind();
            ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).SelectedValue =
                ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).SelectedValue = tblDefaults.Rows[0]["GolfCourseTeeID"].ToString();

            ((DropDownList)fvMatchMaint.FindControl("ddHolesPlayed")).SelectedValue = tblDefaults.Rows[0]["HolesPlayedID"].ToString();
        }

        protected void fvMatchDataBound(object sender, EventArgs e) {
            if (fvMatchMaint.CurrentMode == FormViewMode.Edit) {
                // bind and select the cascaded drop downs
                sqlVarsityTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)fvMatchMaint.DataItem)["GolfCourseID"].ToString();
                sqlJVTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)fvMatchMaint.DataItem)["GolfCourseID"].ToString();
                ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).DataBind();
                ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).DataBind();
                ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).SelectedValue = ((DataRowView)fvMatchMaint.DataItem)["VarsityTeeID"].ToString();
                ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).SelectedValue = ((DataRowView)fvMatchMaint.DataItem)["JVTeeID"].ToString();

                // don't allow schools to be changed if any players have been assigned
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                sqlConn.Open();
                string strSQL =
                    "SELECT NumHomePlayers=COUNT(HP.PlayerID), NumAwayPlayers=COUNT(AP.PlayerID) " +
                    "FROM Matches M" +
                    " INNER JOIN MatchGolfRounds MR ON MR.MatchID = M.MatchID" +
                    " INNER JOIN GolfRounds GR ON GR.GolfRoundID = MR.GolfRoundID" +
                    " LEFT JOIN Players HP ON HP.PlayerID = GR.PlayerID AND HP.SchoolID = M.HomeSchoolID" +
                    " LEFT JOIN Players AP ON AP.PlayerID = GR.PlayerID AND AP.SchoolID = M.AwaySchoolID " +
                    "WHERE M.MatchID = @MatchID";
                SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
                sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;
                SqlDataAdapter saMatch = new SqlDataAdapter(sqlCmd);
                DataTable tblMatch = new DataTable();
                saMatch.Fill(tblMatch);
                sqlConn.Close();
                if (Int32.Parse(tblMatch.Rows[0]["NumHomePlayers"].ToString()) != 0) {
                    ((DropDownList)fvMatchMaint.FindControl("ddHomeSchools")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddHomeSchools")).ToolTip = "Remove all player assignments before changing schools.";
                }
                if (Int32.Parse(tblMatch.Rows[0]["NumAwayPlayers"].ToString()) != 0) {
                    ((DropDownList)fvMatchMaint.FindControl("ddAwaySchools")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddAwaySchools")).ToolTip = "Remove all player assignments before changing schools.";
                }

                // don't allow any of the course information to change if any players have been assigned
                /*
                if (Int32.Parse(tblMatch.Rows[0]["NumHomePlayers"].ToString()) != 0 || Int32.Parse(tblMatch.Rows[0]["NumAwayPlayers"].ToString()) != 0) {
                    ((DropDownList)fvMatchMaint.FindControl("ddGolfCourses")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddGolfCourses")).ToolTip = "Remove all player assignments before changing the course.";
                    ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).ToolTip = "Remove all player assignments before changing tees.";
                    ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).ToolTip = "Remove all player assignments before changing tees.";
                    ((DropDownList)fvMatchMaint.FindControl("ddHolesPlayed")).Enabled = false;
                    ((DropDownList)fvMatchMaint.FindControl("ddHolesPlayed")).ToolTip = "Remove all player assignments before changing which holes are played.";
                }
                */
            }
        }

        protected void fvMatchItemUpdating(object sender, FormViewUpdateEventArgs e) {
            // When updating the record, use the value from the cascaded drop down lists
            sqlMatchMaint.UpdateParameters["VarsityTeeID"].DefaultValue = ((DropDownList)fvMatchMaint.FindControl("ddVarsityTees")).SelectedValue;
            sqlMatchMaint.UpdateParameters["JVTeeID"].DefaultValue = ((DropDownList)fvMatchMaint.FindControl("ddJVTees")).SelectedValue;
        }

        protected void fvMatchMaint_ItemUpdated(object sender, FormViewUpdatedEventArgs e) {
            // if the match name/description is changed, reload the list of matches
            if (e.OldValues["MatchName"].ToString() != e.NewValues["MatchName"].ToString()) {
                ddMatches.DataBind();
                ddMatches.SelectedValue = ddMatches.SelectedValue;
            }

            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            SqlCommand sqlCmd = new SqlCommand();
            sqlCmd.Connection = sqlConn;
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;

            // sync changes made to the match with all the match rounds
            sqlCmd.CommandText =
                "UPDATE GR SET" +
                " GR.DatePlayed=M.MatchDate," +
                " GR.GolfCourseID=M.GolfCourseID," +
                " GR.GolfCourseTeeID=CASE WHEN GR.IsVarsity=1 THEN M.VarsityTeeID ELSE M.JVTeeID END," +
                " GR.HolesPlayedID=M.HolesPlayedID " +
                "FROM Matches M" +
                " INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID" +
                " INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID " +
                "WHERE MR.MatchID=@MatchID";
            sqlCmd.ExecuteNonQuery();

            // if the match golf course was changed, update all related child records
            if (e.OldValues["GolfCourseID"].ToString() != e.NewValues["GolfCourseID"].ToString()) {
                // update all the players' golf round holes
                sqlCmd.CommandText =
                    "UPDATE RH " +
                    "SET RH.GolfCourseHoleID=NewHoles.GolfCourseHoleID " +
                    "FROM Matches M" +
                    " INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID" +
                    " INNER JOIN GolfRoundHoles RH ON RH.GolfRoundID=MR.GolfRoundID" +
                    " INNER JOIN GolfCourseHoles OldHoles ON OldHoles.GolfCourseHoleID=RH.GolfCourseHoleID" +
                    " INNER JOIN GolfCourseHoles NewHoles ON NewHoles.HoleNumber=OldHoles.HoleNumber AND NewHoles.GolfCourseID=M.GolfCourseID " +
                    "WHERE MR.MatchID=@MatchID";
                sqlCmd.ExecuteNonQuery();
                // update all the players' golf round hole points
                sqlCmd.CommandText =
                    "UPDATE RH SET RH.Points=" +
                    " case when RH.Score = 0 then 0" +
                    "      else case when Gender = 'M'" +
                    "                then case when Par - RH.Score + 2 < 0 then 0" +
                    "                          else case when Par - RH.Score + 2 > 5 then 5 else Par - RH.Score + 2 end" +
                    "                     end" +
                    "                else case when Par - RH.Score + 3 < 0 then 0" +
                    "                          else case when Par - RH.Score + 3 > 6 then 6 else Par - RH.Score + 3 end" +
                    "                     end" +
                    "           end" +
                    " end " +
                    "FROM Matches M" +
                    " INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID" +
                    " INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID" +
                    " INNER JOIN GolfRoundHoles RH ON RH.GolfRoundID=MR.GolfRoundID" +
                    " INNER JOIN GolfCourseHoles CH ON CH.GolfCourseHoleID=RH.GolfCourseHoleID" +
                    " INNER JOIN Players P ON GR.PlayerID=P.PlayerID " +
                    "WHERE MR.MatchID=@MatchID";
                sqlCmd.ExecuteNonQuery();
                // update all the players' golf round points
                sqlCmd.CommandText =
                    "UPDATE GR SET GR.Points=RH.TotalPoints " +
                    "FROM Matches M" +
                    " INNER JOIN MatchGolfRounds MR ON MR.MatchID=M.MatchID" +
                    " INNER JOIN GolfRounds GR ON GR.GolfRoundID=MR.GolfRoundID" +
                    " INNER JOIN" +
                    "  (SELECT RH.GolfRoundID, TotalPoints=SUM(RH.Points)" +
                    "   FROM GolfRoundHoles RH" +
                    "    INNER JOIN MatchGolfRounds MR ON MR.GolfRoundID=RH.GolfRoundID AND MR.MatchID=@MatchID" +
                    "   GROUP BY RH.GolfRoundID) RH ON RH.GolfRoundID=MR.GolfRoundID " +
                    "WHERE MR.MatchID=@MatchID";
                sqlCmd.ExecuteNonQuery();
                // update lowest handicap holes
                sqlCmd.CommandText = "WITH " +
                    "ML AS (" +
                    "  SELECT TOP 1 M.MatchID, MensHoleNumber = HoleNumber," +
                    "     MensLowest = SUM(GolfCourseHoleID) OVER(ORDER BY HandicapMen)" +
                    "  FROM Matches M INNER JOIN GolfCourseHoles H ON M.GolfCourseID = H.GolfCourseID AND MatchID = @MatchID" +
                    "  WHERE(HolesPlayedID = 1 AND HoleNumber <= 9) OR(HolesPlayedID = 2 AND HoleNumber > 9))," +
                    "WL AS (" +
                    "  SELECT TOP 1 M.MatchID, WomensHoleNumber = HoleNumber," +
                    "     WomensLowest = SUM(GolfCourseHoleID) OVER(ORDER BY HandicapWomen)" +
                    "  FROM Matches M INNER JOIN GolfCourseHoles H ON M.GolfCourseID = H.GolfCourseID AND MatchID = @MatchID" +
                    "  WHERE(HolesPlayedID = 1 AND HoleNumber <= 9) OR(HolesPlayedID = 2 AND HoleNumber > 9))," +
                    "LH AS (" +
                    "  SELECT ML.MatchID, MensLowest, MensHoleNumber, WomensLowest, WomensHoleNumber" +
                    "  FROM ML INNER JOIN WL ON ML.MatchID = WL.MatchID) " +
                    "UPDATE M SET LowestHandicapMenHoleID = MensLowest, LowestHandicapWomenHoleID = WomensLowest " +
                    "FROM Matches M INNER JOIN LH ON LH.MatchID = M.MatchID AND M.Matchid = @MatchID";
                sqlCmd.ExecuteNonQuery();
                //// update the total match points for the Home and Away teams' varsity players
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
            }
            sqlConn.Close();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlMatchMaint.InsertParameters["MatchDate"].DefaultValue = DateTime.Now.ToShortDateString();
            sqlMatchMaint.Insert();
        }

        protected void sqlMatchInserted(object sender, SqlDataSourceStatusEventArgs e) {
            // re-bind matches dropdown to include newly added match and select it
            ddMatches.DataBind();
            try {
                ddMatches.SelectedValue = ((DbCommand)e.Command).Parameters["@MatchID"].Value.ToString();
            }
            catch (Exception ex) {
                // if we can't get back to the previous match, that's okay
            }
        }

        protected void sqlMatchDeleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "MatchDeleteAlert" + UniqueID,
                    "alert('This match cannot be deleted until there are no players assigned to it.');", true);
                e.ExceptionHandled = true;
            }
            else {
                ddMatches.DataBind();
                fvMatchMaint.DataBind();
            }
        }
    }
}