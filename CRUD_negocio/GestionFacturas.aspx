
<%@ Page Title="Gestión de Facturas" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="GestionFacturas.aspx.cs"
    Inherits="CRUD_negocio.GestionFacturas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold">Gestión de Facturas</h2>
                <p class="text-muted">
                    Consulta las facturas y administra sus estados de pago.
                </p>
            </div>

            <a href="Admin.aspx" class="btn btn-outline-dark">
                Volver al panel
            </a>
        </div>

        <asp:Label ID="lblMensaje" runat="server"
            CssClass="d-block mb-3 fw-semibold"></asp:Label>

        <!-- TABLA DE FACTURAS -->
        <div class="card shadow-sm border-0 mb-4">

            <div class="card-header bg-dark text-white py-3">
                <h5 class="mb-0">Facturas registradas</h5>
            </div>

            <div class="card-body">

                <div class="table-responsive">

                    <asp:GridView ID="gvFacturas" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-hover table-bordered align-middle"
                        DataKeyNames="IdFactura"
                        OnRowCommand="gvFacturas_RowCommand"
                        EmptyDataText="No hay facturas registradas."
                        GridLines="None">

                        <Columns>

                            <asp:BoundField DataField="IdFactura"
                                HeaderText="Factura" />

                            <asp:BoundField DataField="IdPedido"
                                HeaderText="Pedido" />

                            <asp:BoundField DataField="Cliente"
                                HeaderText="Cliente" />

                            <asp:BoundField DataField="Fecha"
                                HeaderText="Fecha"
                                DataFormatString="{0:dd/MM/yyyy HH:mm}" />

                            <asp:BoundField DataField="Total"
                                HeaderText="Total"
                                DataFormatString="{0:C}" />

                            <asp:TemplateField HeaderText="Estado de pago">
                                <ItemTemplate>
                                    <span class='<%# ObtenerClaseEstado(Eval("EstadoPago").ToString()) %>'>
                                        <%# Eval("EstadoPago") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:LinkButton ID="btnGestionar" runat="server"
                                        Text="Gestionar"
                                        CssClass="btn btn-sm btn-dark"
                                        CommandName="GestionarFactura"
                                        CommandArgument='<%# Eval("IdFactura") %>'
                                        CausesValidation="false" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>
        </div>

        <!-- ACTUALIZAR ESTADO -->
        <asp:Panel ID="pnlGestion" runat="server" Visible="false">

            <div class="card shadow-sm border-0">

                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold">Actualizar factura</h5>
                </div>

                <div class="card-body">

                    <div class="row g-3 align-items-end">

                        <div class="col-md-4">
                            <label class="form-label">Número de factura</label>
                            <asp:TextBox ID="txtIdFactura" runat="server"
                                CssClass="form-control" ReadOnly="true">
                            </asp:TextBox>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Estado de pago</label>
                            <asp:DropDownList ID="ddlEstadoPago" runat="server"
                                CssClass="form-select">
                                <asp:ListItem Text="Pendiente" Value="Pendiente" />
                                <asp:ListItem Text="Pagada" Value="Pagada" />
                                <asp:ListItem Text="Anulada" Value="Anulada" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <asp:Button ID="btnActualizar" runat="server"
                                Text="Guardar cambios"
                                CssClass="btn btn-dark w-100"
                                OnClick="btnActualizar_Click" />
                        </div>

                    </div>

                </div>
            </div>

        </asp:Panel>

    </div>

</asp:Content>
