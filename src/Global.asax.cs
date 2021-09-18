using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace Golf
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        void Session_Start(object sender, EventArgs e) {
            // Code that runs on session startup
            // Note: The Session_Start event is raised only when the sessionstate mode is set to InProc in the Web.config file.
            Session.Timeout = 60;
            string x = Request.UserHostAddress;

            if (Request.UserHostAddress == "127.0.0.1" || Request.UserHostAddress == "::1") {
                Session["StateID"] = 1;
                Session["DistrictID"] = 3;
                Session["LeagueID"] = 21; // SPS 4A
                Session["SchoolID"] = 0;
                Session["Name"] = "wa-dist3-legSPS4A";
            }
            else {
                Session["StateID"] = -1;
                Session["DistrictID"] = -1;
                Session["LeagueID"] = -1;
                Session["SchoolID"] = -1;
                Session["Name"] = "Public";
            }
        }
    }
}