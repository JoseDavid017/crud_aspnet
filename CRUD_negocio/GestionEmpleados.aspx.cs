
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class GestionEmpleados : Page
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
            }
        }

        // CONSULTAR EMPLEADOS
        private void CargarEmpleados()
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT IdEmpleado, Nombre, Apellido,
                           Cargo, Telefono, Correo
                    FROM Empleados
                    ORDER BY IdEmpleado DESC";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    gvEmpleados.DataSource = tabla;
                    gvEmpleados.DataBind();
                }
            }
        }

        // REGISTRAR O ACTUALIZAR EMPLEADO
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string apellido = txtApellido.Text.Trim();
            string cargo = txtCargo.Text.Trim();
            string telefono = txtTelefono.Text.Trim();
            string correo = txtCorreo.Text.Trim();

            if (nombre == "" || apellido == "" ||
                cargo == "" || telefono == "" || correo == "")
            {
                MostrarMensaje("Todos los campos son obligatorios.", "text-danger");
                return;
            }

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                if (!string.IsNullOrEmpty(hfIdEmpleado.Value))
                {
                    // ACTUALIZAR EMPLEADO
                    string actualizar = @"
                        UPDATE Empleados
                        SET Nombre = @Nombre,
                            Apellido = @Apellido,
                            Cargo = @Cargo,
                            Telefono = @Telefono,
                            Correo = @Correo
                        WHERE IdEmpleado = @IdEmpleado";

                    using (SqlCommand comando = new SqlCommand(actualizar, conexion))
                    {
                        AgregarParametros(comando, nombre, apellido,
                            cargo, telefono, correo);

                        comando.Parameters.Add("@IdEmpleado", SqlDbType.Int)
                            .Value = Convert.ToInt32(hfIdEmpleado.Value);

                        comando.ExecuteNonQuery();
                    }

                    MostrarMensaje("Empleado actualizado correctamente.", "text-success");
                }
                else
                {
                    // REGISTRAR EMPLEADO
                    string insertar = @"
                        INSERT INTO Empleados
                        (Nombre, Apellido, Cargo, Telefono, Correo)
                        VALUES
                        (@Nombre, @Apellido, @Cargo, @Telefono, @Correo)";

                    using (SqlCommand comando = new SqlCommand(insertar, conexion))
                    {
                        AgregarParametros(comando, nombre, apellido,
                            cargo, telefono, correo);

                        comando.ExecuteNonQuery();
                    }

                    MostrarMensaje("Empleado registrado correctamente.", "text-success");
                }
            }

            LimpiarFormulario();
            CargarEmpleados();
        }

        // AGREGAR PARAMETROS
        private void AgregarParametros(
            SqlCommand comando,
            string nombre,
            string apellido,
            string cargo,
            string telefono,
            string correo)
        {
            comando.Parameters.Add("@Nombre", SqlDbType.VarChar, 100).Value = nombre;
            comando.Parameters.Add("@Apellido", SqlDbType.VarChar, 100).Value = apellido;
            comando.Parameters.Add("@Cargo", SqlDbType.VarChar, 100).Value = cargo;
            comando.Parameters.Add("@Telefono", SqlDbType.VarChar, 30).Value = telefono;
            comando.Parameters.Add("@Correo", SqlDbType.VarChar, 150).Value = correo;
        }

        // EVENTOS DEL GRIDVIEW
        protected void gvEmpleados_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int idEmpleado = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditarEmpleado")
            {
                CargarEmpleado(idEmpleado);
            }
            else if (e.CommandName == "EliminarEmpleado")
            {
                EliminarEmpleado(idEmpleado);
            }
        }

        // CARGAR EMPLEADO PARA EDITAR
        private void CargarEmpleado(int idEmpleado)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                string consulta = @"
                    SELECT Nombre, Apellido, Cargo, Telefono, Correo
                    FROM Empleados
                    WHERE IdEmpleado = @IdEmpleado";

                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add("@IdEmpleado", SqlDbType.Int).Value = idEmpleado;

                    conexion.Open();

                    using (SqlDataReader lector = comando.ExecuteReader())
                    {
                        if (lector.Read())
                        {
                            hfIdEmpleado.Value = idEmpleado.ToString();

                            txtNombre.Text = lector["Nombre"].ToString();
                            txtApellido.Text = lector["Apellido"].ToString();
                            txtCargo.Text = lector["Cargo"].ToString();
                            txtTelefono.Text = lector["Telefono"].ToString();
                            txtCorreo.Text = lector["Correo"].ToString();

                            btnGuardar.Text = "Actualizar empleado";

                            MostrarMensaje("Editando empleado seleccionado.", "text-primary");
                        }
                    }
                }
            }
        }

        // ELIMINAR EMPLEADO
        private void EliminarEmpleado(int idEmpleado)
        {
            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                string eliminar = @"
                    DELETE FROM Empleados
                    WHERE IdEmpleado = @IdEmpleado
                    AND NOT EXISTS (
                        SELECT 1
                        FROM Pedidos
                        WHERE Pedidos.IdEmpleado = Empleados.IdEmpleado
                    )
                    AND NOT EXISTS (
                        SELECT 1
                        FROM Usuarios
                        WHERE Usuarios.IdEmpleado = Empleados.IdEmpleado
                    )";

                using (SqlCommand comando = new SqlCommand(eliminar, conexion))
                {
                    comando.Parameters.Add("@IdEmpleado", SqlDbType.Int).Value = idEmpleado;

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje("Empleado eliminado correctamente.", "text-success");
                    }
                    else
                    {
                        MostrarMensaje(
                            "No se puede eliminar: el empleado tiene pedidos asignados o un usuario asociado.",
                            "text-danger"
                        );
                    }
                }
            }

            CargarEmpleados();
        }

        // CANCELAR
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            MostrarMensaje("Formulario limpiado.", "text-secondary");
        }

        private void LimpiarFormulario()
        {
            hfIdEmpleado.Value = "";

            txtNombre.Text = "";
            txtApellido.Text = "";
            txtCargo.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";

            btnGuardar.Text = "Guardar empleado";
        }

        // MOSTRAR MENSAJES
        private void MostrarMensaje(string mensaje, string clase)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 fw-semibold " + clase;
        }
    }
}
