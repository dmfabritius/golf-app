using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Players : System.Web.UI.Page {

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
            gvPlayerMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddSchools.DataBind();
            gvPlayerMaint.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddSchools.DataBind();
            gvPlayerMaint.DataBind();
        }

        protected void ddSchools_DataBound(object sender, EventArgs e) {
            if (ddSchools.Items.Count == 0) {
                ListItem NoSchools = new ListItem("(No schools)", "0");
                ddSchools.Items.Add(NoSchools);
            }
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            gvPlayerMaint.DataBind();
        }

        protected void ddGenders_SelectedIndexChanged(object sender, EventArgs e) {
            gvPlayerMaint.DataBind();
        }

        protected void ddActives_SelectedIndexChanged(object sender, EventArgs e) {
            gvPlayerMaint.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            // clear gender filter since new players don't have a gender assigned yet and would be hidden from view
            ddViewGenders.SelectedIndex = 0;
            sqlPlayerMaint.Insert();
        }

        protected void gvPlayerRowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvPlayerMaint.EditIndex == -1) ? 0 : 1;
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate) | e.Row.RowState == DataControlRowState.Edit) {
                    // Populate the list of graduating classes based on the current date
                    DropDownList dd = (DropDownList)e.Row.FindControl("ddGradYear");
                    for (int i = 1; i < 7; i++) dd.Items.Add((DateTime.Now.Year + i - ((System.DateTime.Now.Month < 8) ? 1 : 0)).ToString());
                    dd.SelectedValue = ((DataRowView)e.Row.DataItem)["GraduationYear"].ToString();
                }
                else {
                    // when editing a row, hide the control buttons for the other rows
                    e.Row.FindControl("btnEdit").Visible = e.Row.FindControl("btnDelete").Visible = (gvPlayerMaint.EditIndex == -1);
                }
            }
        }

        protected void gvPlayerRowUpdating(object sender, GridViewUpdateEventArgs e) {
            // When updating the record, use the value from the drop down list of graduation years
            sqlPlayerMaint.UpdateParameters["GraduationYear"].DefaultValue = ((DropDownList)gvPlayerMaint.Rows[e.RowIndex].FindControl("ddGradYear")).SelectedValue;

            // Make sure player names don't have leading spaces and that the default placeholder "(new)" has been removed
            e.NewValues["PlayerName"] = e.NewValues["PlayerName"].ToString().Replace("(new)","").Trim();
        }

        protected void sqlPlayerInserting(object sender, SqlDataSourceCommandEventArgs e) {
            sqlPlayerMaint.InsertParameters["GraduationYear"].DefaultValue = (DateTime.Now.Year + 1 - ((System.DateTime.Now.Month < 8) ? 1 : 0)).ToString();
        }

        protected void sqlPlayerMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "PlayerDeleteAlert" + UniqueID,
                    "alert('This player cannot be deleted until all associated practice and match rounds are deleted.');", true);
                e.ExceptionHandled = true;
            }
        }
    }
}