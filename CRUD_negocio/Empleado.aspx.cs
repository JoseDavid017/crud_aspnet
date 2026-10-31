
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class Empleado : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Empleado"
            );

            if (Session["IdEmpleado"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarPedidos();
            }
        }

        // Consultar todos los pedidos y los datos de sus clientes.
        private void CargarPedidos()
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        P.IdPedido,
                        C.Nombre + ' ' + C.Apellido AS Cliente,
                        C.Telefono,
                        P.Fecha,
                        P.Total,
                        P.Estado
                    FROM Pedidos P
                    INNER JOIN Clientes C
                        ON P.IdCliente = C.IdCliente
                    ORDER BY
                        CASE WHEN P.Estado = 'Pendiente' THEN 0 ELSE 1 END,
                        P.Fecha DESC";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    using (SqlDataAdapter adaptador =
                        new SqlDataAdapter(comando))
                    {
                        DataTable tabla = new DataTable();

                        adaptador.Fill(tabla);

                        gvPedidos.DataSource = tabla;
                        gvPedidos.DataBind();
                    }
                }
            }
        }

        // Procesar las acciones de cada pedido.
        protected void gvPedidos_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int idPedido = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "VerDetalles")
            {
                CargarDetallesPedido(idPedido);
            }
            else if (e.CommandName == "ActualizarEstado")
            {
                GridViewRow fila =
                    (GridViewRow)((Control)e.CommandSource).NamingContainer;

                DropDownList ddlEstado =
                    (DropDownList)fila.FindControl("ddlEstado");

                if (ddlEstado == null)
                {
                    MostrarMensaje("No se pudo obtener el estado seleccionado.");
                    return;
                }

                ActualizarEstado(idPedido, ddlEstado.SelectedValue);
            }
        }

        // Actualizar el estado y asignar el pedido al empleado.
        private void ActualizarEstado(int idPedido, string estado)
        {
            string[] estadosPermitidos =
            {
                "Pendiente",
                "Procesando",
                "Enviado",
                "Entregado",
                "Cancelado"
            };

            if (Array.IndexOf(estadosPermitidos, estado) == -1)
            {
                MostrarMensaje("El estado seleccionado no es válido.");
                return;
            }

            int idEmpleado = Convert.ToInt32(Session["IdEmpleado"]);

            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    UPDATE Pedidos
                    SET Estado = @Estado,
                        IdEmpleado = @IdEmpleado
                    WHERE IdPedido = @IdPedido";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.AddWithValue("@Estado", estado);
                    comando.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                    comando.Parameters.AddWithValue("@IdPedido", idPedido);

                    conexion.Open();

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje("El pedido se actualizó correctamente.");
                    }
                    else
                    {
                        MostrarMensaje("No se encontró el pedido.");
                    }
                }
            }

            CargarPedidos();
        }

        // Consultar los productos asociados a un pedido.
        private void CargarDetallesPedido(int idPedido)
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        PR.Nombre,
                        D.Cantidad,
                        D.Precio,
                        (D.Cantidad * D.Precio) AS Subtotal
                    FROM DetallePedido D
                    INNER JOIN Productos PR
                        ON D.IdProducto = PR.IdProducto
                    WHERE D.IdPedido = @IdPedido";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.AddWithValue(
                        "@IdPedido", idPedido);

                    using (SqlDataAdapter adaptador =
                        new SqlDataAdapter(comando))
                    {
                        DataTable tabla = new DataTable();

                        adaptador.Fill(tabla);

                        gvDetalles.DataSource = tabla;
                        gvDetalles.DataBind();

                        lblNumeroPedido.Text = "#" + idPedido;
                        pnlDetalles.Visible = true;
                    }
                }
            }
        }

        // Mostrar mensajes al empleado.
        private void MostrarMensaje(string mensaje)
        {
            lblMensaje.Text = Server.HtmlEncode(mensaje);
            lblMensaje.Visible = true;
        }
    }
}
