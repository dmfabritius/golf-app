using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Leagues : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // you have to be at least a league director to view this page
            if ((int)Session["SchoolID"] != 0) Server.Transfer("default.aspx");

            // Restrict access based on what user is logged in (see Login.aspx for more info)
            if (!IsPostBack) {
                sqlViewStateList.SelectParameters["StateID"].DefaultValue = Session["StateID"].ToString();
                ddStates.DataBind();
                pnlSelState.Visible = ((int)Session["StateID"] == 0);

                sqlViewDistrictList.SelectParameters["DistrictID"].DefaultValue = Session["DistrictID"].ToString();
                ddDistricts.DataBind();
                pnlSelDistrict.Visible = ((int)Session["DistrictID"] == 0);

                sqlLeagueMaint.SelectParameters["LeagueID"].DefaultValue = Session["LeagueID"].ToString();
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddDistricts.DataBind();
            gvLeagueMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            gvLeagueMaint.DataBind();
        }

        protected void gvLeagueMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvLeagueMaint.EditIndex == -1) ? 0 : 1;

            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState != DataControlRowState.Edit && e.Row.RowState != (DataControlRowState.Edit | DataControlRowState.Alternate)) {
                    // when editing a row, hide the control buttons for the other rows
                    e.Row.FindControl("btnEdit").Visible = e.Row.FindControl("btnDelete").Visible = (gvLeagueMaint.EditIndex == -1);
                }
            }
        }

        protected void gvLeagueMaint_RowUpdating(object sender, GridViewUpdateEventArgs e) {
            if (e.NewValues["Username"] == null) {
                e.Cancel = true;
                return;
            }
            if (e.OldValues["Username"] == null || e.NewValues["Username"].ToString() != e.OldValues["Username"].ToString()) {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                sqlConn.Open();
                SqlCommand sqlCmd = new SqlCommand("SELECT Username FROM Usernames WHERE Username=@Username", sqlConn);
                sqlCmd.Parameters.Add("@Username", SqlDbType.NVarChar).Value = e.NewValues["Username"].ToString();
                if (sqlCmd.ExecuteScalar() != null) {
                    ScriptManager.RegisterStartupScript(this, GetType(), "LeagueDupUserAlert" + UniqueID,
                        "alert('The username already exists. Please enter a different username.');", true);
                    e.Cancel = true;
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlLeagueMaint.Insert();
        }

        protected void sqlLeagueMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "LeagueDeleteAlert" + UniqueID,
                    "alert('This league cannot be deleted until all associated schools are deleted.');", true);
                e.ExceptionHandled = true;
            }
        }
    }
}