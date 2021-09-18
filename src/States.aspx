<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="States.aspx.cs" Inherits="Golf.States" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-8">
            <h3>State Maintenance</h3>
        </div>
        <div class="col-sm-4 text-right">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <p style="padding-top:30px"><img src="img/activity.gif" alt="activity" /> accessing database...</p>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>

    <asp:UpdatePanel ID="updStateMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlStateMaint" runat="server">
        <asp:GridView ID="gvStateMaint" runat="server" AutoGenerateColumns="False" DataKeyNames="StateID" DataSourceID="sqlStateMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="true"
             OnRowDataBound="gvStateMaint_RowDataBound" OnRowUpdating="gvStateMaint_RowUpdating">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" Visible='<%# (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete" Visible='<%# (int)Eval("StateID") != 0 && (int)Session["InEditMode"] == 0 %>'
                            OnClientClick="javascript:return confirm('Only states that have no associated districts can be deleted. Are you sure you want to delete this state?')">
                            <span class="glyphicon glyphicon-trash text-warning"></span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnOK" runat="server" CommandName="Update" ToolTip="Accept edits"><span class="glyphicon glyphicon-ok text-white"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel"><span class="glyphicon glyphicon-remove text-white"></span></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:LinkButton ID="btnAdd" runat="server" CommandName="Insert" CssClass="text-white hover-white" OnClick="btnAdd_Click" Visible='<%# (int)Session["StateID"] == 0 && (int)Session["InEditMode"] == 0 %>'><span class="glyphicon glyphicon-plus"></span> Add</asp:LinkButton>
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="StateName" HeaderText="Name" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="StateAbbr" HeaderText="Abbr" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="StateDirector" HeaderText="State Director" ControlStyle-CssClass="form-control input-sm" />
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

    <asp:SqlDataSource ID="sqlStateMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT * FROM States WHERE @StateID=0 OR StateID=@StateID ORDER BY StateName"
        InsertCommand="INSERT INTO States (StateName) VALUES (@StateName)"
        UpdateCommand="UPDATE States SET StateName=@StateName, StateAbbr=@StateAbbr, Username=@Username, Password=@Password, StateDirector=@StateDirector, IsActive=@IsActive WHERE StateID=@StateID"
        DeleteCommand="DELETE FROM States WHERE StateID = @StateID"
        OnDeleted="sqlStateMaint_Deleted">
        <SelectParameters>
            <asp:Parameter Name="StateID" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="StateID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="StateName" Type="String" DefaultValue=" (new - edit me!)" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="StateID" Type="Int32" />
            <asp:Parameter Name="StateName" Type="String" />
            <asp:Parameter Name="StateAbbr" Type="String" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="StateDirector" Type="String" />
            <asp:Parameter Name="IsActive" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
