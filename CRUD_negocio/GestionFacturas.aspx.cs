
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class GestionFacturas : Page
    {
        private string cadena =
            ConfigurationManager.ConnectionStrings["JaSolution"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Administrador"
            );

            if (!IsPostBack)
            {
                CargarFacturas();
            }
        }

        // CONSULTAR TODAS LAS FACTURAS
        private void CargarFacturas()
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        F.IdFactura,
                        F.IdPedido,
                        C.Nombre + ' ' + C.Apellido AS Cliente,
                        F.Fecha,
                        F.Total,
                        F.EstadoPago
                    FROM Facturas F
                    INNER JOIN Pedidos P
                        ON F.IdPedido = P.IdPedido
                    INNER JOIN Clientes C
                        ON P.IdCliente = C.IdCliente
                    ORDER BY F.Fecha DESC";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    gvFacturas.DataSource = tabla;
                    gvFacturas.DataBind();
                }
            }
        }

        // CLASE VISUAL SEGÚN EL ESTADO
        public string ObtenerClaseEstado(string estado)
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
                    return "badge bg-dark";
            }
        }

        // SELECCIONAR FACTURA
        protected void gvFacturas_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName == "GestionarFactura")
            {
                int idFactura = Convert.ToInt32(e.CommandArgument);

                CargarFactura(idFactura);
            }
        }

        // CARGAR INFORMACIÓN DE LA FACTURA
        private void CargarFactura(int idFactura)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdFactura, EstadoPago
                    FROM Facturas
                    WHERE IdFactura = @IdFactura";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@IdFactura", SqlDbType.Int)
                        .Value = idFactura;

                    conexion.Open();

                    using (SqlDataReader lector = comando.ExecuteReader())
                    {
                        if (lector.Read())
                        {
                            txtIdFactura.Text =
                                lector["IdFactura"].ToString();

                            ddlEstadoPago.SelectedValue =
                                lector["EstadoPago"].ToString();

                            pnlGestion.Visible = true;

                            MostrarMensaje(
                                "Factura seleccionada correctamente.",
                                "text-primary"
                            );
                        }
                    }
                }
            }
        }

        // ACTUALIZAR ESTADO DE PAGO
        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtIdFactura.Text))
            {
                MostrarMensaje(
                    "Primero selecciona una factura.",
                    "text-danger"
                );
                return;
            }

            int idFactura = Convert.ToInt32(txtIdFactura.Text);
            string estado = ddlEstadoPago.SelectedValue;

            string[] estadosPermitidos =
            {
                "Pendiente",
                "Pagada",
                "Anulada"
            };

            if (Array.IndexOf(estadosPermitidos, estado) == -1)
            {
                MostrarMensaje(
                    "El estado seleccionado no es válido.",
                    "text-danger"
                );
                return;
            }

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    UPDATE Facturas
                    SET EstadoPago = @EstadoPago
                    WHERE IdFactura = @IdFactura";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@EstadoPago", SqlDbType.VarChar, 30)
                        .Value = estado;

                    comando.Parameters.Add("@IdFactura", SqlDbType.Int)
                        .Value = idFactura;

                    conexion.Open();

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje(
                            "Estado de la factura actualizado correctamente.",
                            "text-success"
                        );
                    }
                    else
                    {
                        MostrarMensaje(
                            "No se encontró la factura seleccionada.",
                            "text-danger"
                        );
                    }
                }
            }

            CargarFacturas();
            CargarFactura(idFactura);
        }

        // MOSTRAR MENSAJES
        private void MostrarMensaje(string mensaje, string clase)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass =
                "d-block mb-3 fw-semibold " + clase;
        }
    }
}
