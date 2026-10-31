
<%@ Page Title="Gestión de Pedidos" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="GestionPedidos.aspx.cs"
    Inherits="CRUD_negocio.GestionPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold">Gestión de Pedidos</h2>
                <p class="text-muted">Consulta y administra los pedidos de los clientes.</p>
            </div>

            <a href="Admin.aspx" class="btn btn-outline-dark">
                Volver al panel
            </a>
        </div>

        <asp:Label ID="lblMensaje" runat="server"
            CssClass="d-block mb-3 fw-semibold"></asp:Label>

        <!-- LISTADO DE PEDIDOS -->
        <div class="card shadow-sm border-0 mb-4">

            <div class="card-header bg-dark text-white py-3">
                <h5 class="mb-0">Pedidos registrados</h5>
            </div>

            <div class="card-body">

                <div class="table-responsive">

                    <asp:GridView ID="gvPedidos" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover table-bordered align-middle"
                        DataKeyNames="IdPedido"
                        OnRowCommand="gvPedidos_RowCommand"
                        EmptyDataText="No hay pedidos registrados."
                        GridLines="None">

                        <Columns>

                            <asp:BoundField DataField="IdPedido"
                                HeaderText="Pedido" />

                            <asp:BoundField DataField="Cliente"
                                HeaderText="Cliente" />

                            <asp:BoundField DataField="Telefono"
                                HeaderText="Teléfono" />

                            <asp:BoundField DataField="Empleado"
                                HeaderText="Empleado asignado" />

                            <asp:BoundField DataField="Fecha"
                                HeaderText="Fecha"
                                DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                            <asp:BoundField DataField="Total"
                                HeaderText="Total"
                                DataFormatString="{0:C}" />

                            <asp:TemplateField HeaderText="Estado">
                                <ItemTemplate>
                                    <span class="badge bg-secondary">
                                        <%# Eval("Estado") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnVerDetalles" runat="server"
                                        Text="Ver productos"
                                        CssClass="btn btn-sm btn-outline-primary"
                                        CommandName="VerDetalles"
                                        CommandArgument='<%# Eval("IdPedido") %>'
                                        CausesValidation="false" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>
        </div>

        <!-- ACTUALIZAR PEDIDO -->
        <div class="card shadow-sm border-0 mb-4">

            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold">Actualizar pedido</h5>
            </div>

            <div class="card-body">

                <div class="row g-3 align-items-end">

                    <div class="col-md-3">
                        <label class="form-label">Número de pedido</label>
                        <asp:TextBox ID="txtIdPedido" runat="server"
                            CssClass="form-control" ReadOnly="true"
                            placeholder="Selecciona un pedido"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Empleado responsable</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server"
                            CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Estado del pedido</label>
                        <asp:DropDownList ID="ddlEstado" runat="server"
                            CssClass="form-select">
                            <asp:ListItem Text="Pendiente" Value="Pendiente" />
                            <asp:ListItem Text="Procesando" Value="Procesando" />
                            <asp:ListItem Text="Enviado" Value="Enviado" />
                            <asp:ListItem Text="Entregado" Value="Entregado" />
                            <asp:ListItem Text="Cancelado" Value="Cancelado" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <asp:Button ID="btnActualizar" runat="server"
                            Text="Guardar cambios"
                            CssClass="btn btn-dark w-100"
                            OnClick="btnActualizar_Click" />
                    </div>

                </div>

            </div>
        </div>

        <!-- DETALLES DEL PEDIDO -->
        <asp:Panel ID="pnlDetalles" runat="server"
            Visible="false">

            <div class="card shadow-sm border-0">

                <div class="card-header bg-dark text-white py-3">
                    <h5 class="mb-0">
                        Productos del pedido
                        <asp:Label ID="lblNumeroPedido" runat="server"></asp:Label>
                    </h5>
                </div>

                <div class="card-body">

                    <div class="table-responsive">

                        <asp:GridView ID="gvDetalles" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table table-bordered table-hover"
                            EmptyDataText="Este pedido no tiene productos."
                            GridLines="None">

                            <Columns>

                                <asp:BoundField DataField="Nombre"
                                    HeaderText="Producto" />

                                <asp:BoundField DataField="Categoria"
                                    HeaderText="Categoría" />

                                <asp:BoundField DataField="Cantidad"
                                    HeaderText="Cantidad" />

                                <asp:BoundField DataField="Precio"
                                    HeaderText="Precio unitario"
                                    DataFormatString="{0:C}" />

                                <asp:BoundField DataField="Subtotal"
                                    HeaderText="Subtotal"
                                    DataFormatString="{0:C}" />

                            </Columns>

                        </asp:GridView>

                    </div>

                </div>
            </div>

        </asp:Panel>

    </div>

</asp:Content>
