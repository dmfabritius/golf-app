using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class MatchPlayers : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // If not logged in, you can only view
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
            fvMatchInfo.DataBind();
            gvMatchPlayersMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddMatches.DataBind();
            fvMatchInfo.DataBind();
            gvMatchPlayersMaint.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            fvMatchInfo.DataBind();
            gvMatchPlayersMaint.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            ddMatches.DataBind();
            fvMatchInfo.DataBind();
            gvMatchPlayersMaint.DataBind();
        }

        protected void ddMatches_DataBound(object sender, EventArgs e) {
            if (ddMatches.Items.Count == 0) {
                ListItem NoMatches = new ListItem("(No matches)", "0");
                ddMatches.Items.Add(NoMatches);
            }
            else {
                SetMatchSchools();
            }
        }

        protected void ddMatches_SelectedIndexChanged(object sender, EventArgs e) {
            SetMatchSchools();
            fvMatchInfo.DataBind();
            gvMatchPlayersMaint.DataBind();
        }

        protected void ddVarsityPlayers_SelectedIndexChanged(object sender, EventArgs e) {
            // this is an absurd use of the AccessKey property to pass in the player's position, but it works well enough
            InsertRoundDetails("Varsity", ((DropDownList)sender).SelectedValue, ((DropDownList)sender).AccessKey);
        }

        protected void ddJVPlayers_SelectedIndexChanged(object sender, EventArgs e) {
            // this is an absurd use of the AccessKey property to pass in the player's position, but it works well enough
            InsertRoundDetails("JV", ((DropDownList)sender).SelectedValue, ((DropDownList)sender).AccessKey);
        }

        private void InsertRoundDetails(string PlayerType, string PlayerID, string Position) {
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();

            // fill a table with info about the selected match
            SqlCommand sqlCmd = new SqlCommand("SELECT * FROM Matches WHERE MatchID=@MatchID", sqlConn);
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;
            SqlDataAdapter saMatch = new SqlDataAdapter(sqlCmd);
            DataTable tblMatch = new DataTable();
            saMatch.Fill(tblMatch);

            // create a new round for the player
            sqlCmd.CommandText =
                "INSERT INTO GolfRounds ( GolfRoundTypeID,  PlayerID,  IsVarsity,  GolfCourseID,  GolfCourseTeeID,  HolesPlayedID,  DatePlayed,  MatchPosition) " +
                "VALUES                 (@GolfRoundTypeID, @PlayerID, @IsVarsity, @GolfCourseID, @GolfCourseTeeID, @HolesPlayedID, @DatePlayed, @MatchPosition); " +
                "SELECT SCOPE_IDENTITY()";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfRoundTypeID", SqlDbType.Int).Value = 3; // the type of this round is for a match, as opposed to a practice or qualifying round
            sqlCmd.Parameters.Add("@PlayerID", SqlDbType.Int).Value = PlayerID;
            sqlCmd.Parameters.Add("@MatchPosition", SqlDbType.Int).Value = Position;
            sqlCmd.Parameters.Add("@IsVarsity", SqlDbType.Bit).Value = (PlayerType == "Varsity");
            sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = tblMatch.Rows[0]["GolfCourseID"].ToString();
            sqlCmd.Parameters.Add("@GolfCourseTeeID", SqlDbType.Int).Value = (PlayerType == "Varsity") ? tblMatch.Rows[0]["VarsityTeeID"].ToString() : tblMatch.Rows[0]["JVTeeID"].ToString();
            sqlCmd.Parameters.Add("@HolesPlayedID", SqlDbType.Int).Value = tblMatch.Rows[0]["HolesPlayedID"].ToString();
            sqlCmd.Parameters.Add("@DatePlayed", SqlDbType.DateTime).Value = tblMatch.Rows[0]["MatchDate"].ToString();
            //sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int);
            string GolfRoundID = sqlCmd.ExecuteScalar().ToString();

            // fill a table with the GolfCourseHoleIDs for the currently selected golf course
            sqlCmd.CommandText = "SELECT GolfCourseHoleID FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = tblMatch.Rows[0]["GolfCourseID"].ToString();
            SqlDataAdapter saHoles = new SqlDataAdapter(sqlCmd);
            DataTable tblHoles = new DataTable();
            saHoles.Fill(tblHoles);

            // loop thru all the holes for the new round to insert a default score of zero
            sqlCmd.CommandText = "INSERT INTO GolfRoundHoles (GolfRoundID, GolfCourseHoleID, Score) VALUES (@GolfRoundID, @GolfCourseHoleID, 0)";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = GolfRoundID;
            sqlCmd.Parameters.Add("@GolfCourseHoleID", SqlDbType.Int);
            foreach (DataRow r in tblHoles.Rows) {
                sqlCmd.Parameters["@GolfCourseHoleID"].Value = r["GolfCourseHoleID"];
                sqlCmd.ExecuteNonQuery();
            }

            // create record linking the new golf round to the current match
            sqlCmd.CommandText = "INSERT INTO MatchGolfRounds (MatchID, GolfRoundID) VALUES (@MatchID, @GolfRoundID)";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = ddMatches.SelectedValue;
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = GolfRoundID;
            sqlCmd.ExecuteNonQuery();

            sqlConn.Close();

            gvMatchPlayersMaint.DataBind();
        }

        protected void btnDelete_Command(object sender, CommandEventArgs e) {
            // remove the cross-reference link between the match and the golf round, then delete the golf round
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            SqlCommand sqlCmd = new SqlCommand("DELETE FROM MatchGolfRounds WHERE GolfRoundID=@GolfRoundID", sqlConn);
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = e.CommandArgument.ToString();
            sqlCmd.ExecuteNonQuery();
            sqlCmd.CommandText = "DELETE FROM GolfRounds WHERE GolfRoundID=@GolfRoundID";
            sqlCmd.ExecuteNonQuery();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            Server.Transfer("Matches.aspx");
        }

        private void SetMatchSchools() {
            int MatchID;
            if (!Int32.TryParse(ddMatches.SelectedValue, out MatchID)) MatchID = 0;

            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            SqlCommand sqlCmd = new SqlCommand("SELECT HomeSchoolID, AwaySchoolID FROM Matches M WHERE M.MatchID=@MatchID", sqlConn);
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = MatchID;
            SqlDataAdapter saMatchSchools = new SqlDataAdapter(sqlCmd);
            DataTable tblMatchSchools = new DataTable();
            saMatchSchools.Fill(tblMatchSchools);
            if (tblMatchSchools.Rows.Count != 0) {
                sqlHomeSchoolPlayersList.SelectParameters["SchoolID"].DefaultValue = tblMatchSchools.Rows[0]["HomeSchoolID"].ToString();
                sqlAwaySchoolPlayersList.SelectParameters["SchoolID"].DefaultValue = tblMatchSchools.Rows[0]["AwaySchoolID"].ToString();
            }
        }
    }
}