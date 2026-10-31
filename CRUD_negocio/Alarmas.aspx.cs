
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CRUD_negocio
{
    public partial class ALARMAS : System.Web.UI.Page
    {
        string conexion = ConfigurationManager
            .ConnectionStrings["JaSolution"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Cliente"
            );
        }

        protected void btnSolicitar_Click(object sender, EventArgs e)
        {
            if (Session["IdCliente"] == null)
            {
                Response.Redirect("~/AccesoDenegado.aspx");
                return;
            }

            string descripcion = txtDescripcion.Text.Trim();
            string direccion = txtDireccion.Text.Trim();

            if (string.IsNullOrWhiteSpace(descripcion) ||
                string.IsNullOrWhiteSpace(direccion))
            {
                MostrarMensaje(
                    "Completa todos los campos.",
                    "alert alert-warning"
                );
                return;
            }

            if (descripcion.Length > 500 || direccion.Length > 200)
            {
                MostrarMensaje(
                    "La descripción admite máximo 500 caracteres y la dirección 200.",
                    "alert alert-warning"
                );
                return;
            }

            int idCliente = Convert.ToInt32(Session["IdCliente"]);

            using (SqlConnection cn = new SqlConnection(conexion))
            {
                string sql = @"
                    INSERT INTO SolicitudesServicio
                    (IdCliente, TipoServicio, Descripcion, Direccion)
                    VALUES
                    (@IdCliente, @TipoServicio, @Descripcion, @Direccion)";

                using (SqlCommand cmd = new SqlCommand(sql, cn))
                {
                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value =
                        idCliente;

                    cmd.Parameters.Add("@TipoServicio", SqlDbType.VarChar, 50).Value =
                        "Sistemas de alarmas";

                    cmd.Parameters.Add("@Descripcion", SqlDbType.VarChar, 500).Value =
                        descripcion;

                    cmd.Parameters.Add("@Direccion", SqlDbType.VarChar, 200).Value =
                        direccion;

                    try
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();

                        txtDescripcion.Text = "";
                        txtDireccion.Text = "";

                        MostrarMensaje(
                            "Tu solicitud de sistemas de alarmas fue registrada correctamente.",
                            "alert alert-success"
                        );
                    }
                    catch (Exception)
                    {
                        MostrarMensaje(
                            "No fue posible registrar tu solicitud. Inténtalo nuevamente.",
                            "alert alert-danger"
                        );
                    }
                }
            }
        }

        private void MostrarMensaje(string mensaje, string clase)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = clase;
            pnlMensaje.Visible = true;
        }
    }
}
