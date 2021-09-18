<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MatchRecord.aspx.cs" Inherits="Golf.MatchRecord" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style>
        th.onright, td.onright {padding-right:10px;text-align:right !important}
        p.grid-head {margin:0;padding:0 4px;display:inline-block;background:white;font-size:1.4em;width:537px}
        .boldright {font-weight:bold;padding-right:10px;text-align:right !important}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>Match Record & Drill Down</h3>
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
    <asp:Panel ID="pnlSelGender" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddGender" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddGender">Select team type:</label>
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
            <asp:UpdatePanel ID="updLeagueWinLoss" runat="server"><ContentTemplate>
                <asp:GridView ID="gvLeagueWinLoss" runat="server" AutoGenerateColumns="False" DataSourceID="sqlLeagueWinLoss" DataKeyNames="SchoolID"
                    CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
                    OnRowDataBound="gvLeagueWinLoss_RowDataBound" OnSelectedIndexChanged="gvLeagueWinLoss_SelectedIndexChanged">
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
                        <asp:BoundField DataField="SchoolName" HeaderText="School" />
                        <asp:BoundField DataField="Wins" HeaderText="Win" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" />
                        <asp:BoundField DataField="Losses" HeaderText="Loss" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </div>
        <div class="col-sm-8">
            <asp:UpdatePanel ID="updSchoolWinLoss" runat="server"><ContentTemplate>
                <asp:GridView ID="gvSchoolWinLoss" runat="server" AutoGenerateColumns="False" DataSourceID="sqlSchoolWinLoss" DataKeyNames="MatchID"
                    CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
                    OnRowDataBound="gvSchoolWinLoss_RowDataBound" OnSelectedIndexChanged="gvSchoolWinLoss_SelectedIndexChanged">
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
                        <asp:BoundField DataField="MatchDate" HeaderText="Date" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="MatchName" HeaderText="Match" />
                        <asp:BoundField DataField="Result" HeaderText="Win/Loss" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </div>
    </div>

    <br />
    <asp:UpdatePanel ID="updMatchInfo" runat="server"><ContentTemplate>
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
    </ContentTemplate></asp:UpdatePanel>

    <br />
    <asp:UpdatePanel ID="updScoreSummary" runat="server"><ContentTemplate>
        <asp:GridView ID="gvScoreSummary" runat="server" AutoGenerateColumns="False" DataSourceID="sqlScoreSummary"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
            OnRowDataBound="gvScoreSummary_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" ForeColor="White" Font-Bold="False" HorizontalAlign="Center" />
            <Columns>
                <asp:BoundField DataField="Position" HeaderText="Position" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="HomeVarsityPlayer" HeaderText="Home" FooterStyle-HorizontalAlign="Left" />
                <asp:BoundField DataField="HomeVarsityScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="HomeVarsityPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayVarsityPlayer" HeaderText="Away" />
                <asp:BoundField DataField="AwayVarsityScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayVarsityPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" />
            </Columns>
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>

    <br />
    <asp:UpdatePanel ID="updGolfRoundInfo" runat="server"><ContentTemplate><asp:Panel ID="pnlGolfRoundInfo" runat="server">
        <asp:GridView ID="gvGolfRoundInfo" runat="server" AutoGenerateColumns="False" DataSourceID="sqlGolfRoundInfo"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
            OnDataBinding="gvGolfRoundInfo_DataBinding" OnRowDataBound="gvGolfRoundInfo_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" ForeColor="White" Font-Bold="False" />
            <Columns>
                <asp:BoundField DataField="Name" HeaderText=" " ReadOnly="True" />
                <asp:TemplateField HeaderText="1" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i01Label" runat="server" Text='<%# Eval("1").Equals(0) ? "X" : Eval("1") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="2" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i02Label" runat="server" Text='<%# Eval("2").Equals(0) ? "X" : Eval("2") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="3" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i03Label" runat="server" Text='<%# Eval("3").Equals(0) ? "X" : Eval("3") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="4" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i04Label" runat="server" Text='<%# Eval("4").Equals(0) ? "X" : Eval("4") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="5" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i05Label" runat="server" Text='<%# Eval("5").Equals(0) ? "X" : Eval("5") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="6" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i06Label" runat="server" Text='<%# Eval("6").Equals(0) ? "X" : Eval("6") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="7" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i07Label" runat="server" Text='<%# Eval("7").Equals(0) ? "X" : Eval("7") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="8" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i08Label" runat="server" Text='<%# Eval("8").Equals(0) ? "X" : Eval("8") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="9" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i09Label" runat="server" Text='<%# Eval("9").Equals(0) ? "X" : Eval("9") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField= "Out"   HeaderText="Out"   ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:TemplateField HeaderText="10" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i10Label" runat="server" Text='<%# Eval("10").Equals(0) ? "X" : Eval("10") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="11" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i11Label" runat="server" Text='<%# Eval("11").Equals(0) ? "X" : Eval("11") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="12" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i12Label" runat="server" Text='<%# Eval("12").Equals(0) ? "X" : Eval("12") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="13" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i13Label" runat="server" Text='<%# Eval("13").Equals(0) ? "X" : Eval("13") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="14" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i14Label" runat="server" Text='<%# Eval("14").Equals(0) ? "X" : Eval("14") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="15" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i15Label" runat="server" Text='<%# Eval("15").Equals(0) ? "X" : Eval("15") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="16" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i16Label" runat="server" Text='<%# Eval("16").Equals(0) ? "X" : Eval("16") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="17" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i17Label" runat="server" Text='<%# Eval("17").Equals(0) ? "X" : Eval("17") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="18" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate><asp:Label    ID="i18Label" runat="server" Text='<%# Eval("18").Equals(0) ? "X" : Eval("18") %>' CssClass="padright" /></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="In"     HeaderText="In"    ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField= "Total" HeaderText="Total" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

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
    <asp:SqlDataSource ID="sqlViewGenderList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GenderID='M', GenderName='Boys' UNION SELECT GenderID='F', GenderName='Girls'">
        <SelectParameters>
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewYearList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT * FROM (SELECT SchoolYear=9999, YearText='(All Years)' UNION SELECT * FROM SchoolYears) U ORDER BY SchoolYear DESC">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlLeagueWinLoss" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="New_WinLossResults_New" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddGender" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlSchoolWinLoss" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="New_WinLossBySchool_New" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="DistrictID" ControlID="ddDistricts" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="LeagueID" ControlID="ddLeagues" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="SchoolID" ControlID="gvLeagueWinLoss" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddGender" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="SchoolYear" ControlID="ddYears" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlMatchInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchInfo" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="gvSchoolWinLoss" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlScoreSummary" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchVarsityScoreSummary" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="gvSchoolWinLoss" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfRoundInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchGolfRoundInfo" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="gvSchoolWinLoss" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="VarsityOnly" Type="Int32" DefaultValue="1" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
