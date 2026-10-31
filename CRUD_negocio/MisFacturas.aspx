
<%@ Page Title="Mis facturas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MisFacturas.aspx.cs" Inherits="CRUD_negocio.MisFacturas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <h1 class="fw-bold mb-2">Mis facturas</h1>
        <p class="text-muted mb-4">
            Consulta las facturas generadas por tus compras y revisa su estado de pago.
        </p>

        <asp:Label ID="lblMensaje" runat="server"
            Visible="false"
            CssClass="alert alert-info d-block">
        </asp:Label>

        <div class="card shadow-sm border-0">
            <div class="card-body">

                <h5 class="fw-bold mb-3">Historial de facturación</h5>

                <div class="table-responsive">

                    <asp:GridView ID="gvFacturas" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-bordered table-hover align-middle"
                        EmptyDataText="Todavía no tienes facturas registradas."
                        DataKeyNames="IdFactura">

                        <Columns>

                            <asp:BoundField DataField="IdFactura"
                                HeaderText="N.º Factura" />

                            <asp:BoundField DataField="IdPedido"
                                HeaderText="N.º Pedido" />

                            <asp:BoundField DataField="Fecha"
                                HeaderText="Fecha"
                                DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                            <asp:BoundField DataField="Total"
                                HeaderText="Total"
                                DataFormatString="{0:C0}" />

                            <asp:TemplateField HeaderText="Estado de pago">
                                <ItemTemplate>

                                    <asp:Label ID="lblEstado" runat="server"
                                        Text='<%# Eval("EstadoPago") %>'
                                        CssClass='<%# ObtenerClaseEstado(Eval("EstadoPago").ToString()) %>'>
                                    </asp:Label>

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>
        </div>

        <div class="mt-4">
            <a href="MisPedidos.aspx" class="btn btn-outline-dark">
                Volver a mis pedidos
            </a>

            <a href="Productos.aspx" class="btn btn-primary">
                Seguir comprando
            </a>
        </div>

    </div>

</asp:Content>
