using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class _Default : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IdUsuario"] != null)
            {
                MenuVisitante.Visible = false;
                MenuUsuario.Visible = true;

                lblNombreUsuario.Text = Session["Usuario"].ToString();
            }
            else
            {
                MenuVisitante.Visible = true;
                MenuUsuario.Visible = false;
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Default.aspx");
        }
        protected void btn_añadir_Click(object sender, EventArgs e)
        {

        }

    }
}