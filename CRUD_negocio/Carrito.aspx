
<%@ Page Title="Mi carrito" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="CRUD_negocio.Carrito" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">

        <a class="navbar-brand fw-bold d-flex align-items-center" href="Default.aspx">
            <img src="/Content/LOGO.PNG" alt="JA Solutions"
                width="40" height="35" class="me-2" />
            JA Solutions
        </a>

        <button class="navbar-toggler" type="button"
            data-bs-toggle="collapse"
            data-bs-target="#menuPrincipal"
            aria-controls="menuPrincipal"
            aria-expanded="false"
            aria-label="Abrir menú">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="menuPrincipal">
            <ul class="navbar-nav ms-auto align-items-lg-center">

                <li class="nav-item">
                    <a class="nav-link" href="Default.aspx">Inicio</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="Productos.aspx">Productos</a>
                </li>

                <!-- Servicios -->
                <li class="nav-item">
                    <a class="nav-link" href="ALARMAS.aspx">Sistemas de alarmas</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="SVC.aspx">Sistemas de vigilancia</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="IMEI.aspx">Mantenimiento de equipos</a>
                </li>

                <!-- Opciones para visitantes -->
                <asp:PlaceHolder ID="MenuVisitante" runat="server">

                    <li class="nav-item">
                        <a class="nav-link" href="Login.aspx">Iniciar sesión</a>
                    </li>

                    <li class="nav-item ms-lg-2">
                        <a class="btn btn-primary" href="Registro.aspx">Regístrate</a>
                    </li>

                </asp:PlaceHolder>

                <!-- Opciones para usuarios autenticados -->
                <asp:PlaceHolder ID="MenuUsuario" runat="server" Visible="false">

                    <li class="nav-item">
                        <a class="nav-link" href="Carrito.aspx">
                            <i class="bi bi-cart3"></i> Carrito
                        </a>
                    </li>

                    <li class="nav-item">
                        <span class="nav-link fw-bold">
                            Hola,
                            <asp:Label ID="lblNombreUsuario" runat="server"></asp:Label>
                        </span>
                    </li>

                    <li class="nav-item">
                        <asp:LinkButton ID="btnCerrarSesion" runat="server"
                            CssClass="nav-link text-danger"
                            OnClick="btnCerrarSesion_Click">
                            Cerrar sesión
                        </asp:LinkButton>
                    </li>

                </asp:PlaceHolder>

            </ul>
        </div>
    </div>
</nav>

    <div class="container py-5">

        <h1 class="mb-2">Mi carrito de compras</h1>
        <p class="text-muted mb-4">Revisa los productos que deseas comprar.</p>

        <asp:Label ID="lblMensaje" runat="server"
            CssClass="alert alert-info d-block"
            Visible="false"></asp:Label>

        <asp:Panel ID="pnlCarrito" runat="server" Visible="false">

            <div class="table-responsive">
                <asp:GridView ID="gvCarrito" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table table-bordered table-hover align-middle"
                    OnRowCommand="gvCarrito_RowCommand">

                    <Columns>

                        <asp:BoundField DataField="Nombre"
                            HeaderText="Producto" />

                        <asp:BoundField DataField="Precio"
                            HeaderText="Precio"
                            DataFormatString="{0:C0}" />

                        <asp:TemplateField HeaderText="Cantidad">
                            <ItemTemplate>
                                <asp:TextBox ID="txtCantidad" runat="server"
                                    Text='<%# Eval("Cantidad") %>'
                                    TextMode="Number"
                                    min="1"
                                    CssClass="form-control"
                                    Width="85px">
                                </asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Subtotal"
                            HeaderText="Subtotal"
                            DataFormatString="{0:C0}" />

                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>

                                <asp:Button ID="btnActualizar" runat="server"
                                    Text="Actualizar"
                                    CssClass="btn btn-primary btn-sm mb-1"
                                    CommandName="Actualizar"
                                    CommandArgument='<%# Eval("IdProducto") %>' />

                                <asp:Button ID="btnEliminar" runat="server"
                                    Text="Eliminar"
                                    CssClass="btn btn-danger btn-sm"
                                    CommandName="Eliminar"
                                    CommandArgument='<%# Eval("IdProducto") %>'
                                    OnClientClick="return confirm('¿Deseas eliminar este producto?');" />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-4">

                <asp:HyperLink ID="lnkSeguirComprando" runat="server"
                    NavigateUrl="~/Productos.aspx"
                    CssClass="btn btn-outline-dark">
                    Seguir comprando
                </asp:HyperLink>

                <div class="text-end">
                    <h4>Total de la compra:</h4>
                    <h2 class="fw-bold">
                        <asp:Label ID="lblTotal" runat="server"></asp:Label>
                    </h2>

                    <asp:Button ID="btnConfirmarCompra" runat="server"
                        Text="Confirmar compra"
                        CssClass="btn btn-success btn-lg mt-2"
                        OnClick="btnConfirmarCompra_Click" />
                </div>

            </div>

        </asp:Panel>

        <asp:Panel ID="pnlVacio" runat="server" Visible="false"
            CssClass="text-center py-5">

            <h3>Tu carrito está vacío</h3>
            <p class="text-muted">Agrega algunos productos para comenzar tu compra.</p>

            <asp:HyperLink ID="lnkProductos" runat="server"
                NavigateUrl="~/Productos.aspx"
                CssClass="btn btn-dark">
                Ver productos
            </asp:HyperLink>

        </asp:Panel>

    </div>

</asp:Content>
