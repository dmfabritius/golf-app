using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace Golf {

    public partial class MaintGolfCourseHoles : Page {

        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void gvCourseMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the edit button for other rows when in edit mode
            Session["InEditMode"] = (gvCourseMaint.EditIndex == -1) ? 0 : 1;

            if (e.Row.RowType == DataControlRowType.DataRow) {
                int In = 0, Out = 0;
                for (int i = 1; i <= 9; i++) {
                    Out += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    In += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, (i+9).ToString()));
                }
                e.Row.Cells[11].Text = Out.ToString("n0");
                e.Row.Cells[21].Text = In.ToString("n0");
                e.Row.Cells[22].Text = (Out + In).ToString("n0");
            }
        }

        protected void gvCourseRowUpdating(object sender, GridViewUpdateEventArgs e) {
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();

            // determine what is being updated: Par, Men's handicap, or Women's handicap
            string strField = e.OldValues[0].ToString(); // by default, we'll assume it's Par
            if (strField == "Men's") strField = "HandicapMen";
            else if (strField == "Women's") strField = "HandicapWomen";

            string strSQL = "UPDATE GolfCourseHoles SET " + strField + "=@Value WHERE GolfCourseID=@GolfCourseID AND HoleNumber=@HoleNumber";
            SqlCommand sqlCmd = new SqlCommand(strSQL, sqlConn);
            sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = ddCourses.SelectedValue;
            sqlCmd.Parameters.Add("@HoleNumber", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Value", SqlDbType.Int);

            // update each hole for this course (NewValues index 0 thru 17 has values for holes 1 thru 18)
            for (int i = 0; i < 18; i++) {
                sqlCmd.Parameters["@HoleNumber"].Value = i + 1;
                sqlCmd.Parameters["@Value"].Value = e.NewValues[i];
                sqlCmd.ExecuteNonQuery();
            }
            sqlConn.Close();
        }

        protected void gvCourseYardageMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // set flag to hide the add button when in edit mode
            Session["InEditMode"] = (gvCourseYardageMaint.EditIndex == -1) ? 0 : 1;

            // only show a list of schools using a tee when one is being edited
            gvTeeSchools.Visible = (gvCourseYardageMaint.EditIndex != -1);

            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate)) {
                    sqlTeeSchools.SelectParameters["GolfCourseTeeID"].DefaultValue = ((DataRowView)e.Row.DataItem)["GolfCourseTeeID"].ToString();
                    gvTeeSchools.DataBind();
                    gvTeeSchools.Visible = true;
                }
                int In = 0, Out = 0;
                for (int i = 1; i <= 9; i++) {
                    Out += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, i.ToString()));
                    In += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, (i + 9).ToString()));
                }
                e.Row.Cells[11].Text = Out.ToString("n0");
                e.Row.Cells[21].Text = In.ToString("n0");
                e.Row.Cells[22].Text = (Out + In).ToString("n0");
            }
        }

        protected void gvCourseYardageRowUpdating(object sender, GridViewUpdateEventArgs e) {
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
            sqlConn.Open();
            SqlCommand sqlCmd = new SqlCommand();
            sqlCmd.Connection = sqlConn;

            // update the name of the tee and the active status in the parent table
            sqlCmd.CommandText = "UPDATE GolfCourseTees SET TeeName=@TeeName, IsActive=@IsActive WHERE GolfCourseTeeID=@GolfCourseTeeID";
            sqlCmd.Parameters.Add("@GolfCourseTeeID", SqlDbType.VarChar).Value = gvCourseYardageMaint.DataKeys[gvCourseYardageMaint.EditIndex].Value;
            sqlCmd.Parameters.Add("@TeeName", SqlDbType.VarChar).Value = e.NewValues[0];
            sqlCmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = e.NewValues[19];
            sqlCmd.ExecuteNonQuery();

            // for any of the hole yardages that were changed, update them in the child table
            sqlCmd.CommandText =
                "UPDATE Y" +
                " SET Y.Yardage=@Value " +
                "FROM HoleYardages Y" +
                " INNER JOIN GolfCourseHoles H ON H.GolfCourseHoleID=Y.GolfCourseHoleID " +
                "WHERE GolfCourseTeeID=@GolfCourseTeeID" +
                " AND H.HoleNumber=@HoleNumber";
            sqlCmd.Parameters.Clear();
            sqlCmd.Parameters.Add("@GolfCourseTeeID", SqlDbType.Int).Value = gvCourseYardageMaint.DataKeys[gvCourseYardageMaint.EditIndex].Value;
            sqlCmd.Parameters.Add("@HoleNumber", SqlDbType.Int);
            sqlCmd.Parameters.Add("@Value", SqlDbType.Int);

            // update each hole for this course (index 0 of NewValues contains the tee name, so we want values 1 thru 18)
            for (int i = 1; i <= 18; i++) {
                sqlCmd.Parameters["@HoleNumber"].Value = i;
                sqlCmd.Parameters["@Value"].Value = e.NewValues[i];
                sqlCmd.ExecuteNonQuery();
            }
            sqlConn.Close();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            sqlCourseYardageMaint.Insert();
        }

        protected void sqlCourseYardageInserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                //lblPopup.Text = e.Exception.Message + " : " + e.Exception.InnerException;
                //popupErrorMsg.Show();
                e.ExceptionHandled = true;
            }
            else {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                sqlConn.Open();

                // fill a table with the GolfCourseHoleIDs for the currently selected golf course
                SqlCommand sqlCmd = new SqlCommand("SELECT GolfCourseHoleID FROM GolfCourseHoles WHERE GolfCourseID=@GolfCourseID", sqlConn);
                sqlCmd.Parameters.Add("@GolfCourseID", SqlDbType.Int).Value = ddCourses.SelectedValue;
                SqlDataAdapter sqlAdpt = new SqlDataAdapter(sqlCmd);
                DataTable tblHoles = new DataTable();
                sqlAdpt.Fill(tblHoles);

                // loop thru all the holes for the new tee to insert a default value of zero yards
                sqlCmd.Parameters.Clear();
                sqlCmd.CommandText = "INSERT INTO HoleYardages (GolfCourseHoleID, GolfCourseTeeID, Yardage) VALUES (@GolfCourseHoleID, @GolfCourseTeeID, 0)";
                DbCommand cmdInserted = e.Command; // results from the command to insert a new Golf Course Tee, used to reference the new GolfCourseTeeID
                sqlCmd.Parameters.Add("@GolfCourseTeeID", SqlDbType.Int).Value = cmdInserted.Parameters["@GolfCourseTeeID"].Value.ToString();
                sqlCmd.Parameters.Add("@GolfCourseHoleID", SqlDbType.Int).Value = 0;
                foreach (DataRow r in tblHoles.Rows) {
                    sqlCmd.Parameters["@GolfCourseHoleID"].Value = r["GolfCourseHoleID"];
                    sqlCmd.ExecuteNonQuery();
                }
                sqlConn.Close();
            }
        }

        protected void sqlCourseYardageMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                ScriptManager.RegisterStartupScript(this, GetType(), "TeeDeleteAlert" + UniqueID,
                    "alert('This tee cannot be deleted until no schools are using it as their default tee, and all associated practice & match rounds are deleted.');", true);
                e.ExceptionHandled = true;
            }
        }

        protected void gvTeeSchools_RowDataBound(object sender, GridViewRowEventArgs e) {
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