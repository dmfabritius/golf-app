using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Leaderboard : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            SqlCommand sqlCmd = new SqlCommand();

            if (!IsPostBack) {
                // check to see if a specific organization was requested as part of the URL; and if so, verify that it exists
                string StateID = Request.QueryString["state"];
                string DistrictID = Request.QueryString["district"];
                string LeagueID = Request.QueryString["league"];
                string SchoolID = Request.QueryString["school"];
                if (SchoolID != null) {
                    sqlCmd.Parameters.Add("@SchoolID", SqlDbType.Int).Value = SchoolID;
                    sqlCmd.CommandText =
                        "SELECT StateID, D.DistrictID, L.LeagueID, SchoolID " +
                        "FROM Schools S" +
                        " INNER JOIN Leagues L ON S.LeagueID = L.LeagueID" +
                        " INNER JOIN Districts D ON L.DistrictID = D.DistrictID " +
                        "WHERE SchoolID = @SchoolID";
                } else if (LeagueID != null) {
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
                        CreateCookie("school", tblDefaults.Rows[0]["SchoolID"].ToString());
                        // reload page so all the dropdown lists bind correctly
                        Response.Redirect("Leaderboard");
                    }
                }
            }
        }

        protected void ddStates_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["StateID"] != -1 && ddStates.SelectedValue != Session["StateID"].ToString()) {
                    ddStates.SelectedValue = Session["StateID"].ToString();
                    ddDistricts.DataBind();
                }
                if (Request.Cookies["state"] != null && ddStates.SelectedValue != Request.Cookies["state"].Value) {
                    ddStates.SelectedValue = Request.Cookies["state"].Value;
                    ddDistricts.DataBind();
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            //ddLeagues.DataBind();
            //ddSchools.DataBind();
            //ddGender.DataBind();
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void ddDistricts_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["DistrictID"] != -1 && ddDistricts.SelectedValue != Session["DistrictID"].ToString()) {
                    ddDistricts.SelectedValue = Session["DistrictID"].ToString();
                    ddLeagues.DataBind();
                }
                if (Request.Cookies["district"] != null && ddDistricts.SelectedValue != Request.Cookies["district"].Value) {
                    ddDistricts.SelectedValue = Request.Cookies["district"].Value;
                    ddLeagues.DataBind();
                }
            }
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            //ddSchools.DataBind();
            //ddGender.DataBind();
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void ddLeagues_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["LeagueID"] != -1 && ddLeagues.SelectedValue != Session["LeagueID"].ToString()) {
                    ddLeagues.SelectedValue = Session["LeagueID"].ToString();
                    ddSchools.DataBind();
                }
                if (Request.Cookies["league"] != null && ddLeagues.SelectedValue != Request.Cookies["league"].Value) {
                    ddLeagues.SelectedValue = Request.Cookies["league"].Value;
                    ddSchools.DataBind();
                }
            }
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddSchools.DataBind();
            //ddGender.DataBind();
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void ddSchools_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                /*
                if ((int)Session["SchoolID"] != -1) {
                    ddLeagues.SelectedValue = Session["SchoolID"].ToString();
                    ddSchools.DataBind();
                }
                */
                if (Request.Cookies["school"] != null && ddSchools.SelectedValue != Request.Cookies["school"].Value) {
                    ddSchools.SelectedValue = Request.Cookies["school"].Value;
                }
            }
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            //ddGender.DataBind();
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void ddGender_SelectedIndexChanged(object sender, EventArgs e) {
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            GridView1.DataBind();
            GridView2.DataBind();
            GridView3.DataBind();
            GridView4.DataBind();
        }

        protected void CreateCookie(string name, string value) {
            HttpCookie cookie = new HttpCookie(name);
            cookie.Value = value;
            cookie.Expires = DateTime.Now.AddYears(1);
            Response.Cookies.Add(cookie);
        }
    }
}