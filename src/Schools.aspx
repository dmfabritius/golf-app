<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Schools.aspx.cs" Inherits="Golf.Schools" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style>
        td, th {padding:2px}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>School Maintenance</h3>
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
    <asp:Panel ID="pnlSelSchool" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddSchools" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddSchools">Select a school:</label>
            <asp:DropDownList ID="ddSchools" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewSchoolList" DataTextField="SchoolName" DataValueField="SchoolID" OnSelectedIndexChanged="ddSchools_SelectedIndexChanged" OnDataBound="ddSchools_DataBound"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <asp:UpdatePanel ID="updSchoolMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlSchoolMaint" runat="server">
        <asp:FormView ID="fvSchoolMaint" runat="server" DataKeyNames="SchoolID" DataSourceID="sqlSchoolMaint" ForeColor="#333333"
            OnDataBound="fvSchoolDataBound" OnItemUpdating="fvSchoolItemUpdating">
            <RowStyle BackColor="#1C5E55" Font-Bold="False" />
            <EditRowStyle BackColor="#1C5E55" Font-Bold="False" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add School" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <ItemTemplate>
                <table style="background-color:white">
                    <tr><td style="width:140px">Name:</td><td class="data" style="width:450px"><%# Eval("SchoolName") %></td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td class="data"><%# Eval("SchoolAbbr") %></td></tr>
                    <tr><td>Classification:</td><td class="data"><%# Eval("ClassificationName") %></td></tr>
                    <tr class="altrow"><td>Default Course:</td><td class="data"><%# Eval("GolfCourseName") %></td></tr>
                    <tr><td>Default Tee:</td><td class="data"><%# Eval("TeeName") %></td></tr>
                    <tr class="altrow"><td>Default Holes:</td><td class="data"><%# Eval("HolesPlayedName") %></td></tr>
                    <tr><td>Boys Coach:</td><td class="data"><%# Eval("BoysCoach") %></td></tr>
                    <tr class="altrow"><td>Girls Coach:</td><td class="data"><%# Eval("GirlsCoach") %></td></tr>
                    <tr><td>Address:</td><td class="data"><%# Eval("AddressLine1") %></td></tr>
                    <tr class="altrow"><td>Line 2:</td><td class="data"><%# Eval("AddressLine2") %></td></tr>
                    <tr><td>City:</td><td class="data"><%# Eval("City") %></td></tr>
                    <tr class="altrow"><td>State:</td><td class="data"><%# Eval("State") %></td></tr>
                    <tr><td>Zip:</td><td class="data"><%# Eval("Zip") %></td></tr>
                    <tr class="altrow"><td>Username:</td><td class="data"><%# Eval("Username") %></td></tr>
                    <tr><td>Password:</td><td class="data"><span>&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;</span></td></tr>
                    <tr class="altrow"><td>Is active:</td><td class="data"><%# ((bool)Eval("IsActive"))? "Yes" : "No" %></td></tr>
                </table>
                <div style="padding:5px 0">
                        &nbsp; <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="text-white hover-white"><span class="glyphicon glyphicon-edit"></span> Edit</asp:LinkButton>
                        &nbsp; <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="text-white hover-white" Visible='<%# (int)Session["SchoolID"] == 0 %>'
                            OnClientClick="javascript:return confirm('Only schools that have no associated players can be deleted. Are you sure you want to delete this school?')">
                            <span class="glyphicon glyphicon-trash"></span> Delete</asp:LinkButton>
                        &nbsp; <asp:LinkButton ID="btnAdd" runat="server" OnClick="btnAdd_Click" CssClass="text-white hover-white" Visible='<%# (int)Session["SchoolID"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add school</asp:LinkButton>
                </div>
            </ItemTemplate>
            <EditItemTemplate>
                <table style="background-color:white">
                    <tr><td>League:</td><td>
                        <asp:DropDownList ID="ddSchoolLeagues" runat="server" DataSourceID="sqlSchoolLeagueList" DataTextField="LeagueName" DataValueField="LeagueID" SelectedValue='<%# Bind("LeagueID") %>' CssClass="form-control input-sm mini" /></td></tr>
                    <tr><td style="width:140px">Name:</td><td style="width:450px"><asp:TextBox ID="SchoolName" runat="server" Text='<%# Bind("SchoolName") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Abbreviation:</td><td style="width:450px"><asp:TextBox ID="SchoolAbbr" runat="server" Text='<%# Bind("SchoolAbbr") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Classification:</td><td>
                        <asp:DropDownList ID="ddClassifications" runat="server" DataSourceID="sqlClassificationList" DataTextField="ClassificationName" DataValueField="ClassificationID" SelectedValue='<%# Bind("ClassificationID") %>' CssClass="form-control input-sm mini" /></td></tr>
                    <tr class="altrow"><td>Default Course:</td><td>
                        <asp:DropDownList ID="ddDefaultGolfCourses" runat="server" DataSourceID="sqlGolfCourseList" DataTextField="GolfCourseName" DataValueField="GolfCourseID" SelectedValue='<%# Bind("DefaultGolfCourseID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddGolfCourses_SelectedIndexChanged" CssClass="form-control input-sm mini" /></td></tr>
                    <tr><td>Default Tee:</td><td>
                        <asp:DropDownList ID="ddGolfCourseTees" runat="server" DataSourceID="sqlGolfCourseTeeList" DataTextField="TeeName" DataValueField="GolfCourseTeeID" OnDataBinding="ddGolfCourseTees_DataBinding" CssClass="form-control input-sm mini" /></td></tr>
                    <tr class="altrow"><td>Default Holes:</td><td>
                        <asp:DropDownList ID="ddHolesPlayed" runat="server" DataSourceID="sqlHolesPlayedList" DataTextField="HolesPlayedName" DataValueField="HolesPlayedID" SelectedValue='<%# Bind("DefaultHolesPlayedID") %>' CssClass="form-control input-sm mini" /></td></tr>
                    <tr><td>Boys Coach:</td><td><asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("BoysCoach") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>Girls Coach:</td><td><asp:TextBox ID="TextBox9" runat="server" Text='<%# Bind("GirlsCoach") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Address:</td><td><asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("AddressLine1") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>Line 2:</td><td><asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("AddressLine2") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>City:</td><td><asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("City") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>State:</td><td><asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("State") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Zip:</td><td><asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("Zip") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>Username:</td><td><asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("Username") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr><td>Password:</td><td><asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Password") %>' CssClass="form-control input-sm" /></td></tr>
                    <tr class="altrow"><td>Is active:</td><td><asp:CheckBox ID="cbIsActive" runat="server" Checked='<%# Bind("IsActive") %>' /></td></tr>
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
            <asp:Parameter Name="StateID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewDistrictList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT DistrictID, DistrictName FROM Districts WHERE (@DistrictID=0 OR DistrictID=@DistrictID) AND StateID=@StateID ORDER BY DistrictName">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="DistrictID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewLeagueList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT LeagueID, LeagueName FROM Leagues WHERE (@LeagueID=0 OR LeagueID=@LeagueID) AND DistrictID=@DistrictID ORDER BY LeagueName">
        <SelectParameters>
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="LeagueID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewSchoolList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT SchoolID, SchoolName FROM Schools WHERE (@SchoolID=0 OR SchoolID=@SchoolID) AND LeagueID=@LeagueID ORDER BY SchoolName">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="SchoolID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlSchoolMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT S.*, ClassificationName=ISNULL(CL.ClassificationName, '(Not Assigned)'), GolfCourseName=ISNULL(CO.GolfCourseName, '(Not assigned)'), TeeName=ISNULL(TE.TeeName, '(Not assigned)'), HolesPlayedName=ISNULL(HP.HolesPlayedName, '(Not assigned)') FROM Schools S LEFT JOIN Classifications CL ON S.ClassificationID=CL.ClassificationID LEFT JOIN GolfCourses CO ON S.DefaultGolfCourseID=CO.GolfCourseID LEFT JOIN GolfCourseTees TE ON S.DefaultGolfCourseTeeID=TE.GolfCourseTeeID LEFT JOIN HolesPlayedTypes HP ON S.DefaultHolesPlayedID=HP.HolesPlayedID WHERE S.SchoolID=@SchoolID ORDER BY SchoolName"
        InsertCommand="INSERT INTO Schools (LeagueID, SchoolName) VALUES (@LeagueID, @SchoolName); SELECT @SchoolID = SCOPE_IDENTITY()"
        OnInserted="sqlSchoolInserted"
        UpdateCommand="UPDATE Schools SET LeagueID=@LeagueID, SchoolName=@SchoolName, SchoolAbbr=@SchoolAbbr, ClassificationID=@ClassificationID, DefaultGolfCourseID=@DefaultGolfCourseID, DefaultGolfCourseTeeID=@DefaultGolfCourseTeeID, DefaultHolesPlayedID=@DefaultHolesPlayedID, BoysCoach=@BoysCoach, GirlsCoach=@GirlsCoach, AddressLine1=@AddressLine1, AddressLine2=@AddressLine2, City=@City, State=@State, Zip=@Zip, Username=@Username, Password=@Password, IsActive=@IsActive WHERE SchoolID=@SchoolID"
        OnUpdated="sqlSchoolUpdated"
        DeleteCommand="DELETE FROM Schools WHERE SchoolID=@SchoolID"
        OnDeleted="sqlSchoolDeleted">
        <SelectParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="SchoolName" Type="String" DefaultValue=" (new - edit me!)" />
            <asp:Parameter Name="SchoolID" Type="Int32" Direction="Output" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="LeagueID" Type="Int32" />
            <asp:Parameter Name="SchoolName" Type="String" />
            <asp:Parameter Name="SchoolAbbr" Type="String" />
            <asp:Parameter Name="ClassificationID" Type="Int32" />
            <asp:Parameter Name="DefaultGolfCourseID" Type="Int32" />
            <asp:Parameter Name="DefaultGolfCourseTeeID" Type="Int32" />
            <asp:Parameter Name="DefaultHolesPlayedID" Type="Int32" />
            <asp:Parameter Name="BoysCoach" Type="String" />
            <asp:Parameter Name="GirlsCoach" Type="String" />
            <asp:Parameter Name="AddressLine1" Type="String" />
            <asp:Parameter Name="AddressLine2" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="State" Type="String" />
            <asp:Parameter Name="Zip" Type="String" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="IsActive" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlSchoolLeagueList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT LeagueID, LeagueName FROM Leagues WHERE DistrictID=@DistrictID ORDER BY LeagueName">
        <SelectParameters>
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlClassificationList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT ClassificationID, ClassificationName FROM Classifications UNION SELECT ClassificationID=NULL, ClassificationName='(Not assigned)') U ORDER BY ClassificationID">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfCourseList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT GolfCourseID, GolfCourseName FROM GolfCourses UNION SELECT GolfCourseID=NULL, GolfCourseName='(Not assigned)') U ORDER BY GolfCourseName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfCourseTeeList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT GolfCourseTeeID, TeeName FROM GolfCourseTees WHERE GolfCourseID=@GolfCourseID UNION SELECT GolfCourseTeeID=NULL, TeeName='(Not assigned)') U ORDER BY TeeName">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlHolesPlayedList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT HolesPlayedID, HolesPlayedName FROM HolesPlayedTypes UNION SELECT HolesPlayedID=NULL, HolesPlayedName='(Not assigned)') U ORDER BY HolesPlayedName">
    </asp:SqlDataSource>

</asp:Content>
