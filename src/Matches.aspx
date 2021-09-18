<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Matches.aspx.cs" Inherits="Golf.Matches" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        td, th {padding:2px}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) {
            $(".picker").datepicker();
        });
    </script>

    <div class="row">
        <div class="col-sm-8">
            <h3>Match Maintenance</h3>
        </div>
        <div class="col-sm-4 text-right">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <p style="padding-top:30px"><img src="img/activity.gif" alt="activity" /> accessing database...</p>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>

    <asp:Panel ID="pnlSelState" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddStates" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddStates">Select a state:</label>
            <asp:DropDownList ID="ddStates" runat="server" AutoPostBack="True" CssClass="form-control mini col-sm-10"
                DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID" OnSelectedIndexChanged="ddStates_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelDistrict" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddDistricts" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddDistricts">Select a district:</label>
            <asp:DropDownList ID="ddDistricts" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewDistrictList" DataTextField="DistrictName" DataValueField="DistrictID" OnSelectedIndexChanged="ddDistricts_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelLeague" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddLeagues" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddLeagues">Select a league:</label>
            <asp:DropDownList ID="ddLeagues" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewLeagueList" DataTextField="LeagueName" DataValueField="LeagueID" OnSelectedIndexChanged="ddLeagues_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelYear" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddYears" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddYears">Select a year:</label>
            <asp:DropDownList ID="ddYears" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewYearList" DataTextField="YearText" DataValueField="SchoolYear" OnSelectedIndexChanged="ddYears_SelectedIndexChanged"/>
    </ContentTemplate></asp:UpdatePanel></asp:Panel>
    <asp:Panel ID="pnlSelMatch" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddMatches" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddMatches">Select a match:</label>
            <asp:DropDownList ID="ddMatches" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewMatchList" DataTextField="MatchName" DataValueField="MatchID" OnDataBound="ddMatches_DataBound" OnSelectedIndexChanged="ddMatches_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <asp:UpdatePanel ID="updMatchMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlMatchMaint" runat="server">
        <asp:FormView ID="fvMatchMaint" runat="server" DataKeyNames="MatchID" DataSourceID="sqlMatchMaint" ForeColor="#333333"
            OnDataBound="fvMatchDataBound" OnItemUpdating="fvMatchItemUpdating" OnItemUpdated="fvMatchMaint_ItemUpdated">
            <RowStyle BackColor="#1C5E55" Font-Bold="False" />
            <EditRowStyle BackColor="#1C5E55" Font-Bold="False" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add match" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" Visible='<%# (int)Session["SchoolID"] != -1 %>' />
            </EmptyDataTemplate>
            <ItemTemplate>
                <table style="background-color:white">
                    <tr><td style="width:140px">Description:</td><td class="data" style="width:450px"><%# Eval("MatchName") %></td></tr>
                    <tr class="altrow"><td>Team type:</td><td class="data"><%# Eval("MatchGender").ToString().Replace("M","Boys").Replace("F","Girls").Replace("A","Co-ed") %></td></tr>
                    <tr><td>Date:</td><td class="data"><%# Eval("MatchDate","{0:d}") %></td></tr>
                    <tr class="altrow"><td>Time:</td><td class="data"><%# Eval("MatchTime","{0:t}") %></td></tr>
                    <tr><td>Official match:</td><td class="data"><%# ((bool)Eval("IsOfficial"))? "Yes, league match" : "No, non-league match" %></td></tr>
                    <tr class="altrow"><td>Home school:</td><td class="data"><%# Eval("HomeSchoolName") %></td></tr>
                    <tr><td>Away school:</td><td class="data"><%# Eval("AwaySchoolName") %></td></tr>
                    <tr class="altrow"><td>Golf course:</td><td class="data"><%# Eval("GolfCourseName") %></td></tr>
                    <tr><td>Varsity tee:</td><td class="data"><%# Eval("VarsityTeeName") %></td></tr>
                    <tr class="altrow"><td>JV tee:</td><td class="data"><%# Eval("JVTeeName") %></td></tr>
                    <tr><td>Holes played:</td><td class="data"><%# Eval("HolesPlayedName") %></td></tr>
                </table>
                <div style="padding:5px 0">
                        &nbsp; <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="text-white hover-white" Visible='<%# (int)Session["SchoolID"] != -1 %>'><span class="glyphicon glyphicon-edit"></span> Edit</asp:LinkButton>
                        &nbsp; <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="text-white hover-white" Visible='<%# (int)Session["SchoolID"] != -1 %>'
                            OnClientClick="javascript:return confirm('Only matches that have no associated players can be deleted. Are you sure you want to delete this match?')">
                            <span class="glyphicon glyphicon-trash"></span> Delete</asp:LinkButton>
                        &nbsp; <asp:LinkButton ID="btnAdd" runat="server" OnClick="btnAdd_Click" CssClass="text-white hover-white" Visible='<%# (int)Session["SchoolID"] != -1 %>'><span class="glyphicon glyphicon-plus"></span> Add match</asp:LinkButton>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <table style="background-color:white">
                    <tr><td style="width:140px">Description:</td><td style="width:450px"><asp:TextBox ID="MatchName" runat="server" Text='<%# Bind("MatchName") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>Team type:</td><td><asp:DropDownList ID="ddGenders" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlGenderList" DataTextField="GenderName" DataValueField="Gender" SelectedValue='<%# Bind("MatchGender") %>' /></td></tr>
                    <tr><td>Date:</td><td><asp:TextBox ID="MatchDate" runat="server" Text='<%# Bind("MatchDate","{0:d}") %>' CssClass="form-control input-sm picker" /></td></tr>
                    <tr class="altrow"><td>Time:</td><td><asp:TextBox ID="MatchTime" runat="server" Text='<%# Bind("MatchTime","{0:t}") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Official match:</td><td><asp:CheckBox ID="cbIsOfficial" runat="server" Checked='<%# Bind("IsOfficial") %>' /></td></tr>
                    <tr class="altrow"><td>Home school:</td><td><asp:DropDownList ID="ddHomeSchools" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlHomeSchoolList" DataTextField="SchoolName" DataValueField="SchoolID" SelectedValue='<%# Bind("HomeSchoolID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddHomeSchools_SelectedIndexChanged" /></td></tr>
                    <tr><td>Away school:</td><td><asp:DropDownList ID="ddAwaySchools" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlAwaySchoolList" DataTextField="SchoolName" DataValueField="SchoolID" SelectedValue='<%# Bind("AwaySchoolID") %>' /></td></tr>
                    <tr class="altrow"><td>Golf course:</td><td><asp:DropDownList ID="ddGolfCourses" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlGolfCourseList" DataTextField="GolfCourseName" DataValueField="GolfCourseID" SelectedValue='<%# Bind("GolfCourseID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddGolfCourses_SelectedIndexChanged" /></td></tr>
                    <tr><td>Varsity tee:</td><td><asp:DropDownList ID="ddVarsityTees" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlVarsityTeeList" DataTextField="TeeName" DataValueField="GolfCourseTeeID" /></td></tr>
                    <tr class="altrow"><td>JV tee:</td><td><asp:DropDownList ID="ddJVTees" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlJVTeeList" DataTextField="TeeName" DataValueField="GolfCourseTeeID" /></td></tr>
                    <tr><td>Holes played:</td><td><asp:DropDownList ID="ddHolesPlayed" runat="server" CssClass="form-control input-sm mini"
                        DataSourceID="sqlHolesPlayedList" DataTextField="HolesPlayedName" DataValueField="HolesPlayedID" SelectedValue='<%# Bind("HolesPlayedID") %>' /></td></tr>
                </table>
                <div style="padding:5px 0">
                        &nbsp; <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" CssClass="text-white hover-white"><span class="glyphicon glyphicon-ok"></span> Accept edits</asp:LinkButton>
                        &nbsp; <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="text-white hover-white"><span class="glyphicon glyphicon-remove"></span> Cancel</asp:LinkButton>
                </div>
            </EditItemTemplate>
        </asp:FormView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

    <asp:SqlDataSource ID="sqlViewStateList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT StateID, StateName FROM States WHERE (@StateID=0 OR StateID=@StateID) AND StateID > 0 ORDER BY StateName">
        <SelectParameters>
            <asp:Parameter Name="StateID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewDistrictList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT DistrictID, DistrictName FROM Districts WHERE (@DistrictID=0 OR DistrictID=@DistrictID) AND StateID=@StateID ORDER BY DistrictName">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="DistrictID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewLeagueList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT LeagueID, LeagueName FROM Leagues WHERE (@LeagueID=0 OR LeagueID=@LeagueID) AND DistrictID=@DistrictID ORDER BY LeagueName">
        <SelectParameters>
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="LeagueID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewYearList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM SchoolYears ORDER BY SchoolYear DESC">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewMatchList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="MatchList" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="SchoolID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlMatchMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchInfo" SelectCommandType="StoredProcedure"
        InsertCommand="INSERT INTO Matches (StateID, DistrictID, LeagueID, MatchName, MatchDate) VALUES (@StateID, @DistrictID, @LeagueID, @MatchName, @MatchDate); SELECT @MatchID = SCOPE_IDENTITY()"
        OnInserted="sqlMatchInserted"
        UpdateCommand="UPDATE Matches SET HomeSchoolID=@HomeSchoolID, AwaySchoolID=@AwaySchoolID, GolfCourseID=@GolfCourseID, VarsityTeeID=@VarsityTeeID, JVTeeID=@JVTeeID, HolesPlayedID=@HolesPlayedID, IsOfficial=@IsOfficial, MatchName=@MatchName, MatchGender=@MatchGender, MatchDate=@MatchDate, MatchTime=@MatchTime WHERE MatchID=@MatchID"
        DeleteCommand="DELETE FROM Matches WHERE MatchID=@MatchID"
        OnDeleted="sqlMatchDeleted">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="MatchID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="MatchName" Type="String" DefaultValue=" (new - edit me!)" />
            <asp:Parameter Name="MatchDate" Type="DateTime" />
            <asp:Parameter Name="MatchID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="MatchID" Type="Int32" />
            <asp:Parameter Name="HomeSchoolID" Type="Int32" />
            <asp:Parameter Name="AwaySchoolID" Type="Int32" />
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
            <asp:Parameter Name="VarsityTeeID" Type="Int32" />
            <asp:Parameter Name="JVTeeID" Type="Int32" />
            <asp:Parameter Name="HolesPlayedID" Type="Int32" />
            <asp:Parameter Name="IsOfficial" Type="Boolean" />
            <asp:Parameter Name="MatchName" Type="String" />
            <asp:Parameter Name="MatchGender" Type="String" />
            <asp:Parameter Name="MatchDate" Type="DateTime" />
            <asp:Parameter Name="MatchTime" Type="DateTime" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlHomeSchoolList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT SchoolID, SchoolName FROM Schools WHERE LeagueID=@LeagueID UNION SELECT SchoolID=NULL, SchoolName='(Not assigned)') U ORDER BY SchoolName">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAwaySchoolList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT SchoolID, SchoolName FROM Schools WHERE LeagueID=@LeagueID UNION SELECT SchoolID=NULL, SchoolName='(Not assigned)') U ORDER BY SchoolName">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfCourseList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT GolfCourseID, GolfCourseName FROM GolfCourses UNION SELECT GolfCourseID=NULL, GolfCourseName='(Not assigned)') U ORDER BY GolfCourseName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVarsityTeeList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT GolfCourseTeeID, TeeName FROM GolfCourseTees WHERE GolfCourseID=@GolfCourseID UNION SELECT GolfCourseTeeID=NULL, TeeName='(Not assigned)') U ORDER BY TeeName">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlJVTeeList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT GolfCourseTeeID, TeeName FROM GolfCourseTees WHERE GolfCourseID=@GolfCourseID UNION SELECT GolfCourseTeeID=NULL, TeeName='(Not assigned)') U ORDER BY TeeName">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlHolesPlayedList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT HolesPlayedID, HolesPlayedName FROM HolesPlayedTypes ORDER BY HolesPlayedName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlGenderList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT Gender='A', GenderName='Co-ed' UNION SELECT Gender='M', GenderName='Boys' UNION SELECT Gender='F', GenderName='Girls'">
    </asp:SqlDataSource>

</asp:Content>
