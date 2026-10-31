
<%@ Page Title="Sistemas de Alarmas" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ALARMAS.aspx.cs"
    Inherits="CRUD_negocio.ALARMAS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- PRESENTACIÓN -->
    <section class="bg-dark text-white py-5">
        <div class="container py-4">
            <div class="row align-items-center">

                <div class="col-md-7">
                    <span class="badge bg-primary mb-3">JA SOLUTIONS</span>

                    <h1 class="display-4 fw-bold">
                        Sistemas de alarmas
                    </h1>

                    <p class="lead">
                        Protege tu hogar o empresa con soluciones de seguridad
                        diseñadas para ayudarte a detectar situaciones de riesgo
                        y mejorar la protección de tus espacios.
                    </p>

                    <a href="#solicitud" class="btn btn-primary btn-lg mt-3">
                        Solicitar servicio
                    </a>
                </div>

                <div class="col-md-5 text-center mt-4 mt-md-0">
                    <i class="bi bi-shield-lock-fill"
                       style="font-size: 150px; color: #0d6efd;"></i>
                </div>

            </div>
        </div>
    </section>

    <!-- BENEFICIOS -->
    <section class="container py-5">

        <div class="text-center mb-5">
            <h2 class="fw-bold">Protección para tus espacios</h2>
            <p class="text-muted">
                Conoce algunas ventajas de nuestros sistemas de alarmas.
            </p>
        </div>

        <div class="row g-4">

            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-bell-fill text-primary fs-1"></i>
                        <h5 class="fw-bold mt-3">Detección de riesgos</h5>
                        <p class="text-muted">
                            Sistemas diseñados para detectar eventos
                            que puedan comprometer la seguridad.
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-house-lock-fill text-primary fs-1"></i>
                        <h5 class="fw-bold mt-3">Protección de espacios</h5>
                        <p class="text-muted">
                            Alternativas de seguridad para viviendas,
                            oficinas y establecimientos comerciales.
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center p-4">
                        <i class="bi bi-tools text-primary fs-1"></i>
                        <h5 class="fw-bold mt-3">Instalación especializada</h5>
                        <p class="text-muted">
                            Atención técnica para la instalación y
                            configuración de los equipos.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- FORMULARIO -->
    <section id="solicitud" class="bg-light py-5">

        <div class="container">

            <div class="text-center mb-4">
                <h2 class="fw-bold">Solicita tu sistema de alarmas</h2>
                <p class="text-muted">
                    Completa los siguientes datos para registrar tu solicitud.
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
                            Descripción de lo que necesitas
                        </label>

                        <asp:TextBox ID="txtDescripcion" runat="server"
                            TextMode="MultiLine"
                            Rows="4"
                            CssClass="form-control"
                            MaxLength="500"
                            placeholder="Ejemplo: Necesito instalar un sistema de alarmas en mi vivienda...">
                        </asp:TextBox>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">
                            Dirección donde se realizará el servicio
                        </label>

                        <asp:TextBox ID="txtDireccion" runat="server"
                            CssClass="form-control"
                            MaxLength="200"
                            placeholder="Escribe la dirección del lugar">
                        </asp:TextBox>
                    </div>

                    <asp:Button ID="btnSolicitar" runat="server"
                        Text="Enviar solicitud"
                        CssClass="btn btn-primary w-100"
                        OnClick="btnSolicitar_Click" />

                </div>
            </div>

        </div>

    </section>

</asp:Content>
