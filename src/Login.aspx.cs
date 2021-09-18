using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf {

    public partial class Login : Page {

        protected void Page_Load(object sender, EventArgs e) {
            // Session variables are initialized by the Global.Session_Startup in Global.asax.cs
            if ((int)Session["SchoolID"] == -1) {
                    Username.Focus();
            }
            else {
                // When a user logs out, they return to this page, so hide the logout link and reset the session variables
                ((LinkButton)Master.FindControl("LoginLink")).Visible = true;
                ((LinkButton)Master.FindControl("LoginUser")).Visible = false;
                ((LinkButton)Master.FindControl("LogoutLink")).Visible = false;
                Session["StateID"] = -1;
                Session["DistrictID"] = -1;
                Session["LeagueID"] = -1;
                Session["SchoolID"] = -1;
                Session["Name"] = "";
                //HttpCookie cookie = new HttpCookie("GolfAppData");
                //cookie.Value = "empty";
                //cookie.Expires = DateTime.Now.AddHours(1);
                //Response.Cookies.Add(cookie);
            }
        }

        protected void LogIn(object sender, EventArgs e) {
            if (IsValid) {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["GolfDb"].ToString());
                sqlConn.Open();
                SqlCommand sqlCmd = new SqlCommand("SELECT * FROM Credentials WHERE Username=@Username AND Password=@Password", sqlConn);
                sqlCmd.Parameters.Add("@Username", SqlDbType.NVarChar).Value = Username.Text;
                sqlCmd.Parameters.Add("@Password", SqlDbType.NVarChar).Value = Password.Text;
                SqlDataAdapter saCreds = new SqlDataAdapter(sqlCmd);
                DataTable tblLogins = new DataTable();
                saCreds.Fill(tblLogins);
                sqlConn.Close();
                if (tblLogins.Rows.Count == 0) {
                    FailureText.Text = "Username and/or password not found. Please re-enter your credentials.";
                    ErrorMessage.Visible = true;
                    Password.Focus();
                }
                else {
                    Session["StateID"] = (int)tblLogins.Rows[0]["StateID"];       // the global admin will have State = 0
                    Session["DistrictID"] = (int)tblLogins.Rows[0]["DistrictID"]; // state directors will have District = 0
                    Session["LeagueID"] = (int)tblLogins.Rows[0]["LeagueID"];     // district directors will have League = 0
                    Session["SchoolID"] = (int)tblLogins.Rows[0]["SchoolID"];     // league directors will have School = 0
                    Session["Name"] = tblLogins.Rows[0]["Name"].ToString();

                    // Each time someone successfully logs in, check to see if there's any system maintenance that needs doing
                    //SystemMaintenance();

                    Response.Redirect("Practices");
                }
            }
        }
    }
}