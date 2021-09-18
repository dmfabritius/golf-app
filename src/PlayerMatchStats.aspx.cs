using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class PlayerMatchStats : System.Web.UI.Page {

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
            gvPlayerStats.DataBind();
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
            gvPlayerStats.DataBind();
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
            gvPlayerStats.DataBind();
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            ddGender.DataBind();
            gvPlayerStats.DataBind();
        }

        protected void ddGender_SelectedIndexChanged(object sender, EventArgs e) {
            gvPlayerStats.DataBind();
        }

        protected void ddYears_SelectedIndexChanged(object sender, EventArgs e) {
            gvPlayerStats.DataBind();
        }

        protected void gvPlayerStats_RowDataBound(object sender, GridViewRowEventArgs e) {
            e.Row.Cells[2].Visible = (ddSchools.SelectedValue.ToString() == "0");
            e.Row.Cells[3].Visible = (ddLeagues.SelectedValue.ToString() == "0");
            e.Row.Cells[4].Visible = (ddDistricts.SelectedValue.ToString() == "0");
            e.Row.Cells[5].Visible = (ddStates.SelectedValue.ToString() == "0");

            if (e.Row.RowType == DataControlRowType.DataRow) {
                // if a row hasn't been selected, then select the first row
                if (gvPlayerStats.SelectedIndex == -1) gvPlayerStats.SelectedIndex = 0;
                // bind the details table to the data from the selected row
                if (e.Row.RowIndex == gvPlayerStats.SelectedIndex) {
                    if (Session["InfoOption"] == null) Session["InfoOption"] = "Scores";
                    sqlStatDetails.SelectParameters["PlayerID"].DefaultValue =  ((DataRowView)e.Row.DataItem)["PlayerID"].ToString();
                    sqlStatDetails.SelectParameters["Info"].DefaultValue = Session["InfoOption"].ToString();
                    gvStatDetails.DataBind();
                    e.Row.BackColor = ColorTranslator.FromHtml("#F7E7CA");
                }
            }
        }

        protected void gvPlayerStats_SelectedIndexChanged(object sender, EventArgs e) {
            foreach (GridViewRow row in gvPlayerStats.Rows) {
                // turn all the rows back to their normal color
                row.BackColor = (row.RowState == DataControlRowState.Alternate) ? ColorTranslator.FromHtml("#FFFFFF") : ColorTranslator.FromHtml("#E3EAEB");
                // turn the selected row a different color
                row.BackColor = (row.RowIndex == gvPlayerStats.SelectedIndex) ? ColorTranslator.FromHtml("#F7E7CA") : row.BackColor;
            }
            sqlStatDetails.SelectParameters["PlayerID"].DefaultValue = gvPlayerStats.DataKeys[gvPlayerStats.SelectedIndex].Value.ToString();
            gvStatDetails.DataBind();
        }

        protected void gvStatDetails_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                // calc totals
                int In = 0, Out = 0;
                for (int i = 1; i <= 9; i++) {
                    Out += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    In += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, (i + 9).ToString()));
                }
                e.Row.Cells[10].Text = (Out != 0) ? Out.ToString("n0") : "";
                e.Row.Cells[20].Text = (In != 0) ? In.ToString("n0") : "";
                // since the stats for this page are limited to 9-hole rounds, we don't need the 18-hole total
                //e.Row.Cells[21].Text = ((Out + In) != 0) ? (Out + In).ToString("n0") : "";
            }

            if (e.Row.RowType == DataControlRowType.Footer) {
                // make the left-most footer cell span the whole grid
                int cols = e.Row.Cells.Count;
                for (int i = 1; i < cols; i++) {
                    e.Row.Cells.RemoveAt(1);
                    e.Row.Cells[0].ColumnSpan = cols;
                }
                // select the desired radio button
                foreach (ListItem i in ((RadioButtonList)e.Row.FindControl("rblInfoOptions")).Items) {
                    i.Selected = (i.Text == Session["InfoOption"].ToString());
                }
            }
        }

        protected void rblInfoOptions_SelectedIndexChanged(object sender, EventArgs e) {
            foreach (ListItem i in ((RadioButtonList)sender).Items) {
                if (i.Selected) {
                    Session["InfoOption"] = i.Text;
                    sqlStatDetails.SelectParameters["Info"].DefaultValue = i.Text;
                }
            }
            gvStatDetails.DataBind();
        }
    }
}