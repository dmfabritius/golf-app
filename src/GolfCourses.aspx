<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GolfCourses.aspx.cs" Inherits="Golf.GolfCourses" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-8">
            <h3>Golf Course Maintenance</h3>
        </div>
        <div class="col-sm-4 text-right">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <p style="padding-top:30px"><img src="img/activity.gif" alt="activity" /> accessing database...</p>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>

    <asp:UpdatePanel ID="updCourseMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlCourseMaint" runat="server">
        <asp:GridView ID="gvCourseMaint" runat="server" AutoGenerateColumns="False" DataKeyNames="GolfCourseID" DataSourceID="sqlGolfCourseMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" AllowPaging="true" PageSize="12"
            OnRowDataBound="gvCourseMaint_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <PagerStyle BackColor="Wheat" Font-Bold="True" />
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'
                            OnClientClick="javascript:return confirm('Only courses that have no associated tees or rounds of golf, and are not being used as the default course for a school, can be deleted. Are you sure you want to delete this golf course?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnAdd" runat="server" CommandName="Insert" CssClass="text-white hover-white" OnClick="btnAdd_Click" Visible='<%# (int)Session["SchoolID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="GolfCourseName" HeaderText="Course Name" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="AddressLine1" HeaderText="Address" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="State" HeaderText="State" SortExpression="State" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="Zip" HeaderText="Zip" SortExpression="Zip" ControlStyle-CssClass="form-control input-sm" />
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
    <asp:UpdatePanel ID="updCourseSchools" runat="server"><ContentTemplate><asp:Panel ID="pnlCourseSchools" runat="server">
        <asp:GridView ID="gvCourseSchools" runat="server" AutoGenerateColumns="False" DataSourceID="sqlCourseSchools"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="True" OnRowDataBound="gvCourseSchools_RowDataBound">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="false" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="SchoolName" HeaderText="School" FooterText="Schools using this course as their default" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="LeagueName" HeaderText="League" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="DistrictName" HeaderText="District" HeaderStyle-CssClass="onleft" />
                <asp:BoundField DataField="StateAbbr" HeaderText="State" HeaderStyle-CssClass="onleft" />
            </Columns>
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

    <asp:SqlDataSource ID="sqlGolfCourseMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT * FROM GolfCourses ORDER BY GolfCourseName"
        InsertCommand="INSERT INTO GolfCourses (GolfCourseName) VALUES (@GolfCourseName); SELECT @GolfCourseID=SCOPE_IDENTITY()"
        OnInserted="sqlGolfCourseInserted"
        UpdateCommand="UPDATE GolfCourses SET GolfCourseName=@GolfCourseName, AddressLine1=@AddressLine1, City=@City, State=@State, Zip=@Zip, IsActive=@IsActive WHERE GolfCourseID=@GolfCourseID"
        DeleteCommand="DELETE FROM GolfCourses WHERE GolfCourseID=@GolfCourseID"
        OnDeleted="sqlGolfCourseMaint_Deleted">
        <DeleteParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="GolfCourseName" Type="String" DefaultValue=" (new - edit me!)" />
            <asp:Parameter Name="GolfCourseID" Type="Int32" Direction="Output" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32" />
            <asp:Parameter Name="GolfCourseName" Type="String" />
            <asp:Parameter Name="AddressLine1" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="State" Type="String" />
            <asp:Parameter Name="Zip" Type="String" />
            <asp:Parameter Name="IsActive" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlCourseSchools" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT SchoolName, LeagueName, DistrictName, StateAbbr FROM GolfCourses C INNER JOIN Schools S ON S.DefaultGolfCourseID=C.GolfCourseID INNER JOIN Leagues L ON L.LeagueID=S.LeagueID INNER JOIN Districts D ON D.DistrictID=L.DistrictID INNER JOIN States ST ON ST.StateID=D.StateID WHERE C.GolfCourseID=@GolfCourseID">
        <SelectParameters>
            <asp:Parameter Name="GolfCourseID" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>