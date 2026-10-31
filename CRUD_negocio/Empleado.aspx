
<%@ Page Title="Panel del empleado" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Empleado.aspx.cs" Inherits="CRUD_negocio.Empleado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="mb-4">
            <h1 class="fw-bold">Panel del empleado</h1>
            <p class="text-muted">
                Bienvenido. Desde aquí puedes gestionar los pedidos de JA Solutions.
            </p>
        </div>

        <div class="row g-4 mb-4">

            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Gestión de pedidos</h5>
                        <p class="text-muted">
                            Consulta las compras de los clientes y actualiza sus estados.
                        </p>
                        <a href="#pedidos" class="btn btn-primary">
                            Ver pedidos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Catálogo de productos</h5>
                        <p class="text-muted">
                            Consulta los productos disponibles en la tienda.
                        </p>
                        <a href="Productos.aspx" class="btn btn-outline-dark">
                            Ver productos
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <asp:Label ID="lblMensaje" runat="server"
            Visible="false"
            CssClass="alert alert-info d-block">
        </asp:Label>

        <div id="pedidos" class="card shadow-sm border-0">
            <div class="card-body">

                <h4 class="fw-bold mb-3">Pedidos de los clientes</h4>

                <div class="table-responsive">

                    <asp:GridView ID="gvPedidos" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-bordered table-hover align-middle"
                        EmptyDataText="No hay pedidos registrados."
                        OnRowCommand="gvPedidos_RowCommand">

                        <Columns>

                            <asp:BoundField DataField="IdPedido"
                                HeaderText="N.º Pedido" />

                            <asp:BoundField DataField="Cliente"
                                HeaderText="Cliente" />

                            <asp:BoundField DataField="Telefono"
                                HeaderText="Teléfono" />

                            <asp:BoundField DataField="Fecha"
                                HeaderText="Fecha"
                                DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                            <asp:BoundField DataField="Total"
                                HeaderText="Total"
                                DataFormatString="{0:C0}" />

                            <asp:BoundField DataField="Estado"
                                HeaderText="Estado actual" />

                            <asp:TemplateField HeaderText="Cambiar estado">
                                <ItemTemplate>

                                    <asp:DropDownList ID="ddlEstado" runat="server"
                                        CssClass="form-select mb-2"
                                        SelectedValue='<%# Eval("Estado") %>'>

                                        <asp:ListItem Text="Pendiente" Value="Pendiente" />
                                        <asp:ListItem Text="Procesando" Value="Procesando" />
                                        <asp:ListItem Text="Enviado" Value="Enviado" />
                                        <asp:ListItem Text="Entregado" Value="Entregado" />
                                        <asp:ListItem Text="Cancelado" Value="Cancelado" />

                                    </asp:DropDownList>

                                    <asp:Button ID="btnActualizarEstado" runat="server"
                                        Text="Guardar"
                                        CssClass="btn btn-success btn-sm"
                                        CommandName="ActualizarEstado"
                                        CommandArgument='<%# Eval("IdPedido") %>' />

                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Detalles">
                                <ItemTemplate>

                                    <asp:Button ID="btnVerDetalles" runat="server"
                                        Text="Ver productos"
                                        CssClass="btn btn-primary btn-sm"
                                        CommandName="VerDetalles"
                                        CommandArgument='<%# Eval("IdPedido") %>' />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>
            </div>
        </div>

        <asp:Panel ID="pnlDetalles" runat="server"
            Visible="false" CssClass="card shadow-sm border-0 mt-4">

            <div class="card-body">

                <h4 class="fw-bold mb-3">
                    Productos del pedido
                    <asp:Label ID="lblNumeroPedido" runat="server"></asp:Label>
                </h4>

                <div class="table-responsive">

                    <asp:GridView ID="gvDetalles" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-bordered table-hover align-middle"
                        EmptyDataText="No hay productos en este pedido.">

                        <Columns>

                            <asp:BoundField DataField="Nombre"
                                HeaderText="Producto" />

                            <asp:BoundField DataField="Cantidad"
                                HeaderText="Cantidad" />

                            <asp:BoundField DataField="Precio"
                                HeaderText="Precio unitario"
                                DataFormatString="{0:C0}" />

                            <asp:BoundField DataField="Subtotal"
                                HeaderText="Subtotal"
                                DataFormatString="{0:C0}" />

                        </Columns>

                    </asp:GridView>

                </div>

            </div>

        </asp:Panel>

    </div>

</asp:Content>
