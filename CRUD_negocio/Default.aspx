
<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CRUD_negocio._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- NAVBAR -->
    
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



    <!-- SECCIÓN PRINCIPAL -->
    <section class="bg-light py-5">
        <div class="container">
            <div class="row align-items-center py-4">

                <div class="col-lg-6 mb-4 mb-lg-0">
                    <span class="badge bg-primary mb-3">
                        Tecnología y seguridad
                    </span>

                    <h1 class="display-4 fw-bold">
                        Protegemos lo que más importa.
                    </h1>

                    <p class="lead text-secondary mt-3">
                        En JA Solutions ofrecemos soluciones tecnológicas,
                        equipos de seguridad y servicios especializados para
                        proteger y mantener tus dispositivos.
                    </p>

                    <div class="mt-4">
                        <a href="Productos.aspx" class="btn btn-primary btn-lg me-2">
                            Ver productos
                        </a>

                        <a href="#servicios" class="btn btn-outline-dark btn-lg">
                            Nuestros servicios
                        </a>
                    </div>
                </div>

                <div class="col-lg-6 text-center">
                    <img src="Content/LOGO.PNG"
                        alt="JA Solutions"
                        class="img-fluid"
                        style="max-height: 300px;" />
                </div>

            </div>
        </div>
    </section>


    <!-- SERVICIOS -->
    <section id="servicios" class="py-5">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="fw-bold">Nuestros servicios</h2>
                <p class="text-secondary">
                    Soluciones diseñadas para tu seguridad y tranquilidad.
                </p>
            </div>

            <div class="row g-4">

                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-lg">
                        <div class="card-body text-center p-4">
                            <div class="fs-1 text-primary mb-3">
                                <i class="bi bi-shield-check"></i>
                            </div>

                            <h5 class="fw-bold">Sistemas de alarmas</h5>

                            <p class="text-secondary">
                                Soluciones de seguridad para proteger espacios,
                                establecimientos y propiedades.
                            </p>

                            <a href="ALARMAS.aspx"
                                class="btn btn-outline-primary">
                                Conocer servicio
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-lg">
                        <div class="card-body text-center p-4">
                            <div class="fs-1 text-primary mb-3">
                                <i class="bi bi-camera-video"></i>
                            </div>

                            <h5 class="fw-bold">Sistemas de vigilancia</h5>

                            <p class="text-secondary">
                                Equipos y soluciones de vigilancia para mejorar
                                el control y la supervisión de tus espacios.
                            </p>

                            <a href="SVC.aspx"
                                class="btn btn-outline-primary">
                                Conocer servicio
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-lg">
                        <div class="card-body text-center p-4">
                            <div class="fs-1 text-primary mb-3">
                                <i class="bi bi-tools"></i>
                            </div>

                            <h5 class="fw-bold">Mantenimiento de equipos</h5>

                            <p class="text-secondary">
                                Servicio de mantenimiento y revisión para
                                conservar tus dispositivos en buen estado.
                            </p>

                            <a href="IMEI.aspx"
                                class="btn btn-outline-primary">
                                Conocer servicio
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>


    <!-- PRODUCTOS -->
    <section class="bg-light py-5">
        <div class="container">

            <div class="text-center mb-5">
                <h2 class="fw-bold">Productos destacados</h2>
                <p class="text-secondary">
                    Conoce algunos de los productos disponibles en nuestra tienda.
                </p>
            </div>

            <asp:Repeater ID="RepeaterProductos" runat="server"
                DataSourceID="SqlProductos">

                <HeaderTemplate>
                    <div class="row g-4">
                </HeaderTemplate>

                <ItemTemplate>
                    <div class="col-sm-6 col-lg-4">
                        <div class="card h-100 border-0 shadow-sm">

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

                                <h5 class="text-dark fw-bold">
                                    $ <%# Eval("Precio", "{0:N0}") %>
                                </h5>

                                <small class="text-muted">
                                    Disponibles: <%# Eval("Stock") %>
                                </small>
                            </div>

                        </div>
                    </div>
                </ItemTemplate>

                <FooterTemplate>
                    </div>
                </FooterTemplate>

            </asp:Repeater>

            <asp:SqlDataSource ID="SqlProductos" runat="server"
                ConnectionString="<%$ ConnectionStrings:JaSolution %>"
                SelectCommand="
                    SELECT TOP 6 IdProducto, Nombre, Categoria,
                    Descripcion, Precio, Stock
                    FROM Productos
                    WHERE Stock > 0
                    ORDER BY IdProducto DESC">
            </asp:SqlDataSource>

            <div class="text-center mt-5">
                <a href="Productos.aspx" class="btn btn-dark px-4">
                    Ver todos los productos
                </a>
            </div>

        </div>
    </section>


    <!-- LLAMADO A LA ACCIÓN -->
    <section class="bg-primary text-white py-5">
        <div class="container text-center">

            <h2 class="fw-bold">
                ¿Necesitas una solución tecnológica?
            </h2>

            <p class="lead mt-3">
                Regístrate en JA Solutions y conoce nuestros productos y servicios.
            </p>

            <a href="Registro.aspx"
                class="btn btn-light btn-lg mt-3 fw-semibold rounded-4">
                Crear una cuenta
            </a>

        </div>
    </section>


    <!-- FOOTER -->
    <footer class="bg-dark text-white py-4">
        <div class="container text-center">

            <h5 class="fw-bold">JA Solutions</h5>

            <p class="text-white-50 mb-2">
                Tecnología, seguridad y soluciones para ti.
            </p>

            <small class="text-white-50">
                © 2026 JA Solutions. Todos los derechos reservados.
            </small>

        </div>
    </footer>

</asp:Content>
