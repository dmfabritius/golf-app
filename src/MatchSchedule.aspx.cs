using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class MatchSchedule : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void ddStates_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["StateID"] != -1) {
                    ddStates.SelectedValue = Session["StateID"].ToString();
                    ddDistricts.DataBind();
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            ddLeagues.DataBind();
            ddSchools.DataBind();
            ddGender.DataBind();
            GridView1.DataBind();
        }

        protected void ddDistricts_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["DistrictID"] != -1) {
                    ddDistricts.SelectedValue = Session["DistrictID"].ToString();
                    ddLeagues.DataBind();
                }
            }
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddSchools.DataBind();
            ddGender.DataBind();
            GridView1.DataBind();
        }

        protected void ddLeagues_DataBound(object sender, EventArgs e) {
            if (!IsPostBack) {
                if ((int)Session["LeagueID"] != -1) {
                    ddLeagues.SelectedValue = Session["LeagueID"].ToString();
                    ddSchools.DataBind();
                }
            }
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddSchools.DataBind();
            ddGender.DataBind();
            GridView1.DataBind();
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            ddGender.DataBind();
            GridView1.DataBind();
        }

        protected void ddGender_SelectedIndexChanged(object sender, EventArgs e) {
            GridView1.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            GridView1.DataBind();
        }

        private string prevDate = "";
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (((DataRowView)e.Row.DataItem)["MatchDate"].ToString() != prevDate) {
                    e.Row.CssClass = "sep";
                    e.Row.Cells[0].CssClass = "extratop";
                    prevDate = ((DataRowView)e.Row.DataItem)["MatchDate"].ToString();
                }
            }
        }

        private string prevTeamType = "";
        protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (((DataRowView)e.Row.DataItem)["TeamType"].ToString() != prevDate) {
                    e.Row.CssClass = "sep";
                    e.Row.Cells[0].CssClass = "extratop";
                    prevDate = ((DataRowView)e.Row.DataItem)["TeamType"].ToString();
                }
            }
        }
    }
}
        