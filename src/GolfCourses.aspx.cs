using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {
    public partial class GolfCourses : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void gvCourseMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvCourseMaint.EditIndex == -1) ? 0 : 1;

            // only show a list of schools using a tee when one is being edited
            gvCourseSchools.Visible = (gvCourseMaint.EditIndex != -1);

            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate)) {
                    sqlCourseSchools.SelectParameters["GolfCourseID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfCourseID"].ToString();
                    gvCourseSchools.DataBind();
                    gvCourseSchools.Visible = true;
                }
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlGolfCourseMaint.Insert();
        }

        protected void sqlGolfCourseInserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                //lblPopup.Text = e.Exception.Message + " : " + e.Exception.InnerException;
                //popupErrorMsg.Show();
                e.ExceptionHandled = true;
            }
            else {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                sqlConn.Open();

                // use the new golf course ID to create the associated holes
                SqlCommand sqlCmd = new SqlCommand();
                sqlCmd.Connection = sqlConn;
                sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = ((DbCommand)e.Command).Parameters["@GolfCourseID"].Value.ToString();
                sqlCmd.Parameters.Add("@HoleNumber", SqlDbType.Int).Value = 0;

                for (int i = 1; i <= 18; i++) {
                    sqlCmd.CommandText = "INSERT INTO GolfCourseHoles (GolfCourseID, HoleNumber) VALUES (@GolfCourseID, @HoleNumber)";
                    sqlCmd.Parameters["@HoleNumber"].Value = i;
                    sqlCmd.ExecuteNonQuery();
                }
                sqlConn.Close();
            }
        }

        protected void sqlGolfCourseMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "CourseDeleteAlert" + UniqueID,
                    "alert('This golf course cannot be deleted until no schools are using it as their default course, and all associated tees and pratice & match rounds are deleted.');", true);
                e.ExceptionHandled = true;
            }
        }

        protected void gvCourseSchools_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.Footer) {
                // make the left-most footer cell span the whole grid
                int cols = e.Row.Cells.Count;
                for (int i = 1; i < cols; i++) {
                    e.Row.Cells.RemoveAt(1);
                    e.Row.Cells[0].ColumnSpan = cols;
                }
            }
        }
    }
}