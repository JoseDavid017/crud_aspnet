
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CRUD_negocio
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_ingresar_Click(object sender, EventArgs e)
        {
            // 1. Validar el formulario
            if (!Page.IsValid)
            {
                return;
            }

            // 2. Obtener los datos
            string usuario = txt_usuario.Text.Trim();
            string contrasena = txt_contrasena.Text;

            // 3. Obtener la conexión
            string cadena = ConfigurationManager
                .ConnectionStrings["JaSolution"]
                .ConnectionString;

            using (SqlConnection conexion = new SqlConnection(cadena))
            {
                try
                {
                    conexion.Open();

                    // 4. Consultar usuario y contraseña
                    string consulta = @"
                        SELECT IdUsuario, Usuario, Rol, IdCliente, IdEmpleado
                        FROM Usuarios
                        WHERE Usuario = @Usuario
                        AND Contrasena = @Contrasena";

                    using (SqlCommand comando = new SqlCommand(
                        consulta, conexion))
                    {
                        comando.Parameters.AddWithValue(
                            "@Usuario", usuario);

                        comando.Parameters.AddWithValue(
                            "@Contrasena", contrasena);

                        // 5. Ejecutar la consulta
                        using (SqlDataReader lector = comando.ExecuteReader())
                        {
                            if (lector.Read())
                            {
                                // 6. Guardar información en la sesión
                                Session["IdUsuario"] = lector["IdUsuario"];
                                Session["Usuario"] = lector["Usuario"];
                                Session["Rol"] = lector["Rol"];

                                if (lector["IdCliente"] != DBNull.Value)
                                    Session["IdCliente"] = lector["IdCliente"];

                                if (lector["IdEmpleado"] != DBNull.Value)
                                    Session["IdEmpleado"] = lector["IdEmpleado"];

                                
                                // 7. Redireccionar
                                if (Session["Rol"].ToString() == "Administrador")
                                {
                                    Response.Redirect("Admin.aspx");
                                }else if (Session["Rol"].ToString()=="Cliente"){
                                    Response.Redirect("Cliente.aspx");
                                }else if (Session["Rol"].ToString() == "Empleado")
                                {
                                    Response.Redirect("Empleado.aspx");
                                }
                                else
                                {
                                    Response.Redirect("Default.aspx");
                                }
                                
                            }
                            else
                            {
                                MostrarMensaje("Usuario o contraseña incorrectos.");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al iniciar sesión: " + ex.Message);
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
                "mensaje",
                "alert('" + mensajeSeguro + "');",
                true);
        }
    }
}
