
<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="GestionClientes.aspx.cs"
    Inherits="CRUD_negocio.GestionClientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold">Gestión de Clientes</h2>
                <p class="text-muted">Administra los clientes registrados en el sistema.</p>
            </div>

            <a href="Admin.aspx" class="btn btn-outline-dark">
                Volver al panel
            </a>
        </div>

        <asp:Label ID="lblMensaje" runat="server"
            CssClass="d-block mb-3 fw-semibold"></asp:Label>

        <!-- FORMULARIO -->
        <div class="card shadow-sm border-0 mb-5">
            <div class="card-header bg-dark text-white py-3">
                <h5 class="mb-0">Información del cliente</h5>
            </div>

            <div class="card-body p-4">

                <asp:HiddenField ID="hfIdCliente" runat="server" />

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server"
                            CssClass="form-control" MaxLength="100"
                            placeholder="Nombre del cliente"></asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Apellido</label>
                        <asp:TextBox ID="txtApellido" runat="server"
                            CssClass="form-control" MaxLength="100"
                            placeholder="Apellido del cliente"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Documento</label>
                        <asp:TextBox ID="txtDocumento" runat="server"
                            CssClass="form-control" MaxLength="30"
                            placeholder="Número de documento"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Teléfono</label>
                        <asp:TextBox ID="txtTelefono" runat="server"
                            CssClass="form-control" MaxLength="30"
                            placeholder="Número de teléfono"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Correo electrónico</label>
                        <asp:TextBox ID="txtCorreo" runat="server"
                            CssClass="form-control" MaxLength="150"
                            TextMode="Email"
                            placeholder="correo@ejemplo.com"></asp:TextBox>
                    </div>

                </div>

                <div class="mt-4 d-flex gap-2">

                    <asp:Button ID="btnGuardar" runat="server"
                        Text="Guardar cliente"
                        CssClass="btn btn-dark px-4"
                        OnClick="btnGuardar_Click" />

                    <asp:Button ID="btnCancelar" runat="server"
                        Text="Cancelar"
                        CssClass="btn btn-outline-secondary"
                        OnClick="btnCancelar_Click"
                        CausesValidation="false" />

                </div>

            </div>
        </div>

        <!-- TABLA DE CLIENTES -->
        <div class="card shadow-sm border-0">

            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold">Clientes registrados</h5>
            </div>

            <div class="card-body">

                <div class="table-responsive">

                    <asp:GridView ID="gvClientes" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover table-bordered align-middle"
                        DataKeyNames="IdCliente"
                        OnRowCommand="gvClientes_RowCommand"
                        EmptyDataText="No hay clientes registrados."
                        GridLines="None">

                        <Columns>

                            <asp:BoundField DataField="IdCliente"
                                HeaderText="ID" />

                            <asp:BoundField DataField="Nombre"
                                HeaderText="Nombre" />

                            <asp:BoundField DataField="Apellido"
                                HeaderText="Apellido" />

                            <asp:BoundField DataField="Documento"
                                HeaderText="Documento" />

                            <asp:BoundField DataField="Telefono"
                                HeaderText="Teléfono" />

                            <asp:BoundField DataField="Correo"
                                HeaderText="Correo electrónico" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnEditar" runat="server"
                                        Text="Editar"
                                        CssClass="btn btn-sm btn-warning me-1"
                                        CommandName="EditarCliente"
                                        CommandArgument='<%# Eval("IdCliente") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton ID="btnEliminar" runat="server"
                                        Text="Eliminar"
                                        CssClass="btn btn-sm btn-danger"
                                        CommandName="EliminarCliente"
                                        CommandArgument='<%# Eval("IdCliente") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('¿Estás seguro de eliminar este cliente?');" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>
        </div>

    </div>

</asp:Content>
