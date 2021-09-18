using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Districts : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // you have to be at least a district director to view this page
            if ((int)Session["LeagueID"] != 0) Server.Transfer("default.aspx");

            // Restrict access based on what user is logged in (see Login.aspx for more info)
            if (!IsPostBack) {
                sqlViewStateList.SelectParameters["StateID"].DefaultValue = Session["StateID"].ToString();
                ddStates.DataBind();
                pnlSelState.Visible = ((int)Session["StateID"] == 0);

                sqlDistrictMaint.SelectParameters["DistrictID"].DefaultValue = Session["DistrictID"].ToString();
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            gvDistrictMaint.DataBind();
        }

        protected void gvDistrictMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvDistrictMaint.EditIndex == -1) ? 0 : 1;
        }

        protected void gvDistrictMaint_RowUpdating(object sender, GridViewUpdateEventArgs e) {
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
                    ScriptManager.RegisterStartupScript(this, GetType(), "DistrictDupUserAlert" + UniqueID,
                        "alert('The username already exists. Please enter a different username.');", true);
                    e.Cancel = true;
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlDistrictMaint.Insert();
        }

        protected void sqlDistrictMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "DistrictDeleteAlert" + UniqueID,
                    "alert('This district cannot be deleted until all associated leagues are deleted.');", true);
                e.ExceptionHandled = true;
            }
        }
    }
}