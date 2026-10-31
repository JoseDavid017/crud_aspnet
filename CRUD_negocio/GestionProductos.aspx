
<%@ Page Title="Gestión de productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GestionProductos.aspx.cs" Inherits="CRUD_negocio.GestionProductos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold">Gestión de productos</h1>
                <p class="text-muted">
                    Administra el catálogo de productos de JA Solutions.
                </p>
            </div>

            <a href="Admin.aspx" class="btn btn-outline-dark">
                Volver al panel
            </a>
        </div>

        <asp:Label ID="lblMensaje" runat="server"
            Visible="false"
            CssClass="alert alert-info d-block">
        </asp:Label>

        <!-- Formulario para crear y editar -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">

                <h4 class="fw-bold mb-3">
                    <asp:Label ID="lblTituloFormulario" runat="server"
                        Text="Registrar producto"></asp:Label>
                </h4>

                <asp:HiddenField ID="hfIdProducto" runat="server" />

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Nombre del producto</label>
                        <asp:TextBox ID="txtNombre" runat="server"
                            CssClass="form-control"
                            MaxLength="100"
                            placeholder="Nombre del producto">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Categoría</label>
                        <asp:TextBox ID="txtCategoria" runat="server"
                            CssClass="form-control"
                            MaxLength="50"
                            placeholder="Ej. Alarmas">
                        </asp:TextBox>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server"
                            CssClass="form-control"
                            TextMode="MultiLine"
                            Rows="3"
                            MaxLength="500"
                            placeholder="Descripción del producto">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Precio</label>
                        <asp:TextBox ID="txtPrecio" runat="server"
                            CssClass="form-control"
                            TextMode="Number">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Stock</label>
                        <asp:TextBox ID="txtStock" runat="server"
                            CssClass="form-control"
                            TextMode="Number">
                        </asp:TextBox>
                    </div>

                    <div class="col-12">
                        <asp:Button ID="btnGuardar" runat="server"
                            Text="Registrar producto"
                            CssClass="btn btn-primary"
                            OnClick="btnGuardar_Click" />

                        <asp:Button ID="btnCancelar" runat="server"
                            Text="Cancelar edición"
                            CssClass="btn btn-outline-secondary"
                            Visible="false"
                            CausesValidation="false"
                            OnClick="btnCancelar_Click" />
                    </div>

                </div>

            </div>
        </div>

        <!-- Listado de productos -->
        <div class="card shadow-sm border-0">
            <div class="card-body">

                <h4 class="fw-bold mb-3">Productos registrados</h4>

                <div class="table-responsive">

                    <asp:GridView ID="gvProductos" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-bordered table-hover align-middle"
                        EmptyDataText="No hay productos registrados."
                        DataKeyNames="IdProducto"
                        OnRowCommand="gvProductos_RowCommand">

                        <Columns>

                            <asp:BoundField DataField="IdProducto"
                                HeaderText="ID" />

                            <asp:BoundField DataField="Nombre"
                                HeaderText="Producto" />

                            <asp:BoundField DataField="Categoria"
                                HeaderText="Categoría" />

                            <asp:BoundField DataField="Descripcion"
                                HeaderText="Descripción" />

                            <asp:BoundField DataField="Precio"
                                HeaderText="Precio"
                                DataFormatString="{0:C0}" />

                            <asp:BoundField DataField="Stock"
                                HeaderText="Stock" />

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>

                                    <asp:Button ID="btnEditar" runat="server"
                                        Text="Editar"
                                        CssClass="btn btn-warning btn-sm mb-1"
                                        CommandName="EditarProducto"
                                        CommandArgument='<%# Eval("IdProducto") %>' />

                                    <asp:Button ID="btnEliminar" runat="server"
                                        Text="Eliminar"
                                        CssClass="btn btn-danger btn-sm"
                                        CommandName="EliminarProducto"
                                        CommandArgument='<%# Eval("IdProducto") %>'
                                        OnClientClick="return confirm('¿Estás seguro de eliminar este producto?');" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>
            </div>
        </div>

    </div>

</asp:Content>
