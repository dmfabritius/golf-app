<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Districts.aspx.cs" Inherits="Golf.Districts" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-8">
            <h3>District Maintenance</h3>
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

    <asp:UpdatePanel ID="updDistrictMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlDistrictMaint" runat="server">
        <asp:GridView ID="gvDistrictMaint" runat="server" AutoGenerateColumns="False" DataKeyNames="DistrictID" DataSourceID="sqlDistrictMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="true"
            OnRowDataBound="gvDistrictMaint_RowDataBound" OnRowUpdating="gvDistrictMaint_RowUpdating">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add District" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" Visible='<%# (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete" Visible='<%# (int)Session["DistrictID"] == 0 && (int)Session["InEditMode"] == 0 %>'
                            OnClientClick="javascript:return confirm('Only districts that have no associated leagues can be deleted. Are you sure you want to delete this district?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnAdd" runat="server" CommandName="Insert" CssClass="text-white hover-white" OnClick="btnAdd_Click" Visible='<%# (int)Session["DistrictID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="DistrictName" HeaderText="Name" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="DistrictDirector" HeaderText="District Director" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="Username" HeaderText="Username" ControlStyle-CssClass="form-control input-sm" />
                <asp:TemplateField HeaderText="Password">
                    <ItemTemplate>
                        <span>&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;</span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtPasswordEdit" runat="server" Text='<%# Bind("Password") %>' CssClass="form-control input-sm"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
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

    <asp:SqlDataSource ID="sqlViewStateList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT StateID, StateName FROM States WHERE (@StateID=0 OR StateID=@StateID) AND StateID > 0 ORDER BY StateName">
        <SelectParameters>
            <asp:Parameter Name="StateID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlDistrictMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT * FROM Districts WHERE (@DistrictID=0 OR DistrictID=@DistrictID) AND StateID=@StateID ORDER BY DistrictName"
        InsertCommand="INSERT INTO Districts (StateID, DistrictName) VALUES (@StateID, @DistrictName)"
        UpdateCommand="UPDATE Districts SET DistrictName=@DistrictName, Username=@Username, Password=@Password, DistrictDirector=@DistrictDirector, IsActive=@IsActive WHERE DistrictID=@DistrictID"
        DeleteCommand="DELETE FROM Districts WHERE DistrictID=@DistrictID"
        OnDeleted="sqlDistrictMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="DistrictID" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="DistrictID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="DistrictName" Type="String" DefaultValue=" (new - edit me!)" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="DistrictID" Type="Int32" />
            <asp:Parameter Name="DistrictName" Type="String" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="DistrictDirector" Type="String" />
            <asp:Parameter Name="IsActive" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
