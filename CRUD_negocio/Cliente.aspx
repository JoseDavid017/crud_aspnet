
<%@ Page Title="Panel del cliente" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cliente.aspx.cs" Inherits="CRUD_negocio.Cliente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <h1 class="fw-bold">Panel del cliente</h1>

        <p class="text-secondary">
            Bienvenido a JA Solutions. Desde aquí puedes consultar nuestros productos y servicios.
        </p>

        <div class="row g-4 mt-3">

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Productos</h5>
                        <p>Consulta nuestro catálogo de productos.</p>
                        <a href="Productos.aspx" class="btn btn-primary">
                            Ver productos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Mis pedidos</h5>
                        <p>Consulta el estado de tus pedidos.</p>
                        <a href="MisPedidos.aspx" class="btn btn-primary">
                            Ver pedidos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Mis facturas</h5>
                        <p>Consulta tus facturas.</p>
                        <a href="MisFacturas.aspx" class="btn btn-primary">
                            Ver facturas
                        </a>
                    </div>
                </div>
            </div>

        </div>

    </div>

</asp:Content>
