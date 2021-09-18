using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Practices : System.Web.UI.Page {

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

                sqlViewSchoolList.SelectParameters["SchoolID"].DefaultValue = Session["SchoolID"].ToString();
                ddSchools.DataBind();
                pnlSelSchool.Visible = ((int)Session["SchoolID"] == 0);
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            ddLeagues.DataBind();
            ddSchools.DataBind();
            gvPracticeMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddSchools.DataBind();
            gvPracticeMaint.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddSchools.DataBind();
            gvPracticeMaint.DataBind();
        }

        protected void ddSchools_DataBound(object sender, EventArgs e) {
            if (ddSchools.Items.Count == 0) {
                ListItem NoSchools = new ListItem("(No schools)", "0");
                ddSchools.Items.Add(NoSchools);
            }
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            gvPracticeMaint.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            conn.Open();
            SqlCommand sqlCmd = new SqlCommand(
                "SELECT TOP 1 GolfCourseID=ISNULL(DefaultGolfCourseID,1), GolfCourseTeeID=ISNULL(DefaultGolfCourseTeeID,1), HolesPlayedID=ISNULL(DefaultHolesPlayedID,1), PlayerID "+
                "FROM Schools S INNER JOIN Players P ON S.SchoolID=P.SchoolID WHERE S.SchoolID=@SchoolID ORDER BY PlayerName", conn);
            sqlCmd.Parameters.Add("@SchoolID", SqlDbType.Int).Value = ddSchools.SelectedValue;
            SqlDataAdapter adapter = new SqlDataAdapter(sqlCmd);
            DataTable tblDefaults = new DataTable();
            adapter.Fill(tblDefaults);
            conn.Close();
            if (tblDefaults.Rows.Count == 0) {
                ScriptManager.RegisterStartupScript(this, GetType(), "PracticeNoPlayersAlert" + UniqueID,
                    "alert('The selected school must have at least one player before you can create a practice round.');", true);
                return;
            }

            sqlPracticeMaint.InsertParameters["DatePlayed"].DefaultValue = DateTime.Now.ToShortDateString();
            sqlPracticeMaint.InsertParameters["PlayerID"].DefaultValue = tblDefaults.Rows[0]["PlayerID"].ToString();
            sqlPracticeMaint.InsertParameters["GolfCourseID"].DefaultValue = tblDefaults.Rows[0]["GolfCourseID"].ToString();
            sqlPracticeMaint.InsertParameters["GolfCourseTeeID"].DefaultValue = tblDefaults.Rows[0]["GolfCourseTeeID"].ToString();
            sqlPracticeMaint.InsertParameters["HolesPlayedID"].DefaultValue = tblDefaults.Rows[0]["HolesPlayedID"].ToString();
            sqlPracticeMaint.Insert();
        }

        protected void btnUpdate_Click(object sender, EventArgs e) {
            gvPracticeMaint.UpdateRow(gvPracticeMaint.EditIndex, false);
        }

        protected void btnCancel_Click(object sender, EventArgs e) {
            gvPracticeMaint.EditIndex = -1;
            gvPracticeMaint.DataBind();
            gvGolfRoundInfo.Visible = false;
        }

        protected void gvPracticeRowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvPracticeMaint.EditIndex == -1) ? 0 : 1;

            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate)) {
                    // select the row being edited
                    //gvPracticeMaint.SelectedIndex = gvPracticeMaint.EditIndex;
                    // when binding a row that's in an edit state, bind the cascaded drop down
                    sqlGolfCourseTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfCourseID"].ToString();
                    ((DropDownList)e.Row.FindControl("ddGolfCourseTees")).DataBind();
                    ((DropDownList)e.Row.FindControl("ddGolfCourseTees")).SelectedValue = ((DataRowView)e.Row.DataItem)["GolfCourseTeeID"].ToString();
                    // bind the details table to the data from the row being edited
                    sqlGolfRoundInfo.SelectParameters["GolfRoundID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfRoundID"].ToString();
                    sqlGolfRoundInfo.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfCourseID"].ToString();
                    sqlGolfRoundInfo.SelectParameters["GolfCourseTeeID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfCourseTeeID"].ToString();
                    sqlGolfRoundInfo.SelectParameters["Gender"].DefaultValue = ((DataRowView)e.Row.DataItem)["Gender"].ToString();

                    // when we bind the round info, we only want to make the holes played visible, so we need to keep track of that
                    Session["HolesPlayedID"] = ((DataRowView)e.Row.DataItem)["HolesPlayedID"].ToString();
                    gvGolfRoundInfo.DataBind();
                    gvGolfRoundInfo.Visible = true;
                }
                else {
                    // when editing a row, hide the control buttons for the other rows
                    e.Row.FindControl("btnEdit").Visible = e.Row.FindControl("btnDelete").Visible = (gvPracticeMaint.EditIndex == -1);
                }
            }
        }

        private int[] par = new int[19];
        protected void gvGolfRoundInfo_RowDataBound(object sender, GridViewRowEventArgs e) {
            // when the gvPracticeMaint edit row was bound, we saved the HolesPlayedID
            // id 1 = Front 9, 2 = Back 9, 3 = All 18
            int intHolesPlayedID = 1;
            Int32.TryParse(Session["HolesPlayedID"].ToString(), out intHolesPlayedID);

            for (int i = 1; i <= 9; i++) {
                // only show the holes played
                e.Row.Cells[i].Visible = (intHolesPlayedID == 1 || intHolesPlayedID == 3);
                e.Row.Cells[i + 10].Visible = (intHolesPlayedID == 2 || intHolesPlayedID == 3);
            }
            e.Row.Cells[10].Visible = (intHolesPlayedID == 1);
            e.Row.Cells[20].Visible = (intHolesPlayedID == 2);
            e.Row.Cells[21].Visible = (intHolesPlayedID == 3);
            e.Row.Attributes.Add("HolesHidden", "true");

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
                e.Row.Cells[10].Text = Out.ToString("n0");
                e.Row.Cells[20].Text = In.ToString("n0");
                e.Row.Cells[21].Text = (Out + In).ToString("n0");
            }
            if (e.Row.RowType == DataControlRowType.Footer) {
                // make the left-most footer cell span the whole grid
                int cols = e.Row.Cells.Count;
                for (int i = 1; i < cols; i++) {
                    e.Row.Cells.RemoveAt(1);
                    e.Row.Cells[0].ColumnSpan = cols;
                }
            }
        }

        protected void gvPracticeRowUpdating(object sender, GridViewUpdateEventArgs e) {
            // When updating the record, use the value from the cascaded drop down list
            sqlPracticeMaint.UpdateParameters["GolfCourseTeeID"].DefaultValue = ((DropDownList)gvPracticeMaint.Rows[e.RowIndex].FindControl("ddGolfCourseTees")).SelectedValue;
        }

        protected void sqlPracticeInserted(object sender, SqlDataSourceStatusEventArgs e) {
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();

            // fill a table with the GolfCourseHoleIDs for the currently selected golf course
            SqlCommand sqlCmd = new SqlCommand("SELECT GolfCourseHoleID FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID", sqlConn);
            sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = ((DbCommand)e.Command).Parameters["@GolfCourseID"].Value;
            SqlDataAdapter sqlAdpt = new SqlDataAdapter(sqlCmd);
            DataTable tblHoles = new DataTable();
            sqlAdpt.Fill(tblHoles);

            // loop thru all the holes for the new round to insert a default score of zero
            sqlCmd.CommandText = "INSERT INTO GolfRoundHoles (GolfRoundID, GolfCourseHoleID, Score) VALUES (@GolfRoundID, @GolfCourseHoleID, 0)";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = ((DbCommand)e.Command).Parameters["@GolfRoundID"].Value.ToString();
            sqlCmd.Parameters.Add("@GolfCourseHoleID", SqlDbType.Int).Value = 0;
            foreach (DataRow r in tblHoles.Rows) {
                sqlCmd.Parameters["@GolfCourseHoleID"].Value = r["GolfCourseHoleID"];
                sqlCmd.ExecuteNonQuery();
            }
            sqlConn.Close();

            // the new record should sort to the top of the gridview, so edit the first row
            gvPracticeMaint.EditIndex = 0;
        }

        protected void sqlPracticeUpdated(object sender, SqlDataSourceStatusEventArgs e) {
            // when the practice round gets updated, it's possible that the golf course was changed
            // so update the golf round hole IDs to match the practice golf course
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            // replace the old course hole IDs with the new course hole IDs to associate the new par and handicap values
            string strSQL =
                "UPDATE RH SET RH.GolfCourseHoleID = NewHoles.GolfCourseHoleID FROM GolfRoundHoles RH" +
                " INNER JOIN GolfCourseHoles OldHoles ON OldHoles.GolfCourseHoleID = RH.GolfCourseHoleID" +
                " INNER JOIN GolfCourseHoles NewHoles ON NewHoles.HoleNumber = OldHoles.HoleNumber AND NewHoles.GolfCourseID = @NewGolfCourseID" +
                " WHERE RH.GolfRoundID = @GolfRoundID";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            // values from sql update parms
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = ((DbCommand)e.Command).Parameters["@GolfRoundID"].Value;
            sqlCmd.Parameters.Add("@NewGolfCourseID", SqlDbType.Int).Value = ((DbCommand)e.Command).Parameters["@GolfCourseID"].Value;
            sqlCmd.ExecuteNonQuery();
            sqlConn.Close();

            UpdateRoundDetails();
            gvGolfRoundInfo.Visible = false;
        }

        protected void gvPracticeRowCancelingEdit(object sender, GridViewCancelEditEventArgs e) {
            gvGolfRoundInfo.Visible = false;
        }

        protected void ddGolfCourses_SelectedIndexChanged(object sender, EventArgs e) {
            // rebind the associated course tees for the new course
            sqlGolfCourseTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            ((DropDownList)gvPracticeMaint.Rows[gvPracticeMaint.EditIndex].FindControl("ddGolfCourseTees")).DataBind();

            // rebind detail info
            sqlGolfRoundInfo.SelectParameters["GolfCourseID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            sqlGolfRoundInfo.SelectParameters["GolfCourseTeeID"].DefaultValue = ((DropDownList)gvPracticeMaint.Rows[gvPracticeMaint.EditIndex].FindControl("ddGolfCourseTees")).SelectedValue;
            gvGolfRoundInfo.DataBind();
        }

        protected void ddGolfCourseTees_SelectedIndexChanged(object sender, EventArgs e) {
            // rebind detail info
            sqlGolfRoundInfo.SelectParameters["GolfCourseTeeID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            gvGolfRoundInfo.DataBind();
        }

        protected void ddHolesPlayed_SelectedIndexChanged(object sender, EventArgs e) {
            // save hole selection in class-level variable to be used when binding round info
            Session["HolesPlayedID"] = ((DropDownList)sender).SelectedValue;
            gvGolfRoundInfo.DataBind();
        }

        protected void ddPlayers_SelectedIndexChanged(object sender, EventArgs e) {
            // find out if the new player is male or female
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            string strSQL = "SELECT Gender FROM Players WHERE PlayerID=@PlayerID";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            sqlCmd.Parameters.Add("@PlayerID", SqlDbType.Int).Value = ((DropDownList)sender).SelectedValue;
            sqlGolfRoundInfo.SelectParameters["Gender"].DefaultValue = (string)sqlCmd.ExecuteScalar();

            // rebind detail info
            gvGolfRoundInfo.DataBind();
        }

        protected void UpdateRoundDetails() {
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

            // to calculate points, we need to know the player's gender
            string gender = ((Label)gvPracticeMaint.Rows[gvPracticeMaint.EditIndex].FindControl("Gender")).Text;

            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            string strSQL =
                "UPDATE RH SET Score=@Score, Points=@Points, Putts=@Putts, IsFairway=@IsFairway, IsGreen=@IsGreen " +
                "FROM GolfRoundHoles RH INNER JOIN GolfCourseHoles CH ON CH.GolfCourseHoleID=RH.GolfCourseHoleID " +
                "WHERE GolfRoundID=@GolfRoundID AND HoleNumber=@HoleNumber";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = gvPracticeMaint.DataKeys[gvPracticeMaint.EditIndex].Value;
            sqlCmd.Parameters.Add("@HoleNumber", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Score", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Points", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Putts", SqlDbType.Int);
            sqlCmd.Parameters.Add("@IsFairway", SqlDbType.Int);
            sqlCmd.Parameters.Add("@IsGreen", SqlDbType.Int);

            // when the gvPracticeMaint edit row was bound, we saved the HolesPlayedID
            // id 1 = Front 9, 2 = Back 9, 3 = All 18
            int intHolesPlayedID = 1;
            Int32.TryParse(Session["HolesPlayedID"].ToString(), out intHolesPlayedID);

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
                    basis = (gender == "F") ? 3 : 2;            // ladies get an extra point
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
            sqlCmd.Parameters.Add("@GolfRoundID", SqlDbType.Int).Value = gvPracticeMaint.DataKeys[gvPracticeMaint.EditIndex].Value;
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

            sqlConn.Close();

            gvPracticeMaint.DataBind();
            gvGolfRoundInfo.DataBind();
        }
    }
}