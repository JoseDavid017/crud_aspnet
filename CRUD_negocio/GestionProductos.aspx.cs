
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CRUD_negocio
{
    public partial class GestionProductos : Page
    {
        private string CadenaConexion
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["JaSolution"].ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Seguridad.ValidarRol(
                this,
                "~/AccesoDenegado.aspx",
                "Administrador"
            );

            if (!IsPostBack)
            {
                CargarProductos();
            }
        }

        // CONSULTAR PRODUCTOS
        private void CargarProductos()
        {
            using (SqlConnection conexion =
                new SqlConnection(CadenaConexion))
            {
                string consulta = @"
                    SELECT IdProducto, Nombre, Categoria,
                           Descripcion, Precio, Stock
                    FROM Productos
                    ORDER BY IdProducto DESC";

                using (SqlDataAdapter adaptador =
                    new SqlDataAdapter(consulta, conexion))
                {
                    DataTable tabla = new DataTable();
                    adaptador.Fill(tabla);

                    gvProductos.DataSource = tabla;
                    gvProductos.DataBind();
                }
            }
        }

        // REGISTRAR O ACTUALIZAR PRODUCTO
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string categoria = txtCategoria.Text.Trim();
            string descripcion = txtDescripcion.Text.Trim();

            decimal precio;
            int stock;

            if (nombre == "" || categoria == "")
            {
                MostrarMensaje(
                    "El nombre y la categoría son obligatorios.",
                    "danger"
                );
                return;
            }

            // TextMode Number envía el decimal con punto.
            if (!decimal.TryParse(
                txtPrecio.Text.Trim(),
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out precio) || precio <= 0)
            {
                MostrarMensaje(
                    "Ingresa un precio válido mayor que cero.",
                    "danger"
                );
                return;
            }

            if (!int.TryParse(txtStock.Text.Trim(), out stock) ||
                stock < 0)
            {
                MostrarMensaje(
                    "Ingresa una cantidad de stock válida.",
                    "danger"
                );
                return;
            }

            using (SqlConnection conexion =
                new SqlConnection(CadenaConexion))
            {
                conexion.Open();

                string consulta;

                if (string.IsNullOrEmpty(hfIdProducto.Value))
                {
                    consulta = @"
                        INSERT INTO Productos
                        (Nombre, Categoria, Descripcion, Precio, Stock)
                        VALUES
                        (@Nombre, @Categoria, @Descripcion, @Precio, @Stock)";
                }
                else
                {
                    consulta = @"
                        UPDATE Productos
                        SET Nombre = @Nombre,
                            Categoria = @Categoria,
                            Descripcion = @Descripcion,
                            Precio = @Precio,
                            Stock = @Stock
                        WHERE IdProducto = @IdProducto";
                }

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add(
                        "@Nombre", SqlDbType.VarChar, 100
                    ).Value = nombre;

                    comando.Parameters.Add(
                        "@Categoria", SqlDbType.VarChar, 50
                    ).Value = categoria;

                    comando.Parameters.Add(
                        "@Descripcion", SqlDbType.VarChar, 500
                    ).Value = descripcion;

                    SqlParameter parametroPrecio =
                        comando.Parameters.Add("@Precio", SqlDbType.Decimal);

                    parametroPrecio.Precision = 18;
                    parametroPrecio.Scale = 2;
                    parametroPrecio.Value = precio;

                    comando.Parameters.Add(
                        "@Stock", SqlDbType.Int
                    ).Value = stock;

                    if (!string.IsNullOrEmpty(hfIdProducto.Value))
                    {
                        comando.Parameters.Add(
                            "@IdProducto", SqlDbType.Int
                        ).Value = Convert.ToInt32(hfIdProducto.Value);
                    }

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje(
                            string.IsNullOrEmpty(hfIdProducto.Value)
                                ? "Producto registrado correctamente."
                                : "Producto actualizado correctamente.",
                            "success"
                        );

                        LimpiarFormulario();
                        CargarProductos();
                    }
                    else
                    {
                        MostrarMensaje(
                            "No se encontró el producto que deseas actualizar.",
                            "warning"
                        );
                    }
                }
            }
        }

        // PROCESAR BOTONES DEL GRIDVIEW
        protected void gvProductos_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int idProducto = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditarProducto")
            {
                CargarProducto(idProducto);
            }
            else if (e.CommandName == "EliminarProducto")
            {
                EliminarProducto(idProducto);
            }
        }

        // CARGAR DATOS EN EL FORMULARIO PARA EDITAR
        private void CargarProducto(int idProducto)
        {
            using (SqlConnection conexion =
                new SqlConnection(CadenaConexion))
            {
                string consulta = @"
                    SELECT IdProducto, Nombre, Categoria,
                           Descripcion, Precio, Stock
                    FROM Productos
                    WHERE IdProducto = @IdProducto";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add(
                        "@IdProducto", SqlDbType.Int
                    ).Value = idProducto;

                    conexion.Open();

                    using (SqlDataReader lector = comando.ExecuteReader())
                    {
                        if (lector.Read())
                        {
                            hfIdProducto.Value =
                                lector["IdProducto"].ToString();

                            txtNombre.Text =
                                lector["Nombre"].ToString();

                            txtCategoria.Text =
                                lector["Categoria"].ToString();

                            txtDescripcion.Text =
                                lector["Descripcion"] == DBNull.Value
                                ? ""
                                : lector["Descripcion"].ToString();

                            txtPrecio.Text =
                                Convert.ToDecimal(lector["Precio"])
                                .ToString(CultureInfo.InvariantCulture);

                            txtStock.Text =
                                lector["Stock"].ToString();

                            lblTituloFormulario.Text =
                                "Editar producto";

                            btnGuardar.Text = "Guardar cambios";
                            btnCancelar.Visible = true;
                        }
                    }
                }
            }
        }

        // ELIMINAR PRODUCTO
        private void EliminarProducto(int idProducto)
        {
            using (SqlConnection conexion =
                new SqlConnection(CadenaConexion))
            {
                string consulta = @"
                    DELETE FROM Productos
                    WHERE IdProducto = @IdProducto
                    AND NOT EXISTS (
                        SELECT 1
                        FROM DetallePedido
                        WHERE DetallePedido.IdProducto =
                              Productos.IdProducto
                    )";

                using (SqlCommand comando =
                    new SqlCommand(consulta, conexion))
                {
                    comando.Parameters.Add(
                        "@IdProducto", SqlDbType.Int
                    ).Value = idProducto;

                    conexion.Open();

                    int filas = comando.ExecuteNonQuery();

                    if (filas > 0)
                    {
                        MostrarMensaje(
                            "Producto eliminado correctamente.",
                            "success"
                        );
                    }
                    else
                    {
                        MostrarMensaje(
                            "No se puede eliminar este producto porque " +
                            "no existe o está asociado a pedidos anteriores. " +
                            "Puedes establecer su stock en cero.",
                            "warning"
                        );
                    }
                }
            }

            CargarProductos();
        }

        // CANCELAR EDICIÓN
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void LimpiarFormulario()
        {
            hfIdProducto.Value = "";
            txtNombre.Text = "";
            txtCategoria.Text = "";
            txtDescripcion.Text = "";
            txtPrecio.Text = "";
            txtStock.Text = "";

            lblTituloFormulario.Text = "Registrar producto";
            btnGuardar.Text = "Registrar producto";
            btnCancelar.Visible = false;
        }

        // MOSTRAR MENSAJES
        private void MostrarMensaje(string mensaje, string tipo)
        {
            lblMensaje.Text = Server.HtmlEncode(mensaje);
            lblMensaje.CssClass = "alert alert-" + tipo + " d-block";
            lblMensaje.Visible = true;
        }
    }
}
