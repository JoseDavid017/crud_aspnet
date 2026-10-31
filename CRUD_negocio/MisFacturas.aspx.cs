
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace CRUD_negocio
{
    public partial class MisFacturas : Page
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
                CargarFacturas();
            }
        }

        // Consultar las facturas del cliente autenticado.
        private void CargarFacturas()
        {
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"].ConnectionString;

            int idCliente = Convert.ToInt32(Session["IdCliente"]);

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        F.IdFactura,
                        F.IdPedido,
                        F.Fecha,
                        F.Total,
                        F.EstadoPago
                    FROM Facturas F
                    INNER JOIN Pedidos P
                        ON F.IdPedido = P.IdPedido
                    WHERE P.IdCliente = @IdCliente
                    ORDER BY F.Fecha DESC";

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

                        gvFacturas.DataSource = tabla;
                        gvFacturas.DataBind();

                        if (tabla.Rows.Count == 0)
                        {
                            lblMensaje.Text =
                                "Todavía no tienes facturas registradas.";

                            lblMensaje.CssClass =
                                "alert alert-info d-block";

                            lblMensaje.Visible = true;
                        }
                        else
                        {
                            lblMensaje.Visible = false;
                        }
                    }
                }
            }
        }

        // Asignar colores según el estado de pago.
        protected string ObtenerClaseEstado(string estado)
        {
            switch (estado)
            {
                case "Pendiente":
                    return "badge bg-warning text-dark";

                case "Pagada":
                    return "badge bg-success";

                case "Anulada":
                    return "badge bg-secondary";

                default:
                    return "badge bg-info text-dark";
            }
        }
    }
}
