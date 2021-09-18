<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MatchSchedule.aspx.cs" Inherits="Golf.MatchSchedule" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        tr.sep{border-top:1px solid #999999}
        th, td {vertical-align:bottom}
        td.extratop{padding-top:10px}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>Match Schedule and Record</h3>
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
                DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID"
                OnDataBound="ddStates_DataBound" OnSelectedIndexChanged="ddStates_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelDistrict" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddDistricts" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddDistricts">Select a district:</label>
            <asp:DropDownList ID="ddDistricts" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewDistrictList" DataTextField="DistrictName" DataValueField="DistrictID"
                OnDataBound="ddDistricts_DataBound" OnSelectedIndexChanged="ddDistricts_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelLeague" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddLeagues" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddLeagues">Select a league:</label>
            <asp:DropDownList ID="ddLeagues" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewLeagueList" DataTextField="LeagueName" DataValueField="LeagueID"
                OnDataBound="ddLeagues_DataBound" OnSelectedIndexChanged="ddLeagues_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelSchool" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddSchools" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddSchools">Select a school:</label>
            <asp:DropDownList ID="ddSchools" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewSchoolList" DataTextField="SchoolName" DataValueField="SchoolID" OnSelectedIndexChanged="ddSchools_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelGender" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddGender" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddGender">Select a gender:</label>
            <asp:DropDownList ID="ddGender" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewGenderList" DataTextField="GenderName" DataValueField="GenderID" OnSelectedIndexChanged="ddGender_SelectedIndexChanged" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelYear" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddYears" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddYears">Select a year:</label>
            <asp:DropDownList ID="ddYears" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewYearList" DataTextField="YearText" DataValueField="SchoolYear" OnSelectedIndexChanged="ddYears_SelectedIndexChanged"/>
    </ContentTemplate></asp:UpdatePanel></asp:Panel>

    <br />
    <div class="row">
        <div class="col-sm-4">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server"><ContentTemplate>
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="sqlWinLoss"
                    CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" OnRowDataBound="GridView2_RowDataBound">
                    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#E3EAEB" />
                    <AlternatingRowStyle BackColor="#FFFFFF" />
                    <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
                    <Columns>
                        <asp:BoundField DataField="SchoolName" HeaderText="School" />
                        <asp:BoundField DataField="TeamType" HeaderText="B/G" />
                        <asp:BoundField DataField="Wins" HeaderText="Win" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" />
                        <asp:BoundField DataField="Losses" HeaderText="Loss" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </div>
        <div class="col-sm-8">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server"><ContentTemplate>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlMatchSchedule"
                    CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" OnRowDataBound="GridView1_RowDataBound">
                    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#E3EAEB" />
                    <AlternatingRowStyle BackColor="#FFFFFF" />
                    <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
                    <Columns>
                        <asp:BoundField DataField="MatchDate" HeaderText="Date" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="MatchTime" HeaderText="Time" DataFormatString="{0:t}" />
                        <asp:BoundField DataField="MatchName" HeaderText="Match" />
                        <asp:BoundField DataField="GolfCourseName" HeaderText="Golf Course" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </div>
    </div>

    <asp:SqlDataSource ID="sqlViewStateList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT StateID, StateName FROM States ORDER BY StateName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewDistrictList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT DistrictID, DistrictName FROM Districts WHERE StateID=@StateID UNION SELECT DistrictID=0, DistrictName='(All districts)') U ORDER BY DistrictName">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewLeagueList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT LeagueID, LeagueName FROM Leagues WHERE DistrictID=@DistrictID UNION SELECT LeagueID=0, LeagueName='(All leagues)') U ORDER BY LeagueName">
        <SelectParameters>
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewSchoolList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT SchoolID, SchoolName FROM Schools WHERE LeagueID=@LeagueID UNION SELECT SchoolID=0, SchoolName='(All schools)') U ORDER BY SchoolName">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewGenderList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GenderID='A', GenderName='(All Genders)' UNION SELECT GenderID='F', GenderName='Female' UNION SELECT GenderID='M', GenderName='Male'">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewYearList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM SchoolYears ORDER BY SchoolYear DESC">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlMatchSchedule" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchSchedule" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddGender" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlWinLoss" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="New_WinLossResults_New" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddGender" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
