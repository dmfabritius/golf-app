using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Golf
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            /*
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }
            Page.PreLoad += master_Page_PreLoad;
            */
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            /*
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
            */
        }

        protected string Username() {
            return Session["Name"].ToString();
        }

        protected void Page_Load(object sender, EventArgs e) {
            // All Session variables are initialized by the Global.Session_Startup in Global.asax.cs
            LoginLink.Visible = ((int)Session["SchoolID"] == -1);
            LoginUser.Visible = LogoutLink.Visible = ((int)Session["SchoolID"] != -1);

            // right now, I'm just making things not visible if you can't edit them
            // -- it would be possible instead to leave them visible and then restrict to read-only access on the individual pages
            OrganizationSubMenu.Visible = ((int)Session["SchoolID"] != -1);
            StatesLink.Visible = ((int)Session["DistrictID"] == 0);
            DistrictsLink.Visible = ((int)Session["LeagueID"] == 0);
            LeaguesLink.Visible = ((int)Session["SchoolID"] == 0);

            PracticesLink.Visible = ((int)Session["SchoolID"] != -1);

            MatchesLink.Visible = ((int)Session["SchoolID"] != -1);
            ReadOnlyMatchesLink.Visible = ((int)Session["SchoolID"] == -1);
            MatchScoreEntrySimpleLink.Visible = MatchScoreEntryDetailedLink.Visible = ((int)Session["SchoolID"] != -1);
        }
    }
}