
<%@ Page Title="Mis pedidos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MisPedidos.aspx.cs" Inherits="CRUD_negocio.MisPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <h1 class="fw-bold mb-2">Mis pedidos</h1>
        <p class="text-muted mb-4">
            Consulta tus compras y revisa el estado de cada pedido.
        </p>

        <asp:Label ID="lblMensaje" runat="server"
            Visible="false"
            CssClass="alert alert-info d-block">
        </asp:Label>

        <div class="card shadow-sm border-0">
            <div class="card-body">

                <h5 class="fw-bold mb-3">Historial de compras</h5>

                <div class="table-responsive">

                    <asp:GridView ID="gvPedidos" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover table-bordered align-middle"
                        EmptyDataText="Todavía no tienes pedidos registrados."
                        DataKeyNames="IdPedido"
                        OnRowCommand="gvPedidos_RowCommand">

                        <Columns>

                            <asp:BoundField DataField="IdPedido"
                                HeaderText="N.º Pedido" />

                            <asp:BoundField DataField="Fecha"
                                HeaderText="Fecha"
                                DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                            <asp:BoundField DataField="Total"
                                HeaderText="Total"
                                DataFormatString="{0:C0}" />

                            <asp:BoundField DataField="Estado"
                                HeaderText="Estado" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:Button ID="btnDetalles" runat="server"
                                        Text="Ver detalles"
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

        <!-- Detalles del pedido seleccionado -->
        <asp:Panel ID="pnlDetalles" runat="server"
            Visible="false" CssClass="card shadow-sm border-0 mt-4">

            <div class="card-body">

                <h5 class="fw-bold mb-3">
                    Detalles del pedido
                    <asp:Label ID="lblNumeroPedido" runat="server"></asp:Label>
                </h5>

                <div class="table-responsive">

                    <asp:GridView ID="gvDetalles" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-bordered table-hover align-middle"
                        EmptyDataText="No hay productos registrados.">

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

        <div class="mt-4">
            <a href="Productos.aspx" class="btn btn-outline-dark">
                Seguir comprando
            </a>
        </div>

    </div>

</asp:Content>
