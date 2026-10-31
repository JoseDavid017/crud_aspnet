
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class GestionPedidos : Page
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
                CargarEmpleados();
                CargarPedidos();
            }
        }

        // CONSULTAR EMPLEADOS PARA EL DROPDOWN
        private void CargarEmpleados()
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdEmpleado,
                           Nombre + ' ' + Apellido AS NombreCompleto
                    FROM Empleados
                    ORDER BY Nombre";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    ddlEmpleado.DataSource = tabla;
                    ddlEmpleado.DataTextField = "NombreCompleto";
                    ddlEmpleado.DataValueField = "IdEmpleado";
                    ddlEmpleado.DataBind();
                }
            }

            ddlEmpleado.Items.Insert(
                0,
                new ListItem("Sin asignar", "")
            );
        }

        // CONSULTAR PEDIDOS
        private void CargarPedidos()
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        P.IdPedido,
                        C.Nombre + ' ' + C.Apellido AS Cliente,
                        C.Telefono,
                        CASE
                            WHEN E.IdEmpleado IS NULL THEN 'Sin asignar'
                            ELSE E.Nombre + ' ' + E.Apellido
                        END AS Empleado,
                        P.Fecha,
                        P.Total,
                        P.Estado
                    FROM Pedidos P
                    INNER JOIN Clientes C
                        ON P.IdCliente = C.IdCliente
                    LEFT JOIN Empleados E
                        ON P.IdEmpleado = E.IdEmpleado
                    ORDER BY P.Fecha DESC";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    gvPedidos.DataSource = tabla;
                    gvPedidos.DataBind();
                }
            }
        }

        // EVENTOS DEL GRIDVIEW
        protected void gvPedidos_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalles")
            {
                int idPedido = Convert.ToInt32(e.CommandArgument);

                txtIdPedido.Text = idPedido.ToString();

                CargarPedidoSeleccionado(idPedido);
                CargarDetallesPedido(idPedido);
            }
        }

        // CARGAR ESTADO Y EMPLEADO ACTUAL
        private void CargarPedidoSeleccionado(int idPedido)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdEmpleado, Estado
                    FROM Pedidos
                    WHERE IdPedido = @IdPedido";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@IdPedido", SqlDbType.Int).Value = idPedido;

                    conexion.Open();

                    using (SqlDataReader lector = comando.ExecuteReader())
                    {
                        if (lector.Read())
                        {
                            ddlEstado.SelectedValue = lector["Estado"].ToString();

                            if (lector["IdEmpleado"] == DBNull.Value)
                            {
                                ddlEmpleado.SelectedValue = "";
                            }
                            else
                            {
                                string idEmpleado = lector["IdEmpleado"].ToString();

                                if (ddlEmpleado.Items.FindByValue(idEmpleado) != null)
                                    ddlEmpleado.SelectedValue = idEmpleado;
                            }
                        }
                    }
                }
            }
        }

        // CONSULTAR PRODUCTOS DEL PEDIDO
        private void CargarDetallesPedido(int idPedido)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT
                        PR.Nombre,
                        PR.Categoria,
                        D.Cantidad,
                        D.Precio,
                        (D.Cantidad * D.Precio) AS Subtotal
                    FROM DetallePedido D
                    INNER JOIN Productos PR
                        ON D.IdProducto = PR.IdProducto
                    WHERE D.IdPedido = @IdPedido";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@IdPedido", SqlDbType.Int).Value = idPedido;

                    using (SqlDataAdapter adaptador = new SqlDataAdapter(comando))
                    {
                        DataTable tabla = new DataTable();
                        adaptador.Fill(tabla);

                        gvDetalles.DataSource = tabla;
                        gvDetalles.DataBind();
                    }
                }
            }

            lblNumeroPedido.Text = "#" + idPedido;
            pnlDetalles.Visible = true;
        }

        // ACTUALIZAR PEDIDO
        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtIdPedido.Text))
            {
                MostrarMensaje("Primero selecciona un pedido.", "text-danger");
                return;
            }

            int idPedido = Convert.ToInt32(txtIdPedido.Text);

            string estado = ddlEstado.SelectedValue;
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
                MostrarMensaje("El estado seleccionado no es válido.", "text-danger");
                return;
            }

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    UPDATE Pedidos
                    SET Estado = @Estado,
                        IdEmpleado = @IdEmpleado
                    WHERE IdPedido = @IdPedido";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@Estado", SqlDbType.VarChar, 30).Value = estado;

                    SqlParameter parametroEmpleado =
                        comando.Parameters.Add("@IdEmpleado", SqlDbType.Int);

                    if (string.IsNullOrEmpty(ddlEmpleado.SelectedValue))
                    {
                        parametroEmpleado.Value = DBNull.Value;
                    }
                    else
                    {
                        parametroEmpleado.Value =
                            Convert.ToInt32(ddlEmpleado.SelectedValue);
                    }

                    comando.Parameters.Add("@IdPedido", SqlDbType.Int).Value = idPedido;

                    conexion.Open();

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje("Pedido actualizado correctamente.", "text-success");
                    }
                    else
                    {
                        MostrarMensaje("No se encontró el pedido.", "text-danger");
                    }
                }
            }

            CargarPedidos();
            CargarPedidoSeleccionado(idPedido);
        }

        // MENSAJES
        private void MostrarMensaje(string mensaje, string clase)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 fw-semibold " + clase;
        }
    }
}
