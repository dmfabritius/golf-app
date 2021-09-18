<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PlayerMatchStats.aspx.cs" Inherits="Golf.PlayerMatchStats" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        input[type=radio] {margin-right:5px}
        #MainContent_gvStatDetails th {text-align:center !important}
        #MainContent_gvStatDetails td {padding:2px 16px}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>Player Match Statistics</h3>
            <h5><i>Note: Stats are for varsity players only and are based on their 7 best 9-hole rounds, including rounds with Xs.</i></h5>
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
    <asp:UpdatePanel ID="updPlayerStats" runat="server"><ContentTemplate>
        <asp:GridView ID="gvPlayerStats" runat="server" AutoGenerateColumns="False" DataSourceID="sqlPlayerStats" DataKeyNames="PlayerID"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" AllowSorting="True"
            OnRowDataBound="gvPlayerStats_RowDataBound" OnSelectedIndexChanged="gvPlayerStats_SelectedIndexChanged">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" ToolTip="Select"><span class="glyphicon glyphicon-list-alt text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PlayerName" HeaderText="Player" />
                <asp:BoundField DataField="SchoolName" HeaderText="School" />
                <asp:BoundField DataField="LeagueName" HeaderText="League" />
                <asp:BoundField DataField="DistrictName" HeaderText="District" />
                <asp:BoundField DataField="StateName" HeaderText="State" Visible="false" />
                <asp:BoundField DataField="NumPlayed" HeaderText="Rounds" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="Score" HeaderText="Avg Score" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Center" SortExpression="NumPlayed DESC, Score, PlayerName ASC" />
                <asp:BoundField DataField="Points" HeaderText="Avg Points" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Center" SortExpression="Points DESC, PlayerName ASC" />
                <asp:BoundField DataField="TotalScore" HeaderText="Total Score" ItemStyle-HorizontalAlign="Center" SortExpression="TotalScore ASC, PlayerName ASC" />
                <asp:BoundField DataField="TotalPoints" HeaderText="Total Points" ItemStyle-HorizontalAlign="Center" SortExpression="TotalPoints DESC, PlayerName ASC" />
                <asp:BoundField DataField="Putts" HeaderText="Putts" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Center" SortExpression="Putts, PlayerName ASC" />
                <asp:BoundField DataField="Fairways" HeaderText="Fairways" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Center" SortExpression="Fairways DESC, PlayerName ASC" />
                <asp:BoundField DataField="Greens" HeaderText="Greens" DataFormatString="{0:0.00}" ItemStyle-HorizontalAlign="Center" SortExpression="Greens DESC, PlayerName ASC" />
            </Columns>
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>

    <br />
    <h5><i>Note: Detailed statistics show ALL match rounds, from which the 7 best are summarized above.</i></h5>
    <asp:UpdatePanel ID="updStatDetails" runat="server"><ContentTemplate>
        <asp:GridView ID="gvStatDetails" runat="server" AutoGenerateColumns="False" DataSourceID="sqlStatDetails"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
            OnRowDataBound="gvStatDetails_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" HorizontalAlign="Center" />
            <AlternatingRowStyle BackColor="#FFFFFF" HorizontalAlign="Center" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" ForeColor="White" />
            <Columns>
                <asp:TemplateField HeaderText="Date Played">
                    <ItemTemplate>
                        <%# Eval("DatePlayed","{0:d}") %>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:RadioButtonList ID="rblInfoOptions" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblInfoOptions_SelectedIndexChanged">
                            <asp:ListItem Text="Scores" />
                            <asp:ListItem Text="Points" />
                            <asp:ListItem Text="Putts" />
                            <asp:ListItem Text="Fairways" />
                            <asp:ListItem Text="Greens" />
                        </asp:RadioButtonList>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="1" HeaderText="1" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="2" HeaderText="2" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="3" HeaderText="3" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="4" HeaderText="4" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="5" HeaderText="5" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="6" HeaderText="6" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="7" HeaderText="7" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="8" HeaderText="8" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="9" HeaderText="9" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="Out" HeaderText="Out" />
                <asp:BoundField DataField="10" HeaderText="10" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="11" HeaderText="11" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="12" HeaderText="12" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="13" HeaderText="13" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="14" HeaderText="14" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="15" HeaderText="15" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="16" HeaderText="16" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="17" HeaderText="17" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="18" HeaderText="18" DataFormatString="{0:#;#;\ }" />
                <asp:BoundField DataField="In" HeaderText="In" />
            </Columns>
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>

    <!-- <br /><p>Note: Only 9-hole rounds are included in these results.</p> -->

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
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewYearList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT SchoolYear=9999, YearText='(All Years)' UNION SELECT * FROM SchoolYears) U ORDER BY SchoolYear DESC">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPlayerStats" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="PlayerMatchStats" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddGender" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="IsPractice" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlStatDetails" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="InfoPerHoleByPlayer" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="PlayerID" Type="Int32" DefaultValue="0" />
            <asp:Parameter Name="IsPractice" Type="Int32" DefaultValue="0" />
            <asp:Parameter Name="IsNineHoles" Type="Int32" DefaultValue="1" />
            <asp:Parameter Name="Info" Type="String" DefaultValue="Score" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
