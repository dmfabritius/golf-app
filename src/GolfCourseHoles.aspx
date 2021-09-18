<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GolfCourseHoles.aspx.cs" Inherits="Golf.MaintGolfCourseHoles" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        th{text-align:right !important}
        th.onleft{text-align:left !important}
        input[type=text] {margin:0;padding:0 0 0 5px;height:1.8em}
        th,td{padding:3px 2px}
        #MainContent_gvTeeSchools td,
        #MainContent_gvTeeSchools th {padding:2px 9px}
        .info-width{min-width:100px !important;width:100px !important}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-8">
            <h3>Golf Course Hole Maintenance</h3>
        </div>
        <div class="col-sm-4 text-right">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <p style="padding-top:30px"><img src="img/activity.gif" alt="activity" /> accessing database...</p>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>

    <asp:Panel ID="pnlSelCourse" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddCourses" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddCourses">Select a course:</label>
            <asp:DropDownList ID="ddCourses" runat="server" AutoPostBack="True" CssClass="form-control mini col-sm-10"
                DataSourceID="sqlViewCourseList" DataTextField="GolfCourseName" DataValueField="GolfCourseID" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <asp:UpdatePanel ID="updCourseMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlCourseMaint" runat="server">
        <asp:GridView ID="gvCourseMaint" runat="server" AutoGenerateColumns="False" DataSourceID="sqlCourseMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None"
            OnRowDataBound="gvCourseMaint_RowDataBound" OnRowUpdating="gvCourseRowUpdating">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" ForeColor="White" Font-Bold="True" />
            <Columns>
                <asp:TemplateField ItemStyle-Width="55px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Info"   ReadOnly="True" ItemStyle-CssClass="info-width" />
                <asp:BoundField DataField= "1"     HeaderText="1"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "2"     HeaderText="2"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "3"     HeaderText="3"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "4"     HeaderText="4"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "5"     HeaderText="5"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "6"     HeaderText="6"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "7"     HeaderText="7"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "8"     HeaderText="8"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "9"     HeaderText="9"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "Out"   HeaderText="Out"   ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField="10"     HeaderText="10"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="11"     HeaderText="11"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="12"     HeaderText="12"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="13"     HeaderText="13"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="14"     HeaderText="14"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="15"     HeaderText="15"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="16"     HeaderText="16"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="17"     HeaderText="17"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="18"     HeaderText="18"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="In"     HeaderText="In"    ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField= "Total" HeaderText="Total" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

    <br />
    <asp:UpdatePanel ID="updCourseYardageMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlCourseYardageMaint" runat="server">
        <asp:GridView ID="gvCourseYardageMaint" runat="server" AutoGenerateColumns="False" DataSourceID="sqlCourseYardageMaint" DataKeyNames="GolfCourseTeeID"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True"
            OnRowDataBound="gvCourseYardageMaint_RowDataBound" OnRowUpdating="gvCourseYardageRowUpdating">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="false" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add District" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField ItemStyle-Width="55px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'
                            OnClientClick="javascript:return confirm('Only tees that have not been used in a round of golf and are not being used as the default tee for a school can be deleted. Are you sure you want to delete this tee?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnAdd" runat="server" CssClass="text-white hover-white" OnClick="btnAdd_Click" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TeeName" HeaderText="Tee"  HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="text-left" ItemStyle-CssClass="info-width" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "1"     HeaderText="1"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "2"     HeaderText="2"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "3"     HeaderText="3"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "4"     HeaderText="4"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "5"     HeaderText="5"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "6"     HeaderText="6"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "7"     HeaderText="7"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "8"     HeaderText="8"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "9"     HeaderText="9"     ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField= "Out"   HeaderText="Out"   ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField="10"     HeaderText="10"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="11"     HeaderText="11"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="12"     HeaderText="12"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="13"     HeaderText="13"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="14"     HeaderText="14"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="15"     HeaderText="15"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="16"     HeaderText="16"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="17"     HeaderText="17"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="18"     HeaderText="18"    ItemStyle-Width="45px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="In"     HeaderText="In"    ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField= "Total" HeaderText="Total" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ReadOnly="true" ItemStyle-ForeColor="#8E5F41" />
                <asp:BoundField DataField="GolfCourseTeeID" Visible="false" ReadOnly="true" />
                <asp:TemplateField HeaderText="Active" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Active" runat="server" Text='<%# ((bool)Eval("IsActive"))? "Y" : "-" %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="cbIsActive" runat="server" Checked='<%# Bind("IsActive") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

    <br />
    <asp:UpdatePanel ID="updTeeSchools" runat="server"><ContentTemplate><asp:Panel ID="pnlTeeSchools" runat="server">
        <asp:GridView ID="gvTeeSchools" runat="server" AutoGenerateColumns="False" DataSourceID="sqlTeeSchools"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" OnRowDataBound="gvTeeSchools_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="false" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="SchoolName" HeaderText="School" FooterText="Schools using this tee as their default" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="LeagueName" HeaderText="League" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="DistrictName" HeaderText="District" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="StateAbbr" HeaderText="State" HeaderStyle-CssClass="onleft" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>


    <asp:SqlDataSource ID="sqlViewCourseList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GolfCourseID, GolfCourseName FROM GolfCourses ORDER BY GolfCourseName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlCourseMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="GolfCourseMaintSelect" SelectCommandType="StoredProcedure"
        UpdateCommand="SELECT 1 --placeholder update command is necessary for proper functioning of the gridview">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddCourses" Name="GolfCourseID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sqlCourseYardageMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="YardagePerHoleByCourseTee" SelectCommandType="StoredProcedure"
        InsertCommand="INSERT INTO GolfCourseTees (GolfCourseID,TeeName) VALUES (@GolfCourseID,' (new - edit me!)'); SELECT @GolfCourseTeeID = SCOPE_IDENTITY()"
        OnInserted="sqlCourseYardageInserted"
        UpdateCommand="SELECT 1 --placeholder update command is necessary for proper functioning of the gridview"
        DeleteCommand="DELETE FROM GolfCourseTees WHERE GolfCourseTeeID=@GolfCourseTeeID"
        OnDeleted="sqlCourseYardageMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddCourses" Name="GolfCourseID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddCourses" Name="GolfCourseID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="GolfCourseTeeID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvCourseYardageMaint" Name="GolfCourseTeeID" PropertyName="SelectedDataKey" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlTeeSchools" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT SchoolName, LeagueName, DistrictName, StateAbbr FROM GolfCourseTees T INNER JOIN Schools S ON S.DefaultGolfCourseTeeID=T.GolfCourseTeeID INNER JOIN Leagues L ON L.LeagueID=S.LeagueID INNER JOIN Districts D ON D.DistrictID=L.DistrictID INNER JOIN States ST ON ST.StateID=D.StateID WHERE T.GolfCourseTeeID=@GolfCourseTeeID">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseTeeID" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
