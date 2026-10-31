
using System;
using System.Web.UI;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
namespace CRUD_negocio
{
    public partial class Productos : Page
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
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Default.aspx");
        }


        protected void RepeaterProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Añadir")
            {
                // Obtener el ID del producto
                int idProducto = Convert.ToInt32(e.CommandArgument);

                // Obtener la cantidad seleccionada
                TextBox txtCantidad = (TextBox)e.Item.FindControl("txtCantidad");

                int cantidad;

                if (!int.TryParse(txtCantidad.Text, out cantidad) || cantidad <= 0)
                {
                    MostrarMensaje("Ingresa una cantidad válida.");
                    return;
                }

                // Obtener la conexión
                string cadena = ConfigurationManager
                    .ConnectionStrings["JaSolution"].ConnectionString;

                using (SqlConnection conexion = new SqlConnection(cadena))
                {
                    conexion.Open();

                    string consulta = @"
                SELECT IdProducto, Nombre, Precio, Stock
                FROM Productos
                WHERE IdProducto = @IdProducto";

                    using (SqlCommand comando = new SqlCommand(consulta, conexion))
                    {
                        comando.Parameters.AddWithValue("@IdProducto", idProducto);

                        using (SqlDataReader lector = comando.ExecuteReader())
                        {
                            if (!lector.Read())
                            {
                                MostrarMensaje("El producto no existe.");
                                return;
                            }

                            int stock = Convert.ToInt32(lector["Stock"]);

                            if (cantidad > stock)
                            {
                                MostrarMensaje("No hay suficientes unidades disponibles.");
                                return;
                            }

                            CarritoItem nuevoProducto = new CarritoItem
                            {
                                IdProducto = idProducto,
                                Nombre = lector["Nombre"].ToString(),
                                Precio = Convert.ToDecimal(lector["Precio"]),
                                Cantidad = cantidad
                            };

                            // Obtener el carrito de la sesión
                            List<CarritoItem> carrito =
                                Session["Carrito"] as List<CarritoItem>;

                            if (carrito == null)
                            {
                                carrito = new List<CarritoItem>();
                            }

                            // Buscar si el producto ya está agregado
                            CarritoItem existente = carrito.Find(
                                p => p.IdProducto == idProducto);

                            if (existente != null)
                            {
                                if (existente.Cantidad + cantidad > stock)
                                {
                                    MostrarMensaje("La cantidad supera el stock disponible.");
                                    return;
                                }

                                existente.Cantidad += cantidad;
                            }
                            else
                            {
                                carrito.Add(nuevoProducto);
                            }

                            Session["Carrito"] = carrito;

                            MostrarMensaje("Producto añadido al carrito correctamente.");
                        }
                    }
                }
            }
        }

        private void MostrarMensaje(string mensaje)
        {
            string mensajeSeguro = mensaje.Replace("\\", "\\\\")
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

    }
}
