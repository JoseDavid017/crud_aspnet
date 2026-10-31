
<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="CRUD_negocio.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5 mb-5">

        <div class="row justify-content-center">
            <div class="col-md-5 card p-5 shadow-lg rounded-4">


                <div class="d-flex align-items-center gap-3 mb-4">

                    <!-- Logo -->
                    <img src="Content/LOGO.png"
                        width="65"
                        height="65"
                        alt="JA Solutions"
                        class="object-fit-contain" />

                    <!-- Textos -->
                    <div>
                        <h4 class="mb-1 fw-bold">Crear Cuenta</h4>

                        <p class="mb-0 text-muted fw-semibold">
                            Registrate en JA solutions
                        </p>
                    </div>

                </div>


                <asp:ValidationSummary ID="ValidationSummary1"
                    runat="server"
                    CssClass="text-danger mb-3"
                    ValidationGroup="Registro" />

                <!-- Nombre y apellido -->
                <div class="row">

                    <div class="col-md-6">
                        <div class="mb-3">
                            <asp:Label CssClass="form-label" ID="lbl_nombre"
                                runat="server" Text="Nombre"></asp:Label>

                            <asp:TextBox CssClass="form-control text-capitalize"
                                ID="txt_nombre" runat="server"
                                placeholder="Jose" MaxLength="24"></asp:TextBox>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                runat="server" ErrorMessage="El nombre es obligatorio"
                                ControlToValidate="txt_nombre"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="Registro"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <asp:Label ID="lbl_apellido" CssClass="form-label"
                                runat="server" Text="Apellido"></asp:Label>

                            <asp:TextBox ID="txt_apellido"
                                CssClass="form-control text-capitalize"
                                placeholder="Ariza" runat="server"
                                MaxLength="24"></asp:TextBox>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                runat="server" ErrorMessage="El apellido es obligatorio"
                                ControlToValidate="txt_apellido"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="Registro"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                </div>

                <!-- Documento y teléfono -->
                <div class="row">

                    <div class="col-md-6">
                        <div class="mb-3">
                            <asp:Label ID="lbl_documento"
                                CssClass="form-label" runat="server"
                                Text="Documento"></asp:Label>

                            <asp:TextBox ID="txt_documento"
                                CssClass="form-control" runat="server"
                                placeholder="1234567890" MaxLength="10"></asp:TextBox>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4"
                                runat="server" ErrorMessage="El documento es obligatorio"
                                ControlToValidate="txt_documento"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="Registro"></asp:RequiredFieldValidator>

                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2"
                                runat="server" ErrorMessage="Documento inválido (6 a 10 dígitos)"
                                ControlToValidate="txt_documento"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationExpression="^[0-9]{6,10}$"
                                ValidationGroup="Registro"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <asp:Label ID="lbl_telefono"
                                CssClass="form-label" runat="server"
                                Text="Teléfono"></asp:Label>

                            <asp:TextBox ID="txt_telefono"
                                CssClass="form-control" runat="server"
                                placeholder="3001234567" MaxLength="10"></asp:TextBox>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5"
                                runat="server" ErrorMessage="El teléfono es obligatorio"
                                ControlToValidate="txt_telefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationGroup="Registro"></asp:RequiredFieldValidator>

                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3"
                                runat="server" ErrorMessage="El teléfono debe tener 10 dígitos"
                                ControlToValidate="txt_telefono"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidationExpression="^[0-9]{10}$"
                                ValidationGroup="Registro"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                </div>

                <!-- Correo -->
                <div class="mb-3">
                    <asp:Label ID="lbl_correo" runat="server"
                        Text="Correo electrónico" CssClass="form-label"></asp:Label>

                    <asp:TextBox ID="txt_correo" CssClass="form-control"
                        runat="server" placeholder="example@example.com"
                        MaxLength="32"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3"
                        runat="server" ErrorMessage="El correo es obligatorio"
                        ControlToValidate="txt_correo"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="Registro"></asp:RequiredFieldValidator>

                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1"
                        runat="server" ErrorMessage="Correo electrónico inválido"
                        ControlToValidate="txt_correo"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationExpression="^[^\s@]+@[^\s@]+\.[^\s@]+$"
                        ValidationGroup="Registro"></asp:RegularExpressionValidator>
                </div>

                <hr />

                <h5 class="mb-3">Datos de acceso</h5>

                <!-- Usuario -->
                <div class="mb-3">
                    <asp:Label ID="lbl_usuario" runat="server"
                        Text="Nombre de usuario" CssClass="form-label"></asp:Label>

                    <asp:TextBox ID="txt_usuario" CssClass="form-control"
                        runat="server" placeholder="joseariza24"
                        MaxLength="16"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6"
                        runat="server" ErrorMessage="El usuario es obligatorio"
                        ControlToValidate="txt_usuario"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="Registro"></asp:RequiredFieldValidator>
                </div>

                <!-- Contraseña -->
                <div class="mb-3">
                    <asp:Label ID="lbl_contrasena" runat="server"
                        Text="Contraseña" CssClass="form-label"></asp:Label>

                    <asp:TextBox ID="txt_contrasena" CssClass="form-control"
                        runat="server" TextMode="Password"
                        placeholder="Crea una contraseña"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7"
                        runat="server" ErrorMessage="La contraseña es obligatoria"
                        ControlToValidate="txt_contrasena"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="Registro"></asp:RequiredFieldValidator>
                </div>

                <!-- Confirmar contraseña -->
                <div class="mb-4">
                    <asp:Label ID="lbl_confirmar" runat="server"
                        Text="Confirmar contraseña" CssClass="form-label"></asp:Label>

                    <asp:TextBox ID="txt_confirmar" CssClass="form-control"
                        runat="server" TextMode="Password"
                        placeholder="Repite tu contraseña"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8"
                        runat="server" ErrorMessage="Confirma tu contraseña"
                        ControlToValidate="txt_confirmar"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="Registro"></asp:RequiredFieldValidator>

                    <asp:CompareValidator ID="CompareValidator1"
                        runat="server"
                        ControlToValidate="txt_confirmar"
                        ControlToCompare="txt_contrasena"
                        ErrorMessage="Las contraseñas no coinciden"
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationGroup="Registro"></asp:CompareValidator>
                </div>

                <!-- Botón registrar -->
                <div class="d-grid">
                    <asp:Button ID="btn_registrar" runat="server"
                        Text="Registrarme"
                        CssClass="btn btn-dark btn-lg fw-semibold rounded-4"
                        OnClick="btn_registrar_Click"
                        ValidationGroup="Registro" />
                </div>

            </div>
        </div>

    </div>

</asp:Content>
