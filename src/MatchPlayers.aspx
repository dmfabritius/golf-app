<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MatchPlayers.aspx.cs" Inherits="Golf.MatchPlayers" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        #MainContent_fvMatchInfo td,
        #MainContent_fvMatchInfo th {padding:2px 2px}
        #MainContent_updMatchInfo div {margin-bottom:5px}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>Match Player Maintenance</h3>
        </div>
        <div class="col-sm-4 text-right">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <p style="padding-top:30px"><img src="img/activity.gif" alt="activity" /> accessing database...</p>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-4">
            <asp:Panel ID="pnlSelState" runat="server" Visible="True" CssClass="form-group"><asp:UpdatePanel ID="updddStates" runat="server"><ContentTemplate>
                <div class="row">
                    <div class="col-sm-4"><label class="control-label" for="ddStates">Select a state:</label></div>
                    <div class="col-sm-8"><asp:DropDownList ID="ddStates" runat="server" AutoPostBack="True" CssClass="form-control mini"
                        DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID" OnSelectedIndexChanged="ddStates_SelectedIndexChanged"/></div>
                </div>
            </ContentTemplate></asp:UpdatePanel></asp:Panel>
            <asp:Panel ID="pnlSelDistrict" runat="server" Visible="True" CssClass="form-group"><asp:UpdatePanel ID="updddDistricts" runat="server"><ContentTemplate>
                <div class="row">
                    <div class="col-sm-4"><label class="control-label" for="ddDistricts">Select a district:</label></div>
                    <div class="col-sm-8"><asp:DropDownList ID="ddDistricts" runat="server" AutoPostBack="True" CssClass="form-control mini"
                        DataSourceID="sqlViewDistrictList" DataTextField="DistrictName" DataValueField="DistrictID" OnSelectedIndexChanged="ddDistricts_SelectedIndexChanged"/></div>
                </div>
            </ContentTemplate></asp:UpdatePanel></asp:Panel>
            <asp:Panel ID="pnlSelLeague" runat="server" Visible="True" CssClass="form-group"><asp:UpdatePanel ID="updddLeagues" runat="server"><ContentTemplate>
                <div class="row">
                    <div class="col-sm-4"><label class="control-label" for="ddLeagues">Select a league:</label></div>
                    <div class="col-sm-8"><asp:DropDownList ID="ddLeagues" runat="server" AutoPostBack="True" CssClass="form-control mini"
                        DataSourceID="sqlViewLeagueList" DataTextField="LeagueName" DataValueField="LeagueID" OnSelectedIndexChanged="ddLeagues_SelectedIndexChanged"/></div>
                </div>
            </ContentTemplate></asp:UpdatePanel></asp:Panel>
            <asp:Panel ID="pnlSelYear" runat="server" Visible="True" CssClass="form-group"><asp:UpdatePanel ID="updddYears" runat="server"><ContentTemplate>
                <div class="row">
                    <div class="col-sm-4"><label class="control-label" for="ddYears">Select a year:</label></div>
                    <div class="col-sm-8"><asp:DropDownList ID="ddYears" runat="server" AutoPostBack="True" CssClass="form-control mini"
                        DataSourceID="sqlViewYearList" DataTextField="YearText" DataValueField="SchoolYear"
                        OnSelectedIndexChanged="ddYears_SelectedIndexChanged"/></div>
                </div>
            </ContentTemplate></asp:UpdatePanel></asp:Panel>
            <asp:Panel ID="pnlSelMatch" runat="server" Visible="True" CssClass="form-group"><asp:UpdatePanel ID="updddMatches" runat="server"><ContentTemplate>
                <div class="row">
                    <div class="col-sm-4"><label class="control-label" for="ddMatches">Select a match:</label></div>
                    <div class="col-sm-8"><asp:DropDownList ID="ddMatches" runat="server" AutoPostBack="True" CssClass="form-control mini"
                        DataSourceID="sqlViewMatchList" DataTextField="MatchName" DataValueField="MatchID"
                        OnDataBound="ddMatches_DataBound" OnSelectedIndexChanged="ddMatches_SelectedIndexChanged"/></div>
                </div>
            </ContentTemplate></asp:UpdatePanel></asp:Panel>
        </div>
        <div class="col-sm-8">
            <asp:UpdatePanel ID="updMatchInfo" runat="server"><ContentTemplate><asp:Panel ID="pnlMatchInfo" runat="server">
                <asp:FormView ID="fvMatchInfo" runat="server" DataKeyNames="MatchID" DataSourceID="sqlMatchInfo" ForeColor="#333333">
                    <RowStyle BackColor="#1C5E55" Font-Bold="False" />
                    <ItemTemplate>
                        <table style="background-color:white">
                            <tr class="altrow"><td>Date:</td><td class="data"><%# Eval("MatchDate","{0:d}") %> at <%# Eval("MatchTime","{0:t}") %></td></tr>
                            <tr><td>Home school:</td><td class="data"><%# Eval("HomeSchoolName") %></td></tr>
                            <tr class="altrow"><td>Away school:</td><td class="data"><%# Eval("AwaySchoolName") %></td></tr>
                            <tr><td>Golf course:</td><td class="data"><%# Eval("GolfCourseName") %></td></tr>
                        </table>
                    </ItemTemplate>
                </asp:FormView>
            </asp:Panel></ContentTemplate></asp:UpdatePanel>
        </div>
    </div>

    <br />
    <asp:UpdatePanel ID="updMatchPlayersMaint" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="gvMatchPlayersMaint" />
        </Triggers>
        <ContentTemplate><asp:Panel ID="pnlMatchPlayersMaint" runat="server">
        <asp:GridView ID="gvMatchPlayersMaint" runat="server" AutoGenerateColumns="False" DataSourceID="sqlMatchPlayersMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Go to create/edit matches" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="Position" HeaderText="Position" ItemStyle-HorizontalAlign="Center" />
                <asp:TemplateField HeaderText="Home Varsity Players" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteHVP" runat="server" ToolTip="Delete" CommandName="Delete" OnCommand="btnDelete_Command" CommandArgument='<%# Eval("HomeVarsityRoundID") %>' Visible='<%# !Eval("HomeVarsityPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("HomeSchoolID") == (int)Session["SchoolID"]) %>'
                            OnClientClick="javascript:return confirm('Are you sure you want to remove this player from the match and delete any associated scores & match round details?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                        <asp:Label ID="HomeVarsityPlayer" runat="server" Text='<%# Eval("HomeVarsityPlayer") %>' Visible='<%# !Eval("HomeVarsityPlayer").Equals(DBNull.Value) %>' />
                        <asp:DropDownList ID="ddPlayersHVP" runat="server" CssClass="form-control input-sm mini" Visible='<%# Eval("HomeVarsityPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("HomeSchoolID") == (int)Session["SchoolID"]) %>'
                            DataSourceID="sqlHomeSchoolPlayersList" DataTextField="PlayerName" DataValueField="PlayerID" AccessKey='<%# Eval("Position") %>' AutoPostBack="True" OnSelectedIndexChanged="ddVarsityPlayers_SelectedIndexChanged" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Home JV Players" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteHJP" runat="server" ToolTip="Delete" CommandName="Delete" OnCommand="btnDelete_Command" CommandArgument='<%# Eval("HomeJVRoundID") %>' Visible='<%# !Eval("HomeJVPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("HomeSchoolID") == (int)Session["SchoolID"]) %>'
                            OnClientClick="javascript:return confirm('Are you sure you want to remove this player from the match and delete any associated scores & match round details?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                        <asp:Label ID="HomeJVPlayer" runat="server" Text='<%# Eval("HomeJVPlayer") %>' Visible='<%# !Eval("HomeJVPlayer").Equals(DBNull.Value) %>' />
                        <asp:DropDownList ID="ddPlayersHJP" runat="server" CssClass="form-control input-sm mini" Visible='<%# Eval("HomeJVPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("HomeSchoolID") == (int)Session["SchoolID"]) %>'
                            DataSourceID="sqlHomeSchoolPlayersList" DataTextField="PlayerName" DataValueField="PlayerID" AccessKey='<%# Eval("Position") %>' AutoPostBack="True" OnSelectedIndexChanged="ddJVPlayers_SelectedIndexChanged" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Away Varsity Players" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteAVP" runat="server" ToolTip="Delete" CommandName="Delete" OnCommand="btnDelete_Command" CommandArgument='<%# Eval("AwayVarsityRoundID") %>' Visible='<%# !Eval("AwayVarsityPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("AwaySchoolID") == (int)Session["SchoolID"]) %>'
                            OnClientClick="javascript:return confirm('Are you sure you want to remove this player from the match and delete any associated scores & match round details?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                        <asp:Label ID="AwayVarsityPlayer" runat="server" Text='<%# Eval("AwayVarsityPlayer") %>' Visible='<%# !Eval("AwayVarsityPlayer").Equals(DBNull.Value) %>' />
                        <asp:DropDownList ID="ddPlayersAVP" runat="server" CssClass="form-control input-sm mini" Visible='<%# Eval("AwayVarsityPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("AwaySchoolID") == (int)Session["SchoolID"]) %>'
                            DataSourceID="sqlAwaySchoolPlayersList" DataTextField="PlayerName" DataValueField="PlayerID" AccessKey='<%# Eval("Position") %>' AutoPostBack="True" OnSelectedIndexChanged="ddVarsityPlayers_SelectedIndexChanged" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Away JV Players" ItemStyle-Width="200px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteAJP" runat="server" ToolTip="Delete" CommandName="Delete" OnCommand="btnDelete_Command" CommandArgument='<%# Eval("AwayJVRoundID") %>' Visible='<%# !Eval("AwayJVPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("AwaySchoolID") == (int)Session["SchoolID"]) %>'
                            OnClientClick="javascript:return confirm('Are you sure you want to remove this player from the match and delete any associated scores & match round details?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                        <asp:Label ID="AwayJVPlayer" runat="server" Text='<%# Eval("AwayJVPlayer") %>' Visible='<%# !Eval("AwayJVPlayer").Equals(DBNull.Value) %>' />
                        <asp:DropDownList ID="ddPlayersAJP" runat="server" CssClass="form-control input-sm mini" Visible='<%# Eval("AwayJVPlayer").Equals(DBNull.Value) && ((int)Session["SchoolID"] == 0 || (int)Eval("AwaySchoolID") == (int)Session["SchoolID"]) %>'
                            DataSourceID="sqlAwaySchoolPlayersList" DataTextField="PlayerName" DataValueField="PlayerID" AccessKey='<%# Eval("Position") %>' AutoPostBack="True" OnSelectedIndexChanged="ddJVPlayers_SelectedIndexChanged" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        </asp:Panel></ContentTemplate>
    </asp:UpdatePanel>

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

    <asp:SqlDataSource ID="sqlMatchInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchInfo" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlMatchPlayersMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchPlayersMaint" SelectCommandType="StoredProcedure"
        DeleteCommand="SELECT 1 -- Required placeholder">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlHomeSchoolPlayersList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT PlayerID, PlayerName FROM Players WHERE SchoolID=@SchoolID UNION SELECT PlayerID=NULL, PlayerName='(Not assigned)') U ORDER BY PlayerName">
        <SelectParameters>
            <asp:Parameter Name="SchoolID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAwaySchoolPlayersList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT PlayerID, PlayerName FROM Players WHERE SchoolID=@SchoolID UNION SELECT PlayerID=NULL, PlayerName='(Not assigned)') U ORDER BY PlayerName">
        <SelectParameters>
            <asp:Parameter Name="SchoolID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
