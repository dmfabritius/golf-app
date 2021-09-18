<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Players.aspx.cs" Inherits="Golf.Players" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-8">
            <h3>Player Maintenance</h3>
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
    <asp:Panel ID="pnlSelGender" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddGenders" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddViewGenders">Select a gender:</label>
            <asp:DropDownList ID="ddViewGenders" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewGenderList" DataTextField="GenderName" DataValueField="GenderID" OnSelectedIndexChanged="ddGenders_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelActive" runat="server" Visible="True" CssClass="form-group">
        <asp:UpdatePanel ID="updddActives" runat="server"><ContentTemplate>
            <label class="control-label col-sm-2" for="ddActives">Show inactive?</label>
            <asp:DropDownList ID="ddActives" runat="server" AutoPostBack="True" CssClass="form-control mini"
                DataSourceID="sqlViewActiveList" DataTextField="ActiveName" DataValueField="ActiveID" OnSelectedIndexChanged="ddActives_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <asp:UpdatePanel ID="updPlayerMaint" runat="server"><ContentTemplate><asp:Panel ID="pnlPlayerMaint" runat="server">
        <asp:GridView ID="gvPlayerMaint" runat="server" AutoGenerateColumns="False" DataKeyNames="PlayerID" DataSourceID="sqlPlayerMaint"
            CellPadding="-1" ForeColor="#333333" GridLines="None" ShowFooter="true" OnRowDataBound="gvPlayerRowDataBound" OnRowUpdating="gvPlayerRowUpdating">
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#E3EAEB" />
            <AlternatingRowStyle BackColor="#FFFFFF" />
            <EditRowStyle BackColor="#8E5F41" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="False" />
            <EmptyDataTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add Player" OnClick="btnAdd_Click" CssClass="btn btn-sm btn-warning btn-shift" />
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit"><span class="glyphicon glyphicon-edit text-warning"></span></asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                            OnClientClick="javascript:return confirm('Only players that have no associated golf rounds can be deleted. Are you sure you want to delete this player?')">
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
                <asp:BoundField DataField="PlayerName" HeaderText="Player Name" ControlStyle-CssClass="form-control input-sm" />
                <asp:TemplateField HeaderText="Grad Year">
                    <ItemTemplate>
                        <span><%# Eval("GraduationYear") %></span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddGradYear" runat="server" CssClass="form-control input-sm mini" />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Gender">
                    <ItemTemplate>
                        <span><%# Eval("Gender") %></span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddGender" runat="server" CssClass="form-control input-sm mini"
                            DataSourceID="sqlGenderList" DataTextField="GenderName" DataValueField="Gender" SelectedValue='<%# Bind("Gender") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CellNumber" HeaderText="Cell Phone" ControlStyle-CssClass="form-control input-sm" />
                <asp:BoundField DataField="EmailAddress" HeaderText="Email Address" ControlStyle-CssClass="form-control input-sm" />
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
    <asp:SqlDataSource ID="sqlViewGenderList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT GenderID='A', GenderName='(All Genders)' UNION SELECT GenderID='M', GenderName='Male' UNION SELECT GenderID='F', GenderName='Female'">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewActiveList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT ActiveID=0, ActiveName='No, don''t show inactive' UNION SELECT ActiveID=1, ActiveName='Yes, show inactive'">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPlayerMaint" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>"
        SelectCommand="SELECT * FROM Players WHERE SchoolID=@SchoolID AND (@GenderID='A' OR @GenderID=Gender) AND (@ActiveID=1 OR IsActive=1) ORDER BY PlayerName"
        InsertCommand="INSERT INTO Players (SchoolID, PlayerName, GraduationYear) VALUES (@SchoolID, @PlayerName, @GraduationYear)"
        OnInserting="sqlPlayerInserting"
        UpdateCommand="UPDATE Players SET PlayerName=@PlayerName, GraduationYear=@GraduationYear, Gender=@Gender, CellNumber=@CellNumber, EmailAddress=@EmailAddress, IsActive=@IsActive WHERE PlayerID=@PlayerID"
        DeleteCommand="DELETE FROM Players WHERE PlayerID=@PlayerID"
        OnDeleted="sqlPlayerMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="GenderID" ControlID="ddViewGenders" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter Name="ActiveID" ControlID="ddActives" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="PlayerID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="SchoolID" ControlID="ddSchools" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="PlayerName" Type="String" DefaultValue=" (new - edit me!)" />
            <asp:Parameter Name="GraduationYear" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="PlayerID" Type="Int32" />
            <asp:Parameter Name="PlayerName" Type="String" />
            <asp:Parameter Name="GraduationYear" Type="Int32" />
            <asp:Parameter Name="Gender" Type="String" />
            <asp:Parameter Name="CellNumber" Type="String" />
            <asp:Parameter Name="EmailAddress" Type="String" />
            <asp:Parameter Name="IsActive" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlGenderList" runat="server" ConnectionString="<%$ ConnectionStrings:GolfDb %>" 
        SelectCommand="SELECT Gender=NULL, GenderName='-' UNION SELECT Gender='M', GenderName='Male' UNION SELECT Gender='F', GenderName='Female'">
    </asp:SqlDataSource>

</asp:Content>
