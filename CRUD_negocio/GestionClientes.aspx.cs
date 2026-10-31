
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class GestionClientes : Page
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
                CargarClientes();
            }
        }

        // CONSULTAR CLIENTES
        private void CargarClientes()
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdCliente, Nombre, Apellido,
                           Documento, Telefono, Correo
                    FROM Clientes
                    ORDER BY IdCliente DESC";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    gvClientes.DataSource = tabla;
                    gvClientes.DataBind();
                }
            }
        }

        // REGISTRAR O ACTUALIZAR CLIENTE
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string apellido = txtApellido.Text.Trim();
            string documento = txtDocumento.Text.Trim();
            string telefono = txtTelefono.Text.Trim();
            string correo = txtCorreo.Text.Trim();

            if (nombre == "" || apellido == "" ||
                documento == "" || telefono == "" || correo == "")
            {
                MostrarMensaje("Todos los campos son obligatorios.", "text-danger");
                return;
            }

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                // Verificar documento duplicado
                string verificar = @"
                    SELECT COUNT(*)
                    FROM Clientes
                    WHERE Documento = @Documento
                    AND IdCliente <> @IdCliente";

                using (SqlCommand comando = new SqlCommand(verificar, conexion))
                {
                    int idCliente = 0;

                    if (!string.IsNullOrEmpty(hfIdCliente.Value))
                    {
                        idCliente = Convert.ToInt32(hfIdCliente.Value);
                    }

                    comando.Parameters.Add("@Documento", SqlDbType.VarChar, 30).Value = documento;
                    comando.Parameters.Add("@IdCliente", SqlDbType.Int).Value = idCliente;

                    int existe = Convert.ToInt32(comando.ExecuteScalar());

                    if (existe > 0)
                    {
                        MostrarMensaje("Ya existe un cliente con ese documento.", "text-danger");
                        return;
                    }
                }

                // Si existe ID, actualizar
                if (!string.IsNullOrEmpty(hfIdCliente.Value))
                {
                    string actualizar = @"
                        UPDATE Clientes
                        SET Nombre = @Nombre,
                            Apellido = @Apellido,
                            Documento = @Documento,
                            Telefono = @Telefono,
                            Correo = @Correo
                        WHERE IdCliente = @IdCliente";

                    using (SqlCommand comando = new SqlCommand(actualizar, conexion))
                    {
                        AgregarParametros(comando, nombre, apellido,
                            documento, telefono, correo);

                        comando.Parameters.Add("@IdCliente", SqlDbType.Int)
                            .Value = Convert.ToInt32(hfIdCliente.Value);

                        comando.ExecuteNonQuery();
                    }

                    MostrarMensaje("Cliente actualizado correctamente.", "text-success");
                }
                else
                {
                    // Registrar nuevo cliente
                    string insertar = @"
                        INSERT INTO Clientes
                        (Nombre, Apellido, Documento, Telefono, Correo)
                        VALUES
                        (@Nombre, @Apellido, @Documento, @Telefono, @Correo)";

                    using (SqlCommand comando = new SqlCommand(insertar, conexion))
                    {
                        AgregarParametros(comando, nombre, apellido,
                            documento, telefono, correo);

                        comando.ExecuteNonQuery();
                    }

                    MostrarMensaje("Cliente registrado correctamente.", "text-success");
                }
            }

            LimpiarFormulario();
            CargarClientes();
        }

        // AGREGAR PARAMETROS
        private void AgregarParametros(
            SqlCommand comando,
            string nombre,
            string apellido,
            string documento,
            string telefono,
            string correo)
        {
            comando.Parameters.Add("@Nombre", SqlDbType.VarChar, 100).Value = nombre;
            comando.Parameters.Add("@Apellido", SqlDbType.VarChar, 100).Value = apellido;
            comando.Parameters.Add("@Documento", SqlDbType.VarChar, 30).Value = documento;
            comando.Parameters.Add("@Telefono", SqlDbType.VarChar, 30).Value = telefono;
            comando.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = correo;
        }

        // EVENTOS DEL GRIDVIEW
        protected void gvClientes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idCliente = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditarCliente")
            {
                CargarCliente(idCliente);
            }
            else if (e.CommandName == "EliminarCliente")
            {
                EliminarCliente(idCliente);
            }
        }

        // CARGAR DATOS PARA EDITAR
        private void CargarCliente(int idCliente)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT Nombre, Apellido, Documento, Telefono, Correo
                    FROM Clientes
                    WHERE IdCliente = @IdCliente";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@IdCliente", SqlDbType.Int).Value = idCliente;

                    conexion.Open();

                    using (SqlDataReader lector = comando.ExecuteReader())
                    {
                        if (lector.Read())
                        {
                            hfIdCliente.Value = idCliente.ToString();

                            txtNombre.Text = lector["Nombre"].ToString();
                            txtApellido.Text = lector["Apellido"].ToString();
                            txtDocumento.Text = lector["Documento"].ToString();
                            txtTelefono.Text = lector["Telefono"].ToString();
                            txtCorreo.Text = lector["Correo"].ToString();

                            btnGuardar.Text = "Actualizar cliente";

                            MostrarMensaje("Editando cliente seleccionado.", "text-primary");
                        }
                    }
                }
            }
        }

        // ELIMINAR CLIENTE
        private void EliminarCliente(int idCliente)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                string eliminar = @"
                    DELETE FROM Clientes
                    WHERE IdCliente = @IdCliente
                    AND NOT EXISTS (
                        SELECT 1
                        FROM Pedidos
                        WHERE Pedidos.IdCliente = Clientes.IdCliente
                    )
                    AND NOT EXISTS (
                        SELECT 1
                        FROM Usuarios
                        WHERE Usuarios.IdCliente = Clientes.IdCliente
                    )";

                using (SqlCommand comando = new SqlCommand(eliminar, conexion))
                {
                    comando.Parameters.Add("@IdCliente", SqlDbType.Int).Value = idCliente;

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje("Cliente eliminado correctamente.", "text-success");
                    }
                    else
                    {
                        MostrarMensaje(
                            "No se puede eliminar: el cliente tiene pedidos o un usuario asociado.",
                            "text-danger"
                        );
                    }
                }
            }

            CargarClientes();
        }

        // LIMPIAR FORMULARIO
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            MostrarMensaje("Formulario limpiado.", "text-secondary");
        }

        private void LimpiarFormulario()
        {
            hfIdCliente.Value = "";

            txtNombre.Text = "";
            txtApellido.Text = "";
            txtDocumento.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";

            btnGuardar.Text = "Guardar cliente";
        }

        // MOSTRAR MENSAJES
        private void MostrarMensaje(string mensaje, string clase)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 fw-semibold " + clase;
        }
    }
}
