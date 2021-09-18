<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Golf.Login" Async="true" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        input[type=text] {height: 34px}
    </style>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2>Log In</h2>

    <div class="input-group">
        <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
        <asp:TextBox runat="server" ID="Username" TextMode="SingleLine" CssClass="form-control" Placeholder="Username" />
    </div>
    <asp:RequiredFieldValidator runat="server" ControlToValidate="Username" CssClass="text-danger" ErrorMessage="Please enter your username." />

    <div class="input-group">
        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
        <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" Placeholder="Password" />
    </div>
    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="Please enter your password." />

    <br /><br />
    <div class="row">
        <div class="col-sm-2">
            <asp:Button runat="server" OnClick="LogIn" Text="Log in" CssClass="btn btn-warning" />
        </div>
    </div>

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger"><br /><asp:Literal runat="server" ID="FailureText" /></p>
    </asp:PlaceHolder>

</asp:Content>
