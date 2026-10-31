using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace CRUD_negocio
{
    public class Seguridad
    {
        public static void ValidarRol(Page pagina, params string[] rolesPermitidos)
        {
            // Comprobar si inició sesión
            if (pagina.Session["IdUsuario"] == null)
            {
                pagina.Response.Redirect("~/Login.aspx");
                return;
            }

            // Obtener el rol del usuario
            string rol = pagina.Session["Rol"].ToString();

            // Verificar los permisos
            bool autorizado = false;

            foreach (string rolPermitido in rolesPermitidos)
            {
                if (rol == rolPermitido)
                {
                    autorizado = true;
                    break;
                }
            }

            // Denegar acceso si no tiene permisos
            if (!autorizado)
            {
                pagina.Response.Redirect("~/Default.aspx");
            }
        }
    }
}