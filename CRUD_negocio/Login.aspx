<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CRUD_negocio.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <div class="container mt-5 mb-5">
            <div class="row justify-content-center">
                <div class="col-md-5 card p-5 shadow-lg rounded-5">

                    <div class="d-flex align-items-center gap-3 mb-4">

                        <!-- Logo -->
                        <img src="Content/LOGO.png"
                            width="65"
                            height="65"
                            alt="JA Solutions"
                            class="object-fit-contain" />

                        <!-- Textos -->
                        <div>
                            <h4 class="mb-1 fw-bold">Hola de nuevo</h4>

                            <p class="mb-0 text-muted fw-semibold">
                                Bienvenido de nuevo a JA Solutions
                            </p>
                        </div>

                    </div>
                    <asp:ValidationSummary ID="ValidationSummary1"
                        runat="server"
                        CssClass="text-danger mb-3"
                        ValidationGroup="Login" />
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mb-3">
                                <asp:Label ID="lbl_usuario" runat="server"
                                    Text="Nombre de usuario" CssClass="form-label"></asp:Label>

                                <asp:TextBox ID="txt_usuario" CssClass="form-control"
                                    runat="server" placeholder="joseariza24"
                                    MaxLength="16"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                    runat="server" ErrorMessage="El usuario es obligatorio"
                                    ControlToValidate="txt_usuario"
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="Logn"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Contraseña -->
                            <div class="mb-5">
                                <asp:Label ID="lbl_contrasena" runat="server"
                                    Text="Contraseña" CssClass="form-label"></asp:Label>

                                <asp:TextBox ID="txt_contrasena" CssClass="form-control"
                                    runat="server" TextMode="Password"
                                    placeholder="ingresa tu contraseña"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                    runat="server" ErrorMessage="La contraseña es obligatoria"
                                    ControlToValidate="txt_contrasena"
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="Login"></asp:RequiredFieldValidator>
                            </div>
                            <!-- Botón registrar -->
                            <div class="d-grid">
                                <asp:Button ID="btn_ingresar" runat="server"
                                    Text="Entrar"
                                    CssClass="btn btn-dark btn-lg rounded-4 fw-semibold"
                                    OnClick="btn_ingresar_Click"
                                    ValidationGroup="Login" />
                            </div>
                            <div class="mt-4 justify-content-center">
                                <p class="text-muted text-center fw-semibold">¿Nuevo en JA solution? <span><a class="text-dark text-decoration-none fw-semibold" href="Registro.aspx">Crear Cuenta</a></span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
