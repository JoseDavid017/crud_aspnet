
<%@ Page Title="Sistemas de Alarmas" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ALARMAS.aspx.cs"
    Inherits="CRUD_negocio.ALARMAS" %>

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
                            <i class="bi bi-cart3"></i>Carrito
                        </a>
                    </li>

                    <li class="nav-item">
                        <span class="nav-link fw-bold">Hola,
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
    <!-- PRESENTACIÓN -->
    <section class="container py-5">

        <div class="row align-items-center">

            <div class="col-md-6">
                <span class="badge bg-primary mb-3">JA SOLUTIONS</span>

                <h1 class="fw-bold display-5">
                    Sistemas de alarmas
                </h1>

                <p class="text-muted fs-5">
                    Protegemos tus espacios mediante soluciones de seguridad
                    diseñadas para detectar situaciones de riesgo y ayudarte
                    a mantener tu hogar o empresa protegido.
                </p>

                <a href="#solicitud" class="btn btn-primary btn-lg">
                    Solicitar servicio
                </a>
            </div>

            <div class="col-md-6 text-center">
                <i class="bi bi-shield-lock-fill"
                   style="font-size: 180px; color: #0d6efd;"></i>
            </div>

        </div>

    </section>

    <!-- BENEFICIOS -->
    <section class="bg-light py-5">

        <div class="container">

            <div class="text-center mb-5">
                <h2 class="fw-bold">Nuestros sistemas de alarmas</h2>
                <p class="text-muted">
                    Soluciones para mejorar la seguridad de tus instalaciones.
                </p>
            </div>

            <div class="row g-4">

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center p-4">
                            <i class="bi bi-bell-fill fs-1 text-primary"></i>
                            <h5 class="fw-bold mt-3">Detección</h5>
                            <p class="text-muted">
                                Detección de eventos que puedan representar
                                un riesgo para tus instalaciones.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center p-4">
                            <i class="bi bi-house-lock-fill fs-1 text-primary"></i>
                            <h5 class="fw-bold mt-3">Protección</h5>
                            <p class="text-muted">
                                Alternativas de seguridad para hogares,
                                oficinas y establecimientos comerciales.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body text-center p-4">
                            <i class="bi bi-tools fs-1 text-primary"></i>
                            <h5 class="fw-bold mt-3">Instalación</h5>
                            <p class="text-muted">
                                Instalación y configuración de equipos
                                de seguridad según las necesidades del cliente.
                            </p>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </section>

    <!-- SOLICITUD -->
    <section id="solicitud" class="container py-5">

        <div class="text-center mb-4">
            <h2 class="fw-bold">Solicita tu servicio</h2>
            <p class="text-muted">
                Cuéntanos qué necesitas y nuestro equipo podrá atender tu solicitud.
            </p>
        </div>

        <div class="card border-0 shadow-sm mx-auto"
             style="max-width: 700px;">

            <div class="card-body p-4">

                <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                    <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                </asp:Panel>

                <div class="mb-3">
                    <label class="form-label fw-bold">
                        Servicio solicitado
                    </label>

                    <input type="text" class="form-control"
                        value="Sistemas de alarmas" readonly />
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">
                        Descripción
                    </label>

                    <asp:TextBox ID="txtDescripcion" runat="server"
                        TextMode="MultiLine"
                        Rows="4"
                        MaxLength="500"
                        CssClass="form-control"
                        placeholder="Describe qué necesitas...">
                    </asp:TextBox>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">
                        Dirección
                    </label>

                    <asp:TextBox ID="txtDireccion" runat="server"
                        MaxLength="200"
                        CssClass="form-control"
                        placeholder="Dirección donde se realizará el servicio">
                    </asp:TextBox>
                </div>

                <asp:Button ID="btnSolicitar" runat="server"
                    Text="Enviar solicitud"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnSolicitar_Click" />

            </div>

        </div>

    </section>

</asp:Content>
