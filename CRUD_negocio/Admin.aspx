
<%@ Page Title="Panel administrativo" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="CRUD_negocio.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <!-- Encabezado -->
        <div class="mb-5">
            <span class="badge bg-dark">JA Solutions</span>
            <h1 class="fw-bold mt-2">Panel administrativo</h1>
            <p class="text-secondary">
                Desde aquí puedes administrar la información y las operaciones de la empresa.
            </p>
        </div>

        <!-- Bienvenida -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4">
                <h4 class="fw-bold">
                    Bienvenido, administrador
                </h4>
                <p class="text-secondary mb-0">
                    Selecciona el módulo que deseas gestionar.
                </p>
            </div>
        </div>

        <!-- Módulos -->
        <div class="row g-4">

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4">
                        <h5 class="fw-bold">Productos</h5>
                        <p class="text-secondary">
                            Administra el catálogo, precios y existencias de los productos.
                        </p>
                        <a href="GestionProductos.aspx" class="btn btn-dark">
                            Gestionar productos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4">
                        <h5 class="fw-bold">Clientes</h5>
                        <p class="text-secondary">
                            Consulta y administra los clientes registrados.
                        </p>
                        <a href="GestionClientes.aspx" class="btn btn-dark">
                            Gestionar clientes
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4">
                        <h5 class="fw-bold">Empleados</h5>
                        <p class="text-secondary">
                            Administra la información de los empleados.
                        </p>
                        <a href="GestionEmpleados.aspx" class="btn btn-dark">
                            Gestionar empleados
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4">
                        <h5 class="fw-bold">Pedidos</h5>
                        <p class="text-secondary">
                            Consulta y actualiza los pedidos de los clientes.
                        </p>
                        <a href="GestionPedidos.aspx" class="btn btn-dark">
                            Gestionar pedidos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body p-4">
                        <h5 class="fw-bold">Facturas</h5>
                        <p class="text-secondary">
                            Consulta las facturas y sus estados de pago.
                        </p>
                        <a href="GestionFacturas.aspx" class="btn btn-dark">
                            Gestionar facturas
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <div class="mt-5">
            <a href="Default.aspx" class="btn btn-outline-secondary">
                Volver al inicio
            </a>
        </div>

    </div>

</asp:Content>
