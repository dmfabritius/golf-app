<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MatchScoreEntrySimple.aspx.cs" Inherits="Golf.MatchScoreEntrySimple" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        th.onright, td.onright{padding-right:10px;text-align:right !important}
        .sep-gray{border-right:3px solid #555555}
        .sep-white{border-right:3px solid white}
        .info-width{min-width:100px !important;width:100px !important}
        input[type=text].narrow {margin-left:1px;padding-right:2px;max-width:32px;text-align:right}
        input[type=checkbox].narrow {margin:0;padding:0;text-align:right}
        span.narrow {height: 19px;width: 19px;margin-right: 4px;padding: 0 3px 0 0;border: 0;box-shadow:none}
        span.padright{padding-right:3px}
        #MainContent_fvMatchInfo td,
        #MainContent_fvMatchInfo th {padding:2px 2px}
        #MainContent_updGolfRoundInfo div,
        #MainContent_updScoreSummary div {margin-top:5px}
    </style>
    <script type="text/javascript">
        function mark(e) {
            e.style.backgroundColor = '#F7E7CA';
        }
    </script>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) {
            $("input[type='text']").on("click", function () { $(this).select(); });
            $("input[type='text']").on("focus", function () { $(this).select(); });
        });
    </script>

    <div class="row">
        <div class="col-sm-8">
            <h3>Match Score Entry</h3>
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
                        DataSourceID="sqlViewMatchList" DataTextField="MatchName" DataValueField="MatchID" OnSelectedIndexChanged="ddMatches_SelectedIndexChanged" OnDataBound="ddMatches_DataBound"/></div>
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

    <asp:UpdatePanel ID="updScoreSummary" runat="server"><ContentTemplate><asp:Panel ID="pnlScoreSummary" runat="server">
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
                <asp:BoundField DataField="HomeVarsityPlayer" HeaderText="Home Varsity" FooterStyle-HorizontalAlign="Left" />
                <asp:BoundField DataField="HomeVarsityScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="HomeVarsityPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayVarsityPlayer" HeaderText="Away Varsity" />
                <asp:BoundField DataField="AwayVarsityScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayVarsityPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" ItemStyle-CssClass="sep-gray" />
                <asp:BoundField DataField="HomeJVPlayer" HeaderText="Home JV" />
                <asp:BoundField DataField="HomeJVScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="HomeJVPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayJVPlayer" HeaderText="Away JV" />
                <asp:BoundField DataField="AwayJVScore" HeaderText="Score" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="AwayJVPoints" HeaderText="Points" ItemStyle-HorizontalAlign="Center" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

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
                <asp:TemplateField ItemStyle-Width="240px">
                    <ItemTemplate>
                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name") %>' />
                        <asp:Label ID="GolfRoundID" runat="server" Text='<%# Eval("GolfRoundID") %>' Visible="false" />
                        <asp:Label ID="Gender" runat="server" Text='<%# Eval("Gender") %>' Visible="false" />
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="text-white hover-white" OnClick="btnUpdate_Click"><span class="glyphicon glyphicon-ok"></span> Update</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="1" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i01Label" runat="server"       Text='<%# Eval("1") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i01TextBox" runat="server"     Text='<%# (Eval("1").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("1") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="2" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i02Label" runat="server"       Text='<%# Eval("2") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i02TextBox" runat="server"     Text='<%# (Eval("2").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("2") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="3" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i03Label" runat="server"       Text='<%# Eval("3") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i03TextBox" runat="server"     Text='<%# (Eval("3").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("3") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="4" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i04Label" runat="server"       Text='<%# Eval("4") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i04TextBox" runat="server"     Text='<%# (Eval("4").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("4") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="5" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i05Label" runat="server"       Text='<%# Eval("5") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i05TextBox" runat="server"     Text='<%# (Eval("5").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("5") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="6" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i06Label" runat="server"       Text='<%# Eval("6") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i06TextBox" runat="server"     Text='<%# (Eval("6").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("6") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="7" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i07Label" runat="server"       Text='<%# Eval("7") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i07TextBox" runat="server"     Text='<%# (Eval("7").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("7") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="8" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i08Label" runat="server"       Text='<%# Eval("8") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i08TextBox" runat="server"     Text='<%# (Eval("8").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("8") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="9" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i09Label" runat="server"       Text='<%# Eval("9") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i09TextBox" runat="server"     Text='<%# (Eval("9").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("9") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField= "Out"   HeaderText="Out"   ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:TemplateField HeaderText="10" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i10Label" runat="server"       Text='<%# Eval("10") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i10TextBox" runat="server"     Text='<%# (Eval("10").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("10") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="11" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i11Label" runat="server"       Text='<%# Eval("11") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i11TextBox" runat="server"     Text='<%# (Eval("11").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("11") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="12" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i12Label" runat="server"       Text='<%# Eval("12") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i12TextBox" runat="server"     Text='<%# (Eval("12").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("12") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="13" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i13Label" runat="server"       Text='<%# Eval("13") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i13TextBox" runat="server"     Text='<%# (Eval("13").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("13") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="14" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i14Label" runat="server"       Text='<%# Eval("14") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i14TextBox" runat="server"     Text='<%# (Eval("14").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("14") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="15" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i15Label" runat="server"       Text='<%# Eval("15") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i15TextBox" runat="server"     Text='<%# (Eval("15").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("15") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="16" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i16Label" runat="server"       Text='<%# Eval("16") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i16TextBox" runat="server"     Text='<%# (Eval("16").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("16") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="17" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i17Label" runat="server"       Text='<%# Eval("17") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i17TextBox" runat="server"     Text='<%# (Eval("17").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("17") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="18" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i18Label" runat="server"       Text='<%# Eval("18") %>' Visible='<%# Eval("Name").Equals("Par") %>' CssClass="padright" />
                        <asp:TextBox  ID="i18TextBox" runat="server"     Text='<%# (Eval("18").Equals(0) && !Eval("Name").Equals("Par"))? "X" : Eval("18") %>' Visible='<%# !Eval("Name").Equals("Par") %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="In"     HeaderText="In"    ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField= "Total" HeaderText="Total" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
            </Columns>
        </asp:GridView>
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

    <asp:SqlDataSource ID="sqlMatchInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT M.*, HomeSchoolName=ISNULL(S1.SchoolName, '(Not assigned)'), AwaySchoolName=ISNULL(S2.SchoolName, '(Not assigned)'), GolfCourseName=ISNULL(GolfCourseName, '(Not assigned)'), VarsityTeeName=ISNULL(VT.TeeName, '(Not assigned)'), JVTeeName=ISNULL(JT.TeeName, '(Not assigned)'), HolesPlayedName=ISNULL(HolesPlayedName, '(Not assigned)') FROM Matches M LEFT JOIN Schools S1 ON S1.SchoolID=M.HomeSchoolID LEFT JOIN Schools S2 ON S2.SchoolID=M.AwaySchoolID LEFT JOIN GolfCourses C ON C.GolfCourseID=M.GolfCourseID LEFT JOIN GolfCourseTees VT ON VT.GolfCourseTeeID=M.VarsityTeeID LEFT JOIN GolfCourseTees JT ON JT.GolfCourseTeeID=M.JVTeeID LEFT JOIN HolesPlayedTypes H ON H.HolesPlayedID=M.HolesPlayedID WHERE M.MatchID=@MatchID">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlGolfRoundInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchGolfRoundInfo" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="VarsityOnly" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlScoreSummary" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="MatchScoreSummary" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="MatchID" ControlID="ddMatches" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
