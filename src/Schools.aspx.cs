using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Schools : System.Web.UI.Page {

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
            fvSchoolMaint.DataBind();
        }

        protected void ddDistricts_SelectedIndexChanged(object sender, EventArgs e) {
            ddLeagues.DataBind();
            ddSchools.DataBind();
            fvSchoolMaint.DataBind();
        }

        protected void ddLeagues_SelectedIndexChanged(object sender, EventArgs e) {
            ddSchools.DataBind();
            fvSchoolMaint.DataBind();
        }

        protected void ddSchools_DataBound(object sender, EventArgs e) {
            if (ddSchools.Items.Count == 0) {
                ListItem NoSchools = new ListItem("(No schools)", "0");
                ddSchools.Items.Add(NoSchools);
            }
        }

        protected void ddSchools_SelectedIndexChanged(object sender, EventArgs e) {
            fvSchoolMaint.DataBind();
        }

        protected void ddGolfCourseTees_DataBinding(object sender, EventArgs e) {
            if (fvSchoolMaint.DataItem != null) {
                sqlGolfCourseTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)fvSchoolMaint.DataItem)["DefaultGolfCourseID"].ToString();
            }
        }

        protected void fvSchoolDataBound(object sender, EventArgs e) {
            // Once data has been bound to the form view, sync up the drop down list for the cascaded drop down list
            if (fvSchoolMaint.CurrentMode == FormViewMode.Edit) {
                ((DropDownList)fvSchoolMaint.FindControl("ddGolfCourseTees")).SelectedValue = ((DataRowView)fvSchoolMaint.DataItem)["DefaultGolfCourseTeeID"].ToString();
                ((DropDownList)fvSchoolMaint.FindControl("ddSchoolLeagues")).Enabled = ((int)Session["LeagueID"] == 0);
            }
        }

        protected void fvSchoolItemUpdating(object sender, FormViewUpdateEventArgs e) {
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
                    ScriptManager.RegisterStartupScript(this, GetType(), "SchoolDupUserAlert" + UniqueID,
                        "alert('The username already exists. Please enter a different username.');", true);
                    e.Cancel = true;
                }
            }
            // When updating the record, use the values from the cascaded drop down list for the tees
            sqlSchoolMaint.UpdateParameters["DefaultGolfCourseTeeID"].DefaultValue = ((DropDownList)fvSchoolMaint.FindControl("ddGolfCourseTees")).SelectedValue;
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlSchoolMaint.Insert();
        }

        protected void sqlSchoolInserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                //lblPopup.Text = e.Exception.Message + "\n" + e.Exception.InnerException;
                //popupErrorMsg.Show();
                e.ExceptionHandled = true;
            }
            else {
                // re-bind schools dropdown to include newly added school and select it
                ddSchools.DataBind();
                ddSchools.SelectedValue = ((DbCommand)e.Command).Parameters["@SchoolID"].Value.ToString();
            }
        }

        protected void sqlSchoolUpdated(object sender, SqlDataSourceStatusEventArgs e) {
            // in case the school name is changed, reload the list of schools
            string SchoolID = ddSchools.SelectedValue;
            ddSchools.DataBind();
            try {
                ddSchools.SelectedValue = SchoolID;
            }
            catch(Exception ex) {
                // if we changed the school's league, we won't be able to re-select it after updating
            }
        }

        protected void sqlSchoolDeleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "SchoolDeleteAlert" + UniqueID,
                    "alert('This school cannot be deleted until all associated players are deleted.');", true);
                e.ExceptionHandled = true;
            }
            else {
                ddSchools.DataBind();
                fvSchoolMaint.DataBind();
            }
        }

        protected void ddGolfCourses_SelectedIndexChanged(object sender, EventArgs e) {
            sqlGolfCourseTeeList.SelectParameters["GolfCourseID"].DefaultValue = ((DropDownList)sender).SelectedValue;
            ((DropDownList)fvSchoolMaint.FindControl("ddGolfCourseTees")).DataBind();
        }
    }
}