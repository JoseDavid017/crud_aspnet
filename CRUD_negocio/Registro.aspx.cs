
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class About : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_registrar_Click(object sender, EventArgs e)
        {
            // Validar los controles del formulario
            if (!Page.IsValid)
            {
                return;
            }

            // Obtener los datos del formulario
            string nombre = txt_nombre.Text.Trim();
            string apellido = txt_apellido.Text.Trim();
            string documento = txt_documento.Text.Trim();
            string telefono = txt_telefono.Text.Trim();
            string correo = txt_correo.Text.Trim();
            string usuario = txt_usuario.Text.Trim();
            string contrasena = txt_contrasena.Text;
            string confirmar = txt_confirmar.Text;

            // Validar longitud mínima de contraseña
            if (contrasena.Length < 8)
            {
                MostrarMensaje("La contraseña debe tener mínimo 8 caracteres.");
                return;
            }

            if (contrasena != confirmar)
            {
                MostrarMensaje("Las contraseñas no coinciden.");
                return;
            }

            // Obtener cadena de conexión
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"]
                .ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                conexion.Open();

                using (SqlTransaction transaccion = conexion.BeginTransaction())
                {
                    try
                    {
                        // Comprobar si el documento o usuario ya existen
                        string consulta = @"
                            SELECT
                                CASE
                                    WHEN EXISTS (
                                        SELECT 1 FROM Clientes
                                        WHERE Documento = @Documento
                                    ) THEN 1 ELSE 0
                                END
                                +
                                CASE
                                    WHEN EXISTS (
                                        SELECT 1 FROM Usuarios
                                        WHERE Usuario = @Usuario
                                    ) THEN 2 ELSE 0
                                END";

                        int resultado;

                        using (SqlCommand comando = new SqlCommand(
                            consulta, conexion, transaccion))
                        {
                            comando.Parameters.Add("@Documento",
                                SqlDbType.VarChar, 10).Value = documento;

                            comando.Parameters.Add("@Usuario",
                                SqlDbType.VarChar, 16).Value = usuario;

                            resultado = Convert.ToInt32(comando.ExecuteScalar());
                        }

                        if (resultado != 0)
                        {
                            transaccion.Rollback();

                            if (resultado == 1)
                                MostrarMensaje("El documento ya está registrado.");
                            else if (resultado == 2)
                                MostrarMensaje("El nombre de usuario ya existe.");
                            else
                                MostrarMensaje("El documento y el usuario ya existen.");

                            return;
                        }

                        // 1. Insertar el cliente
                        string insertarCliente = @"
                            INSERT INTO Clientes
                            (Nombre, Apellido, Documento, Telefono, Correo)
                            VALUES
                            (@Nombre, @Apellido, @Documento, @Telefono, @Correo);

                            SELECT CAST(SCOPE_IDENTITY() AS INT);";

                        int idCliente;

                        using (SqlCommand comando = new SqlCommand(
                            insertarCliente, conexion, transaccion))
                        {
                            comando.Parameters.Add("@Nombre",
                                SqlDbType.VarChar, 24).Value = nombre;

                            comando.Parameters.Add("@Apellido",
                                SqlDbType.VarChar, 24).Value = apellido;

                            comando.Parameters.Add("@Documento",
                                SqlDbType.VarChar, 10).Value = documento;

                            comando.Parameters.Add("@Telefono",
                                SqlDbType.VarChar, 10).Value = telefono;

                            comando.Parameters.Add("@Correo",
                                SqlDbType.VarChar, 32).Value = correo;

                            idCliente = Convert.ToInt32(
                                comando.ExecuteScalar());
                        }
                        // 3. Insertar el usuario
                        string insertarUsuario = @"
                            INSERT INTO Usuarios
                            (Usuario, Contrasena, Rol, IdCliente)
                            VALUES
                            (@Usuario, @Contrasena, @Rol, @IdCliente)";

                        using (SqlCommand comando = new SqlCommand(
                            insertarUsuario, conexion, transaccion))
                        {
                            comando.Parameters.Add("@Usuario",
                                SqlDbType.VarChar, 16).Value = usuario;

                            comando.Parameters.Add("@Contrasena",
                                SqlDbType.VarChar, 255).Value = contrasena;

                            comando.Parameters.Add("@Rol",
                                SqlDbType.VarChar, 16).Value = "Cliente";

                            comando.Parameters.Add("@IdCliente",
                                SqlDbType.Int).Value = idCliente;

                            comando.ExecuteNonQuery();
                        }

                        // Confirmar las dos inserciones
                        transaccion.Commit();

                        MostrarMensaje("¡Registro exitoso! Ya puedes iniciar sesión.");

                        LimpiarFormulario();
                    }
                    catch (SqlException ex)
                    {
                        transaccion.Rollback();

                        if (ex.Number == 2601 || ex.Number == 2627)
                        {
                            MostrarMensaje("El documento o usuario ya se encuentra registrado.");
                        }
                        else
                        {
                            MostrarMensaje("Error al guardar los datos: " + ex.Message);
                        }
                    }
                    catch (Exception ex)
                    {
                        transaccion.Rollback();
                        MostrarMensaje("Ocurrió un error: " + ex.Message);
                    }
                }
            }
            Response.Redirect("Login.aspx");
        }


        // Mostrar mensajes al usuario
        private void MostrarMensaje(string mensaje)
        {
            string mensajeSeguro = mensaje.Replace("\\", "\\\\")
                                          .Replace("'", "\\'")
                                          .Replace("\r", "")
                                          .Replace("\n", "");

            ClientScript.RegisterStartupScript(
                this.GetType(),
                "mensaje",
                "alert('" + mensajeSeguro + "');",
                true);
        }

        // Limpiar campos del formulario
        private void LimpiarFormulario()
        {
            txt_nombre.Text = "";
            txt_apellido.Text = "";
            txt_documento.Text = "";
            txt_telefono.Text = "";
            txt_correo.Text = "";
            txt_usuario.Text = "";
            txt_contrasena.Text = "";
            txt_confirmar.Text = "";
        }
    }
}
