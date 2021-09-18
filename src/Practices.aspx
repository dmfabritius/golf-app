<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Practices.aspx.cs" Inherits="Golf.Practices" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        th.onright{padding-right:10px;text-align:right !important}
        .info-width{min-width:100px !important;width:100px !important}
        input[type=text].narrow {margin-left:1px;padding-right:2px;max-width:32px;text-align:right}
        input[type=checkbox].narrow {margin:0;padding:0;text-align:right}
        span.narrow {height: 19px;width: 19px;margin-right: 4px;padding: 0 3px 0 0;border: 0;box-shadow:none}
        span.padright{padding-right:3px}
    </style>
    <script type="text/javascript">
        function mark(e) {e.style.backgroundColor = '#F7E7CA';}
    </script>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) {
            $(".picker").datepicker();
            $("input[type='text']").on("click", function () { $(this).select(); });
            $("input[type='text']").on("focus", function () { $(this).select(); });
        });
    </script>

    <div class="row">
        <div class="col-sm-8">
            <h3>Practice Rounds</h3>
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

    <asp:UpdatePanel ID="updPracticeMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlPracticeMaint" runat="server">
        <asp:GridView ID="gvPracticeMaint" runat="server" AutoGenerateColumns="False" DataSourceID="sqlPracticeMaint" DataKeyNames="GolfRoundID"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" AllowPaging="true" PageSize="6"
            OnRowDataBound="gvPracticeRowDataBound" OnRowUpdating="gvPracticeRowUpdating" OnRowCancelingEdit="gvPracticeRowCancelingEdit">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <PagerStyle BackColor="Wheat" Font-Bold="True" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add Practice Round" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField ItemStyle-Width="60px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit"><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete"
                            OnClientClick="javascript:return confirm('Are you sure you want to delete this practice round?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnAdd" runat="server" CommandName="Insert" CssClass="text-white hover-white" OnClick="btnAdd_Click" Visible='<%# (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Played" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <%# Eval("DatePlayed","{0:d}") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="DatePlayed" runat="server" Text='<%# Bind("DatePlayed","{0:d}") %>' CssClass="form-control input-sm picker" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Player" ItemStyle-Width="140px">
                    <ItemTemplate>
                        <%# Eval("PlayerName") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:Label ID="Gender" runat="server" Text='<%# Eval("Gender") %>' Visible="False" />
                        <asp:DropDownList ID="ddPlayers" runat="server" CssClass="form-control input-sm mini"
                            DataSourceID="sqlPlayerList" DataTextField="PlayerName" DataValueField="PlayerID" SelectedValue='<%# Bind("PlayerID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddPlayers_SelectedIndexChanged" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Golf Course" ItemStyle-Width="280px">
                    <ItemTemplate>
                        <%# Eval("GolfCourseName") %><asp:Label ID="GolfCourseID" runat="server" Text='<%# Eval("GolfCourseID") %>' Visible="False" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddGolfCourses" runat="server" CssClass="form-control input-sm mini"
                            DataSourceID="sqlGolfCourseList" DataTextField="GolfCourseName" DataValueField="GolfCourseID" SelectedValue='<%# Bind("GolfCourseID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddGolfCourses_SelectedIndexChanged" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tee" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <%# Eval("TeeName") %><asp:Label ID="GolfCourseTeeID" runat="server" Text='<%# Eval("GolfCourseTeeID") %>' Visible="False" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddGolfCourseTees" runat="server" CssClass="form-control input-sm mini"
                            DataSourceID="sqlGolfCourseTeeList" DataTextField="TeeName" DataValueField="GolfCourseTeeID" AutoPostBack="True" OnSelectedIndexChanged="ddGolfCourseTees_SelectedIndexChanged" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Holes Played" ItemStyle-Width="110px" ControlStyle-Width="110px">
                    <ItemTemplate>
                        <%# Eval("HolesPlayedName") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddHolesPlayed" runat="server" CssClass="form-control input-sm mini"
                            DataSourceID="sqlHolesPlayedList" DataTextField="HolesPlayedName" DataValueField="HolesPlayedID" SelectedValue='<%# Bind("HolesPlayedID") %>' AutoPostBack="True" OnSelectedIndexChanged="ddHolesPlayed_SelectedIndexChanged" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Score" HeaderText="Score" ReadOnly="True" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField="Points" HeaderText="Points" ReadOnly="True" ItemStyle-ForeColor="#8E5F41" />
                <asp:TemplateField HeaderText="Varsity" ItemStyle-Width="60px" ControlStyle-Width="60px">
                    <ItemTemplate>
                        <asp:Label ID="Varsity" runat="server" Text='<%# ((bool)Eval("IsVarsity"))? "Y" : "-" %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="cbIsVarsity" runat="server" Checked='<%# Bind("IsVarsity") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Comments" HeaderText="Comments" ControlStyle-CssClass="form-control input-sm" ItemStyle-Width="180px" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

    <br />
    <asp:UpdatePanel ID="updGolfRoundInfo" runat="server"><ContentTemplate><asp:Panel ID="pnlGolfRoundInfo" runat="server">
        <asp:GridView ID="gvGolfRoundInfo" runat="server" AutoGenerateColumns="False" DataSourceID="sqlGolfRoundInfo"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" Visible="False"
            OnRowDataBound="gvGolfRoundInfo_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" ForeColor="White" Font-Bold="False" />
            <Columns>
                <asp:TemplateField ItemStyle-Width="110px">
                    <ItemTemplate>
                        <%# Eval("Info") %>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="text-white hover-white" OnClick="btnUpdate_Click"><span class="glyphicon glyphicon-ok"></span> Update</asp:LinkButton> &nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" CssClass="text-white hover-white" OnClick="btnCancel_Click"><span class="glyphicon glyphicon-remove"></span> Cancel</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="1" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i01Label" runat="server"       Text='<%# Eval("1") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i01TextBox" runat="server"     Text='<%# (Eval("1").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("1") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i01Checkbox" runat="server" Checked='<%# Eval("1").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="2" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i02Label" runat="server"       Text='<%# Eval("2") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i02TextBox" runat="server"     Text='<%# (Eval("2").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("2") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i02Checkbox" runat="server" Checked='<%# Eval("2").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="3" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i03Label" runat="server"       Text='<%# Eval("3") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i03TextBox" runat="server"     Text='<%# (Eval("3").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("3") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i03Checkbox" runat="server" Checked='<%# Eval("3").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="4" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i04Label" runat="server"       Text='<%# Eval("4") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i04TextBox" runat="server"     Text='<%# (Eval("4").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("4") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i04Checkbox" runat="server" Checked='<%# Eval("4").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="5" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i05Label" runat="server"       Text='<%# Eval("5") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i05TextBox" runat="server"     Text='<%# (Eval("5").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("5") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i05Checkbox" runat="server" Checked='<%# Eval("5").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="6" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i06Label" runat="server"       Text='<%# Eval("6") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i06TextBox" runat="server"     Text='<%# (Eval("6").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("6") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i06Checkbox" runat="server" Checked='<%# Eval("6").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="7" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i07Label" runat="server"       Text='<%# Eval("7") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i07TextBox" runat="server"     Text='<%# (Eval("7").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("7") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i07Checkbox" runat="server" Checked='<%# Eval("7").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="8" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i08Label" runat="server"       Text='<%# Eval("8") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i08TextBox" runat="server"     Text='<%# (Eval("8").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("8") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i08Checkbox" runat="server" Checked='<%# Eval("8").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="9" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i09Label" runat="server"       Text='<%# Eval("9") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i09TextBox" runat="server"     Text='<%# (Eval("9").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("9") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i09Checkbox" runat="server" Checked='<%# Eval("9").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField= "Out"   HeaderText="Out"   ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:TemplateField HeaderText="10" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i10Label" runat="server"       Text='<%# Eval("10") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i10TextBox" runat="server"     Text='<%# (Eval("10").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("10") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i10Checkbox" runat="server" Checked='<%# Eval("10").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="11" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i11Label" runat="server"       Text='<%# Eval("11") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i11TextBox" runat="server"     Text='<%# (Eval("11").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("11") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i11Checkbox" runat="server" Checked='<%# Eval("11").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="12" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i12Label" runat="server"       Text='<%# Eval("12") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i12TextBox" runat="server"     Text='<%# (Eval("12").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("12") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i12Checkbox" runat="server" Checked='<%# Eval("12").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="13" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i13Label" runat="server"       Text='<%# Eval("13") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i13TextBox" runat="server"     Text='<%# (Eval("13").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("13") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i13Checkbox" runat="server" Checked='<%# Eval("13").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="14" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i14Label" runat="server"       Text='<%# Eval("14") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i14TextBox" runat="server"     Text='<%# (Eval("14").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("14") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i14Checkbox" runat="server" Checked='<%# Eval("14").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="15" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i15Label" runat="server"       Text='<%# Eval("15") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i15TextBox" runat="server"     Text='<%# (Eval("15").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("15") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i15Checkbox" runat="server" Checked='<%# Eval("15").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="16" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i16Label" runat="server"       Text='<%# Eval("16") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i16TextBox" runat="server"     Text='<%# (Eval("16").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("16") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i16Checkbox" runat="server" Checked='<%# Eval("16").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="17" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i17Label" runat="server"       Text='<%# Eval("17") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i17TextBox" runat="server"     Text='<%# (Eval("17").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("17") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i17Checkbox" runat="server" Checked='<%# Eval("17").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="18" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="onright">
                    <ItemTemplate>
                        <asp:Label    ID="i18Label" runat="server"       Text='<%# Eval("18") %>' Visible='<%# !(Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")||Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="padright" />
                        <asp:TextBox  ID="i18TextBox" runat="server"     Text='<%# (Eval("18").Equals(0) && Eval("Info").Equals("Score"))? "X" : Eval("18") %>' Visible='<%# (Eval("Info").Equals("Score")||Eval("Info").Equals("Putts")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
                        <asp:CheckBox ID="i18Checkbox" runat="server" Checked='<%# Eval("18").Equals(1) %>' Visible='<%# (Eval("Info").Equals("Fairway")||Eval("Info").Equals("Green")) %>' CssClass="form-control input-sm narrow" onchange="mark(this)" />
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

    <asp:SqlDataSource ID="sqlPracticeMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="PracticeMaintSelect" SelectCommandType="StoredProcedure"
        InsertCommand="INSERT INTO GolfRounds (PlayerID, GolfRoundTypeID, GolfCourseID, GolfCourseTeeID, HolesPlayedID, DatePlayed) VALUES (@PlayerID, @GolfRoundTypeID, @GolfCourseID, @GolfCourseTeeID, @HolesPlayedID, @DatePlayed); SELECT @GolfRoundID = SCOPE_IDENTITY()"
        OnInserted="sqlPracticeInserted"
        UpdateCommand="UPDATE GolfRounds SET DatePlayed=@DatePlayed, PlayerID=@PlayerID, GolfCourseID=@GolfCourseID, GolfCourseTeeID=@GolfCourseTeeID, HolesPlayedID=@HolesPlayedID, IsVarsity=@IsVarsity, Comments=@Comments WHERE GolfRoundID=@GolfRoundID"
        OnUpdated="sqlPracticeUpdated"
        DeleteCommand="DELETE FROM GolfRounds WHERE GolfRoundID=@GolfRoundID">
        <SelectParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="GolfRoundID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="PlayerID" Type="Int32" />
            <asp:Parameter Name="GolfRoundTypeID" Type="Int32" DefaultValue="1" />
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
            <asp:Parameter Name="GolfCourseTeeID" Type="Int32" />
            <asp:Parameter Name="HolesPlayedID" Type="Int32" />
            <asp:Parameter Name="DatePlayed" Type="DateTime" />
            <asp:Parameter Name="GolfRoundID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="GolfRoundID" Type="Int32" />
            <asp:Parameter Name="DatePlayed" Type="DateTime" />
            <asp:Parameter Name="PlayerID" Type="Int32" />
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
            <asp:Parameter Name="GolfCourseTeeID" Type="Int32" />
            <asp:Parameter Name="HolesPlayedID" Type="Int32" />
            <asp:Parameter Name="IsVarsity" Type="Boolean" />
            <asp:Parameter Name="Comments" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlGolfRoundInfo" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="InfoPerHoleByRound" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="GolfRoundID" Type="Int32" />
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
            <asp:Parameter Name="GolfCourseTeeID" Type="Int32" />
            <asp:Parameter Name="Gender" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPlayerList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT PlayerID, PlayerName FROM Players WHERE SchoolID=@SchoolID ORDER BY PlayerName">
        <SelectParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfCourseList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GolfCourseID, GolfCourseName FROM GolfCourses ORDER BY GolfCourseName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlGolfCourseTeeList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GolfCourseTeeID, TeeName FROM GolfCourseTees WHERE GolfCourseID=@GolfCourseID ORDER BY TeeName">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlHolesPlayedList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT HolesPlayedID, HolesPlayedName FROM HolesPlayedTypes ORDER BY HolesPlayedName">
    </asp:SqlDataSource>

</asp:Content>
