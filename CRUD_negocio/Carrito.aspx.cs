
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class Carrito : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IdUsuario"] != null)
            {
                MenuVisitante.Visible = false;
                MenuUsuario.Visible = true;

                lblNombreUsuario.Text = Session["Usuario"].ToString();
            }
            else
            {
                MenuVisitante.Visible = true;
                MenuUsuario.Visible = false;
            }
            // Solo los clientes pueden acceder al carrito.
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Cliente"
            );

            if (Session["IdUsuario"] == null ||
                Session["Rol"] == null ||
                Session["Rol"].ToString() != "Cliente")
            {
                return;
            }

            // Evita sobrescribir las cantidades ingresadas
            // cuando se ejecuta una acción del GridView.
            if (!IsPostBack)
            {
                CargarCarrito();
            }
        }
        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Default.aspx");
        }
        // Mostrar los productos y calcular el total.
        private void CargarCarrito()
        {
            List<CarritoItem> carrito =
                Session["Carrito"] as List<CarritoItem>;

            if (carrito == null || carrito.Count == 0)
            {
                pnlCarrito.Visible = false;
                pnlVacio.Visible = true;
                Session["Carrito"] = null;
                lblTotal.Text = "$ 0";
                return;
            }

            pnlCarrito.Visible = true;
            pnlVacio.Visible = false;

            gvCarrito.DataSource = carrito;
            gvCarrito.DataBind();

            decimal total = 0;

            foreach (CarritoItem producto in carrito)
            {
                total += producto.Subtotal;
            }

            lblTotal.Text = "$ " + total.ToString("N0");
        }

        // Actualizar o eliminar productos.
        protected void gvCarrito_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            List<CarritoItem> carrito =
                Session["Carrito"] as List<CarritoItem>;

            if (carrito == null)
            {
                MostrarMensaje("Tu carrito está vacío.");
                CargarCarrito();
                return;
            }

            int idProducto = Convert.ToInt32(e.CommandArgument);

            CarritoItem producto = carrito.Find(
                p => p.IdProducto == idProducto
            );

            if (producto == null)
            {
                MostrarMensaje("No se encontró el producto.");
                return;
            }

            // ACTUALIZAR CANTIDAD
            if (e.CommandName == "Actualizar")
            {
                GridViewRow fila =
                    (GridViewRow)((Control)e.CommandSource).NamingContainer;

                TextBox txtCantidad =
                    (TextBox)fila.FindControl("txtCantidad");

                int cantidad;

                if (!int.TryParse(txtCantidad.Text, out cantidad) ||
                    cantidad <= 0)
                {
                    MostrarMensaje("Ingresa una cantidad válida.");
                    CargarCarrito();
                    return;
                }

                int stock = ObtenerStock(idProducto);

                if (stock == -1)
                {
                    MostrarMensaje("El producto ya no existe.");
                    carrito.Remove(producto);
                    Session["Carrito"] = carrito;
                    CargarCarrito();
                    return;
                }

                if (cantidad > stock)
                {
                    MostrarMensaje(
                        "No hay suficientes unidades disponibles. Stock actual: "
                        + stock
                    );

                    CargarCarrito();
                    return;
                }

                producto.Cantidad = cantidad;

                Session["Carrito"] = carrito;

                MostrarMensaje("Cantidad actualizada correctamente.");
                CargarCarrito();
            }

            // ELIMINAR PRODUCTO
            else if (e.CommandName == "Eliminar")
            {
                carrito.Remove(producto);

                Session["Carrito"] = carrito;

                MostrarMensaje("Producto eliminado del carrito.");
                CargarCarrito();
            }
        }

        // Consultar el stock actual en SQL Server.
        private int ObtenerStock(int idProducto)
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            using (SqlConnection conexion =
                new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT Stock
                    FROM Productos
                    WHERE IdProducto = @IdProducto";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.AddWithValue(
                        "@IdProducto", idProducto
                    );

                    conexion.Open();

                    object resultado = comando.ExecuteScalar();

                    if (resultado == null || resultado == DBNull.Value)
                    {
                        return -1;
                    }

                    return Convert.ToInt32(resultado);
                }
            }
        }

        // Mostrar mensajes al usuario.
        private void MostrarMensaje(string mensaje)
        {
            string mensajeSeguro = mensaje
                .Replace("\\", "\\\\")
                .Replace("'", "\\'")
                .Replace("\r", "")
                .Replace("\n", "");

            ClientScript.RegisterStartupScript(
                this.GetType(),
                Guid.NewGuid().ToString(),
                "alert('" + mensajeSeguro + "');",
                true
            );
        }


        protected void btnConfirmarCompra_Click(object sender, EventArgs e)
        {
            List<CarritoItem> carrito =
                Session["Carrito"] as List<CarritoItem>;

            if (carrito == null || carrito.Count == 0)
            {
                MostrarMensaje("Tu carrito está vacío.");
                CargarCarrito();
                return;
            }

            if (Session["IdCliente"] == null)
            {
                MostrarMensaje("No se encontró el cliente de esta sesión.");
                return;
            }

            int idCliente = Convert.ToInt32(Session["IdCliente"]);

            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                using (SqlTransaction transaccion =
                    conexion.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        decimal total = 0;

                        List<CarritoItem> productosValidados =
                            new List<CarritoItem>();

                        // 1. Consultar precios y verificar existencias.
                        foreach (CarritoItem item in carrito)
                        {
                            if (item.Cantidad <= 0)
                            {
                                throw new Exception("Hay una cantidad inválida.");
                            }

                            string consultaProducto = @"
                        SELECT Nombre, Precio, Stock
                        FROM Productos WITH (UPDLOCK, HOLDLOCK)
                        WHERE IdProducto = @IdProducto";

                            using (SqlCommand comando = new SqlCommand(
                                consultaProducto, conexion, transaccion))
                            {
                                comando.Parameters.AddWithValue(
                                    "@IdProducto", item.IdProducto);

                                using (SqlDataReader lector = comando.ExecuteReader())
                                {
                                    if (!lector.Read())
                                    {
                                        throw new Exception(
                                            "Uno de los productos ya no existe.");
                                    }

                                    int stock = Convert.ToInt32(lector["Stock"]);

                                    if (item.Cantidad > stock)
                                    {
                                        throw new Exception(
                                            "Stock insuficiente para el producto: "
                                            + lector["Nombre"].ToString());
                                    }

                                    CarritoItem producto = new CarritoItem
                                    {
                                        IdProducto = item.IdProducto,
                                        Nombre = lector["Nombre"].ToString(),
                                        Precio = Convert.ToDecimal(lector["Precio"]),
                                        Cantidad = item.Cantidad
                                    };

                                    productosValidados.Add(producto);
                                    total += producto.Subtotal;
                                }
                            }
                        }

                        // 2. Registrar el pedido.
                        int idPedido;

                        string insertarPedido = @"
                    INSERT INTO Pedidos
                    (IdCliente, IdEmpleado, Fecha, Estado, Total)
                    OUTPUT INSERTED.IdPedido
                    VALUES
                    (@IdCliente, NULL, GETDATE(), 'Pendiente', @Total)";

                        using (SqlCommand comando = new SqlCommand(
                            insertarPedido, conexion, transaccion))
                        {
                            comando.Parameters.AddWithValue(
                                "@IdCliente", idCliente);

                            SqlParameter parametroTotal =
                                comando.Parameters.Add("@Total", SqlDbType.Decimal);

                            parametroTotal.Precision = 18;
                            parametroTotal.Scale = 2;
                            parametroTotal.Value = total;

                            idPedido = Convert.ToInt32(
                                comando.ExecuteScalar());
                        }

                        // 3. Registrar los detalles y descontar el inventario.
                        foreach (CarritoItem producto in productosValidados)
                        {
                            string insertarDetalle = @"
                        INSERT INTO DetallePedido
                        (IdPedido, IdProducto, Cantidad, Precio)
                        VALUES
                        (@IdPedido, @IdProducto, @Cantidad, @Precio)";

                            using (SqlCommand comando = new SqlCommand(
                                insertarDetalle, conexion, transaccion))
                            {
                                comando.Parameters.AddWithValue(
                                    "@IdPedido", idPedido);

                                comando.Parameters.AddWithValue(
                                    "@IdProducto", producto.IdProducto);

                                comando.Parameters.AddWithValue(
                                    "@Cantidad", producto.Cantidad);

                                SqlParameter parametroPrecio =
                                    comando.Parameters.Add("@Precio", SqlDbType.Decimal);

                                parametroPrecio.Precision = 18;
                                parametroPrecio.Scale = 2;
                                parametroPrecio.Value = producto.Precio;

                                comando.ExecuteNonQuery();
                            }

                            string actualizarStock = @"
                        UPDATE Productos
                        SET Stock = Stock - @Cantidad
                        WHERE IdProducto = @IdProducto
                        AND Stock >= @Cantidad";

                            using (SqlCommand comando = new SqlCommand(
                                actualizarStock, conexion, transaccion))
                            {
                                comando.Parameters.AddWithValue(
                                    "@Cantidad", producto.Cantidad);

                                comando.Parameters.AddWithValue(
                                    "@IdProducto", producto.IdProducto);

                                int filas = comando.ExecuteNonQuery();

                                if (filas == 0)
                                {
                                    throw new Exception(
                                        "No fue posible actualizar el inventario.");
                                }
                            }
                        }

                        // 4. Generar la factura.
                        string insertarFactura = @"
                    INSERT INTO Facturas
                    (IdPedido, Fecha, Total, EstadoPago)
                    VALUES
                    (@IdPedido, GETDATE(), @Total, 'Pendiente')";

                        using (SqlCommand comando = new SqlCommand(
                            insertarFactura, conexion, transaccion))
                        {
                            comando.Parameters.AddWithValue(
                                "@IdPedido", idPedido);

                            SqlParameter parametroTotal =
                                comando.Parameters.Add("@Total", SqlDbType.Decimal);

                            parametroTotal.Precision = 18;
                            parametroTotal.Scale = 2;
                            parametroTotal.Value = total;

                            comando.ExecuteNonQuery();
                        }

                        // 5. Confirmar todas las operaciones.
                        transaccion.Commit();

                        // Vaciar el carrito únicamente después de guardar la compra.
                        Session["Carrito"] = null;

                        CargarCarrito();

                        lblMensaje.CssClass = "alert alert-success d-block";
                        lblMensaje.Text =
                            "¡Compra registrada correctamente! " +
                            "Número de pedido: " + idPedido +
                            ". Total: $ " + total.ToString("N0") +
                            ". Tu factura quedó pendiente de pago.";

                        lblMensaje.Visible = true;
                    }
                    catch (Exception ex)
                    {
                        transaccion.Rollback();

                        lblMensaje.CssClass = "alert alert-danger d-block";
                        lblMensaje.Text = "No se pudo completar la compra: "
                            + Server.HtmlEncode(ex.Message);

                        lblMensaje.Visible = true;
                    }
                }
            }
        }

    }
}
