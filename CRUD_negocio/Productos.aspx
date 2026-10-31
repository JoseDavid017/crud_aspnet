<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="CRUD_negocio.Productos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!--navbar-->
        
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


        <h1 class="display-4 fw-bold">Productos</h1>
        <p class="mt-4 lead text-secundary">
            Nuestros Productos
        </p>

        <asp:Repeater ID="RepeaterProductos" runat="server" DataSourceID="SqlDataSource1" OnItemCommand="RepeaterProductos_ItemCommand">
            <HeaderTemplate>
                <div class="row g-4">
            </HeaderTemplate>


            <ItemTemplate>
                <div class="col-sm-12 col-lg-6 mb-3">
                    <div class="card h-100 border-0 shadow-lg">
                        <div class="card-body">

                            <span class="badge bg-dark mb-2">
                                <%# Eval("Categoria") %>
                            </span>

                            <h5 class="card-title fw-bold">
                                <%# Eval("Nombre") %>
                            </h5>

                            <p class="card-text text-secondary">
                                <%# Eval("Descripcion") %>
                            </p>

                            <h5 class="text-dark fw-bold">$ <%# Eval("Precio", "{0:N0}") %>
                            </h5>

                            <small class="text-muted">Disponibles: <%# Eval("Stock") %>
                            </small>

                            <hr />

                            <label class="form-label">Cantidad:</label>

                            <asp:TextBox ID="txtCantidad" runat="server"
                                Text="1"
                                TextMode="Number"
                                CssClass="form-control mb-3">
                            </asp:TextBox>

                            <asp:Button ID="btnAñadir" runat="server"
                                Text="Añadir al carrito"
                                CssClass="btn btn-dark w-100"
                                CommandName="Añadir"
                                CommandArgument='<%# Eval("IdProducto") %>' />

                        </div>
                    </div>
                </div>
            </ItemTemplate>


            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:JaSolution %>"
            SelectCommand="SELECT * FROM Productos WHERE Stock > 0 ORDER BY Categoria"></asp:SqlDataSource>
    </div>

</asp:Content>

