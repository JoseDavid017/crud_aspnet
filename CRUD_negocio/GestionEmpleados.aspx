
<%@ Page Title="Gestión de Empleados" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="GestionEmpleados.aspx.cs"
    Inherits="CRUD_negocio.GestionEmpleados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold">Gestión de Empleados</h2>
                <p class="text-muted">Administra los empleados de JA Solutions.</p>
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
                <h5 class="mb-0">Información del empleado</h5>
            </div>

            <div class="card-body p-4">

                <asp:HiddenField ID="hfIdEmpleado" runat="server" />

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server"
                            CssClass="form-control" MaxLength="100"
                            placeholder="Nombre del empleado"></asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Apellido</label>
                        <asp:TextBox ID="txtApellido" runat="server"
                            CssClass="form-control" MaxLength="100"
                            placeholder="Apellido del empleado"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Cargo</label>
                        <asp:TextBox ID="txtCargo" runat="server"
                            CssClass="form-control" MaxLength="100"
                            placeholder="Cargo del empleado"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Teléfono</label>
                        <asp:TextBox ID="txtTelefono" runat="server"
                            CssClass="form-control" MaxLength="30"
                            placeholder="Teléfono"></asp:TextBox>
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
                        Text="Guardar empleado"
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

        <!-- TABLA DE EMPLEADOS -->
        <div class="card shadow-sm border-0">

            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold">Empleados registrados</h5>
            </div>

            <div class="card-body">

                <div class="table-responsive">

                    <asp:GridView ID="gvEmpleados" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover table-bordered align-middle"
                        DataKeyNames="IdEmpleado"
                        OnRowCommand="gvEmpleados_RowCommand"
                        EmptyDataText="No hay empleados registrados."
                        GridLines="None">

                        <Columns>

                            <asp:BoundField DataField="IdEmpleado"
                                HeaderText="ID" />

                            <asp:BoundField DataField="Nombre"
                                HeaderText="Nombre" />

                            <asp:BoundField DataField="Apellido"
                                HeaderText="Apellido" />

                            <asp:BoundField DataField="Cargo"
                                HeaderText="Cargo" />

                            <asp:BoundField DataField="Telefono"
                                HeaderText="Teléfono" />

                            <asp:BoundField DataField="Correo"
                                HeaderText="Correo electrónico" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnEditar" runat="server"
                                        Text="Editar"
                                        CssClass="btn btn-sm btn-warning me-1"
                                        CommandName="EditarEmpleado"
                                        CommandArgument='<%# Eval("IdEmpleado") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton ID="btnEliminar" runat="server"
                                        Text="Eliminar"
                                        CssClass="btn btn-sm btn-danger"
                                        CommandName="EliminarEmpleado"
                                        CommandArgument='<%# Eval("IdEmpleado") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('¿Estás seguro de eliminar este empleado?');" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>
        </div>

    </div>

</asp:Content>
