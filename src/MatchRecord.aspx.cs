using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class MatchRecord : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            SqlCommand sqlCmd = new SqlCommand();

            if (!IsPostBack) {
                // check to see if a specific organization was requested as part of the URL; and if so, verify that it exists
                string StateID = Request.QueryString["state"];
                string DistrictID = Request.QueryString["district"];
                string LeagueID = Request.QueryString["league"];
                if (LeagueID != null) {
                    sqlCmd.Parameters.Add("@LeagueID", SqlDbType.Int).Value = LeagueID;
                    sqlCmd.CommandText =
                        "SELECT StateID, D.DistrictID, LeagueID, SchoolID=0 " +
                        "FROM Leagues L INNER JOIN Districts D ON L.DistrictID = D.DistrictID " +
                        "WHERE LeagueID = @LeagueID";
                } else if (DistrictID != null) {
                    sqlCmd.Parameters.Add("@DistrictID", SqlDbType.Int).Value = DistrictID;
                    sqlCmd.CommandText = "SELECT StateID, DistrictID, LeagueID=0, SchoolID=0 FROM Districts WHERE DistrictID=@DistrictID";
                } else if (StateID != null) {
                    sqlCmd.Parameters.Add("@StateID", SqlDbType.Int).Value = StateID;
                    sqlCmd.CommandText = "SELECT StateID, DistrictID=0, LeagueID=0, SchoolID=0 WHERE StateID=@StateID";
                }
                if (sqlCmd.Parameters.Count != 0) {
                    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                    conn.Open();
                    sqlCmd.Connection = conn;
                    SqlDataAdapter adapter = new SqlDataAdapter(sqlCmd);
                    DataTable tblDefaults = new DataTable();
                    adapter.Fill(tblDefaults);
                    conn.Close();
                    // if the requested organization exists, set cookies to use it as the initial default for the report
                    if (tblDefaults.Rows.Count != 0) {
                        CreateCookie("state", tblDefaults.Rows[0]["StateID"].ToString());
                        CreateCookie("district", tblDefaults.Rows[0]["DistrictID"].ToString());
                        CreateCookie("league", tblDefaults.Rows[0]["LeagueID"].ToString());
                        // reload page so all the dropdown lists bind correctly
                        Response.Redirect("MatchRecord");
                    }
                }
            }
        }

        protected void CreateCookie(string name, string value) {
            HttpCookie cookie = new HttpCookie(name);
            cookie.Value = value;
            cookie.Expires = DateTime.Now.AddYears(1);
            Response.Cookies.Add(cookie);
        }

        protected void ddStates_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["StateID"] != -1 && ddStates.SelectedValue != Session["StateID"].ToString()) {
                    ddStates.SelectedValue = Session["StateID"].ToString();
                    ddDistricts.DataBind();
                }
                else if (Request.Cookies["state"] != null && ddStates.SelectedValue != Request.Cookies["state"].Value) {
                    ddStates.SelectedValue = Request.Cookies["state"].Value;
                    ddDistricts.DataBind();
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            gvLeagueWinLoss.DataBind();
        }

        protected void ddDistricts_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["DistrictID"] != -1 && ddDistricts.SelectedValue != Session["DistrictID"].ToString()) {
                    ddDistricts.SelectedValue = Session["DistrictID"].ToString();
                    ddLeagues.DataBind();
                }
                else if (Request.Cookies["district"] != null && ddDistricts.SelectedValue != Request.Cookies["district"].Value) {
                    ddDistricts.SelectedValue = Request.Cookies["district"].Value;
                    ddLeagues.DataBind();
                }
            }
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            gvLeagueWinLoss.DataBind();
        }

        protected void ddLeagues_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["LeagueID"] != -1 && ddLeagues.SelectedValue != Session["LeagueID"].ToString()) {
                    ddLeagues.SelectedValue = Session["LeagueID"].ToString();
                }
                else if (Request.Cookies["league"] != null && ddLeagues.SelectedValue != Request.Cookies["league"].Value) {
                    ddLeagues.SelectedValue = Request.Cookies["league"].Value;
                }
            }
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            gvLeagueWinLoss.DataBind();
        }

        protected void ddGender_SelectedIndexChanged(object sender, EventArgs e) {
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            gvLeagueWinLoss.DataBind();
        }

        protected void gvLeagueWinLoss_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                // if a row hasn't been selected, then select the first row
                if (gvLeagueWinLoss.SelectedIndex == -1) gvLeagueWinLoss.SelectedIndex = 0;
                // bind the details table to the data from the selected row
                if (e.Row.RowIndex == gvLeagueWinLoss.SelectedIndex) {
                    sqlSchoolWinLoss.SelectParameters["SchoolID"].DefaultValue = ((DataRowView)e.Row.DataItem)["SchoolID"].ToString();
                    gvSchoolWinLoss.DataBind();
                    e.Row.BackColor = ColorTranslator.FromHtml("#F7E7CA");
                }
            }
        }

        protected void gvLeagueWinLoss_SelectedIndexChanged(object sender, EventArgs e) {
            foreach (GridViewRow row in gvLeagueWinLoss.Rows) {
                // turn all the rows back to their normal color
                row.BackColor = (row.RowState == DataControlRowState.Alternate) ? ColorTranslator.FromHtml("#FFFFFF") : ColorTranslator.FromHtml("#E3EAEB");
                // turn the selected row a different color
                row.BackColor = (row.RowIndex == gvLeagueWinLoss.SelectedIndex) ? ColorTranslator.FromHtml("#F7E7CA") : row.BackColor;
            }
//            sqlSchoolWinLoss.SelectParameters["SchoolID"].DefaultValue = gvLeagueWinLoss.DataKeys[gvLeagueWinLoss.SelectedIndex].Value.ToString();
//            gvSchoolWinLoss.DataBind();
        }

        protected void gvSchoolWinLoss_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                // if a row hasn't been selected, then select the first row
                if (gvSchoolWinLoss.SelectedIndex == -1) gvSchoolWinLoss.SelectedIndex = 0;
                // highlight selected row
                if (e.Row.RowIndex == gvSchoolWinLoss.SelectedIndex) {
                    e.Row.BackColor = ColorTranslator.FromHtml("#F7E7CA");
                }
            }
        }

        protected void gvSchoolWinLoss_SelectedIndexChanged(object sender, EventArgs e) {
            foreach (GridViewRow row in gvSchoolWinLoss.Rows) {
                // turn all the rows back to their normal color
                row.BackColor = (row.RowState == DataControlRowState.Alternate) ? ColorTranslator.FromHtml("#FFFFFF") : ColorTranslator.FromHtml("#E3EAEB");
                // turn the selected row a different color
                row.BackColor = (row.RowIndex == gvSchoolWinLoss.SelectedIndex) ? ColorTranslator.FromHtml("#F7E7CA") : row.BackColor;
            }
        }

        private int TotalHVPoints = 0, TotalAVPoints = 0;
        private int TotalHVScore = 0, TotalAVScore = 0;
        private int WorstHVPoints = 999, WorstAVPoints = 999;
        private int WorstHVScore = 0, WorstAVScore = 0;
        private int HVCount = 0, AVCount = 0;
        protected void gvScoreSummary_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            const int HVScoreCellIndex = 2;
            const int HVPointsCellIndex = 3;
            const int AVScoreCellIndex = 5;
            const int AVPointsCellIndex = 6;

            int HVPoints = 0, AVPoints = 0;
            int HVScore = 0, AVScore = 0;
            if (e.Row.RowType == DataControlRowType.DataRow) {
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeVarsityPoints"].ToString(), out HVPoints);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayVarsityPoints"].ToString(), out AVPoints);
                TotalHVPoints += HVPoints;
                TotalAVPoints += AVPoints;
                if (HVPoints < WorstHVPoints) WorstHVPoints = HVPoints;
                if (AVPoints < WorstAVPoints) WorstAVPoints = AVPoints;
                if (HVPoints != 0) HVCount++;
                if (AVPoints != 0) AVCount++;
                Int32.TryParse(((DataRowView)e.Row.DataItem)["HomeVarsityScore"].ToString(), out HVScore);
                Int32.TryParse(((DataRowView)e.Row.DataItem)["AwayVarsityScore"].ToString(), out AVScore);
                TotalHVScore += HVScore;
                TotalAVScore += AVScore;
                if (HVScore > WorstHVScore) WorstHVScore = HVScore;
                if (AVScore > WorstAVScore) WorstAVScore = AVScore;
            }
            else if (e.Row.RowType == DataControlRowType.Footer) {
                string HVPointsStr = (TotalHVPoints != 0) ? TotalHVPoints.ToString() : "";
                string AVPointsStr = (TotalAVPoints != 0) ? TotalAVPoints.ToString() : "";
                string HVScoreStr = (TotalHVScore != 0) ? TotalHVScore.ToString() : "";
                string AVScoreStr = (TotalAVScore != 0) ? TotalAVScore.ToString() : "";

                e.Row.Cells[0].Text = "Totals:<br>Best 5:";
                if (HVCount > 5) {
                    TotalHVScore -= WorstHVScore;
                    TotalHVPoints -= WorstHVPoints;
                }
                if (AVCount > 5) {
                    TotalAVScore -= WorstAVScore;
                    TotalAVPoints -= WorstAVPoints;
                }

                HVPointsStr += (TotalHVPoints != 0) ? "<br>" + TotalHVPoints.ToString() : "";
                AVPointsStr += (TotalAVPoints != 0) ? "<br>" + TotalAVPoints.ToString() : "";
                HVScoreStr += (TotalHVScore != 0) ? "<br>" + TotalHVScore.ToString() : "";
                AVScoreStr += (TotalAVScore != 0) ? "<br>" + TotalAVScore.ToString() : "";

                e.Row.Cells[HVPointsCellIndex].Text = HVPointsStr;
                e.Row.Cells[AVPointsCellIndex].Text = AVPointsStr;
                e.Row.Cells[HVScoreCellIndex].Text = HVScoreStr;
                e.Row.Cells[AVScoreCellIndex].Text = AVScoreStr;
            }
        }

        private int HolesPlayedID;

        protected void gvGolfRoundInfo_DataBinding(object sender, EventArgs e) {
            // determine which holes were played for the selected match
            //int MatchID;
            //if (!Int32.TryParse(gvSchoolWinLoss.DataKeys[gvLeagueWinLoss.SelectedIndex].Value.ToString(), out MatchID)) MatchID = 0;
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            SqlCommand sqlCmd = new SqlCommand("SELECT HolesPlayedID FROM Matches WHERE MatchID=@MatchID", sqlConn);
            sqlCmd.Parameters.Add("@MatchID", SqlDbType.Int).Value = gvSchoolWinLoss.SelectedValue;
            try {
                HolesPlayedID = Int32.Parse(sqlCmd.ExecuteScalar().ToString());
            }
            catch {
                HolesPlayedID = 1;
            }
        }

        protected void gvGolfRoundInfo_RowDataBound(object sender, GridViewRowEventArgs e) {
            // only show the holes played (as determined during data binding)
            for (int i = 1; i <= 9; i++) {
                e.Row.Cells[i].Visible = (HolesPlayedID == 1 || HolesPlayedID == 3);
                e.Row.Cells[i + 10].Visible = (HolesPlayedID == 2 || HolesPlayedID == 3);
            }
            e.Row.Cells[10].Visible = (HolesPlayedID == 1);
            e.Row.Cells[20].Visible = (HolesPlayedID == 2);
            e.Row.Cells[21].Visible = (HolesPlayedID == 3);

            // calculate totals
            if (e.Row.RowType == DataControlRowType.DataRow) {
                int In = 0, Out = 0;
                for (int i = 1; i <= 9; i++) {
                    Out += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    In += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, (i + 9).ToString()));
                }
                e.Row.Cells[10].Text = (Out != 0) ? Out.ToString("n0") : "";
                e.Row.Cells[20].Text = (In != 0) ? In.ToString("n0") : "";
                e.Row.Cells[21].Text = ((Out + In) != 0) ? (Out + In).ToString("n0") : "";

                // right-justify the label for Par
                if (e.Row.Cells[0].Text == "Par") {
                    for (int i = 0; i <= 21; i++) {
                        e.Row.Cells[i].CssClass = "boldright";
                    }
                }
            }
        }
    }
}