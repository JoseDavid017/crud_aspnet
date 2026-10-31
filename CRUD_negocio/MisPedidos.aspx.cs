
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class MisPedidos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Cliente"
            );

            if (Session["IdCliente"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarPedidos();
            }
        }

        // Consultar los pedidos del cliente autenticado.
        private void CargarPedidos()
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            int idCliente = Convert.ToInt32(Session["IdCliente"]);

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdPedido, Fecha, Total, Estado
                    FROM Pedidos
                    WHERE IdCliente = @IdCliente
                    ORDER BY Fecha DESC";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.AddWithValue(
                        "@IdCliente", idCliente);

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

        // Consultar los productos de un pedido seleccionado.
        protected void gvPedidos_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalles")
            {
                int idPedido = Convert.ToInt32(e.CommandArgument);

                CargarDetallesPedido(idPedido);
            }
        }

        private void CargarDetallesPedido(int idPedido)
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            int idCliente = Convert.ToInt32(Session["IdCliente"]);

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        P.Nombre,
                        D.Cantidad,
                        D.Precio,
                        (D.Cantidad * D.Precio) AS Subtotal
                    FROM DetallePedido D
                    INNER JOIN Productos P
                        ON D.IdProducto = P.IdProducto
                    INNER JOIN Pedidos PE
                        ON D.IdPedido = PE.IdPedido
                    WHERE PE.IdPedido = @IdPedido
                    AND PE.IdCliente = @IdCliente";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.AddWithValue(
                        "@IdPedido", idPedido);

                    comando.Parameters.AddWithValue(
                        "@IdCliente", idCliente);

                    using (SqlDataAdapter adaptador =
                        new SqlDataAdapter(comando))
                    {
                        DataTable tabla = new DataTable();
                        adaptador.Fill(tabla);

                        if (tabla.Rows.Count == 0)
                        {
                            pnlDetalles.Visible = false;

                            lblMensaje.Text =
                                "No se encontraron detalles para este pedido.";

                            lblMensaje.CssClass =
                                "alert alert-warning d-block";

                            lblMensaje.Visible = true;
                            return;
                        }

                        gvDetalles.DataSource = tabla;
                        gvDetalles.DataBind();

                        lblNumeroPedido.Text = "#" + idPedido;

                        pnlDetalles.Visible = true;
                        lblMensaje.Visible = false;
                    }
                }
            }
        }
    }
}
